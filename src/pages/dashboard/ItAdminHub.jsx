import React, { useState, useEffect, useMemo } from 'react';
import { supabase } from '@/lib/supabase';
import { 
    Search, Filter, MapPin, Mail, Phone, 
    User, Award, Briefcase, Shield, Activity,
    CheckCircle, XCircle, AlertTriangle, X
} from 'lucide-react';
import { useAuth } from '@/context/AuthContext';

const ItAdminHub = () => {
    const { user } = useAuth();
    const [volunteers, setVolunteers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');
    const [selectedVolunteer, setSelectedVolunteer] = useState(null);
    const [dashboardStats, setDashboardStats] = useState({ total: 0, pendingIt: 0, duplicate: 0 });
    const [isUpdating, setIsUpdating] = useState({ state: false, id: null });
    const [toastMessage, setToastMessage] = useState('');

    useEffect(() => {
        fetchVolunteers();
    }, []);

    const fetchVolunteers = async () => {
        try {
            setLoading(true);
            const { data, error } = await supabase
                .from('volunteers')
                .select('*')
                .order('created_at', { ascending: false });

            if (error) throw error;
            
            setVolunteers(data || []);
            
            const pendingIt = data?.filter(v => !v.onboarding_status || v.onboarding_status === 'pending_it').length || 0;
            const duplicate = data?.filter(v => v.onboarding_status === 'duplicate').length || 0;
            
            setDashboardStats({
                total: data?.length || 0,
                pendingIt,
                duplicate
            });

        } catch (error) {
            console.error('Error fetching volunteers for IT Admin:', error);
        } finally {
            setLoading(false);
        }
    };

    const updateStatus = async (volunteerId, newStatus) => {
        try {
            setIsUpdating({ state: true, id: volunteerId });
            const { error } = await supabase
                .from('volunteers')
                .update({ onboarding_status: newStatus })
                .eq('id', volunteerId);

            if (error) throw error;

            setVolunteers(prev => prev.map(v => 
                v.id === volunteerId ? { ...v, onboarding_status: newStatus } : v
            ));

            if (selectedVolunteer?.id === volunteerId) {
                setSelectedVolunteer(prev => ({ ...prev, onboarding_status: newStatus }));
            }

            // Recalculate stats quickly locally
            const getCount = (statusVal) => volunteers.map(v => v.id === volunteerId ? { ...v, onboarding_status: newStatus } : v).filter(v => v.onboarding_status === statusVal).length;
            setDashboardStats({
                total: volunteers.length,
                pendingIt: volunteers.map(v => v.id === volunteerId ? { ...v, onboarding_status: newStatus } : v).filter(v => !v.onboarding_status || v.onboarding_status === 'pending_it').length,
                duplicate: getCount('duplicate')
            });

            setToastMessage(`Successfully updated status.`);
            setTimeout(() => setToastMessage(''), 3000);

        } catch (error) {
            console.error('Error updating status:', error);
            setToastMessage(`Error updating status: ${error.message}`);
            setTimeout(() => setToastMessage(''), 3000);
        } finally {
            setIsUpdating({ state: false, id: null });
        }
    };

    const filteredVolunteers = useMemo(() => {
        return volunteers.filter(volunteer => {
            const searchLower = searchTerm.toLowerCase();
            const matchesSearch = searchTerm === '' || 
                (volunteer.first_name || '').toLowerCase().includes(searchLower) ||
                (volunteer.last_name || '').toLowerCase().includes(searchLower) ||
                (volunteer.email || '').toLowerCase().includes(searchLower) ||
                (volunteer.mobile_number || '').includes(searchLower) ||
                (volunteer.ilj_id || '').toLowerCase().includes(searchLower);
            
            return matchesSearch;
        });
    }, [volunteers, searchTerm]);

    const getStatusStyles = (status) => {
        switch (status) {
            case 'pending_onboarding':
            case 'onboarded':
                return 'bg-green-100 text-green-800 border-green-200';
            case 'duplicate':
                return 'bg-red-100 text-red-800 border-red-200';
            case 'pending_it':
            default:
                return 'bg-amber-100 text-amber-800 border-amber-200';
        }
    };

    const getStatusText = (status) => {
        switch (status) {
            case 'pending_onboarding': return 'Verified (To Onboard)';
            case 'onboarded': return 'Onboarded';
            case 'duplicate': return 'Duplicate/Rejected';
            case 'pending_it': 
            default: return 'Pending IT Verification';
        }
    };

    if (loading) {
        return (
            <div className="flex justify-center items-center h-full min-h-[400px]">
                <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-purple-600"></div>
            </div>
        );
    }

    return (
        <div className="space-y-6">
            <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                <div>
                    <h1 className="text-2xl font-bold text-gray-900 flex items-center gap-2">
                        <Activity className="h-6 w-6 text-purple-600" />
                        Master DB (IT Admin)
                    </h1>
                    <p className="text-gray-500 mt-1">Review registrations, de-duplicate records, and verify members before onboarding.</p>
                </div>
            </div>

            {/* Stats Overview */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
                <div className="bg-white p-5 rounded-xl border border-gray-200 shadow-sm flex items-center gap-4">
                    <div className="p-3 bg-purple-100 text-purple-600 rounded-lg">
                        <User className="h-6 w-6" />
                    </div>
                    <div>
                        <p className="text-sm font-medium text-gray-500">Total Volunteers</p>
                        <p className="text-2xl font-bold text-gray-900">{dashboardStats.total}</p>
                    </div>
                </div>
                <div className="bg-white p-5 rounded-xl border border-amber-200 shadow-sm flex items-center gap-4 ring-1 ring-amber-50">
                    <div className="p-3 bg-amber-100 text-amber-600 rounded-lg">
                        <AlertTriangle className="h-6 w-6" />
                    </div>
                    <div>
                        <p className="text-sm font-medium text-gray-500">Pending Verification</p>
                        <p className="text-2xl font-bold text-amber-600">{dashboardStats.pendingIt}</p>
                    </div>
                </div>
                <div className="bg-white p-5 rounded-xl border border-gray-200 shadow-sm flex items-center gap-4">
                    <div className="p-3 bg-red-100 text-red-600 rounded-lg">
                        <XCircle className="h-6 w-6" />
                    </div>
                    <div>
                        <p className="text-sm font-medium text-gray-500">Duplicates/Rejected</p>
                        <p className="text-2xl font-bold text-gray-900">{dashboardStats.duplicate}</p>
                    </div>
                </div>
            </div>

            <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-4 mb-6">
                <div className="relative">
                    <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" />
                    <input
                        type="text"
                        placeholder="Search by Name, Email, Phone, or ILJ ID..."
                        className="w-full pl-10 pr-4 py-2 bg-gray-50 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-400 focus:bg-white transition-all"
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                    />
                </div>
            </div>

            <div className="grid shadow-sm rounded-xl overflow-hidden bg-white border border-gray-200">
                <div className="overflow-x-auto">
                    <table className="w-full text-left text-sm whitespace-nowrap">
                        <thead className="bg-gray-50 border-b border-gray-200 text-gray-600">
                            <tr>
                                <th className="px-6 py-4 font-semibold">Volunteer</th>
                                <th className="px-6 py-4 font-semibold">Contact Info</th>
                                <th className="px-6 py-4 font-semibold">Location</th>
                                <th className="px-6 py-4 font-semibold">Reg. Date</th>
                                <th className="px-6 py-4 font-semibold">Status</th>
                                <th className="px-6 py-4 font-semibold text-right">Action</th>
                            </tr>
                        </thead>
                        <tbody className="divide-y divide-gray-100">
                            {filteredVolunteers.length > 0 ? (
                                filteredVolunteers.map(volunteer => {
                                    const currentStatus = volunteer.onboarding_status || 'pending_it';
                                    return (
                                        <tr key={volunteer.id} className="hover:bg-gray-50/50 transition-colors">
                                            <td className="px-6 py-4">
                                                <div className="flex items-center gap-3">
                                                    <div className="w-10 h-10 rounded-full bg-purple-100 border border-purple-200 text-purple-700 font-bold flex items-center justify-center shrink-0">
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
                                            <td className="px-6 py-4">
                                                <div className="flex flex-col gap-1 text-gray-600">
                                                    <span className="flex items-center gap-1.5"><Mail className="h-3.5 w-3.5" />{volunteer.email}</span>
                                                    <span className="flex items-center gap-1.5"><Phone className="h-3.5 w-3.5" />{volunteer.mobile_number}</span>
                                                </div>
                                            </td>
                                            <td className="px-6 py-4 text-gray-600">
                                                <span className="flex items-center gap-1.5"><MapPin className="h-3.5 w-3.5" />{volunteer.city}, {volunteer.state}</span>
                                            </td>
                                            <td className="px-6 py-4 text-gray-600">
                                                {new Date(volunteer.created_at).toLocaleDateString()}
                                            </td>
                                            <td className="px-6 py-4">
                                                <span className={`px-2.5 py-1 text-xs font-semibold rounded-full border ${getStatusStyles(currentStatus)}`}>
                                                    {getStatusText(currentStatus)}
                                                </span>
                                            </td>
                                            <td className="px-6 py-4 text-right">
                                                <button
                                                    onClick={() => setSelectedVolunteer(volunteer)}
                                                    className="font-medium text-purple-600 hover:text-purple-800 hover:underline"
                                                >
                                                    View & Verify
                                                </button>
                                            </td>
                                        </tr>
                                    );
                                })
                            ) : (
                                <tr>
                                    <td colSpan="6" className="px-6 py-12 text-center text-gray-500">
                                        No entries found.
                                    </td>
                                </tr>
                            )}
                        </tbody>
                    </table>
                </div>
            </div>

            {/* Verification Modal */}
            {selectedVolunteer && (
                <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm transition-all text-left" onClick={() => setSelectedVolunteer(null)}>
                    <div className="bg-white w-full max-w-2xl max-h-[90vh] overflow-y-auto rounded-2xl shadow-2xl animate-in fade-in zoom-in-95 duration-200" onClick={e => e.stopPropagation()}>
                        <div className="sticky top-0 bg-white border-b border-gray-100 p-6 flex justify-between items-start z-10">
                            <div>
                                <h2 className="text-xl font-bold text-gray-900">Registration Details</h2>
                                <p className="text-sm text-gray-500 mt-1">Verify this record against the master database.</p>
                            </div>
                            <button onClick={() => setSelectedVolunteer(null)} className="p-2 hover:bg-gray-100 rounded-full transition-colors"><X className="h-6 w-6 text-gray-500" /></button>
                        </div>
                        
                        <div className="p-6">
                            <div className="mb-6 flex items-center justify-between bg-gray-50 p-4 rounded-xl border border-gray-200">
                                <div className="flex items-center gap-4">
                                    <div className="w-14 h-14 rounded-full bg-purple-100 border border-purple-200 text-purple-700 font-bold flex xl:text-xl items-center justify-center shrink-0">
                                        {selectedVolunteer.first_name?.[0]}{selectedVolunteer.last_name?.[0]}
                                    </div>
                                    <div>
                                        <h3 className="text-lg font-bold text-gray-900">{selectedVolunteer.first_name} {selectedVolunteer.last_name}</h3>
                                        <p className="text-gray-500 font-mono text-sm">{selectedVolunteer.ilj_id}</p>
                                    </div>
                                </div>
                                <div className="text-right">
                                    <span className={`px-3 py-1 text-sm font-semibold rounded-full border ${getStatusStyles(selectedVolunteer.onboarding_status || 'pending_it')}`}>
                                        {getStatusText(selectedVolunteer.onboarding_status || 'pending_it')}
                                    </span>
                                </div>
                            </div>
                            
                            
                            <div className="space-y-6 mb-8">
                                {/* Personal & Contact */}
                                <div>
                                    <h4 className="text-sm font-bold text-gray-500 uppercase tracking-wider mb-3 border-b pb-1">Personal & Contact</h4>
                                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                        <div className="sm:col-span-2 lg:col-span-1"><p className="text-xs text-gray-400">Email</p><p className="font-medium text-gray-900 break-all">{selectedVolunteer.email}</p></div>
                                        <div><p className="text-xs text-gray-400">Phone</p><p className="font-medium text-gray-900 break-all">{selectedVolunteer.mobile_number}</p></div>
                                        <div><p className="text-xs text-gray-400">Date of Birth</p><p className="font-medium text-gray-900">{selectedVolunteer.dob ? new Date(selectedVolunteer.dob).toLocaleDateString() : 'N/A'}</p></div>
                                        <div><p className="text-xs text-gray-400">Gender</p><p className="font-medium text-gray-900">{selectedVolunteer.gender || 'N/A'}</p></div>
                                    </div>
                                </div>

                                {/* Address */}
                                <div>
                                    <h4 className="text-sm font-bold text-gray-500 uppercase tracking-wider mb-3 border-b pb-1">Address</h4>
                                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                        <div><p className="text-xs text-gray-400">Address Line 1</p><p className="font-medium text-gray-900">{selectedVolunteer.address_line1 || 'N/A'}</p></div>
                                        <div><p className="text-xs text-gray-400">Address Line 2 (Area)</p><p className="font-medium text-gray-900">{selectedVolunteer.address_line2 || 'N/A'}</p></div>
                                        <div><p className="text-xs text-gray-400">City & District</p><p className="font-medium text-gray-900">{selectedVolunteer.city || 'N/A'}, {selectedVolunteer.district || 'N/A'}</p></div>
                                        <div><p className="text-xs text-gray-400">State & Country (PIN)</p><p className="font-medium text-gray-900">{selectedVolunteer.state}, {selectedVolunteer.country} - {selectedVolunteer.pincode}</p></div>
                                        <div><p className="text-xs text-gray-400">Sangh Name</p><p className="font-medium text-gray-900">{selectedVolunteer.sangh_name || 'N/A'}</p></div>
                                    </div>
                                </div>

                                {/* Education & Occupation */}
                                <div>
                                    <h4 className="text-sm font-bold text-gray-500 uppercase tracking-wider mb-3 border-b pb-1">Background</h4>
                                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                        <div className="sm:col-span-2"><p className="text-xs text-gray-400">Dharmik Studies</p><p className="font-medium text-gray-900 whitespace-pre-wrap">{selectedVolunteer.dharmik_studies || 'N/A'}</p></div>
                                        <div><p className="text-xs text-gray-400">Qualification</p><p className="font-medium text-gray-900">{selectedVolunteer.qualification || 'N/A'}</p></div>
                                        <div><p className="text-xs text-gray-400">Specialization</p><p className="font-medium text-gray-900">{selectedVolunteer.specialization || 'N/A'}</p></div>
                                        <div><p className="text-xs text-gray-400">Occupation</p><p className="font-medium text-gray-900">{selectedVolunteer.occupation || 'N/A'} {selectedVolunteer.occupation_other ? `(${selectedVolunteer.occupation_other})` : ''}</p></div>
                                    </div>
                                </div>

                                {/* Interests & Preferences */}
                                <div>
                                    <h4 className="text-sm font-bold text-gray-500 uppercase tracking-wider mb-3 border-b pb-1">Interests & Preferences</h4>
                                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                        <div><p className="text-xs text-gray-400">Hobbies</p><p className="font-medium text-gray-900">{selectedVolunteer.hobbies || 'N/A'}</p></div>
                                        <div><p className="text-xs text-gray-400">Skills</p><p className="font-medium text-gray-900">{selectedVolunteer.skills || 'N/A'}</p></div>
                                        <div className="sm:col-span-2"><p className="text-xs text-gray-400">Volunteering Preferences</p>
                                            <ul className="list-disc pl-5 font-medium text-gray-900">
                                                <li>{selectedVolunteer.volunteering_preference1 || 'N/A'}</li>
                                                {selectedVolunteer.volunteering_preference2 && <li>{selectedVolunteer.volunteering_preference2}</li>}
                                                {selectedVolunteer.volunteering_preference3 && <li>{selectedVolunteer.volunteering_preference3}</li>}
                                            </ul>
                                        </div>
                                        <div className="sm:col-span-2"><p className="text-xs text-gray-400">Availability & Mode</p><p className="font-medium text-gray-900">{selectedVolunteer.availability_days || 'N/A'} • {selectedVolunteer.participation_mode || 'N/A'} • {selectedVolunteer.time_commitment || 'N/A'}</p></div>
                                        <div><p className="text-xs text-gray-400">Referred By</p><p className="font-medium text-gray-900">{selectedVolunteer.referred_by || 'N/A'}</p></div>
                                    </div>
                                </div>
                            </div>
                            
                            <div className="border-t border-gray-100 pt-6">
                                <h4 className="font-semibold text-gray-900 mb-4">Verification Actions</h4>
                                <div className="flex flex-col sm:flex-row gap-3">
                                    <button 
                                        onClick={() => updateStatus(selectedVolunteer.id, 'pending_onboarding')}
                                        disabled={isUpdating.state}
                                        className="flex-1 flex items-center justify-center gap-2 bg-green-600 hover:bg-green-700 text-white font-medium py-2.5 px-4 rounded-lg transition-colors shadow-sm disabled:opacity-70 disabled:cursor-not-allowed"
                                    >
                                        {isUpdating.state && isUpdating.id === selectedVolunteer.id ? (
                                            <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-white"></div>
                                        ) : <CheckCircle className="h-5 w-5" />} Mark Valid (Send to Onboarding)
                                    </button>
                                    <button 
                                        onClick={() => updateStatus(selectedVolunteer.id, 'duplicate')}
                                        disabled={isUpdating.state}
                                        className="flex-1 flex items-center justify-center gap-2 bg-red-50 hover:bg-red-100 text-red-600 border border-red-200 font-medium py-2.5 px-4 rounded-lg transition-colors disabled:opacity-70 disabled:cursor-not-allowed"
                                    >
                                        <AlertTriangle className="h-5 w-5" /> Flag as Duplicate / Reject
                                    </button>
                                    <button 
                                        onClick={() => updateStatus(selectedVolunteer.id, 'pending_it')}
                                        disabled={isUpdating.state}
                                        className="flex-1 flex items-center justify-center gap-2 bg-gray-100 hover:bg-gray-200 text-gray-700 font-medium py-2.5 px-4 rounded-lg transition-colors disabled:opacity-70 disabled:cursor-not-allowed"
                                    >
                                        Keep as Pending Verification
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            )}
            {/* Toast Notification */}
            {toastMessage && (
                <div className="fixed bottom-4 right-4 bg-gray-900 text-white px-6 py-3 rounded-lg shadow-lg z-50 animate-in slide-in-from-bottom flex items-center gap-2 font-medium">
                    {toastMessage.includes('Error') ? <XCircle className="h-5 w-5 text-red-400" /> : <CheckCircle className="h-5 w-5 text-green-400" />}
                    {toastMessage}
                </div>
            )}
        </div>
    );
};

export default ItAdminHub;
