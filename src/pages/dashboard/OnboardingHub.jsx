import React, { useState, useEffect, useMemo } from 'react';
import { supabase, supabaseUrl } from '@/lib/supabase';
import { 
    Search, MapPin, Mail, Phone, 
    User, CheckCircle, Clock, UserPlus
} from 'lucide-react';
import { useAuth } from '@/context/AuthContext';

const OnboardingHub = () => {
    const { user } = useAuth();
    const [volunteers, setVolunteers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');
    const [selectedVolunteer, setSelectedVolunteer] = useState(null);
    const [dashboardStats, setDashboardStats] = useState({ pendingOnboarding: 0, onboarded: 0 });
    const [isUpdating, setIsUpdating] = useState(false);
    const [toastMessage, setToastMessage] = useState('');
    
    // New states for Assignment Workflow
    const [projects, setProjects] = useState([]);
    const [selectedProjects, setSelectedProjects] = useState([]);
    const [onboardingTasks, setOnboardingTasks] = useState({
        contacted: false,
        introduced: false,
        explained: false
    });

    useEffect(() => {
        fetchVolunteers();
        fetchProjects();
    }, []);

    const fetchProjects = async () => {
        try {
            const { data, error } = await supabase.from('projects').select('id, title').order('title');
            if (!error && data) setProjects(data);
        } catch (err) {
            console.error('Error fetching projects:', err);
        }
    };

    const fetchVolunteers = async () => {
        try {
            setLoading(true);
            const { data, error } = await supabase
                .from('volunteers')
                .select('*')
                .in('onboarding_status', ['pending_onboarding', 'onboarded'])
                .order('created_at', { ascending: false });

            if (error) throw error;
            
            setVolunteers(data || []);
            
            const pendingOnboarding = data?.filter(v => v.onboarding_status === 'pending_onboarding').length || 0;
            const onboarded = data?.filter(v => v.onboarding_status === 'onboarded').length || 0;
            
            setDashboardStats({
                pendingOnboarding,
                onboarded
            });

        } catch (error) {
            console.error('Error fetching volunteers for Onboarding:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleFinalizeOnboarding = async (volunteerId, projectsArr) => {
        if (projectsArr.length === 0) {
            setToastMessage('Error: You must assign at least one pod/project.');
            setTimeout(() => setToastMessage(''), 3000);
            return;
        }

        try {
            setIsUpdating(true);
            const assignedPodString = projectsArr.map(p => p.title).join(', ');

            // 1. Update volunteer status and master sheet assigned_pod column
            const { error } = await supabase
                .from('volunteers')
                .update({ 
                    onboarding_status: 'onboarded',
                    assigned_pod: assignedPodString 
                })
                .eq('id', volunteerId);

            if (error) throw error;

            // 2. Insert mapping records into project_volunteers table
            // Delete existing mappings first to ensure a clean slate and avoid duplicates
            await supabase.from('project_volunteers').delete().eq('volunteer_id', volunteerId);

            const projectVolunteerRecords = projectsArr.map(p => ({
                project_id: p.id,
                volunteer_id: volunteerId,
                status: 'approved',
                engagement_status: 'active'
            }));

            const { error: pvError } = await supabase
                .from('project_volunteers')
                .insert(projectVolunteerRecords);

            if (pvError) {
                console.error("Error creating project_volunteers records:", pvError);
                // Non-fatal error for this function since master sheet is already updated
            }
            
            // Send email notification for pod assignment unconditionally
            try {
                const response = await fetch(`${supabaseUrl}/functions/v1/notify-pod-assignment`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        volunteer_id: volunteerId,
                        project_ids: projectsArr.map(p => p.id)
                    })
                });
                if (!response.ok) {
                    const errRes = await response.json().catch(()=>({}));
                    console.error("Email Edge Function returned error:", errRes);
                }
            } catch (emailErr) {
                console.error("Error sending pod assignment emails:", emailErr);
            }

            setVolunteers(prev => prev.map(v => 
                v.id === volunteerId ? { ...v, onboarding_status: 'onboarded', assigned_pod: assignedPodString } : v
            ));

            // Recalculate stats quickly locally
            const updatedVols = volunteers.map(v => v.id === volunteerId ? { ...v, onboarding_status: 'onboarded' } : v);
            setDashboardStats({
                pendingOnboarding: updatedVols.filter(v => v.onboarding_status === 'pending_onboarding').length,
                onboarded: updatedVols.filter(v => v.onboarding_status === 'onboarded').length
            });

            setSelectedVolunteer(null);
            setSelectedProjects([]);
            setToastMessage('Volunteer successfully onboarded and assigned to pod!');
            setTimeout(() => setToastMessage(''), 3000);

        } catch (error) {
            console.error('Error updating status:', error);
            setToastMessage(`Error: ${error.message}`);
            setTimeout(() => setToastMessage(''), 3000);
        } finally {
            setIsUpdating(false);
        }
    };

    const filteredVolunteers = useMemo(() => {
        return volunteers.filter(volunteer => {
            const searchLower = searchTerm.toLowerCase();
            const matchesSearch = searchTerm === '' || 
                (volunteer.first_name || '').toLowerCase().includes(searchLower) ||
                (volunteer.last_name || '').toLowerCase().includes(searchLower) ||
                (volunteer.email || '').toLowerCase().includes(searchLower) ||
                (volunteer.mobile_number || '').includes(searchLower);
            
            return matchesSearch;
        });
    }, [volunteers, searchTerm]);

    if (loading) {
        return (
            <div className="flex justify-center items-center h-full min-h-[400px]">
                <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-blue-600"></div>
            </div>
        );
    }

    return (
        <div className="space-y-6">
            <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                <div>
                    <h1 className="text-2xl font-bold text-gray-900 flex items-center gap-2">
                        <UserPlus className="h-6 w-6 text-blue-600" />
                        Onboarding 
                    </h1>
                    <p className="text-gray-500 mt-1">Interview members, assign pods, and finalize onboarding.</p>
                </div>
            </div>

            {/* Stats */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
                <div className="bg-white p-5 rounded-xl border border-amber-200 shadow-sm flex items-center gap-4 ring-1 ring-amber-50">
                    <div className="p-3 bg-amber-100 text-amber-600 rounded-lg">
                        <Clock className="h-6 w-6" />
                    </div>
                    <div>
                        <p className="text-sm font-medium text-gray-500">To Onboard (Queue)</p>
                        <p className="text-2xl font-bold text-amber-600">{dashboardStats.pendingOnboarding}</p>
                    </div>
                </div>
                <div className="bg-white p-5 rounded-xl border border-green-200 shadow-sm flex items-center gap-4 ring-1 ring-green-50">
                    <div className="p-3 bg-green-100 text-green-600 rounded-lg">
                        <CheckCircle className="h-6 w-6" />
                    </div>
                    <div>
                        <p className="text-sm font-medium text-gray-500">Successfully Onboarded</p>
                        <p className="text-2xl font-bold text-green-600">{dashboardStats.onboarded}</p>
                    </div>
                </div>
            </div>

            <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-4 mb-6">
                <div className="relative">
                    <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" />
                    <input
                        type="text"
                        placeholder="Search queue..."
                        className="w-full pl-10 pr-4 py-2 bg-gray-50 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400 focus:bg-white transition-all"
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                    />
                </div>
            </div>

            <div className="space-y-4">
                {filteredVolunteers.length > 0 ? (
                    filteredVolunteers.map(volunteer => {
                        const isPending = volunteer.onboarding_status === 'pending_onboarding';
                        return (
                            <div key={volunteer.id} className="bg-white rounded-xl shadow-sm border border-gray-200 p-5 flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                                <div className="flex gap-4">
                                    <div className={`w-12 h-12 rounded-full flex items-center justify-center font-bold text-lg shrink-0 ${isPending ? 'bg-amber-100 text-amber-700' : 'bg-green-100 text-green-700'}`}>
                                        {volunteer.first_name?.[0]}{volunteer.last_name?.[0]}
                                    </div>
                                    <div>
                                        <div className="flex flex-col mt-2 md:mt-1 space-y-1">
                                            <h3 className="text-lg font-bold text-gray-900 leading-tight">
                                                {volunteer.first_name} {volunteer.last_name}
                                            </h3>
                                            <div className="flex flex-wrap items-center gap-x-4 gap-y-1 text-sm text-gray-600">
                                                <span className="flex items-center gap-1"><Mail className="h-3.5 w-3.5 text-gray-400" />{volunteer.email}</span>
                                                <span className="flex items-center gap-1"><Phone className="h-3.5 w-3.5 text-gray-400" />{volunteer.mobile_number}</span>
                                                <span className="flex items-center gap-1"><MapPin className="h-3.5 w-3.5 text-gray-400" />{volunteer.city}</span>
                                            </div>

                                            {/* Show preferences inline */}
                                            {isPending && (
                                                <div className="mt-3 p-3 bg-gray-50 rounded-lg border border-gray-100 max-w-2xl">
                                                    <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1.5">Registered Preferences:</p>
                                                    <div className="flex flex-wrap gap-2">
                                                        {volunteer.volunteering_preference1 && <span className="px-2 py-1 bg-white border border-gray-200 rounded text-xs text-gray-700">{volunteer.volunteering_preference1}</span>}
                                                        {volunteer.volunteering_preference2 && <span className="px-2 py-1 bg-white border border-gray-200 rounded text-xs text-gray-700">{volunteer.volunteering_preference2}</span>}
                                                        {volunteer.volunteering_preference3 && <span className="px-2 py-1 bg-white border border-gray-200 rounded text-xs text-gray-700">{volunteer.volunteering_preference3}</span>}
                                                        {!volunteer.volunteering_preference1 && <span className="text-xs text-gray-400 italic">No preferences specified</span>}
                                                    </div>
                                                </div>
                                            )}
                                            
                                            {!isPending && volunteer.assigned_pod && (
                                                 <div className="mt-2 text-sm">
                                                    <span className="text-gray-500 font-medium">Assigned Pod: </span>
                                                    <span className="font-semibold text-indigo-700 bg-indigo-50 px-2 py-0.5 rounded border border-indigo-100">{volunteer.assigned_pod}</span>
                                                 </div>
                                            )}
                                        </div>
                                    </div>
                                </div>
                                
                                <div className="flex flex-col md:flex-row items-center gap-3 w-full md:w-auto mt-4 md:mt-0">
                                        {isPending ? (
                                            <button 
                                                onClick={() => {
                                                    setSelectedVolunteer(volunteer);
                                                    setOnboardingTasks({ contacted: false, introduced: false, explained: false });
                                                    setSelectedProjects([]);
                                                }}
                                                className="w-full md:w-auto px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-lg text-sm shadow-sm transition-colors flex items-center justify-center gap-2"
                                            >
                                                <CheckCircle className="h-4 w-4" /> Assign Pod & Onboard
                                            </button>
                                        ) : (
                                            <>
                                                <div className="px-3 py-1.5 bg-green-50 text-green-700 border border-green-200 rounded-lg text-sm font-medium flex items-center gap-2">
                                                    <CheckCircle className="h-4 w-4" /> Onboarded
                                                </div>
                                                <button 
                                                    onClick={() => {
                                                        setSelectedVolunteer(volunteer);
                                                        setOnboardingTasks({ contacted: true, introduced: true, explained: true });
                                                        setSelectedProjects(
                                                            volunteer.assigned_pod 
                                                                ? projects.filter(p => volunteer.assigned_pod.includes(p.title))
                                                                : []
                                                        );
                                                    }}
                                                    className="w-full md:w-auto px-4 py-1.5 bg-white hover:bg-gray-50 text-blue-600 border border-blue-200 rounded-lg text-sm shadow-sm font-medium transition-colors focus:ring-2 focus:ring-blue-400"
                                                >
                                                    Edit Pods
                                                </button>
                                            </>
                                        )}
                                    </div>
                            </div>
                        );
                    })
                ) : (
                    <div className="text-center py-12 bg-white rounded-lg border border-gray-200">
                        <UserPlus className="h-12 w-12 text-gray-300 mx-auto mb-3" />
                        <h3 className="text-lg font-medium text-gray-900">Queue is empty</h3>
                        <p className="text-gray-500">No volunteers are currently waiting for onboarding.</p>
                    </div>
                )}
            </div>

            {/* Assignment Modal */}
            {selectedVolunteer && (
                <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm transition-all" onClick={() => !isUpdating && setSelectedVolunteer(null)}>
                    <div className="bg-white w-full max-w-lg rounded-2xl shadow-2xl animate-in fade-in zoom-in-95 duration-200 overflow-hidden" onClick={e => e.stopPropagation()}>
                        <div className="bg-blue-50 border-b border-blue-100 p-5">
                            <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                                <UserPlus className="h-6 w-6 text-blue-600" /> 
                                {selectedVolunteer.onboarding_status === 'onboarded' ? 'Edit Pod Assignment' : 'Finalize Onboarding'}
                            </h2>
                            <p className="text-sm text-gray-600 mt-1">Assign <span className="font-semibold text-gray-900">{selectedVolunteer.first_name} {selectedVolunteer.last_name}</span> to a Pod based on their preferences and interview.</p>
                        </div>
                        
                        <div className="p-6 space-y-5">
                            <div className="bg-gray-50 p-4 rounded-xl border border-gray-200 space-y-2">
                                <p className="text-xs font-bold text-gray-500 uppercase tracking-wider">Volunteer Selected Preferences</p>
                                <ul className="list-disc pl-5 text-sm font-medium text-gray-800 space-y-1">
                                    <li>{selectedVolunteer.volunteering_preference1 || 'None specified'}</li>
                                    {selectedVolunteer.volunteering_preference2 && <li>{selectedVolunteer.volunteering_preference2}</li>}
                                    {selectedVolunteer.volunteering_preference3 && <li>{selectedVolunteer.volunteering_preference3}</li>}
                                </ul>
                            </div>

                            {/* Checklist */}
                            {selectedVolunteer.onboarding_status !== 'onboarded' && (
                                <div>
                                    <h3 className="text-sm font-bold text-gray-700 mb-3 border-b border-gray-100 pb-2">Onboarding Checklist</h3>
                                    <div className="space-y-3">
                                        <label className="flex items-center gap-3 cursor-pointer p-2 hover:bg-gray-50 rounded-lg transition-colors border border-transparent hover:border-gray-200">
                                            <input type="checkbox" className="w-5 h-5 rounded border-gray-300 text-blue-600 focus:ring-blue-500" checked={onboardingTasks.contacted} onChange={(e) => setOnboardingTasks(prev => ({...prev, contacted: e.target.checked}))} />
                                            <span className="text-sm font-medium text-gray-800 tracking-tight">Contact the volunteer</span>
                                        </label>
                                        <label className="flex items-center gap-3 cursor-pointer p-2 hover:bg-gray-50 rounded-lg transition-colors border border-transparent hover:border-gray-200">
                                            <input type="checkbox" className="w-5 h-5 rounded border-gray-300 text-blue-600 focus:ring-blue-500" checked={onboardingTasks.introduced} onChange={(e) => setOnboardingTasks(prev => ({...prev, introduced: e.target.checked}))} />
                                            <span className="text-sm font-medium text-gray-800 tracking-tight">Introduce them to the organization</span>
                                        </label>
                                        <label className="flex items-center gap-3 cursor-pointer p-2 hover:bg-gray-50 rounded-lg transition-colors border border-transparent hover:border-gray-200">
                                            <input type="checkbox" className="w-5 h-5 rounded border-gray-300 text-blue-600 focus:ring-blue-500" checked={onboardingTasks.explained} onChange={(e) => setOnboardingTasks(prev => ({...prev, explained: e.target.checked}))} />
                                            <span className="text-sm font-medium text-gray-800 tracking-tight">Explain the different pods and their work</span>
                                        </label>
                                    </div>
                                </div>
                            )}

                            {/* Assigned Pod Select - only show if checklist is done */}
                            {(onboardingTasks.contacted && onboardingTasks.introduced && onboardingTasks.explained) && (
                                <div className="animate-in slide-in-from-top-2 fade-in duration-300">
                                    <label className="block text-sm font-bold text-gray-700 mb-2">Assign to Pod / Project <span className="text-red-500">*</span></label>
                                    <div className="bg-white border text-sm border-gray-300 rounded-lg max-h-48 overflow-y-auto w-full p-2 space-y-1">
                                        {projects.length > 0 ? projects.map(p => (
                                            <label key={p.id} className="flex items-start md:items-center gap-3 p-2 hover:bg-blue-50/50 rounded-lg cursor-pointer transition-colors">
                                                <input 
                                                    type="checkbox" 
                                                    className="w-4 h-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500 mt-0.5 md:mt-0"
                                                    checked={selectedProjects.some(sp => sp.id === p.id)}
                                                    onChange={(e) => {
                                                        if (e.target.checked) setSelectedProjects([...selectedProjects, p]);
                                                        else setSelectedProjects(selectedProjects.filter(sp => sp.id !== p.id));
                                                    }}
                                                />
                                                <span className="font-medium text-gray-800">{p.title}</span>
                                            </label>
                                        )) : (
                                            <div className="p-3 text-center text-gray-500 italic text-sm">No projects found.</div>
                                        )}
                                    </div>
                                    <p className="text-xs text-gray-500 mt-2">The Assigned Pod column in the Master Sheet will automatically update. You can assign them to multiple projects.</p>
                                </div>
                            )}
                        </div>

                        <div className="p-5 border-t border-gray-100 bg-gray-50 flex gap-3 justify-end">
                            <button 
                                onClick={() => setSelectedVolunteer(null)}
                                disabled={isUpdating}
                                className="px-4 py-2 text-gray-700 bg-white border border-gray-300 hover:bg-gray-50 font-medium rounded-lg transition-colors disabled:opacity-50"
                            >
                                Cancel
                            </button>
                            <button 
                                onClick={() => handleFinalizeOnboarding(selectedVolunteer.id, selectedProjects)}
                                disabled={isUpdating || !(onboardingTasks.contacted && onboardingTasks.introduced && onboardingTasks.explained) || selectedProjects.length === 0}
                                className="px-5 py-2 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-lg shadow-sm transition-colors flex items-center justify-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed min-w-[160px]"
                            >
                                {isUpdating ? (
                                    <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-white"></div>
                                ) : (
                                    <>
                                        <CheckCircle className="h-5 w-5" /> 
                                        {selectedVolunteer.onboarding_status === 'onboarded' ? 'Save Assignments' : 'Confirm & Onboard'}
                                    </>
                                )}
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

export default OnboardingHub;
