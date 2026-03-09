import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import { Calendar, User, Phone, MapPin, Image as ImageIcon, Loader2, ChevronDown, ChevronUp, Trash2 } from 'lucide-react';

const AdminEventRegistrations = () => {
    const [registrations, setRegistrations] = useState([]);
    const [loading, setLoading] = useState(true);
    const [expandedProjects, setExpandedProjects] = useState({});

    useEffect(() => {
        fetchRegistrations();
    }, []);

    const fetchRegistrations = async () => {
        try {
            setLoading(true);
            const { data, error } = await supabase
                .from('event_registrations')
                .select(`
                    *,
                    project:project_id (
                        title,
                        project_code
                    )
                `)
                .order('created_at', { ascending: false });

            if (error) throw error;
            setRegistrations(data || []);
        } catch (error) {
            console.error('Error fetching event registrations:', error);
        } finally {
            setLoading(false);
        }
    };

    const toggleProject = (projectId) => {
        setExpandedProjects(prev => ({
            ...prev,
            [projectId]: !prev[projectId]
        }));
    };

    const handleDelete = async (registrationId) => {
        if (!window.confirm("Are you sure you want to delete this registration? This cannot be undone.")) return;

        try {
            const { error } = await supabase
                .from('event_registrations')
                .delete()
                .eq('id', registrationId);

            if (error) throw error;

            // Remove from local state
            setRegistrations(prev => prev.filter(r => r.id !== registrationId));
        } catch (error) {
            console.error('Error deleting registration:', error);
            alert('Failed to delete registration. Please try again.');
        }
    };

    if (loading) {
        return (
            <div className="flex justify-center h-64 items-center">
                <Loader2 className="h-10 w-10 animate-spin border-[#ae2b2b] text-[#ae2b2b]" />
            </div>
        );
    }

    // Group by project_id
    const groupedRegistrations = registrations.reduce((acc, curr) => {
        const pId = curr.project_id;
        if (!acc[pId]) {
            acc[pId] = {
                project: curr.project,
                registrations: []
            };
        }
        acc[pId].registrations.push(curr);
        return acc;
    }, {});

    const groups = Object.entries(groupedRegistrations);

    return (
        <div className="space-y-6">
            <div className="flex justify-between items-end border-b border-gray-200 pb-4">
                <div>
                    <h2 className="text-2xl font-bold text-gray-900 font-serif flex items-center gap-2">
                        <Calendar className="text-[#ae2b2b] h-6 w-6" /> Event Registrations
                    </h2>
                    <p className="text-sm text-gray-500 mt-1">Review registrations for upcoming events and workshops.</p>
                </div>
            </div>

            {groups.length === 0 ? (
                <div className="text-center py-20 bg-white rounded-xl border border-dashed border-gray-300">
                    <Calendar className="h-12 w-12 text-gray-300 mx-auto mb-4" />
                    <h3 className="text-lg font-medium text-gray-900">No Registrations Found</h3>
                    <p className="text-gray-500">There are currently no event registrations.</p>
                </div>
            ) : (
                <div className="space-y-6">
                    {groups.map(([projectId, { project, registrations }]) => (
                        <div key={projectId} className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden text-sm">
                            <button
                                onClick={() => toggleProject(projectId)}
                                className="w-full flex items-center justify-between p-4 bg-gray-50 hover:bg-gray-100 transition-colors text-left"
                            >
                                <div>
                                    <h3 className="text-lg font-bold text-gray-900 group-hover:text-[#ae2b2b] transition-colors">
                                        {project?.title || 'Unknown Project'}
                                    </h3>
                                    <div className="flex gap-2 mt-1">
                                        <span className="text-xs bg-[#ae2b2b]/10 text-[#ae2b2b] px-2 py-0.5 rounded font-mono font-medium">
                                            {project?.project_code || 'N/A'}
                                        </span>
                                        <span className="text-xs bg-gray-200 text-gray-700 px-2 py-0.5 rounded font-medium">
                                            {registrations.length} Registration{registrations.length !== 1 ? 's' : ''}
                                        </span>
                                    </div>
                                </div>
                                {expandedProjects[projectId] ? (
                                    <ChevronUp className="h-5 w-5 text-gray-400" />
                                ) : (
                                    <ChevronDown className="h-5 w-5 text-gray-400" />
                                )}
                            </button>

                            {expandedProjects[projectId] && (
                                <div className="p-4 border-t border-gray-200 bg-white">
                                    <div className="overflow-x-auto">
                                        <table className="w-full text-left border-collapse">
                                            <thead>
                                                <tr className="bg-gray-50 text-gray-600 border-b border-gray-200">
                                                    <th className="p-3 font-semibold text-xs uppercase tracking-wider">Date</th>
                                                    <th className="p-3 font-semibold text-xs uppercase tracking-wider">Name & Age</th>
                                                    <th className="p-3 font-semibold text-xs uppercase tracking-wider">Contact</th>
                                                    <th className="p-3 font-semibold text-xs uppercase tracking-wider">Sangh & Address</th>
                                                    <th className="p-3 font-semibold text-xs uppercase tracking-wider">Payment Proof</th>
                                                    <th className="p-3 font-semibold text-xs uppercase tracking-wider text-right">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody className="divide-y divide-gray-100">
                                                {registrations.map((reg) => (
                                                    <tr key={reg.id} className="hover:bg-gray-50/50 transition-colors">
                                                        <td className="p-3 whitespace-nowrap text-gray-500">
                                                            {new Date(reg.created_at).toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' })}
                                                        </td>
                                                        <td className="p-3">
                                                            <div className="font-medium text-gray-900">{reg.full_name}</div>
                                                            {reg.age && <div className="text-xs text-gray-500">Age: {reg.age}</div>}
                                                        </td>
                                                        <td className="p-3">
                                                            <div className="flex items-center gap-1.5 text-gray-700">
                                                                <Phone className="h-3.5 w-3.5 text-gray-400" />
                                                                {reg.whatsapp_number}
                                                            </div>
                                                        </td>
                                                        <td className="p-3 max-w-[250px]">
                                                            {reg.sangh_name && <div className="font-medium text-gray-800 text-xs mb-1 bg-gray-100 inline-block px-1.5 py-0.5 rounded">{reg.sangh_name}</div>}
                                                            <div className="flex items-start gap-1.5 text-gray-600 text-xs mt-1">
                                                                <MapPin className="h-3.5 w-3.5 text-gray-400 shrink-0" />
                                                                <span className="line-clamp-2" title={reg.address}>{reg.address || '-'}</span>
                                                            </div>
                                                        </td>
                                                        <td className="p-3">
                                                            {reg.payment_screenshot_url ? (
                                                                <a
                                                                    href={reg.payment_screenshot_url}
                                                                    target="_blank"
                                                                    rel="noopener noreferrer"
                                                                    className="inline-flex items-center gap-1.5 px-2.5 py-1.5 bg-green-50 text-green-700 hover:bg-green-100 rounded border border-green-200 text-xs font-semibold transition-colors"
                                                                >
                                                                    <ImageIcon className="h-3.5 w-3.5" /> View Proof
                                                                </a>
                                                            ) : (
                                                                <span className="text-gray-400 text-xs italic">No Proof</span>
                                                            )}
                                                        </td>
                                                        <td className="p-3 text-right">
                                                            <button
                                                                onClick={() => handleDelete(reg.id)}
                                                                className="p-1.5 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded transition-colors"
                                                                title="Delete Registration"
                                                            >
                                                                <Trash2 className="h-4 w-4" />
                                                            </button>
                                                        </td>
                                                    </tr>
                                                ))}
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            )}
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
};

export default AdminEventRegistrations;
