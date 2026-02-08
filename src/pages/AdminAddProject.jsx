import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { supabase } from '../lib/supabase';
import {
    ArrowLeft, Search, User,
    Check, X, Briefcase, Hash, Upload, Cloud, Eye
} from 'lucide-react';

const AdminAddProject = () => {
    const navigate = useNavigate();
    const [loading, setLoading] = useState(false);
    const [authLoading, setAuthLoading] = useState(true);
    const [volunteers, setVolunteers] = useState([]);

    // Form State
    const [formData, setFormData] = useState({
        project_code: 'PRJ-',
        title: '',
        description: '',
        status: 'upcoming',
        visibility: 'public' // public or private
    });

    const [bannerFile, setBannerFile] = useState(null);
    const [bannerPreview, setBannerPreview] = useState(null);

    // Search & Selection State
    const [volunteerSearchQuery, setVolunteerSearchQuery] = useState('');
    const [selectedVolunteers, setSelectedVolunteers] = useState([]); // Array of IDs

    const [managerSearchQuery, setManagerSearchQuery] = useState('');
    const [selectedManager, setSelectedManager] = useState(null); // Single object or ID

    useEffect(() => {
        const init = async () => {
            const { data: { session } } = await supabase.auth.getSession();
            if (!session) {
                navigate('/admin');
                return;
            }
            setAuthLoading(false);
            fetchVolunteers();
        };
        init();
    }, [navigate]);

    const fetchVolunteers = async () => {
        const { data, error } = await supabase
            .from('volunteers')
            .select('id, first_name, last_name, ilj_id, email, occupation')
            .order('first_name');

        if (!error && data) {
            setVolunteers(data);
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
        setSelectedVolunteers(prev =>
            prev.includes(id)
                ? prev.filter(vid => vid !== id)
                : [...prev, id]
        );
    };

    const handleSubmit = async (e) => {
        e.preventDefault();

        if (!selectedManager) {
            alert("Please select a project manager.");
            return;
        }

        setLoading(true);

        try {
            let publicUrl = null;

            // 1. Upload Image (Only if selected)
            if (bannerFile) {
                const fileExt = bannerFile.name.split('.').pop();
                const fileName = `${Math.random()}.${fileExt}`;
                const filePath = `${fileName}`;

                const { error: uploadError } = await supabase.storage
                    .from('project-banners')
                    .upload(filePath, bannerFile);

                if (uploadError) throw uploadError;

                const { data } = supabase.storage
                    .from('project-banners')
                    .getPublicUrl(filePath);

                publicUrl = data.publicUrl;
            }

            // 2. Create Project
            const { data: projectData, error: projectError } = await supabase
                .from('projects')
                .insert([{
                    project_code: formData.project_code,
                    title: formData.title,
                    description: formData.description,
                    status: formData.status,
                    visibility: formData.visibility,
                    banner_url: publicUrl,
                    manager_id: selectedManager.id
                }])
                .select()
                .single();

            if (projectError) throw projectError;

            // 3. Link Volunteers
            if (selectedVolunteers.length > 0) {
                const linkData = selectedVolunteers.map(vid => ({
                    project_id: projectData.id,
                    volunteer_id: vid
                }));

                const { error: linkError } = await supabase
                    .from('project_volunteers')
                    .insert(linkData);

                if (linkError) throw linkError;
            }

            alert('Project created successfully!');
            navigate('/admin/dashboard');

        } catch (error) {
            console.error('Error creating project:', error);
            alert(`Failed to create project: ${error.message}`);
        } finally {
            setLoading(false);
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

    if (authLoading) {
        return (
            <div className="min-h-screen bg-gray-50 flex items-center justify-center">
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-[#ae2b2b]"></div>
            </div>
        );
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
                        <h1 className="text-xl font-bold text-gray-900">Create New Project</h1>
                    </div>
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
                                                placeholder="PRJ-001"
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
                                        </select>
                                    </div>
                                    <div>
                                        <label className="block text-sm font-medium text-gray-700 mb-1">Visibility</label>
                                        <div className="relative">
                                            <Eye className="absolute left-3 top-3 h-4 w-4 text-gray-400" />
                                            <select
                                                name="visibility"
                                                value={formData.visibility}
                                                onChange={handleInputChange}
                                                className="w-full pl-9 pr-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-amber-500 focus:outline-none bg-white"
                                            >
                                                <option value="public">Public (Visible to All)</option>
                                                <option value="private">Private (Logged-in Only)</option>
                                            </select>
                                        </div>
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
                                        placeholder="e.g. Community Clean-up"
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
                                        placeholder="Describe the project goals and requirements..."
                                        className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-amber-500 focus:outline-none resize-none"
                                    />
                                </div>

                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">Banner Image (Optional)</label>
                                    <div className="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-lg hover:bg-gray-50 transition-colors cursor-pointer relative">
                                        <div className="space-y-1 text-center">
                                            {bannerPreview ? (
                                                <div className="relative">
                                                    <img src={bannerPreview} alt="Preview" className="mx-auto h-48 object-cover rounded-md shadow-sm" />
                                                    <button
                                                        type="button"
                                                        onClick={(e) => { e.preventDefault(); setBannerFile(null); setBannerPreview(null); }}
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
                                                    <p className="text-xs text-gray-500">PNG, JPG, GIF up to 10MB</p>
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

                        {/* 2. Assign Manager Section (Search Based) */}
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
                                            {filteredVolunteersForManager.length === 0 && (
                                                <p className="p-3 text-sm text-gray-500 text-center">No matches found</p>
                                            )}
                                        </div>
                                    )}
                                </div>
                            )}
                        </div>
                    </div>

                    {/* Right Column: Add Team Members */}
                    <div className="lg:col-span-1">
                        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 h-full flex flex-col">
                            <h2 className="text-lg font-semibold text-gray-900 mb-4">Add Team Members</h2>

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
                                        // Disable selection if this person is already the manager
                                        const isManager = selectedManager?.id === volunteer.id;

                                        if (isManager) return null;

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
                                    <span className="text-sm text-gray-500">Selected:</span>
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
                                            Uploading...
                                        </>
                                    ) : (
                                        <>
                                            <Cloud className="h-4 w-4" /> Create Project
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

export default AdminAddProject;
