import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import { Check, X, Loader2, Clock, Filter, CheckCircle, FileSpreadsheet, Calendar, Download } from 'lucide-react';
import * as XLSX from 'xlsx';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';

export default function AdminTimesheets() {
    const [entries, setEntries] = useState([]);
    const [projects, setProjects] = useState([]);
    const [loading, setLoading] = useState(true);
    const [filter, setFilter] = useState('pending'); // pending, approved, rejected, all
    const [startDate, setStartDate] = useState('');
    const [endDate, setEndDate] = useState('');
    const [projectFilter, setProjectFilter] = useState('all');

    useEffect(() => {
        fetchData();
        fetchProjects();
    }, [filter, startDate, endDate, projectFilter]);

    const fetchProjects = async () => {
        const { data } = await supabase.from('projects').select('id, title').order('title');
        setProjects(data || []);
    };

    const fetchData = async () => {
        setLoading(true);
        let query = supabase
            .from('timesheets')
            .select(`
                *,
                volunteer:volunteers(first_name, last_name, ilj_id),
                project:projects(title)
            `)
            .order('date_worked', { ascending: false });

        if (filter !== 'all') {
            query = query.eq('status', filter);
        }

        if (startDate) {
            query = query.gte('date_worked', startDate);
        }

        if (endDate) {
            query = query.lte('date_worked', endDate);
        }

        if (projectFilter !== 'all') {
            query = query.eq('project_id', projectFilter);
        }

        const { data, error } = await query;
        if (error) console.error(error);

        setEntries(data || []);
        setLoading(false);
    };

    const getAggregatedData = () => {
        const aggregated = {};
        entries.forEach(entry => {
            const volId = entry.volunteer_id;
            if (!aggregated[volId]) {
                aggregated[volId] = {
                    id: volId,
                    volunteer: entry.volunteer,
                    total_hrs: 0,
                    approved_hrs: 0,
                    pending_hrs: 0
                };
            }
            const hrs = Number(entry.hours) || 0;
            aggregated[volId].total_hrs += hrs;
            if (entry.status === 'approved') {
                aggregated[volId].approved_hrs += hrs;
            } else if (entry.status === 'pending') {
                aggregated[volId].pending_hrs += hrs;
            }
        });
        return Object.values(aggregated).sort((a, b) => b.total_hrs - a.total_hrs);
    };

    const exportToExcel = () => {
        let worksheet;
        if (filter === 'all') {
            const dataToExport = getAggregatedData().map(agg => ({
                "ILJ Code": agg.volunteer?.ilj_id || 'N/A',
                "Name": `${agg.volunteer?.first_name || ''} ${agg.volunteer?.last_name || ''}`.trim(),
                "Total Hrs": agg.total_hrs,
                "Approved Hrs": agg.approved_hrs,
                "Pending Hrs": agg.pending_hrs
            }));
            worksheet = XLSX.utils.json_to_sheet(dataToExport);
        } else {
            const dataToExport = entries.map(t => ({
                Date: new Date(t.date_worked).toLocaleDateString(),
                Volunteer: `${t.volunteer?.first_name} ${t.volunteer?.last_name}`,
                ILJ_ID: t.volunteer?.ilj_id,
                Project: t.project?.title,
                Role: t.role,
                Hours: t.hours,
                Work_Mode: t.work_mode,
                Description: t.description,
                Status: t.status,
                Volunteer_ID: t.volunteer_id,
                Project_ID: t.project_id
            }));
            worksheet = XLSX.utils.json_to_sheet(dataToExport);
        }

        const workbook = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(workbook, worksheet, "Timesheets");
        XLSX.writeFile(workbook, `Admin_Timesheets_${new Date().toLocaleDateString().replace(/\//g, '-')}.xlsx`);
    };

    const exportToPDF = () => {
        const doc = new jsPDF();
        
        // Brand Header
        doc.setFillColor(174, 43, 43); // #ae2b2b crimson
        doc.rect(0, 0, 210, 30, 'F');
        
        doc.setTextColor(255, 255, 255);
        doc.setFont('Helvetica', 'bold');
        doc.setFontSize(20);
        doc.text("I LOVE JINSHASAN", 15, 20);
        
        doc.setFontSize(10);
        doc.setFont('Helvetica', 'normal');
        doc.text("Timesheet Report", 160, 20);
        
        doc.setTextColor(30, 30, 30);
        doc.setFont('Helvetica', 'bold');
        doc.setFontSize(14);
        doc.text(`Timesheet Data - ${filter.toUpperCase()} Entries`, 15, 45);
        
        // Date filters display
        doc.setFont('Helvetica', 'normal');
        doc.setFontSize(10);
        doc.setTextColor(100, 100, 100);
        const formatDateText = (d) => d ? new Date(d).toLocaleDateString('en-GB') : '';
        const dateRangeText = (startDate || endDate) 
            ? `Date Range: ${formatDateText(startDate) || 'Start'} to ${formatDateText(endDate) || 'End'}`
            : "Date Range: All Time";
        const podFilterText = projectFilter !== 'all'
            ? `Pod Filter: ${projects.find(p => p.id === projectFilter)?.title || 'Selected Pod'}`
            : "Pod Filter: All Pods";
        doc.text(`${dateRangeText} | ${podFilterText}`, 15, 52);
        
        doc.setDrawColor(220, 220, 220);
        doc.line(15, 56, 195, 56);

        let tableHeaders = [];
        let tableData = [];

        if (filter === 'all') {
            tableHeaders = [["ILJ Code", "Name", "Total Hours", "Approved Hours", "Pending Hours"]];
            tableData = getAggregatedData().map(agg => [
                agg.volunteer?.ilj_id || 'N/A',
                `${agg.volunteer?.first_name || ''} ${agg.volunteer?.last_name || ''}`.trim() || 'N/A',
                String(agg.total_hrs),
                String(agg.approved_hrs),
                String(agg.pending_hrs)
            ]);
        } else {
            tableHeaders = [["Date", "Volunteer", "ILJ Code", "Pod", "Role", "Hours", "Mode", "Status", "Description"]];
            tableData = entries.map(t => [
                t.date_worked ? new Date(t.date_worked).toLocaleDateString('en-GB') : 'N/A',
                `${t.volunteer?.first_name || ''} ${t.volunteer?.last_name || ''}`.trim() || 'N/A',
                t.volunteer?.ilj_id || 'N/A',
                t.project?.title || 'N/A',
                t.role || 'N/A',
                String(t.hours),
                t.work_mode || 'N/A',
                t.status || 'N/A',
                t.description || 'N/A'
            ]);
        }

        autoTable(doc, {
            startY: 60,
            head: tableHeaders,
            body: tableData,
            theme: 'striped',
            headStyles: { fillColor: [174, 43, 43] },
            styles: { fontSize: 8, cellPadding: 2 },
            columnStyles: filter === 'all' ? {} : {
                0: { cellWidth: 18 }, // Date
                1: { cellWidth: 25 }, // Volunteer
                2: { cellWidth: 18 }, // ILJ Code
                3: { cellWidth: 25 }, // Pod
                4: { cellWidth: 20 }, // Role
                5: { cellWidth: 10 }, // Hours
                6: { cellWidth: 12 }, // Mode
                7: { cellWidth: 15 }, // Status
                8: { cellWidth: 'auto' }  // Description
            },
            margin: { left: 15, right: 15 }
        });

        doc.save(`Admin_Timesheets_${filter}_${new Date().toISOString().slice(0, 10)}.pdf`);
    };

    const updateStatus = async (id, newStatus) => {
        const { error } = await supabase.from('timesheets').update({ status: newStatus }).eq('id', id);
        if (error) {
            alert("Failed to update status");
        } else {
            setEntries(prev => prev.map(e => e.id === id ? { ...e, status: newStatus } : e));
            // Or remove from list if filter is strict
            if (filter !== 'all' && filter !== newStatus) {
                setEntries(prev => prev.filter(e => e.id !== id));
            }
        }
    };

    return (
        <div className="space-y-6">
            <div className="flex flex-col xl:flex-row justify-between items-start xl:items-center gap-4 bg-white p-4 rounded-xl shadow-sm border border-gray-200">
                <div className="flex items-center gap-4 w-full xl:w-auto">
                    <h2 className="text-xl font-bold text-gray-800 whitespace-nowrap">Timesheet Approvals</h2>
                    <button
                        onClick={exportToExcel}
                        className="flex items-center gap-2 px-3 py-1.5 bg-green-50 text-green-700 border border-green-200 rounded-lg hover:bg-green-100 text-xs font-bold transition-colors ml-auto xl:ml-0"
                    >
                        <FileSpreadsheet className="h-3.5 w-3.5" /> Export Excel
                    </button>
                    <button
                        onClick={exportToPDF}
                        className="flex items-center gap-2 px-3 py-1.5 bg-red-50 text-[#ae2b2b] border border-red-200 rounded-lg hover:bg-red-100 text-xs font-bold transition-colors"
                    >
                        <Download className="h-3.5 w-3.5" /> Download PDF
                    </button>
                </div>

                <div className="flex flex-col sm:flex-row gap-3 w-full xl:w-auto overflow-x-auto">
                    {/* Status Filter */}
                    <div className="flex bg-gray-100 p-1 rounded-lg shrink-0">
                        {['pending', 'approved', 'rejected', 'all'].map(f => (
                            <button
                                key={f}
                                onClick={() => setFilter(f)}
                                className={`px-3 py-1.5 text-xs font-bold rounded-md capitalize transition-colors
                                    ${filter === f ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-500 hover:text-gray-700'}
                                `}
                            >
                                {f}
                            </button>
                        ))}
                    </div>

                    {/* Start Date Filter */}
                    <div className="relative shrink-0 flex items-center gap-1.5">
                        <span className="text-[10px] uppercase font-bold text-gray-500">From</span>
                        <div className="relative">
                            <Calendar className="absolute left-2.5 top-1/2 -translate-y-1/2 h-3.5 w-3.5 text-gray-400" />
                            <input
                                type="date"
                                className="pl-8 pr-3 py-1.5 bg-white border border-gray-200 rounded-lg text-xs font-medium focus:ring-2 focus:ring-[#ae2b2b] outline-none"
                                value={startDate}
                                onChange={(e) => setStartDate(e.target.value)}
                            />
                        </div>
                    </div>

                    {/* End Date Filter */}
                    <div className="relative shrink-0 flex items-center gap-1.5">
                        <span className="text-[10px] uppercase font-bold text-gray-500">To</span>
                        <div className="relative">
                            <Calendar className="absolute left-2.5 top-1/2 -translate-y-1/2 h-3.5 w-3.5 text-gray-400" />
                            <input
                                type="date"
                                className="pl-8 pr-3 py-1.5 bg-white border border-gray-200 rounded-lg text-xs font-medium focus:ring-2 focus:ring-[#ae2b2b] outline-none"
                                value={endDate}
                                onChange={(e) => setEndDate(e.target.value)}
                            />
                        </div>
                    </div>

                    {/* Project Filter */}
                    <div className="shrink-0">
                        <select
                            className="px-3 py-1.5 bg-white border border-gray-200 rounded-lg text-xs font-medium focus:ring-2 focus:ring-[#ae2b2b] outline-none max-w-[200px]"
                            value={projectFilter}
                            onChange={(e) => setProjectFilter(e.target.value)}
                        >
                            <option value="all">All Pods</option>
                            {projects.map(p => (
                                <option key={p.id} value={p.id}>{p.title}</option>
                            ))}
                        </select>
                    </div>
                </div>
            </div>

            {loading ? (
                <div className="flex justify-center p-12"><Loader2 className="h-8 w-8 animate-spin text-[#ae2b2b]" /></div>
            ) : (
                <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                    {entries.length === 0 ? (
                        <div className="text-center py-12">
                            <Clock className="h-12 w-12 text-gray-300 mx-auto mb-3" />
                            <p className="text-gray-500">No entries found for this filter.</p>
                        </div>
                    ) : filter === 'all' ? (
                        <div className="overflow-x-auto">
                            <table className="w-full text-left text-sm">
                                <thead className="bg-gray-50 text-gray-500 font-medium border-b border-gray-100">
                                    <tr>
                                        <th className="px-6 py-4">ILJ Code</th>
                                        <th className="px-6 py-4">Name</th>
                                        <th className="px-6 py-4">Total Hrs</th>
                                        <th className="px-6 py-4">Approved Hrs</th>
                                        <th className="px-6 py-4">Pending Hrs</th>
                                    </tr>
                                </thead>
                                <tbody className="divide-y divide-gray-100">
                                    {getAggregatedData().map(agg => (
                                        <tr key={agg.id} className="hover:bg-gray-50 transition-colors">
                                            <td className="px-6 py-4 text-gray-500 font-mono text-xs">
                                                {agg.volunteer?.ilj_id || 'N/A'}
                                            </td>
                                            <td className="px-6 py-4 font-bold text-gray-900">
                                                {agg.volunteer?.first_name} {agg.volunteer?.last_name}
                                            </td>
                                            <td className="px-6 py-4 font-bold text-[#ae2b2b]">
                                                {agg.total_hrs}
                                            </td>
                                            <td className="px-6 py-4 text-green-600 font-medium">
                                                {agg.approved_hrs}
                                            </td>
                                            <td className="px-6 py-4 text-amber-600 font-medium">
                                                {agg.pending_hrs}
                                            </td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    ) : (
                        <div className="overflow-x-auto">
                            <table className="w-full text-left text-sm">
                                <thead className="bg-gray-50 text-gray-500 font-medium border-b border-gray-100">
                                    <tr>
                                        <th className="px-6 py-4">Volunteer</th>
                                        <th className="px-6 py-4">Activity / Pod</th>
                                        <th className="px-6 py-4">Date & Hours</th>
                                        <th className="px-6 py-4">Description</th>
                                        <th className="px-6 py-4 text-right">Actions</th>
                                    </tr>
                                </thead>
                                <tbody className="divide-y divide-gray-100">
                                    {entries.map(entry => (
                                        <tr key={entry.id} className="hover:bg-gray-50 transition-colors">
                                            <td className="px-6 py-4">
                                                <p className="font-bold text-gray-900">
                                                    {entry.volunteer?.first_name} {entry.volunteer?.last_name}
                                                </p>
                                                <p className="text-xs text-gray-500">{entry.volunteer?.ilj_id}</p>
                                            </td>
                                            <td className="px-6 py-4">
                                                <p className="text-gray-900 font-medium">{entry.role}</p>
                                                <p className="text-xs text-gray-500">{entry.project?.title || 'General'}</p>
                                            </td>
                                            <td className="px-6 py-4">
                                                <div className="flex items-center gap-4">
                                                    <div>
                                                        <p className="text-gray-900">{new Date(entry.date_worked).toLocaleDateString()}</p>
                                                        <p className="text-xs text-gray-500">{entry.work_mode}</p>
                                                    </div>
                                                    <span className="bg-[#ae2b2b]/10 text-[#ae2b2b] px-2 py-1 rounded font-bold text-xs">
                                                        {entry.hours} hrs
                                                    </span>
                                                </div>
                                            </td>
                                            <td className="px-6 py-4 max-w-xs truncate text-gray-600" title={entry.description}>
                                                {entry.description}
                                            </td>
                                            <td className="px-6 py-4 text-right">
                                                {entry.status === 'pending' ? (
                                                    <div className="flex justify-end gap-2">
                                                        <button
                                                            onClick={() => updateStatus(entry.id, 'rejected')}
                                                            className="p-1.5 text-red-600 hover:bg-red-50 rounded bg-white border border-gray-200" title="Reject"
                                                        >
                                                            <X className="h-4 w-4" />
                                                        </button>
                                                        <button
                                                            onClick={() => updateStatus(entry.id, 'approved')}
                                                            className="p-1.5 text-green-600 hover:bg-green-50 rounded bg-white border border-gray-200" title="Approve"
                                                        >
                                                            <Check className="h-4 w-4" />
                                                        </button>
                                                    </div>
                                                ) : (
                                                    <span className={`px-2 py-1 rounded text-xs font-bold uppercase
                                                        ${entry.status === 'approved' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}
                                                    `}>
                                                        {entry.status}
                                                    </span>
                                                )}
                                            </td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    )}
                </div>
            )}
        </div>
    );
}
