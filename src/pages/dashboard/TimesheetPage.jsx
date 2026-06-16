import { useState, useEffect } from "react";
import { useAuth } from "@/context/AuthContext";
import { supabase } from "@/lib/supabase";
import { Clock, Check, X, FileText } from "lucide-react";

export default function TimesheetPage() {
    const { user } = useAuth();
    const [projects, setProjects] = useState([]);
    const [entries, setEntries] = useState([]);
    const [loading, setLoading] = useState(true);
    const [submitting, setSubmitting] = useState(false);

    // Form State
    const [formData, setFormData] = useState({
        projectId: "",
        event: "",
        role: "",
        hours: "",
        mode: "On-site",
        description: "",
        date: new Date().toISOString().split('T')[0]
    });

    useEffect(() => {
        if (user) {
            fetchData();
            fetchProjects();
        }
    }, [user]);

    const fetchProjects = async () => {
        let projectsQuery = supabase.from('projects').select('id, title, project_code');
        if (!user?.isITAdmin) {
            projectsQuery = projectsQuery.neq('status', 'archived');
        }
        const { data } = await projectsQuery;
        setProjects(data || []);
    };

    const fetchData = async () => {
        setLoading(true);
        const { data } = await supabase
            .from('timesheets')
            .select('*, project:projects(title)')
            .eq('volunteer_id', user.id)
            .order('date_worked', { ascending: false });
        setEntries(data || []);
        setLoading(false);
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setSubmitting(true);

        try {
            const { error } = await supabase.from('timesheets').insert({
                volunteer_id: user.id,
                project_id: formData.projectId || null,
                role: formData.role,
                hours: parseFloat(formData.hours),
                work_mode: formData.mode,
                description: formData.description,
                date_worked: formData.date,
                status: 'pending' // pending approval
            });

            if (error) throw error;

            alert("Timesheet submitted successfully!");
            setFormData({
                projectId: "", event: "", role: "", hours: "",
                mode: "On-site", description: "", date: new Date().toISOString().split('T')[0]
            });
            fetchData(); // refresh list
        } catch (err) {
            console.error("Submit Error:", err);
            alert("Failed to submit timesheet. Please try again.");
        } finally {
            setSubmitting(false);
        }
    };

    const getStatusBadge = (status) => {
        switch (status) {
            case 'approved': return <span className="px-2 py-1 rounded-full bg-green-100 text-green-700 text-xs font-bold uppercase">Approved</span>;
            case 'rejected': return <span className="px-2 py-1 rounded-full bg-red-100 text-red-700 text-xs font-bold uppercase">Rejected</span>;
            default: return <span className="px-2 py-1 rounded-full bg-yellow-100 text-yellow-700 text-xs font-bold uppercase">Pending</span>;
        }
    };

    // Calendar Logic
    const today = new Date();
    const startOfWeek = new Date(today);
    startOfWeek.setDate(today.getDate() - today.getDay()); // Start from Sunday

    const weekDays = Array.from({ length: 7 }, (_, i) => {
        const d = new Date(startOfWeek);
        d.setDate(startOfWeek.getDate() + i);
        return d;
    });

    const getDailyHours = (date) => {
        if (!entries.length) return 0;
        const dateStr = date.toISOString().split('T')[0];
        return entries
            .filter(e => e.date_worked === dateStr)
            .reduce((sum, e) => sum + (Number(e.hours) || 0), 0);
    };

    const totalWeekHours = weekDays.reduce((acc, day) => acc + getDailyHours(day), 0);

    return (
        <div className="space-y-8">
            <div className="flex flex-col md:flex-row md:items-end justify-between gap-4">
                <div>
                    <h2 className="text-2xl font-bold text-gray-900">Volunteer Timesheet</h2>
                    <p className="text-gray-500">Log your contributions and track your hours.</p>
                </div>
                <div className="bg-[#ae2b2b]/5 text-[#ae2b2b] px-4 py-2 rounded-xl border border-[#ae2b2b]/20 font-medium flex items-center gap-2">
                    <Clock className="h-5 w-5" />
                    <span>This Week: <span className="font-bold text-xl">{totalWeekHours}</span> hrs</span>
                </div>
            </div>

            {/* Creative Weekly Calendar */}
            <div className="bg-white rounded-2xl shadow-sm border border-gray-200 p-6">
                <h3 className="font-bold text-gray-800 mb-4 flex items-center gap-2">
                    <Clock className="h-5 w-5 text-[#ae2b2b]" /> Weekly Activity
                </h3>
                <div className="grid grid-cols-7 gap-2 md:gap-4">
                    {weekDays.map((day, i) => {
                        const dateStr = day.toISOString().split('T')[0];
                        const isToday = dateStr === new Date().toISOString().split('T')[0];
                        const isSelected = dateStr === formData.date;
                        const hours = getDailyHours(day);
                        const dateNum = day.getDate();
                        const dayName = day.toLocaleDateString('default', { weekday: 'short' });

                        // Dynamic styling based on hours
                        let [bgColor, textColor, borderColor] = ["bg-gray-50", "text-gray-400", "border-transparent"];
                        if (hours > 0) {
                            if (hours >= 4) [bgColor, textColor, borderColor] = ["bg-green-50", "text-green-700", "border-green-200"];
                            else[bgColor, textColor, borderColor] = ["bg-[#ae2b2b]/5", "text-[#ae2b2b]", "border-[#ae2b2b]/20"];
                        }

                        // Selection and Today highlighting
                        if (isSelected) {
                            borderColor = "border-[#ae2b2b] ring-2 ring-[#ae2b2b] ring-offset-1";
                            // Ensure text is visible if selected
                            if (textColor === "text-gray-400") textColor = "text-gray-800";
                        } else if (isToday) {
                            borderColor = "border-[#ae2b2b] ring-1 ring-[#ae2b2b]";
                        }

                        return (
                            <div
                                key={i}
                                onClick={() => setFormData(prev => ({ ...prev, date: dateStr }))}
                                className={`flex flex-col items-center justify-center p-3 rounded-xl border transition-all cursor-pointer ${bgColor} ${borderColor} ${hours > 0 ? "shadow-sm" : "hover:bg-gray-100"}`}
                            >
                                <span className={`text-xs font-semibold uppercase mb-1 ${isToday ? 'text-[#ae2b2b]' : 'text-gray-400'}`}>{dayName}</span>
                                <span className={`text-lg font-bold mb-1 ${isToday ? 'text-gray-900' : 'text-gray-700'}`}>{dateNum}</span>
                                {hours > 0 ? (
                                    <span className={`text-xs font-bold px-2 py-0.5 rounded-full bg-white/50 ${textColor}`}>
                                        {hours}h
                                    </span>
                                ) : (
                                    <span className="h-5"></span>
                                )}
                            </div>
                        );
                    })}
                </div>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">

                {/* Submission Form */}
                <div className="lg:col-span-1">
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 sticky top-24">
                        <h3 className="font-bold text-lg text-gray-800 mb-4 flex items-center gap-2">
                            <FileText className="h-5 w-5 text-[#ae2b2b]" /> New Entry
                        </h3>
                        <form onSubmit={handleSubmit} className="space-y-4">
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Date</label>
                                <input
                                    type="date"
                                    required
                                    className="w-full p-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-400 focus:outline-none"
                                    value={formData.date}
                                    onChange={(e) => setFormData({ ...formData, date: e.target.value })}
                                />
                            </div>

                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Project</label>
                                <select
                                    className="w-full p-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-400 focus:outline-none"
                                    value={formData.projectId}
                                    onChange={(e) => setFormData({ ...formData, projectId: e.target.value })}
                                >
                                    <option value="">-- Select Project --</option>
                                    {projects.map(p => (
                                        <option key={p.id} value={p.id}>{p.project_code} - {p.title}</option>
                                    ))}
                                    <option value="">Other / General</option>
                                </select>
                            </div>

                            <div className="grid grid-cols-2 gap-4">
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">Hours</label>
                                    <input
                                        type="number" step="0.5" min="0.5" required
                                        className="w-full p-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-400 focus:outline-none"
                                        placeholder="e.g. 2.5"
                                        value={formData.hours}
                                        onChange={(e) => setFormData({ ...formData, hours: e.target.value })}
                                    />
                                </div>
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">Mode</label>
                                    <select
                                        className="w-full p-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-400 focus:outline-none"
                                        value={formData.mode}
                                        onChange={(e) => setFormData({ ...formData, mode: e.target.value })}
                                    >
                                        <option>On-site</option>
                                        <option>Online</option>
                                        <option>Hybrid</option>
                                    </select>
                                </div>
                            </div>

                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Role / Activity</label>
                                <input
                                    type="text" required
                                    className="w-full p-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-400 focus:outline-none"
                                    placeholder="e.g. Teaching, Editing"
                                    value={formData.role}
                                    onChange={(e) => setFormData({ ...formData, role: e.target.value })}
                                />
                            </div>

                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Description</label>
                                <textarea
                                    rows="3" required
                                    className="w-full p-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-400 focus:outline-none resize-none"
                                    placeholder="Briefly describe what you did..."
                                    value={formData.description}
                                    onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                                ></textarea>
                            </div>

                            <button
                                type="submit"
                                disabled={submitting}
                                className="w-full py-2.5 bg-gray-900 text-white font-medium rounded-lg hover:bg-gray-800 transition-colors shadow-lg shadow-gray-200 disabled:opacity-70 flex justify-center"
                            >
                                {submitting ? 'Submitting...' : 'Submit Entry'}
                            </button>
                        </form>
                    </div>
                </div>

                {/* History List */}
                <div className="lg:col-span-2">
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                        <div className="p-4 border-b border-gray-100 bg-gray-50 flex justify-between items-center">
                            <h3 className="font-bold text-gray-800">History & Status</h3>
                            <div className="text-sm text-gray-500">
                                Total Approved: <span className="font-bold text-gray-900">{entries.filter(e => e.status === 'approved').reduce((acc, c) => acc + (c.hours || 0), 0)} hrs</span>
                            </div>
                        </div>

                        {loading ? (
                            <div className="p-12 text-center"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#ae2b2b] mx-auto"></div></div>
                        ) : entries.length === 0 ? (
                            <div className="p-12 text-center text-gray-500">No entries found. Start logging your work!</div>
                        ) : (
                            <div className="divide-y divide-gray-100">
                                {entries.map(entry => (
                                    <div key={entry.id} className="p-5 hover:bg-gray-50 transition-colors">
                                        <div className="flex justify-between items-start mb-2">
                                            <div className="flex items-center gap-2">
                                                <span className="font-bold text-gray-900">{entry.role}</span>
                                                <span className="text-sm text-gray-500">• {new Date(entry.date_worked).toLocaleDateString()}</span>
                                            </div>
                                            {getStatusBadge(entry.status)}
                                        </div>
                                        <p className="text-sm text-gray-600 mb-2">{entry.description}</p>
                                        <div className="flex items-center gap-4 text-xs text-gray-500 font-medium">
                                            <span className="bg-gray-100 px-2 py-1 rounded text-gray-600">
                                                {entry.project?.title || 'General'}
                                            </span>
                                            <span className="flex items-center gap-1">
                                                <Clock className="h-3 w-3" /> {entry.hours} Hours
                                            </span>
                                            <span>{entry.work_mode}</span>
                                        </div>
                                    </div>
                                ))}
                            </div>
                        )}
                    </div>
                </div>

            </div>
        </div>
    );
}
