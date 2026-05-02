import React, { useState, useEffect, useMemo } from 'react';
import { supabase } from '@/lib/supabase';
import { 
    Search, Users, Download, Filter, 
    FileText, CheckCircle, Clock, XCircle,
    MapPin, Mail, Phone, MessageSquare
} from 'lucide-react';

const MasterSheet = () => {
    const [volunteers, setVolunteers] = useState([]);
    const [projects, setProjects] = useState([]);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');
    const [filterStatus, setFilterStatus] = useState('All');
    const [filterDesignation, setFilterDesignation] = useState('All');
    const [filterLocation, setFilterLocation] = useState('All');
    const [filterMode, setFilterMode] = useState('All');
    const [filterKalyanMitra, setFilterKalyanMitra] = useState('All');
    const [activeTab, setActiveTab] = useState('Master');
    const [selectedVolunteer, setSelectedVolunteer] = useState(null);

    useEffect(() => {
        fetchData();
    }, []);

    const fetchData = async () => {
        try {
            setLoading(true);
            const [projRes, volRes] = await Promise.all([
                supabase.from('projects').select('id, title').order('title'),
                supabase.from('volunteers').select('*').order('created_at', { ascending: false })
            ]);

            if (projRes.data) setProjects(projRes.data);
            if (volRes.error) throw volRes.error;
            
            setVolunteers(volRes.data || []);
        } catch (error) {
            console.error('Error fetching master sheet data:', error);
        } finally {
            setLoading(false);
        }
    };

    const determineNewOrExisting = (createdAt) => {
        const thirtyDaysAgo = new Date();
        thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
        const joinedDate = new Date(createdAt);
        return joinedDate > thirtyDaysAgo ? 'New' : 'Existing';
    };

    const getStatusBadge = (status) => {
        switch (status) {
            case 'onboarded':
                return <span className="px-2 py-1 bg-green-100 text-green-700 rounded text-xs font-semibold">Onboarded</span>;
            case 'pending_onboarding':
                return <span className="px-2 py-1 bg-blue-100 text-blue-700 rounded text-xs font-semibold">In Queue</span>;
            case 'duplicate':
                return <span className="px-2 py-1 bg-red-100 text-red-700 rounded text-xs font-semibold">Duplicate</span>;
            case 'pending_it':
            case 'pending':
            default:
                return <span className="px-2 py-1 bg-amber-100 text-amber-700 rounded text-xs font-semibold">Pending Verification</span>;
        }
    };

    const uniqueDesignations = useMemo(() => [...new Set(volunteers.map(v => v.designation).filter(Boolean))], [volunteers]);
    const uniqueLocations = useMemo(() => [...new Set(volunteers.map(v => v.city ? `${v.city}, ${v.state}` : null).filter(Boolean))], [volunteers]);
    const uniqueModes = useMemo(() => [...new Set(volunteers.map(v => v.participation_mode).filter(Boolean))], [volunteers]);
    const uniqueKalyanMitras = useMemo(() => [...new Set(volunteers.map(v => v.kalyan_mitra).filter(Boolean))], [volunteers]);

    const filteredVolunteers = useMemo(() => {
        return volunteers.filter(volunteer => {
            const matchesSearch = searchTerm === '' || 
                (volunteer.first_name || '').toLowerCase().includes(searchTerm.toLowerCase()) ||
                (volunteer.last_name || '').toLowerCase().includes(searchTerm.toLowerCase()) ||
                (volunteer.email || '').toLowerCase().includes(searchTerm.toLowerCase()) ||
                (volunteer.ilj_id || '').toLowerCase().includes(searchTerm.toLowerCase());
                
            const matchesStatus = filterStatus === 'All' || 
                (filterStatus === 'Onboarded' && volunteer.onboarding_status === 'onboarded') ||
                (filterStatus === 'Pending' && volunteer.onboarding_status !== 'onboarded' && volunteer.onboarding_status !== 'duplicate');

            const matchesDesignation = filterDesignation === 'All' || volunteer.designation === filterDesignation;
            const matchesLocation = filterLocation === 'All' || (volunteer.city && `${volunteer.city}, ${volunteer.state}` === filterLocation);
            const matchesMode = filterMode === 'All' || volunteer.participation_mode === filterMode;
            const matchesKalyanMitra = filterKalyanMitra === 'All' || volunteer.kalyan_mitra === filterKalyanMitra;

            let matchesTab = true;
            if (activeTab !== 'Master') {
                const activeProject = projects.find(p => p.id === activeTab);
                if (activeProject) {
                    matchesTab = volunteer.assigned_pod && volunteer.assigned_pod.includes(activeProject.title);
                }
            }

            return matchesSearch && matchesStatus && matchesDesignation && matchesLocation && matchesMode && matchesKalyanMitra && matchesTab;
        });
    }, [volunteers, searchTerm, filterStatus, filterDesignation, filterLocation, filterMode, filterKalyanMitra, activeTab, projects]);

    const exportToCSV = () => {
        const headers = ["Volunteer ID", "Name", "Email", "Phone", "New/Existing", "Preferred Pod", "Assigned Pod", "Onboarding Status", "Activity Status"];
        const rows = filteredVolunteers.map(v => [
            v.ilj_id || '',
            `${v.first_name} ${v.last_name}`.trim(),
            v.email,
            v.mobile_number,
            determineNewOrExisting(v.created_at),
            v.volunteering_preference1 || '',
            v.assigned_pod || '',
            v.onboarding_status || 'pending',
            v.activity_status || 'Active'
        ]);

        const csvContent = [
            headers.join(','),
            ...rows.map(e => e.map(item => `"${(item || '').replace(/"/g, '""')}"`).join(','))
        ].join('\n');

        const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
        const link = document.createElement("a");
        const url = URL.createObjectURL(blob);
        link.setAttribute("href", url);
        link.setAttribute("download", `Master_Sheet_${new Date().toISOString().split('T')[0]}.csv`);
        link.style.visibility = 'hidden';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    };

    if (loading) {
        return (
            <div className="flex justify-center items-center h-full min-h-[400px]">
                <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-indigo-600"></div>
            </div>
        );
    }

    return (
        <div className="space-y-6">
            <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                <div>
                    <h1 className="text-2xl font-bold text-gray-900 flex items-center gap-2">
                        <Users className="h-6 w-6 text-indigo-600" />
                        Master Sheet
                    </h1>
                    <p className="text-gray-500 mt-1">Complete overview of all registered volunteers across the organization.</p>
                </div>
                <button
                    onClick={exportToCSV}
                    className="flex items-center gap-2 bg-indigo-50 text-indigo-600 hover:bg-indigo-100 border border-indigo-200 px-4 py-2 rounded-lg font-medium transition-colors"
                >
                    <Download className="h-4 w-4" /> Export CSV
                </button>
            </div>

            {/* Pod Tabs */}
            <div className="flex overflow-x-auto gap-1 border-b border-gray-200 custom-scrollbar">
                <button
                    onClick={() => setActiveTab('Master')}
                    className={`whitespace-nowrap px-5 py-2.5 font-medium transition-all border-b-2 ${
                        activeTab === 'Master' 
                            ? 'text-indigo-600 border-indigo-600 bg-indigo-50/50' 
                            : 'text-gray-500 border-transparent hover:text-gray-700 hover:bg-gray-50'
                    }`}
                >
                    Master Sheet (All)
                </button>
                {projects.map(project => (
                    <button
                        key={project.id}
                        onClick={() => setActiveTab(project.id)}
                        className={`whitespace-nowrap px-5 py-2.5 font-medium transition-all border-b-2 ${
                            activeTab === project.id 
                                ? 'text-indigo-600 border-indigo-600 bg-indigo-50/50' 
                                : 'text-gray-500 border-transparent hover:text-gray-700 hover:bg-gray-50'
                        }`}
                    >
                        {project.title}
                    </button>
                ))}
            </div>

            <div className="bg-white rounded-xl shadow-sm border border-gray-200">
                <div className="p-4 border-b border-gray-200 bg-gray-50/50 rounded-t-xl space-y-4">
                    <div className="flex flex-col md:flex-row gap-4 justify-between items-start md:items-center">
                        <div className="relative w-full md:w-96 shrink-0">
                            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
                            <input
                                type="text"
                                placeholder="Search by name, email, or ID..."
                                className="w-full pl-9 pr-4 py-2 bg-white border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-400 text-sm shadow-sm"
                                value={searchTerm}
                                onChange={(e) => setSearchTerm(e.target.value)}
                            />
                        </div>
                        
                        <div className="flex flex-wrap items-center gap-2 w-full justify-end">
                            <Filter className="h-4 w-4 text-gray-400 mr-1 hidden sm:block" />
                            <select
                                className="bg-white border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400 font-medium text-gray-700 shadow-sm"
                                value={filterStatus}
                                onChange={(e) => setFilterStatus(e.target.value)}
                            >
                                <option value="All">All Statuses</option>
                                <option value="Onboarded">Onboarded</option>
                                <option value="Pending">Pending / Queue</option>
                            </select>
                            
                            <select
                                className="bg-white border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400 font-medium text-gray-700 shadow-sm max-w-[150px]"
                                value={filterDesignation}
                                onChange={(e) => setFilterDesignation(e.target.value)}
                            >
                                <option value="All">All Designations</option>
                                {uniqueDesignations.map(d => <option key={d} value={d}>{d}</option>)}
                            </select>

                            <select
                                className="bg-white border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400 font-medium text-gray-700 shadow-sm max-w-[150px]"
                                value={filterLocation}
                                onChange={(e) => setFilterLocation(e.target.value)}
                            >
                                <option value="All">All Locations</option>
                                {uniqueLocations.map(l => <option key={l} value={l}>{l}</option>)}
                            </select>

                            <select
                                className="bg-white border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400 font-medium text-gray-700 shadow-sm max-w-[150px]"
                                value={filterMode}
                                onChange={(e) => setFilterMode(e.target.value)}
                            >
                                <option value="All">All Modes</option>
                                {uniqueModes.map(m => <option key={m} value={m}>{m}</option>)}
                            </select>

                            <select
                                className="bg-white border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400 font-medium text-gray-700 shadow-sm max-w-[150px]"
                                value={filterKalyanMitra}
                                onChange={(e) => setFilterKalyanMitra(e.target.value)}
                            >
                                <option value="All">All Kalyan Mitras</option>
                                {uniqueKalyanMitras.map(k => <option key={k} value={k}>{k}</option>)}
                            </select>
                            
                            {(filterStatus !== 'All' || filterDesignation !== 'All' || filterLocation !== 'All' || filterMode !== 'All' || filterKalyanMitra !== 'All') && (
                                <button 
                                    onClick={() => {
                                        setFilterStatus('All');
                                        setFilterDesignation('All');
                                        setFilterLocation('All');
                                        setFilterMode('All');
                                        setFilterKalyanMitra('All');
                                    }}
                                    className="text-xs text-red-600 hover:text-red-800 font-medium px-2 py-1 transition-colors"
                                >
                                    Clear
                                </button>
                            )}
                        </div>
                    </div>
                </div>

                <div className="overflow-x-auto">
                    <table className="w-full text-left text-sm whitespace-nowrap">
                        <thead className="bg-gray-50 border-b border-gray-200 text-gray-600">
                            <tr>
                                <th className="px-6 py-4 font-semibold rounded-tl-lg">Volunteer ID</th>
                                <th className="px-6 py-4 font-semibold">Name</th>
                                <th className="px-6 py-4 font-semibold">Email</th>
                                <th className="px-6 py-4 font-semibold">Phone</th>
                                <th className="px-6 py-4 font-semibold">New/Existing</th>
                                <th className="px-6 py-4 font-semibold">Preferred Pod</th>
                                <th className="px-6 py-4 font-semibold">Assigned Pod</th>
                                <th className="px-6 py-4 font-semibold">Onboarding Status</th>
                                <th className="px-6 py-4 font-semibold">Activity Status</th>
                            </tr>
                        </thead>
                        <tbody className="divide-y divide-gray-100 bg-white">
                            {filteredVolunteers.length > 0 ? (
                                filteredVolunteers.map(volunteer => {
                                    const newOrExisting = determineNewOrExisting(volunteer.created_at);
                                    return (
                                        <tr 
                                            key={volunteer.id} 
                                            className="hover:bg-indigo-50/50 transition-colors cursor-pointer"
                                            onClick={() => setSelectedVolunteer(volunteer)}
                                        >
                                            <td className="px-6 py-4 font-mono text-gray-600 text-xs">
                                                {volunteer.ilj_id || 'N/A'}
                                            </td>
                                            <td className="px-6 py-4">
                                                <p className="font-semibold text-gray-900">{volunteer.first_name} {volunteer.last_name}</p>
                                            </td>
                                            <td className="px-6 py-4 text-gray-600 max-w-[200px] truncate" title={volunteer.email}>
                                                {volunteer.email}
                                            </td>
                                            <td className="px-6 py-4 text-gray-600">
                                                {volunteer.mobile_number || 'N/A'}
                                            </td>
                                            <td className="px-6 py-4">
                                                <span className={`px-2.5 py-1 rounded text-xs font-bold border shadow-sm ${
                                                    newOrExisting === 'New' ? 'bg-purple-100 text-purple-700 border-purple-200' : 'bg-gray-100 text-gray-700 border-gray-200'
                                                }`}>
                                                    {newOrExisting}
                                                </span>
                                            </td>
                                            <td className="px-6 py-4 text-gray-600 max-w-[150px] truncate" title={volunteer.volunteering_preference1}>
                                                {volunteer.volunteering_preference1 || '-'}
                                            </td>
                                            <td className="px-6 py-4">
                                                {volunteer.assigned_pod ? (
                                                    <span className="font-medium text-indigo-700">{volunteer.assigned_pod}</span>
                                                ) : <span className="text-gray-400 italic">Not Assigned</span>}
                                            </td>
                                            <td className="px-6 py-4">
                                                {getStatusBadge(volunteer.onboarding_status)}
                                            </td>
                                            <td className="px-6 py-4">
                                                 <span className={`px-2.5 py-1 rounded text-[11px] uppercase font-bold border shadow-sm ${
                                                    (volunteer.activity_status || 'Active') === 'Active' 
                                                        ? 'bg-green-100 text-green-700 border-green-200' 
                                                        : 'bg-gray-100 text-gray-700 border-gray-200'
                                                }`}>
                                                    {(volunteer.activity_status || 'Active')}
                                                </span>
                                            </td>
                                        </tr>
                                    );
                                })
                            ) : (
                                <tr>
                                    <td colSpan="9" className="px-6 py-12 text-center text-gray-500">
                                        <FileText className="h-10 w-10 text-gray-300 mx-auto mb-3" />
                                        <p className="font-medium text-gray-900">No records found</p>
                                        <p className="text-sm">Try adjusting your search or filters.</p>
                                    </td>
                                </tr>
                            )}
                        </tbody>
                    </table>
                </div>
                <div className="p-4 border-t border-gray-100 bg-gray-50 text-xs text-gray-500 flex justify-between rounded-b-xl">
                    <span>Showing {filteredVolunteers.length} volunteer(s)</span>
                    <span>Master Sheet • Auto-syncing from DB</span>
                </div>
            </div>

            {/* Volunteer Details Modal */}
            {selectedVolunteer && (
                <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm" onClick={() => setSelectedVolunteer(null)}>
                    <div className="bg-white w-full max-w-4xl rounded-2xl shadow-2xl animate-in fade-in zoom-in-95 overflow-hidden flex flex-col max-h-[90vh]" onClick={e => e.stopPropagation()}>
                        <div className="bg-gradient-to-r from-indigo-50 to-blue-50 border-b border-indigo-100 p-6 flex justify-between items-start shrink-0">
                            <div className="flex items-center gap-4">
                                <div className="w-14 h-14 rounded-full bg-indigo-600 text-white font-bold text-xl flex items-center justify-center shadow-md">
                                    {selectedVolunteer.first_name?.[0]}{selectedVolunteer.last_name?.[0]}
                                </div>
                                <div>
                                    <h2 className="text-2xl font-bold text-gray-900">{selectedVolunteer.first_name} {selectedVolunteer.last_name}</h2>
                                    <p className="text-sm font-medium text-indigo-700 font-mono mt-0.5">{selectedVolunteer.ilj_id}</p>
                                </div>
                            </div>
                            <button onClick={() => setSelectedVolunteer(null)} className="text-gray-400 hover:text-gray-600 bg-white hover:bg-gray-100 rounded-full p-2 transition-colors">
                                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                            </button>
                        </div>
                        
                        <div className="p-6 overflow-y-auto w-full">
                            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 w-full">
                                
                                {/* Registration / Internal Details */}
                                <div className="space-y-6">
                                    <div className="bg-white border border-gray-200 rounded-xl overflow-hidden shadow-sm">
                                        <div className="bg-gray-50 border-b border-gray-100 px-4 py-3"><h4 className="text-sm font-bold text-gray-800">System Information</h4></div>
                                        <div className="p-4 grid grid-cols-2 gap-4">
                                            <div><p className="text-xs text-gray-500 font-semibold mb-1">Onboarding Status</p>{getStatusBadge(selectedVolunteer.onboarding_status)}</div>
                                            <div>
                                                <p className="text-xs text-gray-500 font-semibold mb-1">Activity Status</p>
                                                <span className={`px-2 py-1 rounded text-[11px] uppercase font-bold border shadow-sm ${
                                                    (selectedVolunteer.activity_status || 'Active') === 'Active' ? 'bg-green-100 text-green-700 border-green-200' : 'bg-gray-100 text-gray-700 border-gray-200'
                                                }`}>{(selectedVolunteer.activity_status || 'Active')}</span>
                                            </div>
                                            <div className="col-span-2">
                                                <p className="text-xs text-gray-500 font-semibold mb-1">Assigned Pod(s)</p>
                                                <p className="text-sm font-medium text-indigo-700">{selectedVolunteer.assigned_pod || 'Not Assigned'}</p>
                                            </div>
                                        </div>
                                    </div>

                                    {/* Contact & Location */}
                                    <div className="bg-gray-50 border border-gray-100 rounded-xl p-4">
                                        <h4 className="text-xs font-bold text-gray-500 uppercase tracking-wider mb-3 flex items-center gap-1.5"><MessageSquare className="h-4 w-4" /> Personal Contact</h4>
                                        <div className="space-y-4">
                                            <div className="flex gap-4"><Mail className="h-5 w-5 text-indigo-400 shrink-0" /><div><p className="text-xs text-gray-500 font-semibold">Email</p><a href={`mailto:${selectedVolunteer.email}`} className="text-sm font-medium text-gray-900">{selectedVolunteer.email}</a></div></div>
                                            <div className="flex gap-4"><Phone className="h-5 w-5 text-indigo-400 shrink-0" /><div><p className="text-xs text-gray-500 font-semibold">Phone / WhatsApp</p><a href={`https://wa.me/${selectedVolunteer.mobile_number?.replace(/\D/g, '')}`} target="_blank" rel="noreferrer" className="text-sm font-medium text-gray-900">{selectedVolunteer.mobile_number}</a></div></div>
                                            <div className="flex gap-4"><MapPin className="h-5 w-5 text-indigo-400 shrink-0" /><div><p className="text-xs text-gray-500 font-semibold">Location</p><p className="text-sm font-medium text-gray-900">{selectedVolunteer.city ? `${selectedVolunteer.city}, ${selectedVolunteer.state}` : 'N/A'}</p></div></div>
                                        </div>
                                    </div>
                                </div>

                                {/* Background & Preferences */}
                                <div className="space-y-6">
                                    <div className="bg-white border border-gray-200 rounded-xl overflow-hidden shadow-sm">
                                        <div className="bg-gray-50 border-b border-gray-100 px-4 py-3"><h4 className="text-sm font-bold text-gray-800">Background & Skills</h4></div>
                                        <div className="p-4 space-y-4">
                                            <div className="grid grid-cols-2 gap-4">
                                                <div><p className="text-xs text-gray-500 font-semibold mb-0.5">Qualification</p><p className="text-sm font-medium text-gray-900">{selectedVolunteer.qualification || '-'}</p></div>
                                                <div><p className="text-xs text-gray-500 font-semibold mb-0.5">Occupation</p><p className="text-sm font-medium text-gray-900">{selectedVolunteer.occupation || '-'}</p></div>
                                            </div>
                                            <div><p className="text-xs text-gray-500 font-semibold mb-0.5">Specialization / Skills</p><p className="text-sm font-medium text-gray-900">{selectedVolunteer.skills || selectedVolunteer.specialization || '-'}</p></div>
                                            <div><p className="text-xs text-gray-500 font-semibold mb-0.5">Dharmik Studies / Kalyan Mitra</p><p className="text-sm font-medium text-gray-900">{selectedVolunteer.dharmik_studies || selectedVolunteer.kalyan_mitra || '-'}</p></div>
                                        </div>
                                    </div>

                                    {/* Availability */}
                                    <div className="bg-indigo-50 border border-indigo-100 rounded-xl p-4">
                                        <h4 className="text-xs font-bold text-indigo-800 uppercase tracking-wider mb-3">Preferences & Availability</h4>
                                        <div className="space-y-3">
                                            <div><p className="text-xs text-indigo-400 font-semibold">Volunteering Preferences</p><ul className="list-disc pl-4 text-sm font-medium text-indigo-900 mt-1 space-y-1"><li>{selectedVolunteer.volunteering_preference1 || 'None specified'}</li>{selectedVolunteer.volunteering_preference2 && <li>{selectedVolunteer.volunteering_preference2}</li>}{selectedVolunteer.volunteering_preference3 && <li>{selectedVolunteer.volunteering_preference3}</li>}</ul></div>
                                            <div className="grid grid-cols-2 pt-2 border-t border-indigo-100/50 mt-2">
                                                <div><p className="text-xs text-indigo-400 font-semibold">Days</p><p className="text-sm font-medium text-indigo-900 mt-0.5">{selectedVolunteer.availability_days || '-'}</p></div>
                                                <div><p className="text-xs text-indigo-400 font-semibold">Mode</p><p className="text-sm font-medium text-indigo-900 mt-0.5">{selectedVolunteer.participation_mode || '-'}</p></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                        
                        <div className="p-5 border-t border-gray-100 bg-gray-50 flex justify-end shrink-0">
                            <button onClick={() => setSelectedVolunteer(null)} className="px-6 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg transition-colors shadow-sm">
                                Close Details
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
};

export default MasterSheet;
