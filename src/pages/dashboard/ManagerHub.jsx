import { useState, useEffect } from "react";
import { useAuth } from "@/context/AuthContext";
import { supabase } from "@/lib/supabase";
import {
    Briefcase, CheckSquare, Clock, Users, Award,
    Plus, Check, X, Search, ChevronRight
} from "lucide-react";
import { motion } from "framer-motion";

export default function ManagerHub() {
    const { user } = useAuth();
    const [activeTab, setActiveTab] = useState("approvals");
    const [projects, setProjects] = useState([]);
    const [pendingTimesheets, setPendingTimesheets] = useState([]);
    const [volunteers, setVolunteers] = useState([]);
    const [loading, setLoading] = useState(true);

    const [editingProject, setEditingProject] = useState(null);

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

    useEffect(() => {
        if (!user) return;

        if (user.managed_projects && Array.isArray(user.managed_projects) && user.managed_projects.length > 0) {
            setProjects(user.managed_projects);
            // Default select first project
            const firstProjId = user.managed_projects[0].id;
            setTaskForm(prev => ({ ...prev, projectId: firstProjId }));
            setTeamProjectId(firstProjId);

            fetchManagerData();
            fetchTeamMembers(firstProjId);
        } else {
            // User loaded but no projects
            setProjects([]);
            setLoading(false);
        }
    }, [user]);

    const fetchTeamMembers = async (projId) => {
        if (!projId) return;
        try {
            const { data, error } = await supabase
                .from('project_volunteers')
                .select(`
                    id,
                    project_id,
                    volunteer:volunteers(id, first_name, last_name, ilj_id, email)
                `)
                .eq('project_id', projId);

            if (error) throw error;
            setTeamMembers(data?.map(d => d.volunteer) || []);
        } catch (error) {
            console.error("Fetch Team Error:", error);
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

            setTeamMembers(prev => prev.filter(m => m.id !== volunteerId));
        } catch (error) {
            console.error("Remove Team Error:", error);
            alert("Failed to remove member.");
        }
    };

    const [postedOpportunities, setPostedOpportunities] = useState([]);

    // Assignment Type: 'volunteer', 'team', 'general'
    const [assignmentType, setAssignmentType] = useState('volunteer');

    const fetchManagerData = async () => {
        if (!user.managed_projects || user.managed_projects.length === 0) return;
        setLoading(true);
        try {
            const projectIds = user.managed_projects.map(p => p.id);

            // 1. Fetch Pending Timesheets for these projects
            const { data: timesheets, error: tsError } = await supabase
                .from('timesheets')
                .select(`
                    *,
                    volunteer:volunteers(first_name, last_name, ilj_id),
                    project:projects(title)
                `)
                .in('project_id', projectIds)
                .eq('status', 'pending') // Only pending ones
                .order('date_worked', { ascending: false });

            if (tsError) throw tsError;
            setPendingTimesheets(timesheets || []);

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

            // Remove from list locally
            setPendingTimesheets(prev => prev.filter(t => t.id !== id));
            alert(`Timesheet ${status === 'approved' ? 'Approved' : 'Rejected'}`);
        } catch (error) {
            console.error("Approval Error:", error);
            alert("Action failed.");
        }
    };

    const handleCreateTask = async (e) => {
        e.preventDefault();
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
                    deadline: taskForm.deadline,
                    created_by: user.id,
                    status: 'pending'
                }));

                const { error: insertError } = await supabase.from('tasks').insert(tasksToInsert);
                if (insertError) throw insertError;

                // Send Emails (fire and forget loop)
                teamData.forEach(async (m) => {
                    const assignee = m.volunteer;
                    if (assignee?.email) {
                        await supabase.functions.invoke('send-task-email', {
                            body: {
                                to: assignee.email,
                                assignee_name: `${assignee.first_name} ${assignee.last_name}`,
                                manager_name: `${user.first_name} ${user.last_name}`,
                                project_title: project?.title || 'Unknown Project',
                                task_title: taskForm.title,
                                task_description: taskForm.description,
                                deadline: taskForm.deadline
                            }
                        }).catch(err => console.error("Email fail for " + assignee.email, err));
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
                    deadline: taskForm.deadline,
                    created_by: user.id,
                    status: 'pending'
                });

                if (error) throw error;

                // Send Email Notification
                const assignee = volunteers.find(v => v.id === taskForm.assigneeId);

                if (assignee?.email) {
                    const { error: emailError } = await supabase.functions.invoke('send-task-email', {
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
                    if (emailError) console.warn("Email sending failed:", emailError);
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
                    { id: "projects", label: "My Projects", icon: Briefcase },
                    { id: "team", label: "My Team", icon: Users },
                    { id: "approvals", label: "Approvals", icon: Clock, count: pendingTimesheets.length },
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
                                            <p className="text-xs text-gray-500 uppercase tracking-wider">Project Code</p>
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
                                        <label className="block text-sm font-medium text-gray-700 mb-1">Project Title</label>
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
                        {teamMembers.map(member => (
                            <div key={member.id} className="bg-white p-4 rounded-xl border border-gray-200 shadow-sm flex items-center justify-between group">
                                <div className="flex items-center gap-3">
                                    <div className="w-10 h-10 rounded-full bg-gray-100 flex items-center justify-center text-[#ae2b2b] font-bold">
                                        {member.first_name?.[0]}{member.last_name?.[0]}
                                    </div>
                                    <div>
                                        <h4 className="font-bold text-gray-900 text-sm">{member.first_name} {member.last_name}</h4>
                                        <p className="text-xs text-gray-500">{member.ilj_id}</p>
                                    </div>
                                </div>
                                <button
                                    onClick={() => handleRemoveFromTeam(member.id)}
                                    className="p-2 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors opacity-0 group-hover:opacity-100"
                                    title="Remove from team"
                                >
                                    <X className="h-4 w-4" />
                                </button>
                            </div>
                        ))}
                        {teamMembers.length === 0 && (
                            <div className="col-span-full text-center py-12 text-gray-500 bg-gray-50 rounded-xl border border-dashed border-gray-200">
                                <Users className="h-12 w-12 mx-auto mb-3 opacity-20" />
                                <p>No team members assigned yet.</p>
                            </div>
                        )}
                    </div>
                </motion.div>
            )}

            {/* Approvals Tab */}
            {activeTab === "approvals" && (
                <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="space-y-4">
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
                                            <p className="text-xs text-gray-500">{ts.project?.title} • {new Date(ts.date_worked).toLocaleDateString()}</p>
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

            {/* Assign Tasks Tab */}
            {activeTab === "tasks" && (
                <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }}>
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 md:p-8 max-w-2xl mx-auto">
                        <h2 className="text-xl font-bold text-gray-900 mb-6">Create New Task / Opportunity</h2>
                        <form onSubmit={handleCreateTask} className="space-y-5">

                            {/* Assignment Type Selection */}
                            <div className="grid grid-cols-3 gap-3 p-1 bg-gray-100 rounded-lg">
                                <button
                                    type="button"
                                    onClick={() => setAssignmentType('volunteer')}
                                    className={`py-2 px-3 rounded-md text-sm font-medium transition-all ${assignmentType === 'volunteer' ? 'bg-white text-[#ae2b2b] shadow-sm' : 'text-gray-500 hover:text-gray-700'
                                        }`}
                                >
                                    Specific Volunteer
                                </button>
                                <button
                                    type="button"
                                    onClick={() => setAssignmentType('team')}
                                    className={`py-2 px-3 rounded-md text-sm font-medium transition-all ${assignmentType === 'team' ? 'bg-white text-[#ae2b2b] shadow-sm' : 'text-gray-500 hover:text-gray-700'
                                        }`}
                                >
                                    Entire Team
                                </button>
                                <button
                                    type="button"
                                    onClick={() => setAssignmentType('general')}
                                    className={`py-2 px-3 rounded-md text-sm font-medium transition-all ${assignmentType === 'general' ? 'bg-white text-[#ae2b2b] shadow-sm' : 'text-gray-500 hover:text-gray-700'
                                        }`}
                                >
                                    General Opportunity
                                </button>
                            </div>

                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Select Project</label>
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

                            {assignmentType === 'volunteer' && (
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
                                                    .filter(v =>
                                                        `${v.first_name} ${v.last_name}`.toLowerCase().includes(volunteerSearch.toLowerCase()) ||
                                                        v.ilj_id.toLowerCase().includes(volunteerSearch.toLowerCase())
                                                    )
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
                            )}

                            {assignmentType === 'team' && (
                                <div className="p-4 bg-blue-50 text-blue-800 rounded-lg text-sm border border-blue-100">
                                    This task will be assigned to <strong>all current members</strong> of the selected team.
                                </div>
                            )}

                            {assignmentType === 'general' && (
                                <div className="p-4 bg-purple-50 text-purple-800 rounded-lg text-sm border border-purple-100">
                                    This will be posted as an <strong>Opportunity</strong> in the Announcements section. Volunteers can express interest.
                                </div>
                            )}

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

                            {assignmentType !== 'general' && (
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
                            )}

                            <button
                                type="submit"
                                className="w-full bg-[#ae2b2b] text-white py-3 rounded-lg font-bold hover:bg-[#8b1e1e] transition-all shadow-md mt-4"
                            >
                                {assignmentType === 'general' ? 'Post Opportunity' : 'Assign Task'}
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
                                            <p className="text-xs text-gray-500">Project: {opp.project?.title || 'General'} • Posted: {new Date(opp.created_at).toLocaleDateString()}</p>
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
        </div>
    );
}
