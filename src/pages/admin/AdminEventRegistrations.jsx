import React, { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import { Calendar, User, Phone, MapPin, Image as ImageIcon, Loader2, ChevronDown, ChevronUp, Trash2, Eye, X } from 'lucide-react';

const AdminEventRegistrations = () => {
    const [registrations, setRegistrations] = useState([]);
    const [selectedReg, setSelectedReg] = useState(null);
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
            // Find the registration to get the URLs for storage deletion
            const reg = registrations.find(r => r.id === registrationId);
            if (reg) {
                const filesToRemove = [];
                const extractPath = (url) => {
                    if (!url) return null;
                    try {
                        const parts = url.split('/project-gallery/');
                        if (parts.length > 1) {
                            // In case of query parameters in URL, remove them
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
                        // We continue with DB deletion even if storage deletion fails
                    }
                }
            }

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
                                                    <tr 
                                                        key={reg.id} 
                                                        className="hover:bg-blue-50/50 transition-colors cursor-pointer"
                                                        onClick={() => setSelectedReg(reg)}
                                                    >
                                                        <td className="p-3 whitespace-nowrap text-gray-500">
                                                            {new Date(reg.created_at).toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' })}
                                                        </td>
                                                        <td className="p-3">
                                                            <div className="font-medium text-gray-900 flex items-center gap-2">
                                                                {reg.full_name}
                                                                {reg.supported_file_url && (
                                                                    <span className="text-[10px] bg-blue-100 text-blue-800 px-1.5 py-0.5 rounded font-mono font-bold">
                                                                        {reg.supported_file_url}
                                                                    </span>
                                                                )}
                                                            </div>
                                                            {reg.age && <div className="text-xs text-gray-500">Age: {reg.age}</div>}
                                                            {reg.dob && <div className="text-xs text-gray-500">DOB: {reg.dob}</div>}
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
                                                                    onClick={(e) => e.stopPropagation()}
                                                                >
                                                                    <ImageIcon className="h-3.5 w-3.5" /> View Proof
                                                                </a>
                                                            ) : (
                                                                <span className="text-gray-400 text-xs italic">No Proof</span>
                                                            )}
                                                        </td>
                                                        <td className="p-3 text-right">
                                                            <button
                                                                onClick={(e) => {
                                                                    e.stopPropagation();
                                                                    handleDelete(reg.id);
                                                                }}
                                                                className="inline-flex items-center gap-1.5 p-1.5 px-3 text-red-600 bg-red-50 hover:bg-red-100 rounded text-xs font-semibold transition-colors"
                                                                title="Delete Registration"
                                                            >
                                                                <Trash2 className="h-4 w-4" /> Delete
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

            {/* Registration Details Modal */}
            {selectedReg && (
                <div className="fixed inset-0 z-[9999] flex items-center justify-center bg-black/60 p-4 backdrop-blur-sm">
                    <div className="bg-white rounded-2xl w-full max-w-2xl max-h-[90vh] overflow-y-auto shadow-2xl transform transition-all">
                        <div className="sticky top-0 bg-white border-b border-gray-100 px-6 py-4 flex justify-between items-center z-10 shadow-sm">
                            <h3 className="text-xl font-bold text-gray-900 font-serif">Registration Details</h3>
                            <button
                                onClick={() => setSelectedReg(null)}
                                className="text-gray-400 hover:text-red-600 hover:bg-red-50 p-2 rounded-full transition-colors focus:outline-none"
                            >
                                <X className="h-6 w-6" />
                            </button>
                        </div>
                        <div className="p-6 space-y-6">
                            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                {selectedReg.supported_file_url && (
                                    <div className="md:col-span-2 bg-blue-50/50 p-3 rounded-lg border border-blue-100 mb-2">
                                        <p className="text-xs font-semibold text-blue-700 uppercase tracking-wider mb-0.5">Registration ID</p>
                                        <p className="font-bold text-blue-900 text-lg font-mono">{selectedReg.supported_file_url}</p>
                                    </div>
                                )}
                                <div>
                                    <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Full Name</p>
                                    <p className="font-medium text-gray-900 text-lg">{selectedReg.full_name}</p>
                                </div>
                                {selectedReg.email && (
                                    <div>
                                        <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Email</p>
                                        <p className="font-medium text-gray-900">{selectedReg.email}</p>
                                    </div>
                                )}
                                <div>
                                    <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">WhatsApp Number</p>
                                    <p className="font-medium text-gray-900">{selectedReg.whatsapp_number}</p>
                                </div>
                                {selectedReg.mobile_number && (
                                    <div>
                                        <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Mobile Number</p>
                                        <p className="font-medium text-gray-900">{selectedReg.mobile_number}</p>
                                    </div>
                                )}
                                {selectedReg.age && (
                                    <div>
                                        <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Age</p>
                                        <p className="font-medium text-gray-900">{selectedReg.age}</p>
                                    </div>
                                )}
                                {selectedReg.dob && (
                                    <div>
                                        <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Date of Birth</p>
                                        <p className="font-medium text-gray-900">{selectedReg.dob}</p>
                                    </div>
                                )}
                                {selectedReg.sangh_name && (
                                    <div className="md:col-span-2">
                                        <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Sangh Name</p>
                                        <p className="font-medium text-gray-900">{selectedReg.sangh_name}</p>
                                    </div>
                                )}
                                {selectedReg.address && (
                                    <div className="md:col-span-2">
                                        <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Address</p>
                                        <p className="font-medium text-gray-900">{selectedReg.address}</p>
                                    </div>
                                )}
                            </div>

                            {/* Extra specific details */}
                            {selectedReg.project?.project_code === 'PRJ-008-02' ? (
                                <div className="border-t border-gray-100 pt-6">
                                    <h4 className="text-sm font-bold text-gray-800 mb-4 bg-gray-50 p-2 rounded inline-block font-serif">Additional Details (Reflect)</h4>
                                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                        {selectedReg.education_details && (
                                            <div className="md:col-span-2">
                                                <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Professional Education</p>
                                                <p className="font-medium text-gray-900">{selectedReg.education_details}</p>
                                            </div>
                                        )}
                                        {selectedReg.hobbies && (
                                            <div className="md:col-span-2">
                                                <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Instagram ID</p>
                                                <p className="font-medium text-gray-900">{selectedReg.hobbies}</p>
                                            </div>
                                        )}
                                        {selectedReg.fathers_name && (
                                            <div className="md:col-span-2">
                                                <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Booked Sessions</p>
                                                <p className="font-medium text-gray-900">{selectedReg.fathers_name}</p>
                                            </div>
                                        )}
                                    </div>
                                </div>
                            ) : (
                                (selectedReg.fathers_name || selectedReg.emergency_contact_name || selectedReg.is_vihar_sevika !== null || selectedReg.mothers_name || selectedReg.contact_no_3 || selectedReg.education_details || selectedReg.dharmik_education || selectedReg.hobbies || selectedReg.medical_information) && (
                                    <div className="border-t border-gray-100 pt-6">
                                        <h4 className="text-sm font-bold text-gray-800 mb-4 bg-gray-50 p-2 rounded inline-block font-serif">Additional Details</h4>
                                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                            {selectedReg.is_vihar_sevika !== null && selectedReg.is_vihar_sevika !== undefined && (
                                                <div>
                                                    <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Active Vihar Sevika?</p>
                                                    <p className="font-medium text-gray-900">{selectedReg.is_vihar_sevika ? 'Yes' : 'No'}</p>
                                                </div>
                                            )}
                                            {selectedReg.fathers_name && (
                                                <div>
                                                    <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Father's Name</p>
                                                    <p className="font-medium text-gray-900">{selectedReg.fathers_name}</p>
                                                </div>
                                            )}
                                            {selectedReg.emergency_contact_name && (
                                                <div>
                                                    <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Emergency Contact</p>
                                                    <p className="font-medium text-gray-900">
                                                        {selectedReg.emergency_contact_name} ({selectedReg.emergency_contact_relation})
                                                    </p>
                                                    <p className="text-sm text-gray-600 mt-0.5">{selectedReg.emergency_contact_number}</p>
                                                </div>
                                            )}
                                            {selectedReg.payment_date && (
                                                <div>
                                                    <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Payment Date</p>
                                                    <p className="font-medium text-gray-900">{selectedReg.payment_date}</p>
                                                </div>
                                            )}
                                            {selectedReg.vihar_seva_head_name && (
                                                <div>
                                                    <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Vihar Seva Head Name</p>
                                                    <p className="font-medium text-gray-900">{selectedReg.vihar_seva_head_name}</p>
                                                </div>
                                            )}
                                            {selectedReg.vihar_seva_head_contact && (
                                                <div>
                                                    <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Vihar Seva Head Contact</p>
                                                    <p className="font-medium text-gray-900">{selectedReg.vihar_seva_head_contact}</p>
                                                </div>
                                            )}
                                            {selectedReg.mothers_name && (
                                                <div>
                                                    <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Mother's Name</p>
                                                    <p className="font-medium text-gray-900">{selectedReg.mothers_name}</p>
                                                </div>
                                            )}
                                            {selectedReg.contact_no_3 && (
                                                <div>
                                                    <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Contact No. 3</p>
                                                    <p className="font-medium text-gray-900">{selectedReg.contact_no_3}</p>
                                                </div>
                                            )}
                                            {selectedReg.education_details && (
                                                <div className="md:col-span-2">
                                                    <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Education</p>
                                                    <p className="font-medium text-gray-900">{selectedReg.education_details}</p>
                                                </div>
                                            )}
                                            {selectedReg.dharmik_education && (
                                                <div className="md:col-span-2">
                                                    <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Dharmik Education</p>
                                                    <p className="font-medium text-gray-900">{selectedReg.dharmik_education}</p>
                                                </div>
                                            )}
                                            {selectedReg.hobbies && (
                                                <div className="md:col-span-2">
                                                    <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Hobbies</p>
                                                    <p className="font-medium text-gray-900">{selectedReg.hobbies}</p>
                                                </div>
                                            )}
                                            {selectedReg.medical_information && (
                                                <div className="md:col-span-2">
                                                    <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Medical Condition</p>
                                                    <p className="font-medium text-gray-900">{selectedReg.medical_information}</p>
                                                </div>
                                            )}
                                        </div>
                                    </div>
                                )
                            )}

                            {/* Documents Section */}
                            {(selectedReg.payment_screenshot_url || selectedReg.photograph_url) && (
                                <div className="border-t border-gray-100 pt-6">
                                    <h4 className="text-sm font-bold text-gray-800 mb-4 bg-gray-50 p-2 rounded inline-block">Documents & Proofs</h4>
                                    <div className="flex flex-wrap gap-3">
                                        {selectedReg.payment_screenshot_url && (
                                            <a
                                                href={selectedReg.payment_screenshot_url}
                                                target="_blank"
                                                rel="noopener noreferrer"
                                                className="inline-flex items-center gap-2 px-4 py-3 bg-green-50 text-green-700 hover:bg-green-100 rounded-lg border border-green-200 text-sm font-bold transition-all hover:shadow-md"
                                            >
                                                <ImageIcon className="h-5 w-5" /> View Payment Proof
                                            </a>
                                        )}
                                        {selectedReg.photograph_url && (
                                            <a
                                                href={selectedReg.photograph_url}
                                                target="_blank"
                                                rel="noopener noreferrer"
                                                className="inline-flex items-center gap-2 px-4 py-3 bg-blue-50 text-blue-700 hover:bg-blue-100 rounded-lg border border-blue-200 text-sm font-bold transition-all hover:shadow-md"
                                            >
                                                <ImageIcon className="h-5 w-5" /> View Photograph
                                            </a>
                                        )}
                                    </div>
                                </div>
                            )}
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
};

export default AdminEventRegistrations;
