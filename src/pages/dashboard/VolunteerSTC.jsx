import { useState, useEffect } from 'react';
import { supabase } from '@/lib/supabase';
import { useAuth } from '@/context/AuthContext';
import { Activity, CheckCircle, Clock, Trophy, Award, CheckSquare, ListTodo } from 'lucide-react';

export default function VolunteerSTC() {
    const { user } = useAuth();
    const [assignments, setAssignments] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        if (user?.id) fetchAssignments();
    }, [user?.id]);

    const fetchAssignments = async () => {
        try {
            setLoading(true);
            const { data, error } = await supabase
                .from('spiritual_task_assignments')
                .select(`
                    id, status, completed_at,
                    task:spiritual_tasks(title, description, created_at)
                `)
                .eq('volunteer_id', user.id)
                .order('created_at', { ascending: false });

            if (error) throw error;
            setAssignments(data || []);
        } catch (err) {
            console.error('Error fetching STC assignments:', err);
        } finally {
            setLoading(false);
        }
    };

    const markAsCompleted = async (assignmentId) => {
        try {
            const { error } = await supabase
                .from('spiritual_task_assignments')
                .update({ 
                    status: 'completed', 
                    completed_at: new Date().toISOString() 
                })
                .eq('id', assignmentId);

            if (error) throw error;

            setAssignments(prev => prev.map(a => 
                a.id === assignmentId ? { ...a, status: 'completed', completed_at: new Date().toISOString() } : a
            ));
        } catch (err) {
            alert(`Error: ${err.message}`);
        }
    };

    const completedCount = assignments.filter(a => a.status === 'completed').length;
    const pendingCount = assignments.filter(a => a.status === 'pending').length;

    if (loading) {
        return (
            <div className="flex justify-center items-center h-64">
                <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-[#ae2b2b]"></div>
            </div>
        );
    }

    return (
        <div className="space-y-6">
            <div className="bg-gradient-to-r from-[#ae2b2b] justify-between items-center to-[#5c1212] rounded-2xl p-6 md:p-8 text-white shadow-lg flex flex-col md:flex-row gap-6">
                <div>
                    <div className="flex items-center gap-3 mb-2">
                        <div className="bg-white/20 p-2 rounded-lg backdrop-blur-sm">
                            <Activity className="h-6 w-6" />
                        </div>
                        <h2 className="text-2xl md:text-3xl font-bold font-serif">Spiritual Tasks (STC)</h2>
                    </div>
                    <p className="text-white/80 mt-1 max-w-xl">
                        Complete your assigned spiritual tasks to grow and contribute. Earn STC points for every task you complete!
                    </p>
                </div>
                
                <div className="flex items-center shrink-0">
                    <div className="bg-white/10 border border-white/20 backdrop-blur-md px-6 py-4 rounded-2xl text-center">
                        <div className="text-white/80 text-sm font-bold uppercase tracking-wider mb-1 flex justify-center items-center gap-2">
                            <Trophy className="h-4 w-4 text-amber-300" /> STC Score
                        </div>
                        <div className="text-5xl font-black text-amber-300 drop-shadow-lg">
                            {completedCount * 1}
                        </div>
                    </div>
                </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="bg-white border text-center p-6 border-gray-200 rounded-xl shadow-sm">
                    <Clock className="h-8 w-8 text-amber-500 mx-auto mb-2" />
                    <h3 className="text-2xl font-bold text-gray-900">{pendingCount}</h3>
                    <p className="text-sm font-bold text-gray-500 uppercase tracking-widest mt-1">Pending Tasks</p>
                </div>
                <div className="bg-white border text-center p-6 border-gray-200 rounded-xl shadow-sm">
                    <CheckSquare className="h-8 w-8 text-green-500 mx-auto mb-2" />
                    <h3 className="text-2xl font-bold text-gray-900">{completedCount}</h3>
                    <p className="text-sm font-bold text-gray-500 uppercase tracking-widest mt-1">Completed Tasks</p>
                </div>
            </div>

            <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                <div className="p-6 border-b border-gray-100 flex items-center gap-2">
                    <ListTodo className="h-5 w-5 text-[#ae2b2b]" />
                    <h3 className="text-lg font-bold text-gray-900">Your Assigned Tasks</h3>
                </div>

                {assignments.length === 0 ? (
                    <div className="text-center py-16">
                        <Award className="h-12 w-12 text-gray-300 mx-auto mb-4" />
                        <p className="text-gray-500 font-medium">You don't have any spiritual tasks assigned yet.</p>
                    </div>
                ) : (
                    <div className="divide-y divide-gray-100">
                        {assignments.map(assignment => (
                            <div key={assignment.id} className="p-6 hover:bg-gray-50 transition-colors flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                                <div className="flex-1">
                                    <div className="flex items-center gap-3 mb-1">
                                        <h4 className="text-lg font-bold text-gray-900">{assignment.task?.title}</h4>
                                        {assignment.status === 'completed' && (
                                            <span className="bg-green-100 text-green-800 text-xs font-bold px-2 py-0.5 rounded uppercase tracking-wider flex items-center gap-1">
                                                <CheckCircle className="h-3 w-3" /> Done
                                            </span>
                                        )}
                                        {assignment.status === 'pending' && (
                                            <span className="bg-amber-100 text-amber-800 text-xs font-bold px-2 py-0.5 rounded uppercase tracking-wider flex items-center gap-1">
                                                <Clock className="h-3 w-3" /> Pending
                                            </span>
                                        )}
                                    </div>
                                    <p className="text-gray-600 text-sm whitespace-pre-wrap">{assignment.task?.description}</p>
                                    <p className="text-gray-400 text-xs mt-2">
                                        Assigned on: {new Date(assignment.task?.created_at).toLocaleDateString()}
                                    </p>
                                </div>
                                <div className="shrink-0">
                                    {assignment.status === 'pending' ? (
                                        <button
                                            onClick={() => markAsCompleted(assignment.id)}
                                            className="w-full sm:w-auto px-5 py-2.5 bg-gradient-to-r from-emerald-500 to-green-600 text-white font-bold rounded-lg shadow-md hover:from-emerald-600 hover:to-green-700 transition-all flex items-center justify-center gap-2"
                                        >
                                            <CheckCircle className="h-4 w-4" /> Mark Complete
                                        </button>
                                    ) : (
                                        <div className="text-sm font-bold text-green-600 flex items-center justify-center sm:justify-start gap-1">
                                            Completed <br />
                                            {new Date(assignment.completed_at).toLocaleDateString()}
                                        </div>
                                    )}
                                </div>
                            </div>
                        ))}
                    </div>
                )}
            </div>
        </div>
    );
}
