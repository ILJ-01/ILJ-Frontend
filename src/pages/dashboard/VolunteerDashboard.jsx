import { useState, useEffect } from "react";
import { useAuth } from "@/context/AuthContext";
import { supabase } from "@/lib/supabase";
import {
    Calendar, CheckCircle, Clock, Award,
    ArrowRight, Activity, Briefcase, Lightbulb, Send, Loader2
} from "lucide-react";
import { Link } from "react-router-dom";

export default function VolunteerDashboard() {
    const { user } = useAuth();
    const [stats, setStats] = useState({
        totalHours: 0,
        pendingTasks: 0,
        upcomingEventsCount: 0,
        level: "Active Volunteer"
    });
    const [upcomingEvents, setUpcomingEvents] = useState([]);
    const [myTasks, setMyTasks] = useState([]);
    const [announcements, setAnnouncements] = useState([]);
    const [opportunities, setOpportunities] = useState([]);
    const [loading, setLoading] = useState(true);

    // Idea states
    const [projects, setProjects] = useState([]);
    const [myIdeas, setMyIdeas] = useState([]);
    const [assignedProjects, setAssignedProjects] = useState([]);
    const [ideaForm, setIdeaForm] = useState({ title: '', description: '', project_id: '' });
    const [submittingIdea, setSubmittingIdea] = useState(false);
    const [showIdeaForm, setShowIdeaForm] = useState(false);

    useEffect(() => {
        if (user?.id) fetchDashboardData();
    }, [user]);

    const fetchDashboardData = async () => {
        try {
            setLoading(true);

            // 1. Total Hours
            const { data: timesheets } = await supabase
                .from('timesheets')
                .select('hours')
                .eq('volunteer_id', user.id)
                .eq('status', 'approved');

            const hours = timesheets?.reduce((acc, curr) => acc + (curr.hours || 0), 0) || 0;

            // 2. Pending Tasks
            const { count: taskCount } = await supabase
                .from('tasks')
                .select('*', { count: 'exact', head: true })
                .eq('assignee_id', user.id)
                .neq('status', 'completed');

            // 3. Upcoming Events
            const { data: events } = await supabase
                .from('events')
                .select('*')
                .gte('date', new Date().toISOString())
                .order('date', { ascending: true })
                .limit(3);

            // 4. Tasks List
            const { data: tasks } = await supabase
                .from('tasks')
                .select('*, project:projects(title)')
                .eq('assignee_id', user.id)
                .neq('status', 'completed')
                .limit(4);

            // 5. Announcements (General)
            const { data: activeAnnouncements } = await supabase
                .from('announcements')
                .select('*')
                .eq('type', 'general') // Assuming default type is general or similar
                .order('created_at', { ascending: false })
                .limit(3);

            // 6. Task Opportunities
            const { data: opps } = await supabase
                .from('announcements')
                .select(`*, project:projects(title), interests:announcement_interests(volunteer_id)`)
                .eq('type', 'task_opportunity')
                .order('created_at', { ascending: false });

            setStats({
                totalHours: hours,
                pendingTasks: taskCount || 0,
                upcomingEventsCount: events?.length || 0,
                level: hours > 50 ? "Core Volunteer" : "Active Volunteer"
            });
            setUpcomingEvents(events || []);
            setMyTasks(tasks || []);
            setAnnouncements(activeAnnouncements || []);

            // Process opportunities to check if user already interested
            const processedOpps = opps?.map(o => ({
                ...o,
                alreadyInterested: o.interests?.some(i => i.volunteer_id === user.id)
            })) || [];
            setOpportunities(processedOpps);

            // 7. Fetch projects for idea form
            let projectsQuery = supabase.from('projects').select('id, title');
            if (!user?.isITAdmin) {
                projectsQuery = projectsQuery.neq('status', 'archived');
            }
            const { data: projectData } = await projectsQuery.order('title');
            setProjects(projectData || []);

            // 8. Fetch my ideas
            const { data: ideasData } = await supabase
                .from('ideas')
                .select('*, project:projects(title)')
                .eq('submitted_by', user.id)
                .order('created_at', { ascending: false });
            setMyIdeas(ideasData || []);

            // 9. Fetch assigned projects
            const { data: assignedProjectsData, error: assignedError } = await supabase
                .from('project_volunteers')
                .select('projects(*)')
                .eq('volunteer_id', user.id);
            
            if (assignedError) {
                console.error("Error fetching assigned projects:", assignedError);
            }
            
            setAssignedProjects(
                assignedProjectsData
                    ?.map(ap => ap.projects || ap.project)
                    .filter(Boolean)
                    .filter(p => user?.isITAdmin || p.status !== 'archived') || []
            );

        } catch (error) {
            console.error("Dashboard Load Error:", error);
        } finally {
            setLoading(false);
        }
    };

    const handleInterest = async (eventId) => {
        try {
            const { data, error } = await supabase.rpc('register_event_interest', {
                p_event_id: eventId,
                p_volunteer_id: user.id
            });

            if (error) throw error;

            if (!data.success) {
                if (data.message === 'Already interested') {
                    alert("You have already marked your interest for this event.");
                } else throw new Error(data.error || 'Unknown error');
            } else {
                // Optimistic update
                setUpcomingEvents(prev => prev.map(e => e.id === eventId ? { ...e, interested: true } : e));
                alert("Marked as interested!");
            }
        } catch (e) {
            console.error("Interest Error:", e);
        }
    };

    const handleOpportunityInterest = async (announcementId) => {
        try {
            const announcement = opportunities.find(o => o.id === announcementId);

            const { data, error } = await supabase.rpc('register_announcement_interest', {
                p_announcement_id: announcementId,
                p_volunteer_id: user.id
            });

            if (error) throw error;

            if (!data.success) {
                if (data.message === 'Already interested') {
                    alert("You have already expressed interest in this opportunity.");
                    return;
                }
                throw new Error(data.error || 'Unknown error');
            }

            // Notify Manager
            if (announcement?.created_by) {
                await supabase.from('notifications').insert({
                    user_id: announcement.created_by,
                    message: `${user.first_name} ${user.last_name} is interested in: ${announcement.title}`,
                    is_read: false
                });
            }

            setOpportunities(prev => prev.map(o => o.id === announcementId ? { ...o, alreadyInterested: true } : o));
            alert("Thanks! The project manager has been notified of your interest.");
        } catch (e) {
            console.error("Interest Error:", e);
            alert("Could not mark interest. Please try again.");
        }
    };

    const handleSubmitIdea = async (e) => {
        e.preventDefault();
        if (!ideaForm.title.trim() || !ideaForm.description.trim()) {
            alert('Please fill in the title and description.');
            return;
        }

        setSubmittingIdea(true);
        try {
            const { data, error } = await supabase
                .from('ideas')
                .insert({
                    title: ideaForm.title.trim(),
                    description: ideaForm.description.trim(),
                    project_id: ideaForm.project_id || null,
                    submitted_by: user.id
                })
                .select('*, project:projects(title)')
                .single();

            if (error) throw error;

            setMyIdeas(prev => [data, ...prev]);
            setIdeaForm({ title: '', description: '', project_id: '' });
            setShowIdeaForm(false);
            alert('Your idea has been submitted successfully! 🎉');
        } catch (err) {
            console.error('Idea Submit Error:', err);
            alert('Failed to submit idea. Please try again.');
        } finally {
            setSubmittingIdea(false);
        }
    };

    if (loading) return (
        <div className="flex justify-center items-center h-96">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-[#ae2b2b]"></div>
        </div>
    );

    return (
        <div className="space-y-6 animate-in fade-in slide-in-from-bottom-4 duration-500">

            {/* Project Manager Access Banner */}
            {user.managed_projects?.length > 0 && (
                <div className="bg-gray-900 rounded-2xl p-6 md:p-8 text-white shadow-xl flex flex-col md:flex-row items-start md:items-center justify-between gap-6 border border-gray-800">
                    <div>
                        <div className="flex items-center gap-2 mb-2">
                            <div className="bg-[#ae2b2b] p-1.5 rounded"><Briefcase size={16} className="text-white" /></div>
                            <span className="text-xs font-bold uppercase tracking-widest text-gray-400">Manager Access</span>
                        </div>
                        <h2 className="text-xl md:text-2xl font-bold font-serif">You are managing {user.managed_projects.length} Project{user.managed_projects.length !== 1 ? 's' : ''}</h2>
                        <p className="text-gray-400 mt-1 max-w-xl">Access your manager hub to assign tasks to volunteers and approve timesheets for your assigned projects.</p>
                    </div>
                    <Link
                        to="/dashboard/manager"
                        className="whitespace-nowrap px-6 py-3 bg-white text-gray-900 rounded-lg font-bold hover:bg-gray-100 transition-colors shadow-lg flex items-center gap-2"
                    >
                        Go to Manager Hub <ArrowRight size={18} />
                    </Link>
                </div>
            )}

            {/* Welcome Section */}
            <div className="bg-gradient-to-r from-[#ae2b2b] to-[#5c1212] rounded-2xl p-6 md:p-8 text-white shadow-lg">
                <h2 className="text-2xl md:text-3xl font-bold font-serif mb-2">Welcome, {user.first_name} 👋</h2>
                <div className="flex flex-wrap gap-6 mt-4 text-white/90">
                    <div className="flex items-center gap-2 bg-white/20 px-4 py-2 rounded-lg backdrop-blur-sm">
                        <Clock className="h-5 w-5" />
                        <span className="font-medium">{stats.totalHours} Hours Contributed</span>
                    </div>
                    <div className="flex items-center gap-2 bg-white/20 px-4 py-2 rounded-lg backdrop-blur-sm">
                        <Award className="h-5 w-5" />
                        <span className="font-medium">{stats.level}</span>
                    </div>
                </div>
            </div>

            {/* Quick Stats Grid */}
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                <StatsCard
                    icon={Calendar}
                    title="Upcoming Events"
                    value={stats.upcomingEventsCount}
                    label="Next event you can help"
                    color="bg-blue-50 text-blue-600"
                />
                <StatsCard
                    icon={CheckCircle}
                    title="My Tasks"
                    value={stats.pendingTasks}
                    label="Pending tasks"
                    color="bg-purple-50 text-purple-600"
                />
                <StatsCard
                    icon={Clock}
                    title="Total Hours"
                    value={stats.totalHours}
                    label="Approved contributions"
                    color="bg-green-50 text-green-600"
                />
                <StatsCard
                    icon={Activity}
                    title="Contribution"
                    value={stats.level}
                    label="Current Level"
                    color="bg-[#ae2b2b]/5 text-[#ae2b2b]"
                />
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">

                {/* Upcoming Events Column */}
                <div className="lg:col-span-2 space-y-6">
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <div className="flex justify-between items-center mb-6">
                            <h3 className="text-lg font-bold text-gray-800 flex items-center gap-2">
                                <Calendar className="h-5 w-5 text-[#ae2b2b]" /> Upcoming Events
                            </h3>
                            <Link to="/dashboard/events" className="text-sm text-[#ae2b2b] hover:underline font-medium flex items-center gap-1">
                                View All <ArrowRight className="h-4 w-4" />
                            </Link>
                        </div>

                        {upcomingEvents.length === 0 ? (
                            <p className="text-gray-500 text-center py-8">No upcoming events scheduled.</p>
                        ) : (
                            <div className="space-y-4">
                                {upcomingEvents.map(event => (
                                    <div key={event.id} className="flex flex-col sm:flex-row gap-4 p-4 rounded-xl border border-gray-100 bg-gray-50 hover:bg-white hover:shadow-md transition-all">
                                        <div className="bg-white rounded-lg p-3 text-center min-w-[80px] border border-gray-200 shadow-sm flex flex-col justify-center">
                                            <span className="block text-2xl font-bold text-[#ae2b2b]">
                                                {new Date(event.date).getDate()}
                                            </span>
                                            <span className="text-xs uppercase font-bold text-gray-500">
                                                {new Date(event.date).toLocaleString('default', { month: 'short' })}
                                            </span>
                                        </div>
                                        <div className="flex-1">
                                            <h4 className="font-bold text-gray-900">{event.title}</h4>
                                            <p className="text-sm text-gray-600 mt-1 line-clamp-2">{event.description}</p>
                                            <div className="flex items-center gap-2 mt-3">
                                                <span className="text-xs font-semibold bg-blue-100 text-blue-700 px-2 py-1 rounded">
                                                    Role: {event.role_needed || 'Volunteer'}
                                                </span>
                                            </div>
                                        </div>
                                        <div className="flex items-center">
                                            <button
                                                onClick={() => handleInterest(event.id)}
                                                className="w-full sm:w-auto px-4 py-2 bg-[#ae2b2b] hover:bg-[#8b1e1e] text-white text-sm font-medium rounded-lg transition-colors shadow-sm"
                                            >
                                                Volunteer
                                            </button>
                                        </div>
                                    </div>
                                ))}
                            </div>
                        )}
                    </div>

                    {/* Volunteer Opportunities */}
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <div className="flex justify-between items-center mb-6">
                            <h3 className="text-lg font-bold text-gray-800 flex items-center gap-2">
                                <Briefcase className="h-5 w-5 text-[#ae2b2b]" /> Volunteer Opportunities
                            </h3>
                        </div>

                        {opportunities.length === 0 ? (
                            <p className="text-gray-500 text-center py-8">No open opportunities at the moment.</p>
                        ) : (
                            <div className="space-y-4">
                                {opportunities.map(opp => (
                                    <div key={opp.id} className="p-4 rounded-xl border border-purple-100 bg-purple-50 hover:bg-white hover:shadow-md transition-all">
                                        <div className="flex justify-between items-start">
                                            <div>
                                                <div className="flex items-center gap-2 mb-1">
                                                    <span className="text-xs font-bold uppercase tracking-wider text-purple-700 bg-purple-100 px-2 py-0.5 rounded">
                                                        {opp.project?.title || 'General Opportunity'}
                                                    </span>
                                                    <span className="text-xs text-gray-500">{new Date(opp.created_at).toLocaleDateString()}</span>
                                                </div>
                                                <h4 className="font-bold text-gray-900 text-lg">{opp.title}</h4>
                                                <p className="text-gray-600 text-sm mt-2">{opp.message}</p>

                                                {opp.deadline && (
                                                    <p className="text-xs text-red-600 mt-2 font-medium">Deadline: {new Date(opp.deadline).toLocaleDateString()}</p>
                                                )}
                                            </div>
                                            <button
                                                onClick={() => handleOpportunityInterest(opp.id)}
                                                disabled={opp.alreadyInterested}
                                                className={`px-4 py-2 text-sm font-medium rounded-lg transition-colors shadow-sm whitespace-nowrap ml-4 ${opp.alreadyInterested
                                                    ? 'bg-green-100 text-green-700 cursor-default'
                                                    : 'bg-purple-600 hover:bg-purple-700 text-white'
                                                    }`}
                                            >
                                                {opp.alreadyInterested ? 'Interested' : 'I\'m Interested'}
                                            </button>
                                        </div>
                                    </div>
                                ))}
                            </div>
                        )}
                    </div>

                    {/* Announcements */}
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <h3 className="text-lg font-bold text-gray-800 mb-4 flex items-center gap-2">
                            <Activity className="h-5 w-5 text-[#ae2b2b]" /> Announcements
                        </h3>
                        {announcements.length === 0 ? (
                            <p className="text-gray-500 text-center py-4">No new announcements.</p>
                        ) : (
                            <div className="space-y-4">
                                {announcements.map(ann => (
                                    <div key={ann.id} className="p-4 bg-[#ae2b2b]/5 rounded-lg border border-[#ae2b2b]/20">
                                        <h4 className="font-bold text-[#ae2b2b]">{ann.title}</h4>
                                        <p className="text-[#5c1212] text-sm mt-1">{ann.message}</p>
                                        <span className="text-xs text-[#ae2b2b]/70 mt-2 block">{new Date(ann.created_at).toLocaleDateString()}</span>
                                    </div>
                                ))}
                            </div>
                        )}
                    </div>
                </div>

                {/* Right Side Column */}
                <div className="space-y-6">
                    {/* My Tasks Column */}
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 h-fit">
                        <div className="flex justify-between items-center mb-6">
                        <h3 className="text-lg font-bold text-gray-800 flex items-center gap-2">
                            <CheckCircle className="h-5 w-5 text-[#ae2b2b]" /> My Tasks
                        </h3>
                        <Link to="/dashboard/tasks" className="text-sm text-[#ae2b2b] hover:underline font-medium">See All</Link>
                    </div>

                    {myTasks.length === 0 ? (
                        <div className="text-center py-10 bg-gray-50 rounded-lg border border-dashed border-gray-200">
                            <CheckCircle className="h-8 w-8 text-gray-300 mx-auto mb-2" />
                            <p className="text-gray-500 text-sm">No pending tasks. Great job!</p>
                        </div>
                    ) : (
                        <div className="space-y-3">
                            {myTasks.map(task => (
                                <div key={task.id} className="p-3 bg-white border border-gray-200 hover:border-[#ae2b2b]/50 rounded-lg shadow-sm transition-all group">
                                    <div className="flex justify-between items-start mb-1">
                                        <span className="text-xs font-semibold px-2 py-0.5 rounded bg-gray-100 text-gray-600">
                                            {task.project?.title || 'General'}
                                        </span>
                                        <span className={`text-[10px] font-bold uppercase tracking-wider
                             ${task.status === 'in_progress' ? 'text-blue-600' : 'text-[#ae2b2b]'}
                          `}>
                                            {task.status.replace('_', ' ')}
                                        </span>
                                    </div>
                                    <h4 className="font-bold text-gray-800 text-sm mt-1">{task.title}</h4>
                                    {task.deadline && (
                                        <p className="text-xs text-red-500 mt-2 flex items-center gap-1">
                                            <Clock className="h-3 w-3" /> Due: {new Date(task.deadline).toLocaleDateString()}
                                        </p>
                                    )}
                                </div>
                            ))}
                        </div>
                    )}

                    {/* Quick Action */}
                    <div className="mt-8 pt-6 border-t border-gray-100">
                        <Link to="/dashboard/timesheet" className="block w-full text-center py-3 bg-gray-900 text-white rounded-lg font-medium hover:bg-gray-800 transition-colors shadow-lg shadow-gray-200">
                            + Add Timesheet Entry
                        </Link>
                    </div>
                </div>

                {/* Assigned Projects */}
                <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 h-fit">
                    <div className="flex justify-between items-center mb-6">
                        <h3 className="text-lg font-bold text-gray-800 flex items-center gap-2">
                            <Briefcase className="h-5 w-5 text-[#ae2b2b]" /> Assigned Projects
                        </h3>
                        <Link to="/projects" className="text-sm text-[#ae2b2b] hover:underline font-medium">Explore All</Link>
                    </div>

                    {assignedProjects.length === 0 ? (
                        <div className="text-center py-8 bg-gray-50 rounded-lg border border-dashed border-gray-200">
                            <Briefcase className="h-8 w-8 text-gray-300 mx-auto mb-2" />
                            <p className="text-gray-500 text-sm">You currently aren't assigned to any projects.</p>
                        </div>
                    ) : (
                        <div className="space-y-3">
                            {assignedProjects.map(project => (
                                <div key={project.id} className="p-3 bg-white border border-gray-200 hover:border-[#ae2b2b]/50 rounded-lg shadow-sm transition-all group">
                                    <div className="flex justify-between items-start mb-1">
                                        <span className="text-xs font-semibold px-2 py-0.5 rounded bg-purple-100 text-purple-700">
                                            {project.project_code || 'General'}
                                        </span>
                                        <span className={`text-[10px] font-bold uppercase tracking-wider
                                            ${project.status === 'upcoming' ? 'text-amber-600' : (project.status === 'completed' ? 'text-green-600' : 'text-blue-600')}
                                        `}>
                                            {project.status ? project.status.replace('_', ' ') : 'Active'}
                                        </span>
                                    </div>
                                    <h4 className="font-bold text-gray-800 text-sm mt-1">{project.title}</h4>
                                    <p className="text-xs text-gray-500 mt-1 line-clamp-2">{project.description}</p>
                                </div>
                            ))}
                        </div>
                    )}
                </div>
            </div>

            </div>

            {/* Share an Idea Section */}
            <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                <div className="p-6">
                    <div className="flex justify-between items-center mb-4">
                        <h3 className="text-lg font-bold text-gray-800 flex items-center gap-2">
                            <Lightbulb className="h-5 w-5 text-amber-500" /> Share an Idea
                        </h3>
                        <button
                            onClick={() => setShowIdeaForm(!showIdeaForm)}
                            className={`px-4 py-2 rounded-lg text-sm font-bold transition-all ${showIdeaForm
                                    ? 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                                    : 'bg-gradient-to-r from-amber-500 to-red-500 text-white hover:from-amber-600 hover:to-red-600 shadow-md'
                                }`}
                        >
                            {showIdeaForm ? 'Cancel' : '+ New Idea'}
                        </button>
                    </div>

                    <p className="text-sm text-gray-500 mb-4">Have a great idea? Share it with the leadership team. Your ideas help shape our community!</p>

                    {/* Idea Form */}
                    {showIdeaForm && (
                        <form onSubmit={handleSubmitIdea} className="mb-6 p-5 bg-gradient-to-br from-amber-50/80 to-red-50/80 rounded-xl border border-amber-200/50 space-y-4 animate-in fade-in slide-in-from-top-2 duration-300">
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Idea Title *</label>
                                <input
                                    type="text"
                                    className="w-full p-3 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-amber-500 focus:border-transparent outline-none bg-white"
                                    placeholder="Give your idea a clear title..."
                                    value={ideaForm.title}
                                    onChange={(e) => setIdeaForm(prev => ({ ...prev, title: e.target.value }))}
                                    required
                                />
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Description *</label>
                                <textarea
                                    className="w-full p-3 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-amber-500 focus:border-transparent outline-none bg-white resize-none"
                                    rows={4}
                                    placeholder="Describe your idea in detail — what problem does it solve, how can it be implemented?"
                                    value={ideaForm.description}
                                    onChange={(e) => setIdeaForm(prev => ({ ...prev, description: e.target.value }))}
                                    required
                                />
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Related Pod (Optional)</label>
                                <select
                                    className="w-full p-3 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-amber-500 focus:border-transparent outline-none bg-white"
                                    value={ideaForm.project_id}
                                    onChange={(e) => setIdeaForm(prev => ({ ...prev, project_id: e.target.value }))}
                                >
                                    <option value="">Not related to any Pod</option>
                                    {projects.map(p => (
                                        <option key={p.id} value={p.id}>{p.title}</option>
                                    ))}
                                </select>
                            </div>
                            <button
                                type="submit"
                                disabled={submittingIdea}
                                className="w-full flex items-center justify-center gap-2 py-3 bg-gradient-to-r from-red-500 to-red-500 text-white rounded-lg font-bold hover:from-red-600 hover:to-red-600 transition-all shadow-md disabled:opacity-50 disabled:cursor-not-allowed"
                            >
                                {submittingIdea ? (
                                    <><Loader2 className="h-4 w-4 animate-spin" /> Submitting...</>
                                ) : (
                                    <><Send className="h-4 w-4" /> Submit Idea</>
                                )}
                            </button>
                        </form>
                    )}

                    {/* My Ideas List */}
                    {myIdeas.length > 0 && (
                        <div className="space-y-3">
                            <h4 className="text-xs font-bold text-gray-500 uppercase tracking-widest">Your Submitted Ideas</h4>
                            {myIdeas.map(idea => {
                                const statusMap = {
                                    pending: { label: 'Pending Review', style: 'bg-amber-100 text-amber-700' },
                                    reviewed: { label: 'Reviewed', style: 'bg-blue-100 text-blue-700' },
                                    approved: { label: 'Approved', style: 'bg-green-100 text-green-700' },
                                    implemented: { label: 'Implemented', style: 'bg-purple-100 text-purple-700' },
                                    rejected: { label: 'Rejected', style: 'bg-red-100 text-red-700' }
                                };
                                const s = statusMap[idea.status] || statusMap.pending;

                                return (
                                    <div key={idea.id} className="p-4 bg-gray-50 rounded-lg border border-gray-100 hover:bg-white hover:shadow-sm transition-all">
                                        <div className="flex items-start justify-between gap-3">
                                            <div className="flex-1 min-w-0">
                                                <div className="flex items-center gap-2 flex-wrap">
                                                    <Lightbulb className="h-4 w-4 text-amber-500 shrink-0" />
                                                    <h4 className="font-bold text-gray-900 text-sm">{idea.title}</h4>
                                                    <span className={`px-2 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider ${s.style}`}>
                                                        {s.label}
                                                    </span>
                                                </div>
                                                <p className="text-gray-600 text-xs mt-1 line-clamp-2">{idea.description}</p>
                                                <div className="flex items-center gap-3 mt-2">
                                                    {idea.project && (
                                                        <span className="text-xs text-blue-600 font-medium flex items-center gap-1">
                                                            <Briefcase className="h-3 w-3" /> {idea.project.title}
                                                        </span>
                                                    )}
                                                    <span className="text-xs text-gray-400">
                                                        {new Date(idea.created_at).toLocaleDateString('en-IN', { day: 'numeric', month: 'short', year: 'numeric' })}
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                );
                            })}
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}

function StatsCard({ icon: Icon, title, value, label, color }) {
    return (
        <div className="bg-white p-5 rounded-xl border border-gray-200 shadow-sm hover:shadow-md transition-shadow">
            <div className="flex items-start justify-between">
                <div>
                    <p className="text-gray-500 text-sm font-medium">{title}</p>
                    <h3 className="text-3xl font-bold text-gray-900 mt-1">{value}</h3>
                </div>
                <div className={`p-2 rounded-lg ${color}`}>
                    <Icon className="h-6 w-6" />
                </div>
            </div>
            <p className="text-xs text-gray-400 mt-3">{label}</p>
        </div>
    )
}
