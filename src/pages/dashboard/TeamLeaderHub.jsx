import { useState, useEffect } from "react";
import { useAuth } from "@/context/AuthContext";
import { supabase } from "@/lib/supabase";
import {
    Users, Search, ChevronRight, X, Mail, Phone, MapPin,
    GraduationCap, Heart, Award, User,
    FileText, Mic, Palette, Camera, Calendar, Megaphone, School, Code, Shield, LayoutGrid, CheckSquare, Loader2,
    FileSpreadsheet
} from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import * as XLSX from 'xlsx';

export default function TeamLeaderHub() {
    const { user } = useAuth();
    const [volunteers, setVolunteers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState("");
    const [selectedVolunteer, setSelectedVolunteer] = useState(null);
    const [teams, setTeams] = useState([]);
    const [activeTeam, setActiveTeam] = useState("All");

    // Task Assignment State
    const [isTaskModalOpen, setIsTaskModalOpen] = useState(false);
    const [activeTab, setActiveTab] = useState("overview");
    const [assignmentType, setAssignmentType] = useState('volunteer'); // 'volunteer' or 'team'
    const [targetTeam, setTargetTeam] = useState("All");
    const [creating, setCreating] = useState(false);

    const [taskForm, setTaskForm] = useState({
        title: "",
        description: "",
        deadline: "",
        assigneeId: "" // Added assigneeId for the separate task assignment section
    });

    // Initialize targetTeam when teams are loaded
    useEffect(() => {
        if (teams.length > 0 && targetTeam === "All") {
            setTargetTeam(teams[0]);
        }
    }, [teams]);

    const handleAssignTask = async (e) => {
        e.preventDefault();
        if (creating) return;
        setCreating(true);

        // 1. Assignment from Modal (selectedVolunteer is already set)
        if (selectedVolunteer) {
            try {
                await createTaskForVolunteer(selectedVolunteer, taskForm);
                alert("Task assigned successfully!");
                setIsTaskModalOpen(false);
                setTaskForm(prev => ({ ...prev, title: "", description: "", deadline: "" }));
            } catch (error) {
                console.error("Task Error:", error);
                alert("Failed to assign task.");
            } finally {
                setCreating(false);
            }
            return;
        }


        // 2. Assignment from Main Tab (Bulk or Selected Dropdown)
        try {
            if (assignmentType === 'volunteer') {
                if (!taskForm.assigneeId) {
                    alert("Please select a volunteer.");
                    return;
                }
                const assignee = volunteers.find(v => v.id === taskForm.assigneeId);
                await createTaskForVolunteer(assignee, taskForm);
                alert("Task assigned successfully!");

            } else if (assignmentType === 'team') {
                // Assign to ALL filtered volunteers in the selected Team
                const teamVolunteers = volunteers.filter(v =>
                    [v.volunteering_preference1, v.volunteering_preference2, v.volunteering_preference3].includes(targetTeam)
                );

                if (teamVolunteers.length === 0) {
                    alert(`No volunteers found in ${targetTeam}.`);
                    return;
                }

                if (!confirm(`Assign this task to all ${teamVolunteers.length} volunteers in ${targetTeam}?`)) return;

                // Create Tasks in Parallel (for simplicity in frontend)
                // In production, better to use a backend function for batch insert + notifications
                const tasksPromise = teamVolunteers.map(vol => createTaskForVolunteer(vol, taskForm));
                await Promise.all(tasksPromise);

                alert(`Task assigned to ${teamVolunteers.length} members!`);
            }

            // Reset Form but keep assignment type
            setTaskForm(prev => ({ ...prev, title: "", description: "", deadline: "", assigneeId: "" }));

        } catch (error) {
            console.error("Bulk Assignment Error:", error);
            alert("Failed to assign tasks.");
        } finally {
            setCreating(false);
        }
    };

    // Helper to create task & send notifications
    const createTaskForVolunteer = async (volunteer, formData) => {
        // Create Task
        const { error } = await supabase.from('tasks').insert({
            title: formData.title,
            description: formData.description,
            assignee_id: volunteer.id,
            deadline: formData.deadline ? new Date(formData.deadline) : null,
            status: 'pending',
        });
        if (error) throw error;

        // System Notification
        await supabase.from('notifications').insert({
            user_id: volunteer.id,
            message: `New Task: ${formData.title}`,
            is_read: false
        });

        // Email Notification
        if (volunteer.email) {
            try {
                // Determine project title context
                const teamContext = user.team_leader_for.split('|').find(t =>
                    [volunteer.volunteering_preference1, volunteer.volunteering_preference2].includes(t.trim())
                ) || activeTeam;

                await fetch(`${import.meta.env.VITE_SUPABASE_URL}/functions/v1/send-task-email`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${import.meta.env.VITE_SUPABASE_ANON_KEY}`,
                    },
                    body: JSON.stringify({
                        to: volunteer.email,
                        assignee_name: `${volunteer.first_name} ${volunteer.last_name}`,
                        manager_name: `${user.first_name} ${user.last_name}`,
                        project_title: teamContext || 'Team Task',
                        task_title: formData.title,
                        task_description: formData.description,
                        deadline: formData.deadline
                    })
                });
            } catch (e) {
                console.error("Email send warning:", e);
            }
        }
    };

    const teamMapping = {
        "Research & Documentation": { icon: FileText, color: "blue" },
        "Content Writing (Articles, Blogs, Scripts)": { icon: FileText, color: "indigo" },
        "Public Speaking, Acting & Stage Activities": { icon: Mic, color: "purple" },
        "Graphic Design & Video Editing": { icon: Palette, color: "pink" },
        "Photography & Videography": { icon: Camera, color: "rose" },
        "Event Planning & Management": { icon: Calendar, color: "red" },
        "Marketing & Outreach": { icon: Megaphone, color: "amber" },
        "Pathshala & Educational Activities": { icon: School, color: "emerald" },
        "IT & Technical Support": { icon: Code, color: "cyan" }
    };

    useEffect(() => {
        if (user?.team_leader_for) {
            const parsedTeams = user.team_leader_for.split('|').map(t => t.trim());
            setTeams(parsedTeams);
            fetchInterestedVolunteers(parsedTeams);
        }
    }, [user]);

    const fetchInterestedVolunteers = async (teamList) => {
        setLoading(true);
        try {
            // Construct OR conditions for all teams and all preferences
            const orConditions = [];
            teamList.forEach(team => {
                orConditions.push(`volunteering_preference1.eq."${team}"`);
                orConditions.push(`volunteering_preference2.eq."${team}"`);
                orConditions.push(`volunteering_preference3.eq."${team}"`);
            });

            const { data, error } = await supabase
                .from('volunteers')
                .select('*')
                .or(orConditions.join(','))
                .order('created_at', { ascending: false });

            if (error) throw error;
            setVolunteers(data || []);
        } catch (error) {
            console.error("Fetch Team Volunteers Error:", error);
        } finally {
            setLoading(false);
        }
    };

    const getPreferenceLevel = (volunteer, contextTeam) => {
        // If a specific team context is active, return the preference level for THAT team
        if (contextTeam && contextTeam !== "All") {
            if (volunteer.volunteering_preference1 === contextTeam) return 1;
            if (volunteer.volunteering_preference2 === contextTeam) return 2;
            if (volunteer.volunteering_preference3 === contextTeam) return 3;
            return 0;
        }

        // If "All" teams are active, show the highest preference level that matches ANY of the leader's teams
        const leaderTeams = user.team_leader_for.split('|').map(t => t.trim());
        const prefs = [volunteer.volunteering_preference1, volunteer.volunteering_preference2, volunteer.volunteering_preference3];

        for (let i = 0; i < prefs.length; i++) {
            if (leaderTeams.includes(prefs[i])) return i + 1;
        }
        return 0;
    };

    const handleExportVolunteers = () => {
        const dataToExport = filteredVolunteers.map(v => {
            const { id, ...rest } = v;
            const level = getPreferenceLevel(v, activeTeam);
            return {
                ...rest,
                Preference_Ranking: level,
                Context_Team: activeTeam
            };
        });

        const worksheet = XLSX.utils.json_to_sheet(dataToExport);
        const workbook = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(workbook, worksheet, "Team_Volunteers");
        XLSX.writeFile(workbook, `Team_Volunteers_${activeTeam.replace(/ /g, '_')}_${new Date().toLocaleDateString().replace(/\//g, '-')}.xlsx`);
    };

    const filteredVolunteers = volunteers.filter(v => {
        const matchesSearch = `${v.first_name} ${v.last_name} ${v.ilj_id}`.toLowerCase().includes(searchTerm.toLowerCase());
        const matchesTeam = activeTeam === "All" ||
            [v.volunteering_preference1, v.volunteering_preference2, v.volunteering_preference3].includes(activeTeam);
        return matchesSearch && matchesTeam;
    });

    if (!user?.team_leader_for) {
        return (
            <div className="flex flex-col items-center justify-center h-[60vh] text-center px-4">
                <div className="bg-gray-100 p-6 rounded-full mb-4">
                    <Users className="h-12 w-12 text-gray-400" />
                </div>
                <h2 className="text-2xl font-bold text-gray-900">Access Denied</h2>
                <p className="text-gray-500 mt-2 max-w-md">
                    This hub is only accessible to designated Team Leaders. If you believe this is an error, please contact the administrator.
                </p>
            </div>
        );
    }

    return (
        <div className="space-y-8">
            {/* Header */}
            <div className="bg-gradient-to-r from-[#ae2b2b] to-[#5c1212] rounded-3xl p-8 text-white shadow-xl relative overflow-hidden">
                <div className="relative z-10 flex flex-col md:flex-row md:items-center justify-between gap-6">
                    <div>
                        <div className="flex items-center gap-3 mb-2">
                            <span className="bg-white/20 backdrop-blur-md px-3 py-1 rounded-full text-xs font-bold uppercase tracking-wider">Team Leader Hub</span>
                        </div>
                        <h1 className="text-3xl md:text-4xl font-serif font-bold italic">Leadership Hub</h1>
                        <p className="text-white/80 mt-2 max-w-2xl">
                            Manage and connect with volunteers who have expressed interest in your {teams.length > 1 ? 'teams' : 'team'}.
                        </p>
                    </div>
                    <div className="bg-white/10 backdrop-blur-md p-4 rounded-2xl flex items-center gap-4 border border-white/10">
                        <div className="text-right">
                            <p className="text-xs text-white/60 uppercase font-bold tracking-widest">Total Interested</p>
                            <p className="text-3xl font-bold">{volunteers.length}</p>
                        </div>
                        <div className="w-px h-10 bg-white/20"></div>
                        <div className="bg-white/20 p-3 rounded-xl">
                            <Users className="h-6 w-6" />
                        </div>
                    </div>
                </div>

                {/* Decorative Elements */}
                <div className="absolute top-0 right-0 w-64 h-64 bg-white/5 rounded-full -translate-y-1/2 translate-x-1/2 blur-3xl"></div>
                <div className="absolute bottom-0 left-0 w-48 h-48 bg-black/10 rounded-full translate-y-1/2 -translate-x-1/2 blur-2xl"></div>
            </div>

            {/* Tabs Navigation */}
            <div className="flex flex-wrap gap-2 border-b border-gray-200 pb-1">
                <button
                    onClick={() => setActiveTab("overview")}
                    className={`flex items-center gap-2 px-6 py-3 font-bold text-sm transition-all rounded-t-xl border-b-2 
                        ${activeTab === "overview" ? "border-[#ae2b2b] text-[#ae2b2b] bg-red-50" : "border-transparent text-gray-500 hover:text-gray-700 hover:bg-gray-50"}`}
                >
                    <Users className="h-4 w-4" /> Overview & Volunteers
                </button>
                <button
                    onClick={() => setActiveTab("tasks")}
                    className={`flex items-center gap-2 px-6 py-3 font-bold text-sm transition-all rounded-t-xl border-b-2 
                        ${activeTab === "tasks" ? "border-[#ae2b2b] text-[#ae2b2b] bg-red-50" : "border-transparent text-gray-500 hover:text-gray-700 hover:bg-gray-50"}`}
                >
                    <CheckSquare className="h-4 w-4" /> Assign Tasks
                </button>
            </div>

            {/* Tab Content: Overview */}
            {activeTab === "overview" && (
                <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="space-y-4">
                    <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                        <div className="flex flex-wrap gap-2">
                            <button
                                onClick={() => setActiveTeam("All")}
                                className={`px-4 py-2 rounded-xl text-xs font-bold transition-all border flex items-center gap-2 ${activeTeam === "All"
                                    ? 'bg-[#ae2b2b] text-white border-[#ae2b2b] shadow-md'
                                    : 'bg-white text-gray-600 border-gray-200 hover:bg-gray-50'
                                    }`}
                            >
                                <LayoutGrid className="h-3.5 w-3.5" /> All Teams
                            </button>
                            {teams.map(team => {
                                const Icon = teamMapping[team]?.icon || Shield;
                                return (
                                    <button
                                        key={team}
                                        onClick={() => setActiveTeam(team)}
                                        className={`px-4 py-2 rounded-xl text-xs font-bold transition-all border flex items-center gap-2 ${activeTeam === team
                                            ? 'bg-[#ae2b2b] text-white border-[#ae2b2b] shadow-md'
                                            : 'bg-white text-gray-600 border-gray-200 hover:bg-gray-50'
                                            }`}
                                    >
                                        <Icon className="h-3.5 w-3.5" /> {team}
                                    </button>
                                );
                            })}
                        </div>
                    </div>
                    <div className="flex gap-2 w-full md:w-auto">
                        <div className="relative flex-1 md:w-64">
                            <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
                            <input
                                type="text"
                                placeholder="Search by name or ID..."
                                className="w-full pl-10 pr-4 py-2 bg-white border border-gray-200 rounded-xl focus:ring-2 focus:ring-[#ae2b2b] focus:border-transparent outline-none shadow-sm transition-all"
                                value={searchTerm}
                                onChange={(e) => setSearchTerm(e.target.value)}
                            />
                        </div>
                        <button
                            onClick={handleExportVolunteers}
                            className="px-4 py-2 bg-green-600 text-white rounded-xl hover:bg-green-700 transition-colors shadow-sm flex items-center justify-center gap-2"
                            title="Export List to Excel"
                        >
                            <FileSpreadsheet className="h-4 w-4" />
                        </button>
                    </div>


                    {loading ? (
                        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                            {[1, 2, 3, 4, 5, 6].map(i => (
                                <div key={i} className="bg-white h-32 rounded-2xl border border-gray-100 animate-pulse"></div>
                            ))}
                        </div>
                    ) : (
                        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                            {filteredVolunteers.map(volunteer => {
                                const level = getPreferenceLevel(volunteer, activeTeam);
                                return (
                                    <motion.div
                                        key={volunteer.id}
                                        layout
                                        initial={{ opacity: 0, scale: 0.95 }}
                                        animate={{ opacity: 1, scale: 1 }}
                                        onClick={() => setSelectedVolunteer(volunteer)}
                                        className="bg-white border border-gray-200 rounded-2xl p-5 hover:border-[#ae2b2b] hover:shadow-lg transition-all cursor-pointer group relative overflow-hidden"
                                    >
                                        <div className="flex items-start gap-4">
                                            <div className="w-12 h-12 rounded-full bg-gray-50 flex items-center justify-center text-[#ae2b2b] font-bold text-lg group-hover:bg-[#ae2b2b]/10 transition-colors">
                                                {volunteer.first_name?.[0]}{volunteer.last_name?.[0]}
                                            </div>
                                            <div className="flex-1 min-w-0">
                                                <h3 className="font-bold text-gray-900 truncate group-hover:text-[#ae2b2b] transition-colors">
                                                    {volunteer.first_name} {volunteer.last_name}
                                                </h3>
                                                <p className="text-xs text-gray-500 font-mono">{volunteer.ilj_id}</p>
                                                <div className="flex flex-wrap gap-2 mt-2">
                                                    <span className={`text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-full shadow-sm
                                                        ${level === 1 ? 'bg-green-100 text-green-700 border border-green-200' :
                                                            level === 2 ? 'bg-amber-100 text-amber-700 border border-amber-200' :
                                                                'bg-gray-100 text-gray-600 border border-gray-200'}
                                                    `}>
                                                        {level === 1 ? '1st' : level === 2 ? '2nd' : '3rd'} Preference
                                                    </span>
                                                </div>
                                            </div>
                                            <ChevronRight className="h-5 w-5 text-gray-300 group-hover:text-[#ae2b2b] transition-all" />
                                        </div>

                                        {/* Preference Dot */}
                                        <div className={`absolute top-0 right-0 w-8 h-8 -mr-4 -mt-4 rotate-45 
                                            ${level === 1 ? 'bg-green-500' : level === 2 ? 'bg-amber-500' : 'bg-gray-300'}
                                         opacity-20`}></div>
                                    </motion.div>
                                );
                            })}

                            {filteredVolunteers.length === 0 && (
                                <div className="col-span-full py-12 text-center bg-gray-50 rounded-3xl border-2 border-dashed border-gray-200">
                                    <Search className="h-10 w-10 text-gray-300 mx-auto mb-3" />
                                    <p className="text-gray-500">No volunteers found matching that search.</p>
                                </div>
                            )}
                        </div>
                    )}
                </motion.div>
            )}


            {
                activeTab === "tasks" && (
                    <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="bg-white rounded-2xl shadow-lg border border-gray-100 p-8">
                        <div className="max-w-2xl mx-auto space-y-8">
                            <div className="text-center">
                                <h2 className="text-2xl font-serif font-bold text-gray-900">Task Assignment Desk</h2>
                                <p className="text-gray-500 mt-2">Delegate responsibilities to your team efficiently.</p>
                            </div>

                            {/* Toggle Switches */}
                            <div className="flex bg-gray-100 p-1 rounded-xl">
                                <button onClick={() => setAssignmentType('volunteer')} className={`flex-1 py-3 rounded-lg text-sm font-bold transition-all flex items-center justify-center gap-2 ${assignmentType === 'volunteer' ? 'bg-white shadow text-[#ae2b2b]' : 'text-gray-500 hover:text-gray-700'}`}>
                                    <User className="h-4 w-4" /> Specific Volunteer
                                </button>
                                <button onClick={() => setAssignmentType('team')} className={`flex-1 py-3 rounded-lg text-sm font-bold transition-all flex items-center justify-center gap-2 ${assignmentType === 'team' ? 'bg-white shadow text-[#ae2b2b]' : 'text-gray-500 hover:text-gray-700'}`}>
                                    <Users className="h-4 w-4" /> Entire Team Group
                                </button>
                            </div>

                            <form onSubmit={handleAssignTask} className="space-y-6">
                                {/* Team Context Selector */}
                                <div className="bg-gray-50 p-6 rounded-2xl border border-gray-200 space-y-4">
                                    <label className="block text-sm font-bold text-gray-700">1. Select Team Context</label>
                                    <div className="grid grid-cols-2 gap-3">
                                        {teams.map(t => (
                                            <button key={t} type="button" onClick={() => setTargetTeam(t)} className={`px-4 py-3 rounded-xl border text-left text-sm font-medium transition-all ${targetTeam === t ? 'border-[#ae2b2b] bg-red-50 text-[#ae2b2b] shadow-sm' : 'border-gray-200 hover:border-gray-300 bg-white'}`}>
                                                {t}
                                            </button>
                                        ))}
                                    </div>
                                </div>

                                {assignmentType === 'volunteer' && (
                                    <div>
                                        <label className="block text-sm font-bold text-gray-700 mb-2">2. Select Volunteer</label>
                                        <div className="relative">
                                            <select
                                                className="w-full p-4 bg-white border border-gray-200 rounded-xl outline-none focus:ring-2 focus:ring-[#ae2b2b] appearance-none"
                                                value={taskForm.assigneeId || ""}
                                                onChange={e => setTaskForm({ ...taskForm, assigneeId: e.target.value })}
                                                required
                                            >
                                                <option value="">-- Choose Volunteer --</option>
                                                {volunteers
                                                    .filter(v => [v.volunteering_preference1, v.volunteering_preference2, v.volunteering_preference3].includes(targetTeam))
                                                    .map(v => (
                                                        <option key={v.id} value={v.id}>{v.first_name} {v.last_name} ({v.ilj_id})</option>
                                                    ))}
                                            </select>
                                            <ChevronRight className="absolute right-4 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400 rotate-90" />
                                        </div>
                                        <p className="text-xs text-gray-500 mt-2 px-1">Only showing volunteers interested in {targetTeam}.</p>
                                    </div>
                                )}

                                <div>
                                    <label className="block text-sm font-bold text-gray-700 mb-2">{assignmentType === 'volunteer' ? '3' : '2'}. Task Details</label>
                                    <div className="space-y-4">
                                        <input type="text" required className="w-full p-4 bg-white border border-gray-200 rounded-xl outline-none focus:ring-2 focus:ring-[#ae2b2b]" placeholder="Task Title (e.g. Prepare Graphics)" value={taskForm.title} onChange={e => setTaskForm({ ...taskForm, title: e.target.value })} />
                                        <textarea required rows="4" className="w-full p-4 bg-white border border-gray-200 rounded-xl outline-none focus:ring-2 focus:ring-[#ae2b2b]" placeholder="Detailed instructions..." value={taskForm.description} onChange={e => setTaskForm({ ...taskForm, description: e.target.value })}></textarea>
                                    </div>
                                </div>

                                <div>
                                    <label className="block text-sm font-bold text-gray-700 mb-2">Deadline</label>
                                    <input type="date" className="w-full p-4 bg-white border border-gray-200 rounded-xl outline-none focus:ring-2 focus:ring-[#ae2b2b]" value={taskForm.deadline} onChange={e => setTaskForm({ ...taskForm, deadline: e.target.value })} />
                                </div>

                                <button
                                    type="submit"
                                    disabled={creating}
                                    className={`w-full py-4 bg-[#ae2b2b] text-white rounded-xl font-bold text-lg shadow-xl shadow-red-900/10 hover:shadow-red-900/20 transition-all hover:-translate-y-1 flex items-center justify-center gap-2 ${creating ? 'opacity-70 cursor-not-allowed hover:translate-y-0' : ''}`}
                                >
                                    {creating ? (
                                        <>
                                            <Loader2 className="h-5 w-5 animate-spin" />
                                            {assignmentType === 'team' ? 'Assigning to Team...' : 'Assigning Task...'}
                                        </>
                                    ) : (
                                        assignmentType === 'team' ? `Assign to All ${targetTeam} Members` : 'Assign Task to Volunteer'
                                    )}
                                </button>
                            </form>
                        </div>
                    </motion.div>
                )
            }

            {/* Details Modal (Fixed UI Placement) */}
            <AnimatePresence>
                {selectedVolunteer && (
                    <div className="fixed inset-0 z-[60] flex items-center justify-center p-4">
                        <motion.div
                            initial={{ opacity: 0 }}
                            animate={{ opacity: 1 }}
                            exit={{ opacity: 0 }}
                            onClick={() => setSelectedVolunteer(null)}
                            className="absolute inset-0 bg-black/60 backdrop-blur-sm"
                        />
                        <motion.div
                            initial={{ scale: 0.9, opacity: 0, y: 20 }}
                            animate={{ scale: 1, opacity: 1, y: 0 }}
                            exit={{ scale: 0.9, opacity: 0, y: 20 }}
                            className="bg-white w-full max-w-4xl max-h-[90vh] overflow-hidden rounded-3xl shadow-2xl relative z-10 flex flex-col"
                        >
                            {/* Modal Header */}
                            <div className="relative h-32 flex-shrink-0 bg-[#ae2b2b]">
                                <div className="absolute inset-0 overflow-hidden">
                                    <div className="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full -translate-y-1/2 translate-x-1/2 blur-2xl"></div>
                                    <div className="absolute bottom-0 left-0 w-48 h-48 bg-black/10 rounded-full translate-y-1/2 -translate-x-1/2 blur-xl"></div>
                                </div>
                                {/* Avatar Container - positioned absolutely overlap */}
                                <div className="absolute -bottom-12 left-8">
                                    <div className="w-24 h-24 rounded-3xl bg-white p-1.5 shadow-xl">
                                        <div className="w-full h-full rounded-2xl bg-gradient-to-br from-[#ae2b2b] to-[#5c1212] flex items-center justify-center text-white text-3xl font-bold border-4 border-white shadow-inner">
                                            {selectedVolunteer.first_name?.[0]}{selectedVolunteer.last_name?.[0]}
                                        </div>
                                    </div>
                                </div>
                                <button
                                    onClick={() => setSelectedVolunteer(null)}
                                    className="absolute top-4 right-4 p-2 bg-white/20 hover:bg-white/40 text-white rounded-full transition-colors backdrop-blur-md"
                                >
                                    <X className="h-6 w-6" />
                                </button>
                            </div>

                            {/* Modal Content - Name moved here for better placement */}
                            <div className="flex-1 overflow-y-auto p-8 pt-16">
                                <div className="mb-8">
                                    <h2 className="text-3xl font-bold text-gray-900 leading-tight">
                                        {selectedVolunteer.first_name} {selectedVolunteer.last_name}
                                    </h2>
                                    <div className="flex flex-wrap items-center gap-3 mt-2">
                                        <span className="text-[#ae2b2b] font-mono font-bold bg-red-50 px-2 py-0.5 rounded text-sm tracking-wider">
                                            {selectedVolunteer.ilj_id}
                                        </span>
                                        <span className="text-gray-300">|</span>
                                        <span className="text-sm text-gray-500 font-medium">
                                            Joined {new Date(selectedVolunteer.created_at).toLocaleDateString()}
                                        </span>
                                    </div>
                                </div>

                                <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                                    <section className="space-y-6">
                                        <div>
                                            <h3 className="flex items-center gap-2 text-sm font-bold text-gray-400 uppercase tracking-widest mb-4">
                                                <User className="h-4 w-4" /> Personal Info
                                            </h3>
                                            <div className="bg-gray-50 rounded-2xl p-4 space-y-4">
                                                <DetailItem label="Full Name" value={`${selectedVolunteer.first_name} ${selectedVolunteer.middle_name || ''} ${selectedVolunteer.last_name}`} />
                                                <div className="grid grid-cols-2 gap-4">
                                                    <DetailItem label="Gender" value={selectedVolunteer.gender} />
                                                    <DetailItem label="Age" value={selectedVolunteer.age} />
                                                </div>
                                                <DetailItem label="District" value={selectedVolunteer.district} />
                                                <DetailItem label="City" value={selectedVolunteer.city} />
                                            </div>
                                        </div>

                                        <div>
                                            <h3 className="flex items-center gap-2 text-sm font-bold text-gray-400 uppercase tracking-widest mb-4">
                                                <Phone className="h-4 w-4" /> Contact Detail
                                            </h3>
                                            <div className="bg-gray-50 rounded-2xl p-4 space-y-4">
                                                <DetailItem icon={Mail} label="Email Address" value={selectedVolunteer.email} />
                                                <DetailItem icon={Phone} label="Mobile Number" value={selectedVolunteer.mobile_number} />
                                            </div>
                                        </div>
                                    </section>

                                    <section className="space-y-6">
                                        <div>
                                            <h3 className="flex items-center gap-2 text-sm font-bold text-gray-400 uppercase tracking-widest mb-4">
                                                <Award className="h-4 w-4" /> Volunteering Profile
                                            </h3>
                                            <div className="bg-[#ae2b2b]/5 border border-[#ae2b2b]/10 rounded-2xl p-4 space-y-4">
                                                <div className="flex items-start gap-4">
                                                    <div className="p-2 bg-[#ae2b2b] text-white rounded-lg">
                                                        <Heart className="h-4 w-4" />
                                                    </div>
                                                    <div>
                                                        <p className="text-xs text-gray-500 font-bold uppercase">Preference for {activeTeam !== "All" ? activeTeam : "Your Teams"}</p>
                                                        <p className="text-lg font-bold text-[#ae2b2b]">
                                                            {getPreferenceLevel(selectedVolunteer, activeTeam) === 1 ? 'Primary (1st)' :
                                                                getPreferenceLevel(selectedVolunteer, activeTeam) === 2 ? 'Secondary (2nd)' : 'Tertiary (3rd)'} Choice
                                                        </p>
                                                    </div>
                                                </div>
                                                <DetailItem label="Availability" value={selectedVolunteer.availability_days} />
                                                <DetailItem label="Time Commitment" value={selectedVolunteer.time_commitment} />
                                                <DetailItem label="Mode" value={selectedVolunteer.participation_mode} />
                                            </div>
                                        </div>

                                        <div>
                                            <h3 className="flex items-center gap-2 text-sm font-bold text-gray-400 uppercase tracking-widest mb-4">
                                                <GraduationCap className="h-4 w-4" /> Background
                                            </h3>
                                            <div className="bg-gray-50 rounded-2xl p-4 space-y-4">
                                                <DetailItem label="Occupation" value={selectedVolunteer.occupation} />
                                                <DetailItem label="Qualification" value={selectedVolunteer.qualification} />
                                                <div>
                                                    <p className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">Skills</p>
                                                    <div className="flex flex-wrap gap-2">
                                                        {selectedVolunteer.skills?.split(',').map((s, i) => (
                                                            <span key={i} className="px-3 py-1 bg-white text-gray-600 text-xs font-medium rounded-full border border-gray-200 shadow-sm">
                                                                {s.trim()}
                                                            </span>
                                                        ))}
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </section>
                                </div>

                                <div className="mt-8 pt-6 border-t border-gray-100 flex justify-end items-center gap-4">
                                    <button
                                        onClick={() => setIsTaskModalOpen(true)}
                                        className="px-6 py-3 bg-white text-[#ae2b2b] border border-[#ae2b2b] rounded-2xl font-bold shadow-sm hover:bg-gray-50 transition-all flex items-center gap-2"
                                    >
                                        <CheckSquare className="h-4 w-4" /> Assign Task
                                    </button>
                                    <button
                                        onClick={() => setSelectedVolunteer(null)}
                                        className="px-8 py-3 bg-[#ae2b2b] text-white rounded-2xl font-bold shadow-lg hover:shadow-red-900/20 transition-all hover:-translate-y-0.5"
                                    >
                                        Close Details
                                    </button>
                                </div>
                            </div>
                        </motion.div>
                    </div>
                )}
            </AnimatePresence>

            {/* Modal for Quick Task (Reused) */}
            {
                isTaskModalOpen && selectedVolunteer && (
                    <div className="fixed inset-0 z-[70] flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm">
                        <motion.div
                            initial={{ scale: 0.9, opacity: 0 }}
                            animate={{ scale: 1, opacity: 1 }}
                            className="bg-white rounded-2xl shadow-xl max-w-lg w-full overflow-hidden"
                        >
                            <div className="p-6 border-b border-gray-100 flex justify-between items-center">
                                <h3 className="text-lg font-bold text-gray-900">Assign Task to {selectedVolunteer.first_name}</h3>
                                <button onClick={() => setIsTaskModalOpen(false)} className="text-gray-400 hover:text-gray-600">
                                    <X size={24} />
                                </button>
                            </div>
                            <form onSubmit={handleAssignTask} className="p-6 space-y-4">
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">Task Title</label>
                                    <input
                                        type="text"
                                        className="w-full border-gray-300 rounded-lg shadow-sm focus:ring-[#ae2b2b] focus:border-[#ae2b2b] p-2.5 border"
                                        value={taskForm.title}
                                        onChange={e => setTaskForm({ ...taskForm, title: e.target.value })}
                                        required
                                        placeholder="e.g. Prepare research report"
                                    />
                                </div>
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">Description</label>
                                    <textarea
                                        className="w-full border-gray-300 rounded-lg shadow-sm focus:ring-[#ae2b2b] focus:border-[#ae2b2b] p-2.5 border"
                                        rows="4"
                                        value={taskForm.description}
                                        onChange={e => setTaskForm({ ...taskForm, description: e.target.value })}
                                        required
                                        placeholder="Detailed instructions..."
                                    />
                                </div>
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">Deadline</label>
                                    <input
                                        type="date"
                                        className="w-full border-gray-300 rounded-lg shadow-sm focus:ring-[#ae2b2b] focus:border-[#ae2b2b] p-2.5 border"
                                        value={taskForm.deadline}
                                        onChange={e => setTaskForm({ ...taskForm, deadline: e.target.value })}
                                    />
                                </div>
                                <div className="pt-4 flex gap-3">
                                    <button
                                        type="button"
                                        onClick={() => setIsTaskModalOpen(false)}
                                        className="flex-1 py-2.5 bg-gray-100 text-gray-700 rounded-lg font-bold hover:bg-gray-200 transition-colors"
                                    >
                                        Cancel
                                    </button>
                                    <button
                                        type="submit"
                                        disabled={creating}
                                        className={`flex-1 py-2.5 bg-[#ae2b2b] text-white rounded-lg font-bold shadow-md hover:bg-[#902424] transition-colors flex items-center justify-center gap-2 ${creating ? 'opacity-70 cursor-not-allowed' : ''}`}
                                    >
                                        {creating ? (
                                            <>
                                                <Loader2 className="h-4 w-4 animate-spin" />
                                                Assigning...
                                            </>
                                        ) : (
                                            'Assign Task'
                                        )}
                                    </button>
                                </div>
                            </form>
                        </motion.div>
                    </div>
                )
            }


        </div>
    );
}

const DetailItem = ({ icon: Icon, label, value }) => {
    if (!value) return null;
    return (
        <div className="flex items-start gap-3">
            {Icon && <Icon className="h-4 w-4 text-gray-400 mt-0.5" />}
            <div>
                <p className="text-[10px] text-gray-400 font-bold uppercase tracking-wider">{label}</p>
                <p className="text-gray-900 font-medium">{value}</p>
            </div>
        </div>
    );
};
