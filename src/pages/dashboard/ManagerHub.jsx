import { useState, useEffect } from "react";
import { useAuth } from "@/context/AuthContext";
import { supabase } from "@/lib/supabase";
import {

    Briefcase, CheckSquare, Clock, Users, Award,
    Plus, Check, X, Search, ChevronRight, Trash2, Archive, Star, MessageSquare,
    FileSpreadsheet, RotateCcw, History
} from "lucide-react";
import { motion } from "framer-motion";
import * as XLSX from 'xlsx';

export default function ManagerHub() {
    const { user } = useAuth();
    const [activeTab, setActiveTab] = useState("approvals");
    const [projects, setProjects] = useState([]);
    const [pendingTimesheets, setPendingTimesheets] = useState([]);
    const [historyTimesheets, setHistoryTimesheets] = useState([]);
    const [pendingIdeas, setPendingIdeas] = useState([]);
    const [historyIdeas, setHistoryIdeas] = useState([]);
    const [volunteers, setVolunteers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [selectedTaskForFeedback, setSelectedTaskForFeedback] = useState(null);

    const [editingProject, setEditingProject] = useState(null);
    const [creatingTask, setCreatingTask] = useState(false);

    const [taskForm, setTaskForm] = useState({
        title: "",
        description: "",
        projectId: "",
        assigneeId: "",
        deadline: ""
    });

    const handleDeleteOpportunity = async (id) => {
        if (!window.confirm("Are you sure you want to delete this opportunity?")) return;
        try {
            const { error } = await supabase.from('announcements').delete().eq('id', id);
            if (error) throw error;
            setPostedOpportunities(prev => prev.filter(o => o.id !== id));
        } catch (error) {
            console.error("Delete Error:", error);
            alert("Failed to delete opportunity.");
        }
    };

    const [volunteerSearch, setVolunteerSearch] = useState("");
    const [showVolList, setShowVolList] = useState(false);

    // Team Management State
    const [teamMembers, setTeamMembers] = useState([]);
    const [teamProjectId, setTeamProjectId] = useState("");
    const [manageTeamSearch, setManageTeamSearch] = useState("");
    const [showManageTeamList, setShowManageTeamList] = useState(false);

    // Tasks tracking
    const [teamTasks, setTeamTasks] = useState([]);
    const [showArchivedTasks, setShowArchivedTasks] = useState(false);

    useEffect(() => {
        if (!user) return;

        // Continue to set up project-specific state if available
        if (user.managed_projects && Array.isArray(user.managed_projects) && user.managed_projects.length > 0) {
            setProjects(user.managed_projects);
            // Default select first project
            const firstProjId = user.managed_projects[0].id;
            setTaskForm(prev => ({ ...prev, projectId: firstProjId }));
            setTeamProjectId(firstProjId);

            fetchTeamMembers(firstProjId);
            fetchTeamTasks(firstProjId);
        } else {
            // User loaded but no projects
            setProjects([]);
        }

        // ALWAYS fetch general manager data (like volunteers list, opportunities)
        fetchManagerData();
        setLoading(false);
    }, [user]);

    const fetchTeamMembers = async (projId) => {
        if (!projId) return;
        try {
            const { data, error } = await supabase
                .from('project_volunteers')
                .select(`
                    id,
                    project_id,
                    status,
                    volunteer:volunteers(id, first_name, last_name, ilj_id, email, designation, secondary_designation)
                `)
                .eq('project_id', projId);

            if (error) throw error;
            // Attach project_volunteers.status as engagement_status, and the junction id as pv_id
            setTeamMembers(data?.filter(d => Boolean(d.volunteer)).map(d => ({ 
                ...d.volunteer, 
                engagement_status: d.status,
                pv_id: d.id
            })) || []);
        } catch (error) {
            console.error("Fetch Team Error:", error);
        }
    };

    const fetchTeamTasks = async (projId) => {
        if (!projId) return;
        try {
            const { data, error } = await supabase
                .from('tasks')
                .select(`
                    id,
                    title,
                    status,
                    deadline,
                    rating,
                    feedback_comments,
                    assignee:volunteers(first_name, last_name, ilj_id, designation, secondary_designation)
                `)
                .eq('project_id', projId)
                .order('created_at', { ascending: false });

            if (error) throw error;
            setTeamTasks(data || []);
        } catch (error) {
            console.error("Fetch Team Tasks Error:", error);
        }
    };

    const handleAddToTeam = async (volunteerId) => {
        if (!teamProjectId) return;
        try {
            // Check if already in team
            const exists = teamMembers.find(m => m.id === volunteerId);
            if (exists) {
                alert("Volunteer is already in the team!");
                return;
            }

            const { error } = await supabase
                .from('project_volunteers')
                .insert({
                    project_id: teamProjectId,
                    volunteer_id: volunteerId,
                    status: 'active',
                    assigned_at: new Date()
                });

            if (error) throw error;

            // Refresh team
            fetchTeamMembers(teamProjectId);
            setManageTeamSearch("");
            setShowManageTeamList(false);
            alert("Member added to team!");
        } catch (error) {
            console.error("Add Team Error:", error);
            alert("Failed to add member.");
        }
    };

    const handleRemoveFromTeam = async (volunteerId) => {
        if (!confirm("Remove this volunteer from the team?")) return;
        try {
            const { error } = await supabase
                .from('project_volunteers')
                .delete()
                .eq('project_id', teamProjectId)
                .eq('volunteer_id', volunteerId);

            if (error) throw error;

            setTeamMembers(prev => prev.filter(m => m && m.id !== volunteerId));
        } catch (error) {
            console.error("Remove Team Error:", error);
            alert("Failed to remove member.");
        }
    };

    const handleUpdateEngagementStatus = async (pvId, newStatus) => {
        try {
            const { error } = await supabase
                .from('project_volunteers')
                .update({ status: newStatus })
                .eq('id', pvId);

            if (error) throw error;

            setTeamMembers(prev => prev.map(m => m.pv_id === pvId ? { ...m, engagement_status: newStatus } : m));
        } catch (error) {
            console.error("Update Engagement Error:", error);
            alert("Failed to update engagement status.");
        }
    };

    const handleFeedbackSubmit = async (taskId, rating, comments) => {
        try {
            const { error } = await supabase
                .from('tasks')
                .update({ rating: parseInt(rating), feedback_comments: comments })
                .eq('id', taskId);

            if (error) throw error;

            setTeamTasks(prev => prev.map(t => t.id === taskId ? { ...t, rating, feedback_comments: comments } : t));
            setSelectedTaskForFeedback(null);
            alert("Feedback saved!");
        } catch (err) {
            alert("Error saving feedback: " + err.message);
        }
    };

    const [postedOpportunities, setPostedOpportunities] = useState([]);

    // Assignment Type: 'volunteer', 'team', 'general'
    const [assignmentType, setAssignmentType] = useState('volunteer');

    const fetchManagerData = async () => {
        // Allow fetching if user exists, even if managed_projects is empty (in case we need to fetch other things or if projects are loaded differently)
        if (!user) return;
        setLoading(true);
        try {
            const projectIds = (user.managed_projects || []).map(p => p.id);

            // 1. Fetch ALL Timesheets for these projects (Pending + History)
            
            // Fetch Ideas
            const { data: ideasData, error: ideasError } = await supabase
                .from('ideas')
                .select('*, volunteer:volunteers(first_name, last_name, ilj_id), project:projects(title)')
                .in('project_id', projectIds)
                .order('created_at', { ascending: false });

            if (ideasError) throw ideasError;
            
            const pIdeas = [];
            const hIdeas = [];
            (ideasData || []).forEach(idea => {
                if (idea.status === 'pending') pIdeas.push(idea);
                else hIdeas.push(idea);
            });
            setPendingIdeas(pIdeas);
            setHistoryIdeas(hIdeas);

            const { data: timesheets, error: tsError } = await supabase
                .from('timesheets')
                .select(`
                    *,
                    volunteer:volunteers(first_name, last_name, ilj_id, designation, secondary_designation),
                    project:projects(title)
                `)
                .in('project_id', projectIds)
                .neq('volunteer_id', user.id) // PMs cannot approve their own timesheets
                .order('date_worked', { ascending: false });

            if (tsError) throw tsError;

            // Filter: 
            // 1. Exclude "Pod Manager" designations if any (handled by Admin)
            // 2. Split into Pending vs History
            const filteredTimesheets = (timesheets || []).filter(t =>
                t.volunteer?.designation !== 'Pod Manager' &&
                t.volunteer?.designation !== 'Director' // Also exclude Director if any
            );

            setPendingTimesheets(filteredTimesheets.filter(t => t.status === 'pending'));
            setHistoryTimesheets(filteredTimesheets.filter(t => ['approved', 'rejected'].includes(t.status)));

            // 2. Fetch Volunteers for Task Assignment
            const { data: volData, error: vError } = await supabase
                .from('volunteers')
                .select('id, first_name, last_name, ilj_id, email')
                .order('first_name');

            if (vError) throw vError;
            setVolunteers(volData || []);

            // 3. Fetch Posted Opportunities
            const { data: opps, error: oppError } = await supabase
                .from('announcements')
                .select(`
                    *,
                    interests:announcement_interests(
                        volunteer:volunteers(id, first_name, last_name, ilj_id, email, mobile_number)
                    ),
                    project:projects(title)
                `)
                .eq('created_by', user.id)
                .eq('type', 'task_opportunity')
                .order('created_at', { ascending: false });

            if (oppError) throw oppError;
            setPostedOpportunities(opps || []);

        } catch (error) {
            console.error("Manager Data Error:", error);
        } finally {
            setLoading(false);
        }
    };

    const handleApproval = async (id, status) => {
        try {
            const { error } = await supabase
                .from('timesheets')
                .update({ status })
                .eq('id', id);

            if (error) throw error;

            // Move from pending to history locally
            const item = pendingTimesheets.find(t => t.id === id);
            if (item) {
                setPendingTimesheets(prev => prev.filter(t => t.id !== id));
                setHistoryTimesheets(prev => [{ ...item, status }, ...prev]);
            }
            alert(`Timesheet ${status === 'approved' ? 'Approved' : 'Rejected'}`);
        } catch (error) {
            console.error("Approval Error:", error);
            alert("Action failed.");
        }
    };

    const handleIdeaApproval = async (id, status) => {
        try {
            const { error } = await supabase.from('ideas').update({ status }).eq('id', id);
            if (error) throw error;
            const item = pendingIdeas.find(i => i.id === id);
            if (item) {
                setPendingIdeas(prev => prev.filter(i => i.id !== id));
                setHistoryIdeas(prev => [{ ...item, status }, ...prev]);
            }
            alert("Idea status updated!");
        } catch (error) {
            console.error(error);
            alert("Failed to update idea.");
        }
    };

    const handleRevertStatus = async (id) => {
        if (!confirm("Are you sure you want to revert this timesheet to Pending?")) return;
        try {
            const { error } = await supabase
                .from('timesheets')
                .update({ status: 'pending' })
                .eq('id', id);

            if (error) throw error;

            // Move from history to pending locally
            const item = historyTimesheets.find(t => t.id === id);
            if (item) {
                setHistoryTimesheets(prev => prev.filter(t => t.id !== id));
                setPendingTimesheets(prev => [{ ...item, status: 'pending' }, ...prev]);
            }
            alert("Timesheet reverted to Pending.");
        } catch (error) {
            console.error("Revert Error:", error);
            alert("Action failed.");
        }
    };

    const exportToExcel = (data, fileName) => {
        const worksheet = XLSX.utils.json_to_sheet(data);
        const workbook = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(workbook, worksheet, "Sheet1");
        XLSX.writeFile(workbook, `${fileName}.xlsx`);
    };

    const handleExportTimesheets = () => {
        const dataToExport = [...pendingTimesheets, ...historyTimesheets].map(t => {
            return {
                Date_Worked: t.date_worked ? new Date(t.date_worked).toLocaleDateString() : 'N/A',
                ILJ_ID: t.volunteer?.ilj_id || 'N/A',
                Volunteer_Name: `${t.volunteer?.first_name || ''} ${t.volunteer?.last_name || ''}`.trim(),
                Project_Name: t.project?.title || 'Unknown',
                Hours: t.hours,
                Role: t.role,
                Work_Mode: t.work_mode,
                Status: t.status,
                Description: t.description
            };
        });
        exportToExcel(dataToExport, `Timesheets_Report_${new Date().toLocaleDateString().replace(/\//g, '-')}`);
    };

    const handleExportTeam = () => {
        const dataToExport = teamMembers.map(m => {
            return {
                ILJ_ID: m.ilj_id,
                First_Name: m.first_name,
                Last_Name: m.last_name,
                Email: m.email,
                Designation: m.designation,
                Secondary_Designation: m.secondary_designation
            };
        });
        exportToExcel(dataToExport, `Team_List_${new Date().toLocaleDateString().replace(/\//g, '-')}`);
    };

    const handleCreateTask = async (e) => {
        e.preventDefault();
        if (creatingTask) return;
        setCreatingTask(true);

        try {
            const project = projects.find(p => p.id === taskForm.projectId);

            if (assignmentType === 'general') {
                // 1. General Opportunity (Announcement)
                const { error } = await supabase.from('announcements').insert({
                    title: taskForm.title,
                    message: taskForm.description, // Mapping description to message
                    project_id: taskForm.projectId,
                    created_by: user.id,
                    type: 'task_opportunity',
                    deadline: taskForm.deadline || null
                });

                if (error) throw error;
                alert("Opportunity posted to announcements!");
                fetchManagerData(); // Reload opportunities list

            } else if (assignmentType === 'team') {
                // 2. Assign to Entire Team
                // Fetch team members first
                const { data: teamData, error: teamError } = await supabase
                    .from('project_volunteers')
                    .select('volunteer_id, volunteer:volunteers(id, email, first_name, last_name)')
                    .eq('project_id', taskForm.projectId);

                if (teamError) throw teamError;
                if (!teamData || teamData.length === 0) {
                    alert("No team members found for this project.");
                    return;
                }

                // Create tasks for all
                const tasksToInsert = teamData.map(m => ({
                    title: taskForm.title,
                    description: taskForm.description,
                    project_id: taskForm.projectId,
                    assignee_id: m.volunteer_id,
                    deadline: taskForm.deadline || null,
                    status: 'pending'
                }));

                const { error: insertError } = await supabase.from('tasks').insert(tasksToInsert);
                if (insertError) throw insertError;

                // Send Emails (fire and forget loop)
                teamData.forEach(async (m) => {
                    const assignee = m.volunteer;
                    if (assignee?.email) {
                        const { error: invokeError } = await supabase.functions.invoke('send-task-email', {
                            body: {
                                to: assignee.email,
                                assignee_name: `${assignee.first_name} ${assignee.last_name}`,
                                manager_name: `${user.first_name} ${user.last_name}`,
                                project_title: project?.title || 'Unknown Project',
                                task_title: taskForm.title,
                                task_description: taskForm.description,
                                deadline: taskForm.deadline
                            }
                        });
                        if (invokeError) console.error("Email fail for " + assignee.email, invokeError);
                    }
                });

                // Insert Notifications
                const notificationsToInsert = teamData.map(m => ({
                    user_id: m.volunteer_id,
                    message: `New Task Assigned: ${taskForm.title} in project ${project?.title || 'Unknown'}`,
                    is_read: false
                }));
                await supabase.from('notifications').insert(notificationsToInsert);

                alert(`Task assigned to ${tasksToInsert.length} team members!`);

            } else {
                // 3. Specific Volunteer (Original)
                if (!taskForm.assigneeId) {
                    alert("Please select a volunteer.");
                    return;
                }

                const { error } = await supabase.from('tasks').insert({
                    title: taskForm.title,
                    description: taskForm.description,
                    project_id: taskForm.projectId,
                    assignee_id: taskForm.assigneeId,
                    deadline: taskForm.deadline || null,
                    status: 'pending'
                });

                if (error) throw error;

                // Send Email Notification
                const assignee = volunteers.find(v => v.id === taskForm.assigneeId);

                if (assignee?.email) {
                    try {
                        // Using manual fetch to be more robust than invoke
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
                                manager_name: `${user.first_name} ${user.last_name}`,
                                project_title: project?.title || 'Unknown Project',
                                task_title: taskForm.title,
                                task_description: taskForm.description,
                                deadline: taskForm.deadline
                            })
                        });

                        const result = await response.json();
                        if (!response.ok) {
                            console.error("Email API failure:", result);
                            alert(`Task created, but email failed: ${result.error || response.statusText}`);
                        } else {
                            console.log("Email sent:", result);
                        }
                    } catch (fetchErr) {
                        console.error("Email Network Error:", fetchErr);
                        alert(`Task created, but email notification failed (Network Error).`);
                    }
                }

                // Insert Notification
                await supabase.from('notifications').insert({
                    user_id: taskForm.assigneeId,
                    message: `New Task Assigned: ${taskForm.title} in project ${project?.title || 'Unknown'}`,
                    is_read: false
                });

                alert("Task assigned & notification sent!");
            }

            // Reset Form (but keep project selection)
            setTaskForm({ ...taskForm, title: "", description: "", assigneeId: "" });

        } catch (error) {
            console.error("Task Creation Error:", error);
            alert("Failed to assign task.");
        } finally {
            setCreatingTask(false);
        }
    };

    const handleUpdateProject = async (e) => {
        e.preventDefault();
        try {
            const { error } = await supabase
                .from('projects')
                .update({
                    title: editingProject.title,
                    description: editingProject.description,
                    status: editingProject.status
                })
                .eq('id', editingProject.id);

            if (error) throw error;

            alert("Project updated successfully!");
            // Update local state
            setProjects(prev => prev.map(p => p.id === editingProject.id ? editingProject : p));
            setEditingProject(null);
        } catch (error) {
            console.error("Project Update Error:", error);
            alert("Failed to update project.");
        }
    };

    // ... (existing render)

    return (
        <div className="space-y-6">
            {/* Header */}
            {/* ... */}

            {/* Tabs */}
            <div className="flex flex-wrap gap-2 md:gap-0 border-b-0 md:border-b border-gray-200">
                {[
                    { id: "projects", label: "My Pods", icon: Briefcase },
                    { id: "team", label: "My Team", icon: Users },
                    { id: "approvals", label: "Approvals", icon: Clock, count: pendingTimesheets.length + pendingIdeas.length },
                    { id: "history", label: "History", icon: History },
                    { id: "tasks", label: "Assign Tasks", icon: CheckSquare },
                    { id: "opportunities", label: "Opportunities", icon: Award }
                ].map((tab) => {
                    const Icon = tab.icon;
                    const isActive = activeTab === tab.id;
                    return (
                        <button
                            key={tab.id}
                            onClick={() => setActiveTab(tab.id)}
                            className={`flex-1 md:flex-none flex items-center justify-center gap-2 px-4 py-3 md:px-6 md:py-3 font-medium text-sm transition-all
                                rounded-xl md:rounded-none md:border-b-2 whitespace-nowrap
                                ${isActive
                                    ? "bg-[#ae2b2b] text-white md:bg-transparent md:border-[#ae2b2b] md:text-[#ae2b2b]"
                                    : "bg-white text-gray-500 border border-gray-100 md:bg-transparent md:border-transparent md:border-b-2 hover:text-gray-700"
                                }
                            `}
                        >
                            <Icon className="h-4 w-4" />
                            <span>{tab.label}</span>
                            {tab.count > 0 && (
                                <span className={`px-2 py-0.5 rounded-full text-xs font-bold ${isActive ? "bg-white text-[#ae2b2b] md:bg-red-100" : "bg-red-100 text-[#ae2b2b]"
                                    }`}>
                                    {tab.count}
                                </span>
                            )}
                        </button>
                    );
                })}
            </div>

            {/* Projects Tab */}
            {activeTab === "projects" && (
                <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="space-y-6">
                    <div className="grid grid-cols-1 gap-6">
                        {projects.map(project => (
                            <div key={project.id} className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                                <div className="p-6">
                                    <div className="flex justify-between items-start mb-4">
                                        <div>
                                            <h3 className="text-xl font-bold text-gray-900">{project.title}</h3>
                                            <span className={`inline-block mt-2 px-2.5 py-0.5 rounded-full text-xs font-medium uppercase tracking-wide ${project.status === 'active' ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'
                                                }`}>
                                                {project.status}
                                            </span>
                                        </div>
                                        <button
                                            onClick={() => setEditingProject(project)}
                                            className="text-sm border border-[#ae2b2b] text-[#ae2b2b] px-4 py-2 rounded-lg hover:bg-red-50 transition-colors font-medium"
                                        >
                                            Edit Details
                                        </button>
                                    </div>
                                    <p className="text-gray-600 mb-6">{project.description}</p>

                                    <div className="grid grid-cols-2 md:grid-cols-4 gap-4 py-4 border-t border-gray-100">
                                        <div>
                                            <p className="text-xs text-gray-500 uppercase tracking-wider">Created</p>
                                            <p className="font-mono text-sm">{new Date(project.created_at).toLocaleDateString()}</p>
                                        </div>
                                        <div>
                                            <p className="text-xs text-gray-500 uppercase tracking-wider">Pod Code</p>
                                            <p className="font-mono text-sm">{project.project_code}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        ))}
                    </div>

                    {/* Edit Project Modal */}
                    {editingProject && (
                        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4 backdrop-blur-sm">
                            <motion.div
                                initial={{ scale: 0.95 }}
                                animate={{ scale: 1 }}
                                className="bg-white rounded-2xl shadow-xl max-w-lg w-full overflow-hidden"
                            >
                                <div className="p-6 border-b border-gray-100 flex justify-between items-center">
                                    <h3 className="text-lg font-bold font-serif text-[#ae2b2b]">Edit Project Details</h3>
                                    <button onClick={() => setEditingProject(null)} className="text-gray-400 hover:text-gray-600">
                                        <X size={24} />
                                    </button>
                                </div>
                                <form onSubmit={handleUpdateProject} className="p-6 space-y-4">
                                    <div>
                                        <label className="block text-sm font-medium text-gray-700 mb-1">Pod Title</label>
                                        <input
                                            type="text"
                                            className="w-full border-gray-300 rounded-lg shadow-sm focus:ring-[#ae2b2b] focus:border-[#ae2b2b] p-2.5 border"
                                            value={editingProject.title}
                                            onChange={e => setEditingProject({ ...editingProject, title: e.target.value })}
                                            required
                                        />
                                    </div>
                                    <div>
                                        <label className="block text-sm font-medium text-gray-700 mb-1">Description</label>
                                        <textarea
                                            className="w-full border-gray-300 rounded-lg shadow-sm focus:ring-[#ae2b2b] focus:border-[#ae2b2b] p-2.5 border"
                                            rows="4"
                                            value={editingProject.description}
                                            onChange={e => setEditingProject({ ...editingProject, description: e.target.value })}
                                            required
                                        />
                                    </div>
                                    <div>
                                        <label className="block text-sm font-medium text-gray-700 mb-1">Status</label>
                                        <select
                                            className="w-full border-gray-300 rounded-lg shadow-sm focus:ring-[#ae2b2b] focus:border-[#ae2b2b] p-2.5 border bg-white"
                                            value={editingProject.status}
                                            onChange={e => setEditingProject({ ...editingProject, status: e.target.value })}
                                        >
                                            <option value="active">Active</option>
                                            <option value="completed">Completed</option>
                                            <option value="paused">Paused</option>
                                            <option value="archived">Archived</option>
                                        </select>
                                    </div>
                                    <div className="flex gap-3 pt-4">
                                        <button
                                            type="button"
                                            onClick={() => setEditingProject(null)}
                                            className="flex-1 py-2.5 bg-gray-100 text-gray-700 rounded-lg font-medium hover:bg-gray-200 transition-colors"
                                        >
                                            Cancel
                                        </button>
                                        <button
                                            type="submit"
                                            className="flex-1 py-2.5 bg-[#ae2b2b] text-white rounded-lg font-medium hover:bg-[#8b1e1e] transition-colors shadow-md"
                                        >
                                            Save Changes
                                        </button>
                                    </div>
                                </form>
                            </motion.div>
                        </div>
                    )}
                </motion.div>
            )}

            {/* Team Management Tab */}
            {activeTab === "team" && (
                <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="space-y-6">
                    {/* Project Selector for Team */}
                    <div className="bg-white p-4 rounded-xl border border-gray-200 shadow-sm flex items-center justify-between">
                        <div>
                            <h3 className="font-bold text-gray-900">Manage Team For:</h3>
                        </div>
                        <select
                            className="border-gray-300 rounded-lg shadow-sm focus:ring-[#ae2b2b] focus:border-[#ae2b2b] p-2 border bg-white text-sm"
                            value={teamProjectId}
                            onChange={(e) => {
                                setTeamProjectId(e.target.value);
                                fetchTeamMembers(e.target.value);
                                fetchTeamTasks(e.target.value);
                            }}
                        >
                            {projects.map(p => <option key={p.id} value={p.id}>{p.title}</option>)}
                        </select>
                    </div>

                    {/* Add Member Box */}
                    <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
                        <label className="block text-sm font-medium text-gray-700 mb-2">Add New Team Member</label>
                        <div className="relative">
                            <input
                                type="text"
                                className="w-full pl-10 border-gray-300 rounded-lg shadow-sm focus:ring-[#ae2b2b] focus:border-[#ae2b2b] p-3 border"
                                placeholder="Search volunteers to add..."
                                value={manageTeamSearch}
                                onChange={(e) => {
                                    setManageTeamSearch(e.target.value);
                                    setShowManageTeamList(true);
                                }}
                                onFocus={() => setShowManageTeamList(true)}
                            />
                            <Search className="absolute left-3 top-3.5 h-5 w-5 text-gray-400" />

                            {showManageTeamList && manageTeamSearch && (
                                <div className="absolute z-10 w-full mt-1 bg-white border border-gray-200 rounded-lg shadow-xl max-h-60 overflow-y-auto">
                                    {volunteers
                                        .filter(v =>
                                            !teamMembers.some(m => m.id === v.id) && // Exclude existing members
                                            (`${v.first_name} ${v.last_name} ${v.ilj_id}`.toLowerCase().includes(manageTeamSearch.toLowerCase()))
                                        )
                                        .map(v => (
                                            <div
                                                key={v.id}
                                                className="p-3 hover:bg-gray-50 cursor-pointer border-b border-gray-50 flex justify-between items-center"
                                                onClick={() => handleAddToTeam(v.id)}
                                            >
                                                <div>
                                                    <p className="font-medium text-gray-900">{v.first_name} {v.last_name}</p>
                                                    <p className="text-xs text-gray-500">{v.ilj_id}</p>
                                                </div>
                                                <Plus className="h-4 w-4 text-[#ae2b2b]" />
                                            </div>
                                        ))
                                    }
                                </div>
                            )}
                        </div>
                    </div>

                    {/* Team List */}
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                        {teamMembers.map(member => {
                            if (!member) return null; // Safe guard
                            return (
                                <div key={member.id} className="bg-white p-4 rounded-xl border border-gray-200 shadow-sm flex items-center justify-between group">
                                    <div className="flex items-center gap-3">
                                        <div className="w-10 h-10 rounded-full bg-gray-100 flex items-center justify-center text-[#ae2b2b] font-bold">
                                            {member.first_name?.[0]}{member.last_name?.[0]}
                                        </div>
                                        <div>
                                            <h4 className="font-bold text-gray-900 text-sm">{member.first_name} {member.last_name}</h4>
                                            <div className="flex items-center gap-2">
                                                <p className="text-xs text-gray-500">{member.ilj_id}</p>
                                                {member.designation && (
                                                    <span className="text-[9px] bg-blue-50 text-blue-600 px-1.5 py-0.5 rounded font-bold uppercase border border-blue-100/50">
                                                        {member.designation}
                                                    </span>
                                                )}
                                                {member.secondary_designation && (
                                                    <span className="text-[9px] bg-purple-50 text-purple-600 px-1.5 py-0.5 rounded font-bold uppercase border border-purple-100/50">
                                                        {member.secondary_designation}
                                                    </span>
                                                )}
                                            </div>
                                        </div>
                                    </div>
                                    <div className="flex flex-col items-end gap-2">
                                        <select
                                            value={member.engagement_status || 'active'}
                                            onChange={(e) => handleUpdateEngagementStatus(member.pv_id, e.target.value)}
                                            className={`text-xs px-2 py-1 rounded font-medium border appearance-none focus:outline-none focus:ring-1 focus:ring-[#ae2b2b] ${
                                                member.engagement_status === 'engaged' ? 'bg-green-50 text-green-700 border-green-200' :
                                                member.engagement_status === 'inactive' ? 'bg-gray-50 text-gray-600 border-gray-200' :
                                                'bg-[#ae2b2b]/10 text-[#ae2b2b] border-[#ae2b2b]/20'
                                            }`}
                                        >
                                            <option value="active">Active (Pending)</option>
                                            <option value="engaged">Engaged</option>
                                            <option value="inactive">Inactive</option>
                                        </select>
                                        <button
                                            onClick={() => handleRemoveFromTeam(member.id)}
                                            className="p-1.5 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors md:opacity-0 md:group-hover:opacity-100"
                                            title="Remove from team"
                                        >
                                            <Trash2 className="h-4 w-4 block md:hidden" />
                                            <X className="h-4 w-4 hidden md:block" />
                                        </button>
                                    </div>
                                </div>
                            )
                        })}
                        {teamMembers.length === 0 && (
                            <div className="col-span-full text-center py-12 text-gray-500 bg-gray-50 rounded-xl border border-dashed border-gray-200">
                                <Users className="h-12 w-12 mx-auto mb-3 opacity-20" />
                                <p>No team members assigned yet.</p>
                            </div>
                        )}
                    </div>

                    <div className="mt-6 flex justify-end">
                        <button
                            onClick={handleExportTeam}
                            className="flex items-center gap-2 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors font-bold text-sm"
                        >
                            <FileSpreadsheet className="h-4 w-4" /> Export Team List
                        </button>
                    </div>

                    {/* Team Tasks Status Section */}
                    <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm mt-8">
                        <div className="flex items-center justify-between mb-6">
                            <h3 className="font-bold text-gray-900 border-l-4 border-[#ae2b2b] pl-3">Team Task Status</h3>
                            <div className="flex gap-4">
                                <div className="flex items-center gap-1.5">
                                    <div className="w-2.5 h-2.5 rounded-full bg-blue-500"></div>
                                    <span className="text-xs text-gray-500">In Progress</span>
                                </div>
                                <div className="flex items-center gap-1.5">
                                    <div className="w-2.5 h-2.5 rounded-full bg-green-500"></div>
                                    <span className="text-xs text-gray-500">Completed</span>
                                </div>
                                <div className="flex items-center gap-1.5">
                                    <div className="w-2.5 h-2.5 rounded-full bg-red-400"></div>
                                    <span className="text-xs text-gray-500">Pending</span>
                                </div>
                                <button
                                    onClick={() => setShowArchivedTasks(!showArchivedTasks)}
                                    className={`text-xs px-2 py-1 rounded border transition-colors ${showArchivedTasks ? 'bg-amber-100 border-amber-300 text-amber-700' : 'bg-gray-50 border-gray-200 text-gray-500 hover:bg-gray-100'}`}
                                >
                                    {showArchivedTasks ? 'Show Active' : 'Show Archived'}
                                </button>
                            </div>
                        </div>

                        {teamTasks.filter(t => showArchivedTasks ? t.status === 'archived' : t.status !== 'archived').length === 0 ? (
                            <div className="text-center py-8 text-gray-400 border border-dashed rounded-lg">
                                {showArchivedTasks ? 'No archived tasks found.' : 'No tasks found for this pod.'}
                            </div>
                        ) : (
                            <div className="overflow-x-auto">
                                <table className="w-full text-sm text-left">
                                    <thead>
                                        <tr className="text-gray-500 border-b">
                                            <th className="pb-3 font-semibold">Volunteer</th>
                                            <th className="pb-3 font-semibold">Task Title</th>
                                            <th className="pb-3 font-semibold">Status</th>
                                            <th className="pb-3 font-semibold">Deadline</th>
                                            <th className="pb-3 font-semibold text-right">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody className="divide-y divide-gray-50">
                                        {teamTasks
                                            .filter(t => showArchivedTasks ? t.status === 'archived' : t.status !== 'archived')
                                            .map(task => (
                                                <tr key={task.id} className="hover:bg-gray-50 transition-colors">
                                                    <td className="py-3">
                                                        <div className="flex flex-col">
                                                            <p className="font-medium text-gray-900">{task.assignee?.first_name} {task.assignee?.last_name}</p>
                                                            <div className="flex items-center gap-2">
                                                                <p className="text-[10px] text-gray-400 font-mono">{task.assignee?.ilj_id}</p>
                                                                {task.assignee?.designation && (
                                                                    <span className="text-[9px] text-[#ae2b2b] bg-red-50 px-1 rounded font-bold border border-red-100/50">
                                                                        {task.assignee?.designation}
                                                                    </span>
                                                                )}
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td className="py-3 font-medium text-gray-700">{task.title}</td>
                                                    <td className="py-3">
                                                        <span className={`px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-wider
                                                        ${task.status === 'completed' ? 'bg-green-100 text-green-700' :
                                                                task.status === 'in_progress' ? 'bg-blue-100 text-blue-700' :
                                                                    'bg-red-50 text-red-600'}
                                                    `}>
                                                            {task.status.replace('_', ' ')}
                                                        </span>
                                                    </td>
                                                    <td className="py-3 text-gray-500">
                                                        {task.deadline ? new Date(task.deadline).toLocaleDateString() : '-'}
                                                    </td>
                                                    <td className="py-3 text-right">
                                                        <div className="flex items-center justify-end gap-2">
                                                            <button
                                                                onClick={async () => {
                                                                    const newStatus = task.status === 'archived' ? 'pending' : 'archived';
                                                                    const { error } = await supabase.from('tasks').update({ status: newStatus }).eq('id', task.id);
                                                                    if (error) {
                                                                        console.error(error);
                                                                        alert("Failed to update status");
                                                                    }
                                                                    else fetchTeamTasks(teamProjectId);
                                                                }}
                                                                className="text-gray-400 hover:text-amber-600 p-1.5 rounded hover:bg-amber-50 transition-colors"
                                                                title={task.status === 'archived' ? "Unarchive" : "Archive Task"}
                                                            >
                                                                <Archive className="h-4 w-4" />
                                                            </button>
                                                            <button
                                                                onClick={async () => {
                                                                    if (!confirm("Are you sure you want to delete this task? This cannot be undone.")) return;
                                                                    const { error } = await supabase.from('tasks').delete().eq('id', task.id);
                                                                    if (error) {
                                                                        console.error(error);
                                                                        alert("Failed to delete task");
                                                                    } else {
                                                                        fetchTeamTasks(teamProjectId);
                                                                    }
                                                                }}
                                                                className="text-gray-400 hover:text-red-600 p-1.5 rounded hover:bg-red-50 transition-colors"
                                                                title="Delete Task"
                                                            >
                                                                <Trash2 className="h-4 w-4" />
                                                            </button>
                                                            {task.status === 'completed' && (
                                                                <button
                                                                    onClick={() => setSelectedTaskForFeedback(task)}
                                                                    className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-bold transition-all shadow-sm
                                                                        ${task.rating
                                                                            ? 'bg-amber-50 text-amber-700 border border-amber-200 hover:bg-amber-100'
                                                                            : 'bg-blue-600 text-white hover:bg-blue-700 font-bold'
                                                                        }`}
                                                                >
                                                                    <Star className={`h-3 w-3 ${task.rating ? 'fill-amber-500' : ''}`} />
                                                                    {task.rating ? task.rating : 'Rate'}
                                                                </button>
                                                            )}
                                                        </div>
                                                    </td>
                                                </tr>
                                            ))}
                                    </tbody>
                                </table>
                            </div>
                        )}
                    </div>
                </motion.div>
            )}

            {/* Approvals Tab */}
            {activeTab === "approvals" && (
                <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="space-y-4">
                    <div className="flex justify-between items-center mb-2">
                        <h3 className="font-bold text-gray-800">Pending Approvals</h3>
                        <button
                            onClick={handleExportTimesheets}
                            className="flex items-center gap-2 px-3 py-1.5 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 text-xs font-bold"
                        >
                            <FileSpreadsheet className="h-3.5 w-3.5" /> Export All Timesheets
                        </button>
                    </div>

                    {pendingTimesheets.length === 0 ? (
                        <div className="bg-white p-12 rounded-xl text-center border border-gray-200 border-dashed">
                            <CheckSquare className="h-12 w-12 text-green-500 mx-auto mb-4 opacity-50" />
                            <h3 className="text-lg font-medium text-gray-900">All Caught Up!</h3>
                            <p className="text-gray-500">No pending timesheets to approve.</p>
                        </div>
                    ) : (
                        <div className="grid grid-cols-1 gap-4">
                            {pendingTimesheets.map((ts) => (
                                <div key={ts.id} className="bg-white p-4 rounded-xl shadow-sm border border-gray-200 flex flex-col md:flex-row justify-between gap-4 md:items-center">
                                    <div className="flex items-start gap-4">
                                        <div className="w-10 h-10 rounded-full bg-gray-100 flex items-center justify-center text-[#ae2b2b] font-bold">
                                            {ts.volunteer?.first_name?.[0]}{ts.volunteer?.last_name?.[0]}
                                        </div>
                                        <div>
                                            <h4 className="font-bold text-gray-900">{ts.volunteer?.first_name} {ts.volunteer?.last_name}</h4>
                                            <p className="text-xs text-gray-500">{new Date(ts.date_worked).toLocaleDateString()}</p>
                                            <p className="text-sm mt-1 text-gray-700 bg-gray-50 p-2 rounded border border-gray-100 italic">"{ts.description}"</p>
                                        </div>
                                    </div>
                                    <div className="flex items-center gap-4">
                                        <div className="text-right mr-4">
                                            <span className="block text-2xl font-bold text-gray-900">{ts.hours}h</span>
                                            <span className="text-xs text-gray-500 uppercase">Logged</span>
                                        </div>
                                        <div className="flex gap-2">
                                            <button
                                                onClick={() => handleApproval(ts.id, 'rejected')}
                                                className="p-2 hover:bg-red-50 text-red-600 rounded-lg border border-transparent hover:border-red-100 transition-all"
                                                title="Reject"
                                            >
                                                <X className="h-5 w-5" />
                                            </button>
                                            <button
                                                onClick={() => handleApproval(ts.id, 'approved')}
                                                className="px-4 py-2 bg-green-600 hover:bg-green-700 text-white rounded-lg font-medium shadow-sm transition-all flex items-center gap-2"
                                            >
                                                <Check className="h-4 w-4" /> Approve
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            ))}
                        </div>
                    )}
                </motion.div>
            )}

            {/* History Tab */}
            {activeTab === "history" && (
                <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="space-y-4">
                    <div className="flex justify-between items-center mb-2">
                        <h3 className="font-bold text-gray-800">Processed Timesheets</h3>
                        <button
                            onClick={handleExportTimesheets}
                            className="flex items-center gap-2 px-3 py-1.5 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 text-xs font-bold"
                        >
                            <FileSpreadsheet className="h-3.5 w-3.5" /> Export All
                        </button>
                    </div>

                    {historyTimesheets.length === 0 ? (
                        <div className="bg-white p-12 rounded-xl text-center border border-gray-200 border-dashed">
                            <History className="h-12 w-12 text-gray-300 mx-auto mb-4 opacity-50" />
                            <h3 className="text-lg font-medium text-gray-900">No History Yet</h3>
                            <p className="text-gray-500">Processed timesheets will appear here.</p>
                        </div>
                    ) : (
                        <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                            <div className="overflow-x-auto">
                                <table className="w-full text-left text-sm">
                                    <thead className="bg-gray-50 text-gray-500 font-medium border-b border-gray-100">
                                        <tr>
                                            <th className="px-6 py-4">Volunteer</th>
                                            <th className="px-6 py-4">Date</th>
                                            <th className="px-6 py-4">Pod</th>
                                            <th className="px-6 py-4">Hours</th>
                                            <th className="px-6 py-4">Status</th>
                                            <th className="px-6 py-4 text-right">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody className="divide-y divide-gray-100">
                                        {historyTimesheets.map((ts) => (
                                            <tr key={ts.id} className="hover:bg-gray-50">
                                                <td className="px-6 py-4">
                                                    <div className="font-bold text-gray-900">{ts.volunteer?.first_name} {ts.volunteer?.last_name}</div>
                                                    <div className="text-xs text-gray-500">{ts.volunteer?.ilj_id}</div>
                                                </td>
                                                <td className="px-6 py-4 text-gray-600">{new Date(ts.date_worked).toLocaleDateString()}</td>
                                                <td className="px-6 py-4 text-gray-600">{ts.project?.title}</td>
                                                <td className="px-6 py-4 font-bold">{ts.hours}h</td>
                                                <td className="px-6 py-4">
                                                    <span className={`px-2 py-1 rounded-full text-xs font-bold uppercase ${ts.status === 'approved' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'
                                                        }`}>
                                                        {ts.status}
                                                    </span>
                                                </td>
                                                <td className="px-6 py-4 text-right">
                                                    <button
                                                        onClick={() => handleRevertStatus(ts.id)}
                                                        className="text-gray-400 hover:text-blue-600 p-1 rounded hover:bg-blue-50 transition-colors"
                                                        title="Revert to Pending"
                                                    >
                                                        <RotateCcw className="h-4 w-4" />
                                                    </button>
                                                </td>
                                            </tr>
                                        ))}
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    )}
                </motion.div>
            )}

            {/* History Tab */}
            {activeTab === "history" && (
                <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="space-y-4">
                    <div className="flex justify-between items-center mb-2">
                        <h3 className="font-bold text-gray-800">Processed Timesheets</h3>
                        <button
                            onClick={handleExportTimesheets}
                            className="flex items-center gap-2 px-3 py-1.5 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 text-xs font-bold"
                        >
                            <FileSpreadsheet className="h-3.5 w-3.5" /> Export All
                        </button>
                    </div>

                    {historyTimesheets.length === 0 ? (
                        <div className="bg-white p-12 rounded-xl text-center border border-gray-200 border-dashed">
                            <History className="h-12 w-12 text-gray-300 mx-auto mb-4 opacity-50" />
                            <h3 className="text-lg font-medium text-gray-900">No History Yet</h3>
                            <p className="text-gray-500">Processed timesheets will appear here.</p>
                        </div>
                    ) : (
                        <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                            <div className="overflow-x-auto">
                                <table className="w-full text-left text-sm">
                                    <thead className="bg-gray-50 text-gray-500 font-medium border-b border-gray-100">
                                        <tr>
                                            <th className="px-6 py-4">Volunteer</th>
                                            <th className="px-6 py-4">Date</th>
                                            <th className="px-6 py-4">Pod</th>
                                            <th className="px-6 py-4">Hours</th>
                                            <th className="px-6 py-4">Status</th>
                                            <th className="px-6 py-4 text-right">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody className="divide-y divide-gray-100">
                                        {historyTimesheets.map((ts) => (
                                            <tr key={ts.id} className="hover:bg-gray-50">
                                                <td className="px-6 py-4">
                                                    <div className="font-bold text-gray-900">{ts.volunteer?.first_name} {ts.volunteer?.last_name}</div>
                                                    <div className="text-xs text-gray-500">{ts.volunteer?.ilj_id}</div>
                                                </td>
                                                <td className="px-6 py-4 text-gray-600">{new Date(ts.date_worked).toLocaleDateString()}</td>
                                                <td className="px-6 py-4 text-gray-600">{ts.project?.title}</td>
                                                <td className="px-6 py-4 font-bold">{ts.hours}h</td>
                                                <td className="px-6 py-4">
                                                    <span className={`px-2 py-1 rounded-full text-xs font-bold uppercase ${ts.status === 'approved' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'
                                                        }`}>
                                                        {ts.status}
                                                    </span>
                                                </td>
                                                <td className="px-6 py-4 text-right">
                                                    <button
                                                        onClick={() => handleRevertStatus(ts.id)}
                                                        className="text-gray-400 hover:text-blue-600 p-1 rounded hover:bg-blue-50 transition-colors"
                                                        title="Revert to Pending"
                                                    >
                                                        <RotateCcw className="h-4 w-4" />
                                                    </button>
                                                </td>
                                            </tr>
                                        ))}
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    )}
                </motion.div>
            )}

            {/* Assign Tasks Tab */}
            {activeTab === "tasks" && (
                <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }}>
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 md:p-8 max-w-2xl mx-auto">
                        <h2 className="text-xl font-bold text-gray-900 mb-6">Create New Task / Opportunity</h2>
                        <form onSubmit={handleCreateTask} className="space-y-5">



                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Select Pod</label>
                                <select
                                    className="w-full border-gray-300 rounded-lg shadow-sm focus:ring-[#ae2b2b] focus:border-[#ae2b2b] p-2.5 border bg-white"
                                    value={taskForm.projectId}
                                    onChange={e => setTaskForm({ ...taskForm, projectId: e.target.value })}
                                    required
                                >
                                    {projects.map(p => (
                                        <option key={p.id} value={p.id}>{p.title}</option>
                                    ))}
                                </select>
                            </div>


                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">Assign To (Volunteer)</label>
                                    <div className="relative">
                                        <div className="relative">
                                            <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
                                            <input
                                                type="text"
                                                className="w-full pl-9 border-gray-300 rounded-lg shadow-sm focus:ring-[#ae2b2b] focus:border-[#ae2b2b] p-2.5 border"
                                                placeholder="Search by name or ILJ ID..."
                                                value={volunteerSearch}
                                                onChange={(e) => {
                                                    setVolunteerSearch(e.target.value);
                                                    setShowVolList(true);
                                                }}
                                                onFocus={() => setShowVolList(true)}
                                            />
                                        </div>

                                        {showVolList && volunteerSearch && (
                                            <div className="absolute z-10 w-full mt-1 bg-white border border-gray-200 rounded-lg shadow-lg max-h-60 overflow-y-auto">
                                                {volunteers
                                                    .filter(v => {
                                                        const fullName = `${v.first_name || ''} ${v.last_name || ''}`.toLowerCase();
                                                        const iljId = (v.ilj_id || '').toLowerCase();
                                                        const query = volunteerSearch.toLowerCase();
                                                        return fullName.includes(query) || iljId.includes(query);
                                                    })
                                                    .map(v => (
                                                        <div
                                                            key={v.id}
                                                            className="p-3 hover:bg-gray-50 cursor-pointer border-b border-gray-50 last:border-0"
                                                            onClick={() => {
                                                                setTaskForm(prev => ({ ...prev, assigneeId: v.id }));
                                                                setVolunteerSearch(`${v.first_name} ${v.last_name} (${v.ilj_id})`);
                                                                setShowVolList(false);
                                                            }}
                                                        >
                                                            <p className="text-sm font-medium text-gray-900">{v.first_name} {v.last_name}</p>
                                                            <p className="text-xs text-gray-500">{v.ilj_id}</p>
                                                        </div>
                                                    ))
                                                }
                                                {volunteers.filter(v => `${v.first_name} ${v.last_name}`.toLowerCase().includes(volunteerSearch.toLowerCase())).length === 0 && (
                                                    <div className="p-3 text-sm text-gray-500 text-center">No volunteers found</div>
                                                )}
                                            </div>
                                        )}
                                    </div>
                                </div>




                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Task Title</label>
                                <input
                                    type="text"
                                    className="w-full border-gray-300 rounded-lg shadow-sm focus:ring-[#ae2b2b] focus:border-[#ae2b2b] p-2.5 border"
                                    placeholder="e.g. Design Event Banner"
                                    value={taskForm.title}
                                    onChange={e => setTaskForm({ ...taskForm, title: e.target.value })}
                                    required
                                />
                            </div>

                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Description</label>
                                <textarea
                                    className="w-full border-gray-300 rounded-lg shadow-sm focus:ring-[#ae2b2b] focus:border-[#ae2b2b] p-2.5 border"
                                    rows="3"
                                    placeholder="Details about the task..."
                                    value={taskForm.description}
                                    onChange={e => setTaskForm({ ...taskForm, description: e.target.value })}
                                />
                            </div>


                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">Deadline</label>
                                    <input
                                        type="date"
                                        className="w-full border-gray-300 rounded-lg shadow-sm focus:ring-[#ae2b2b] focus:border-[#ae2b2b] p-2.5 border"
                                        value={taskForm.deadline}
                                        onChange={e => setTaskForm({ ...taskForm, deadline: e.target.value })}
                                        required
                                    />
                                </div>


                            <button
                                type="submit"
                                disabled={creatingTask}
                                className={`w-full py-3 rounded-lg font-bold transition-all shadow-md mt-4 flex items-center justify-center gap-2
                                    ${creatingTask ? 'bg-gray-400 cursor-not-allowed text-gray-100' : 'bg-[#ae2b2b] text-white hover:bg-[#8b1e1e]'}
                                `}
                            >
                                {creatingTask ? (
                                    <>
                                        <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-white"></div>
                                        Assigning...
                                    </>
                                ) : (
                                    'Assign Task'
                                )}
                            </button>
                        </form>
                    </div>
                </motion.div>
            )}

            {/* Opportunities Tab */}
            {activeTab === "opportunities" && (
                <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="space-y-6">
                    <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
                        <h3 className="font-bold text-gray-900 mb-4">Posted Opportunities</h3>
                        <p className="text-sm text-gray-500 mb-6">These tasks are visible to all volunteers in the Announcements section. Monitor interest here.</p>

                        <div className="space-y-4">
                            {postedOpportunities.map(opp => (
                                <div key={opp.id} className="border rounded-xl p-4 hover:shadow-md transition-shadow">
                                    <div className="flex justify-between items-start mb-2">
                                        <div>
                                            <h4 className="font-bold text-lg text-gray-900">{opp.title}</h4>
                                            <p className="text-xs text-gray-500">Pod: {opp.project?.title || 'General'} • Posted: {new Date(opp.created_at).toLocaleDateString()}</p>
                                        </div>
                                        <div className="flex items-center gap-2">
                                            {opp.deadline && (
                                                <span className="text-xs bg-red-50 text-red-600 px-2 py-1 rounded-full font-medium">
                                                    Deadline: {new Date(opp.deadline).toLocaleDateString()}
                                                </span>
                                            )}
                                            <button
                                                onClick={() => handleDeleteOpportunity(opp.id)}
                                                className="text-gray-400 hover:text-red-600 p-1"
                                                title="Delete Opportunity"
                                            >
                                                <X className="h-4 w-4" />
                                            </button>
                                        </div>
                                    </div>
                                    <p className="text-gray-600 text-sm mb-4 bg-gray-50 p-3 rounded-lg">{opp.message}</p>

                                    <div className="border-t pt-3">
                                        <h5 className="font-semibold text-sm text-gray-800 mb-3 flex items-center gap-2">
                                            <Users className="h-4 w-4 text-[#ae2b2b]" />
                                            Interested Volunteers ({opp.interests?.length || 0})
                                        </h5>
                                        {(!opp.interests || opp.interests.length === 0) ? (
                                            <p className="text-sm text-gray-400 italic">No interest shown yet.</p>
                                        ) : (
                                            <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                                                {opp.interests.map(interest => (
                                                    <div key={interest.volunteer.id} className="flex justify-between items-center p-2 bg-gray-50 rounded border border-gray-100">
                                                        <div className="flex items-center gap-2">
                                                            <div className="w-8 h-8 rounded-full bg-[#ae2b2b]/10 text-[#ae2b2b] flex items-center justify-center text-xs font-bold">
                                                                {interest.volunteer.first_name[0]}
                                                            </div>
                                                            <div>
                                                                <p className="text-sm font-medium">{interest.volunteer.first_name} {interest.volunteer.last_name}</p>
                                                                <p className="text-xs text-gray-500">{interest.volunteer.ilj_id}</p>
                                                                {interest.volunteer.mobile_number && <p className="text-xs text-gray-400">📞 {interest.volunteer.mobile_number}</p>}
                                                            </div>
                                                        </div>
                                                        <div className="flex flex-col items-end gap-1">
                                                            <a href={`mailto:${interest.volunteer.email}`} className="text-xs text-blue-600 hover:underline">{interest.volunteer.email}</a>
                                                        </div>
                                                    </div>
                                                ))}
                                            </div>
                                        )}
                                    </div>
                                </div>
                            ))}
                            {postedOpportunities.length === 0 && (
                                <div className="text-center py-8 text-gray-400">No opportunities posted yet.</div>
                            )}
                        </div>
                    </div>
                </motion.div>
            )}

            {selectedTaskForFeedback && (
                <div className="fixed inset-0 z-[60] flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm">
                    <div className="bg-white w-full max-w-md rounded-2xl p-6 shadow-2xl animate-in fade-in zoom-in-95 duration-200">
                        <div className="flex justify-between items-center mb-6">
                            <div>
                                <h3 className="text-xl font-bold text-gray-900 leading-tight">Task Feedback</h3>
                                <p className="text-sm text-gray-500 mt-0.5">{selectedTaskForFeedback.title}</p>
                            </div>
                            <button onClick={() => setSelectedTaskForFeedback(null)} className="p-2 hover:bg-gray-100 rounded-full transition-colors">
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
                                            onClick={() => setSelectedTaskForFeedback({ ...selectedTaskForFeedback, rating: star })}
                                            className="p-1 transition-transform active:scale-90"
                                        >
                                            <Star className={`h-8 w-8 transition-colors ${star <= (selectedTaskForFeedback.rating || 5) ? "text-amber-400 fill-amber-400" : "text-gray-200 fill-gray-200"}`} />
                                        </button>
                                    ))}
                                </div>
                            </div>
                            <div>
                                <label className="block text-sm font-bold text-gray-700 mb-2 uppercase tracking-wider">Comments</label>
                                <textarea
                                    className="w-full border border-gray-200 rounded-xl p-3 text-sm focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] outline-none transition-all resize-none min-h-[100px]"
                                    placeholder="Write your feedback here..."
                                    value={selectedTaskForFeedback.feedback_comments || ''}
                                    onChange={(e) => setSelectedTaskForFeedback({ ...selectedTaskForFeedback, feedback_comments: e.target.value })}
                                />
                            </div>
                            <button
                                onClick={() => handleFeedbackSubmit(selectedTaskForFeedback.id, selectedTaskForFeedback.rating || 5, selectedTaskForFeedback.feedback_comments)}
                                className="w-full py-4 bg-[#ae2b2b] text-white rounded-xl font-bold shadow-lg flex items-center justify-center gap-2 hover:bg-[#8b1e1e] transition-all"
                            >
                                <MessageSquare className="h-4 w-4" /> Save Feedback
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}
