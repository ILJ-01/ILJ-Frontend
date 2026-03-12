import { useState, useEffect } from "react";
import { useAuth } from "@/context/AuthContext";
import { supabase } from "@/lib/supabase";
import {
    Lightbulb, Send, Loader2, Briefcase
} from "lucide-react";

export default function VolunteerIdeas() {
    const { user } = useAuth();
    const [loading, setLoading] = useState(true);
    const [projects, setProjects] = useState([]);
    const [myIdeas, setMyIdeas] = useState([]);

    // Idea forms
    const [ideaForm, setIdeaForm] = useState({ title: '', description: '', project_id: '' });
    const [submittingIdea, setSubmittingIdea] = useState(false);
    const [showIdeaForm, setShowIdeaForm] = useState(false);

    useEffect(() => {
        if (user?.id) fetchIdeasData();
    }, [user]);

    const fetchIdeasData = async () => {
        try {
            setLoading(true);

            // Fetch projects for idea form
            const { data: projectData } = await supabase
                .from('projects')
                .select('id, title')
                .order('title');
            setProjects(projectData || []);

            // Fetch my ideas
            const { data: ideasData } = await supabase
                .from('ideas')
                .select('*, project:projects(title)')
                .eq('submitted_by', user.id)
                .order('created_at', { ascending: false });
            setMyIdeas(ideasData || []);

        } catch (error) {
            console.error("Ideas Load Error:", error);
        } finally {
            setLoading(false);
        }
    };

    const handleSubmitIdea = async (e) => {
        e.preventDefault();
        if (!ideaForm.title.trim() || !ideaForm.description.trim()) {
            alert('Please fill in the title and description.');
            return;
        }

        setSubmittingIdea(true);
        try {
            const { data, error } = await supabase
                .from('ideas')
                .insert({
                    title: ideaForm.title.trim(),
                    description: ideaForm.description.trim(),
                    project_id: ideaForm.project_id || null,
                    submitted_by: user.id
                })
                .select('*, project:projects(title)')
                .single();

            if (error) throw error;

            setMyIdeas(prev => [data, ...prev]);
            setIdeaForm({ title: '', description: '', project_id: '' });
            setShowIdeaForm(false);
            alert('Your idea has been submitted successfully! 🎉');
        } catch (err) {
            console.error('Idea Submit Error:', err);
            alert('Failed to submit idea. Please try again.');
        } finally {
            setSubmittingIdea(false);
        }
    };

    if (loading) return (
        <div className="flex justify-center items-center h-96">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-[#ae2b2b]"></div>
        </div>
    );

    return (
        <div className="space-y-6 animate-in fade-in slide-in-from-bottom-4 duration-500">
            {/* Header section */}
            <div className="bg-gradient-to-r from-red-900 to-red-500 rounded-2xl p-6 md:p-8 text-white shadow-lg">
                <div className="flex items-center gap-3 mb-2">
                    <div className="bg-white/20 p-2 rounded-lg backdrop-blur-sm">
                        <Lightbulb className="h-6 w-6 text-white" />
                    </div>
                    <h2 className="text-2xl md:text-3xl font-bold font-serif text-white">Share an Idea</h2>
                </div>
                <p className="text-white/90 mt-2 max-w-2xl text-lg">
                    Have a great idea? Share it with the leadership team. Your ideas help shape our community!
                </p>
            </div>

            {/* Share an Idea Action */}
            <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                <div className="p-6">
                    <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-4">
                        <h3 className="text-lg font-bold text-gray-800 flex items-center gap-2">
                            <Lightbulb className="h-5 w-5 text-amber-500" /> New Idea
                        </h3>
                        <button
                            onClick={() => setShowIdeaForm(!showIdeaForm)}
                            className={`px-6 py-2.5 rounded-lg text-sm font-bold transition-all shadow-md ${showIdeaForm
                                    ? 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                                    : 'bg-gradient-to-r from-amber-500 to-red-500 text-white hover:from-amber-600 hover:to-red-600'
                                }`}
                        >
                            {showIdeaForm ? 'Cancel' : '+ New Idea'}
                        </button>
                    </div>

                    {/* Idea Form */}
                    {showIdeaForm && (
                        <form onSubmit={handleSubmitIdea} className="mb-6 p-6 bg-gradient-to-br from-amber-50/80 to-red-50/80 rounded-xl border border-amber-200/50 space-y-5 animate-in fade-in slide-in-from-top-2 duration-300">
                            <div>
                                <label className="block text-sm font-bold text-gray-800 mb-1.5">Idea Title <span className="text-red-500">*</span></label>
                                <input
                                    type="text"
                                    className="w-full p-3.5 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-amber-500 focus:border-transparent outline-none bg-white shadow-sm"
                                    placeholder="Give your idea a clear title..."
                                    value={ideaForm.title}
                                    onChange={(e) => setIdeaForm(prev => ({ ...prev, title: e.target.value }))}
                                    required
                                />
                            </div>
                            <div>
                                <label className="block text-sm font-bold text-gray-800 mb-1.5">Description <span className="text-red-500">*</span></label>
                                <textarea
                                    className="w-full p-3.5 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-amber-500 focus:border-transparent outline-none bg-white resize-none shadow-sm"
                                    rows={5}
                                    placeholder="Describe your idea in detail — what problem does it solve, how can it be implemented?"
                                    value={ideaForm.description}
                                    onChange={(e) => setIdeaForm(prev => ({ ...prev, description: e.target.value }))}
                                    required
                                />
                            </div>
                            <div>
                                <label className="block text-sm font-bold text-gray-800 mb-1.5">Related Pod (Optional)</label>
                                <select
                                    className="w-full p-3.5 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-amber-500 focus:border-transparent outline-none bg-white shadow-sm"
                                    value={ideaForm.project_id}
                                    onChange={(e) => setIdeaForm(prev => ({ ...prev, project_id: e.target.value }))}
                                >
                                    <option value="">Not related to any Pod</option>
                                    {projects.map(p => (
                                        <option key={p.id} value={p.id}>{p.title}</option>
                                    ))}
                                </select>
                            </div>
                            <button
                                type="submit"
                                disabled={submittingIdea}
                                className="w-full flex items-center justify-center gap-2 py-3.5 bg-gradient-to-r from-red-900 to-red-500 text-white rounded-xl font-bold text-base hover:from-amber-600 hover:to-red-600 transition-all shadow-md disabled:opacity-50 disabled:cursor-not-allowed mt-4"
                            >
                                {submittingIdea ? (
                                    <><Loader2 className="h-5 w-5 animate-spin" /> Submitting...</>
                                ) : (
                                    <><Send className="h-5 w-5" /> Submit Idea</>
                                )}
                            </button>
                        </form>
                    )}

                    {/* My Ideas List */}
                    {myIdeas.length > 0 ? (
                        <div className="space-y-4 mt-6">
                            <h4 className="text-xs font-bold text-gray-500 uppercase tracking-widest border-b pb-2">Your Submitted Ideas ({myIdeas.length})</h4>
                            {myIdeas.map(idea => {
                                const statusMap = {
                                    pending: { label: 'Pending Review', style: 'bg-amber-100 text-amber-700 border-amber-200' },
                                    reviewed: { label: 'Reviewed', style: 'bg-blue-100 text-blue-700 border-blue-200' },
                                    approved: { label: 'Approved', style: 'bg-green-100 text-green-700 border-green-200' },
                                    implemented: { label: 'Implemented', style: 'bg-purple-100 text-purple-700 border-purple-200' },
                                    rejected: { label: 'Rejected', style: 'bg-red-100 text-red-700 border-red-200' }
                                };
                                const s = statusMap[idea.status] || statusMap.pending;

                                return (
                                    <div key={idea.id} className="p-5 bg-gray-50 rounded-xl border border-gray-100 hover:bg-white hover:shadow-md transition-all">
                                        <div className="flex items-start justify-between gap-3">
                                            <div className="flex-1 min-w-0">
                                                <div className="flex items-start sm:items-center flex-col sm:flex-row gap-2 sm:gap-3 mb-2">
                                                    <div className="flex items-center gap-2">
                                                        <Lightbulb className="h-5 w-5 text-amber-500 shrink-0" />
                                                        <h4 className="font-bold text-gray-900 text-base">{idea.title}</h4>
                                                    </div>
                                                    <span className={`px-2.5 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider border ${s.style}`}>
                                                        {s.label}
                                                    </span>
                                                </div>
                                                <p className="text-gray-700 text-sm whitespace-pre-wrap mt-2">{idea.description}</p>
                                                <div className="flex items-center gap-4 mt-4 flex-wrap">
                                                    {idea.project && (
                                                        <span className="text-xs text-blue-700 font-bold flex items-center gap-1 bg-blue-50 px-2.5 py-1 rounded-md border border-blue-100">
                                                            <Briefcase className="h-3 w-3" /> {idea.project.title}
                                                        </span>
                                                    )}
                                                    <span className="text-xs text-gray-500 font-medium">
                                                        Submitted on {new Date(idea.created_at).toLocaleDateString('en-IN', { day: 'numeric', month: 'short', year: 'numeric' })}
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                );
                            })}
                        </div>
                    ) : (
                        !showIdeaForm && (
                            <div className="text-center py-12 px-4 rounded-xl border border-dashed border-gray-200 bg-gray-50 mt-4">
                                <Lightbulb className="h-12 w-12 text-gray-300 mx-auto mb-3" />
                                <h4 className="text-lg font-bold text-gray-700">No Ideas Shared Yet</h4>
                                <p className="text-gray-500 max-w-sm mx-auto mt-1">
                                    Click the "+ New Idea" button above to share your first idea with the leadership!
                                </p>
                            </div>
                        )
                    )}
                </div>
            </div>
        </div>
    );
}
