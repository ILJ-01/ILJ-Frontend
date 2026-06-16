import React, { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import {
    Activity, Plus, Search, Users, CheckCircle, Search as SearchIcon, X, CheckSquare, Clock, Edit2, Trash2, PieChart, ChevronDown, ChevronUp, Download
} from 'lucide-react';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';
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

    // Summary View State
    const [activeTab, setActiveTab] = useState('tasks'); // 'tasks' or 'summary'
    const [globalAssignments, setGlobalAssignments] = useState([]);
    const [summaryLoading, setSummaryLoading] = useState(false);
    const [expandedSummaryVol, setExpandedSummaryVol] = useState(null);
    const [expandedSummaryTask, setExpandedSummaryTask] = useState(null);

    useEffect(() => {
        fetchTasks();
        fetchVolunteers();
        fetchAllAssignments();
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

    const fetchAllAssignments = async () => {
        try {
            setSummaryLoading(true);
            let allData = [];
            let page = 0;
            const pageSize = 1000;
            let keepFetching = true;
            
            while (keepFetching) {
                const { data, error } = await supabase
                    .from('spiritual_task_assignments')
                    .select(`
                        id, status,
                        task:spiritual_tasks(id, title),
                        volunteer:volunteers(id, first_name, last_name, ilj_id)
                    `)
                    .range(page * pageSize, (page + 1) * pageSize - 1);
                    
                if (error) throw error;
                
                if (!data || data.length === 0) {
                    keepFetching = false;
                } else {
                    allData = [...allData, ...data];
                    if (data.length < pageSize) {
                        keepFetching = false;
                    } else {
                        page++;
                    }
                }
            }
            setGlobalAssignments(allData);
        } catch (err) {
            console.error('Error fetching global assignments:', err);
        } finally {
            setSummaryLoading(false);
        }
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
            fetchAllAssignments(); // Refresh summaries
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
            fetchAllAssignments(); // Refresh summaries
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

    // Compute Summaries
    const volunteerStats = {};
    const taskStats = {};

    // Initialize taskStats with all created tasks to show tasks with 0 completions
    tasks.forEach(t => {
        taskStats[t.id] = {
            id: t.id,
            title: t.title,
            completedCount: 0,
            completedBy: []
        };
    });

    globalAssignments.forEach(a => {
        const vol = Array.isArray(a.volunteer) ? a.volunteer[0] : a.volunteer;
        const task = Array.isArray(a.task) ? a.task[0] : a.task;
        
        if (!vol || !task) return;
        
        // Vol stats
        const vId = vol.id;
        if (!volunteerStats[vId]) {
            volunteerStats[vId] = {
                id: vId,
                ilj_id: vol.ilj_id,
                name: `${vol.first_name || ''} ${vol.last_name || ''}`.trim(),
                completedCount: 0,
                completedTasks: []
            };
        }
        
        // Task stats
        const tId = task.id;
        if (!taskStats[tId]) {
            taskStats[tId] = {
                id: tId,
                title: task.title,
                completedCount: 0,
                completedBy: []
            };
        }

        if (a.status === 'completed') {
            volunteerStats[vId].completedCount += 1;
            volunteerStats[vId].completedTasks.push(task.title);

            taskStats[tId].completedCount += 1;
            taskStats[tId].completedBy.push({
                name: `${vol.first_name || ''} ${vol.last_name || ''}`.trim() || 'Unknown',
                ilj_id: vol.ilj_id || 'N/A'
            });
        }
    });

    const volunteerList = Object.values(volunteerStats).sort((a,b) => b.completedCount - a.completedCount);
    // You could filter volunteerList to only show those > 0: .filter(v => v.completedCount > 0)
    const taskList = Object.values(taskStats).sort((a,b) => b.completedCount - a.completedCount);

    const exportToPDF = () => {
        const doc = new jsPDF();
        
        // Brand Header
        doc.setFillColor(174, 43, 43); // #ae2b2b crimson
        doc.rect(0, 0, 210, 30, 'F');
        
        doc.setTextColor(255, 255, 255);
        doc.setFont('Helvetica', 'bold');
        doc.setFontSize(20);
        doc.text("I LOVE JINSHASAN", 15, 20);
        
        doc.setFontSize(10);
        doc.setFont('Helvetica', 'normal');
        doc.text("STC Summary Report", 150, 20);
        
        doc.setTextColor(30, 30, 30);
        doc.setFont('Helvetica', 'bold');
        doc.setFontSize(14);
        
        let tableHeaders = [];
        let tableData = [];
        let filename = '';

        if (activeTab === 'vol_summary') {
            doc.text("Volunteer Wise Spiritual Task (STC) Summary", 15, 45);
            doc.setFont('Helvetica', 'normal');
            doc.setFontSize(10);
            doc.setTextColor(100, 100, 100);
            doc.text(`Generated: ${new Date().toLocaleDateString('en-GB')}`, 15, 52);
            doc.line(15, 56, 195, 56);

            tableHeaders = [["ILJ Code", "Volunteer Name", "Tasks Completed", "Score/Points"]];
            tableData = volunteerList.map(v => [
                v.ilj_id || 'N/A',
                v.name || 'N/A',
                String(v.completedCount),
                `${v.completedCount} pts`
            ]);
            filename = `STC_Volunteer_Summary_${new Date().toISOString().slice(0, 10)}.pdf`;
        } else if (activeTab === 'task_summary') {
            doc.text("Task Wise Spiritual Task (STC) Summary", 15, 45);
            doc.setFont('Helvetica', 'normal');
            doc.setFontSize(10);
            doc.setTextColor(100, 100, 100);
            doc.text(`Generated: ${new Date().toLocaleDateString('en-GB')}`, 15, 52);
            doc.line(15, 56, 195, 56);

            tableHeaders = [["No.", "Task Title", "Completion Count", "Completed By Volunteers"]];
            tableData = taskList.map((t, index) => [
                String(index + 1),
                t.title || 'N/A',
                `${t.completedCount} Volunteers`,
                t.completedBy.map(v => `${v.name} (${v.ilj_id})`).join(', ') || 'None'
            ]);
            filename = `STC_Task_Summary_${new Date().toISOString().slice(0, 10)}.pdf`;
        } else {
            return; // Not applicable
        }

        autoTable(doc, {
            startY: 60,
            head: tableHeaders,
            body: tableData,
            theme: 'striped',
            headStyles: { fillColor: [174, 43, 43] },
            styles: { fontSize: 9, cellPadding: 3 },
            columnStyles: activeTab === 'task_summary' ? {
                0: { cellWidth: 12 },
                1: { cellWidth: 50 },
                2: { cellWidth: 35 },
                3: { cellWidth: 'auto' } // wrap volunteer list
            } : {},
            margin: { left: 15, right: 15 }
        });

        doc.save(filename);
    };

    return (
        <div className="space-y-6">
            {/* Header */}
            <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                <div className="flex items-center gap-2">
                    <Activity className="h-6 w-6 text-[#ae2b2b]" />
                    <h2 className="text-xl font-bold text-gray-900">Spiritual Tasks (STC)</h2>
                </div>
                <div className="flex gap-2 w-full sm:w-auto">
                    <div className="flex bg-gray-100 p-1 rounded-lg">
                        <button 
                            onClick={() => setActiveTab('tasks')}
                            className={`px-4 py-2 text-sm font-bold rounded-md transition-colors ${activeTab === 'tasks' ? 'bg-white text-[#ae2b2b] shadow-sm' : 'text-gray-600 hover:text-gray-900'}`}
                        >
                            <CheckSquare className="h-4 w-4 inline-block mr-1" /> Tasks
                        </button>
                        <button 
                            onClick={() => setActiveTab('vol_summary')}
                            className={`px-4 py-2 text-sm font-bold rounded-md transition-colors ${activeTab === 'vol_summary' ? 'bg-white text-[#ae2b2b] shadow-sm' : 'text-gray-600 hover:text-gray-900'}`}
                        >
                            <Users className="h-4 w-4 inline-block mr-1" /> Vol Summary
                        </button>
                        <button 
                            onClick={() => setActiveTab('task_summary')}
                            className={`px-4 py-2 text-sm font-bold rounded-md transition-colors ${activeTab === 'task_summary' ? 'bg-white text-[#ae2b2b] shadow-sm' : 'text-gray-600 hover:text-gray-900'}`}
                        >
                            <PieChart className="h-4 w-4 inline-block mr-1" /> Task Summary
                        </button>
                    </div>
                </div>
                {activeTab === 'tasks' ? (
                    <button
                        onClick={() => setShowCreateModal(true)}
                        className="flex items-center justify-center gap-2 bg-[#ae2b2b] text-white px-4 py-2 rounded-lg hover:bg-[#8b1e1e] transition-all shadow-md font-semibold text-sm w-full sm:w-auto"
                    >
                        <Plus className="h-4 w-4" /> Create STC Task
                    </button>
                ) : (
                    <button
                        onClick={exportToPDF}
                        className="flex items-center justify-center gap-2 bg-red-50 text-[#ae2b2b] border border-red-200 px-4 py-2 rounded-lg hover:bg-red-100 transition-all shadow-md font-semibold text-sm w-full sm:w-auto"
                    >
                        <Download className="h-4 w-4" /> Download PDF
                    </button>
                )}
            </div>

            {activeTab === 'tasks' ? (
                <>
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
            </>
            ) : (
                <div className="space-y-8 animate-in fade-in slide-in-from-bottom-2">
                    {summaryLoading ? (
                        <div className="flex justify-center items-center h-32">
                            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-amber-500"></div>
                        </div>
                    ) : (
                        <>
                            {/* Volunteer Wise Table */}
                            {activeTab === 'vol_summary' && (
                                <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                                    <div className="bg-gray-50 border-b border-gray-200 px-6 py-4">
                                        <h3 className="text-lg font-bold text-gray-900 flex items-center gap-2">
                                            <Users className="h-5 w-5 text-[#ae2b2b]" /> Volunteer Wise ST Summary
                                        </h3>
                                    </div>
                                    <div className="overflow-x-auto">
                                    <table className="w-full text-left text-sm cursor-default">
                                        <thead className="bg-gray-50/50 text-gray-500 font-bold uppercase tracking-wider text-xs">
                                            <tr>
                                                <th className="px-6 py-3 border-b border-gray-100">ID</th>
                                                <th className="px-6 py-3 border-b border-gray-100">Name</th>
                                                <th className="px-6 py-3 border-b border-gray-100 text-center">No. of Tasks Completed</th>
                                                <th className="px-6 py-3 border-b border-gray-100 text-center">Score</th>
                                                <th className="px-6 py-3 border-b border-gray-100 w-10"></th>
                                            </tr>
                                        </thead>
                                        <tbody className="divide-y divide-gray-100">
                                            {volunteerList.map(v => (
                                                <React.Fragment key={v.id}>
                                                    <tr 
                                                        className="hover:bg-gray-50/80 transition-colors cursor-pointer"
                                                        onClick={() => setExpandedSummaryVol(expandedSummaryVol === v.id ? null : v.id)}
                                                    >
                                                        <td className="px-6 py-4 text-gray-500 font-mono text-xs">{v.ilj_id || 'N/A'}</td>
                                                        <td className="px-6 py-4 font-bold text-gray-900">{v.name}</td>
                                                        <td className="px-6 py-4 text-center font-bold text-[#ae2b2b]">{v.completedCount}</td>
                                                        <td className="px-6 py-4 text-center">
                                                            <span className="bg-amber-100 text-amber-800 px-2 py-1 rounded font-bold text-xs">{v.completedCount} pts</span>
                                                        </td>
                                                        <td className="px-6 py-4 text-right text-gray-400">
                                                            {expandedSummaryVol === v.id ? <ChevronUp className="h-4 w-4" /> : <ChevronDown className="h-4 w-4" />}
                                                        </td>
                                                    </tr>
                                                    {expandedSummaryVol === v.id && (
                                                        <tr className="bg-gray-50/50">
                                                            <td colSpan={5} className="px-6 py-4">
                                                                <div className="text-xs font-bold text-gray-500 uppercase tracking-widest mb-2 border-b border-gray-200 pb-1">Tasks Completed by {v.name}</div>
                                                                {v.completedTasks.length > 0 ? (
                                                                    <ul className="list-disc pl-5 space-y-1 text-gray-700">
                                                                        {v.completedTasks.map((t, i) => (
                                                                            <li key={i}>{t}</li>
                                                                        ))}
                                                                    </ul>
                                                                ) : (
                                                                    <p className="text-gray-400 italic">No tasks completed yet.</p>
                                                                )}
                                                            </td>
                                                        </tr>
                                                    )}
                                                </React.Fragment>
                                            ))}
                                            {volunteerList.length === 0 && (
                                                <tr><td colSpan={5} className="px-6 py-8 text-center text-gray-500">No Volunteer Data Available.</td></tr>
                                            )}
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            )}
                            
                            {/* Task Wise Table */}
                            {activeTab === 'task_summary' && (
                            <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                                <div className="bg-gray-50 border-b border-gray-200 px-6 py-4">
                                    <h3 className="text-lg font-bold text-gray-900 flex items-center gap-2">
                                        <CheckSquare className="h-5 w-5 text-[#ae2b2b]" /> Task Wise ST Summary
                                    </h3>
                                </div>
                                <div className="overflow-x-auto">
                                    <table className="w-full text-left text-sm cursor-default">
                                        <thead className="bg-gray-50/50 text-gray-500 font-bold uppercase tracking-wider text-xs">
                                            <tr>
                                                <th className="px-6 py-3 border-b border-gray-100 w-16 text-center">No.</th>
                                                <th className="px-6 py-3 border-b border-gray-100">Task Title</th>
                                                <th className="px-6 py-3 border-b border-gray-100 text-center">Completed By (Volunteers)</th>
                                                <th className="px-6 py-3 border-b border-gray-100 w-10"></th>
                                            </tr>
                                        </thead>
                                        <tbody className="divide-y divide-gray-100">
                                            {taskList.map((t, index) => (
                                                <React.Fragment key={t.id}>
                                                    <tr 
                                                        className="hover:bg-gray-50/80 transition-colors cursor-pointer"
                                                        onClick={() => setExpandedSummaryTask(expandedSummaryTask === t.id ? null : t.id)}
                                                    >
                                                        <td className="px-6 py-4 text-center font-bold text-gray-400">{index + 1}</td>
                                                        <td className="px-6 py-4 font-bold text-gray-900">{t.title}</td>
                                                        <td className="px-6 py-4 text-center">
                                                            <span className="bg-green-50 text-green-700 px-3 py-1 rounded-full font-bold text-xs border border-green-100">{t.completedCount} Volunteers</span>
                                                        </td>
                                                        <td className="px-6 py-4 text-right text-gray-400">
                                                            {expandedSummaryTask === t.id ? <ChevronUp className="h-4 w-4" /> : <ChevronDown className="h-4 w-4" />}
                                                        </td>
                                                    </tr>
                                                    {expandedSummaryTask === t.id && (
                                                        <tr className="bg-gray-50/50">
                                                            <td colSpan={4} className="px-6 py-4">
                                                                <div className="text-xs font-bold text-gray-500 uppercase tracking-widest mb-2 border-b border-gray-200 pb-1">Volunteers who completed '{t.title}'</div>
                                                                {t.completedBy.length > 0 ? (
                                                                    <div className="flex flex-wrap gap-2 mt-2">
                                                                        {t.completedBy.map((v, i) => (
                                                                            <span key={i} className="bg-white border border-gray-200 text-gray-700 px-2.5 py-1 rounded text-xs shadow-sm font-medium flex items-center gap-1">
                                                                                <CheckCircle className="h-3 w-3 text-green-500" /> 
                                                                                {v.name} <span className="text-gray-400 font-mono">({v.ilj_id})</span>
                                                                            </span>
                                                                        ))}
                                                                    </div>
                                                                ) : (
                                                                    <p className="text-gray-400 italic">No volunteers have completed this task yet.</p>
                                                                )}
                                                            </td>
                                                        </tr>
                                                    )}
                                                </React.Fragment>
                                            ))}
                                            {taskList.length === 0 && (
                                                <tr><td colSpan={4} className="px-6 py-8 text-center text-gray-500">No Task Data Available.</td></tr>
                                            )}
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            )}
                        </>
                    )}
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
