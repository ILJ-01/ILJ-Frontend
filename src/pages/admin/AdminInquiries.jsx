import { useState, useEffect } from "react";
import { supabase } from "@/lib/supabase";
import {
    LayoutGrid, Search, Loader2, MessageSquare, MapPin,
    Star, Trash2, CheckCircle, X, Download, FileSpreadsheet, 
    HelpCircle, Send, Edit3, ShieldCheck, MessageSquareQuote
} from "lucide-react";
import * as XLSX from 'xlsx';
import { useAuth } from "@/context/AuthContext";
import { Navigate } from "react-router-dom";

export default function AdminInquiries() {
    const { user, loading: authLoading } = useAuth();
    const [activeTab, setActiveTab] = useState("inquiries"); // 'inquiries', 'feedback', or 'reflect_questions'
    const [data, setData] = useState([]);
    const [loading, setLoading] = useState(true);
    const [projects, setProjects] = useState({});
    const [events, setEvents] = useState({});

    // Admin Reply State
    const [replyingId, setReplyingId] = useState(null);
    const [replyText, setReplyText] = useState("");
    const [isSavingReply, setIsSavingReply] = useState(false);

    useEffect(() => {
        fetchProjectsAndEvents();
        fetchData();
    }, [activeTab]);

    const fetchProjectsAndEvents = async () => {
        const { data: pData } = await supabase.from('projects').select('id, title');
        if (pData) {
            const pMap = {};
            pData.forEach(p => pMap[p.id] = p.title);
            setProjects(pMap);
        }
        
        const { data: eData } = await supabase.from('events').select('id, title');
        if (eData) {
            const eMap = {};
            eData.forEach(e => eMap[e.id] = e.title);
            setEvents(eMap);
        }
    };

    const fetchData = async () => {
        setLoading(true);
        try {
            const table = activeTab === 'inquiries' 
                ? 'project_inquiries' 
                : activeTab === 'reflect_questions' 
                    ? 'reflect_questions' 
                    : 'project_feedback';
                    
            const { data: result, error } = await supabase
                .from(table)
                .select('*')
                .order('created_at', { ascending: false });

            if (error) throw error;
            setData(result || []);
        } catch (err) {
            console.error("Error fetching data:", err);
        } finally {
            setLoading(false);
        }
    };

    const handleDelete = async (id) => {
        if (!confirm("Are you sure you want to delete this item?")) return;
        try {
            const table = activeTab === 'inquiries' 
                ? 'project_inquiries' 
                : activeTab === 'reflect_questions' 
                    ? 'reflect_questions' 
                    : 'project_feedback';
                    
            const { error } = await supabase.from(table).delete().eq('id', id);
            if (error) throw error;
            setData(prev => prev.filter(item => item.id !== id));
        } catch (err) {
            console.error("Delete error:", err);
            alert("Failed to delete.");
        }
    };

    const handleSaveReply = async (questionId) => {
        if (!replyText.trim()) {
            alert("Please type a reply before saving.");
            return;
        }

        setIsSavingReply(true);
        const repliedAtIso = new Date().toISOString();

        try {
            const { error } = await supabase
                .from('reflect_questions')
                .update({
                    admin_reply: replyText.trim(),
                    replied_at: repliedAtIso
                })
                .eq('id', questionId);

            if (error) throw error;

            // Update local state
            setData(prev => prev.map(item => item.id === questionId ? {
                ...item,
                admin_reply: replyText.trim(),
                replied_at: repliedAtIso
            } : item));

            setReplyingId(null);
            setReplyText("");
            alert("Reply saved & published successfully!");
        } catch (err) {
            console.error("Error saving reply:", err);
            alert("Failed to save reply.");
        } finally {
            setIsSavingReply(false);
        }
    };

    const handleExport = () => {
        const exportData = data.map(item => {
            if (activeTab === 'inquiries') {
                return {
                    Project: projects[item.project_id] || 'Unknown',
                    Name: item.name,
                    Email: item.email,
                    Mobile: item.mobile,
                    Message: item.message,
                    Created_At: new Date(item.created_at).toLocaleString()
                };
            } else if (activeTab === 'reflect_questions') {
                return {
                    Reference_Code: item.reference_code || 'N/A',
                    Session: item.session || 'General Question',
                    Question: item.question,
                    Admin_Reply: item.admin_reply || 'Pending',
                    Replied_At: item.replied_at ? new Date(item.replied_at).toLocaleString() : 'N/A',
                    Is_Anonymous: item.is_anonymous ? 'Yes' : 'No',
                    Name: item.is_anonymous ? 'Anonymous' : (item.name || 'N/A'),
                    Mobile: item.is_anonymous ? 'N/A' : (item.mobile || 'N/A'),
                    Age: item.is_anonymous ? 'N/A' : (item.age || 'N/A'),
                    Email: item.is_anonymous ? 'N/A' : (item.email || 'N/A'),
                    City: item.is_anonymous ? 'N/A' : (item.city || 'N/A'),
                    Created_At: new Date(item.created_at).toLocaleString()
                };
            } else {
                return {
                    Pod: projects[item.project_id] || 'Unknown',
                    Event: item.event_id ? (events[item.event_id] || 'Unknown') : 'N/A',
                    Rating: item.rating,
                    Comments: item.comments,
                    Is_Anonymous: item.is_anonymous ? 'Yes' : 'No',
                    Created_At: new Date(item.created_at).toLocaleString()
                };
            }
        });

        const ws = XLSX.utils.json_to_sheet(exportData);
        const wb = XLSX.utils.book_new();
        const sheetName = activeTab === 'inquiries' 
            ? "Inquiries" 
            : activeTab === 'reflect_questions' 
                ? "Reflect Questions" 
                : "Feedback";

        XLSX.utils.book_append_sheet(wb, ws, sheetName);
        XLSX.writeFile(wb, `${activeTab}_${new Date().toISOString().split('T')[0]}.xlsx`);
    };

    if (authLoading) return <div className="p-10 text-center">Loading...</div>;

    return (
        <div className="p-6 md:p-8 space-y-6 bg-gray-50 min-h-screen">
            <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                <div>
                    <h1 className="text-2xl font-bold text-gray-900 font-serif">
                        {activeTab === 'inquiries' 
                            ? 'Pod Inquiries' 
                            : activeTab === 'reflect_questions'
                                ? 'Reflect Workshop Questions'
                                : 'Feedback & Reviews'}
                    </h1>
                    <p className="text-gray-500">
                        {activeTab === 'reflect_questions' 
                            ? 'Questions submitted by people regarding Reflect Workshop (Admin Only).'
                            : 'Manage incoming requests and feedback.'}
                    </p>
                </div>
                <div className="flex gap-3">
                    <button
                        onClick={handleExport}
                        disabled={loading || data.length === 0}
                        className="flex items-center gap-2 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition cursor-pointer text-sm font-semibold"
                    >
                        <FileSpreadsheet className="h-4 w-4" /> Export
                    </button>
                </div>
            </div>

            {/* Tabs */}
            <div className="flex flex-wrap bg-white p-1 rounded-xl w-fit border border-gray-200 gap-1">
                <button
                    onClick={() => setActiveTab("inquiries")}
                    className={`px-4 py-2 rounded-lg text-sm font-medium transition-all flex items-center gap-2 cursor-pointer
                        ${activeTab === "inquiries" ? "bg-[#ae2b2b] text-white shadow" : "text-gray-500 hover:text-gray-900"}`}
                >
                    <MapPin className="h-4 w-4" /> Organize Requests
                </button>
                <button
                    onClick={() => setActiveTab("feedback")}
                    className={`px-4 py-2 rounded-lg text-sm font-medium transition-all flex items-center gap-2 cursor-pointer
                        ${activeTab === "feedback" ? "bg-[#ae2b2b] text-white shadow" : "text-gray-500 hover:text-gray-900"}`}
                >
                    <MessageSquare className="h-4 w-4" /> Feedback
                </button>
                <button
                    onClick={() => setActiveTab("reflect_questions")}
                    className={`px-4 py-2 rounded-lg text-sm font-medium transition-all flex items-center gap-2 cursor-pointer
                        ${activeTab === "reflect_questions" ? "bg-[#ae2b2b] text-white shadow" : "text-gray-500 hover:text-gray-900"}`}
                >
                    <HelpCircle className="h-4 w-4" /> Reflect Questions
                </button>
            </div>

            {/* Content Table/List */}
            {loading ? (
                <div className="flex justify-center py-12">
                    <Loader2 className="h-8 w-8 animate-spin text-[#ae2b2b]" />
                </div>
            ) : data.length === 0 ? (
                <div className="text-center py-12 bg-white rounded-xl border border-dashed border-gray-300">
                    <div className="mx-auto h-12 w-12 text-gray-400 mb-3 flex items-center justify-center">
                        {activeTab === 'inquiries' ? <MapPin className="h-8 w-8" /> : activeTab === 'reflect_questions' ? <HelpCircle className="h-8 w-8" /> : <MessageSquare className="h-8 w-8" />}
                    </div>
                    <h3 className="text-lg font-medium text-gray-900">No records found</h3>
                    <p className="text-gray-500">Wait for new submissions.</p>
                </div>
            ) : (
                <div className="grid gap-4">
                    {data.map((item) => (
                        <div key={item.id} className="bg-white p-5 rounded-2xl shadow-sm border border-gray-100 hover:shadow-md transition">
                            <div className="flex flex-col md:flex-row gap-4 justify-between items-start">
                                <div className="space-y-3 flex-1 w-full">
                                    {/* Top Header Tags */}
                                    <div className="flex flex-wrap items-center gap-2">
                                        {activeTab === 'reflect_questions' ? (
                                            <>
                                                {item.reference_code && (
                                                    <span className="text-xs font-mono font-bold uppercase tracking-wide px-2.5 py-1 bg-amber-100 text-amber-900 rounded-md border border-amber-200">
                                                        {item.reference_code}
                                                    </span>
                                                )}
                                                <span className="text-xs font-bold uppercase tracking-wide px-2.5 py-1 bg-gray-100 text-gray-700 rounded-md">
                                                    {item.session || 'General Question'}
                                                </span>
                                                {item.is_anonymous ? (
                                                    <span className="text-xs font-semibold px-2.5 py-1 bg-gray-100 text-gray-600 rounded-md">
                                                        Anonymous
                                                    </span>
                                                ) : (
                                                    <span className="text-xs font-semibold px-2.5 py-1 bg-emerald-50 text-emerald-700 rounded-md border border-emerald-100">
                                                        Named Submitter
                                                    </span>
                                                )}
                                            </>
                                        ) : (
                                            <>
                                                <span className="text-xs font-semibold uppercase tracking-wide px-2 py-0.5 bg-gray-100 text-gray-600 rounded">
                                                    {projects[item.project_id] || 'Unknown Pod'}
                                                </span>
                                                {item.event_id && (
                                                    <span className="text-xs font-semibold uppercase tracking-wide px-2 py-0.5 bg-blue-50 text-blue-600 rounded border border-blue-100">
                                                        Event: {events[item.event_id] || 'Unknown'}
                                                    </span>
                                                )}
                                            </>
                                        )}
                                        <span className="text-xs text-gray-400">• {new Date(item.created_at).toLocaleString()}</span>
                                    </div>

                                    {/* Main Content Area */}
                                    {activeTab === 'inquiries' ? (
                                        <>
                                            <h3 className="font-bold text-gray-900">{item.name} <span className="text-gray-400 font-normal">({item.mobile})</span></h3>
                                            <p className="text-sm text-gray-600 font-medium">{item.email}</p>
                                            <p className="mt-2 text-gray-700 bg-gray-50 p-3 rounded-lg border border-gray-100 text-sm leading-relaxed">
                                                {item.message}
                                            </p>
                                        </>
                                    ) : activeTab === 'reflect_questions' ? (
                                        <div className="space-y-3 w-full">
                                            {/* Submitter Details */}
                                            {!item.is_anonymous && (
                                                <div className="text-xs text-gray-600 flex flex-wrap gap-x-4 gap-y-1 font-medium bg-gray-50/70 p-2.5 rounded-lg border border-gray-100">
                                                    {item.name && <span><strong>Name:</strong> {item.name}</span>}
                                                    {item.mobile && <span><strong>Mobile:</strong> {item.mobile}</span>}
                                                    {item.age && <span><strong>Age:</strong> {item.age}</span>}
                                                    {item.email && <span><strong>Email:</strong> {item.email}</span>}
                                                    {item.city && <span><strong>City:</strong> {item.city}</span>}
                                                </div>
                                            )}

                                            {/* Question Text */}
                                            <div className="bg-amber-50/30 p-4 rounded-xl border border-amber-100">
                                                <span className="text-[10px] font-bold uppercase tracking-wider text-amber-900/60 block mb-1">
                                                    User Question:
                                                </span>
                                                <p className="text-gray-900 font-serif text-base leading-relaxed">
                                                    "{item.question}"
                                                </p>
                                            </div>

                                            {/* Existing Admin Reply Box */}
                                            {item.admin_reply && replyingId !== item.id && (
                                                <div className="bg-gradient-to-br from-[#ae2b2b]/5 to-[#ae2b2b]/10 border-l-4 border-[#ae2b2b] p-4 rounded-r-xl space-y-1.5 animate-in fade-in">
                                                    <div className="flex items-center justify-between gap-2">
                                                        <span className="inline-flex items-center gap-1.5 text-xs font-bold text-[#ae2b2b]">
                                                            <ShieldCheck className="h-4 w-4" /> Official Admin Reply:
                                                        </span>
                                                        {item.replied_at && (
                                                            <span className="text-xs text-gray-400">
                                                                {new Date(item.replied_at).toLocaleString()}
                                                            </span>
                                                        )}
                                                    </div>
                                                    <p className="text-gray-900 font-medium text-sm leading-relaxed whitespace-pre-line">
                                                        {item.admin_reply}
                                                    </p>
                                                </div>
                                            )}

                                            {/* Reply Action / Form */}
                                            {replyingId === item.id ? (
                                                <div className="space-y-3 bg-red-50/30 p-4 rounded-xl border border-[#ae2b2b]/20 animate-in fade-in">
                                                    <label className="block text-xs font-bold text-[#ae2b2b] uppercase tracking-wider">
                                                        Write Official Reply:
                                                    </label>
                                                    <textarea
                                                        rows="4"
                                                        placeholder="Write reply here... (This reply will be visible to the submitter)"
                                                        value={replyText}
                                                        onChange={(e) => setReplyText(e.target.value)}
                                                        className="w-full p-3 border border-gray-300 rounded-xl bg-white focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] outline-none text-sm font-medium"
                                                    />
                                                    <div className="flex gap-2">
                                                        <button
                                                            onClick={() => handleSaveReply(item.id)}
                                                            disabled={isSavingReply}
                                                            className="flex items-center gap-1.5 px-4 py-2 rounded-xl bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white font-bold text-xs shadow-md transition-all cursor-pointer disabled:opacity-50"
                                                        >
                                                            <Send className="h-3.5 w-3.5" /> Save & Publish Reply
                                                        </button>
                                                        <button
                                                            onClick={() => {
                                                                setReplyingId(null);
                                                                setReplyText("");
                                                            }}
                                                            className="px-4 py-2 rounded-xl border border-gray-300 bg-white text-gray-700 font-semibold text-xs hover:bg-gray-50 transition-colors cursor-pointer"
                                                        >
                                                            Cancel
                                                        </button>
                                                    </div>
                                                </div>
                                            ) : (
                                                <div className="pt-1">
                                                    <button
                                                        onClick={() => {
                                                            setReplyingId(item.id);
                                                            setReplyText(item.admin_reply || "");
                                                        }}
                                                        className="inline-flex items-center gap-1.5 px-3.5 py-1.5 rounded-lg bg-[#ae2b2b]/10 text-[#ae2b2b] hover:bg-[#ae2b2b] hover:text-white font-bold text-xs transition-all cursor-pointer border border-[#ae2b2b]/20"
                                                    >
                                                        {item.admin_reply ? (
                                                            <>
                                                                <Edit3 className="h-3.5 w-3.5" /> Edit Reply
                                                            </>
                                                        ) : (
                                                            <>
                                                                <MessageSquareQuote className="h-3.5 w-3.5" /> Reply to Question
                                                            </>
                                                        )}
                                                    </button>
                                                </div>
                                            )}
                                        </div>
                                    ) : (
                                        <>
                                            <div className="flex items-center gap-1 mb-1">
                                                {[...Array(5)].map((_, i) => (
                                                    <Star key={i} className={`h-4 w-4 ${i < item.rating ? 'fill-yellow-400 text-yellow-400' : 'text-gray-300'}`} />
                                                ))}
                                                {item.is_anonymous && <span className="text-xs bg-gray-100 px-2 py-0.5 rounded text-gray-500 ml-2">Anonymous</span>}
                                            </div>
                                            <p className="text-gray-700 mt-2 italic">"{item.comments}"</p>
                                        </>
                                    )}
                                </div>

                                <button
                                    onClick={() => handleDelete(item.id)}
                                    className="p-2 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition cursor-pointer shrink-0"
                                    title="Delete"
                                >
                                    <Trash2 className="h-4 w-4" />
                                </button>
                            </div>
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
}
