import { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { supabase } from '../lib/supabase';
import {
    ArrowLeft, Save, Search, User,
    Check, X, Briefcase, Image, Hash, Upload, Cloud, Trash2, CheckCircle, XCircle
} from 'lucide-react';

const AdminEditProject = () => {
    const navigate = useNavigate();
    const { id } = useParams();
    const [loading, setLoading] = useState(false);
    const [fetching, setFetching] = useState(true);
    const [volunteers, setVolunteers] = useState([]);

    // Form State
    const [formData, setFormData] = useState({
        project_code: '',
        title: '',
        description: '',
        status: 'upcoming',
        banner_url: ''
    });

    const [bannerFile, setBannerFile] = useState(null);
    const [bannerPreview, setBannerPreview] = useState(null);

    // Search & Selection State
    const [volunteerSearchQuery, setVolunteerSearchQuery] = useState('');
    const [selectedVolunteers, setSelectedVolunteers] = useState([]); // Array of IDs (Approved ones)
    const [pendingRequests, setPendingRequests] = useState([]); // Array of { volunteer_id, status }

    const [managerSearchQuery, setManagerSearchQuery] = useState('');
    const [selectedManager, setSelectedManager] = useState(null); // Single object

    useEffect(() => {
        const checkAuth = async () => {
            const { data: { session } } = await supabase.auth.getSession();
            if (!session) {
                navigate('/admin');
            }
        };
        checkAuth();

        const loadData = async () => {
            await Promise.all([fetchVolunteers(), fetchProjectDetails()]);
            setFetching(false);
        };
        loadData();
    }, [navigate, id]);

    const fetchVolunteers = async () => {
        const { data, error } = await supabase
            .from('volunteers')
            .select('id, first_name, last_name, ilj_id, email, occupation')
            .order('first_name');

        if (!error && data) {
            setVolunteers(data);
        }
    };

    const fetchProjectDetails = async () => {
        try {
            // 1. Get Project Info
            const { data: project, error } = await supabase
                .from('projects')
                .select('*')
                .eq('id', id)
                .single();

            if (error) throw error;

            setFormData({
                project_code: project.project_code,
                title: project.title,
                description: project.description || '',
                status: project.status || 'upcoming',
                banner_url: project.banner_url || ''
            });

            if (project.banner_url) {
                setBannerPreview(project.banner_url);
            }

            // 2. Get Manager (if exists)
            if (project.manager_id) {
                const { data: manager } = await supabase
                    .from('volunteers')
                    .select('*')
                    .eq('id', project.manager_id)
                    .single();
                if (manager) setSelectedManager(manager);
            }

            // 3. Get Project Volunteers (Both Approved and Pending)
            const { data: teamData, error: teamError } = await supabase
                .from('project_volunteers')
                .select('volunteer_id, status')
                .eq('project_id', id);

            if (teamError) throw teamError;

            if (teamData) {
                const approvedIds = teamData
                    .filter(t => !t.status || t.status === 'approved')
                    .map(t => t.volunteer_id);

                const pending = teamData
                    .filter(t => t.status === 'pending')
                    .map(t => t.volunteer_id);

                setSelectedVolunteers(approvedIds);
                setPendingRequests(pending);
            }

        } catch (error) {
            console.error('Error fetching project:', error);
            alert('Failed to load project details');
            navigate('/admin/dashboard');
        }
    };

    const handleInputChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
    };

    const handleFileChange = (e) => {
        const file = e.target.files[0];
        if (file) {
            setBannerFile(file);
            setBannerPreview(URL.createObjectURL(file));
        }
    };

    const toggleVolunteerSelection = (id) => {
        // Only toggle for the 'Approved' / 'Selected' list manually
        setSelectedVolunteers(prev =>
            prev.includes(id)
                ? prev.filter(vid => vid !== id)
                : [...prev, id]
        );
    };

    const handleApprove = async (volunteerId) => {
        try {
            const { error } = await supabase
                .from('project_volunteers')
                .update({ status: 'approved' })
                .eq('project_id', id)
                .eq('volunteer_id', volunteerId);

            if (error) throw error;

            // Move from pending to selected locally
            setPendingRequests(prev => prev.filter(pid => pid !== volunteerId));
            setSelectedVolunteers(prev => [...prev, volunteerId]);
            alert('Volunteer approved!');
        } catch (error) {
            console.error('Error approving:', error);
            alert('Failed to approve.');
        }
    };

    const handleReject = async (volunteerId) => {
        try {
            const { error } = await supabase
                .from('project_volunteers')
                .delete()
                .eq('project_id', id)
                .eq('volunteer_id', volunteerId);

            if (error) throw error;

            setPendingRequests(prev => prev.filter(pid => pid !== volunteerId));
            alert('Request removed.');
        } catch (error) {
            console.error('Error rejecting:', error);
            alert('Failed to delete request.');
        }
    }


    const handleSubmit = async (e) => {
        e.preventDefault();

        if (!selectedManager) {
            alert("Please select a project manager.");
            return;
        }

        setLoading(true);

        try {
            let finalBannerUrl = formData.banner_url;

            // 1. Upload New Image if selected
            if (bannerFile) {
                const fileExt = bannerFile.name.split('.').pop();
                const fileName = `${Math.random()}.${fileExt}`;
                const filePath = `${fileName}`;

                const { error: uploadError } = await supabase.storage
                    .from('project-banners')
                    .upload(filePath, bannerFile);

                if (uploadError) throw uploadError;

                const { data: { publicUrl } } = supabase.storage
                    .from('project-banners')
                    .getPublicUrl(filePath);

                finalBannerUrl = publicUrl;
            }

            // 2. Update Project
            const { error: projectError } = await supabase
                .from('projects')
                .update({
                    project_code: formData.project_code,
                    title: formData.title,
                    description: formData.description,
                    status: formData.status,
                    banner_url: finalBannerUrl,
                    manager_id: selectedManager.id
                })
                .eq('id', id);

            if (projectError) throw projectError;

            // 3. Update Volunteers
            // Strategy: 
            // - We have 'selectedVolunteers' which represents the APPROVED list.
            // - We assume 'pendingRequests' stay as they are unless acted on separately via buttons.
            // - However, submitting this form basically syncs the 'selectedVolunteers' list.
            // - So we need to be careful not to delete 'pending' requests if we do a full delete-insert cycle.
            // - BETTER APPROACH: 
            //   - Fetch current associations again.
            //   - Identify added vs removed from the 'selected' set (ignoring pending).
            //   - Or simpler: Just delete ONLY the approved ones and re-insert them. Leave 'pending' rows alone.

            // Allow simplified approach for now:
            // Delete NOT ALL, but strictly those that are NOT pending.
            // But doing `delete().eq('project_id', id).neq('status', 'pending')` is safer.

            await supabase
                .from('project_volunteers')
                .delete()
                .eq('project_id', id)
                .neq('status', 'pending');

            if (selectedVolunteers.length > 0) {
                const linkData = selectedVolunteers.map(vid => ({
                    project_id: id,
                    volunteer_id: vid,
                    status: 'approved'
                }));

                const { error: linkError } = await supabase
                    .from('project_volunteers')
                    .insert(linkData);

                if (linkError) throw linkError;
            }

            alert('Project updated successfully!');
            navigate('/admin/dashboard');

        } catch (error) {
            console.error('Error updating project:', error);
            alert(`Failed to update project: ${error.message}`);
        } finally {
            setLoading(false);
        }
    };

    const handleDelete = async () => {
        if (!window.confirm("Are you sure you want to delete this project? This cannot be undone.")) return;
        try {
            const { error } = await supabase.from('projects').delete().eq('id', id);
            if (error) throw error;
            alert('Project deleted.');
            navigate('/admin/dashboard');
        } catch (error) {
            alert('Failed to delete project');
        }
    };

    // Filter Logic
    const filteredVolunteersForTeam = volunteers.filter(v =>
        (v.first_name + ' ' + v.last_name).toLowerCase().includes(volunteerSearchQuery.toLowerCase()) ||
        v.ilj_id?.toLowerCase().includes(volunteerSearchQuery.toLowerCase())
    );

    const filteredVolunteersForManager = volunteers.filter(v =>
        (v.first_name + ' ' + v.last_name).toLowerCase().includes(managerSearchQuery.toLowerCase()) ||
        v.ilj_id?.toLowerCase().includes(managerSearchQuery.toLowerCase())
    );

    // Combine pending IDs to render them distinctly in the list if needed, 
    // or just show them in a specific section.
    // Let's show a "Pending Requests" section if there are any pending.

    if (fetching) {
        return <div className="min-h-screen flex items-center justify-center bg-gray-50">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-amber-600"></div>
        </div>;
    }

    return (
        <div className="min-h-screen bg-gray-50 pb-12 font-sans">
            {/* Header */}
            <div className="bg-white shadow-sm border-b border-gray-200 sticky top-0 z-10">
                <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
                    <div className="flex items-center gap-4">
                        <button
                            onClick={() => navigate('/admin/dashboard')}
                            className="p-2 hover:bg-gray-100 rounded-full transition-colors"
                        >
                            <ArrowLeft className="h-5 w-5 text-gray-500" />
                        </button>
                        <h1 className="text-xl font-bold text-gray-900">Edit Project</h1>
                    </div>
                    <button
                        onClick={handleDelete}
                        className="text-red-600 hover:text-red-700 hover:bg-red-50 px-3 py-2 rounded-lg flex items-center gap-2 transition-colors text-sm font-medium"
                    >
                        <Trash2 className="h-4 w-4" /> Delete Project
                    </button>
                </div>
            </div>

            <main className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                <form onSubmit={handleSubmit} className="grid grid-cols-1 lg:grid-cols-3 gap-8">

                    {/* Left Column: Project Details */}
                    <div className="lg:col-span-2 space-y-6">

                        {/* 1. Basic Info */}
                        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                            <h2 className="text-lg font-semibold text-gray-900 mb-4 flex items-center gap-2">
                                <Briefcase className="h-5 w-5 text-amber-600" /> Project Details
                            </h2>

                            <div className="space-y-4">
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div>
                                        <label className="block text-sm font-medium text-gray-700 mb-1">Project Code</label>
                                        <div className="relative">
                                            <Hash className="absolute left-3 top-3 h-4 w-4 text-gray-400" />
                                            <input
                                                type="text"
                                                name="project_code"
                                                required
                                                value={formData.project_code}
                                                onChange={handleInputChange}
                                                className="w-full pl-9 pr-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-amber-500 focus:outline-none"
                                            />
                                        </div>
                                    </div>
                                    <div>
                                        <label className="block text-sm font-medium text-gray-700 mb-1">Project Status</label>
                                        <select
                                            name="status"
                                            value={formData.status}
                                            onChange={handleInputChange}
                                            className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-amber-500 focus:outline-none bg-white"
                                        >
                                            <option value="upcoming">Upcoming</option>
                                            <option value="active">Active</option>
                                            <option value="completed">Completed</option>
                                            <option value="archived">Archived</option>
                                        </select>
                                    </div>
                                </div>

                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">Project Title</label>
                                    <input
                                        type="text"
                                        name="title"
                                        required
                                        value={formData.title}
                                        onChange={handleInputChange}
                                        className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-amber-500 focus:outline-none"
                                    />
                                </div>

                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">Description</label>
                                    <textarea
                                        name="description"
                                        rows="4"
                                        required
                                        value={formData.description}
                                        onChange={handleInputChange}
                                        className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-amber-500 focus:outline-none resize-none"
                                    />
                                </div>

                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">Update Banner Image</label>
                                    <div className="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-lg hover:bg-gray-50 transition-colors cursor-pointer relative">
                                        <div className="space-y-1 text-center">
                                            {bannerPreview ? (
                                                <div className="relative">
                                                    <img src={bannerPreview} alt="Preview" className="mx-auto h-48 object-cover rounded-md shadow-sm" />
                                                    <button
                                                        type="button"
                                                        onClick={(e) => { e.preventDefault(); setBannerFile(null); setBannerPreview(null); setFormData({ ...formData, banner_url: '' }); }}
                                                        className="absolute -top-2 -right-2 bg-red-500 text-white rounded-full p-1 shadow-md hover:bg-red-600"
                                                    >
                                                        <X className="h-4 w-4" />
                                                    </button>
                                                </div>
                                            ) : (
                                                <>
                                                    <Upload className="mx-auto h-12 w-12 text-gray-400" />
                                                    <div className="flex text-sm text-gray-600">
                                                        <label className="relative cursor-pointer bg-white rounded-md font-medium text-amber-600 hover:text-amber-500 focus-within:outline-none">
                                                            <span>Upload a file</span>
                                                            <input type="file" className="sr-only" accept="image/*" onChange={handleFileChange} />
                                                        </label>
                                                        <p className="pl-1">or drag and drop</p>
                                                    </div>
                                                </>
                                            )}
                                        </div>
                                        {!bannerPreview && (
                                            <input
                                                type="file"
                                                className="absolute inset-0 w-full h-full opacity-0 cursor-pointer"
                                                accept="image/*"
                                                onChange={handleFileChange}
                                            />
                                        )}
                                    </div>
                                </div>
                            </div>
                        </div>

                        {/* 2. Assign Manager Section */}
                        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                            <h2 className="text-lg font-semibold text-gray-900 mb-4 flex items-center gap-2">
                                <User className="h-5 w-5 text-amber-600" /> Project Manager
                            </h2>

                            {selectedManager ? (
                                <div className="flex items-center justify-between bg-amber-50 p-3 rounded-lg border border-amber-200">
                                    <div className="flex items-center gap-3">
                                        <div className="bg-amber-500 text-white w-10 h-10 rounded-full flex items-center justify-center font-bold">
                                            {selectedManager.first_name[0]}{selectedManager.last_name[0]}
                                        </div>
                                        <div>
                                            <p className="font-semibold text-gray-900">{selectedManager.first_name} {selectedManager.last_name}</p>
                                            <p className="text-xs text-amber-700">{selectedManager.ilj_id}</p>
                                        </div>
                                    </div>
                                    <button
                                        type="button"
                                        onClick={() => setSelectedManager(null)}
                                        className="p-1.5 hover:bg-white rounded-md transition-colors text-gray-500 hover:text-red-500"
                                    >
                                        <X className="h-5 w-5" />
                                    </button>
                                </div>
                            ) : (
                                <div>
                                    <div className="relative mb-2">
                                        <Search className="absolute left-3 top-2.5 h-4 w-4 text-gray-400" />
                                        <input
                                            type="text"
                                            placeholder="Search for a manager..."
                                            value={managerSearchQuery}
                                            onChange={(e) => setManagerSearchQuery(e.target.value)}
                                            className="w-full pl-9 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-amber-500 text-sm"
                                        />
                                    </div>
                                    {managerSearchQuery && (
                                        <div className="max-h-40 overflow-y-auto border border-gray-100 rounded-lg custom-scrollbar">
                                            {filteredVolunteersForManager.slice(0, 5).map(v => (
                                                <div
                                                    key={v.id}
                                                    onClick={() => { setSelectedManager(v); setManagerSearchQuery(''); }}
                                                    className="p-2.5 hover:bg-gray-50 cursor-pointer flex items-center justify-between text-sm border-b last:border-0 border-gray-50"
                                                >
                                                    <span className="font-medium text-gray-700">{v.first_name} {v.last_name}</span>
                                                    <span className="text-gray-400 text-xs">{v.ilj_id}</span>
                                                </div>
                                            ))}
                                        </div>
                                    )}
                                </div>
                            )}
                        </div>
                    </div>

                    {/* Right Column: Add Team Members */}
                    <div className="lg:col-span-1">
                        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 h-full flex flex-col">

                            {/* Pending Requests Section */}
                            {pendingRequests.length > 0 && (
                                <div className="mb-6 p-4 bg-amber-50 rounded-lg border border-amber-200">
                                    <h3 className="text-sm font-bold text-amber-800 mb-3 flex items-center gap-2">
                                        <span className="w-2 h-2 rounded-full bg-amber-500 animate-pulse"></span>
                                        Pending Requests
                                    </h3>
                                    <div className="space-y-3">
                                        {pendingRequests.map(pid => {
                                            const v = volunteers.find(i => i.id === pid);
                                            if (!v) return null;
                                            return (
                                                <div key={pid} className="bg-white p-3 rounded-md shadow-sm border border-amber-100">
                                                    <p className="text-sm font-semibold text-gray-900">{v.first_name} {v.last_name}</p>
                                                    <p className="text-xs text-gray-500 mb-2">{v.ilj_id}</p>
                                                    <div className="flex gap-2">
                                                        <button
                                                            type="button"
                                                            onClick={() => handleApprove(pid)}
                                                            className="flex-1 flex items-center justify-center gap-1 bg-green-100 text-green-700 py-1.5 rounded text-xs font-medium hover:bg-green-200 transition"
                                                        >
                                                            <CheckCircle className="h-3.5 w-3.5" /> Approve
                                                        </button>
                                                        <button
                                                            type="button"
                                                            onClick={() => handleReject(pid)}
                                                            className="flex-1 flex items-center justify-center gap-1 bg-red-100 text-red-700 py-1.5 rounded text-xs font-medium hover:bg-red-200 transition"
                                                        >
                                                            <XCircle className="h-3.5 w-3.5" /> Reject
                                                        </button>
                                                    </div>
                                                </div>
                                            );
                                        })}
                                    </div>
                                </div>
                            )}

                            <h2 className="text-lg font-semibold text-gray-900 mb-4">Manage Team</h2>

                            {/* Search */}
                            <div className="relative mb-4">
                                <Search className="absolute left-3 top-2.5 h-4 w-4 text-gray-400" />
                                <input
                                    type="text"
                                    placeholder="Search team members..."
                                    value={volunteerSearchQuery}
                                    onChange={(e) => setVolunteerSearchQuery(e.target.value)}
                                    className="w-full pl-9 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-amber-500 text-sm"
                                />
                            </div>

                            {/* List */}
                            <div className="flex-1 overflow-y-auto max-h-[500px] space-y-2 pr-1 custom-scrollbar">
                                {filteredVolunteersForTeam.length === 0 ? (
                                    <p className="text-sm text-gray-500 text-center py-4">No volunteers found</p>
                                ) : (
                                    filteredVolunteersForTeam.map(volunteer => {
                                        const isSelected = selectedVolunteers.includes(volunteer.id);
                                        const isPending = pendingRequests.includes(volunteer.id);
                                        const isManager = selectedManager?.id === volunteer.id;

                                        if (isManager || isPending) return null; // Don't show pending in the main selection list to avoid duplicate rendering/logic

                                        return (
                                            <div
                                                key={volunteer.id}
                                                onClick={() => toggleVolunteerSelection(volunteer.id)}
                                                className={`
                                                    cursor-pointer p-3 rounded-lg border transition-all flex items-center justify-between group
                                                    ${isSelected ? 'bg-amber-50 border-amber-500' : 'bg-gray-50 border-gray-100 hover:border-amber-300'}
                                                `}
                                            >
                                                <div className="min-w-0">
                                                    <p className={`text-sm font-medium truncate ${isSelected ? 'text-amber-900' : 'text-gray-900'}`}>
                                                        {volunteer.first_name} {volunteer.last_name}
                                                    </p>
                                                    <p className="text-xs text-gray-500 truncate">{volunteer.ilj_id}</p>
                                                </div>
                                                <div className={`
                                                    w-5 h-5 rounded overflow-hidden flex items-center justify-center border
                                                    ${isSelected ? 'bg-amber-500 border-amber-500 text-white' : 'bg-white border-gray-300'}
                                                `}>
                                                    {isSelected && <Check className="h-3 w-3" />}
                                                </div>
                                            </div>
                                        );
                                    })
                                )}
                            </div>

                            {/* Summary Footer */}
                            <div className="mt-4 pt-4 border-t border-gray-100">
                                <div className="flex justify-between items-center mb-4">
                                    <span className="text-sm text-gray-500">Selected (Approved):</span>
                                    <span className="font-bold text-amber-600">{selectedVolunteers.length}</span>
                                </div>
                                <button
                                    type="submit"
                                    disabled={loading}
                                    className="w-full py-2.5 bg-amber-600 hover:bg-amber-700 text-white font-semibold rounded-lg shadow-md transition-all flex items-center justify-center gap-2 disabled:opacity-70 disabled:cursor-not-allowed"
                                >
                                    {loading ? (
                                        <>
                                            <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div>
                                            Updating...
                                        </>
                                    ) : (
                                        <>
                                            <Save className="h-4 w-4" /> Save Changes
                                        </>
                                    )}
                                </button>
                            </div>
                        </div>
                    </div>

                </form>
            </main>
        </div>
    );
};

export default AdminEditProject;
