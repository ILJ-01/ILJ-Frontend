import React, { useState, useEffect, useMemo } from 'react';
import { supabase } from '@/lib/supabase';
import { useNavigate } from 'react-router-dom';
import { 
    Users, Search, CheckCircle, Mail, Phone, MapPin, 
    MessageSquare, ClipboardList, UserCheck, AlertCircle,
    Briefcase, Clock, History, CheckSquare, Award, Plus,
    Trash2, Check, X, Archive, Star, FileSpreadsheet, RotateCcw,
    Lightbulb, Calendar, Download
} from 'lucide-react';
import { useAuth } from '@/context/AuthContext';
import { motion } from 'framer-motion';
import * as XLSX from 'xlsx';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';
import AdminRevaSessions from '../admin/AdminRevaSessions';
import AdminKivaSessions from '../admin/AdminKivaSessions';

const TABS = [
    { id: 'overview', label: 'Overview', icon: Briefcase },
    { id: 'team', label: 'Team Members', icon: Users },
    { id: 'approvals', label: 'Approvals', icon: Clock },
    { id: 'history', label: 'History', icon: History },
    { id: 'tasks', label: 'Assign Tasks', icon: CheckSquare },
    { id: 'opportunities', label: 'Opportunities', icon: Award }
];

const PodManagementHub = () => {
    const { user } = useAuth();
    const navigate = useNavigate();
    const [projects, setProjects] = useState([]);
    const [selectedProjectId, setSelectedProjectId] = useState('');
    const [activeTab, setActiveTab] = useState('overview');
    
    // Data states
    const [teamMembers, setTeamMembers] = useState([]);
    const [teamTasks, setTeamTasks] = useState([]);
    const [pendingTimesheets, setPendingTimesheets] = useState([]);
    const [historyTimesheets, setHistoryTimesheets] = useState([]);
    const [pendingIdeas, setPendingIdeas] = useState([]);
    const [historyIdeas, setHistoryIdeas] = useState([]);
    const [allVolunteers, setAllVolunteers] = useState([]);
    const [postedOpportunities, setPostedOpportunities] = useState([]);
    
    // Loaders
    const [loadingProjects, setLoadingProjects] = useState(true);
    const [loadingData, setLoadingData] = useState(true);
    const [creatingTask, setCreatingTask] = useState(false);
    
    // Search/UI states
    const [searchTerm, setSearchTerm] = useState('');
    const [manageTeamSearch, setManageTeamSearch] = useState('');
    const [showManageTeamList, setShowManageTeamList] = useState(false);
    const [volunteerSearch, setVolunteerSearch] = useState('');
    const [showVolList, setShowVolList] = useState(false);
    const [showArchivedTasks, setShowArchivedTasks] = useState(false);
    const [selectedVolunteer, setSelectedVolunteer] = useState(null);
    const [selectedTaskForFeedback, setSelectedTaskForFeedback] = useState(null);
    const [editingProject, setEditingProject] = useState(null);
    const [toastMessage, setToastMessage] = useState('');
    const [showCreateOppModal, setShowCreateOppModal] = useState(false);
    const [oppForm, setOppForm] = useState({
        title: "",
        description: "",
        deadline: ""
    });
    
    // Status indicators
    const [isUpdating, setIsUpdating] = useState({ state: false, id: null });
    const [isUpdatingActivity, setIsUpdatingActivity] = useState({ state: false, id: null });
    
    // Task parameters
    const [assignmentType, setAssignmentType] = useState('volunteer');
    const [taskForm, setTaskForm] = useState({
        title: "",
        description: "",
        projectId: "",
        assigneeId: "",
        deadline: ""
    });

    // Kiva and Reva Extra States
    const [eventRegistrations, setEventRegistrations] = useState([]);
    const [kivaRegistrations, setKivaRegistrations] = useState([]);
    const [kivaSessions, setKivaSessions] = useState([]);
    const [selectedReg, setSelectedReg] = useState(null);
    const [revaSearchQuery, setRevaSearchQuery] = useState('');
    const [kivaFilterEvent, setKivaFilterEvent] = useState('all');
    const [kivaFilterDate, setKivaFilterDate] = useState('all');
    const [kivaFilterRegStatus, setKivaFilterRegStatus] = useState('all'); // all, ilj, public
    const [kivaFilterAttStatus, setKivaFilterAttStatus] = useState('all'); // all, Attended/Visited, Not Attended
    const [kivaSearchQuery, setKivaSearchQuery] = useState('');
    const [kivaRegActiveTab, setKivaRegActiveTab] = useState('list'); // list or members

    const activeProject = useMemo(() => projects.find(p => p.id === selectedProjectId), [projects, selectedProjectId]);
    const projectCode = activeProject?.project_code;

    useEffect(() => {
        fetchProjects();
    }, [user?.id]);

    useEffect(() => {
        if (selectedProjectId) {
            fetchProjectData(selectedProjectId);
            setTaskForm(prev => ({ ...prev, projectId: selectedProjectId }));
            const proj = projects.find(p => p.id === selectedProjectId);
            if (proj) {
                const isRevaOrKiva = proj.project_code === 'PRJ-010' || proj.project_code === 'PRJ-009';
                if (!isRevaOrKiva && (activeTab === 'schedule' || activeTab === 'registrations')) {
                    setActiveTab('overview');
                }
            }
        } else {
            clearProjectData();
        }
    }, [selectedProjectId, projects]);

    const fetchProjects = async () => {
        if (!user?.id) return;
        setLoadingProjects(true);
        try {
            let query = supabase.from('projects').select('*').order('title');
            // Filter projects to show only managed projects or sub-headed projects unless CP/VCP
            if (!user?.isCPOrVCP) {
                query = query.or(`manager_id.eq.${user.id},sub_head_ids.cs.{${user.id}}`);
            }
            if (!user?.isITAdmin) {
                query = query.neq('status', 'archived');
            }
            
            const { data, error } = await query;
            if (error) throw error;
            
            setProjects(data || []);
            if (data && data.length > 0) {
                const cachedId = sessionStorage.getItem('selectedPodProjectId');
                const isValid = data.some(p => p.id === cachedId);
                const nextId = isValid ? cachedId : data[0].id;
                setSelectedProjectId(nextId);
                sessionStorage.setItem('selectedPodProjectId', nextId);
            }
        } catch (err) {
            console.error('Error fetching projects:', err);
        } finally {
            setLoadingProjects(false);
        }
    };

    const clearProjectData = () => {
        setTeamMembers([]);
        setTeamTasks([]);
        setPendingTimesheets([]);
        setHistoryTimesheets([]);
        setPendingIdeas([]);
        setHistoryIdeas([]);
        setPostedOpportunities([]);
        setEventRegistrations([]);
        setKivaRegistrations([]);
        setKivaSessions([]);
        setLoadingData(false);
    };

    const fetchProjectData = async (projId) => {
        if (!projId) return;
        
        // Safety Check: Verify user manages this project
        const isManagerOfProject = user?.managed_projects?.some(p => p.id === projId) || user?.isCPOrVCP;
        if (!isManagerOfProject) {
            console.error("Unauthorized access to project:", projId);
            clearProjectData();
            return;
        }

        const project = projects.find(p => p.id === projId);
        const projectCode = project?.project_code;

        setLoadingData(true);
        try {
            // 1. Team Members (from project_volunteers joined with volunteers)
            const { data: teamData, error: teamError } = await supabase
                .from('project_volunteers')
                .select(`
                    id,
                    project_id,
                    status,
                    engagement_status,
                    volunteer:volunteers(id, first_name, last_name, ilj_id, email, mobile_number, city, activity_status, state, dharmik_studies, qualification, occupation, skills, volunteering_preference1, availability_days, designation, secondary_designation)
                `)
                .eq('project_id', projId);

            if (teamError) throw teamError;
            
            const formattedTeam = teamData?.filter(d => Boolean(d.volunteer)).map(d => ({
                pv_id: d.id,
                engagement_status: d.status || d.engagement_status || 'pending',
                activity_status: d.volunteer.activity_status || 'Active',
                ...d.volunteer
            })) || [];
            setTeamMembers(formattedTeam);

            // 2. Team Tasks
            const { data: tasksData, error: tasksError } = await supabase
                .from('tasks')
                .select(`
                    id,
                    title,
                    description,
                    status,
                    deadline,
                    rating,
                    feedback_comments,
                    assignee:volunteers(id, first_name, last_name, ilj_id, designation, secondary_designation)
                `)
                .eq('project_id', projId)
                .order('created_at', { ascending: false });

            if (tasksError) throw tasksError;
            setTeamTasks(tasksData || []);

            // 3. Timesheets
            const { data: tsData, error: tsError } = await supabase
                .from('timesheets')
                .select(`
                    *,
                    volunteer:volunteers(first_name, last_name, ilj_id, designation, secondary_designation),
                    project:projects(title)
                `)
                .eq('project_id', projId)
                .order('date_worked', { ascending: false });

            if (tsError) throw tsError;

            const filteredTs = (tsData || []).filter(t =>
                t.volunteer?.designation !== 'Pod Manager' &&
                t.volunteer?.designation !== 'Director'
            );
            setPendingTimesheets(filteredTs.filter(t => t.status === 'pending'));
            setHistoryTimesheets(filteredTs.filter(t => ['approved', 'rejected'].includes(t.status)));

            // 4. Ideas
            const { data: ideasData, error: ideasError } = await supabase
                .from('ideas')
                .select('*, volunteer:volunteers(first_name, last_name, ilj_id), project:projects(title)')
                .eq('project_id', projId)
                .order('created_at', { ascending: false });

            if (ideasError) throw ideasError;

            setPendingIdeas((ideasData || []).filter(i => i.status === 'pending'));
            setHistoryIdeas((ideasData || []).filter(i => ['approved', 'reviewed', 'rejected'].includes(i.status)));

            // 5. Posted Opportunities
            const { data: oppsData, error: oppsError } = await supabase
                .from('announcements')
                .select(`
                    *,
                    interests:announcement_interests(
                        volunteer:volunteers(id, first_name, last_name, ilj_id, email, mobile_number)
                    ),
                    project:projects(title)
                `)
                .eq('project_id', projId)
                .eq('type', 'task_opportunity')
                .order('created_at', { ascending: false });

            if (oppsError) throw oppsError;
            setPostedOpportunities(oppsData || []);

            // 6. Fetch all volunteers for onboarding / task assign searches
            const { data: volData, error: volError } = await supabase
                .from('volunteers')
                .select('id, first_name, last_name, ilj_id, email')
                .order('first_name');

            if (volError) throw volError;
            setAllVolunteers(volData || []);

            // 7. Get Reva Registrations (PRJ-010)
            if (projectCode === 'PRJ-010') {
                const { data: registrations } = await supabase
                    .from('event_registrations')
                    .select('*')
                    .eq('project_id', projId)
                    .order('created_at', { ascending: false });
                setEventRegistrations(registrations || []);
            } else {
                setEventRegistrations([]);
            }

            // 8. Get KIVA Registrations & Sessions (PRJ-009)
            if (projectCode === 'PRJ-009') {
                const { data: kivaRegs } = await supabase
                    .from('kiva_registrations')
                    .select('*')
                    .eq('project_id', projId)
                    .order('created_at', { ascending: false });
                setKivaRegistrations(kivaRegs || []);

                const { data: kivaSess } = await supabase
                    .from('kiva_sessions')
                    .select('*')
                    .order('date', { ascending: true })
                    .order('time', { ascending: true });
                setKivaSessions(kivaSess || []);
            } else {
                setKivaRegistrations([]);
                setKivaSessions([]);
            }

        } catch (error) {
            console.error("Error fetching project data:", error);
        } finally {
            setLoadingData(false);
        }
    };

    // Database Mutations
    const handleUpdateStatus = async (pvId, newStatus) => {
        try {
            setIsUpdating({ state: true, id: pvId });
            const { error } = await supabase
                .from('project_volunteers')
                .update({ 
                    status: newStatus,
                    engagement_status: newStatus 
                })
                .eq('id', pvId);

            if (error) throw error;

            setTeamMembers(prev => prev.map(v => 
                v.pv_id === pvId ? { ...v, engagement_status: newStatus } : v
            ));

            setToastMessage('Engagement status updated successfully!');
            setTimeout(() => setToastMessage(''), 3000);
        } catch (error) {
            console.error('Error updating status:', error);
            setToastMessage(`Error: Failed to update status`);
            setTimeout(() => setToastMessage(''), 3000);
        } finally {
            setIsUpdating({ state: false, id: null });
        }
    };

    const handleToggleActivity = async (volunteerId, currentStatus) => {
        const newStatus = currentStatus === 'Active' ? 'Inactive' : 'Active';
        try {
            setIsUpdatingActivity({ state: true, id: volunteerId });
            
            const { error } = await supabase
                .from('volunteers')
                .update({ activity_status: newStatus })
                .eq('id', volunteerId);

            if (error) throw error;

            setTeamMembers(prev => prev.map(v => 
                v.id === volunteerId ? { ...v, activity_status: newStatus } : v
            ));

            setToastMessage(`Volunteer marked as ${newStatus}!`);
            setTimeout(() => setToastMessage(''), 3000);
        } catch (error) {
            console.error('Error updating activity status:', error);
            setToastMessage(`Error: Failed to update activity`);
            setTimeout(() => setToastMessage(''), 3000);
        } finally {
            setIsUpdatingActivity({ state: false, id: null });
        }
    };

    const handleAddToTeam = async (volunteerId) => {
        if (!selectedProjectId) return;
        try {
            const exists = teamMembers.find(m => m.id === volunteerId);
            if (exists) {
                alert("Volunteer is already in the team!");
                return;
            }

            const { error } = await supabase
                .from('project_volunteers')
                .insert({
                    project_id: selectedProjectId,
                    volunteer_id: volunteerId,
                    status: 'approved',
                    engagement_status: 'active',
                    assigned_at: new Date()
                });

            if (error) throw error;

            setToastMessage("Member successfully added to team!");
            setTimeout(() => setToastMessage(''), 3000);
            
            fetchProjectData(selectedProjectId);
            setManageTeamSearch("");
            setShowManageTeamList(false);
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
                .eq('project_id', selectedProjectId)
                .eq('volunteer_id', volunteerId);

            if (error) throw error;

            setTeamMembers(prev => prev.filter(m => m && m.id !== volunteerId));
            setToastMessage("Member removed from team!");
            setTimeout(() => setToastMessage(''), 3000);
        } catch (error) {
            console.error("Remove Team Error:", error);
            alert("Failed to remove member.");
        }
    };

    const handleApproval = async (id, status) => {
        try {
            const { error } = await supabase
                .from('timesheets')
                .update({ status })
                .eq('id', id);

            if (error) throw error;

            const item = pendingTimesheets.find(t => t.id === id);
            if (item) {
                setPendingTimesheets(prev => prev.filter(t => t.id !== id));
                setHistoryTimesheets(prev => [{ ...item, status }, ...prev]);
            }
            setToastMessage(`Timesheet ${status === 'approved' ? 'Approved' : 'Rejected'}!`);
            setTimeout(() => setToastMessage(''), 3000);
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
            setToastMessage("Idea status updated!");
            setTimeout(() => setToastMessage(''), 3000);
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

            const item = historyTimesheets.find(t => t.id === id);
            if (item) {
                setHistoryTimesheets(prev => prev.filter(t => t.id !== id));
                setPendingTimesheets(prev => [{ ...item, status: 'pending' }, ...prev]);
            }
            setToastMessage("Timesheet reverted to Pending.");
            setTimeout(() => setToastMessage(''), 3000);
        } catch (error) {
            console.error("Revert Error:", error);
            alert("Action failed.");
        }
    };

    const handleCreateTask = async (e) => {
        e.preventDefault();
        if (creatingTask) return;
        setCreatingTask(true);

        try {
            const project = projects.find(p => p.id === taskForm.projectId);

            if (assignmentType === 'general') {
                const { error } = await supabase.from('announcements').insert({
                    title: taskForm.title,
                    message: taskForm.description,
                    project_id: taskForm.projectId,
                    created_by: user.id,
                    type: 'task_opportunity',
                    deadline: taskForm.deadline || null
                });

                if (error) throw error;
                setToastMessage("Opportunity posted successfully!");
                setTimeout(() => setToastMessage(''), 3000);
                fetchProjectData(selectedProjectId);

            } else if (assignmentType === 'team') {
                if (teamMembers.length === 0) {
                    alert("No team members found in this project to assign tasks to.");
                    setCreatingTask(false);
                    return;
                }

                const tasksToInsert = teamMembers.map(m => ({
                    title: taskForm.title,
                    description: taskForm.description,
                    project_id: taskForm.projectId,
                    assignee_id: m.id,
                    deadline: taskForm.deadline || null,
                    status: 'pending'
                }));

                const { error: insertError } = await supabase.from('tasks').insert(tasksToInsert);
                if (insertError) throw insertError;

                // Send Emails in background
                teamMembers.forEach(async (m) => {
                    if (m.email) {
                        try {
                            await supabase.functions.invoke('send-task-email', {
                                body: {
                                    to: m.email,
                                    assignee_name: `${m.first_name} ${m.last_name}`,
                                    manager_name: `${user.first_name} ${user.last_name}`,
                                    project_title: project?.title || 'Unknown Project',
                                    task_title: taskForm.title,
                                    task_description: taskForm.description,
                                    deadline: taskForm.deadline
                                }
                            });
                        } catch (invokeError) {
                            console.error("Email notification failed for " + m.email, invokeError);
                        }
                    }
                });

                // Notifications
                const notificationsToInsert = teamMembers.map(m => ({
                    user_id: m.id,
                    message: `New Task Assigned: ${taskForm.title} in project ${project?.title || 'Unknown'}`,
                    is_read: false
                }));
                await supabase.from('notifications').insert(notificationsToInsert);

                setToastMessage(`Task assigned to ${tasksToInsert.length} team members!`);
                setTimeout(() => setToastMessage(''), 3000);

            } else {
                if (!taskForm.assigneeId) {
                    alert("Please select a volunteer assignee.");
                    setCreatingTask(false);
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

                const assignee = allVolunteers.find(v => v.id === taskForm.assigneeId);
                if (assignee?.email) {
                    try {
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
                        });
                    } catch (emailErr) {
                        console.error("Task assignment email failed:", emailErr);
                    }
                }

                await supabase.from('notifications').insert({
                    user_id: taskForm.assigneeId,
                    message: `New Task Assigned: ${taskForm.title} in project ${project?.title || 'Unknown'}`,
                    is_read: false
                });

                setToastMessage("Task successfully assigned!");
                setTimeout(() => setToastMessage(''), 3000);
            }

            setTaskForm({ ...taskForm, title: "", description: "", assigneeId: "" });
            setVolunteerSearch("");
            fetchProjectData(selectedProjectId);

        } catch (error) {
            console.error("Task Creation Error:", error);
            alert("Failed to assign task: " + error.message);
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

            setToastMessage("Project details updated!");
            setTimeout(() => setToastMessage(''), 3000);
            setProjects(prev => prev.map(p => p.id === editingProject.id ? editingProject : p));
            setEditingProject(null);
        } catch (error) {
            console.error("Project Update Error:", error);
            alert("Failed to update project.");
        }
    };

    const handleDeleteOpportunity = async (id) => {
        if (!window.confirm("Are you sure you want to delete this opportunity?")) return;
        try {
            const { error } = await supabase.from('announcements').delete().eq('id', id);
            if (error) throw error;
            setPostedOpportunities(prev => prev.filter(o => o.id !== id));
            setToastMessage("Opportunity deleted!");
            setTimeout(() => setToastMessage(''), 3000);
        } catch (error) {
            console.error("Delete Opportunity Error:", error);
            alert("Failed to delete opportunity.");
        }
    };

    const handlePostOpportunity = async (e) => {
        e.preventDefault();
        if (!oppForm.title.trim() || !oppForm.description.trim()) {
            alert("Please fill in title and description.");
            return;
        }
        setCreatingTask(true);
        try {
            const { error } = await supabase.from('announcements').insert({
                title: oppForm.title.trim(),
                message: oppForm.description.trim(),
                project_id: selectedProjectId,
                created_by: user.id,
                type: 'task_opportunity',
                deadline: oppForm.deadline || null
            });

            if (error) throw error;

            setToastMessage("Opportunity posted successfully!");
            setTimeout(() => setToastMessage(''), 3000);
            setShowCreateOppModal(false);
            setOppForm({ title: "", description: "", deadline: "" });
            fetchProjectData(selectedProjectId);
        } catch (error) {
            console.error("Post Opportunity Error:", error);
            alert("Failed to post opportunity: " + error.message);
        } finally {
            setCreatingTask(false);
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
            setToastMessage("Task rated and feedback saved!");
            setTimeout(() => setToastMessage(''), 3000);
        } catch (err) {
            alert("Error saving feedback: " + err.message);
        }
    };

    const handleUpdateKivaAttendance = async (regId, status, sessionId) => {
        try {
            const updateData = {
                attendance_status: status,
                attended_event_id: status === 'Attended/Visited' ? (sessionId || null) : null
            };
            const { error } = await supabase
                .from('kiva_registrations')
                .update(updateData)
                .eq('id', regId);

            if (error) throw error;

            setKivaRegistrations(prev => prev.map(reg => 
                reg.id === regId ? { ...reg, ...updateData } : reg
            ));
            
            setToastMessage('Attendance updated successfully!');
            setTimeout(() => setToastMessage(''), 3000);
        } catch (error) {
            console.error('Error updating Kiva attendance:', error);
            alert(`Failed to update attendance: ${error.message}`);
        }
    };

    const handleDeleteRevaRegistration = async (registrationId) => {
        if (!window.confirm("Are you sure you want to delete this registration? This cannot be undone.")) return;

        try {
            const reg = eventRegistrations.find(r => r.id === registrationId);
            if (reg) {
                const filesToRemove = [];
                const extractPath = (url) => {
                    if (!url) return null;
                    try {
                        const parts = url.split('/project-gallery/');
                        if (parts.length > 1) {
                            return parts[1].split('?')[0];
                        }
                    } catch (e) {
                        console.error("Error extracting path from URL:", url, e);
                    }
                    return null;
                };

                const paymentPath = extractPath(reg.payment_screenshot_url);
                if (paymentPath) filesToRemove.push(paymentPath);

                const photoPath = extractPath(reg.photograph_url);
                if (photoPath) filesToRemove.push(photoPath);

                if (filesToRemove.length > 0) {
                    const { error: storageError } = await supabase.storage
                        .from('project-gallery')
                        .remove(filesToRemove);
                    
                    if (storageError) {
                        console.error("Error deleting files from storage:", storageError);
                    }
                }
            }

            const { error } = await supabase
                .from('event_registrations')
                .delete()
                .eq('id', registrationId);

            if (error) throw error;

            setEventRegistrations(prev => prev.filter(r => r.id !== registrationId));
            setToastMessage('Registration deleted successfully!');
            setTimeout(() => setToastMessage(''), 3000);
        } catch (error) {
            console.error('Error deleting registration:', error);
            alert('Failed to delete registration.');
        }
    };

    const handleDeleteKivaRegistration = async (registrationId) => {
        if (!window.confirm("Are you sure you want to delete this registration? This cannot be undone.")) return;

        try {
            const { error } = await supabase
                .from('kiva_registrations')
                .delete()
                .eq('id', registrationId);

            if (error) throw error;

            setKivaRegistrations(prev => prev.filter(r => r.id !== registrationId));
            setToastMessage('Registration deleted successfully!');
            setTimeout(() => setToastMessage(''), 3000);
        } catch (error) {
            console.error('Error deleting Kiva registration:', error);
            alert('Failed to delete registration.');
        }
    };

    // Exports
    const exportToExcel = (data, fileName) => {
        const worksheet = XLSX.utils.json_to_sheet(data);
        const workbook = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(workbook, worksheet, "DataSheet");
        XLSX.writeFile(workbook, `${fileName}.xlsx`);
    };

    const handleExportTimesheets = () => {
        const dataToExport = [...pendingTimesheets, ...historyTimesheets].map(t => ({
            Date_Worked: t.date_worked ? new Date(t.date_worked).toLocaleDateString() : 'N/A',
            ILJ_ID: t.volunteer?.ilj_id || 'N/A',
            Volunteer_Name: `${t.volunteer?.first_name || ''} ${t.volunteer?.last_name || ''}`.trim(),
            Project_Name: t.project?.title || 'Unknown',
            Hours: t.hours,
            Role: t.role,
            Work_Mode: t.work_mode,
            Status: t.status,
            Description: t.description
        }));
        exportToExcel(dataToExport, `Timesheets_Report_${selectedProjectId}_${new Date().toLocaleDateString().replace(/\//g, '-')}`);
    };

    const handleExportTeam = () => {
        const dataToExport = teamMembers.map(m => ({
            ILJ_ID: m.ilj_id,
            First_Name: m.first_name,
            Last_Name: m.last_name,
            Email: m.email,
            Mobile: m.mobile_number,
            City: m.city,
            Activity: m.activity_status,
            Designation: m.designation,
            Secondary_Designation: m.secondary_designation
        }));
        exportToExcel(dataToExport, `Team_List_${selectedProjectId}_${new Date().toLocaleDateString().replace(/\//g, '-')}`);
    };

    const handleExportRevaRegistrations = (filteredRegs) => {
        const dataToExport = filteredRegs.map((r, index) => ({
            "S.No": index + 1,
            "Date": new Date(r.created_at).toLocaleDateString(),
            "Full Name": r.full_name,
            "WhatsApp Number": r.whatsapp_number,
            "Email": r.email || 'N/A',
            "Age": r.age || 'N/A',
            "DOB": r.dob || 'N/A',
            "Sangh Name": r.sangh_name || 'N/A',
            "Address": r.address || 'N/A'
        }));
        exportToExcel(dataToExport, `Reva_Registrations_${new Date().toLocaleDateString().replace(/\//g, '-')}`);
    };

    const handleExportRevaRegistrationsPDF = (filteredRegs) => {
        const doc = new jsPDF();
        doc.setFillColor(174, 43, 43); // #ae2b2b crimson
        doc.rect(0, 0, 210, 25, 'F');
        doc.setTextColor(255, 255, 255);
        doc.setFont('Helvetica', 'bold');
        doc.setFontSize(16);
        doc.text("REVA Sangh Registrations", 15, 17);
        
        doc.setTextColor(30, 30, 30);
        doc.setFontSize(10);
        doc.setFont('Helvetica', 'normal');
        doc.text(`Total Registrations: ${filteredRegs.length} | Exported: ${new Date().toLocaleDateString()}`, 15, 33);
        
        const tableHeaders = [["S.No", "Date", "Name", "WhatsApp", "Age/DOB", "Sangh", "Address"]];
        const tableData = filteredRegs.map((r, i) => [
            String(i + 1),
            new Date(r.created_at).toLocaleDateString('en-GB'),
            r.full_name,
            r.whatsapp_number,
            `${r.age || '-'}${r.dob ? ' (' + r.dob + ')' : ''}`,
            r.sangh_name || '-',
            r.address || '-'
        ]);
        
        autoTable(doc, {
            startY: 38,
            head: tableHeaders,
            body: tableData,
            theme: 'striped',
            headStyles: { fillColor: [174, 43, 43] },
            styles: { fontSize: 8, cellPadding: 2 },
            columnStyles: {
                0: { cellWidth: 10 },
                1: { cellWidth: 20 },
                2: { cellWidth: 35 },
                3: { cellWidth: 25 },
                4: { cellWidth: 20 },
                5: { cellWidth: 35 },
                6: { cellWidth: 'auto' }
            },
            margin: { left: 15, right: 15 }
        });
        
        doc.save(`Reva_Registrations_${new Date().toLocaleDateString().replace(/\//g, '-')}.pdf`);
    };

    const handleExportKivaRegistrations = (regs) => {
        const dataToExport = regs.map((r, index) => {
            const eventSession = r.attended_event_id ? kivaSessions.find(s => s.id === r.attended_event_id) : null;
            const eventStr = eventSession 
                ? `${new Date(eventSession.date).toLocaleDateString()} at ${eventSession.venue}` 
                : 'N/A';
            return {
                "S.No": index + 1,
                "Registration Date": new Date(r.created_at).toLocaleDateString(),
                "Full Name": r.full_name,
                "Mobile Number": r.mobile_number,
                "ILJ Volunteer?": r.is_ilj_volunteer ? 'Yes' : 'No',
                "ILJ ID": r.ilj_id || 'N/A',
                "Preferred Weekend": r.preferred_dates,
                "Attendance Status": r.attendance_status || 'Not Attended',
                "Attended Event": eventStr
            };
        });
        exportToExcel(dataToExport, `Kiva_All_Registrations_${new Date().toLocaleDateString().replace(/\//g, '-')}`);
    };

    const handleExportKivaRegistrationsPDF = (regs) => {
        const doc = new jsPDF();
        doc.setFillColor(174, 43, 43); // #ae2b2b crimson
        doc.rect(0, 0, 210, 25, 'F');
        doc.setTextColor(255, 255, 255);
        doc.setFont('Helvetica', 'bold');
        doc.setFontSize(16);
        doc.text("Kiva All Registrations & Attendance", 15, 17);
        
        doc.setTextColor(30, 30, 30);
        doc.setFontSize(10);
        doc.setFont('Helvetica', 'normal');
        doc.text(`Total Records: ${regs.length} | Exported: ${new Date().toLocaleDateString()}`, 15, 33);
        
        const tableHeaders = [["S.No", "Date", "Name", "Mobile", "ILJ ID", "Preferred Weekend", "Attendance", "Attended Event"]];
        const tableData = regs.map((r, i) => {
            const eventSession = r.attended_event_id ? kivaSessions.find(s => s.id === r.attended_event_id) : null;
            const eventStr = eventSession 
                ? `${new Date(eventSession.date).toLocaleDateString('en-GB', {day:'numeric', month:'short'})} - ${eventSession.venue}` 
                : '-';
            return [
                String(i + 1),
                new Date(r.created_at).toLocaleDateString('en-GB'),
                r.full_name,
                r.mobile_number,
                r.ilj_id || 'Public',
                r.preferred_dates,
                r.attendance_status || 'Not Attended',
                eventStr
            ];
        });
        
        autoTable(doc, {
            startY: 38,
            head: tableHeaders,
            body: tableData,
            theme: 'striped',
            headStyles: { fillColor: [174, 43, 43] },
            styles: { fontSize: 8, cellPadding: 2 },
            columnStyles: {
                0: { cellWidth: 10 },
                1: { cellWidth: 20 },
                2: { cellWidth: 30 },
                3: { cellWidth: 25 },
                4: { cellWidth: 20 },
                5: { cellWidth: 35 },
                6: { cellWidth: 25 },
                7: { cellWidth: 'auto' }
            },
            margin: { left: 15, right: 15 }
        });
        
        doc.save(`Kiva_All_Registrations_${new Date().toLocaleDateString().replace(/\//g, '-')}.pdf`);
    };

    const handleExportKivaMembers = (members) => {
        const dataToExport = members.map((m, index) => {
            const attendedEventsStr = m.attended_events.map(e => 
                `${new Date(e.date).toLocaleDateString()} (${e.venue})`
            ).join('; ');
            return {
                "S.No": index + 1,
                "Full Name": m.full_name,
                "Mobile Number": m.mobile_number,
                "ILJ Volunteer?": m.is_ilj_volunteer ? 'Yes' : 'No',
                "ILJ ID": m.ilj_id || 'N/A',
                "Total Registrations": m.registrations.length,
                "Total Attended": m.attended_events.length,
                "Attended Events": attendedEventsStr || 'None'
            };
        });
        exportToExcel(dataToExport, `Kiva_Member_Attendance_History_${new Date().toLocaleDateString().replace(/\//g, '-')}`);
    };

    const handleExportKivaMembersPDF = (members) => {
        const doc = new jsPDF();
        doc.setFillColor(174, 43, 43); // #ae2b2b crimson
        doc.rect(0, 0, 210, 25, 'F');
        doc.setTextColor(255, 255, 255);
        doc.setFont('Helvetica', 'bold');
        doc.setFontSize(16);
        doc.text("Kiva Member-wise Attendance History", 15, 17);
        
        doc.setTextColor(30, 30, 30);
        doc.setFontSize(10);
        doc.setFont('Helvetica', 'normal');
        doc.text(`Total Members: ${members.length} | Exported: ${new Date().toLocaleDateString()}`, 15, 33);
        
        const tableHeaders = [["S.No", "Name", "Mobile", "ILJ ID", "Registrations", "Attended Count", "Attended Events History"]];
        const tableData = members.map((m, i) => {
            const attendedEventsStr = m.attended_events.map(e => 
                `${new Date(e.date).toLocaleDateString('en-GB', {day:'numeric', month:'short'})} @ ${e.venue}`
            ).join(', ');
            return [
                String(i + 1),
                m.full_name,
                m.mobile_number,
                m.ilj_id || 'Public',
                String(m.registrations.length),
                String(m.attended_events.length),
                attendedEventsStr || 'None'
            ];
        });
        
        autoTable(doc, {
            startY: 38,
            head: tableHeaders,
            body: tableData,
            theme: 'striped',
            headStyles: { fillColor: [174, 43, 43] },
            styles: { fontSize: 8, cellPadding: 2 },
            columnStyles: {
                0: { cellWidth: 10 },
                1: { cellWidth: 35 },
                2: { cellWidth: 25 },
                3: { cellWidth: 20 },
                4: { cellWidth: 22 },
                5: { cellWidth: 22 },
                6: { cellWidth: 'auto' }
            },
            margin: { left: 15, right: 15 }
        });
        
        doc.save(`Kiva_Member_Attendance_History_${new Date().toLocaleDateString().replace(/\//g, '-')}.pdf`);
    };

    const getStatusStyle = (status) => {
        switch(status) {
            case 'introduced': return 'bg-indigo-100 text-indigo-700 border-indigo-200';
            case 'contacted': return 'bg-blue-100 text-blue-700 border-blue-200';
            case 'engaged': return 'bg-green-150 text-green-700 border-green-200';
            case 'inactive': return 'bg-gray-100 text-gray-600 border-gray-200';
            case 'active': return 'bg-amber-100 text-amber-700 border-amber-200';
            default: return 'bg-amber-100 text-amber-700 border-amber-200'; // pending
        }
    };

    const getStatusLabel = (status) => {
        switch(status) {
            case 'pending': return 'Pending Contact';
            case 'contacted': return 'Contacted';
            case 'introduced': return 'Introduced to Pod';
            case 'active': return 'Active (Pending)';
            case 'engaged': return 'Engaged';
            case 'inactive': return 'Inactive';
            default: return status || 'Pending Contact';
        }
    };

    // Sub-renders
    const renderOverviewTab = () => {
        const selectedProject = projects.find(p => p.id === selectedProjectId);
        if (!selectedProject) return null;
        
        return (
            <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 space-y-6">
                <div className="flex justify-between items-start border-b border-gray-100 pb-4">
                    <div>
                        <h2 className="text-xl font-bold text-gray-900 font-serif">{selectedProject.title}</h2>
                        <span className={`inline-block mt-2 px-2.5 py-0.5 rounded-full text-xs font-semibold uppercase tracking-wide border shadow-sm ${selectedProject.status === 'active' ? 'bg-green-50 text-green-700 border-green-200' : 'bg-gray-50 text-gray-600 border-gray-200'}`}>
                            {selectedProject.status}
                        </span>
                    </div>
                    <div className="flex gap-2">
                        {(selectedProject.project_code === 'PRJ-010' || selectedProject.project_code === 'PRJ-009') && (
                            <>
                                <button
                                    onClick={() => setActiveTab('schedule')}
                                    className="text-xs bg-[#ae2b2b] text-white px-4 py-2 rounded-lg hover:bg-[#8b1e1e] transition-colors font-bold shadow-sm"
                                >
                                    Manage Schedule
                                </button>
                                <button
                                    onClick={() => setActiveTab('registrations')}
                                    className="text-xs border border-[#ae2b2b] text-[#ae2b2b] px-4 py-2 rounded-lg hover:bg-red-50 transition-colors font-bold shadow-sm"
                                >
                                    Manage Registrations
                                </button>
                            </>
                        )}
                        {(user?.isITAdmin || selectedProject.manager_id === user?.id || selectedProject.sub_head_ids?.includes(user?.id)) && (
                            <button
                                onClick={() => setEditingProject(selectedProject)}
                                className="text-xs border border-[#ae2b2b] text-[#ae2b2b] px-4 py-2 rounded-lg hover:bg-red-50 transition-colors font-bold"
                            >
                                Edit Details
                            </button>
                        )}
                    </div>
                </div>
                
                <p className="text-gray-700 leading-relaxed text-sm bg-gray-50 p-4 rounded-lg border border-gray-100">{selectedProject.description || 'No description provided.'}</p>
                
                <div className="grid grid-cols-1 md:grid-cols-3 gap-6 pt-4">
                    <div className="p-4 bg-gray-50/50 rounded-xl border border-gray-100">
                        <p className="text-xs text-gray-500 uppercase font-bold tracking-wider mb-1">Created Date</p>
                        <p className="font-mono text-sm font-semibold text-gray-800">{new Date(selectedProject.created_at).toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' })}</p>
                    </div>
                    <div className="p-4 bg-gray-50/50 rounded-xl border border-gray-100">
                        <p className="text-xs text-gray-500 uppercase font-bold tracking-wider mb-1">Pod Code</p>
                        <p className="font-mono text-sm font-semibold text-gray-800">{selectedProject.project_code || 'N/A'}</p>
                    </div>
                    <div className="p-4 bg-gray-50/50 rounded-xl border border-gray-100">
                        <p className="text-xs text-gray-500 uppercase font-bold tracking-wider mb-1">Budget</p>
                        <p className="text-sm font-semibold text-gray-800">{selectedProject.budget ? `₹ ${selectedProject.budget}` : 'N/A'}</p>
                    </div>
                </div>
            </div>
        );
    };

    const renderTeamTab = () => {
        const filteredTeam = teamMembers.filter(m => {
            const searchLower = searchTerm.toLowerCase();
            return searchTerm === '' || 
                (m.first_name || '').toLowerCase().includes(searchLower) ||
                (m.last_name || '').toLowerCase().includes(searchLower) ||
                (m.email || '').toLowerCase().includes(searchLower) ||
                (m.ilj_id || '').toLowerCase().includes(searchLower);
        });

        return (
            <div className="space-y-6">
                <div className="bg-[#ae2b2b]/5 border border-[#ae2b2b]/15 rounded-xl p-5 flex flex-col md:flex-row gap-6 items-start shadow-sm">
                    <div className="bg-white p-3 rounded-lg shadow-sm border border-red-100 shrink-0">
                        <ClipboardList className="h-8 w-8 text-[#ae2b2b]" />
                    </div>
                    <div>
                        <h3 className="text-lg font-bold text-[#ae2b2b] mb-2 font-serif">Pod Leader Engagement Protocol</h3>
                        <p className="text-sm text-gray-705 mb-3 font-medium">Once volunteers are added to your pod, please follow these steps to actively engage them:</p>
                        <ul className="grid grid-cols-1 md:grid-cols-3 gap-3">
                            <li className="bg-white px-4 py-3 rounded-lg border border-gray-200/60 text-xs text-gray-700 font-medium shadow-sm flex items-start gap-2">
                                <span className="bg-red-50 text-[#ae2b2b] w-5 h-5 rounded-full flex items-center justify-center text-xs font-bold shrink-0">1</span>
                                Contact the volunteer via WhatsApp/Phone or Email to welcome them.
                            </li>
                            <li className="bg-white px-4 py-3 rounded-lg border border-gray-200/60 text-xs text-gray-700 font-medium shadow-sm flex items-start gap-2">
                                <span className="bg-red-50 text-[#ae2b2b] w-5 h-5 rounded-full flex items-center justify-center text-xs font-bold shrink-0">2</span>
                                Introduce them to ongoing pod activities, roles, and deadlines.
                            </li>
                            <li className="bg-white px-4 py-3 rounded-lg border border-gray-200/60 text-xs text-gray-700 font-medium shadow-sm flex items-start gap-2">
                                <span className="bg-red-50 text-[#ae2b2b] w-5 h-5 rounded-full flex items-center justify-center text-xs font-bold shrink-0">3</span>
                                Add them to necessary communication channels (e.g. WhatsApp groups).
                            </li>
                        </ul>
                    </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div className="bg-white p-4 rounded-xl border border-gray-200 shadow-sm flex items-end">
                        <div className="relative w-full">
                            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" />
                            <input
                                type="text"
                                placeholder="Find a volunteer in this team..."
                                className="w-full pl-10 pr-4 py-2.5 bg-gray-50 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/30 focus:bg-white transition-all text-sm font-medium"
                                value={searchTerm}
                                onChange={(e) => setSearchTerm(e.target.value)}
                            />
                        </div>
                    </div>

                    <div className="bg-white p-4 rounded-xl border border-gray-200 shadow-sm relative">
                        <label className="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Add New Team Member</label>
                        <div className="relative">
                            <input
                                type="text"
                                className="w-full pl-10 border border-gray-300 rounded-lg shadow-sm focus:ring-2 focus:ring-[#ae2b2b]/30 focus:border-[#ae2b2b] p-2.5 text-sm font-medium outline-none"
                                placeholder="Search all volunteers to add..."
                                value={manageTeamSearch}
                                onChange={(e) => {
                                    setManageTeamSearch(e.target.value);
                                    setShowManageTeamList(true);
                                }}
                                onFocus={() => setShowManageTeamList(true)}
                            />
                            <Search className="absolute left-3 top-3 h-4 w-4 text-gray-400" />

                            {showManageTeamList && manageTeamSearch && (
                                <div className="absolute z-20 w-full mt-1 bg-white border border-gray-200 rounded-lg shadow-xl max-h-60 overflow-y-auto">
                                    {allVolunteers
                                        .filter(v =>
                                            !teamMembers.some(m => m.id === v.id) && 
                                            (`${v.first_name} ${v.last_name} ${v.ilj_id}`.toLowerCase().includes(manageTeamSearch.toLowerCase()))
                                        )
                                        .map(v => (
                                            <div
                                                key={v.id}
                                                className="p-3 hover:bg-gray-50 cursor-pointer border-b border-gray-50 flex justify-between items-center transition-colors"
                                                onClick={() => handleAddToTeam(v.id)}
                                            >
                                                <div>
                                                    <p className="font-semibold text-sm text-gray-900">{v.first_name} {v.last_name}</p>
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
                </div>

                <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                    {filteredTeam.length > 0 ? (
                        <div className="overflow-x-auto">
                            <table className="w-full text-left text-sm whitespace-nowrap">
                                <thead className="bg-gray-50 border-b border-gray-200 text-gray-600 font-bold">
                                    <tr>
                                        <th className="px-6 py-4">Volunteer Details</th>
                                        <th className="px-6 py-4">Contact & Location</th>
                                        <th className="px-6 py-4">Engagement State</th>
                                        <th className="px-6 py-4">Update State</th>
                                        <th className="px-6 py-4">Activity Status</th>
                                        <th className="px-6 py-4 text-right">Actions</th>
                                    </tr>
                                </thead>
                                <tbody className="divide-y divide-gray-100">
                                    {filteredTeam.map(volunteer => (
                                        <tr key={volunteer.id} className="hover:bg-gray-50/40 transition-colors">
                                            <td className="px-6 py-4 cursor-pointer" onClick={() => setSelectedVolunteer(volunteer)}>
                                                <div className="flex items-center gap-3">
                                                    <div className="w-10 h-10 rounded-full bg-[#ae2b2b]/10 border border-[#ae2b2b]/20 text-[#ae2b2b] font-bold flex items-center justify-center shrink-0 text-sm">
                                                        {volunteer.first_name?.[0]}{volunteer.last_name?.[0]}
                                                    </div>
                                                    <div>
                                                        <p className="font-semibold text-gray-900 leading-tight">
                                                            {volunteer.first_name} {volunteer.last_name}
                                                        </p>
                                                        <p className="text-xs font-mono text-gray-500 mt-1">{volunteer.ilj_id || 'No ID'}</p>
                                                    </div>
                                                </div>
                                            </td>

                                            <td className="px-6 py-4 text-xs font-medium">
                                                <div className="flex flex-col gap-1.5 text-gray-600">
                                                    <a href={`mailto:${volunteer.email}`} className="flex items-center gap-2 hover:text-[#ae2b2b] hover:underline">
                                                        <Mail className="h-3.5 w-3.5 text-gray-400" />{volunteer.email || 'N/A'}
                                                    </a>
                                                    <a href={`https://wa.me/${volunteer.mobile_number?.replace(/\D/g, '')}`} target="_blank" rel="noreferrer" className="flex items-center gap-2 hover:text-[#ae2b2b] hover:underline">
                                                        <Phone className="h-3.5 w-3.5 text-gray-400" />{volunteer.mobile_number || 'N/A'}
                                                    </a>
                                                    <span className="flex items-center gap-2">
                                                        <MapPin className="h-3.5 w-3.5 text-gray-400" />{volunteer.city || 'Location N/A'}
                                                    </span>
                                                </div>
                                            </td>

                                            <td className="px-6 py-4">
                                                <span className={`text-[10px] uppercase font-bold px-2.5 py-1 rounded border shadow-sm ${getStatusStyle(volunteer.engagement_status)}`}>
                                                    {getStatusLabel(volunteer.engagement_status)}
                                                </span>
                                            </td>

                                            <td className="px-6 py-4">
                                                <div className="relative">
                                                    <select 
                                                        className="w-full min-w-[150px] px-3 py-1.5 bg-white border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/30 focus:outline-none font-semibold text-xs text-gray-900 shadow-sm appearance-none cursor-pointer disabled:opacity-50"
                                                        value={volunteer.engagement_status}
                                                        onChange={(e) => handleUpdateStatus(volunteer.pv_id, e.target.value)}
                                                        disabled={isUpdating.state && isUpdating.id === volunteer.pv_id}
                                                    >
                                                        <option value="pending">Pending Contact</option>
                                                        <option value="contacted">Contacted</option>
                                                        <option value="introduced">Introduced to Pod</option>
                                                        <option value="active">Active (Pending)</option>
                                                        <option value="engaged">Engaged</option>
                                                        <option value="inactive">Inactive</option>
                                                    </select>
                                                    <div className="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-500">
                                                        {isUpdating.state && isUpdating.id === volunteer.pv_id ? (
                                                            <div className="animate-spin rounded-full h-3.5 w-3.5 border-b-2 border-[#ae2b2b]"></div>
                                                        ) : (
                                                            <svg className="fill-current h-3.5 w-3.5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><path d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"/></svg>
                                                        )}
                                                    </div>
                                                </div>
                                            </td>

                                            <td className="px-6 py-4">
                                                <label className="relative inline-flex items-center cursor-pointer">
                                                    <input 
                                                        type="checkbox" 
                                                        className="sr-only peer"
                                                        checked={volunteer.activity_status === 'Active'}
                                                        onChange={() => handleToggleActivity(volunteer.id, volunteer.activity_status)}
                                                        disabled={isUpdatingActivity.state && isUpdatingActivity.id === volunteer.id}
                                                    />
                                                    <div className={`w-9 h-5 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-green-500`}></div>
                                                    <span className={`ml-2 text-xs font-bold ${volunteer.activity_status === 'Active' ? 'text-green-600' : 'text-gray-400'}`}>
                                                        {isUpdatingActivity.state && isUpdatingActivity.id === volunteer.id ? 'Saving...' : volunteer.activity_status}
                                                    </span>
                                                </label>
                                            </td>

                                            <td className="px-6 py-4 text-right flex items-center justify-end gap-2">
                                                <button 
                                                    onClick={() => setSelectedVolunteer(volunteer)}
                                                    className="px-3 py-1.5 text-xs font-bold text-[#ae2b2b] bg-red-50 hover:bg-[#ae2b2b]/10 rounded-md border border-[#ae2b2b]/20 transition-colors"
                                                >
                                                    View Details
                                                </button>
                                                <button
                                                    onClick={() => handleRemoveFromTeam(volunteer.id)}
                                                    className="p-1.5 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                                                    title="Remove from team"
                                                >
                                                    <X className="h-4 w-4" />
                                                </button>
                                            </td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    ) : (
                        <div className="text-center py-16">
                            <UserCheck className="h-12 w-12 text-gray-300 mx-auto mb-3" />
                            <h3 className="text-sm font-medium text-gray-900 mb-1">No pod volunteers found</h3>
                            <p className="text-gray-500 text-xs">There are no volunteers in this pod yet, or they don't match your search filter.</p>
                        </div>
                    )}
                </div>

                {/* Team Tasks Section */}
                <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
                    <div className="flex flex-col sm:flex-row sm:items-center justify-between mb-6 gap-4">
                        <h3 className="font-bold text-gray-900 border-l-4 border-[#ae2b2b] pl-3">Team Task Status</h3>
                        <div className="flex flex-wrap items-center gap-4">
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
                        <div className="text-center py-8 text-gray-400 border border-dashed rounded-lg text-xs font-semibold">
                            {showArchivedTasks ? 'No archived tasks found.' : 'No tasks found for this pod.'}
                        </div>
                    ) : (
                        <div className="overflow-x-auto">
                            <table className="w-full text-xs text-left">
                                <thead>
                                    <tr className="text-gray-500 border-b pb-3 font-bold">
                                        <th className="pb-3">Volunteer</th>
                                        <th className="pb-3">Task Title</th>
                                        <th className="pb-3">Status</th>
                                        <th className="pb-3">Deadline</th>
                                        <th className="pb-3 text-right">Actions</th>
                                    </tr>
                                </thead>
                                <tbody className="divide-y divide-gray-50 text-gray-700">
                                    {teamTasks
                                        .filter(t => showArchivedTasks ? t.status === 'archived' : t.status !== 'archived')
                                        .map(task => (
                                            <tr key={task.id} className="hover:bg-gray-50 transition-colors">
                                                <td className="py-3">
                                                    <div className="flex flex-col">
                                                        <p className="font-semibold text-gray-905">{task.assignee?.first_name} {task.assignee?.last_name}</p>
                                                        <p className="text-[10px] text-gray-400 font-mono mt-0.5">{task.assignee?.ilj_id}</p>
                                                    </div>
                                                </td>
                                                <td className="py-3 font-semibold text-gray-750">{task.title}</td>
                                                <td className="py-3">
                                                    <span className={`px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-wider
                                                        ${task.status === 'completed' ? 'bg-green-100 text-green-700' :
                                                          task.status === 'in_progress' ? 'bg-blue-100 text-blue-700' :
                                                          'bg-red-50 text-red-600'}
                                                    `}>
                                                        {task.status.replace('_', ' ')}
                                                    </span>
                                                </td>
                                                <td className="py-3 text-gray-500 font-mono">
                                                    {task.deadline ? new Date(task.deadline).toLocaleDateString() : '-'}
                                                </td>
                                                <td className="py-3 text-right">
                                                    <div className="flex items-center justify-end gap-1.5">
                                                        <button
                                                            onClick={async () => {
                                                                const newStatus = task.status === 'archived' ? 'pending' : 'archived';
                                                                const { error } = await supabase.from('tasks').update({ status: newStatus }).eq('id', task.id);
                                                                if (error) {
                                                                    console.error(error);
                                                                    alert("Failed to update status");
                                                                }
                                                                else fetchProjectData(selectedProjectId);
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
                                                                    fetchProjectData(selectedProjectId);
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
                                                                className={`flex items-center gap-1.5 px-2.5 py-1 rounded text-[10px] font-bold transition-all shadow-sm
                                                                    ${task.rating
                                                                        ? 'bg-amber-50 text-amber-700 border border-amber-200 hover:bg-amber-100'
                                                                        : 'bg-[#ae2b2b] text-white hover:bg-[#8b1e1e]'
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

                <div className="flex justify-end mt-4">
                    <button
                        onClick={handleExportTeam}
                        className="flex items-center gap-2 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors font-bold text-xs shadow-sm"
                    >
                        <FileSpreadsheet className="h-4 w-4" /> Export Team List
                    </button>
                </div>
            </div>
        );
    };

    const renderApprovalsTab = () => {
        return (
            <div className="space-y-8 animate-in fade-in duration-300">
                <div>
                    <h3 className="text-sm font-bold text-gray-500 uppercase tracking-wider mb-4">Pending Timesheets</h3>
                    {pendingTimesheets.length === 0 ? (
                        <div className="bg-white p-8 rounded-xl text-center border border-gray-200 border-dashed shadow-sm">
                            <CheckSquare className="h-8 w-8 text-green-500 mx-auto mb-2 opacity-50" />
                            <p className="text-gray-500 text-sm">No pending timesheets for this pod.</p>
                        </div>
                    ) : (
                        <div className="grid grid-cols-1 gap-4">
                            {pendingTimesheets.map((ts) => (
                                <div key={ts.id} className="bg-white p-4 rounded-xl shadow-sm border border-gray-200 flex flex-col md:flex-row justify-between gap-4 md:items-center">
                                    <div className="flex items-start gap-4">
                                        <div className="w-10 h-10 rounded-full bg-gray-150 flex items-center justify-center text-[#ae2b2b] font-bold text-sm shrink-0">
                                            {ts.volunteer?.first_name?.[0]}{ts.volunteer?.last_name?.[0]}
                                        </div>
                                        <div>
                                            <h4 className="font-bold text-gray-900 text-sm">{ts.volunteer?.first_name} {ts.volunteer?.last_name}</h4>
                                            <p className="text-xs text-gray-500 mt-1">{new Date(ts.date_worked).toLocaleDateString()} • Role: {ts.role || 'Volunteer'}</p>
                                            <p className="text-sm mt-2 text-gray-700 bg-gray-50 p-2.5 rounded border border-gray-100 italic">"{ts.description}"</p>
                                        </div>
                                    </div>
                                    <div className="flex items-center gap-4 justify-between md:justify-end w-full md:w-auto border-t md:border-t-0 pt-3 md:pt-0">
                                        <div className="text-right mr-4">
                                            <span className="block text-2xl font-bold text-gray-900">{ts.hours}h</span>
                                            <span className="text-[10px] text-gray-500 uppercase font-bold">Logged</span>
                                        </div>
                                        <div className="flex gap-2">
                                            <button
                                                onClick={() => handleApproval(ts.id, 'rejected')}
                                                className="p-2 hover:bg-red-50 text-red-655 rounded-lg border border-transparent hover:border-red-100 transition-all"
                                                title="Reject"
                                            >
                                                <X className="h-5 w-5" />
                                            </button>
                                            <button
                                                onClick={() => handleApproval(ts.id, 'approved')}
                                                className="px-4 py-2 bg-green-600 hover:bg-green-700 text-white rounded-lg font-bold shadow-sm transition-all flex items-center gap-1.5 text-xs"
                                            >
                                                <Check className="h-4 w-4" /> Approve
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            ))}
                        </div>
                    )}
                </div>

                <div>
                    <h3 className="text-sm font-bold text-gray-500 uppercase tracking-wider mb-4">Pending Ideas</h3>
                    {pendingIdeas.length === 0 ? (
                        <div className="bg-white p-8 rounded-xl text-center border border-gray-200 border-dashed shadow-sm">
                            <Lightbulb className="h-8 w-8 text-amber-500 mx-auto mb-2 opacity-50" />
                            <p className="text-gray-500 text-sm">No pending ideas for this pod.</p>
                        </div>
                    ) : (
                        <div className="grid grid-cols-1 gap-4">
                            {pendingIdeas.map((idea) => (
                                <div key={idea.id} className="bg-white p-4 rounded-xl shadow-sm border border-amber-100 flex flex-col md:flex-row justify-between gap-4 md:items-center">
                                    <div className="flex items-start gap-4">
                                        <div className="w-10 h-10 rounded-full bg-amber-50 flex items-center justify-center text-amber-600 font-bold shrink-0">
                                            <Lightbulb className="h-5 w-5" />
                                        </div>
                                        <div>
                                            <h4 className="font-bold text-gray-900 text-sm">{idea.title}</h4>
                                            <p className="text-xs text-gray-550 mt-1">By {idea.volunteer?.first_name} {idea.volunteer?.last_name} • {new Date(idea.created_at).toLocaleDateString()}</p>
                                            <p className="text-sm mt-2 text-gray-700 bg-gray-50 p-2.5 rounded border border-gray-100">{idea.description}</p>
                                        </div>
                                    </div>
                                    <div className="flex gap-2 justify-end w-full md:w-auto border-t md:border-t-0 pt-3 md:pt-0">
                                        <button
                                            onClick={() => handleIdeaApproval(idea.id, 'rejected')}
                                            className="p-2 hover:bg-red-50 text-red-600 rounded-lg border border-transparent hover:border-red-100 transition-all"
                                            title="Reject"
                                        >
                                            <X className="h-5 w-5" />
                                        </button>
                                        <button
                                            onClick={() => handleIdeaApproval(idea.id, 'reviewed')}
                                            className="px-3.5 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg font-bold shadow-sm transition-all text-xs"
                                        >
                                            Review
                                        </button>
                                        <button
                                            onClick={() => handleIdeaApproval(idea.id, 'approved')}
                                            className="px-3.5 py-2 bg-green-600 hover:bg-green-700 text-white rounded-lg font-bold shadow-sm transition-all text-xs flex items-center gap-1"
                                        >
                                            <Check className="h-3 w-3" /> Approve
                                        </button>
                                    </div>
                                </div>
                            ))}
                        </div>
                    )}
                </div>
            </div>
        );
    };

    const renderHistoryTab = () => {
        return (
            <div className="space-y-8 animate-in fade-in duration-300">
                <div className="flex justify-between items-center">
                    <h3 className="font-bold text-gray-800 text-sm">Processed Timesheets</h3>
                    <button
                        onClick={handleExportTimesheets}
                        className="flex items-center gap-2 px-3 py-1.5 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 text-xs font-bold shadow-sm"
                    >
                        <FileSpreadsheet className="h-3.5 w-3.5" /> Export All
                    </button>
                </div>

                {historyTimesheets.length === 0 ? (
                    <div className="bg-white p-12 rounded-xl text-center border border-gray-200 border-dashed shadow-sm">
                        <History className="h-12 w-12 text-gray-300 mx-auto mb-4 opacity-50" />
                        <h3 className="text-sm font-medium text-gray-900">No History Yet</h3>
                        <p className="text-gray-500 text-xs mt-1">Processed timesheets for this pod will appear here.</p>
                    </div>
                ) : (
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                        <div className="overflow-x-auto">
                            <table className="w-full text-left text-sm whitespace-nowrap">
                                <thead className="bg-gray-50 text-gray-500 font-bold border-b border-gray-105">
                                    <tr>
                                        <th className="px-6 py-4">Volunteer</th>
                                        <th className="px-6 py-4">Date Worked</th>
                                        <th className="px-6 py-4">Hours</th>
                                        <th className="px-6 py-4">Status</th>
                                        <th className="px-6 py-4 text-right">Action</th>
                                    </tr>
                                </thead>
                                <tbody className="divide-y divide-gray-100 text-gray-700">
                                    {historyTimesheets.map((ts) => (
                                        <tr key={ts.id} className="hover:bg-gray-50/50 transition-colors">
                                            <td className="px-6 py-4">
                                                <div className="font-semibold text-gray-900">{ts.volunteer?.first_name} {ts.volunteer?.last_name}</div>
                                                <div className="text-xs text-gray-400 font-mono mt-0.5">{ts.volunteer?.ilj_id}</div>
                                            </td>
                                            <td className="px-6 py-4 text-gray-600 font-mono">{new Date(ts.date_worked).toLocaleDateString()}</td>
                                            <td className="px-6 py-4 font-bold">{ts.hours}h</td>
                                            <td className="px-6 py-4">
                                                <span className={`px-2.5 py-1 rounded text-[10px] font-bold uppercase tracking-wider ${ts.status === 'approved' ? 'bg-green-100 text-green-700' : 'bg-red-105 text-red-700'}`}>
                                                    {ts.status}
                                                </span>
                                            </td>
                                            <td className="px-6 py-4 text-right">
                                                <button
                                                    onClick={() => handleRevertStatus(ts.id)}
                                                    className="text-gray-400 hover:text-blue-600 p-1.5 rounded hover:bg-blue-50 transition-colors"
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

                <div>
                    <h3 className="font-bold text-gray-805 text-sm mb-4">Processed Ideas</h3>
                    {historyIdeas.length === 0 ? (
                        <div className="bg-white p-12 rounded-xl text-center border border-gray-200 border-dashed shadow-sm">
                            <Lightbulb className="h-12 w-12 text-gray-300 mx-auto mb-4 opacity-50" />
                            <p className="text-gray-500 text-xs font-semibold">Processed ideas for this pod will appear here.</p>
                        </div>
                    ) : (
                        <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                            <div className="overflow-x-auto">
                                <table className="w-full text-left text-sm whitespace-nowrap">
                                    <thead className="bg-gray-50 text-gray-500 font-bold border-b border-gray-100">
                                        <tr>
                                            <th className="px-6 py-4">Idea Title</th>
                                            <th className="px-6 py-4">Submitted By</th>
                                            <th className="px-6 py-4">Date</th>
                                            <th className="px-6 py-4">Status</th>
                                        </tr>
                                    </thead>
                                    <tbody className="divide-y divide-gray-100 text-gray-700">
                                        {historyIdeas.map((idea) => (
                                            <tr key={idea.id} className="hover:bg-gray-50/50 transition-colors">
                                                <td className="px-6 py-4 font-semibold text-gray-900">{idea.title}</td>
                                                <td className="px-6 py-4">
                                                    <div>{idea.volunteer?.first_name} {idea.volunteer?.last_name}</div>
                                                    <div className="text-xs text-gray-400 font-mono">{idea.volunteer?.ilj_id}</div>
                                                </td>
                                                <td className="px-6 py-4 text-gray-600 font-mono">{new Date(idea.created_at).toLocaleDateString()}</td>
                                                <td className="px-6 py-4">
                                                    <span className={`px-2.5 py-1 rounded text-[10px] font-bold uppercase tracking-wider ${
                                                        idea.status === 'approved' ? 'bg-green-105 text-green-700' :
                                                        idea.status === 'reviewed' ? 'bg-blue-105 text-blue-700' : 'bg-red-105 text-red-700'
                                                    }`}>
                                                        {idea.status}
                                                    </span>
                                                </td>
                                            </tr>
                                        ))}
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    )}
                </div>
            </div>
        );
    };

    const renderTasksTab = () => {
        return (
            <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 md:p-8 max-w-2xl mx-auto animate-in fade-in duration-300">
                <h2 className="text-lg font-bold text-gray-900 mb-6 font-serif border-b pb-3">Create New Task / Opportunity</h2>
                
                <form onSubmit={handleCreateTask} className="space-y-5">
                    <div>
                        <label className="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Assignment Type</label>
                        <div className="grid grid-cols-3 gap-2">
                            {[
                                { id: 'volunteer', label: 'Single Member' },
                                { id: 'team', label: 'Entire Team' },
                                { id: 'general', label: 'General Opp.' }
                            ].map(type => (
                                <button
                                    key={type.id}
                                    type="button"
                                    onClick={() => setAssignmentType(type.id)}
                                    className={`py-2 px-3 text-xs font-bold rounded-lg border transition-all text-center
                                        ${assignmentType === type.id
                                            ? 'bg-[#ae2b2b] text-white border-[#ae2b2b] shadow-sm'
                                            : 'bg-white text-gray-655 border-gray-200 hover:bg-gray-50'
                                        }
                                    `}
                                >
                                    {type.label}
                                </button>
                            ))}
                        </div>
                    </div>

                    {assignmentType === 'volunteer' && (
                        <div>
                            <label className="block text-xs font-bold text-gray-700 mb-2 uppercase">Assign To (Volunteer)</label>
                            <div className="relative">
                                <div className="relative">
                                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
                                    <input
                                        type="text"
                                        className="w-full pl-9 border border-gray-300 rounded-lg shadow-sm focus:ring-[#ae2b2b] focus:border-[#ae2b2b] p-2.5 text-sm font-semibold"
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
                                        {allVolunteers
                                            .filter(v => {
                                                const fullName = `${v.first_name || ''} ${v.last_name || ''}`.toLowerCase();
                                                const iljId = (v.ilj_id || '').toLowerCase();
                                                const query = volunteerSearch.toLowerCase();
                                                return fullName.includes(query) || iljId.includes(query);
                                            })
                                            .map(v => (
                                                <div
                                                    key={v.id}
                                                    className="p-3 hover:bg-gray-50 cursor-pointer border-b border-gray-50 last:border-0 transition-colors"
                                                    onClick={() => {
                                                        setTaskForm(prev => ({ ...prev, assigneeId: v.id }));
                                                        setVolunteerSearch(`${v.first_name} ${v.last_name} (${v.ilj_id})`);
                                                        setShowVolList(false);
                                                    }}
                                                >
                                                    <p className="text-sm font-semibold text-gray-900">{v.first_name} {v.last_name}</p>
                                                    <p className="text-xs text-gray-500 font-mono">{v.ilj_id}</p>
                                                </div>
                                            ))
                                        }
                                        {allVolunteers.filter(v => `${v.first_name} ${v.last_name}`.toLowerCase().includes(volunteerSearch.toLowerCase())).length === 0 && (
                                            <div className="p-3 text-xs text-gray-500 text-center">No volunteers found</div>
                                        )}
                                    </div>
                                )}
                            </div>
                        </div>
                    )}

                    <div>
                        <label className="block text-xs font-bold text-gray-700 mb-2 uppercase">Task Title</label>
                        <input
                            type="text"
                            className="w-full border border-gray-300 rounded-lg shadow-sm focus:ring-[#ae2b2b] focus:border-[#ae2b2b] p-2.5 text-sm font-medium"
                            placeholder="e.g. Design Event Banner"
                            value={taskForm.title}
                            onChange={e => setTaskForm({ ...taskForm, title: e.target.value })}
                            required
                        />
                    </div>

                    <div>
                        <label className="block text-xs font-bold text-gray-700 mb-2 uppercase">Description</label>
                        <textarea
                            className="w-full border border-gray-300 rounded-lg shadow-sm focus:ring-[#ae2b2b] focus:border-[#ae2b2b] p-2.5 text-sm font-medium"
                            rows="4"
                            placeholder="Details about the task or role opportunity..."
                            value={taskForm.description}
                            onChange={e => setTaskForm({ ...taskForm, description: e.target.value })}
                        />
                    </div>

                    <div>
                        <label className="block text-xs font-bold text-gray-700 mb-2 uppercase">Deadline</label>
                        <input
                            type="date"
                            className="w-full border border-gray-300 rounded-lg shadow-sm focus:ring-[#ae2b2b] focus:border-[#ae2b2b] p-2.5 text-sm font-mono"
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
                            assignmentType === 'general' ? 'Post Opportunity' : 'Assign Task'
                        )}
                    </button>
                </form>
            </div>
        );
    };

    const renderOpportunitiesTab = () => {
        return (
            <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm animate-in fade-in duration-300 space-y-6">
                <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 border-b border-gray-100 pb-4">
                    <div>
                        <h3 className="font-bold text-gray-900 font-serif text-lg">Posted Opportunities</h3>
                        <p className="text-xs text-gray-500 mt-1">These tasks are visible to all volunteers in the Announcements section of their dashboards.</p>
                    </div>
                    <button
                        onClick={() => setShowCreateOppModal(true)}
                        className="flex items-center justify-center gap-2 bg-[#ae2b2b] text-white px-4 py-2.5 rounded-xl hover:bg-[#8b1e1e] transition-all shadow-md font-bold text-xs"
                    >
                        <Plus className="h-4 w-4" /> Post Opportunity
                    </button>
                </div>

                <div className="space-y-4">
                    {postedOpportunities.map(opp => (
                        <div key={opp.id} className="border border-gray-200 rounded-xl p-4 hover:shadow-sm transition-shadow">
                            <div className="flex justify-between items-start mb-2">
                                <div>
                                    <h4 className="font-bold text-sm text-gray-900">{opp.title}</h4>
                                    <p className="text-[10px] text-gray-500 font-mono mt-0.5">Posted: {new Date(opp.created_at).toLocaleDateString()}</p>
                                </div>
                                <div className="flex items-center gap-2">
                                    {opp.deadline && (
                                        <span className="text-[10px] bg-red-50 text-[#ae2b2b] px-2.5 py-0.5 rounded-full font-bold border border-[#ae2b2b]/15 font-mono">
                                            Deadline: {new Date(opp.deadline).toLocaleDateString()}
                                        </span>
                                    )}
                                    <button
                                        onClick={() => handleDeleteOpportunity(opp.id)}
                                        className="text-gray-400 hover:text-[#ae2b2b] p-1 transition-colors"
                                        title="Delete Opportunity"
                                    >
                                        <X className="h-4 w-4" />
                                    </button>
                                </div>
                            </div>
                            <p className="text-gray-700 text-xs mb-4 bg-gray-50 p-3 rounded-lg leading-relaxed border border-gray-100 italic">"{opp.message}"</p>

                            <div className="border-t border-gray-100 pt-3">
                                <h5 className="font-semibold text-xs text-gray-800 mb-3 flex items-center gap-1.5">
                                    <Users className="h-4 w-4 text-[#ae2b2b]" />
                                    Interested Volunteers ({opp.interests?.length || 0})
                                </h5>
                                {(!opp.interests || opp.interests.length === 0) ? (
                                    <p className="text-xs text-gray-400 italic">No volunteers have shown interest yet.</p>
                                ) : (
                                    <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                                        {opp.interests.map(interest => {
                                            if (!interest || !interest.volunteer) return null;
                                            return (
                                                <div key={interest.volunteer.id} className="flex justify-between items-center p-2.5 bg-gray-50 rounded border border-gray-100 text-xs transition-shadow hover:shadow-sm">
                                                    <div className="flex items-center gap-2.5">
                                                        <div className="w-8 h-8 rounded-full bg-[#ae2b2b]/10 text-[#ae2b2b] flex items-center justify-center font-bold text-xs">
                                                            {interest.volunteer.first_name?.[0]}
                                                        </div>
                                                        <div>
                                                            <p className="font-semibold text-gray-900">{interest.volunteer.first_name} {interest.volunteer.last_name}</p>
                                                            <p className="text-[10px] text-gray-500 font-mono mt-0.5">{interest.volunteer.ilj_id}</p>
                                                            {interest.volunteer.mobile_number && <p className="text-[10px] text-gray-400 font-medium mt-0.5">📞 {interest.volunteer.mobile_number}</p>}
                                                        </div>
                                                    </div>
                                                    <div className="flex flex-col items-end gap-1">
                                                        <a href={`mailto:${interest.volunteer.email}`} className="text-[10px] text-blue-600 hover:underline">{interest.volunteer.email}</a>
                                                    </div>
                                                </div>
                                            );
                                        })}
                                    </div>
                                )}
                            </div>
                        </div>
                    ))}
                    {postedOpportunities.length === 0 && (
                        <div className="text-center py-8 text-gray-400 text-xs italic">No opportunities posted yet.</div>
                    )}
                </div>
            </div>
        );
    };

    const renderScheduleTab = () => {
        if (projectCode === 'PRJ-010') {
            return (
                <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 animate-in fade-in duration-300">
                    <AdminRevaSessions />
                </div>
            );
        }
        if (projectCode === 'PRJ-009') {
            return (
                <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 animate-in fade-in duration-300">
                    <AdminKivaSessions />
                </div>
            );
        }
        return null;
    };

    const filteredKivaRegistrations = useMemo(() => {
        return kivaRegistrations.filter(r => {
            if (kivaSearchQuery) {
                const q = kivaSearchQuery.toLowerCase();
                const nameMatch = (r.full_name || '').toLowerCase().includes(q);
                const mobileMatch = (r.mobile_number || '').toLowerCase().includes(q);
                const idMatch = (r.ilj_id || '').toLowerCase().includes(q);
                if (!nameMatch && !mobileMatch && !idMatch) return false;
            }
            if (kivaFilterEvent !== 'all') {
                if (r.attended_event_id !== kivaFilterEvent) return false;
            }
            if (kivaFilterDate !== 'all') {
                if (r.preferred_dates !== kivaFilterDate) return false;
            }
            if (kivaFilterRegStatus !== 'all') {
                if (kivaFilterRegStatus === 'ilj' && !r.is_ilj_volunteer) return false;
                if (kivaFilterRegStatus === 'public' && r.is_ilj_volunteer) return false;
            }
            if (kivaFilterAttStatus !== 'all') {
                const status = r.attendance_status || 'Not Attended';
                if (status !== kivaFilterAttStatus) return false;
            }
            return true;
        });
    }, [kivaRegistrations, kivaSearchQuery, kivaFilterEvent, kivaFilterDate, kivaFilterRegStatus, kivaFilterAttStatus]);

    const kivaMemberHistory = useMemo(() => {
        const membersMap = {};
        kivaRegistrations.forEach(r => {
            const phone = r.mobile_number;
            if (!phone) return;
            if (!membersMap[phone]) {
                membersMap[phone] = {
                    full_name: r.full_name,
                    mobile_number: phone,
                    ilj_id: r.ilj_id,
                    is_ilj_volunteer: r.is_ilj_volunteer,
                    registrations: [],
                    attended_events: []
                };
            }
            if (r.ilj_id && !membersMap[phone].ilj_id) {
                membersMap[phone].ilj_id = r.ilj_id;
                membersMap[phone].is_ilj_volunteer = true;
            }
            membersMap[phone].registrations.push(r);
            if (r.attendance_status === 'Attended/Visited' && r.attended_event_id) {
                const session = kivaSessions.find(s => s.id === r.attended_event_id);
                if (session) {
                    membersMap[phone].attended_events.push({
                        registration_id: r.id,
                        session_id: session.id,
                        date: session.date,
                        time: session.time,
                        venue: session.venue
                    });
                }
            }
        });
        return Object.values(membersMap).map(m => {
            m.attended_events.sort((a, b) => new Date(b.date) - new Date(a.date));
            m.registrations.sort((a, b) => new Date(b.created_at) - new Date(a.created_at));
            return m;
        }).sort((a, b) => a.full_name.localeCompare(b.full_name));
    }, [kivaRegistrations, kivaSessions]);

    const filteredKivaMemberHistory = useMemo(() => {
        return kivaMemberHistory.filter(m => {
            if (kivaSearchQuery) {
                const q = kivaSearchQuery.toLowerCase();
                const nameMatch = (m.full_name || '').toLowerCase().includes(q);
                const mobileMatch = (m.mobile_number || '').toLowerCase().includes(q);
                const idMatch = (m.ilj_id || '').toLowerCase().includes(q);
                if (!nameMatch && !mobileMatch && !idMatch) return false;
            }
            if (kivaFilterRegStatus !== 'all') {
                if (kivaFilterRegStatus === 'ilj' && !m.is_ilj_volunteer) return false;
                if (kivaFilterRegStatus === 'public' && m.is_ilj_volunteer) return false;
            }
            if (kivaFilterAttStatus !== 'all') {
                const hasAttendedAny = m.attended_events.length > 0;
                if (kivaFilterAttStatus === 'Attended/Visited' && !hasAttendedAny) return false;
                if (kivaFilterAttStatus === 'Not Attended' && hasAttendedAny) return false;
            }
            if (kivaFilterEvent !== 'all') {
                const attendedThisEvent = m.attended_events.some(e => e.session_id === kivaFilterEvent);
                if (!attendedThisEvent) return false;
            }
            return true;
        });
    }, [kivaMemberHistory, kivaSearchQuery, kivaFilterRegStatus, kivaFilterAttStatus, kivaFilterEvent]);

    const renderRegistrationsTab = () => {
        if (projectCode === 'PRJ-010') {
            const filteredReva = eventRegistrations.filter(r => {
                if (revaSearchQuery) {
                    const q = revaSearchQuery.toLowerCase();
                    return (r.full_name || '').toLowerCase().includes(q) ||
                           (r.whatsapp_number || '').toLowerCase().includes(q) ||
                           (r.email || '').toLowerCase().includes(q) ||
                           (r.sangh_name || '').toLowerCase().includes(q);
                }
                return true;
            });

            return (
                <div className="space-y-6 animate-in fade-in duration-300">
                    <div className="bg-white p-5 rounded-xl border border-gray-200 shadow-sm flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                        <div>
                            <h3 className="text-lg font-bold text-gray-905 font-serif flex items-center gap-2">
                                <UserCheck className="h-5 w-5 text-[#ae2b2b]" /> Sangh Registrations
                            </h3>
                            <p className="text-xs text-gray-500 mt-1">Review event registrations for Reva.</p>
                        </div>
                        <div className="flex gap-2">
                            <button
                                type="button"
                                onClick={() => handleExportRevaRegistrations(filteredReva)}
                                className="flex items-center gap-2 px-3.5 py-2 bg-green-600 hover:bg-green-700 text-white rounded-lg text-xs font-bold shadow-sm transition-all cursor-pointer"
                            >
                                <FileSpreadsheet className="h-3.5 w-3.5" /> Export Excel
                            </button>
                            <button
                                type="button"
                                onClick={() => handleExportRevaRegistrationsPDF(filteredReva)}
                                className="flex items-center gap-2 px-3.5 py-2 bg-[#ae2b2b] hover:bg-[#8b1e1e] text-white rounded-lg text-xs font-bold shadow-sm transition-all cursor-pointer"
                            >
                                <Download className="h-3.5 w-3.5" /> Export PDF
                            </button>
                        </div>
                    </div>

                    <div className="bg-white p-4 rounded-xl border border-gray-200 shadow-sm">
                        <div className="relative">
                            <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
                            <input
                                type="text"
                                placeholder="Search by name, whatsapp, email or sangh..."
                                className="w-full pl-9 pr-4 py-2.5 bg-gray-50 border border-gray-200 rounded-lg text-xs font-semibold focus:outline-none focus:bg-white focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all"
                                value={revaSearchQuery}
                                onChange={(e) => setRevaSearchQuery(e.target.value)}
                            />
                        </div>
                    </div>

                    <div className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
                        {filteredReva.length === 0 ? (
                            <div className="text-center py-16">
                                <UserCheck className="h-12 w-12 text-gray-300 mx-auto mb-3" />
                                <h4 className="text-sm font-medium text-gray-900 mb-1">No registrations found</h4>
                                <p className="text-gray-500 text-xs">There are no registrations matching your search.</p>
                            </div>
                        ) : (
                            <div className="overflow-x-auto">
                                <table className="w-full text-left text-xs whitespace-nowrap">
                                    <thead className="bg-gray-50 border-b border-gray-200 text-gray-650 font-bold uppercase tracking-wider">
                                        <tr>
                                            <th className="px-6 py-4">Date</th>
                                            <th className="px-6 py-4">Participant Details</th>
                                            <th className="px-6 py-4">Contact</th>
                                            <th className="px-6 py-4">Sangh / Address</th>
                                            <th className="px-6 py-4">Payment Proof</th>
                                            <th className="px-6 py-4 text-right">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody className="divide-y divide-gray-100 text-gray-700">
                                        {filteredReva.map((reg) => (
                                            <tr key={reg.id} className="hover:bg-gray-50/40 transition-colors">
                                                <td className="px-6 py-4 font-mono text-gray-500">
                                                    {new Date(reg.created_at).toLocaleDateString()}
                                                </td>
                                                <td className="px-6 py-4">
                                                    <p className="font-semibold text-gray-900">{reg.full_name}</p>
                                                    {reg.age && <p className="text-gray-500 text-[10px] mt-0.5">Age: {reg.age}</p>}
                                                </td>
                                                <td className="px-6 py-4">
                                                    <p className="font-medium">📞 {reg.whatsapp_number}</p>
                                                    {reg.email && <p className="text-gray-500 mt-0.5">{reg.email}</p>}
                                                </td>
                                                <td className="px-6 py-4 max-w-[200px] truncate" title={`${reg.sangh_name || ''} - ${reg.address || ''}`}>
                                                    <p className="font-bold text-[#ae2b2b]">{reg.sangh_name || '-'}</p>
                                                    <p className="text-[10px] text-gray-500 mt-0.5 truncate">{reg.address}</p>
                                                </td>
                                                <td className="px-6 py-4">
                                                    {reg.payment_screenshot_url ? (
                                                        <a
                                                            href={reg.payment_screenshot_url}
                                                            target="_blank"
                                                            rel="noopener noreferrer"
                                                            className="inline-flex items-center gap-1 px-2.5 py-1.5 bg-green-50 text-green-700 rounded border border-green-200 font-bold text-[10px] hover:bg-green-100 transition-colors"
                                                        >
                                                            View Screenshot
                                                        </a>
                                                    ) : (
                                                        <span className="text-gray-400 italic">No Screenshot</span>
                                                    )}
                                                </td>
                                                <td className="px-6 py-4 text-right space-x-2">
                                                    <button
                                                        type="button"
                                                        onClick={() => setSelectedReg(reg)}
                                                        className="px-3 py-1.5 text-[10px] font-bold text-[#ae2b2b] bg-red-50 hover:bg-[#ae2b2b]/10 rounded border border-[#ae2b2b]/20 transition-all cursor-pointer"
                                                    >
                                                        Details
                                                    </button>
                                                    <button
                                                        type="button"
                                                        onClick={() => handleDeleteRevaRegistration(reg.id)}
                                                        className="p-1.5 text-gray-450 hover:text-red-600 hover:bg-red-50 rounded transition-all inline-block align-middle cursor-pointer"
                                                    >
                                                        <Trash2 className="h-4 w-4" />
                                                    </button>
                                                </td>
                                            </tr>
                                        ))}
                                    </tbody>
                                </table>
                            </div>
                        )}
                    </div>
                </div>
            );
        }

        if (projectCode === 'PRJ-009') {
            const preferredWeekendOptions = Array.from(new Set(kivaRegistrations.map(r => r.preferred_dates).filter(Boolean)));

            return (
                <div className="space-y-6 animate-in fade-in duration-300">
                    <div className="bg-white p-5 rounded-xl border border-gray-200 shadow-sm flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                        <div>
                            <h3 className="text-lg font-bold text-gray-905 font-serif flex items-center gap-2">
                                <UserCheck className="h-5 w-5 text-[#ae2b2b]" /> Kiva Registrations & Attendance
                            </h3>
                            <p className="text-xs text-gray-500 mt-1">Manage attendance, schedule matching, and registrations for Kiva.</p>
                        </div>
                        <div className="flex gap-2">
                            <button
                                type="button"
                                onClick={() => {
                                    if (kivaRegActiveTab === 'list') {
                                        handleExportKivaRegistrations(filteredKivaRegistrations);
                                    } else {
                                        handleExportKivaMembers(kivaMemberHistory);
                                    }
                                }}
                                className="flex items-center gap-2 px-3.5 py-2 bg-green-600 hover:bg-green-700 text-white rounded-lg text-xs font-bold shadow-sm transition-all cursor-pointer"
                            >
                                <FileSpreadsheet className="h-3.5 w-3.5" /> Export Excel
                            </button>
                            <button
                                type="button"
                                onClick={() => {
                                    if (kivaRegActiveTab === 'list') {
                                        handleExportKivaRegistrationsPDF(filteredKivaRegistrations);
                                    } else {
                                        handleExportKivaMembersPDF(kivaMemberHistory);
                                    }
                                }}
                                className="flex items-center gap-2 px-3.5 py-2 bg-[#ae2b2b] hover:bg-[#8b1e1e] text-white rounded-lg text-xs font-bold shadow-sm transition-all cursor-pointer"
                            >
                                <Download className="h-3.5 w-3.5" /> Export PDF
                            </button>
                        </div>
                    </div>

                    <div className="flex border-b border-gray-200 bg-white px-2 pt-2 rounded-xl shadow-sm border">
                        <button
                            type="button"
                            onClick={() => setKivaRegActiveTab('list')}
                            className={`px-5 py-2.5 text-xs font-bold border-b-2 transition-all cursor-pointer ${kivaRegActiveTab === 'list' ? 'border-[#ae2b2b] text-[#ae2b2b]' : 'border-transparent text-gray-500 hover:text-gray-800'}`}
                        >
                            All Registrations ({filteredKivaRegistrations.length})
                        </button>
                        <button
                            type="button"
                            onClick={() => setKivaRegActiveTab('members')}
                            className={`px-5 py-2.5 text-xs font-bold border-b-2 transition-all cursor-pointer ${kivaRegActiveTab === 'members' ? 'border-[#ae2b2b] text-[#ae2b2b]' : 'border-transparent text-gray-500 hover:text-gray-800'}`}
                        >
                            Member-wise Attendance History ({filteredKivaMemberHistory.length})
                        </button>
                    </div>

                    <div className="bg-white p-5 rounded-xl border border-gray-200 shadow-sm grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
                        <div className="lg:col-span-2">
                            <label className="block text-[10px] font-bold text-gray-500 uppercase mb-1.5">Search Member</label>
                            <div className="relative">
                                <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
                                <input
                                    type="text"
                                    placeholder="Search by name, mobile, id..."
                                    className="w-full pl-9 pr-4 py-2.5 bg-gray-50 border border-gray-200 rounded-lg text-xs font-semibold focus:outline-none focus:bg-white focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all"
                                    value={kivaSearchQuery}
                                    onChange={(e) => setKivaSearchQuery(e.target.value)}
                                />
                            </div>
                        </div>

                        {kivaRegActiveTab === 'list' ? (
                            <div>
                                <label className="block text-[10px] font-bold text-gray-500 uppercase mb-1.5">Preferred Weekend</label>
                                <select
                                    className="w-full p-2.5 bg-gray-50 border border-gray-250 rounded-lg text-xs font-bold text-gray-805 focus:outline-none bg-white cursor-pointer"
                                    value={kivaFilterDate}
                                    onChange={(e) => setKivaFilterDate(e.target.value)}
                                >
                                    <option value="all">All Dates</option>
                                    {preferredWeekendOptions.map(opt => (
                                        <option key={opt} value={opt}>{opt}</option>
                                    ))}
                                </select>
                            </div>
                        ) : (
                            <div className="invisible h-0 sm:h-auto sm:visible"></div>
                        )}

                        <div>
                            <label className="block text-[10px] font-bold text-gray-500 uppercase mb-1.5">Volunteer Type</label>
                            <select
                                className="w-full p-2.5 bg-gray-50 border border-gray-250 rounded-lg text-xs font-bold text-gray-805 focus:outline-none bg-white cursor-pointer"
                                value={kivaFilterRegStatus}
                                onChange={(e) => setKivaFilterRegStatus(e.target.value)}
                            >
                                <option value="all">All Participants</option>
                                <option value="ilj">ILJ Volunteers Only</option>
                                <option value="public">General Public Only</option>
                            </select>
                        </div>

                        <div>
                            <label className="block text-[10px] font-bold text-gray-500 uppercase mb-1.5">Attendance Filter</label>
                            <select
                                className="w-full p-2.5 bg-gray-50 border border-gray-250 rounded-lg text-xs font-bold text-gray-805 focus:outline-none bg-white cursor-pointer"
                                value={kivaFilterAttStatus}
                                onChange={(e) => setKivaFilterAttStatus(e.target.value)}
                            >
                                <option value="all">All Statuses</option>
                                <option value="Attended/Visited">Attended/Visited</option>
                                <option value="Not Attended">Not Attended</option>
                            </select>
                        </div>

                        <div>
                            <label className="block text-[10px] font-bold text-gray-500 uppercase mb-1.5">Kiva Event Filter</label>
                            <select
                                className="w-full p-2.5 bg-gray-50 border border-gray-250 rounded-lg text-xs font-bold text-gray-805 focus:outline-none bg-white cursor-pointer"
                                value={kivaFilterEvent}
                                onChange={(e) => setKivaFilterEvent(e.target.value)}
                            >
                                <option value="all">All Scheduled Events</option>
                                {kivaSessions.map(session => (
                                    <option key={session.id} value={session.id}>
                                        {new Date(session.date).toLocaleDateString('en-GB', { day: 'numeric', month: 'short' })} - {session.venue}
                                    </option>
                                ))}
                            </select>
                        </div>
                    </div>

                    {kivaRegActiveTab === 'list' ? (
                        <div className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
                            {filteredKivaRegistrations.length === 0 ? (
                                <div className="text-center py-16">
                                    <UserCheck className="h-12 w-12 text-gray-300 mx-auto mb-3" />
                                    <h4 className="text-sm font-medium text-gray-900 mb-1">No registrations found</h4>
                                    <p className="text-gray-500 text-xs">There are no registrations matching your filters.</p>
                                </div>
                            ) : (
                                <div className="overflow-x-auto">
                                    <table className="w-full text-left text-xs whitespace-nowrap">
                                        <thead className="bg-gray-50 border-b border-gray-200 text-gray-650 font-bold uppercase tracking-wider">
                                            <tr>
                                                <th className="px-6 py-4">Date</th>
                                                <th className="px-6 py-4">Member Name</th>
                                                <th className="px-6 py-4">Mobile & ILJ ID</th>
                                                <th className="px-6 py-4">Preferred Weekend</th>
                                                <th className="px-6 py-4">Attendance Status</th>
                                                <th className="px-6 py-4">Attended Event</th>
                                                <th className="px-6 py-4 text-right">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody className="divide-y divide-gray-100 text-gray-700">
                                            {filteredKivaRegistrations.map((reg) => (
                                                <tr key={reg.id} className="hover:bg-gray-50/40 transition-colors">
                                                    <td className="px-6 py-4 font-mono text-gray-500">
                                                        {new Date(reg.created_at).toLocaleDateString()}
                                                    </td>
                                                    <td className="px-6 py-4 font-semibold text-gray-900">
                                                        {reg.full_name}
                                                    </td>
                                                    <td className="px-6 py-4 font-medium">
                                                        <p>📞 {reg.mobile_number}</p>
                                                        {reg.is_ilj_volunteer && (
                                                            <span className="inline-block mt-0.5 px-2 py-0.5 bg-[#ae2b2b]/10 text-[#ae2b2b] rounded-full text-[9px] font-bold">
                                                                ILJ Code: {reg.ilj_id || 'N/A'}
                                                            </span>
                                                        )}
                                                    </td>
                                                    <td className="px-6 py-4 font-medium text-gray-600">
                                                        {reg.preferred_dates}
                                                    </td>
                                                    <td className="px-6 py-4">
                                                        <select
                                                            value={reg.attendance_status || 'Not Attended'}
                                                            onChange={(e) => {
                                                                const val = e.target.value;
                                                                const eventId = val === 'Attended/Visited' ? (reg.attended_event_id || (kivaSessions[0]?.id || null)) : null;
                                                                handleUpdateKivaAttendance(reg.id, val, eventId);
                                                            }}
                                                            className="px-2.5 py-1.5 border border-gray-300 rounded-lg text-xs font-bold bg-white focus:outline-none focus:ring-1 focus:ring-[#ae2b2b] cursor-pointer"
                                                        >
                                                            <option value="Not Attended">Not Attended</option>
                                                            <option value="Attended/Visited">Attended/Visited</option>
                                                        </select>
                                                    </td>
                                                    <td className="px-6 py-4 max-w-[200px] truncate">
                                                        {reg.attendance_status === 'Attended/Visited' ? (
                                                            <select
                                                                value={reg.attended_event_id || ''}
                                                                onChange={(e) => handleUpdateKivaAttendance(reg.id, 'Attended/Visited', e.target.value || null)}
                                                                className="px-2.5 py-1.5 border border-gray-300 rounded-lg text-xs font-bold bg-white focus:outline-none focus:ring-1 focus:ring-[#ae2b2b] cursor-pointer w-full max-w-[200px]"
                                                            >
                                                                <option value="">-- Select Event --</option>
                                                                {kivaSessions.map(session => (
                                                                    <option key={session.id} value={session.id}>
                                                                        {new Date(session.date).toLocaleDateString('en-GB', { day: 'numeric', month: 'short' })} - {session.venue}
                                                                    </option>
                                                                ))}
                                                            </select>
                                                        ) : (
                                                            <span className="text-gray-400 italic">-</span>
                                                        )}
                                                    </td>
                                                    <td className="px-6 py-4 text-right">
                                                        <button
                                                            type="button"
                                                            onClick={() => setSelectedReg(reg)}
                                                            className="px-2.5 py-1.5 text-[10px] font-bold text-[#ae2b2b] bg-red-50 hover:bg-[#ae2b2b]/10 rounded border border-[#ae2b2b]/20 transition-all mr-2 cursor-pointer inline-block"
                                                        >
                                                            Details
                                                        </button>
                                                        <button
                                                            type="button"
                                                            onClick={() => handleDeleteKivaRegistration(reg.id)}
                                                            className="p-1.5 text-gray-400 hover:text-red-650 hover:bg-red-50 rounded transition-all inline-block align-middle cursor-pointer"
                                                        >
                                                            <Trash2 className="h-4 w-4" />
                                                        </button>
                                                    </td>
                                                </tr>
                                            ))}
                                        </tbody>
                                    </table>
                                </div>
                            )}
                        </div>
                    ) : (
                        <div className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
                            {filteredKivaMemberHistory.length === 0 ? (
                                <div className="text-center py-16">
                                    <Users className="h-12 w-12 text-gray-300 mx-auto mb-3" />
                                    <h4 className="text-sm font-medium text-gray-900 mb-1">No members found</h4>
                                    <p className="text-gray-500 text-xs">There are no member records matching your filters.</p>
                                </div>
                            ) : (
                                <div className="overflow-x-auto">
                                    <table className="w-full text-left text-xs">
                                        <thead className="bg-gray-50 border-b border-gray-200 text-gray-650 font-bold uppercase tracking-wider">
                                            <tr>
                                                <th className="px-6 py-4">Member Name & ID</th>
                                                <th className="px-6 py-4">Contact</th>
                                                <th className="px-6 py-4 text-center">Registrations</th>
                                                <th className="px-6 py-4 text-center">Attended Events</th>
                                                <th className="px-6 py-4">Attended History Timeline</th>
                                            </tr>
                                        </thead>
                                        <tbody className="divide-y divide-gray-100 text-gray-700">
                                            {filteredKivaMemberHistory.map((m) => (
                                                <tr key={m.mobile_number} className="hover:bg-gray-50/40 transition-colors">
                                                    <td className="px-6 py-4">
                                                        <p className="font-bold text-gray-900 text-sm">{m.full_name}</p>
                                                        {m.is_ilj_volunteer ? (
                                                            <span className="inline-block mt-0.5 px-2 py-0.5 bg-[#ae2b2b]/10 text-[#ae2b2b] rounded-full text-[9px] font-bold uppercase tracking-wider font-mono">
                                                                ILJ VOLUNTEER ({m.ilj_id})
                                                            </span>
                                                        ) : (
                                                            <span className="inline-block mt-0.5 px-2 py-0.5 bg-gray-100 text-gray-500 rounded-full text-[9px] font-bold uppercase tracking-wider">
                                                                General Public
                                                            </span>
                                                        )}
                                                    </td>
                                                    <td className="px-6 py-4 font-mono font-bold text-gray-800 text-sm">
                                                        {m.mobile_number}
                                                    </td>
                                                    <td className="px-6 py-4 text-center font-bold text-gray-900 text-sm">
                                                        {m.registrations.length}
                                                    </td>
                                                    <td className="px-6 py-4 text-center font-bold text-green-700 text-sm">
                                                        {m.attended_events.length}
                                                    </td>
                                                    <td className="px-6 py-4">
                                                        {m.attended_events.length === 0 ? (
                                                            <span className="text-gray-400 italic">No events attended yet</span>
                                                        ) : (
                                                            <div className="space-y-1.5 max-w-md">
                                                                {m.attended_events.map((e, idx) => (
                                                                    <div key={idx} className="flex items-start gap-1.5 text-[11px] bg-green-50/50 p-2 rounded border border-green-100 text-green-800">
                                                                        <Check className="h-3 w-3 mt-0.5 text-green-600 shrink-0" />
                                                                        <div>
                                                                            <span className="font-bold">{new Date(e.date).toLocaleDateString('en-IN', { day: 'numeric', month: 'short', year: 'numeric' })}</span>: <span className="font-medium text-gray-700">{e.venue}</span>
                                                                        </div>
                                                                    </div>
                                                                ))}
                                                            </div>
                                                        )}
                                                    </td>
                                                </tr>
                                            ))}
                                        </tbody>
                                    </table>
                                </div>
                            )}
                        </div>
                    )}
                </div>
            );
        }

        return null;
    };

    const dynamicTabs = useMemo(() => {
        const tabs = [...TABS];
        if (projectCode === 'PRJ-010' || projectCode === 'PRJ-009') {
            tabs.push({ id: 'schedule', label: 'Schedule', icon: Calendar });
            tabs.push({ id: 'registrations', label: 'Registrations', icon: UserCheck });
        }
        return tabs;
    }, [projectCode]);

    return (
        <div className="space-y-6 animate-fade-in pb-12">
            <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                <div>
                    <h1 className="text-2xl font-bold text-gray-905 flex items-center gap-2 font-serif text-[#ae2b2b]">
                        <Users className="h-6 w-6 text-[#ae2b2b]" />
                        Pod Management Hub
                    </h1>
                    <p className="text-gray-500 text-sm mt-0.5">Manage project details, team engagement, approvals, and tasks.</p>
                </div>
            </div>

            {loadingProjects ? (
                <div className="flex justify-center py-20 bg-white rounded-xl border border-gray-250 shadow-sm">
                    <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-[#ae2b2b]"></div>
                </div>
            ) : projects.length > 0 ? (
                <>
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-5 flex flex-col xl:flex-row gap-4 justify-between items-center">
                        <div className="w-full xl:w-1/3">
                            <label className="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Selected Pod / Project</label>
                            <div className="relative">
                                <select
                                    className="w-full bg-gray-50 border border-gray-300 rounded-lg px-4 py-2.5 text-gray-900 font-bold focus:ring-2 focus:ring-[#ae2b2b]/30 focus:outline-none transition-colors cursor-pointer text-sm"
                                    value={selectedProjectId}
                                    onChange={(e) => {
                                        setSelectedProjectId(e.target.value);
                                        sessionStorage.setItem('selectedPodProjectId', e.target.value);
                                    }}
                                >
                                    {projects.map(p => (
                                        <option key={p.id} value={p.id}>{p.title} ({p.project_code || 'No Code'})</option>
                                    ))}
                                </select>
                            </div>
                        </div>
                        
                        {/* Tab Switcher */}
                        <div className="flex flex-wrap gap-1.5 justify-start xl:justify-end w-full xl:w-auto mt-2 xl:mt-0">
                            {dynamicTabs.map((tab) => {
                                const Icon = tab.icon;
                                const isActive = activeTab === tab.id;
                                return (
                                    <button
                                        key={tab.id}
                                        onClick={() => setActiveTab(tab.id)}
                                        className={`flex items-center gap-2 px-3.5 py-2.5 rounded-lg text-xs font-bold transition-all border
                                            ${isActive
                                                ? "bg-[#ae2b2b] text-white border-[#ae2b2b] shadow-md scale-[1.02]"
                                                : "bg-white text-gray-600 border-gray-200 hover:bg-gray-50"
                                            }
                                        `}
                                    >
                                        <Icon className="h-4 w-4" />
                                        <span>{tab.label}</span>
                                        {tab.id === 'approvals' && (pendingTimesheets.length + pendingIdeas.length) > 0 && (
                                            <span className={`px-2 py-0.5 rounded-full text-[10px] font-bold ${isActive ? "bg-white text-[#ae2b2b]" : "bg-red-100 text-[#ae2b2b]"}`}>
                                                {pendingTimesheets.length + pendingIdeas.length}
                                            </span>
                                        )}
                                    </button>
                                );
                            })}
                        </div>
                    </div>
                    
                    {/* Tab Contents */}
                    <div className="mt-6">
                        {loadingData ? (
                            <div className="flex justify-center py-20 bg-white rounded-xl border border-gray-200 shadow-sm">
                                <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-[#ae2b2b]"></div>
                            </div>
                        ) : (
                            <>
                                {activeTab === 'overview' && renderOverviewTab()}
                                {activeTab === 'team' && renderTeamTab()}
                                {activeTab === 'approvals' && renderApprovalsTab()}
                                {activeTab === 'history' && renderHistoryTab()}
                                {activeTab === 'tasks' && renderTasksTab()}
                                {activeTab === 'opportunities' && renderOpportunitiesTab()}
                                {activeTab === 'schedule' && renderScheduleTab()}
                                {activeTab === 'registrations' && renderRegistrationsTab()}
                            </>
                        )}
                    </div>
                </>
            ) : (
                <div className="text-center py-16 bg-white border border-gray-200 rounded-xl shadow-sm">
                    <AlertCircle className="h-12 w-12 text-gray-300 mx-auto mb-3" />
                    <h3 className="text-lg font-bold text-gray-900 mb-1 font-serif text-[#ae2b2b]">No Managed Pods Found</h3>
                    <p className="text-gray-500 text-xs max-w-sm mx-auto">You have not been assigned as a manager for any pod yet. Please contact an IT Admin to request access.</p>
                </div>
            )}

            {/* Edit Project Details Modal */}
            {editingProject && (
                <div className="fixed inset-0 bg-black/55 flex items-center justify-center z-50 p-4 backdrop-blur-sm">
                    <div className="bg-white rounded-2xl shadow-xl max-w-lg w-full overflow-hidden animate-in fade-in zoom-in-95 duration-200">
                        <div className="p-5 border-b border-gray-100 flex justify-between items-center bg-gray-50">
                            <h3 className="text-base font-bold font-serif text-[#ae2b2b]">Edit Project Details</h3>
                            <button onClick={() => setEditingProject(null)} className="text-gray-400 hover:text-gray-600 transition-colors">
                                <X size={20} />
                            </button>
                        </div>
                        <form onSubmit={handleUpdateProject} className="p-6 space-y-4">
                            <div>
                                <label className="block text-xs font-bold text-gray-700 mb-1 uppercase">Pod Title</label>
                                <input
                                    type="text"
                                    className="w-full border-gray-300 rounded-lg shadow-sm focus:ring-[#ae2b2b] focus:border-[#ae2b2b] p-2.5 border text-sm font-semibold"
                                    value={editingProject.title}
                                    onChange={e => setEditingProject({ ...editingProject, title: e.target.value })}
                                    required
                                />
                            </div>
                            <div>
                                <label className="block text-xs font-bold text-gray-700 mb-1 uppercase">Description</label>
                                <textarea
                                    className="w-full border-gray-300 rounded-lg shadow-sm focus:ring-[#ae2b2b] focus:border-[#ae2b2b] p-2.5 border text-sm font-medium"
                                    rows="4"
                                    value={editingProject.description || ''}
                                    onChange={e => setEditingProject({ ...editingProject, description: e.target.value })}
                                    required
                                />
                            </div>
                            <div>
                                <label className="block text-xs font-bold text-gray-700 mb-1 uppercase">Status</label>
                                <select
                                    className="w-full border-gray-300 rounded-lg shadow-sm focus:ring-[#ae2b2b] focus:border-[#ae2b2b] p-2.5 border bg-white text-sm font-bold"
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
                                    className="flex-1 py-2.5 bg-gray-100 text-gray-700 rounded-lg font-bold hover:bg-gray-200 transition-colors text-xs"
                                >
                                    Cancel
                                </button>
                                <button
                                    type="submit"
                                    className="flex-1 py-2.5 bg-[#ae2b2b] text-white rounded-lg font-bold hover:bg-[#8b1e1e] transition-colors shadow-md text-xs"
                                >
                                    Save Changes
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}

            {/* Volunteer Details Modal */}
            {selectedVolunteer && (
                <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm" onClick={() => setSelectedVolunteer(null)}>
                    <div className="bg-white w-full max-w-2xl rounded-2xl shadow-2xl animate-in fade-in zoom-in-95 overflow-hidden flex flex-col max-h-[90vh]" onClick={e => e.stopPropagation()}>
                        <div className="bg-gradient-to-r from-red-50 to-amber-50 border-b border-red-100 p-6 flex justify-between items-start">
                            <div className="flex items-center gap-4">
                                <div className="w-14 h-14 rounded-full bg-[#ae2b2b] text-white font-bold text-xl flex items-center justify-center shadow-md">
                                    {selectedVolunteer.first_name?.[0]}{selectedVolunteer.last_name?.[0]}
                                </div>
                                <div>
                                    <h2 className="text-xl font-bold text-gray-905 font-serif">{selectedVolunteer.first_name} {selectedVolunteer.last_name}</h2>
                                    <p className="text-xs font-bold text-[#ae2b2b] font-mono mt-0.5">{selectedVolunteer.ilj_id}</p>
                                </div>
                            </div>
                            <button onClick={() => setSelectedVolunteer(null)} className="text-gray-400 hover:text-gray-600 bg-white hover:bg-gray-100 rounded-full p-2 transition-colors border">
                                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                            </button>
                        </div>
                        
                        <div className="p-6 overflow-y-auto space-y-6">
                            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div className="bg-gray-50 border border-gray-100 rounded-xl p-4">
                                    <h4 className="text-xs font-bold text-gray-500 uppercase tracking-wider mb-3 flex items-center gap-1.5"><MessageSquare className="h-4 w-4 text-[#ae2b2b]" /> Contact Information</h4>
                                    <div className="space-y-3">
                                        <div className="flex items-start gap-3">
                                            <Mail className="h-5 w-5 text-red-400 mt-0.5" />
                                            <div>
                                                <p className="text-[10px] text-gray-500 font-bold uppercase">Email</p>
                                                <a href={`mailto:${selectedVolunteer.email}`} className="text-sm font-semibold text-gray-900 hover:text-[#ae2b2b]">{selectedVolunteer.email}</a>
                                            </div>
                                        </div>
                                        <div className="flex items-start gap-3">
                                            <Phone className="h-5 w-5 text-red-400 mt-0.5" />
                                            <div>
                                                <p className="text-[10px] text-gray-500 font-bold uppercase">Phone</p>
                                                <a href={`https://wa.me/${selectedVolunteer.mobile_number?.replace(/\D/g, '')}`} target="_blank" rel="noreferrer" className="text-sm font-semibold text-gray-900 hover:text-[#ae2b2b]">{selectedVolunteer.mobile_number}</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div className="bg-gray-50 border border-gray-100 rounded-xl p-4">
                                    <h4 className="text-xs font-bold text-gray-500 uppercase tracking-wider mb-3 flex items-center gap-1.5"><MapPin className="h-4 w-4 text-[#ae2b2b]" /> Location Details</h4>
                                    <div className="space-y-3">
                                        <div>
                                            <p className="text-[10px] text-gray-500 font-bold uppercase">City</p>
                                            <p className="text-sm font-semibold text-gray-900">{selectedVolunteer.city || 'Not provided'}</p>
                                        </div>
                                        <div>
                                            <p className="text-[10px] text-gray-500 font-bold uppercase">State</p>
                                            <p className="text-sm font-semibold text-gray-900">{selectedVolunteer.state || 'Not provided'}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div className="bg-white border border-gray-200 shadow-sm rounded-xl overflow-hidden">
                                <div className="border-b border-gray-100 bg-gray-50/50 px-4 py-3">
                                    <h4 className="text-xs font-bold text-gray-800 uppercase tracking-wider">Volunteer Profile & Background</h4>
                                </div>
                                <div className="p-4 grid grid-cols-1 md:grid-cols-2 gap-y-4 gap-x-6">
                                    <div>
                                        <p className="text-[10px] text-gray-500 font-bold uppercase">Qualification</p>
                                        <p className="text-sm font-semibold text-gray-900">{selectedVolunteer.qualification || '-'}</p>
                                    </div>
                                    <div>
                                        <p className="text-[10px] text-gray-500 font-bold uppercase">Occupation</p>
                                        <p className="text-sm font-semibold text-gray-900">{selectedVolunteer.occupation || '-'}</p>
                                    </div>
                                    <div className="md:col-span-2">
                                        <p className="text-[10px] text-gray-500 font-bold uppercase">Skills</p>
                                        <p className="text-sm font-semibold text-gray-900">{selectedVolunteer.skills || '-'}</p>
                                    </div>
                                    <div className="md:col-span-2">
                                        <p className="text-[10px] text-gray-500 font-bold uppercase">Dharmik Studies / Background</p>
                                        <p className="text-sm font-semibold text-gray-900">{selectedVolunteer.dharmik_studies || '-'}</p>
                                    </div>
                                </div>
                            </div>

                            <div className="bg-red-50/30 border border-[#ae2b2b]/10 rounded-xl p-4">
                                <h4 className="text-xs font-bold text-[#ae2b2b] uppercase tracking-wider mb-3 flex items-center gap-1.5 font-serif">Preferences & Availability</h4>
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div>
                                        <p className="text-[10px] text-[#ae2b2b]/60 font-bold uppercase">Top Preference</p>
                                        <p className="text-sm font-bold text-gray-800 mt-1">
                                            {selectedVolunteer.volunteering_preference1 ? (
                                                <span className="bg-white px-2 py-1 rounded shadow-sm border border-red-50">{selectedVolunteer.volunteering_preference1}</span>
                                            ) : '-'}
                                        </p>
                                    </div>
                                    <div>
                                        <p className="text-[10px] text-[#ae2b2b]/60 font-bold uppercase">Availability Days</p>
                                        <p className="text-sm font-bold text-gray-805 mt-1">{selectedVolunteer.availability_days || '-'}</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div className="p-5 border-t border-gray-100 bg-gray-50 flex justify-end">
                            <button 
                                onClick={() => setSelectedVolunteer(null)}
                                className="px-6 py-2 bg-[#ae2b2b] hover:bg-[#8b1e1e] text-white font-bold rounded-lg transition-colors shadow-sm text-xs"
                            >
                                Close
                            </button>
                        </div>
                    </div>
                </div>
            )}

            {/* Feedback & Star Rating Modal */}
            {selectedTaskForFeedback && (
                <div className="fixed inset-0 z-[60] flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-in fade-in duration-200">
                    <div className="bg-white w-full max-w-md rounded-2xl p-6 shadow-2xl border">
                        <div className="flex justify-between items-center mb-6">
                            <div>
                                <h3 className="text-lg font-bold text-gray-900 font-serif">Task Feedback</h3>
                                <p className="text-xs text-gray-500 mt-0.5">{selectedTaskForFeedback.title}</p>
                            </div>
                            <button onClick={() => setSelectedTaskForFeedback(null)} className="p-2 hover:bg-gray-100 rounded-full transition-colors border">
                                <X className="h-5 w-5 text-gray-400" />
                            </button>
                        </div>

                        <div className="space-y-6">
                            <div>
                                <label className="block text-xs font-bold text-gray-700 mb-3 uppercase tracking-wider">Rating</label>
                                <div className="flex gap-2">
                                    {[1, 2, 3, 4, 5].map((star) => (
                                        <button
                                            key={star}
                                            onClick={() => setSelectedTaskForFeedback({ ...selectedTaskForFeedback, rating: star })}
                                            className="p-1 transition-transform active:scale-95"
                                        >
                                            <Star className={`h-8 w-8 transition-colors ${star <= (selectedTaskForFeedback.rating || 5) ? "text-amber-450 fill-amber-400" : "text-gray-200 fill-gray-200"}`} />
                                        </button>
                                    ))}
                                </div>
                            </div>
                            <div>
                                <label className="block text-xs font-bold text-gray-700 mb-2 uppercase tracking-wider">Comments</label>
                                <textarea
                                    className="w-full border border-gray-200 rounded-xl p-3 text-sm focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] outline-none transition-all resize-none min-h-[100px] font-medium"
                                    placeholder="Write your feedback comments here..."
                                    value={selectedTaskForFeedback.feedback_comments || ''}
                                    onChange={(e) => setSelectedTaskForFeedback({ ...selectedTaskForFeedback, feedback_comments: e.target.value })}
                                />
                            </div>
                            <button
                                onClick={() => handleFeedbackSubmit(selectedTaskForFeedback.id, selectedTaskForFeedback.rating || 5, selectedTaskForFeedback.feedback_comments)}
                                className="w-full py-3.5 bg-[#ae2b2b] hover:bg-[#8b1e1e] text-white rounded-xl font-bold shadow-lg flex items-center justify-center gap-2 transition-all text-xs"
                            >
                                <MessageSquare className="h-4 w-4" /> Save Feedback
                            </button>
                        </div>
                    </div>
                </div>
            )}

            {/* Create Opportunity Modal */}
            {showCreateOppModal && (
                <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-in fade-in duration-200">
                    <div className="bg-white w-full max-w-lg rounded-2xl shadow-2xl overflow-hidden">
                        <div className="p-5 border-b border-gray-100 flex justify-between items-center bg-gray-50">
                            <div className="flex items-center gap-2">
                                <Briefcase className="h-5 w-5 text-[#ae2b2b]" />
                                <h3 className="text-base font-bold font-serif text-[#ae2b2b]">Post New Opportunity</h3>
                            </div>
                            <button 
                                onClick={() => {
                                    setShowCreateOppModal(false);
                                    setOppForm({ title: "", description: "", deadline: "" });
                                }} 
                                className="text-gray-400 hover:text-gray-600 transition-colors p-1 border rounded-lg hover:bg-gray-100"
                            >
                                <X size={18} />
                            </button>
                        </div>
                        <form onSubmit={handlePostOpportunity} className="p-6 space-y-4">
                            <div>
                                <label className="block text-xs font-bold text-gray-700 mb-2 uppercase">Opportunity Title</label>
                                <input
                                    type="text"
                                    className="w-full border border-gray-300 rounded-lg shadow-sm focus:ring-[#ae2b2b] focus:border-[#ae2b2b] p-2.5 text-sm font-semibold"
                                    placeholder="e.g. Content Writer for Social Media"
                                    value={oppForm.title}
                                    onChange={e => setOppForm({ ...oppForm, title: e.target.value })}
                                    required
                                />
                            </div>
                            <div>
                                <label className="block text-xs font-bold text-gray-700 mb-2 uppercase">Description</label>
                                <textarea
                                    className="w-full border border-gray-300 rounded-lg shadow-sm focus:ring-[#ae2b2b] focus:border-[#ae2b2b] p-2.5 text-sm font-medium"
                                    rows="4"
                                    placeholder="Provide details about the role, expectations, and any requirements..."
                                    value={oppForm.description}
                                    onChange={e => setOppForm({ ...oppForm, description: e.target.value })}
                                    required
                                />
                            </div>
                            <div>
                                <label className="block text-xs font-bold text-gray-700 mb-2 uppercase">Deadline (Optional)</label>
                                <input
                                    type="date"
                                    className="w-full border border-gray-300 rounded-lg shadow-sm focus:ring-[#ae2b2b] focus:border-[#ae2b2b] p-2.5 text-sm font-mono"
                                    value={oppForm.deadline}
                                    onChange={e => setOppForm({ ...oppForm, deadline: e.target.value })}
                                />
                            </div>
                            
                            <div className="pt-2 flex justify-end gap-3 border-t border-gray-100">
                                <button
                                    type="button"
                                    onClick={() => {
                                        setShowCreateOppModal(false);
                                        setOppForm({ title: "", description: "", deadline: "" });
                                    }}
                                    className="px-5 py-2.5 bg-white border border-gray-200 text-gray-650 hover:bg-gray-50 font-bold rounded-lg transition-colors text-xs"
                                >
                                    Cancel
                                </button>
                                <button
                                    type="submit"
                                    disabled={creatingTask}
                                    className={`px-5 py-2.5 rounded-lg font-bold transition-all shadow-md flex items-center justify-center gap-2 text-xs
                                        ${creatingTask ? 'bg-gray-400 cursor-not-allowed text-gray-100' : 'bg-[#ae2b2b] text-white hover:bg-[#8b1e1e]'}
                                    `}
                                >
                                    {creatingTask ? (
                                        <>
                                            <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div>
                                            Posting...
                                        </>
                                    ) : (
                                        'Post Opportunity'
                                    )}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}

            {/* Toast Notification */}
            {toastMessage && (
                <div className="fixed bottom-4 right-4 bg-gray-900 text-white px-6 py-3 rounded-lg shadow-lg z-50 animate-in slide-in-from-bottom flex items-center gap-2 font-bold text-sm">
                    {toastMessage.includes('Error') ? <span className="text-red-400 rounded-full bg-red-400/10 p-1 flex items-center justify-center">✕</span> : <CheckCircle className="h-5 w-5 text-green-400" />}
                    {toastMessage}
                </div>
            )}
        </div>
    );
};

export default PodManagementHub;
