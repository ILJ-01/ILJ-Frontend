import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import {
    Briefcase, Plus, Search, Calendar, Users, Trash2, X, AlertCircle, Clock,
    Mail, Phone, User, CheckCircle, CheckCircle2, ChevronDown, ChevronUp, Copy
} from 'lucide-react';

export default function AdminOpportunities() {
    const [opportunities, setOpportunities] = useState([]);
    const [projects, setProjects] = useState([]);
    const [loading, setLoading] = useState(true);
    const [showCreateModal, setShowCreateModal] = useState(false);
    const [expandedOpp, setExpandedOpp] = useState(null);
    const [searchTerm, setSearchTerm] = useState('');
    const [submitting, setSubmitting] = useState(false);

    // Form State
    const [newOpp, setNewOpp] = useState({
        title: '',
        message: '',
        project_id: '',
        deadline: ''
    });

    useEffect(() => {
        fetchOpportunities();
        fetchProjects();
    }, []);

    const fetchProjects = async () => {
        const { data } = await supabase.from('projects').select('id, title').order('title');
        setProjects(data || []);
    };

    const fetchOpportunities = async () => {
        setLoading(true);
        try {
            const { data, error } = await supabase
                .from('announcements')
                .select(`
                    *,
                    project:projects(id, title, project_code),
                    interests:announcement_interests(
                        id,
                        created_at,
                        volunteer:volunteers(
                            id,
                            first_name,
                            last_name,
                            ilj_id,
                            email,
                            mobile_number,
                            city
                        )
                    )
                `)
                .eq('type', 'task_opportunity')
                .order('created_at', { ascending: false });

            if (error) throw error;
            setOpportunities(data || []);
        } catch (err) {
            console.error('Error fetching opportunities:', err);
        } finally {
            setLoading(false);
        }
    };

    const handleCreateOpportunity = async (e) => {
        e.preventDefault();
        if (!newOpp.title.trim() || !newOpp.message.trim()) {
            alert('Please fill in title and description.');
            return;
        }

        setSubmitting(true);
        try {
            const { data: { session } } = await supabase.auth.getSession();
            const creator = session?.user?.email || 'Admin';

            const { error } = await supabase
                .from('announcements')
                .insert({
                    title: newOpp.title.trim(),
                    message: newOpp.message.trim(),
                    project_id: newOpp.project_id || null,
                    deadline: newOpp.deadline || null,
                    type: 'task_opportunity',
                    created_by: creator
                });

            if (error) throw error;

            alert('Opportunity posted successfully!');
            setShowCreateModal(false);
            setNewOpp({ title: '', message: '', project_id: '', deadline: '' });
            fetchOpportunities();
        } catch (err) {
            alert(`Error posting opportunity: ${err.message}`);
        } finally {
            setSubmitting(false);
        }
    };

    const handleDeleteOpportunity = async (e, id) => {
        e.stopPropagation();
        if (!window.confirm("Are you sure you want to delete this Opportunity? All associated volunteer interest links will be deleted.")) return;

        try {
            // Delete volunteer interest links first
            await supabase.from('announcement_interests').delete().eq('announcement_id', id);

            const { error } = await supabase.from('announcements').delete().eq('id', id);
            if (error) throw error;

            setOpportunities(opportunities.filter(o => o.id !== id));
            if (expandedOpp === id) setExpandedOpp(null);
        } catch (err) {
            alert(`Error deleting opportunity: ${err.message}`);
        }
    };

    const copyEmails = (interests) => {
        const emails = interests
            .map(i => i.volunteer?.email)
            .filter(Boolean)
            .join(', ');
        navigator.clipboard.writeText(emails);
        alert('Volunteer emails copied to clipboard!');
    };

    const filteredOpportunities = opportunities.filter(opp =>
        (opp.title || '').toLowerCase().includes(searchTerm.toLowerCase()) ||
        (opp.message || '').toLowerCase().includes(searchTerm.toLowerCase()) ||
        (opp.project?.title || '').toLowerCase().includes(searchTerm.toLowerCase())
    );

    return (
        <div className="space-y-6">
            {/* Toolbar */}
            <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-white p-4 rounded-xl shadow-sm border border-gray-200">
                <div className="relative w-full sm:w-96">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
                    <input
                        type="text"
                        placeholder="Search opportunities..."
                        className="w-full pl-10 pr-4 py-2 border border-gray-200 rounded-xl focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] outline-none text-sm transition-all"
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                    />
                </div>
                <button
                    onClick={() => setShowCreateModal(true)}
                    className="flex items-center justify-center gap-2 bg-[#ae2b2b] text-white px-4 py-2.5 rounded-xl hover:bg-[#8b1e1e] transition-all shadow-md font-bold text-sm w-full sm:w-auto"
                >
                    <Plus className="h-4.5 w-4.5" /> Post Opportunity
                </button>
            </div>

            {/* List */}
            {loading ? (
                <div className="flex justify-center py-12">
                    <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-[#ae2b2b]"></div>
                </div>
            ) : filteredOpportunities.length === 0 ? (
                <div className="text-center py-16 bg-white rounded-xl border border-dashed border-gray-200">
                    <Briefcase className="h-12 w-12 text-gray-300 mx-auto mb-3" />
                    <h3 className="text-lg font-medium text-gray-900">No Opportunities Found</h3>
                    <p className="text-gray-500 mt-1">Post a new task opportunity to engage volunteers.</p>
                </div>
            ) : (
                <div className="space-y-4">
                    {filteredOpportunities.map(opp => {
                        const isExpanded = expandedOpp === opp.id;
                        const volCount = opp.interests?.length || 0;

                        return (
                            <div key={opp.id} className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden transition-all duration-300">
                                {/* Header / Toggle Bar */}
                                <div
                                    className="p-5 cursor-pointer hover:bg-gray-50/50 transition-colors flex justify-between items-start gap-4"
                                    onClick={() => setExpandedOpp(isExpanded ? null : opp.id)}
                                >
                                    <div className="flex-1 min-w-0">
                                        <div className="flex items-center gap-2 mb-1.5 flex-wrap">
                                            {opp.project && (
                                                <span className="text-xs font-bold uppercase tracking-wider text-purple-700 bg-purple-50 px-2 py-0.5 rounded border border-purple-100">
                                                    {opp.project.title}
                                                </span>
                                            )}
                                            <span className="text-xs text-gray-500 font-medium">
                                                Posted: {new Date(opp.created_at).toLocaleDateString()}
                                            </span>
                                        </div>
                                        <h3 className="text-lg font-bold text-gray-900 leading-tight">{opp.title}</h3>
                                        <p className="text-gray-600 text-sm mt-1.5 line-clamp-2">{opp.message}</p>
                                        
                                        <div className="flex items-center gap-4 mt-4 flex-wrap">
                                            <span className="text-xs font-bold text-blue-700 bg-blue-50 px-2.5 py-1 rounded-full border border-blue-100 flex items-center gap-1.5">
                                                <Users className="h-3.5 w-3.5" />
                                                {volCount} Volunteer{volCount !== 1 ? 's' : ''} Interested
                                            </span>
                                            {opp.deadline && (
                                                <span className="text-xs font-semibold text-red-700 bg-red-50 px-2.5 py-1 rounded-full border border-red-100 flex items-center gap-1.5">
                                                    <Clock className="h-3.5 w-3.5" />
                                                    Deadline: {new Date(opp.deadline).toLocaleDateString()}
                                                </span>
                                            )}
                                        </div>
                                    </div>

                                    <div className="flex items-center gap-2 shrink-0">
                                        <button
                                            onClick={(e) => handleDeleteOpportunity(e, opp.id)}
                                            className="p-2 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                                            title="Delete Opportunity"
                                        >
                                            <Trash2 className="h-4.5 w-4.5" />
                                        </button>
                                        <div className="text-gray-400 p-1">
                                            {isExpanded ? <ChevronUp className="h-5 w-5" /> : <ChevronDown className="h-5 w-5" />}
                                        </div>
                                    </div>
                                </div>

                                {/* Expanded Interest Details */}
                                {isExpanded && (
                                    <div className="border-t border-gray-100 bg-gray-50/50 p-6 space-y-4">
                                        <div className="flex justify-between items-center pb-2 border-b border-gray-200">
                                            <h4 className="text-sm font-bold text-gray-800 uppercase tracking-wider flex items-center gap-2">
                                                <Users className="h-4.5 w-4.5 text-[#ae2b2b]" />
                                                Interested Volunteers ({volCount})
                                            </h4>
                                            {volCount > 0 && (
                                                <button
                                                    onClick={() => copyEmails(opp.interests)}
                                                    className="flex items-center gap-1 text-xs text-[#ae2b2b] hover:underline font-bold bg-white px-2.5 py-1.5 rounded-lg border border-gray-200 shadow-sm"
                                                >
                                                    <Copy className="h-3.5 w-3.5" /> Copy Email List
                                                </button>
                                            )}
                                        </div>

                                        {volCount === 0 ? (
                                            <div className="text-center py-6 text-sm text-gray-500 italic">
                                                No volunteers have expressed interest in this opportunity yet.
                                            </div>
                                        ) : (
                                            <div className="overflow-hidden rounded-xl border border-gray-200 bg-white">
                                                <table className="w-full text-left text-sm">
                                                    <thead className="bg-gray-50 text-gray-500 font-bold uppercase tracking-wider text-xs border-b border-gray-100">
                                                        <tr>
                                                            <th className="px-4 py-3">Volunteer</th>
                                                            <th className="px-4 py-3">ILJ Code</th>
                                                            <th className="px-4 py-3">Contact</th>
                                                            <th className="px-4 py-3">Expressed At</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody className="divide-y divide-gray-100">
                                                        {opp.interests.map(interest => {
                                                            const vol = interest.volunteer;
                                                            if (!vol) return null;
                                                            return (
                                                                <tr key={interest.id} className="hover:bg-gray-50/50 transition-colors">
                                                                    <td className="px-4 py-3 font-bold text-gray-900">
                                                                        {vol.first_name} {vol.last_name}
                                                                        <span className="block text-xs font-normal text-gray-500">{vol.city}</span>
                                                                    </td>
                                                                    <td className="px-4 py-3 text-gray-500 font-mono text-xs">
                                                                        {vol.ilj_id || 'N/A'}
                                                                    </td>
                                                                    <td className="px-4 py-3 space-y-0.5">
                                                                        <div className="flex items-center gap-1.5 text-xs text-gray-700">
                                                                            <Mail className="h-3.5 w-3.5 text-gray-400" />
                                                                            <a href={`mailto:${vol.email}`} className="hover:underline text-blue-600 font-medium">{vol.email}</a>
                                                                        </div>
                                                                        <div className="flex items-center gap-1.5 text-xs text-gray-700">
                                                                            <Phone className="h-3.5 w-3.5 text-gray-400" />
                                                                            <span>{vol.mobile_number}</span>
                                                                        </div>
                                                                    </td>
                                                                    <td className="px-4 py-3 text-gray-500 text-xs">
                                                                        {new Date(interest.created_at).toLocaleDateString()}
                                                                    </td>
                                                                </tr>
                                                            );
                                                        })}
                                                    </tbody>
                                                </table>
                                            </div>
                                        )}
                                    </div>
                                )}
                            </div>
                        );
                    })}
                </div>
            )}

            {/* Create Opportunity Modal */}
            {showCreateModal && (
                <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm transition-all animate-in fade-in duration-200">
                    <div className="bg-white w-full max-w-xl rounded-2xl shadow-2xl overflow-hidden flex flex-col animate-in zoom-in-95 duration-200">
                        <div className="p-6 border-b border-gray-100 flex justify-between items-center">
                            <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                                <Briefcase className="h-5 w-5 text-[#ae2b2b]" /> Post New Opportunity
                            </h2>
                            <button onClick={() => setShowCreateModal(false)} className="p-2 hover:bg-gray-100 rounded-full transition-colors">
                                <X className="h-5 w-5 text-gray-500" />
                            </button>
                        </div>

                        <form onSubmit={handleCreateOpportunity} className="flex-1 p-6 space-y-4 overflow-y-auto">
                            <div>
                                <label className="block text-sm font-semibold text-gray-700 mb-1">Opportunity Title *</label>
                                <input
                                    type="text"
                                    required
                                    placeholder="e.g. Graphic Designer for Reconnect Shibir"
                                    className="w-full p-3 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#ae2b2b] outline-none"
                                    value={newOpp.title}
                                    onChange={(e) => setNewOpp({ ...newOpp, title: e.target.value })}
                                />
                            </div>

                            <div>
                                <label className="block text-sm font-semibold text-gray-700 mb-1">Details & Requirements *</label>
                                <textarea
                                    required
                                    rows={4}
                                    placeholder="Describe the tasks, role, skills needed, and commitment levels expected..."
                                    className="w-full p-3 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#ae2b2b] outline-none resize-none"
                                    value={newOpp.message}
                                    onChange={(e) => setNewOpp({ ...newOpp, message: e.target.value })}
                                />
                            </div>

                            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                <div>
                                    <label className="block text-sm font-semibold text-gray-700 mb-1">Associated Pod (Optional)</label>
                                    <select
                                        className="w-full p-3 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#ae2b2b] outline-none bg-white"
                                        value={newOpp.project_id}
                                        onChange={(e) => setNewOpp({ ...newOpp, project_id: e.target.value })}
                                    >
                                        <option value="">General (No specific Pod)</option>
                                        {projects.map(p => (
                                            <option key={p.id} value={p.id}>{p.title}</option>
                                        ))}
                                    </select>
                                </div>

                                <div>
                                    <label className="block text-sm font-semibold text-gray-700 mb-1">Application Deadline (Optional)</label>
                                    <input
                                        type="date"
                                        className="w-full p-3 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#ae2b2b] outline-none bg-white"
                                        value={newOpp.deadline}
                                        onChange={(e) => setNewOpp({ ...newOpp, deadline: e.target.value })}
                                    />
                                </div>
                            </div>

                            <div className="pt-4 border-t border-gray-100 flex justify-end gap-3">
                                <button
                                    type="button"
                                    onClick={() => setShowCreateModal(false)}
                                    className="px-5 py-2.5 rounded-xl font-bold text-gray-700 bg-white border border-gray-200 hover:bg-gray-50 transition-colors"
                                >
                                    Cancel
                                </button>
                                <button
                                    type="submit"
                                    disabled={submitting}
                                    className="px-5 py-2.5 bg-[#ae2b2b] text-white rounded-xl font-bold hover:bg-[#8b1e1e] transition-colors disabled:opacity-50 shadow-sm"
                                >
                                    {submitting ? 'Posting...' : 'Post Opportunity'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}
        </div>
    );
}
