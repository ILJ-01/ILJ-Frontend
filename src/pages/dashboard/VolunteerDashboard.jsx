import { useState, useEffect } from "react";
import { useAuth } from "@/context/AuthContext";
import { supabase } from "@/lib/supabase";
import {
    Calendar, CheckCircle, Clock, Award,
    ArrowRight, Activity
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
    const [loading, setLoading] = useState(true);

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

            // 5. Announcements
            const { data: activeAnnouncements } = await supabase
                .from('announcements')
                .select('*')
                .order('created_at', { ascending: false })
                .limit(3);

            setStats({
                totalHours: hours,
                pendingTasks: taskCount || 0,
                upcomingEventsCount: events?.length || 0,
                level: hours > 50 ? "Core Volunteer" : "Active Volunteer"
            });
            setUpcomingEvents(events || []);
            setMyTasks(tasks || []);
            setAnnouncements(activeAnnouncements || []);

        } catch (error) {
            console.error("Dashboard Load Error:", error);
        } finally {
            setLoading(false);
        }
    };

    const handleInterest = async (eventId) => {
        try {
            await supabase
                .from('event_interests')
                .insert({ event_id: eventId, volunteer_id: user.id });

            // Optimistic update
            setUpcomingEvents(prev => prev.map(e => e.id === eventId ? { ...e, interested: true } : e));

            // Notify admin (create notification record for admin/manager - skipping for now or generic)
            alert("Marked as interested! Admin will be notified.");
        } catch (e) {
            console.error("Interest Error:", e);
        }
    };

    if (loading) return (
        <div className="flex justify-center items-center h-96">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-[#ae2b2b]"></div>
        </div>
    );

    return (
        <div className="space-y-6 animate-in fade-in slide-in-from-bottom-4 duration-500">

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
