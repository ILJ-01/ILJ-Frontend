import { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import { useAuth } from "@/context/AuthContext";
import { supabase } from "@/lib/supabase";
import { Briefcase, Calendar, ChevronRight, CalendarPlus } from "lucide-react";
import { downloadICS } from "@/lib/ics";
export default function AssignedProjectsPage() {
    const { user } = useAuth();
    const [assignedProjects, setAssignedProjects] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        if (user) fetchAssignedProjects();
    }, [user]);

    const fetchAssignedProjects = async () => {
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
                return;
            }

            // The assigned_pod is expected to be a string, possibly comma-separated
            const podNames = assignedPodString.split(',').map(s => s.trim()).filter(Boolean);

            // 2. Fetch the actual project data for those matched pods
            const { data: projectsData, error: projectsError } = await supabase
                .from('projects')
                .select('*')
                .in('title', podNames);

            if (projectsError) {
                console.error("Error fetching projects:", projectsError);
            }
            
            setAssignedProjects(projectsData || []);
        } catch (error) {
            console.error("Fetch Data Error:", error);
            setAssignedProjects([]);
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="space-y-6 animate-fade-in">
            <div>
                <h2 className="text-2xl md:text-3xl font-bold font-serif text-gray-900">Assigned Pods</h2>
                <p className="text-gray-500 mt-2">View and manage the pods you are currently assigned to.</p>
            </div>

            {loading ? (
                <div className="flex justify-center p-12">
                    <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-[#ae2b2b]"></div>
                </div>
            ) : assignedProjects.length === 0 ? (
                <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-16 text-center">
                    <Briefcase className="h-12 w-12 text-gray-300 mx-auto mb-3" />
                    <p className="text-gray-500 font-medium text-lg">You currently aren't assigned to any projects.</p>
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
                                            <span className="font-medium">Next Event: <span className="text-gray-900">{new Date(project.next_event_date).toLocaleDateString()}</span></span>
                                        </div>
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
                                    </div>
                                )}
                                
                                <Link 
                                    to={`/project/${project.id}`}
                                    className="w-full py-3 px-4 bg-gray-50 hover:bg-[#ae2b2b] hover:border-[#ae2b2b] hover:text-white text-[#ae2b2b] font-semibold rounded-xl transition-all flex items-center justify-center gap-2 border border-[#ae2b2b]/20"
                                >
                                    View Project <ChevronRight className="h-4 w-4" />
                                </Link>
                            </div>
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
}
