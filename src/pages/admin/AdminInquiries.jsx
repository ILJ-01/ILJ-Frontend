import { useState, useEffect } from "react";
import { supabase } from "@/lib/supabase";
import {
    LayoutGrid, Search, Loader2, MessageSquare, MapPin,
    Star, Trash2, CheckCircle, X, Download, FileSpreadsheet
} from "lucide-react";
import * as XLSX from 'xlsx';
import { useAuth } from "@/context/AuthContext";
import { Navigate } from "react-router-dom";

export default function AdminInquiries() {
    const { user, loading: authLoading } = useAuth();
    const [activeTab, setActiveTab] = useState("inquiries"); // 'inquiries' or 'feedback'
    const [data, setData] = useState([]);
    const [loading, setLoading] = useState(true);
    const [projects, setProjects] = useState({});

    useEffect(() => {
        fetchProjects();
        fetchData();
    }, [activeTab]);

    const fetchProjects = async () => {
        const { data } = await supabase.from('projects').select('id, title');
        if (data) {
            const map = {};
            data.forEach(p => map[p.id] = p.title);
            setProjects(map);
        }
    };

    const fetchData = async () => {
        setLoading(true);
        try {
            const table = activeTab === 'inquiries' ? 'project_inquiries' : 'project_feedback';
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
            const table = activeTab === 'inquiries' ? 'project_inquiries' : 'project_feedback';
            const { error } = await supabase.from(table).delete().eq('id', id);
            if (error) throw error;
            setData(prev => prev.filter(item => item.id !== id));
        } catch (err) {
            console.error("Delete error:", err);
            alert("Failed to delete.");
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
            } else {
                return {
                    Project: projects[item.project_id] || 'Unknown',
                    Rating: item.rating,
                    Comments: item.comments,
                    Is_Anonymous: item.is_anonymous ? 'Yes' : 'No',
                    Created_At: new Date(item.created_at).toLocaleString()
                };
            }
        });

        const ws = XLSX.utils.json_to_sheet(exportData);
        const wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, ws, activeTab === 'inquiries' ? "Inquiries" : "Feedback");
        XLSX.writeFile(wb, `${activeTab}_${new Date().toISOString().split('T')[0]}.xlsx`);
    };

    if (authLoading) return <div className="p-10 text-center">Loading...</div>;
    // Basic protection (should be handled by route but double check)
    // Assuming admin layout wraps this, but checking user ensures we have context

    return (
        <div className="p-6 md:p-8 space-y-6 bg-gray-50 min-h-screen">
            <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                <div>
                    <h1 className="text-2xl font-bold text-gray-900 font-serif">
                        {activeTab === 'inquiries' ? 'Project Inquiries' : 'Feedback & Reviews'}
                    </h1>
                    <p className="text-gray-500">Manage incoming requests and feedback.</p>
                </div>
                <div className="flex gap-3">
                    <button
                        onClick={handleExport}
                        disabled={loading || data.length === 0}
                        className="flex items-center gap-2 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition"
                    >
                        <FileSpreadsheet className="h-4 w-4" /> Export
                    </button>
                </div>
            </div>

            {/* Tabs */}
            <div className="flex bg-white p-1 rounded-xl w-fit border border-gray-200">
                <button
                    onClick={() => setActiveTab("inquiries")}
                    className={`px-4 py-2 rounded-lg text-sm font-medium transition-all flex items-center gap-2
                        ${activeTab === "inquiries" ? "bg-[#ae2b2b] text-white shadow" : "text-gray-500 hover:text-gray-900"}`}
                >
                    <MapPin className="h-4 w-4" /> Organize Requests
                </button>
                <button
                    onClick={() => setActiveTab("feedback")}
                    className={`px-4 py-2 rounded-lg text-sm font-medium transition-all flex items-center gap-2
                        ${activeTab === "feedback" ? "bg-[#ae2b2b] text-white shadow" : "text-gray-500 hover:text-gray-900"}`}
                >
                    <MessageSquare className="h-4 w-4" /> Feedback
                </button>
            </div>

            {/* Content Table/List */}
            {loading ? (
                <div className="flex justify-center py-12">
                    <Loader2 className="h-8 w-8 animate-spin text-[#ae2b2b]" />
                </div>
            ) : data.length === 0 ? (
                <div className="text-center py-12 bg-white rounded-xl border border-dashed border-gray-300">
                    <div className="mx-auto h-12 w-12 text-gray-400 mb-3">
                        {activeTab === 'inquiries' ? <MapPin /> : <MessageSquare />}
                    </div>
                    <h3 className="text-lg font-medium text-gray-900">No records found</h3>
                    <p className="text-gray-500">Wait for new submissions.</p>
                </div>
            ) : (
                <div className="grid gap-4">
                    {data.map((item) => (
                        <div key={item.id} className="bg-white p-4 rounded-xl shadow-sm border border-gray-100 hover:shadow-md transition">
                            <div className="flex flex-col md:flex-row gap-4 justify-between items-start">
                                <div className="space-y-1 flex-1">
                                    <div className="flex items-center gap-2 mb-1">
                                        <span className="text-xs font-semibold uppercase tracking-wide px-2 py-0.5 bg-gray-100 text-gray-600 rounded">
                                            {projects[item.project_id] || 'Unknown Project'}
                                        </span>
                                        <span className="text-xs text-gray-400">• {new Date(item.created_at).toLocaleDateString()}</span>
                                    </div>

                                    {activeTab === 'inquiries' ? (
                                        <>
                                            <h3 className="font-bold text-gray-900">{item.name} <span className="text-gray-400 font-normal">({item.mobile})</span></h3>
                                            <p className="text-sm text-gray-600 font-medium">{item.email}</p>
                                            <p className="mt-2 text-gray-700 bg-gray-50 p-2 rounded border border-gray-100 text-sm">
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
                                    className="p-2 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition"
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
