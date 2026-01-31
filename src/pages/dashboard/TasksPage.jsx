import { useState, useEffect } from "react";
import { useAuth } from "@/context/AuthContext";
import { supabase } from "@/lib/supabase";
import { CheckCircle, Clock, AlertCircle } from "lucide-react";

export default function TasksPage() {
    const { user } = useAuth();
    const [tasks, setTasks] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        if (user) fetchTasks();
    }, [user]);

    const fetchTasks = async () => {
        setLoading(true);
        try {
            const { data, error } = await supabase
                .from('tasks')
                .select('*, project:projects(title), event:events(title)')
                .eq('assignee_id', user.id)
                .order('deadline', { ascending: true });

            if (error) throw error;
            setTasks(data || []);
        } catch (err) {
            console.error("Fetch Tasks Error:", err);
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
                <h2 className="text-2xl font-bold text-gray-900">My Tasks</h2>
                <p className="text-gray-500">Track and manage your assigned responsibilities.</p>
            </div>

            {loading ? (
                <div className="flex justify-center p-12"><div className="animate-spin rounded-full h-10 w-10 border-b-2 border-[#ae2b2b]"></div></div>
            ) : (
                <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                    {tasks.length === 0 ? (
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
                    )}
                </div>
            )}
        </div>
    );
}
