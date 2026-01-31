import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import { Check, X, Loader2, Clock, Filter, CheckCircle } from 'lucide-react';

export default function AdminTimesheets() {
    const [entries, setEntries] = useState([]);
    const [loading, setLoading] = useState(true);
    const [filter, setFilter] = useState('pending'); // pending, approved, rejected, all

    useEffect(() => {
        fetchData();
    }, [filter]);

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

        const { data, error } = await query;
        if (error) console.error(error);

        setEntries(data || []);
        setLoading(false);
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
            <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                <h2 className="text-xl font-bold text-gray-800">Timesheet Approvals</h2>

                <div className="flex bg-gray-100 p-1 rounded-lg">
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
                    ) : (
                        <div className="overflow-x-auto">
                            <table className="w-full text-left text-sm">
                                <thead className="bg-gray-50 text-gray-500 font-medium border-b border-gray-100">
                                    <tr>
                                        <th className="px-6 py-4">Volunteer</th>
                                        <th className="px-6 py-4">Activity / Project</th>
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
