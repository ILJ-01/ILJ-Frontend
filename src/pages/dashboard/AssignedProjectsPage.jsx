import { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import { useAuth } from "@/context/AuthContext";
import { supabase } from "@/lib/supabase";
import { Briefcase, Calendar, ChevronRight, CalendarPlus, Clock, MapPin } from "lucide-react";
import { downloadICS } from "@/lib/ics";

export default function AssignedProjectsPage() {
    const { user } = useAuth();
    const [assignedProjects, setAssignedProjects] = useState([]);
    const [events, setEvents] = useState([]);
    const [interestedEventIds, setInterestedEventIds] = useState(new Set());
    const [loading, setLoading] = useState(true);
    const [activeTab, setActiveTab] = useState("pods"); // pods or events

    useEffect(() => {
        if (user) fetchAssignedProjectsAndEvents();
    }, [user]);

    const fetchAssignedProjectsAndEvents = async () => {
        setLoading(true);
        try {
            // 1. Fetch the user's specific assigned pods from the master db (volunteers table)
            const { data: volunteerData, error: volError } = await supabase
                .from('volunteers')
                .select('assigned_pod')
                .eq('id', user.id)
                .single();
            
            if (volError) {
                console.error("Error fetching volunteer record:", volError);
            }

            const assignedPodString = volunteerData?.assigned_pod || '';
            
            if (!assignedPodString.trim()) {
                setAssignedProjects([]);
                setEvents([]);
                return;
            }

            // The assigned_pod is expected to be a string, possibly comma-separated
            const podNames = assignedPodString.split(',').map(s => s.trim()).filter(Boolean);

            // 2. Fetch the actual project data for those matched pods
            let projectsQuery = supabase.from('projects').select('*').in('title', podNames);
            if (!user?.isITAdmin) {
                projectsQuery = projectsQuery.neq('status', 'archived');
            }
            const { data: projectsData, error: projectsError } = await projectsQuery;

            if (projectsError) {
                console.error("Error fetching projects:", projectsError);
            }
            
            const projects = projectsData || [];
            setAssignedProjects(projects);

            if (projects.length > 0) {
                const projectIds = projects.map(p => p.id);
                const today = new Date();
                today.setHours(0, 0, 0, 0);

                const [eventsRes, interestsRes] = await Promise.all([
                    supabase
                        .from('events')
                        .select('*')
                        .in('project_id', projectIds)
                        .gte('date', today.toISOString())
                        .order('date', { ascending: true }),
                    supabase
                        .from('event_interests')
                        .select('event_id')
                        .eq('volunteer_id', user.id)
                ]);

                if (eventsRes.data) setEvents(eventsRes.data);
                if (interestsRes.data) setInterestedEventIds(new Set(interestsRes.data.map(i => i.event_id)));
            }

        } catch (error) {
            console.error("Fetch Data Error:", error);
            setAssignedProjects([]);
            setEvents([]);
        } finally {
            setLoading(false);
        }
    };

    const handleVolunteer = async (eventId) => {
        try {
            const { data, error } = await supabase.rpc('register_event_interest', {
                p_event_id: eventId,
                p_volunteer_id: user.id
            });

            if (error) throw error;

            if (!data.success) {
                if (data.message === 'Already interested') {
                    alert("You have already marked your interest for this event.");
                } else {
                    throw new Error(data.error || 'Unknown error');
                }
            } else {
                alert("You're marked as interested");
                setInterestedEventIds(prev => new Set(prev).add(eventId));
            }
        } catch (e) {
            console.error("Volunteer Error:", e);
            alert("Action failed. Please try again.");
        }
    };

    const handleRevokeInterest = async (eventId) => {
        if (!confirm("Are you sure you want to revoke your interest for this event?")) return;
        try {
            const { data, error } = await supabase.rpc('revoke_event_interest', {
                p_event_id: eventId,
                p_volunteer_id: user.id
            });

            if (error) throw error;

            if (!data.success) {
                throw new Error(data.error || 'Unknown error');
            }

            alert("Interest revoked.");
            setInterestedEventIds(prev => {
                const updated = new Set(prev);
                updated.delete(eventId);
                return updated;
            });
        } catch (e) {
            console.error("Revoke Interest Error:", e);
            alert("Action failed. Please try again.");
        }
    };

    return (
        <div className="space-y-6 animate-fade-in">
            <div>
                <h2 className="text-2xl md:text-3xl font-bold font-serif text-gray-900">Pods</h2>
                <p className="text-gray-500 mt-2">View and manage the pods you are currently assigned to.</p>
            </div>

            {/* Tabs */}
            <div className="flex space-x-1 bg-white p-1 rounded-xl shadow-sm border border-gray-200 w-fit">
                <button
                    onClick={() => setActiveTab("pods")}
                    className={`px-6 py-2.5 rounded-lg text-sm font-semibold transition-all ${
                        activeTab === "pods"
                            ? "bg-[#ae2b2b] text-white shadow-md"
                            : "text-gray-600 hover:bg-gray-50"
                    }`}
                >
                    Assigned Pods
                </button>
                <button
                    onClick={() => setActiveTab("events")}
                    className={`px-6 py-2.5 rounded-lg text-sm font-semibold transition-all ${
                        activeTab === "events"
                            ? "bg-[#ae2b2b] text-white shadow-md"
                            : "text-gray-600 hover:bg-gray-50"
                    }`}
                >
                    Upcoming Events
                </button>
            </div>

            {loading ? (
                <div className="flex justify-center p-12">
                    <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-[#ae2b2b]"></div>
                </div>
            ) : activeTab === "pods" ? (
                assignedProjects.length === 0 ? (
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-16 text-center">
                        <Briefcase className="h-12 w-12 text-gray-300 mx-auto mb-3" />
                        <p className="text-gray-500 font-medium text-lg">You currently aren't assigned to any pods.</p>
                    </div>
                ) : (
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        {assignedProjects.map(project => (
                            <div key={project.id} className="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden hover:shadow-xl hover:border-[#ae2b2b]/30 transition-all flex flex-col group">
                                {project.banner_url ? (
                                    <div className="h-48 overflow-hidden relative">
                                        <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent z-10"></div>
                                        <img 
                                            src={project.banner_url} 
                                            alt={project.title} 
                                            className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-700"
                                        />
                                        <div className="absolute bottom-4 left-4 z-20">
                                            <span className="text-xs font-bold uppercase tracking-wider text-white bg-[#ae2b2b] px-3 py-1 rounded">
                                                {project.project_code || 'General'}
                                            </span>
                                        </div>
                                    </div>
                                ) : (
                                    <div className="h-32 bg-gray-50 flex items-center justify-center border-b border-gray-100">
                                        <span className="text-xs font-bold uppercase tracking-wider text-gray-600 bg-gray-200 px-3 py-1 rounded">
                                                {project.project_code || 'General'}
                                        </span>
                                    </div>
                                )}
                                <div className="p-6 flex-1 flex flex-col">
                                    <div className="flex justify-between items-start mb-2">
                                        <h3 className="text-lg font-bold text-gray-900 group-hover:text-[#ae2b2b] transition-colors">{project.title}</h3>
                                    </div>
                                    
                                    <span className={`w-fit text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded border mb-4
                                            ${project.status === 'upcoming' ? 'bg-amber-50 text-amber-600 border-amber-200' : 
                                            (project.status === 'completed' ? 'bg-green-50 text-green-600 border-green-200' : 'bg-blue-50 text-blue-600 border-blue-200')}
                                        `}>
                                        {project.status ? project.status.replace('_', ' ') : 'Active'}
                                    </span>

                                    <p className="text-gray-600 text-sm line-clamp-3 mb-6 flex-1">{project.description}</p>
                                    
                                    {project.next_event_date && (
                                         <div className="flex items-center justify-between gap-2 text-sm text-gray-600 mb-6 bg-gray-50/80 p-3 rounded-xl border border-gray-100">
                                             <div className="flex items-center gap-2">
                                                 <Calendar className="h-4 w-4 text-[#ae2b2b]" />
                                                 <span className="font-medium">Next Event: <span className="text-gray-900">
                                                     {isNaN(Date.parse(project.next_event_date)) || project.next_event_date.toLowerCase().includes('august') ? project.next_event_date : new Date(project.next_event_date).toLocaleDateString()}
                                                 </span></span>
                                             </div>
                                             {!isNaN(Date.parse(project.next_event_date)) && !project.next_event_date.toLowerCase().includes('august') && (
                                                 <button 
                                                     onClick={(e) => {
                                                         e.preventDefault();
                                                         const event = {
                                                             title: `${project.title} Event`,
                                                             description: project.description,
                                                             startTime: new Date(project.next_event_date),
                                                             endTime: new Date(project.next_event_date)
                                                         };
                                                         downloadICS(event, `${project.title.replace(/\s+/g, '_')}_event.ics`);
                                                     }}
                                                     className="text-xs text-blue-600 hover:text-blue-800 hover:underline flex items-center gap-1 transition-colors"
                                                 >
                                                     <CalendarPlus className="h-3 w-3" /> Add to Calendar
                                                 </button>
                                             )}
                                         </div>
                                     )}
                                    
                                    <Link 
                                        to={`/project/${project.id}`}
                                        className="w-full py-3 px-4 bg-gray-50 hover:bg-[#ae2b2b] hover:border-[#ae2b2b] hover:text-white text-[#ae2b2b] font-semibold rounded-xl transition-all flex items-center justify-center gap-2 border border-[#ae2b2b]/20"
                                    >
                                        View Pod <ChevronRight className="h-4 w-4" />
                                    </Link>
                                </div>
                            </div>
                        ))}
                    </div>
                )
            ) : (
                events.length === 0 ? (
                    <div className="col-span-full text-center py-12 bg-white rounded-xl border border-dashed border-gray-300">
                        <Calendar className="h-12 w-12 text-gray-300 mx-auto mb-3" />
                        <p className="text-gray-500">No upcoming events for your assigned pods at the moment.</p>
                    </div>
                ) : (
                    <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
                        {events.map(event => {
                            const isInterested = interestedEventIds.has(event.id);
                            return (
                                <div key={event.id} className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden hover:shadow-md transition-all flex flex-col">
                                    <div className="h-48 bg-gray-100 relative group overflow-hidden">
                                        {event.banner_url ? (
                                            <img
                                                src={event.banner_url}
                                                alt={event.title}
                                                className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"
                                            />
                                        ) : (
                                            <div className="w-full h-full bg-[#ae2b2b]/5 flex items-center justify-center">
                                                <div className="text-center">
                                                    <span className="block text-3xl font-bold text-[#ae2b2b]">{new Date(event.date).getDate()}</span>
                                                    <span className="text-sm font-semibold uppercase text-[#ae2b2b] tracking-wider">
                                                        {new Date(event.date).toLocaleString('default', { month: 'long', year: 'numeric' })}
                                                    </span>
                                                </div>
                                            </div>
                                        )}
                                        {/* Date overlay when image is present */}
                                        {event.banner_url && (
                                            <div className="absolute top-3 right-3 bg-white/90 backdrop-blur-sm px-3 py-1.5 rounded-lg shadow-sm text-center min-w-[60px]">
                                                <span className="block text-xl font-bold text-gray-900 leading-none">{new Date(event.date).getDate()}</span>
                                                <span className="text-[10px] font-bold uppercase text-gray-600 leading-none">{new Date(event.date).toLocaleString('default', { month: 'short' })}</span>
                                            </div>
                                        )}
                                    </div>
                                    <div className="p-5 flex-1 flex flex-col">
                                        <h3 className="text-xl font-bold text-gray-900 mb-2">{event.title}</h3>
                                        <p className="text-gray-600 text-sm mb-4 line-clamp-3 flex-1">{event.description}</p>

                                        <div className="flex flex-col gap-2 mb-4">
                                            <div className="flex items-center gap-2 text-sm text-gray-500">
                                                <Clock className="h-4 w-4" />
                                                <span>
                                                    {new Date(event.date).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                                                </span>
                                            </div>
                                            {event.role_needed && (
                                                <div className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800 w-fit">
                                                    Role: {event.role_needed}
                                                </div>
                                            )}
                                        </div>
                                        
                                        <button 
                                            onClick={(e) => {
                                                e.preventDefault();
                                                const icsEvent = {
                                                    title: event.title,
                                                    description: event.description,
                                                    startTime: new Date(event.date),
                                                    endTime: new Date(event.date)
                                                };
                                                downloadICS(icsEvent, `${event.title.replace(/\\s+/g, '_')}.ics`);
                                            }}
                                            className="mb-4 text-xs font-bold px-4 py-2 bg-blue-50 text-blue-700 hover:bg-blue-100 rounded-lg flex items-center justify-center gap-2 transition-colors w-full"
                                        >
                                            <CalendarPlus className="h-4 w-4" /> Add to Calendar
                                        </button>

                                        <button
                                            onClick={() => isInterested ? handleRevokeInterest(event.id) : handleVolunteer(event.id)}
                                            className={`w-full py-2.5 font-medium rounded-lg transition-colors shadow-sm ${isInterested
                                                ? "bg-red-50 text-red-600 border border-red-200 hover:bg-red-100"
                                                : "bg-[#ae2b2b] text-white hover:bg-[#8b1e1e]"
                                                }`}
                                        >
                                            {isInterested ? "✕ Revoke Interest" : "I am interested to volunteer"}
                                        </button>
                                    </div>
                                </div>
                            );
                        })}
                    </div>
                )
            )}
        </div>
    );
}
