import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import { CheckCircle, Plus, Trash2, X, Loader2, User, Clock, Search, Archive, Star, MessageSquare } from 'lucide-react';

export default function AdminTasks() {
    const [tasks, setTasks] = useState([]);
    const [projects, setProjects] = useState([]);
    const [volunteers, setVolunteers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [showModal, setShowModal] = useState(false);
    const [activeStatusTab, setActiveStatusTab] = useState('pending'); // pending, completed, reviewed, archived, projectwise

    // Search State
    const [assigneeSearch, setAssigneeSearch] = useState('');
    const [showAssigneeDropdown, setShowAssigneeDropdown] = useState(false);
    const [selectedTaskForFeedback, setSelectedTaskForFeedback] = useState(null);
    const [creating, setCreating] = useState(false);
    const [expandedTaskId, setExpandedTaskId] = useState(null);

    const [formData, setFormData] = useState({
        title: '', description: '', project_id: '', assignee_id: '', deadline: ''
    });

    const handleCreate = () => {
        setFormData({ title: '', description: '', project_id: '', assignee_id: '', deadline: '' });
        setAssigneeSearch('');
        setShowAssigneeDropdown(false);
        setShowModal(true);
    };

    useEffect(() => {
        fetchData();
    }, []);

    const fetchData = async () => {
        setLoading(true);
        const [tasksRes, projectsRes, volunteersRes] = await Promise.all([
            supabase.from('tasks').select('*, project:projects(title), assignee:volunteers(first_name, last_name)').order('created_at', { ascending: false }),
            supabase.from('projects').select('id, title').order('title'),
            supabase.from('volunteers').select('id, first_name, last_name, email, ilj_id').order('first_name')
        ]);

        setTasks(tasksRes.data || []);
        setProjects(projectsRes.data || []);
        setVolunteers(volunteersRes.data || []);
        setLoading(false);
    };

    const handleDelete = async (id) => {
        if (!confirm("Delete this task?")) return;
        await supabase.from('tasks').delete().eq('id', id);
        setTasks(prev => prev.filter(t => t.id !== id));
    };

    const handleArchive = async (id, currentStatus) => {
        const newStatus = currentStatus === 'archived' ? 'pending' : 'archived';
        const { error } = await supabase.from('tasks').update({ status: newStatus }).eq('id', id);
        if (error) alert("Failed to update task");
        else fetchData();
    };

    const handleFeedbackSubmit = async (taskId, rating, comments) => {
        try {
            const { error } = await supabase
                .from('tasks')
                .update({ rating: parseInt(rating), feedback_comments: comments })
                .eq('id', taskId);

            if (error) throw error;

            setTasks(prev => prev.map(t => t.id === taskId ? { ...t, rating, feedback_comments: comments } : t));
            setSelectedTaskForFeedback(null);
            alert("Feedback saved!");
        } catch (err) {
            alert("Error saving feedback: " + err.message);
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (creating) return;
        setCreating(true);
        try {
            const { error } = await supabase.from('tasks').insert([{
                ...formData,
                assignee_id: formData.assignee_id || null, // Ensure null if empty string
                project_id: formData.project_id || null
            }]);
            if (error) throw error;

            // Send Email Notification
            if (formData.assignee_id) {
                const assignee = volunteers.find(v => v.id === formData.assignee_id);
                const project = projects.find(p => p.id === formData.project_id);

                if (assignee?.email) {
                    try {
                        const response = await fetch(`${import.meta.env.VITE_SUPABASE_URL}/functions/v1/send-task-email`, {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                                'Authorization': `Bearer ${import.meta.env.VITE_SUPABASE_ANON_KEY}`,
                                'apikey': import.meta.env.VITE_SUPABASE_ANON_KEY
                            },
                            body: JSON.stringify({
                                to: assignee.email,
                                assignee_name: `${assignee.first_name} ${assignee.last_name}`,
                                manager_name: 'Admin',
                                project_title: project?.title || 'General Task',
                                task_title: formData.title,
                                task_description: formData.description,
                                deadline: formData.deadline
                            })
                        });

                        const result = await response.json();
                        if (!response.ok) {
                            console.error("Email API failure:", result);
                            alert(`Task created, but email failed: ${result.error || response.statusText}`);
                        } else {
                            console.log("Email sent successfully:", result);
                        }
                    } catch (fetchErr) {
                        console.error("Email Network Error:", fetchErr);
                        alert(`Task created, but email notification failed (Network Error).`);
                    }
                }
            }

            setShowModal(false);
            setFormData({ title: '', description: '', project_id: '', assignee_id: '', deadline: '' });
            fetchData();
            alert("Task assigned & Email Sent!");
        } catch (error) {
            console.error(error);
            alert("Failed to create task");
        } finally {
            setCreating(false);
        }
    };

    const renderTaskRow = (task) => (
        <div key={task.id} className="border-b border-gray-100 last:border-b-0">
            <div
                onClick={() => setExpandedTaskId(expandedTaskId === task.id ? null : task.id)}
                className={`p-4 hover:bg-gray-50 flex flex-col sm:flex-row sm:items-center justify-between group cursor-pointer transition-colors ${task.status === 'archived' ? 'bg-gray-50/50' : ''}`}>
                <div className="flex-1 min-w-0 pr-4">
                    <div className="flex items-center gap-2 mb-1">
                        <span className={`text-[10px] font-bold uppercase tracking-wider px-1.5 py-0.5 rounded border
                        ${task.status === 'completed' ? 'bg-green-50 text-green-700 border-green-200' :
                                task.status === 'archived' ? 'bg-gray-100 text-gray-700 border-gray-200' :
                                    'bg-[#ae2b2b]/5 text-[#ae2b2b] border-[#ae2b2b]/20'}`}>
                            {task.status} {task.rating ? '(Reviewed)' : ''}
                        </span>
                        {task.project && <span className="text-xs text-gray-500">• {task.project.title}</span>}
                    </div>
                    <h3 className={`font-bold text-gray-900 truncate ${task.status === 'archived' ? 'text-gray-500' : ''}`}>{task.title}</h3>
                    <div className="flex items-center gap-4 mt-1 text-sm text-gray-500">
                        <div className="flex items-center gap-1">
                            <User className="h-3 w-3" />
                            <span className="truncate max-w-[150px]">
                                {task.assignee ? `${task.assignee.first_name} ${task.assignee.last_name}` : 'Unassigned'}
                            </span>
                        </div>
                        {task.deadline && (
                            <div className="flex items-center gap-1 text-red-400">
                                <Clock className="h-3 w-3" />
                                <span>{new Date(task.deadline).toLocaleDateString()}</span>
                            </div>
                        )}
                    </div>
                </div>
                <div className="flex items-center gap-2 mt-3 sm:mt-0">
                    <button
                        onClick={(e) => { e.stopPropagation(); handleArchive(task.id, task.status); }}
                        className="text-gray-400 hover:text-amber-600 p-2 opacity-0 group-hover:opacity-100 transition-opacity"
                        title={task.status === 'archived' ? "Unarchive" : "Archive"}
                    >
                        <Archive className="h-5 w-5" />
                    </button>
                    <button onClick={(e) => { e.stopPropagation(); handleDelete(task.id); }} className="text-gray-400 hover:text-red-500 p-2 opacity-0 group-hover:opacity-100 transition-opacity">
                        <Trash2 className="h-5 w-5" />
                    </button>
                    {task.status === 'completed' && (
                        <button
                            onClick={(e) => { e.stopPropagation(); setSelectedTaskForFeedback(task); }}
                            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-bold transition-all shadow-sm
                            ${task.rating
                                    ? 'bg-amber-50 text-amber-700 border border-amber-200 hover:bg-amber-100'
                                    : 'bg-blue-600 text-white hover:bg-blue-700'
                                }`}
                        >
                            <Star className={`h-3.5 w-3.5 ${task.rating ? 'fill-amber-500' : ''}`} />
                            {task.rating ? `${task.rating} Stars` : 'Add Feedback'}
                        </button>
                    )}
                </div>
            </div>
            {expandedTaskId === task.id && (
                <div className="px-4 pb-4 animate-in slide-in-from-top-2 duration-300">
                    <div className="bg-white rounded-xl p-4 border border-gray-100 shadow-sm relative overflow-hidden">
                        <div className="absolute left-0 top-0 bottom-0 w-1 bg-[#ae2b2b]"></div>
                        
                        {task.status === 'pending' && (
                            <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-4 pb-4 border-b border-gray-100">
                                <div>
                                    <span className="text-[10px] font-bold text-gray-400 uppercase tracking-widest block mb-1">Assigned By</span>
                                    <span className="text-sm font-medium text-gray-800">Admin</span>
                                </div>
                                <div>
                                    <span className="text-[10px] font-bold text-gray-400 uppercase tracking-widest block mb-1">Assigned To</span>
                                    <span className="text-sm font-medium text-gray-800">{task.assignee ? `${task.assignee.first_name} ${task.assignee.last_name}` : 'Unassigned'}</span>
                                </div>
                                <div>
                                    <span className="text-[10px] font-bold text-gray-400 uppercase tracking-widest block mb-1">Date of Assigning</span>
                                    <span className="text-sm font-medium text-gray-800">{new Date(task.created_at).toLocaleDateString()}</span>
                                </div>
                                <div>
                                    <span className="text-[10px] font-bold text-gray-400 uppercase tracking-widest block mb-1">Deadline</span>
                                    <span className={`text-sm font-medium ${new Date(task.deadline) < new Date() ? 'text-red-600' : 'text-gray-800'}`}>
                                        {task.deadline ? new Date(task.deadline).toLocaleDateString() : 'No Deadline'}
                                    </span>
                                </div>
                            </div>
                        )}

                        <h4 className="text-xs font-bold text-gray-400 uppercase tracking-widest mb-2">Task Description</h4>
                        <p className="text-sm text-gray-700 whitespace-pre-line leading-relaxed">
                            {task.description || "No description provided by the assigner."}
                        </p>
                    </div>
                </div>
            )}
        </div>
    );

    return (
        <div className="space-y-6">
            <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                <h2 className="text-xl font-bold text-gray-800 shrink-0">Task Management</h2>
                
                <div className="flex flex-col xl:flex-row items-start xl:items-center gap-3 w-full xl:w-auto overflow-hidden">
                    {/* Tabs */}
                    <div className="flex bg-gray-100 p-1 rounded-lg overflow-x-auto w-full xl:w-auto text-sm no-scrollbar">
                        {['pending', 'completed', 'reviewed', 'archived', 'projectwise'].map(tab => (
                            <button
                                key={tab}
                                onClick={() => setActiveStatusTab(tab)}
                                className={`px-3 py-1.5 rounded-md font-medium whitespace-nowrap transition-colors ${
                                    activeStatusTab === tab 
                                    ? 'bg-white text-[#ae2b2b] shadow-sm' 
                                    : 'text-gray-600 hover:text-gray-900 hover:bg-gray-200/50'
                                }`}
                            >
                                {tab.charAt(0).toUpperCase() + tab.slice(1)} {tab === 'projectwise' ? 'Tasks' : ''}
                            </button>
                        ))}
                    </div>

                    <button
                        onClick={handleCreate}
                        className="flex items-center gap-2 bg-[#ae2b2b] text-white px-4 py-2 rounded-lg hover:bg-[#8b1e1e] transition shadow-sm font-medium shrink-0"
                    >
                        <Plus className="h-4 w-4" /> Assign Task
                    </button>
                </div>
            </div>

            {loading ? (
                <div className="flex justify-center p-12"><Loader2 className="h-8 w-8 animate-spin text-[#ae2b2b]" /></div>
            ) : (
                <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                    <div className="divide-y divide-gray-100">
                        {(() => {
                            let filteredTasks = tasks;
                            if (activeStatusTab === 'reviewed') {
                                filteredTasks = tasks.filter(t => t.status === 'completed' && t.rating);
                            } else if (activeStatusTab === 'completed') {
                                filteredTasks = tasks.filter(t => t.status === 'completed' && !t.rating);
                            } else if (activeStatusTab !== 'projectwise') {
                                filteredTasks = tasks.filter(t => t.status === activeStatusTab);
                            }

                            if (activeStatusTab === 'projectwise') {
                                const grouped = tasks.reduce((acc, t) => {
                                    const pTitle = t.project ? t.project.title : 'General / No Pod';
                                    if (!acc[pTitle]) acc[pTitle] = [];
                                    acc[pTitle].push(t);
                                    return acc;
                                }, {});
                                
                                return Object.entries(grouped).map(([project, projTasks]) => (
                                    <div key={project} className="border-b border-gray-200 last:border-b-0">
                                        <div className="bg-gray-50 px-4 py-3 font-bold text-gray-800 border-b border-gray-200 flex items-center justify-between">
                                            <span>{project}</span>
                                            <span className="text-xs font-normal bg-white px-2 py-1 rounded shadow-sm text-gray-600">{projTasks.length} tasks</span>
                                        </div>
                                        <div className="divide-y divide-gray-100">
                                            {projTasks.map(task => renderTaskRow(task))}
                                        </div>
                                    </div>
                                ));
                            }

                            if (filteredTasks.length === 0) {
                                return <p className="text-gray-500 text-center py-8">No tasks found in this category.</p>;
                            }

                            return filteredTasks.map(task => renderTaskRow(task));
                        })()}
                    </div>
                </div>
            )}

            {showModal && (
                <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm">
                    <div className="bg-white w-full max-w-lg rounded-2xl p-6 shadow-xl animate-in fade-in zoom-in-95">
                        <div className="flex justify-between items-center mb-6">
                            <h3 className="text-xl font-bold">Assign New Task</h3>
                            <button onClick={() => setShowModal(false)}><X className="h-6 w-6 text-gray-400 hover:text-gray-600" /></button>
                        </div>
                        <form onSubmit={handleSubmit} className="space-y-4">
                            <div>
                                <label className="block text-sm font-medium mb-1">Task Title</label>
                                <input required type="text" className="w-full border rounded-lg p-2" value={formData.title} onChange={e => setFormData({ ...formData, title: e.target.value })} />
                            </div>
                            <div className="grid grid-cols-2 gap-4">
                                <div>
                                    <label className="block text-sm font-medium mb-1">Pod</label>
                                    <select className="w-full border rounded-lg p-2" value={formData.project_id} onChange={e => setFormData({ ...formData, project_id: e.target.value })}>
                                        <option value="">-- General --</option>
                                        {projects.map(p => <option key={p.id} value={p.id}>{p.title}</option>)}
                                    </select>
                                </div>
                                <div>
                                    <label className="block text-sm font-medium mb-1">Assignee</label>
                                    <div className="relative">
                                        <div className="relative">
                                            <input
                                                type="text"
                                                placeholder="Search volunteer..."
                                                className="w-full border rounded-lg p-2 pl-9"
                                                value={assigneeSearch}
                                                onChange={(e) => {
                                                    setAssigneeSearch(e.target.value);
                                                    setShowAssigneeDropdown(true);
                                                    setFormData({ ...formData, assignee_id: '' }); // Clear ID on typing
                                                }}
                                                onFocus={() => setShowAssigneeDropdown(true)}
                                            />
                                            <Search className="h-4 w-4 text-gray-400 absolute left-3 top-3" />
                                            {assigneeSearch && (
                                                <button
                                                    type="button"
                                                    onClick={() => {
                                                        setAssigneeSearch('');
                                                        setFormData({ ...formData, assignee_id: '' });
                                                    }}
                                                    className="absolute right-3 top-3 text-gray-400 hover:text-gray-600"
                                                >
                                                    <X className="h-4 w-4" />
                                                </button>
                                            )}
                                        </div>

                                        {showAssigneeDropdown && (
                                            <div className="absolute z-10 w-full mt-1 bg-white border rounded-lg shadow-lg max-h-60 overflow-auto">
                                                {volunteers.filter(v =>
                                                    `${v.first_name} ${v.last_name}`.toLowerCase().includes(assigneeSearch.toLowerCase()) ||
                                                    (v.ilj_id && v.ilj_id.toLowerCase().includes(assigneeSearch.toLowerCase()))
                                                ).length > 0 ? (
                                                    volunteers
                                                        .filter(v =>
                                                            `${v.first_name} ${v.last_name}`.toLowerCase().includes(assigneeSearch.toLowerCase()) ||
                                                            (v.ilj_id && v.ilj_id.toLowerCase().includes(assigneeSearch.toLowerCase()))
                                                        )
                                                        .map(v => (
                                                            <div
                                                                key={v.id}
                                                                className="p-2 hover:bg-gray-50 cursor-pointer flex items-center gap-2"
                                                                onClick={() => {
                                                                    setFormData({ ...formData, assignee_id: v.id });
                                                                    setAssigneeSearch(`${v.first_name} ${v.last_name}`);
                                                                    setShowAssigneeDropdown(false);
                                                                }}
                                                            >
                                                                <div className="h-6 w-6 rounded-full bg-[#ae2b2b]/10 flex items-center justify-center text-xs text-[#ae2b2b] font-bold">
                                                                    {v.first_name[0]}
                                                                </div>
                                                                <div className="flex flex-col">
                                                                    <span className="text-sm font-medium">{v.first_name} {v.last_name}</span>
                                                                    <span className="text-[10px] text-gray-500 font-mono -mt-0.5">{v.ilj_id}</span>
                                                                </div>
                                                            </div>
                                                        ))
                                                ) : (
                                                    <div className="p-3 text-center text-sm text-gray-500">No volunteers found</div>
                                                )}
                                            </div>
                                        )}
                                    </div>
                                    {/* Detect click outside could be added here or just rely on selection */}
                                    {showAssigneeDropdown && (
                                        <div className="fixed inset-0 z-0" onClick={() => setShowAssigneeDropdown(false)}></div>
                                    )}
                                </div>
                            </div>
                            <div>
                                <label className="block text-sm font-medium mb-1">Deadline</label>
                                <input type="datetime-local" className="w-full border rounded-lg p-2" value={formData.deadline} onChange={e => setFormData({ ...formData, deadline: e.target.value })} />
                            </div>
                            <div>
                                <label className="block text-sm font-medium mb-1">Description</label>
                                <textarea rows="3" className="w-full border rounded-lg p-2" value={formData.description} onChange={e => setFormData({ ...formData, description: e.target.value })}></textarea>
                            </div>
                            <button
                                type="submit"
                                disabled={creating}
                                className={`w-full bg-[#ae2b2b] text-white font-bold py-2.5 rounded-lg hover:bg-[#8b1e1e] flex items-center justify-center gap-2 ${creating ? 'opacity-70 cursor-not-allowed' : ''}`}
                            >
                                {creating ? (
                                    <>
                                        <Loader2 className="h-4 w-4 animate-spin" />
                                        Creating...
                                    </>
                                ) : (
                                    'Create Task'
                                )}
                            </button>
                        </form>
                    </div>
                </div>
            )}

            {selectedTaskForFeedback && (
                <FeedbackModal
                    task={selectedTaskForFeedback}
                    onClose={() => setSelectedTaskForFeedback(null)}
                    onSubmit={handleFeedbackSubmit}
                />
            )}
        </div>
    );
}

function FeedbackModal({ task, onClose, onSubmit }) {
    const [rating, setRating] = useState(task.rating || 5);
    const [comments, setComments] = useState(task.feedback_comments || '');

    return (
        <div className="fixed inset-0 z-[60] flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm">
            <div className="bg-white w-full max-w-md rounded-2xl p-6 shadow-2xl animate-in fade-in zoom-in-95 duration-200">
                <div className="flex justify-between items-center mb-6">
                    <div>
                        <h3 className="text-xl font-bold text-gray-900 leading-tight">Task Feedback</h3>
                        <p className="text-sm text-gray-500 mt-0.5">{task.title}</p>
                    </div>
                    <button onClick={onClose} className="p-2 hover:bg-gray-100 rounded-full transition-colors">
                        <X className="h-5 w-5 text-gray-400" />
                    </button>
                </div>

                <div className="space-y-6">
                    <div>
                        <label className="block text-sm font-bold text-gray-700 mb-3 uppercase tracking-wider">Rating</label>
                        <div className="flex gap-2">
                            {[1, 2, 3, 4, 5].map((star) => (
                                <button
                                    key={star}
                                    onClick={() => setRating(star)}
                                    className="p-1 transition-transform active:scale-90"
                                >
                                    <Star
                                        className={`h-8 w-8 transition-colors ${star <= rating
                                            ? "text-amber-400 fill-amber-400"
                                            : "text-gray-200 fill-gray-200"
                                            }`}
                                    />
                                </button>
                            ))}
                        </div>
                    </div>

                    <div>
                        <label className="block text-sm font-bold text-gray-700 mb-2 uppercase tracking-wider">Comments</label>
                        <textarea
                            rows="4"
                            className="w-full border border-gray-200 rounded-xl p-3 text-sm focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] outline-none transition-all resize-none"
                            placeholder="Write your feedback here..."
                            value={comments}
                            onChange={(e) => setComments(e.target.value)}
                        />
                    </div>

                    <div className="flex gap-3 pt-2">
                        <button
                            onClick={onClose}
                            className="flex-1 py-3 px-4 rounded-xl text-sm font-bold text-gray-600 bg-gray-50 hover:bg-gray-100 transition-colors border border-gray-200"
                        >
                            Cancel
                        </button>
                        <button
                            onClick={() => onSubmit(task.id, rating, comments)}
                            className="flex-1 py-3 px-4 rounded-xl text-sm font-bold text-white bg-[#ae2b2b] hover:bg-[#8b1e1e] transition-all shadow-md flex items-center justify-center gap-2"
                        >
                            <MessageSquare className="h-4 w-4" />
                            Save Feedback
                        </button>
                    </div>
                </div>
            </div>
        </div>
    );
}
