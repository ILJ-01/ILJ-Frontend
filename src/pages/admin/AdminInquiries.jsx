import { useState, useEffect } from "react";
import { supabase } from "@/lib/supabase";
import {
    LayoutGrid, Search, Loader2, MessageSquare, MapPin,
    Star, Trash2, CheckCircle, X, Download, FileSpreadsheet, 
    HelpCircle, Send, Edit3, ShieldCheck, MessageSquareQuote,
    Copy, Check, ExternalLink, Lock, Unlock, MessageCircle, Phone
} from "lucide-react";
import * as XLSX from 'xlsx';
import { useAuth } from "@/context/AuthContext";
import {
    getQuestionThreadUrl,
    generateWhatsAppLink,
    formatWhatsAppPhone
} from "@/lib/questionUtils";

export default function AdminInquiries() {
    const { user, loading: authLoading } = useAuth();
    const [activeTab, setActiveTab] = useState("inquiries"); // 'inquiries', 'feedback', 'reflect_questions', or 'questions'
    const [data, setData] = useState([]);
    const [loading, setLoading] = useState(true);
    const [projects, setProjects] = useState({});
    const [events, setEvents] = useState({});

    // Admin Reply State
    const [replyingId, setReplyingId] = useState(null);
    const [replyText, setReplyText] = useState("");
    const [closeAfterReply, setCloseAfterReply] = useState(false);
    const [isSavingReply, setIsSavingReply] = useState(false);

    // Questions Filter & Search State
    const [questionFilter, setQuestionFilter] = useState("all"); // 'all', 'pending', 'answered', 'closed'
    const [searchQuery, setSearchQuery] = useState("");
    const [copiedId, setCopiedId] = useState(null);

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
                    : activeTab === 'questions'
                        ? 'questions'
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
                    : activeTab === 'questions'
                        ? 'questions'
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
            if (activeTab === 'questions') {
                const { data: res, error } = await supabase.rpc('admin_reply_question', {
                    p_question_id: questionId,
                    p_reply: replyText.trim(),
                    p_admin_name: 'ILJ Mentor',
                    p_close: closeAfterReply
                });

                if (error) {
                    // Fallback direct table update if RPC unavailable
                    const item = data.find(d => d.id === questionId);
                    const newMsg = {
                        id: crypto.randomUUID ? crypto.randomUUID() : String(Date.now()),
                        sender: 'admin',
                        sender_name: 'ILJ Mentor',
                        text: replyText.trim(),
                        created_at: repliedAtIso
                    };
                    const updatedConv = [...(item?.conversation || []), newMsg];
                    const nextStatus = closeAfterReply ? 'closed' : 'answered';

                    const { error: fallbackError } = await supabase
                        .from('questions')
                        .update({
                            admin_reply: replyText.trim(),
                            replied_at: repliedAtIso,
                            status: nextStatus,
                            conversation: updatedConv
                        })
                        .eq('id', questionId);

                    if (fallbackError) throw fallbackError;

                    setData(prev => prev.map(q => q.id === questionId ? {
                        ...q,
                        admin_reply: replyText.trim(),
                        replied_at: repliedAtIso,
                        status: nextStatus,
                        conversation: updatedConv
                    } : q));
                } else if (res && res.success) {
                    setData(prev => prev.map(q => q.id === questionId ? {
                        ...q,
                        admin_reply: replyText.trim(),
                        replied_at: res.replied_at || repliedAtIso,
                        status: res.status,
                        conversation: res.conversation
                    } : q));
                }
            } else {
                // reflect_questions
                const updatePayload = {
                    admin_reply: replyText.trim(),
                    replied_at: repliedAtIso
                };
                const { error } = await supabase
                    .from('reflect_questions')
                    .update(updatePayload)
                    .eq('id', questionId);

                if (error) throw error;

                setData(prev => prev.map(item => item.id === questionId ? {
                    ...item,
                    admin_reply: replyText.trim(),
                    replied_at: repliedAtIso
                } : item));
            }

            setReplyingId(null);
            setReplyText("");
            setCloseAfterReply(false);
            alert("Reply saved & published successfully!");
        } catch (err) {
            console.error("Error saving reply:", err);
            alert("Failed to save reply: " + (err.message || "Unknown error"));
        } finally {
            setIsSavingReply(false);
        }
    };

    const handleToggleStatus = async (questionId, newStatus) => {
        try {
            const { data: res, error } = await supabase.rpc('toggle_question_status', {
                p_question_id: questionId,
                p_status: newStatus
            });

            if (error) {
                const { error: fallbackErr } = await supabase
                    .from('questions')
                    .update({ status: newStatus })
                    .eq('id', questionId);
                if (fallbackErr) throw fallbackErr;
            }

            setData(prev => prev.map(q => q.id === questionId ? { ...q, status: newStatus } : q));
        } catch (err) {
            console.error("Error updating status:", err);
            alert("Failed to update status.");
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
            } else if (activeTab === 'questions') {
                return {
                    Ticket_No: item.ticket_no ? `ILJ-Q${item.ticket_no}` : 'N/A',
                    Name: item.name,
                    Phone: item.phone_no,
                    Email: item.email || 'N/A',
                    Gender: item.gender || 'N/A',
                    Age: item.age || 'N/A',
                    Address: item.address || 'N/A',
                    Question: item.question,
                    Status: item.status || 'pending',
                    Admin_Reply: item.admin_reply || 'Pending',
                    Messages_Count: Array.isArray(item.conversation) ? item.conversation.length : 1,
                    Thread_URL: getQuestionThreadUrl(item.access_token || item.id),
                    Replied_At: item.replied_at ? new Date(item.replied_at).toLocaleString() : 'N/A',
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
                : activeTab === 'questions'
                    ? "Questions"
                    : "Feedback";

        XLSX.utils.book_append_sheet(wb, ws, sheetName);
        XLSX.writeFile(wb, `${activeTab}_${new Date().toISOString().split('T')[0]}.xlsx`);
    };

    // Filter items for Questions tab
    const filteredQuestions = data.filter(item => {
        if (activeTab !== 'questions') return true;
        if (questionFilter !== 'all') {
            const itemStatus = item.status || 'pending';
            if (itemStatus !== questionFilter) return false;
        }
        if (searchQuery.trim()) {
            const q = searchQuery.toLowerCase();
            const matchName = item.name?.toLowerCase().includes(q);
            const matchPhone = item.phone_no?.includes(q);
            const matchTicket = String(item.ticket_no || '').includes(q);
            const matchQuestion = item.question?.toLowerCase().includes(q);
            if (!matchName && !matchPhone && !matchTicket && !matchQuestion) return false;
        }
        return true;
    });

    const pendingQuestionsCount = data.filter(d => (d.status || 'pending') === 'pending').length;
    const answeredQuestionsCount = data.filter(d => d.status === 'answered').length;
    const closedQuestionsCount = data.filter(d => d.status === 'closed').length;

    const displayData = activeTab === 'questions' ? filteredQuestions : data;

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
                                : activeTab === 'questions'
                                    ? 'Life & Jainism Questions (Threads)'
                                    : 'Feedback & Reviews'}
                    </h1>
                    <p className="text-gray-500">
                        {activeTab === 'reflect_questions' 
                            ? 'Questions submitted by people regarding Reflect Workshop (Admin Only).'
                            : activeTab === 'questions'
                                ? 'Questions & doubts with threaded dialogue links and WhatsApp notifications.'
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

            {/* Main Tabs */}
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
                <button
                    onClick={() => setActiveTab("questions")}
                    className={`px-4 py-2 rounded-lg text-sm font-medium transition-all flex items-center gap-2 cursor-pointer
                        ${activeTab === "questions" ? "bg-[#ae2b2b] text-white shadow" : "text-gray-500 hover:text-gray-900"}`}
                >
                    <MessageSquareQuote className="h-4 w-4" /> Life & Jainism Questions
                    {activeTab !== "questions" && pendingQuestionsCount > 0 && (
                        <span className="bg-amber-100 text-amber-900 text-xs px-1.5 py-0.5 rounded-full font-bold">
                            {pendingQuestionsCount}
                        </span>
                    )}
                </button>
            </div>

            {/* Questions Tab Sub-Bar: Filters & Search */}
            {activeTab === 'questions' && (
                <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white p-4 rounded-2xl border border-gray-200 shadow-xs">
                    {/* Status Filters */}
                    <div className="flex flex-wrap items-center gap-1.5">
                        <button
                            onClick={() => setQuestionFilter("all")}
                            className={`px-3 py-1.5 rounded-lg text-xs font-bold transition cursor-pointer ${
                                questionFilter === "all"
                                    ? "bg-gray-900 text-white"
                                    : "bg-gray-100 text-gray-700 hover:bg-gray-200"
                            }`}
                        >
                            All ({data.length})
                        </button>
                        <button
                            onClick={() => setQuestionFilter("pending")}
                            className={`px-3 py-1.5 rounded-lg text-xs font-bold transition cursor-pointer flex items-center gap-1.5 ${
                                questionFilter === "pending"
                                    ? "bg-amber-600 text-white"
                                    : "bg-amber-50 text-amber-800 border border-amber-200 hover:bg-amber-100"
                            }`}
                        >
                            <span className="h-2 w-2 rounded-full bg-amber-500 animate-pulse" />
                            Pending ({pendingQuestionsCount})
                        </button>
                        <button
                            onClick={() => setQuestionFilter("answered")}
                            className={`px-3 py-1.5 rounded-lg text-xs font-bold transition cursor-pointer ${
                                questionFilter === "answered"
                                    ? "bg-emerald-600 text-white"
                                    : "bg-emerald-50 text-emerald-800 border border-emerald-200 hover:bg-emerald-100"
                            }`}
                        >
                            Answered ({answeredQuestionsCount})
                        </button>
                        <button
                            onClick={() => setQuestionFilter("closed")}
                            className={`px-3 py-1.5 rounded-lg text-xs font-bold transition cursor-pointer ${
                                questionFilter === "closed"
                                    ? "bg-gray-600 text-white"
                                    : "bg-gray-100 text-gray-700 hover:bg-gray-200"
                            }`}
                        >
                            Closed ({closedQuestionsCount})
                        </button>
                    </div>

                    {/* Search Input */}
                    <div className="relative w-full sm:w-72">
                        <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
                        <input
                            type="text"
                            placeholder="Search name, phone, doubt..."
                            value={searchQuery}
                            onChange={(e) => setSearchQuery(e.target.value)}
                            className="w-full pl-9 pr-3 py-1.5 bg-gray-50 border border-gray-200 rounded-lg text-xs font-medium focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20"
                        />
                    </div>
                </div>
            )}

            {/* Content Table/List */}
            {loading ? (
                <div className="flex justify-center py-12">
                    <Loader2 className="h-8 w-8 animate-spin text-[#ae2b2b]" />
                </div>
            ) : displayData.length === 0 ? (
                <div className="text-center py-12 bg-white rounded-xl border border-dashed border-gray-300">
                    <div className="mx-auto h-12 w-12 text-gray-400 mb-3 flex items-center justify-center">
                        {activeTab === 'inquiries' ? <MapPin className="h-8 w-8" /> : activeTab === 'reflect_questions' ? <HelpCircle className="h-8 w-8" /> : <MessageSquare className="h-8 w-8" />}
                    </div>
                    <h3 className="text-lg font-medium text-gray-900">No records found</h3>
                    <p className="text-gray-500">
                        {activeTab === 'questions' && searchQuery
                            ? "No questions match your search or filter."
                            : "Wait for new submissions."}
                    </p>
                </div>
            ) : (
                <div className="grid gap-4">
                    {displayData.map((item) => (
                        <div key={item.id} className="bg-white p-5 rounded-2xl shadow-sm border border-gray-100 hover:shadow-md transition">
                            <div className="flex flex-col md:flex-row gap-4 justify-between items-start">
                                <div className="space-y-3 flex-1 w-full">
                                    
                                    {/* Top Header Tags */}
                                    <div className="flex flex-wrap items-center gap-2">
                                        {activeTab === 'questions' ? (
                                            <>
                                                {/* Ticket Number Tag */}
                                                <span className="text-xs font-mono font-bold uppercase tracking-wide px-2.5 py-1 bg-[#ae2b2b]/10 text-[#ae2b2b] rounded-md border border-[#ae2b2b]/20">
                                                    #{item.ticket_no ? `ILJ-Q${item.ticket_no}` : 'TICKET'}
                                                </span>

                                                {/* Status Badge */}
                                                {item.status === 'closed' ? (
                                                    <span className="text-xs font-bold px-2.5 py-1 bg-gray-100 text-gray-700 rounded-md border border-gray-200 flex items-center gap-1">
                                                        <Lock className="h-3 w-3" /> Closed
                                                    </span>
                                                ) : item.status === 'answered' ? (
                                                    <span className="text-xs font-bold px-2.5 py-1 bg-emerald-50 text-emerald-700 rounded-md border border-emerald-100 flex items-center gap-1">
                                                        <CheckCircle className="h-3 w-3" /> Answered
                                                    </span>
                                                ) : (
                                                    <span className="text-xs font-bold px-2.5 py-1 bg-amber-50 text-amber-800 rounded-md border border-amber-200 flex items-center gap-1.5">
                                                        <span className="h-2 w-2 rounded-full bg-amber-500 animate-pulse" />
                                                        Pending Reply
                                                    </span>
                                                )}

                                                {item.gender && (
                                                    <span className="text-xs font-medium px-2 py-0.5 bg-gray-100 text-gray-700 rounded">
                                                        {item.gender}
                                                    </span>
                                                )}
                                            </>
                                        ) : activeTab === 'reflect_questions' ? (
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
                                    {activeTab === 'questions' ? (
                                        <div className="space-y-4 w-full">
                                            {/* Submitter & WhatsApp Action Strip */}
                                            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 bg-gray-50/80 p-3.5 rounded-xl border border-gray-100">
                                                <div className="text-xs text-gray-700 flex flex-wrap gap-x-4 gap-y-1 font-medium">
                                                    <span><strong>Name:</strong> {item.name}</span>
                                                    <span>
                                                        <strong>Phone:</strong>{" "}
                                                        <a href={`tel:${item.phone_no}`} className="text-blue-600 hover:underline">
                                                            {item.phone_no}
                                                        </a>
                                                    </span>
                                                    {item.email && <span><strong>Email:</strong> {item.email}</span>}
                                                    {item.age && <span><strong>Age:</strong> {item.age}</span>}
                                                    {item.gender && <span><strong>Gender:</strong> {item.gender}</span>}
                                                    {item.address && <span><strong>Location:</strong> {item.address}</span>}
                                                </div>

                                                {/* Action Buttons: WhatsApp + Copy Link + View Thread */}
                                                <div className="flex flex-wrap items-center gap-2 shrink-0">
                                                    {/* Dynamic WhatsApp Button */}
                                                    <a
                                                        href={generateWhatsAppLink(
                                                            item.phone_no,
                                                            item.name,
                                                            getQuestionThreadUrl(item.access_token || item.id)
                                                        )}
                                                        target="_blank"
                                                        rel="noopener noreferrer"
                                                        className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs shadow-xs transition cursor-pointer"
                                                        title="Open WhatsApp with answer notification and link"
                                                    >
                                                        <MessageCircle className="h-3.5 w-3.5" />
                                                        <span>Notify via WhatsApp</span>
                                                    </a>

                                                    {/* Copy Link Button */}
                                                    <button
                                                        onClick={() => {
                                                            const url = getQuestionThreadUrl(item.access_token || item.id);
                                                            navigator.clipboard.writeText(url);
                                                            setCopiedId(item.id);
                                                            setTimeout(() => setCopiedId(null), 2500);
                                                        }}
                                                        className={`inline-flex items-center gap-1 px-2.5 py-1.5 rounded-lg border text-xs font-semibold transition cursor-pointer shadow-xs ${
                                                            copiedId === item.id
                                                                ? "bg-emerald-50 border-emerald-300 text-emerald-700 font-bold"
                                                                : "bg-white border-gray-200 text-gray-700 hover:bg-gray-50"
                                                        }`}
                                                        title="Copy private question link"
                                                    >
                                                        {copiedId === item.id ? (
                                                            <>
                                                                <Check className="h-3.5 w-3.5 text-emerald-600" />
                                                                <span>Copied!</span>
                                                            </>
                                                        ) : (
                                                            <>
                                                                <Copy className="h-3.5 w-3.5 text-gray-400" />
                                                                <span>Copy Link</span>
                                                            </>
                                                        )}
                                                    </button>

                                                    {/* Open User Thread View */}
                                                    <a
                                                        href={getQuestionThreadUrl(item.access_token || item.id)}
                                                        target="_blank"
                                                        rel="noopener noreferrer"
                                                        className="p-1.5 rounded-lg border border-gray-200 bg-white hover:bg-gray-50 text-gray-500 hover:text-gray-900 transition"
                                                        title="Open user thread view in new tab"
                                                    >
                                                        <ExternalLink className="h-3.5 w-3.5" />
                                                    </a>
                                                </div>
                                            </div>

                                            {/* Chronological Conversation Thread */}
                                            <div className="space-y-3">
                                                <span className="text-[11px] font-bold uppercase tracking-wider text-gray-500 flex items-center gap-1.5">
                                                    <MessageSquare className="h-3.5 w-3.5 text-[#ae2b2b]" /> Conversation Thread ({Array.isArray(item.conversation) ? item.conversation.length : 1} message{Array.isArray(item.conversation) && item.conversation.length === 1 ? '' : 's'}):
                                                </span>

                                                {Array.isArray(item.conversation) && item.conversation.length > 0 ? (
                                                    <div className="space-y-2.5 pl-2 border-l-2 border-gray-200">
                                                        {item.conversation.map((msg, mIdx) => {
                                                            const isUser = msg.sender === 'user';
                                                            return (
                                                                <div
                                                                    key={msg.id || mIdx}
                                                                    className={`p-3.5 rounded-xl text-sm leading-relaxed ${
                                                                        isUser
                                                                            ? "bg-amber-50/60 border border-amber-200/70 text-gray-900"
                                                                            : "bg-red-50/40 border border-[#ae2b2b]/20 text-gray-900"
                                                                    }`}
                                                                >
                                                                    <div className="flex items-center justify-between gap-2 mb-1">
                                                                        <span className={`text-xs font-bold ${isUser ? "text-amber-900" : "text-[#ae2b2b]"}`}>
                                                                            {isUser ? `👤 ${msg.sender_name || item.name || 'User'}` : `🛡️ ILJ Mentor`}
                                                                        </span>
                                                                        {msg.created_at && (
                                                                            <span className="text-[11px] text-gray-400">
                                                                                {new Date(msg.created_at).toLocaleString()}
                                                                            </span>
                                                                        )}
                                                                    </div>
                                                                    <p className="whitespace-pre-line font-medium text-xs sm:text-sm">
                                                                        {msg.text}
                                                                    </p>
                                                                </div>
                                                            );
                                                        })}
                                                    </div>
                                                ) : (
                                                    /* Fallback for legacy records */
                                                    <div className="space-y-2.5">
                                                        <div className="bg-amber-50/40 p-4 rounded-xl border border-amber-100/80">
                                                            <span className="text-[10px] font-bold uppercase tracking-wider text-amber-900/70 block mb-1">
                                                                Question / Doubt:
                                                            </span>
                                                            <p className="text-gray-900 font-serif text-sm sm:text-base leading-relaxed whitespace-pre-line">
                                                                "{item.question}"
                                                            </p>
                                                        </div>

                                                        {item.admin_reply && (
                                                            <div className="bg-gradient-to-br from-[#ae2b2b]/5 to-[#ae2b2b]/10 border-l-4 border-[#ae2b2b] p-4 rounded-r-xl space-y-1">
                                                                <span className="text-xs font-bold text-[#ae2b2b] flex items-center gap-1.5">
                                                                    <ShieldCheck className="h-4 w-4" /> Official Reply / Guidance:
                                                                </span>
                                                                <p className="text-gray-900 font-medium text-sm whitespace-pre-line">
                                                                    {item.admin_reply}
                                                                </p>
                                                            </div>
                                                        )}
                                                    </div>
                                                )}
                                            </div>

                                            {/* Reply / Action Controls */}
                                            {replyingId === item.id ? (
                                                <div className="space-y-3 bg-red-50/30 p-4 rounded-xl border border-[#ae2b2b]/20 animate-in fade-in">
                                                    <label className="block text-xs font-bold text-[#ae2b2b] uppercase tracking-wider">
                                                        Write Reply / Guidance:
                                                    </label>
                                                    <textarea
                                                        rows="4"
                                                        placeholder="Type reply here... (This will appear on the user's thread link)"
                                                        value={replyText}
                                                        onChange={(e) => setReplyText(e.target.value)}
                                                        className="w-full p-3 border border-gray-300 rounded-xl bg-white focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] outline-none text-sm font-medium"
                                                    />

                                                    <div className="flex items-center gap-2">
                                                        <input
                                                            type="checkbox"
                                                            id={`closeAfterReply-${item.id}`}
                                                            checked={closeAfterReply}
                                                            onChange={(e) => setCloseAfterReply(e.target.checked)}
                                                            className="h-4 w-4 text-[#ae2b2b] rounded focus:ring-[#ae2b2b]"
                                                        />
                                                        <label htmlFor={`closeAfterReply-${item.id}`} className="text-xs text-gray-700 font-medium cursor-pointer">
                                                            Close conversation after sending this reply
                                                        </label>
                                                    </div>

                                                    <div className="flex flex-wrap gap-2 pt-1">
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
                                                                setCloseAfterReply(false);
                                                            }}
                                                            className="px-4 py-2 rounded-xl border border-gray-300 bg-white text-gray-700 font-semibold text-xs hover:bg-gray-50 transition-colors cursor-pointer"
                                                        >
                                                            Cancel
                                                        </button>
                                                    </div>
                                                </div>
                                            ) : (
                                                <div className="flex flex-wrap items-center gap-2 pt-1">
                                                    <button
                                                        onClick={() => {
                                                            setReplyingId(item.id);
                                                            setReplyText("");
                                                            setCloseAfterReply(false);
                                                        }}
                                                        className="inline-flex items-center gap-1.5 px-3.5 py-1.5 rounded-lg bg-[#ae2b2b]/10 text-[#ae2b2b] hover:bg-[#ae2b2b] hover:text-white font-bold text-xs transition-all cursor-pointer border border-[#ae2b2b]/20"
                                                    >
                                                        <MessageSquareQuote className="h-3.5 w-3.5" />
                                                        <span>{item.admin_reply ? "Reply / Add Follow-up" : "Reply to Question"}</span>
                                                    </button>

                                                    {item.status === 'closed' ? (
                                                        <button
                                                            onClick={() => handleToggleStatus(item.id, 'answered')}
                                                            className="inline-flex items-center gap-1 px-3 py-1.5 rounded-lg border border-gray-200 bg-white hover:bg-gray-50 text-gray-600 hover:text-gray-900 text-xs font-semibold transition cursor-pointer"
                                                            title="Re-open conversation"
                                                        >
                                                            <Unlock className="h-3.5 w-3.5 text-gray-400" />
                                                            <span>Re-open Thread</span>
                                                        </button>
                                                    ) : (
                                                        <button
                                                            onClick={() => {
                                                                if (confirm("Are you sure you want to close this conversation? The user won't be able to submit more follow-ups unless re-opened.")) {
                                                                    handleToggleStatus(item.id, 'closed');
                                                                }
                                                            }}
                                                            className="inline-flex items-center gap-1 px-3 py-1.5 rounded-lg border border-gray-200 bg-white hover:bg-gray-50 text-gray-600 hover:text-red-700 text-xs font-semibold transition cursor-pointer"
                                                            title="Close conversation"
                                                        >
                                                            <Lock className="h-3.5 w-3.5 text-gray-400" />
                                                            <span>Close Conversation</span>
                                                        </button>
                                                    )}
                                                </div>
                                            )}
                                        </div>
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
                                    ) : activeTab === 'inquiries' ? (
                                        <>
                                            <h3 className="font-bold text-gray-900">{item.name} <span className="text-gray-400 font-normal">({item.mobile})</span></h3>
                                            <p className="text-sm text-gray-600 font-medium">{item.email}</p>
                                            <p className="mt-2 text-gray-700 bg-gray-50 p-3 rounded-lg border border-gray-100 text-sm leading-relaxed">
                                                {item.message}
                                            </p>
                                        </>
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
