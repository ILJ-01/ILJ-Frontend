import { useState, useEffect } from "react";
import { useAuth } from "@/context/AuthContext";
import { supabase } from "@/lib/supabase";
import { CheckCircle, Clock, AlertCircle, Briefcase } from "lucide-react";

export default function TasksPage() {
    const { user } = useAuth();
    const [tasks, setTasks] = useState([]);
    const [opportunities, setOpportunities] = useState([]);
    const [activeTab, setActiveTab] = useState("assigned");
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        if (user) fetchTasks();
    }, [user]);

    const fetchTasks = async () => {
        setLoading(true);
        try {
            // 1. Fetch Assigned Tasks
            const { data: taskData, error: taskError } = await supabase
                .from('tasks')
                .select('*, project:projects(title), event:events(title)')
                .eq('assignee_id', user.id)
                .order('deadline', { ascending: true });

            if (taskError) throw taskError;
            setTasks(taskData || []);

            // 2. Fetch General Opportunities
            const { data: opps, error: oppError } = await supabase
                .from('announcements')
                .select(`
                    *, 
                    project:projects(title), 
                    interests:announcement_interests(volunteer_id)
                `)
                .eq('type', 'task_opportunity')
                .order('created_at', { ascending: false });

            if (oppError) throw oppError;

            // 3. Manually fetch creators
            const creatorIds = opps ? [...new Set(opps.map(o => o.created_by).filter(Boolean))] : [];
            let creatorsMap = {};

            if (creatorIds.length > 0) {
                const { data: creators, error: creatorError } = await supabase
                    .from('volunteers')
                    .select('id, first_name, last_name, email, mobile_number')
                    .in('id', creatorIds);

                if (!creatorError && creators) {
                    creatorsMap = creators.reduce((acc, c) => ({ ...acc, [c.id]: c }), {});
                }
            }

            // Process opportunities
            const processedOpps = opps?.map(o => ({
                ...o,
                creator: creatorsMap[o.created_by] || null, // Map manually fetched creator
                alreadyInterested: o.interests?.some(i => i.volunteer_id === user.id)
            })) || [];

            setOpportunities(processedOpps);

        } catch (err) {
            console.error("Fetch Data Error:", err);
        } finally {
            setLoading(false);
        }
    };

    const updateStatus = async (taskId, newStatus) => {
        try {
            const { error } = await supabase
                .from('tasks')
                .update({ status: newStatus })
                .eq('id', taskId);

            if (error) throw error;

            setTasks(prev => prev.map(t => t.id === taskId ? { ...t, status: newStatus } : t));
        } catch (e) {
            console.error("Update Status Error:", e);
            alert("Failed to update status");
        }
    };

    const handleOpportunityInterest = async (announcementId) => {
        try {
            const announcement = opportunities.find(o => o.id === announcementId);

            const { error } = await supabase
                .from('announcement_interests')
                .insert({ announcement_id: announcementId, volunteer_id: user.id });

            if (error) throw error;

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
            alert("Could not mark interest. You might have already expressed interest.");
        }
    };

    const getStatusColor = (status) => {
        switch (status) {
            case 'completed': return 'bg-green-100 text-green-800 border-green-200';
            case 'in_progress': return 'bg-blue-100 text-blue-800 border-blue-200';
            default: return 'bg-[#ae2b2b]/5 text-[#ae2b2b] border-[#ae2b2b]/20';
        }
    };

    return (
        <div className="space-y-6">
            <div>
                <h2 className="text-2xl font-bold text-gray-900">Task Board</h2>
                <p className="text-gray-500">Manage assigned tasks and discover new opportunities.</p>
            </div>

            {/* Tabs */}
            <div className="flex flex-wrap gap-2 md:gap-4 border-b-0 md:border-b border-gray-200">
                <button
                    onClick={() => setActiveTab("assigned")}
                    className={`flex-1 md:flex-none py-2 px-4 md:py-3 md:px-1 text-sm font-medium transition-all rounded-lg md:rounded-none md:border-b-2 ${activeTab === "assigned"
                            ? "bg-[#ae2b2b] text-white md:bg-transparent md:border-[#ae2b2b] md:text-[#ae2b2b]"
                            : "bg-white text-gray-500 border border-gray-100 md:bg-transparent md:border-transparent hover:text-gray-700"
                        }`}
                >
                    Assigned Tasks
                </button>
                <button
                    onClick={() => setActiveTab("opportunities")}
                    className={`flex-1 md:flex-none py-2 px-4 md:py-3 md:px-1 text-sm font-medium transition-all rounded-lg md:rounded-none md:border-b-2 ${activeTab === "opportunities"
                            ? "bg-[#ae2b2b] text-white md:bg-transparent md:border-[#ae2b2b] md:text-[#ae2b2b]"
                            : "bg-white text-gray-500 border border-gray-100 md:bg-transparent md:border-transparent hover:text-gray-700"
                        }`}
                >
                    General Opportunities
                </button>
            </div>

            {loading ? (
                <div className="flex justify-center p-12"><div className="animate-spin rounded-full h-10 w-10 border-b-2 border-[#ae2b2b]"></div></div>
            ) : (
                <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                    {activeTab === 'assigned' ? (
                        tasks.length === 0 ? (
                            <div className="text-center py-16">
                                <CheckCircle className="h-12 w-12 text-gray-300 mx-auto mb-3" />
                                <p className="text-gray-500">No tasks assigned to you yet.</p>
                            </div>
                        ) : (
                            <div className="divide-y divide-gray-100">
                                {tasks.map(task => (
                                    <div key={task.id} className="p-6 hover:bg-gray-50 transition-colors flex flex-col md:flex-row gap-4 md:items-center">
                                        <div className="flex-1">
                                            <div className="flex items-center gap-2 mb-1">
                                                <span className={`px-2 py-0.5 rounded textxs font-medium border ${getStatusColor(task.status)} uppercase text-[10px] tracking-wider`}>
                                                    {task.status.replace('_', ' ')}
                                                </span>
                                                {task.project && <span className="text-xs text-gray-400">• {task.project.title}</span>}
                                                {task.event && <span className="text-xs text-gray-400">• {task.event.title}</span>}
                                            </div>
                                            <h3 className="text-lg font-bold text-gray-900">{task.title}</h3>
                                            <p className="text-gray-600 mt-1 text-sm">{task.description}</p>
                                            {task.deadline && (
                                                <p className={`text-xs mt-2 font-medium flex items-center gap-1
                                            ${new Date(task.deadline) < new Date() && task.status !== 'completed' ? 'text-red-500' : 'text-gray-500'}
                                        `}>
                                                    <Clock className="h-3 w-3" /> Due: {new Date(task.deadline).toLocaleDateString()}
                                                </p>
                                            )}
                                        </div>

                                        <div className="flex items-center gap-2 shrink-0">
                                            {task.status === 'pending' && (
                                                <button
                                                    onClick={() => updateStatus(task.id, 'in_progress')}
                                                    className="px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-lg hover:bg-blue-700 transition-colors"
                                                >
                                                    Start Task
                                                </button>
                                            )}
                                            {task.status === 'in_progress' && (
                                                <button
                                                    onClick={() => updateStatus(task.id, 'completed')}
                                                    className="px-4 py-2 bg-green-600 text-white text-sm font-medium rounded-lg hover:bg-green-700 transition-colors"
                                                >
                                                    Mark Done
                                                </button>
                                            )}
                                            {task.status === 'completed' && (
                                                <span className="flex items-center text-green-600 font-medium text-sm">
                                                    <CheckCircle className="h-5 w-5 mr-1" /> Completed
                                                </span>
                                            )}
                                        </div>
                                    </div>
                                ))}
                            </div>
                        )
                    ) : (
                        // Opportunities Tab Content
                        opportunities.length === 0 ? (
                            <div className="text-center py-16">
                                <Briefcase className="h-12 w-12 text-gray-300 mx-auto mb-3" />
                                <p className="text-gray-500">No open opportunities at the moment.</p>
                            </div>
                        ) : (
                            <div className="divide-y divide-gray-100">
                                {opportunities.map(opp => (
                                    <div key={opp.id} className="p-6 hover:bg-purple-50/50 transition-colors flex flex-col md:flex-row gap-6 md:items-start group">
                                        <div className="flex-1">
                                            <div className="flex items-center gap-2 mb-2">
                                                <span className="text-xs font-bold uppercase tracking-wider text-purple-700 bg-purple-100 px-2 py-0.5 rounded">
                                                    {opp.project?.title || 'General Opportunity'}
                                                </span>
                                                <span className="text-xs text-gray-500">Posted: {new Date(opp.created_at).toLocaleDateString()}</span>
                                            </div>
                                            <h3 className="text-lg font-bold text-gray-900 group-hover:text-[#ae2b2b] transition-colors">{opp.title}</h3>
                                            <p className="text-gray-600 mt-2 text-sm leading-relaxed">{opp.message}</p>

                                            <div className="mt-4 flex flex-wrap gap-4 text-sm text-gray-500">
                                                {opp.deadline && (
                                                    <span className="flex items-center gap-1 text-red-600 font-medium bg-red-50 px-2 py-1 rounded">
                                                        <Clock className="h-3.5 w-3.5" /> Deadline: {new Date(opp.deadline).toLocaleDateString()}
                                                    </span>
                                                )}
                                                {opp.creator && (
                                                    <div className="flex flex-col gap-1 border-l pl-4 border-gray-200">
                                                        <span className="font-semibold text-gray-700">Contact: {opp.creator.first_name} {opp.creator.last_name}</span>
                                                        <a href={`mailto:${opp.creator.email}`} className="text-blue-600 hover:underline">{opp.creator.email}</a>
                                                        {opp.creator.mobile_number && <span className="text-gray-500">📞 {opp.creator.mobile_number}</span>}
                                                    </div>
                                                )}
                                            </div>
                                        </div>

                                        <button
                                            onClick={() => handleOpportunityInterest(opp.id)}
                                            disabled={opp.alreadyInterested}
                                            className={`px-5 py-2.5 text-sm font-bold rounded-lg transition-all shadow-sm whitespace-nowrap ${opp.alreadyInterested
                                                ? 'bg-green-100 text-green-700 cursor-default border border-green-200'
                                                : 'bg-[#ae2b2b] hover:bg-[#8b1e1e] text-white'
                                                }`}
                                        >
                                            {opp.alreadyInterested ? 'Interest Sent ✅' : 'I\'m Interested'}
                                        </button>
                                    </div>
                                ))}
                            </div>
                        )
                    )}
                </div>
            )}
        </div>
    );
}
