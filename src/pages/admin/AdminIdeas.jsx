import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import {
    Lightbulb, Search, Filter, CheckCircle, Clock, XCircle,
    Rocket, Eye, MessageSquare, User, Briefcase, ChevronDown
} from 'lucide-react';

const STATUS_CONFIG = {
    pending: { label: 'Pending', color: 'bg-amber-100 text-amber-700 border-amber-200', icon: Clock },
    reviewed: { label: 'Reviewed', color: 'bg-blue-100 text-blue-700 border-blue-200', icon: Eye },
    approved: { label: 'Approved', color: 'bg-green-100 text-green-700 border-green-200', icon: CheckCircle },
    implemented: { label: 'Implemented', color: 'bg-purple-100 text-purple-700 border-purple-200', icon: Rocket },
    rejected: { label: 'Rejected', color: 'bg-red-100 text-red-700 border-red-200', icon: XCircle }
};

export default function AdminIdeas() {
    const [ideas, setIdeas] = useState([]);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');
    const [statusFilter, setStatusFilter] = useState('all');
    const [expandedIdea, setExpandedIdea] = useState(null);
    const [adminNotes, setAdminNotes] = useState('');

    useEffect(() => {
        fetchIdeas();
    }, []);

    const fetchIdeas = async () => {
        try {
            setLoading(true);
            const { data, error } = await supabase
                .from('ideas')
                .select(`
                    *,
                    volunteer:volunteers(first_name, last_name, ilj_id, designation, secondary_designation),
                    project:projects(title)
                `)
                .order('created_at', { ascending: false });

            if (error) throw error;
            setIdeas(data || []);
        } catch (err) {
            console.error('Error fetching ideas:', err);
        } finally {
            setLoading(false);
        }
    };

    const handleStatusChange = async (ideaId, newStatus) => {
        try {
            const { error } = await supabase
                .from('ideas')
                .update({ status: newStatus, updated_at: new Date().toISOString() })
                .eq('id', ideaId);

            if (error) throw error;
            setIdeas(prev => prev.map(idea =>
                idea.id === ideaId ? { ...idea, status: newStatus, updated_at: new Date().toISOString() } : idea
            ));
        } catch (err) {
            alert(`Error: ${err.message}`);
        }
    };

    const handleSaveNotes = async (ideaId) => {
        try {
            const { error } = await supabase
                .from('ideas')
                .update({ admin_notes: adminNotes, updated_at: new Date().toISOString() })
                .eq('id', ideaId);

            if (error) throw error;
            setIdeas(prev => prev.map(idea =>
                idea.id === ideaId ? { ...idea, admin_notes: adminNotes, updated_at: new Date().toISOString() } : idea
            ));
            alert('Notes saved!');
        } catch (err) {
            alert(`Error: ${err.message}`);
        }
    };

    const filteredIdeas = ideas.filter(idea => {
        const matchesSearch = searchTerm === '' ||
            idea.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
            idea.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
            `${idea.volunteer?.first_name} ${idea.volunteer?.last_name}`.toLowerCase().includes(searchTerm.toLowerCase());

        const matchesStatus = statusFilter === 'all' || idea.status === statusFilter;

        return matchesSearch && matchesStatus;
    });

    const statusCounts = ideas.reduce((acc, idea) => {
        acc[idea.status] = (acc[idea.status] || 0) + 1;
        return acc;
    }, {});

    if (loading) {
        return (
            <div className="flex justify-center items-center h-64">
                <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-[#ae2b2b]"></div>
            </div>
        );
    }

    return (
        <div className="space-y-6">
            {/* Header Stats */}
            <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-3">
                {Object.entries(STATUS_CONFIG).map(([key, config]) => {
                    const Icon = config.icon;
                    return (
                        <button
                            key={key}
                            onClick={() => setStatusFilter(statusFilter === key ? 'all' : key)}
                            className={`p-3 rounded-xl border transition-all text-left ${statusFilter === key
                                ? 'ring-2 ring-[#ae2b2b] border-[#ae2b2b]/30 shadow-md'
                                : 'border-gray-200 hover:border-gray-300'
                                }`}
                        >
                            <div className="flex items-center gap-2 mb-1">
                                <Icon className="h-4 w-4 text-gray-500" />
                                <span className="text-xs font-bold text-gray-500 uppercase tracking-wider">{config.label}</span>
                            </div>
                            <p className="text-2xl font-bold text-gray-900">{statusCounts[key] || 0}</p>
                        </button>
                    );
                })}
            </div>

            {/* Search */}
            <div className="relative">
                <Search className="absolute left-3 top-3 h-5 w-5 text-gray-400" />
                <input
                    type="text"
                    placeholder="Search ideas by title, description, or volunteer name..."
                    className="w-full pl-10 pr-4 py-3 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-[#ae2b2b] focus:border-transparent outline-none"
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                />
            </div>

            {/* Ideas List */}
            {filteredIdeas.length === 0 ? (
                <div className="text-center py-16 bg-white rounded-xl border border-dashed border-gray-200">
                    <Lightbulb className="h-12 w-12 text-gray-300 mx-auto mb-4" />
                    <h3 className="text-lg font-medium text-gray-900">No Ideas Found</h3>
                    <p className="text-gray-500 mt-1">
                        {ideas.length === 0 ? 'No ideas have been submitted yet.' : 'No ideas match your current filters.'}
                    </p>
                </div>
            ) : (
                <div className="space-y-4">
                    {filteredIdeas.map(idea => {
                        const statusConf = STATUS_CONFIG[idea.status] || STATUS_CONFIG.pending;
                        const StatusIcon = statusConf.icon;
                        const isExpanded = expandedIdea === idea.id;

                        return (
                            <div
                                key={idea.id}
                                className="bg-white rounded-xl border border-gray-200 shadow-sm hover:shadow-md transition-all overflow-hidden"
                            >
                                {/* Idea Header */}
                                <div
                                    className="p-5 cursor-pointer"
                                    onClick={() => {
                                        if (isExpanded) {
                                            setExpandedIdea(null);
                                        } else {
                                            setExpandedIdea(idea.id);
                                            setAdminNotes(idea.admin_notes || '');
                                        }
                                    }}
                                >
                                    <div className="flex flex-col sm:flex-row sm:items-start justify-between gap-3">
                                        <div className="flex-1 min-w-0">
                                            <div className="flex items-center gap-3 mb-2 flex-wrap">
                                                <div className="p-1.5 bg-amber-50 rounded-lg">
                                                    <Lightbulb className="h-5 w-5 text-amber-500" />
                                                </div>
                                                <h3 className="text-lg font-bold text-gray-900">{idea.title}</h3>
                                                <span className={`inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-bold uppercase tracking-wider border ${statusConf.color}`}>
                                                    <StatusIcon className="h-3 w-3" />
                                                    {statusConf.label}
                                                </span>
                                            </div>

                                            <p className="text-gray-600 text-sm line-clamp-2">{idea.description}</p>

                                            <div className="flex items-center gap-4 mt-3 flex-wrap">
                                                <div className="flex items-center gap-1.5 text-xs text-gray-500">
                                                    <User className="h-3.5 w-3.5" />
                                                    <span className="font-medium text-gray-700">
                                                        {idea.volunteer?.first_name} {idea.volunteer?.last_name}
                                                    </span>
                                                    <span className="text-gray-400">({idea.volunteer?.ilj_id})</span>
                                                </div>
                                                {idea.project && (
                                                    <div className="flex items-center gap-1.5 text-xs text-blue-600">
                                                        <Briefcase className="h-3.5 w-3.5" />
                                                        <span className="font-medium">{idea.project.title}</span>
                                                    </div>
                                                )}
                                                <span className="text-xs text-gray-400">
                                                    {new Date(idea.created_at).toLocaleDateString('en-IN', {
                                                        day: 'numeric', month: 'short', year: 'numeric'
                                                    })}
                                                </span>
                                            </div>
                                        </div>

                                        <ChevronDown className={`h-5 w-5 text-gray-400 transition-transform shrink-0 ${isExpanded ? 'rotate-180' : ''}`} />
                                    </div>
                                </div>

                                {/* Expanded Details */}
                                {isExpanded && (
                                    <div className="border-t border-gray-100 p-5 bg-gray-50/50 space-y-5 animate-in fade-in slide-in-from-top-2 duration-200">
                                        {/* Full Description */}
                                        <div>
                                            <h4 className="text-xs font-bold text-gray-500 uppercase tracking-widest mb-2">Full Description</h4>
                                            <p className="text-gray-700 text-sm leading-relaxed whitespace-pre-wrap bg-white p-4 rounded-lg border border-gray-200">
                                                {idea.description}
                                            </p>
                                        </div>

                                        {/* Status Update */}
                                        <div>
                                            <h4 className="text-xs font-bold text-gray-500 uppercase tracking-widest mb-2">Update Status</h4>
                                            <div className="flex flex-wrap gap-2">
                                                {Object.entries(STATUS_CONFIG).map(([key, config]) => {
                                                    const BtnIcon = config.icon;
                                                    return (
                                                        <button
                                                            key={key}
                                                            onClick={() => handleStatusChange(idea.id, key)}
                                                            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-bold uppercase tracking-wider border transition-all ${idea.status === key
                                                                ? `${config.color} ring-2 ring-offset-1 ring-gray-300`
                                                                : 'bg-white border-gray-200 text-gray-500 hover:border-gray-400'
                                                                }`}
                                                        >
                                                            <BtnIcon className="h-3.5 w-3.5" />
                                                            {config.label}
                                                        </button>
                                                    );
                                                })}
                                            </div>
                                        </div>

                                        {/* Admin Notes */}
                                        <div>
                                            <h4 className="text-xs font-bold text-gray-500 uppercase tracking-widest mb-2 flex items-center gap-1.5">
                                                <MessageSquare className="h-3.5 w-3.5" /> Admin Notes
                                            </h4>
                                            <div className="flex gap-2">
                                                <textarea
                                                    className="flex-1 p-3 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-[#ae2b2b] outline-none resize-none bg-white"
                                                    rows={3}
                                                    placeholder="Add internal notes about this idea..."
                                                    value={adminNotes}
                                                    onChange={(e) => setAdminNotes(e.target.value)}
                                                />
                                                <button
                                                    onClick={() => handleSaveNotes(idea.id)}
                                                    className="self-end px-4 py-2 bg-[#ae2b2b] text-white rounded-lg text-sm font-bold hover:bg-[#8b1e1e] transition-colors shadow-sm"
                                                >
                                                    Save
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                )}
                            </div>
                        );
                    })}
                </div>
            )}
        </div>
    );
}
