import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import {
    Activity, Plus, Search, Users, CheckCircle, Search as SearchIcon, X, CheckSquare, Clock, Edit2, Trash2
} from 'lucide-react';
import { useAuth } from '../../context/AuthContext';
import ErrorBoundary from '../../components/ErrorBoundary';

export default function AdminSTC() {
    const { user } = useAuth();
    const [tasks, setTasks] = useState([]);
    const [loading, setLoading] = useState(true);
    const [showCreateModal, setShowCreateModal] = useState(false);
    const [expandedTask, setExpandedTask] = useState(null);
    const [searchTerm, setSearchTerm] = useState('');

    // Create Modal State
    const [newTask, setNewTask] = useState({ title: '', description: '', assignType: 'all', selectedVolunteers: [] });
    const [allVolunteers, setAllVolunteers] = useState([]);
    const [submitting, setSubmitting] = useState(false);

    // Edit Modal State
    const [showEditModal, setShowEditModal] = useState(false);
    const [editingTask, setEditingTask] = useState(null);
    const [editSubmitting, setEditSubmitting] = useState(false);

    // Completions State
    const [completions, setCompletions] = useState([]);
    const [completionsLoading, setCompletionsLoading] = useState(false);

    useEffect(() => {
        fetchTasks();
        fetchVolunteers();
    }, []);

    const fetchTasks = async () => {
        try {
            setLoading(true);
            const { data, error } = await supabase
                .from('spiritual_tasks')
                .select(`
                    *,
                    created_by_user:volunteers!spiritual_tasks_created_by_fkey(first_name, last_name)
                `)
                .order('created_at', { ascending: false });

            if (error) throw error;
            setTasks(data || []);
        } catch (err) {
            console.error('Error fetching STC tasks:', err);
        } finally {
            setLoading(false);
        }
    };

    const fetchVolunteers = async () => {
        const { data } = await supabase
            .from('volunteers')
            .select('id, first_name, last_name, ilj_id, designation')
            .order('first_name', { ascending: true });
        if (data) setAllVolunteers(data);
    };

    const handleCreateTask = async (e) => {
        e.preventDefault();
        setSubmitting(true);
        try {
            // 1. Insert Task
            const { data: taskData, error: taskError } = await supabase
                .from('spiritual_tasks')
                .insert({
                    title: newTask.title.trim(),
                    description: newTask.description.trim(),
                    assignment_type: newTask.assignType,
                    created_by: user.id
                })
                .select()
                .single();

            if (taskError) throw taskError;

            // 2. Assign Volunteers
            const volunteerIds = newTask.assignType === 'all' 
                ? allVolunteers.map(v => v.id) 
                : newTask.selectedVolunteers;

            if (volunteerIds.length > 0) {
                const assignments = volunteerIds.map(vId => ({
                    task_id: taskData.id,
                    volunteer_id: vId,
                    status: 'pending'
                }));

                const { error: assignError } = await supabase
                    .from('spiritual_task_assignments')
                    .insert(assignments);
                if (assignError) throw assignError;
            }

            setTasks([taskData, ...tasks]);
            setShowCreateModal(false);
            setNewTask({ title: '', description: '', assignType: 'all', selectedVolunteers: [] });
            alert('Spiritual Task created and assigned successfully!');
            fetchTasks(); // Refresh to get the joins
        } catch (err) {
            alert(`Error: ${err.message}`);
        } finally {
            setSubmitting(false);
        }
    };

    const toggleVolunteerSelection = (id) => {
        setNewTask(prev => ({
            ...prev,
            selectedVolunteers: prev.selectedVolunteers.includes(id)
                ? prev.selectedVolunteers.filter(v => v !== id)
                : [...prev.selectedVolunteers, id]
        }));
    };

    const handleDeleteTask = async (e, id) => {
        e.stopPropagation();
        if (!window.confirm("Are you sure you want to delete this Spiritual Task? This action cannot be undone.")) return;

        try {
            // Delete assignments first to avoid foreign key cascading issues
            await supabase.from('spiritual_task_assignments').delete().eq('task_id', id);
            
            const { error: taskError } = await supabase.from('spiritual_tasks').delete().eq('id', id);
            if (taskError) throw taskError;
            
            setTasks(tasks.filter(t => t.id !== id));
            if (expandedTask === id) setExpandedTask(null);
        } catch (err) {
            console.error("Delete task err:", err);
            alert("Failed to delete task: " + err.message);
        }
    };

    const openEditModal = (e, task) => {
        e.stopPropagation();
        setEditingTask({ id: task.id, title: task.title, description: task.description });
        setShowEditModal(true);
    };

    const handleUpdateTask = async (e) => {
        e.preventDefault();
        setEditSubmitting(true);
        try {
            const { error } = await supabase
                .from('spiritual_tasks')
                .update({ title: editingTask.title.trim(), description: editingTask.description.trim() })
                .eq('id', editingTask.id);
            if (error) throw error;
            
            setTasks(tasks.map(t => t.id === editingTask.id ? { ...t, title: editingTask.title.trim(), description: editingTask.description.trim() } : t));
            setShowEditModal(false);
            setEditingTask(null);
            fetchTasks();
        } catch (err) {
            alert(`Error updating task: ${err.message}`);
        } finally {
            setEditSubmitting(false);
        }
    };

    const fetchCompletions = async (taskId) => {
        try {
            setCompletionsLoading(true);
            const { data, error } = await supabase
                .from('spiritual_task_assignments')
                .select(`
                    id, status, completed_at,
                    volunteer:volunteers(first_name, last_name, ilj_id)
                `)
                .eq('task_id', taskId);
                
            if (error) throw error;
            setCompletions(data || []);
        } catch (err) {
            console.error('Error fetching completions:', err);
        } finally {
            setCompletionsLoading(false);
        }
    };

    const filteredTasks = tasks.filter(task => 
        (task.title || '').toLowerCase().includes(searchTerm.toLowerCase()) || 
        (task.description || '').toLowerCase().includes(searchTerm.toLowerCase())
    );

    if (loading) {
        return (
            <div className="flex justify-center items-center h-64">
                <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-[#ae2b2b]"></div>
            </div>
        );
    }

    return (
        <div className="space-y-6">
            {/* Header */}
            <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                <div className="flex items-center gap-2">
                    <Activity className="h-6 w-6 text-[#ae2b2b]" />
                    <h2 className="text-xl font-bold text-gray-900">Spiritual Tasks (STC)</h2>
                </div>
                <button
                    onClick={() => setShowCreateModal(true)}
                    className="flex items-center gap-2 bg-[#ae2b2b] text-white px-4 py-2 rounded-lg hover:bg-[#8b1e1e] transition-all shadow-md font-semibold text-sm"
                >
                    <Plus className="h-4 w-4" /> Create STC Task
                </button>
            </div>

            {/* Search */}
            <div className="relative">
                <SearchIcon className="absolute left-3 top-3 h-5 w-5 text-gray-400" />
                <input
                    type="text"
                    placeholder="Search spiritual tasks..."
                    className="w-full pl-10 pr-4 py-3 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#ae2b2b] outline-none"
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                />
            </div>

            {/* Task List */}
            {filteredTasks.length === 0 ? (
                <div className="text-center py-16 bg-white rounded-xl border border-dashed border-gray-200">
                    <Activity className="h-12 w-12 text-gray-300 mx-auto mb-4" />
                    <h3 className="text-lg font-medium text-gray-900">No Spiritual Tasks</h3>
                    <p className="text-gray-500 mt-1">Create a new task to get started.</p>
                </div>
            ) : (
                <div className="space-y-4">
                    {filteredTasks.map(task => {
                        const isExpanded = expandedTask === task.id;
                        
                        return (
                            <div key={task.id} className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
                                <div 
                                    className="p-5 cursor-pointer hover:bg-gray-50 transition-colors"
                                    onClick={() => {
                                        if (isExpanded) {
                                            setExpandedTask(null);
                                        } else {
                                            setExpandedTask(task.id);
                                            fetchCompletions(task.id);
                                        }
                                    }}
                                >
                                    <div className="flex justify-between items-start">
                                        <div>
                                            <h3 className="text-lg font-bold text-gray-900">{task.title}</h3>
                                            <p className="text-gray-600 text-sm mt-1 line-clamp-2">{task.description}</p>
                                            <div className="flex items-center gap-4 mt-3">
                                                <span className="text-xs bg-red-50 text-red-700 px-2.5 py-1 rounded-full font-bold border border-red-100 uppercase tracking-wide flex items-center gap-1">
                                                    <Users className="h-3 w-3" /> {task.assignment_type === 'all' ? 'All Volunteers' : 'Specific Volunteers'}
                                                </span>
                                                <span className="text-xs text-gray-400">
                                                    {new Date(task.created_at).toLocaleDateString()}
                                                </span>
                                            </div>
                                        </div>
                                        <div className="flex items-center gap-2">
                                            <button 
                                                className="p-2 text-gray-400 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors"
                                                onClick={(e) => openEditModal(e, task)}
                                                title="Edit Task"
                                            >
                                                <Edit2 className="h-4 w-4" />
                                            </button>
                                            <button 
                                                className="p-2 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                                                onClick={(e) => handleDeleteTask(e, task.id)}
                                                title="Delete Task"
                                            >
                                                <Trash2 className="h-4 w-4" />
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                
                                {isExpanded && (
                                    <ErrorBoundary>
                                        <div className="border-t border-gray-100 p-5 bg-gray-50/50">
                                            <h4 className="text-sm font-bold text-gray-800 mb-3 flex items-center gap-2">
                                                <CheckSquare className="h-4 w-4 text-[#ae2b2b]" /> Task Completion Status
                                            </h4>
                                            {completionsLoading ? (
                                                <div className="text-sm text-gray-500">Loading assignments...</div>
                                            ) : completions.length === 0 ? (
                                                <div className="text-sm text-gray-500">No volunteers assigned to this task.</div>
                                            ) : (
                                                <div className="space-y-2 max-h-60 overflow-y-auto">
                                                    {completions.map(c => {
                                                        const vol = Array.isArray(c.volunteer) ? c.volunteer[0] : c.volunteer;
                                                        
                                                        // Fallback safety for React Rendering string/object bug
                                                        const safeFirstName = typeof vol?.first_name === 'string' ? vol?.first_name : String(vol?.first_name || 'Unknown');
                                                        const safeLastName = typeof vol?.last_name === 'string' ? vol?.last_name : String(vol?.last_name || 'Volunteer');
                                                        const safeInitials = (safeFirstName[0] || '') + (safeLastName[0] || '');
                                                        const safeIljId = String(vol?.ilj_id || 'N/A');

                                                        return (
                                                        <div key={c.id || Math.random()} className="flex justify-between items-center p-3 bg-white border border-gray-100 rounded-lg">
                                                            <div className="flex items-center gap-3">
                                                                <div className="w-8 h-8 rounded-full bg-gray-100 flex items-center justify-center text-xs font-bold text-gray-600">
                                                                    {safeInitials}
                                                                </div>
                                                                <div>
                                                                    <p className="text-sm font-medium text-gray-900">{safeFirstName} {safeLastName}</p>
                                                                    <p className="text-xs text-gray-500">{safeIljId}</p>
                                                                </div>
                                                            </div>
                                                            <div>
                                                                {c.status === 'completed' ? (
                                                                    <span className="flex items-center gap-1 text-xs font-bold text-green-700 bg-green-50 px-2 py-1 rounded border border-green-200">
                                                                        <CheckCircle className="h-3.5 w-3.5" /> Completed
                                                                    </span>
                                                                ) : (
                                                                    <span className="flex items-center gap-1 text-xs font-bold text-amber-700 bg-amber-50 px-2 py-1 rounded border border-amber-200">
                                                                        <Clock className="h-3.5 w-3.5" /> Pending
                                                                    </span>
                                                                )}
                                                            </div>
                                                        </div>
                                                    )})}
                                                </div>
                                            )}
                                        </div>
                                    </ErrorBoundary>
                                )}
                            </div>
                        );
                    })}
                </div>
            )}

            {/* Create Modal */}
            {showCreateModal && (
                <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm transition-all">
                    <div className="bg-white w-full max-w-2xl max-h-[90vh] overflow-hidden rounded-2xl shadow-2xl flex flex-col">
                        <div className="p-6 border-b border-gray-100 flex justify-between items-center">
                            <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                                <Activity className="h-5 w-5 text-[#ae2b2b]" /> Create STC Task
                            </h2>
                            <button onClick={() => setShowCreateModal(false)} className="p-2 hover:bg-gray-100 rounded-full transition-colors">
                                <X className="h-5 w-5 text-gray-500" />
                            </button>
                        </div>
                        
                        <div className="p-6 overflow-y-auto flex-1">
                            <form id="create-stc-form" onSubmit={handleCreateTask} className="space-y-4">
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">Task Title <span className="text-red-500">*</span></label>
                                    <input
                                        type="text"
                                        required
                                        className="w-full p-3 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#ae2b2b] outline-none"
                                        value={newTask.title}
                                        onChange={(e) => setNewTask({...newTask, title: e.target.value})}
                                    />
                                </div>
                                
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">Description <span className="text-red-500">*</span></label>
                                    <textarea
                                        required
                                        rows={3}
                                        className="w-full p-3 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#ae2b2b] outline-none resize-none"
                                        value={newTask.description}
                                        onChange={(e) => setNewTask({...newTask, description: e.target.value})}
                                    />
                                </div>

                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-2">Assign To</label>
                                    <div className="flex gap-4 mb-4">
                                        <label className="flex items-center gap-2 cursor-pointer">
                                            <input 
                                                type="radio" 
                                                name="assignType" 
                                                value="all" 
                                                checked={newTask.assignType === 'all'}
                                                onChange={() => setNewTask({...newTask, assignType: 'all'})}
                                                className="accent-[#ae2b2b]"
                                            />
                                            <span className="text-sm font-medium">All Volunteers</span>
                                        </label>
                                        <label className="flex items-center gap-2 cursor-pointer">
                                            <input 
                                                type="radio" 
                                                name="assignType" 
                                                value="specific" 
                                                checked={newTask.assignType === 'specific'}
                                                onChange={() => setNewTask({...newTask, assignType: 'specific', selectedVolunteers: []})}
                                                className="accent-[#ae2b2b]"
                                            />
                                            <span className="text-sm font-medium">Specific Volunteers</span>
                                        </label>
                                    </div>
                                    
                                    {newTask.assignType === 'specific' && (
                                        <div className="border border-gray-200 rounded-xl p-4 max-h-64 overflow-y-auto bg-gray-50">
                                            {allVolunteers.map(v => (
                                                <label key={v.id} className="flex items-center gap-3 p-2 hover:bg-white rounded-lg cursor-pointer transition-colors border-b border-gray-100 last:border-0">
                                                    <input 
                                                        type="checkbox"
                                                        checked={newTask.selectedVolunteers.includes(v.id)}
                                                        onChange={() => toggleVolunteerSelection(v.id)}
                                                        className="h-4 w-4 rounded border-gray-300 text-[#ae2b2b] focus:ring-[#ae2b2b] accent-[#ae2b2b]"
                                                    />
                                                    <div className="flex justify-between items-center flex-1">
                                                        <span className="text-sm font-medium text-gray-900">{v.first_name} {v.last_name}</span>
                                                        <span className="text-xs text-gray-500 bg-white px-2 py-0.5 rounded border">{v.ilj_id}</span>
                                                    </div>
                                                </label>
                                            ))}
                                            {allVolunteers.length === 0 && (
                                                <div className="text-sm text-gray-500 text-center py-4">No volunteers found.</div>
                                            )}
                                        </div>
                                    )}
                                </div>
                            </form>
                        </div>
                        
                        <div className="p-6 border-t border-gray-100 bg-gray-50 flex justify-end gap-3 rounded-b-2xl">
                            <button
                                type="button"
                                onClick={() => setShowCreateModal(false)}
                                className="px-5 py-2.5 rounded-xl font-bold text-gray-700 bg-white border border-gray-200 hover:bg-gray-50 transition-colors"
                            >
                                Cancel
                            </button>
                            <button
                                type="submit"
                                form="create-stc-form"
                                disabled={submitting || (newTask.assignType === 'specific' && newTask.selectedVolunteers.length === 0) || !newTask.title || !newTask.description}
                                className="px-5 py-2.5 bg-[#ae2b2b] text-white rounded-xl font-bold hover:bg-[#8b1e1e] transition-colors disabled:opacity-50 shadow-sm"
                            >
                                {submitting ? 'Creating...' : 'Create & Assign Task'}
                            </button>
                        </div>
                    </div>
                </div>
            )}
            {/* Edit Modal */}
            {showEditModal && editingTask && (
                <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm transition-all">
                    <div className="bg-white w-full max-w-lg rounded-2xl shadow-2xl flex flex-col">
                        <div className="p-6 border-b border-gray-100 flex justify-between items-center">
                            <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                                <Edit2 className="h-5 w-5 text-[#ae2b2b]" /> Edit STC Task
                            </h2>
                            <button onClick={() => {setShowEditModal(false); setEditingTask(null);}} className="p-2 hover:bg-gray-100 rounded-full transition-colors">
                                <X className="h-5 w-5 text-gray-500" />
                            </button>
                        </div>
                        
                        <div className="p-6">
                            <form id="edit-stc-form" onSubmit={handleUpdateTask} className="space-y-4">
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">Task Title <span className="text-red-500">*</span></label>
                                    <input
                                        type="text"
                                        required
                                        className="w-full p-3 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#ae2b2b] outline-none"
                                        value={editingTask.title}
                                        onChange={(e) => setEditingTask({...editingTask, title: e.target.value})}
                                    />
                                </div>
                                
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">Description <span className="text-red-500">*</span></label>
                                    <textarea
                                        required
                                        rows={4}
                                        className="w-full p-3 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#ae2b2b] outline-none resize-none"
                                        value={editingTask.description}
                                        onChange={(e) => setEditingTask({...editingTask, description: e.target.value})}
                                    />
                                </div>
                            </form>
                        </div>
                        
                        <div className="p-4 border-t border-gray-100 bg-gray-50 flex justify-end gap-3 rounded-b-2xl">
                            <button
                                type="button"
                                onClick={() => {setShowEditModal(false); setEditingTask(null);}}
                                className="px-5 py-2.5 rounded-xl font-bold text-gray-700 bg-white border border-gray-200 hover:bg-gray-50 transition-colors"
                            >
                                Cancel
                            </button>
                            <button
                                type="submit"
                                form="edit-stc-form"
                                disabled={editSubmitting || !editingTask.title || !editingTask.description}
                                className="px-5 py-2.5 bg-[#ae2b2b] text-white rounded-xl font-bold hover:bg-[#8b1e1e] transition-colors disabled:opacity-50 shadow-sm"
                            >
                                {editSubmitting ? 'Saving...' : 'Save Changes'}
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}
