import React, { useState, useEffect, useMemo } from 'react';
import { supabase } from '@/lib/supabase';
import { 
    Users, Search, CheckCircle, Mail, Phone, MapPin, 
    MessageSquare, ClipboardList, UserCheck, AlertCircle
} from 'lucide-react';
import { useAuth } from '@/context/AuthContext';

const PodManagementHub = () => {
    const { user } = useAuth();
    const [projects, setProjects] = useState([]);
    const [selectedProjectId, setSelectedProjectId] = useState('');
    const [podVolunteers, setPodVolunteers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');
    
    // Status and Modals
    const [isUpdating, setIsUpdating] = useState({ state: false, id: null });
    const [isUpdatingActivity, setIsUpdatingActivity] = useState({ state: false, id: null });
    const [selectedVolunteer, setSelectedVolunteer] = useState(null);
    const [toastMessage, setToastMessage] = useState('');

    useEffect(() => {
        fetchProjects();
    }, []);

    useEffect(() => {
        if (selectedProjectId) {
            fetchPodVolunteers(selectedProjectId);
        } else {
            setPodVolunteers([]);
        }
    }, [selectedProjectId]);

    const fetchProjects = async () => {
        try {
            const { data, error } = await supabase.from('projects').select('id, title').order('title');
            if (error) throw error;
            if (data?.length > 0) {
                setProjects(data);
                setSelectedProjectId(data[0].id); // Auto-select first pod
            }
        } catch (err) {
            console.error('Error fetching projects:', err);
        } finally {
            setLoading(false);
        }
    };

    const fetchPodVolunteers = async (projectId) => {
        setLoading(true);
        try {
            const { data, error } = await supabase
                .from('project_volunteers')
                .select(`
                    id,
                    status,
                    engagement_status,
                    volunteer:volunteers(id, first_name, last_name, email, mobile_number, city, ilj_id, activity_status, state, dharmik_studies, qualification, occupation, skills, volunteering_preference1, availability_days)
                `)
                .eq('project_id', projectId);

            if (error) throw error;
            
            // Clean up nested data
            const formatted = data?.filter(d => Boolean(d.volunteer)).map(d => ({
                pv_id: d.id,
                engagement_status: d.engagement_status || 'pending',
                activity_status: d.volunteer.activity_status || 'Active',
                ...d.volunteer
            })) || [];
            
            setPodVolunteers(formatted);
        } catch (error) {
            console.error('Error fetching pod volunteers:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleUpdateStatus = async (pvId, newStatus) => {
        try {
            setIsUpdating({ state: true, id: pvId });
            const { error } = await supabase
                .from('project_volunteers')
                .update({ engagement_status: newStatus })
                .eq('id', pvId);

            if (error) throw error;

            setPodVolunteers(prev => prev.map(v => 
                v.pv_id === pvId ? { ...v, engagement_status: newStatus } : v
            ));

            setToastMessage('Engagement status updated successfully!');
            setTimeout(() => setToastMessage(''), 3000);
        } catch (error) {
            console.error('Error updating status:', error);
            setToastMessage(`Error: Failed to update status`);
            setTimeout(() => setToastMessage(''), 3000);
        } finally {
            setIsUpdating({ state: false, id: null });
        }
    };

    const handleToggleActivity = async (volunteerId, currentStatus) => {
        const newStatus = currentStatus === 'Active' ? 'Inactive' : 'Active';
        try {
            setIsUpdatingActivity({ state: true, id: volunteerId });
            
            // Update Master DB Sheet (volunteers table)
            const { error } = await supabase
                .from('volunteers')
                .update({ activity_status: newStatus })
                .eq('id', volunteerId);

            if (error) throw error;

            setPodVolunteers(prev => prev.map(v => 
                v.id === volunteerId ? { ...v, activity_status: newStatus } : v
            ));

            setToastMessage(`Volunteer marked as ${newStatus}!`);
            setTimeout(() => setToastMessage(''), 3000);
        } catch (error) {
            console.error('Error updating activity status:', error);
            setToastMessage(`Error: Failed to update activity`);
            setTimeout(() => setToastMessage(''), 3000);
        } finally {
            setIsUpdatingActivity({ state: false, id: null });
        }
    };

    const filteredVolunteers = useMemo(() => {
        return podVolunteers.filter(v => {
            const searchLower = searchTerm.toLowerCase();
            return searchTerm === '' || 
                (v.first_name || '').toLowerCase().includes(searchLower) ||
                (v.last_name || '').toLowerCase().includes(searchLower) ||
                (v.email || '').toLowerCase().includes(searchLower);
        });
    }, [podVolunteers, searchTerm]);

    const getStatusStyle = (status) => {
        switch(status) {
            case 'introduced': return 'bg-indigo-100 text-indigo-700 border-indigo-200';
            case 'contacted': return 'bg-blue-100 text-blue-700 border-blue-200';
            default: return 'bg-amber-100 text-amber-700 border-amber-200'; // pending
        }
    };

    return (
        <div className="space-y-6 animate-fade-in pb-12">
            <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                <div>
                    <h1 className="text-2xl font-bold text-gray-900 flex items-center gap-2">
                        <Users className="h-6 w-6 text-indigo-600" />
                        Pod Engagement Hub
                    </h1>
                    <p className="text-gray-500 mt-1">Manage engagement, contact volunteers, and track pod activity.</p>
                </div>
            </div>

            {/* Workflow Guide */}
            <div className="bg-indigo-50 border border-indigo-100 rounded-xl p-5 flex flex-col md:flex-row gap-6 items-start">
                <div className="bg-white p-3 rounded-lg shadow-sm border border-indigo-100 shrink-0">
                    <ClipboardList className="h-8 w-8 text-indigo-600" />
                </div>
                <div>
                    <h3 className="text-lg font-bold text-indigo-900 mb-2">Pod Leader Engagement Protocol</h3>
                    <p className="text-sm text-indigo-800 mb-3">Once volunteers appear in this sheet, please follow these steps to actively engage them in your pod:</p>
                    <ul className="grid grid-cols-1 md:grid-cols-3 gap-3">
                        <li className="bg-white px-4 py-3 rounded-lg border border-indigo-100 text-sm text-gray-700 font-medium shadow-sm flex items-start gap-2">
                            <span className="bg-indigo-100 text-indigo-700 w-5 h-5 rounded-full flex items-center justify-center text-xs font-bold shrink-0">1</span>
                            Contact the volunteer via Phone or Email to welcome them.
                        </li>
                        <li className="bg-white px-4 py-3 rounded-lg border border-indigo-100 text-sm text-gray-700 font-medium shadow-sm flex items-start gap-2">
                            <span className="bg-indigo-100 text-indigo-700 w-5 h-5 rounded-full flex items-center justify-center text-xs font-bold shrink-0">2</span>
                            Introduce them to ongoing pod activities and projects.
                        </li>
                        <li className="bg-white px-4 py-3 rounded-lg border border-indigo-100 text-sm text-gray-700 font-medium shadow-sm flex items-start gap-2">
                            <span className="bg-indigo-100 text-indigo-700 w-5 h-5 rounded-full flex items-center justify-center text-xs font-bold shrink-0">3</span>
                            Add them to necessary communication channels (e.g. WhatsApp, Slack).
                        </li>
                    </ul>
                </div>
            </div>

            {/* Pod Selector & Search */}
            <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-5 flex flex-col md:flex-row gap-4 justify-between">
                <div className="w-full md:w-1/3">
                    <label className="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Select Pod / Project</label>
                    <select
                        className="w-full bg-gray-50 border border-gray-300 rounded-lg px-4 py-2.5 text-gray-900 font-medium focus:ring-2 focus:ring-indigo-500 focus:outline-none transition-colors"
                        value={selectedProjectId}
                        onChange={(e) => setSelectedProjectId(e.target.value)}
                    >
                        {projects.map(p => (
                            <option key={p.id} value={p.id}>{p.title}</option>
                        ))}
                    </select>
                </div>
                
                <div className="w-full md:w-1/2 flex items-end">
                    <div className="relative w-full">
                        <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" />
                        <input
                            type="text"
                            placeholder="Find a volunteer in this pod..."
                            className="w-full pl-10 pr-4 py-2.5 bg-gray-50 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-400 transition-all"
                            value={searchTerm}
                            onChange={(e) => setSearchTerm(e.target.value)}
                        />
                    </div>
                </div>
            </div>

            {/* Volunteers Sheet (Table) */}
            <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                {loading ? (
                    <div className="flex justify-center py-20">
                        <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-indigo-600"></div>
                    </div>
                ) : filteredVolunteers.length > 0 ? (
                    <div className="overflow-x-auto">
                        <table className="w-full text-left text-sm whitespace-nowrap">
                            <thead className="bg-gray-50 border-b border-gray-200 text-gray-600">
                                <tr>
                                    <th className="px-6 py-4 font-semibold">Volunteer Details</th>
                                    <th className="px-6 py-4 font-semibold">Contact & Location</th>
                                    <th className="px-6 py-4 font-semibold">Workflow State</th>
                                    <th className="px-6 py-4 font-semibold">Master Sheet Activity</th>
                                    <th className="px-6 py-4 font-semibold text-right">Actions</th>
                                </tr>
                            </thead>
                            <tbody className="divide-y divide-gray-100">
                                {filteredVolunteers.map(volunteer => (
                                    <tr key={volunteer.pv_id} className="hover:bg-gray-50/50 transition-colors">
                                        {/* Volunteer Identity */}
                                        <td className="px-6 py-4" onClick={() => setSelectedVolunteer(volunteer)} style={{cursor: 'pointer'}}>
                                            <div className="flex items-center gap-3">
                                                <div className="w-10 h-10 rounded-full bg-indigo-100 border border-indigo-200 text-indigo-700 font-bold flex items-center justify-center shrink-0">
                                                    {volunteer.first_name?.[0]}{volunteer.last_name?.[0]}
                                                </div>
                                                <div>
                                                    <p className="font-semibold text-gray-900 leading-tight">
                                                        {volunteer.first_name} {volunteer.last_name}
                                                    </p>
                                                    <p className="text-xs font-medium text-gray-500 mt-0.5">{volunteer.ilj_id || 'No ID'}</p>
                                                </div>
                                            </div>
                                        </td>
                                        
                                        {/* Contact & Location */}
                                        <td className="px-6 py-4">
                                            <div className="flex flex-col gap-1.5 text-gray-600">
                                                <a href={`mailto:${volunteer.email}`} className="flex items-center gap-2 hover:text-indigo-600 hover:underline">
                                                    <Mail className="h-3.5 w-3.5 text-gray-400" />{volunteer.email || 'N/A'}
                                                </a>
                                                <a href={`https://wa.me/${volunteer.mobile_number?.replace(/\D/g, '')}`} target="_blank" rel="noreferrer" className="flex items-center gap-2 hover:text-indigo-600 hover:underline">
                                                    <Phone className="h-3.5 w-3.5 text-gray-400" />{volunteer.mobile_number || 'N/A'}
                                                </a>
                                                <span className="flex items-center gap-2">
                                                    <MapPin className="h-3.5 w-3.5 text-gray-400" />{volunteer.city || 'Location N/A'}
                                                </span>
                                            </div>
                                        </td>

                                        {/* Live State indicator */}
                                        <td className="px-6 py-4">
                                            <span className={`text-[11px] uppercase font-bold px-2.5 py-1 rounded border shadow-sm ${getStatusStyle(volunteer.engagement_status)}`}>
                                                {volunteer.engagement_status === 'pending' ? 'Pending Contact' : volunteer.engagement_status}
                                            </span>
                                        </td>

                                        {/* Status Update Dropdown */}
                                        <td className="px-6 py-4">
                                            <div className="relative">
                                                <select 
                                                    className="w-full min-w-[140px] px-3 py-2 bg-white border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none font-medium text-gray-900 shadow-sm transition-shadow appearance-none cursor-pointer disabled:opacity-50"
                                                    value={volunteer.engagement_status}
                                                    onChange={(e) => handleUpdateStatus(volunteer.pv_id, e.target.value)}
                                                    disabled={isUpdating.state && isUpdating.id === volunteer.pv_id}
                                                >
                                                    <option value="pending">Pending Contact</option>
                                                    <option value="contacted">Contacted</option>
                                                    <option value="introduced">Introduced to Pod</option>
                                                </select>
                                                <div className="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-500">
                                                    {isUpdating.state && isUpdating.id === volunteer.pv_id ? (
                                                        <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-indigo-600"></div>
                                                    ) : (
                                                        <svg className="fill-current h-4 w-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><path d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"/></svg>
                                                    )}
                                                </div>
                                            </div>
                                        </td>

                                        {/* Master Sheet Active Toggle */}
                                        <td className="px-6 py-4">
                                            <label className="relative inline-flex items-center cursor-pointer">
                                                <input 
                                                    type="checkbox" 
                                                    className="sr-only peer"
                                                    checked={volunteer.activity_status === 'Active'}
                                                    onChange={() => handleToggleActivity(volunteer.id, volunteer.activity_status)}
                                                    disabled={isUpdatingActivity.state && isUpdatingActivity.id === volunteer.id}
                                                />
                                                <div className={`w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-green-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all ${volunteer.activity_status === 'Active' ? 'peer-checked:bg-green-500' : ''}`}></div>
                                                <span className={`ml-3 text-sm font-bold ${volunteer.activity_status === 'Active' ? 'text-green-600' : 'text-gray-400'}`}>
                                                    {isUpdatingActivity.state && isUpdatingActivity.id === volunteer.id ? 'Saving...' : volunteer.activity_status}
                                                </span>
                                            </label>
                                        </td>

                                        {/* Actions */}
                                        <td className="px-6 py-4 text-right">
                                            <button 
                                                onClick={() => setSelectedVolunteer(volunteer)}
                                                className="px-3 py-1.5 text-xs font-bold text-indigo-700 bg-indigo-50 hover:bg-indigo-100 rounded-md border border-indigo-200 transition-colors"
                                            >
                                                View Details
                                            </button>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                ) : (
                    <div className="text-center py-16">
                        <UserCheck className="h-12 w-12 text-gray-300 mx-auto mb-3" />
                        <h3 className="text-lg font-medium text-gray-900 mb-1">No pod volunteers found</h3>
                        <p className="text-gray-500">There are no volunteers assigned to this pod yet, or they don't match your search.</p>
                    </div>
                )}
            </div>

            {/* Volunteer Details Modal */}
            {selectedVolunteer && (
                <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm" onClick={() => setSelectedVolunteer(null)}>
                    <div className="bg-white w-full max-w-2xl rounded-2xl shadow-2xl animate-in fade-in zoom-in-95 overflow-hidden flex flex-col max-h-[90vh]" onClick={e => e.stopPropagation()}>
                        <div className="bg-gradient-to-r from-indigo-50 to-blue-50 border-b border-indigo-100 p-6 flex justify-between items-start">
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
                        
                        <div className="p-6 overflow-y-auto space-y-6">
                            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                {/* Contact Card */}
                                <div className="bg-gray-50 border border-gray-100 rounded-xl p-4">
                                    <h4 className="text-xs font-bold text-gray-500 uppercase tracking-wider mb-3 flex items-center gap-1.5"><MessageSquare className="h-4 w-4" /> Contact Information</h4>
                                    <div className="space-y-3">
                                        <div className="flex items-start gap-3">
                                            <Mail className="h-5 w-5 text-indigo-400 mt-0.5" />
                                            <div>
                                                <p className="text-xs text-gray-500 font-semibold">Email</p>
                                                <a href={`mailto:${selectedVolunteer.email}`} className="text-sm font-medium text-gray-900 hover:text-indigo-600">{selectedVolunteer.email}</a>
                                            </div>
                                        </div>
                                        <div className="flex items-start gap-3">
                                            <Phone className="h-5 w-5 text-indigo-400 mt-0.5" />
                                            <div>
                                                <p className="text-xs text-gray-500 font-semibold">Phone</p>
                                                <a href={`https://wa.me/${selectedVolunteer.mobile_number?.replace(/\D/g, '')}`} target="_blank" rel="noreferrer" className="text-sm font-medium text-gray-900 hover:text-indigo-600">{selectedVolunteer.mobile_number}</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                {/* Location Card */}
                                <div className="bg-gray-50 border border-gray-100 rounded-xl p-4">
                                    <h4 className="text-xs font-bold text-gray-500 uppercase tracking-wider mb-3 flex items-center gap-1.5"><MapPin className="h-4 w-4" /> Location Details</h4>
                                    <div className="space-y-3">
                                        <div>
                                            <p className="text-xs text-gray-500 font-semibold">City</p>
                                            <p className="text-sm font-medium text-gray-900">{selectedVolunteer.city || 'Not provided'}</p>
                                        </div>
                                        <div>
                                            <p className="text-xs text-gray-500 font-semibold">State</p>
                                            <p className="text-sm font-medium text-gray-900">{selectedVolunteer.state || 'Not provided'}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            {/* Background & Skills */}
                            <div className="bg-white border border-gray-200 shadow-sm rounded-xl overflow-hidden">
                                <div className="border-b border-gray-100 bg-gray-50/50 px-4 py-3">
                                    <h4 className="text-sm font-bold text-gray-800">Volunteer Profile & Background</h4>
                                </div>
                                <div className="p-4 grid grid-cols-1 md:grid-cols-2 gap-y-4 gap-x-6">
                                    <div>
                                        <p className="text-xs text-gray-500 font-semibold">Qualification</p>
                                        <p className="text-sm font-medium text-gray-900">{selectedVolunteer.qualification || '-'}</p>
                                    </div>
                                    <div>
                                        <p className="text-xs text-gray-500 font-semibold">Occupation</p>
                                        <p className="text-sm font-medium text-gray-900">{selectedVolunteer.occupation || '-'}</p>
                                    </div>
                                    <div className="md:col-span-2">
                                        <p className="text-xs text-gray-500 font-semibold">Skills</p>
                                        <p className="text-sm font-medium text-gray-900">{selectedVolunteer.skills || '-'}</p>
                                    </div>
                                    <div className="md:col-span-2">
                                        <p className="text-xs text-gray-500 font-semibold">Dharmik Studies / Background</p>
                                        <p className="text-sm font-medium text-gray-900">{selectedVolunteer.dharmik_studies || '-'}</p>
                                    </div>
                                </div>
                            </div>

                            {/* Preferences & Availability */}
                            <div className="bg-indigo-50 border border-indigo-100 rounded-xl p-4">
                                <h4 className="text-xs font-bold text-indigo-800 uppercase tracking-wider mb-3 flex items-center gap-1.5">Availability</h4>
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div>
                                        <p className="text-xs text-indigo-400 font-semibold">Top Volunteering Preference</p>
                                        <p className="text-sm font-medium text-indigo-900 mt-1">
                                            {selectedVolunteer.volunteering_preference1 ? (
                                                <span className="bg-white px-2 py-1 rounded shadow-sm border border-indigo-50">{selectedVolunteer.volunteering_preference1}</span>
                                            ) : '-'}
                                        </p>
                                    </div>
                                    <div>
                                        <p className="text-xs text-indigo-400 font-semibold">Availability Days</p>
                                        <p className="text-sm font-medium text-indigo-900 mt-1">{selectedVolunteer.availability_days || '-'}</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div className="p-5 border-t border-gray-100 bg-gray-50 flex justify-end">
                            <button 
                                onClick={() => setSelectedVolunteer(null)}
                                className="px-6 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg transition-colors shadow-sm"
                            >
                                Done
                            </button>
                        </div>
                    </div>
                </div>
            )}

            {/* Toast Notification */}
            {toastMessage && (
                <div className="fixed bottom-4 right-4 bg-gray-900 text-white px-6 py-3 rounded-lg shadow-lg z-50 animate-in slide-in-from-bottom flex items-center gap-2 font-medium">
                    {toastMessage.includes('Error') ? <span className="text-red-400 rounded-full bg-red-400/10 p-1 flex items-center justify-center">✕</span> : <CheckCircle className="h-5 w-5 text-green-400" />}
                    {toastMessage}
                </div>
            )}
        </div>
    );
};

export default PodManagementHub;

