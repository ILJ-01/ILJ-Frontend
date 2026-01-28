import { useState, useEffect, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import { supabase } from '../lib/supabase';
import {
    Search, Filter, LogOut, MapPin, Mail, Phone,
    X, User, Briefcase, Heart, BookOpen, Plus, LayoutGrid, Users
} from 'lucide-react';

const AdminDashboard = () => {
    const navigate = useNavigate();
    const [activeTab, setActiveTab] = useState('volunteers'); // 'volunteers' or 'projects'

    // Volunteers State
    const [volunteers, setVolunteers] = useState([]);
    const [loadingVolunteers, setLoadingVolunteers] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');
    const [showFilters, setShowFilters] = useState(false);
    const [selectedVolunteer, setSelectedVolunteer] = useState(null);
    const [filters, setFilters] = useState({ district: '', skills: '', volunteering_preference1: '' });
    const [options, setOptions] = useState({ districts: [], preferences: [], skills: [] });

    // Projects State
    const [projects, setProjects] = useState([]);
    const [loadingProjects, setLoadingProjects] = useState(true);

    useEffect(() => {
        const checkAuth = () => {
            const isAuth = sessionStorage.getItem('adminAuth');
            if (!isAuth) navigate('/admin');
        };
        checkAuth();
        fetchVolunteers();
        fetchProjects();
    }, [navigate]);

    const fetchVolunteers = async () => {
        try {
            setLoadingVolunteers(true);
            const { data, error } = await supabase
                .from('volunteers')
                .select('*')
                .order('created_at', { ascending: false });

            if (error) throw error;

            setVolunteers(data || []);

            const districts = [...new Set(data.map(v => v.district).filter(Boolean).map(d => d.trim()))].sort();
            const preferences = [...new Set(data.map(v => v.volunteering_preference1).filter(Boolean))].sort();
            const allSkills = data.map(v => v.skills).filter(Boolean).flatMap(skillStr => skillStr.split(',').map(s => s.trim()));
            const uniqueSkills = [...new Set(allSkills)].sort();

            setOptions({ districts, preferences, skills: uniqueSkills });
        } catch (error) {
            console.error('Error fetching volunteers:', error);
        } finally {
            setLoadingVolunteers(false);
        }
    };

    const fetchProjects = async () => {
        try {
            setLoadingProjects(true);
            // Fetch projects with manager details
            // Note: Supabase JS client handles many-to-one strictly if FK is correct.
            // If manager_id is FK to volunteers(id), we can join.
            // Also getting volunteer count via a separate query/approach or post-process for now to be safe, 
            // or we use supabase's count capability if `project_volunteers` is linked.

            const { data, error } = await supabase
                .from('projects')
                .select(`
                    *,
                    manager:manager_id ( id, first_name, last_name, ilj_id )
                `)
                .order('created_at', { ascending: false });

            if (error) throw error;
            setProjects(data || []);

        } catch (error) {
            console.error('Error fetching projects:', error);
        } finally {
            setLoadingProjects(false);
        }
    };

    const handleLogout = () => {
        sessionStorage.removeItem('adminAuth');
        navigate('/admin');
    };

    // --- Search & Filter Logic (Volunteers) ---
    const filteredVolunteers = useMemo(() => {
        return volunteers.filter(volunteer => {
            const searchLower = searchTerm.toLowerCase();
            const matchesSearch = searchTerm === '' || Object.values(volunteer).some(val =>
                String(val || '').toLowerCase().includes(searchLower)
            );
            const matchesDistrict = !filters.district || (volunteer.district || '').includes(filters.district);
            const matchesPreference = !filters.volunteering_preference1 || volunteer.volunteering_preference1 === filters.volunteering_preference1;
            const matchesSkill = !filters.skills || (volunteer.skills || '').toLowerCase().includes(filters.skills.toLowerCase());
            return matchesSearch && matchesDistrict && matchesSkill && matchesPreference;
        });
    }, [volunteers, searchTerm, filters]);

    const clearFilters = () => {
        setFilters({ district: '', skills: '', volunteering_preference1: '' });
        setSearchTerm('');
    };

    const formatDate = (dateString) => {
        if (!dateString) return 'N/A';
        return new Date(dateString).toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' });
    };

    return (
        <div className="min-h-screen bg-gray-50 font-sans pb-12">
            {/* Top Navigation */}
            <nav className="bg-white shadow-sm border-b border-gray-200 sticky top-0 z-20">
                <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <div className="flex justify-between h-16 items-center">
                        <div className="flex items-center gap-3">
                            <div className="bg-amber-100 p-2 rounded-lg">
                                <User className="h-6 w-6 text-amber-600" />
                            </div>
                            <span className="font-bold text-xl text-gray-800">Admin<span className="text-amber-600">Portal</span></span>
                        </div>
                        <button onClick={handleLogout} className="flex items-center gap-2 text-gray-600 hover:text-red-600 transition-colors px-3 py-2 rounded-md hover:bg-gray-50">
                            <LogOut className="h-5 w-5" />
                            <span className="hidden sm:inline">Logout</span>
                        </button>
                    </div>
                </div>
            </nav>

            <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

                {/* Dashboard Tabs & Actions */}
                <div className="mb-8 flex flex-col md:flex-row md:items-center justify-between gap-4">
                    <div>
                        <h1 className="text-2xl font-bold text-gray-900">Dashboard</h1>
                        <p className="text-gray-500 mt-1">Manage your team and projects effectively.</p>
                    </div>

                    <div className="flex items-center gap-4">
                        {/* Tab Switcher */}
                        <div className="bg-gray-200 p-1 rounded-lg flex items-center">
                            <button
                                onClick={() => setActiveTab('volunteers')}
                                className={`flex items-center gap-2 px-4 py-2 rounded-md font-medium text-sm transition-all ${activeTab === 'volunteers' ? 'bg-white text-amber-700 shadow-sm' : 'text-gray-600 hover:text-gray-900'}`}
                            >
                                <Users className="h-4 w-4" /> Volunteers
                            </button>
                            <button
                                onClick={() => setActiveTab('projects')}
                                className={`flex items-center gap-2 px-4 py-2 rounded-md font-medium text-sm transition-all ${activeTab === 'projects' ? 'bg-white text-amber-700 shadow-sm' : 'text-gray-600 hover:text-gray-900'}`}
                            >
                                <LayoutGrid className="h-4 w-4" /> Projects
                            </button>
                        </div>

                        {/* Action Button */}
                        {activeTab === 'projects' && (
                            <button
                                onClick={() => navigate('/admin/add-project')}
                                className="flex items-center gap-2 bg-amber-600 text-white px-5 py-2.5 rounded-lg hover:bg-amber-700 transition-all shadow-md font-semibold text-sm"
                            >
                                <Plus className="h-5 w-5" />
                                Add Project
                            </button>
                        )}
                    </div>
                </div>

                {/* --- TAB CONTENT: VOLUNTEERS --- */}
                {activeTab === 'volunteers' && (
                    <>
                        {/* Search & Filter Controls */}
                        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-4 mb-6">
                            <div className="flex flex-col md:flex-row gap-4">
                                <div className="flex-1 relative">
                                    <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" />
                                    <input
                                        type="text"
                                        placeholder="Search ANY field..."
                                        className="w-full pl-10 pr-4 py-2.5 bg-gray-50 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-amber-500 focus:bg-white transition-all"
                                        value={searchTerm}
                                        onChange={(e) => setSearchTerm(e.target.value)}
                                    />
                                </div>
                                <button onClick={() => setShowFilters(!showFilters)} className="md:hidden flex items-center justify-center gap-2 bg-gray-100 px-4 py-2 rounded-lg">
                                    <Filter className="h-5 w-5" /> Filters
                                </button>
                            </div>

                            <div className={`mt-4 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 ${showFilters ? 'block' : 'hidden md:grid'}`}>
                                <select
                                    className="w-full p-2.5 bg-gray-50 border border-gray-200 rounded-lg text-sm"
                                    value={filters.district} onChange={(e) => setFilters({ ...filters, district: e.target.value })}
                                >
                                    <option value="">All Districts</option>
                                    {options.districts.map(d => <option key={d} value={d}>{d}</option>)}
                                </select>

                                <select
                                    className="w-full p-2.5 bg-gray-50 border border-gray-200 rounded-lg text-sm"
                                    value={filters.volunteering_preference1} onChange={(e) => setFilters({ ...filters, volunteering_preference1: e.target.value })}
                                >
                                    <option value="">All Preferences</option>
                                    {options.preferences.map(p => <option key={p} value={p}>{p}</option>)}
                                </select>

                                <select
                                    className="w-full p-2.5 bg-gray-50 border border-gray-200 rounded-lg text-sm"
                                    value={filters.skills} onChange={(e) => setFilters({ ...filters, skills: e.target.value })}
                                >
                                    <option value="">All Skills</option>
                                    {options.skills.map(s => <option key={s} value={s}>{s}</option>)}
                                </select>

                                <button onClick={clearFilters} className={`text-sm text-red-600 sm:col-span-2 lg:col-span-3 justify-self-end mt-2 hover:underline ${!Object.values(filters).some(Boolean) && !searchTerm ? 'invisible' : 'visible'}`}>
                                    Clear Filters
                                </button>
                            </div>
                        </div>

                        {/* Validated Stats */}
                        <div className="mb-4">
                            <p className="text-gray-500">Showing <span className="font-semibold text-gray-900">{filteredVolunteers.length}</span> volunteers</p>
                        </div>

                        {/* List Area */}
                        {loadingVolunteers ? (
                            <div className="flex justify-center h-64 items-center"><div className="animate-spin rounded-full h-10 w-10 border-b-2 border-amber-600"></div></div>
                        ) : (
                            <div className="grid grid-cols-1 gap-4">
                                {filteredVolunteers.length === 0 ? (
                                    <div className="text-center py-12 bg-white rounded-lg border border-gray-200">
                                        <p className="text-gray-500">No volunteers found matching your criteria.</p>
                                    </div>
                                ) : (
                                    filteredVolunteers.map((volunteer) => (
                                        <div
                                            key={volunteer.id}
                                            onClick={() => setSelectedVolunteer(volunteer)}
                                            className="bg-white rounded-xl shadow-sm border border-gray-200 hover:border-amber-400 hover:shadow-md transition-all p-5 cursor-pointer group"
                                        >
                                            <div className="flex flex-col md:flex-row justify-between gap-4 md:items-center">
                                                <div className="flex items-start gap-4">
                                                    <div className="bg-gray-100 w-12 h-12 rounded-full flex items-center justify-center text-amber-700 font-bold text-lg border border-gray-200 shrink-0 group-hover:bg-amber-100 transition-colors">
                                                        {volunteer.first_name?.[0]}{volunteer.last_name?.[0]}
                                                    </div>
                                                    <div>
                                                        <h3 className="text-lg font-bold text-gray-900 group-hover:text-amber-700 transition-colors">
                                                            {volunteer.first_name} {volunteer.last_name}
                                                        </h3>
                                                        <div className="flex flex-wrap gap-2 mt-1">
                                                            <span className="text-xs font-medium bg-blue-50 text-blue-700 px-2 py-0.5 rounded border border-blue-100">{volunteer.ilj_id || 'No ID'}</span>
                                                            {volunteer.district && <span className="text-xs font-medium bg-purple-50 text-purple-700 px-2 py-0.5 rounded border border-purple-100">{volunteer.district}</span>}
                                                        </div>
                                                    </div>
                                                </div>
                                                <div className="grid grid-cols-1 sm:grid-cols-3 gap-x-8 gap-y-1 text-sm text-gray-600 flex-1 md:ml-8">
                                                    <div className="flex items-center gap-2"><MapPin className="h-4 w-4 text-gray-400" /><span className="truncate">{volunteer.city}</span></div>
                                                    <div className="flex items-center gap-2"><Mail className="h-4 w-4 text-gray-400" /><span className="truncate">{volunteer.email}</span></div>
                                                    <div className="flex items-center gap-2"><Phone className="h-4 w-4 text-gray-400" /><span>{volunteer.mobile_number}</span></div>
                                                </div>
                                            </div>
                                        </div>
                                    ))
                                )}
                            </div>
                        )}
                    </>
                )}

                {/* --- TAB CONTENT: PROJECTS --- */}
                {activeTab === 'projects' && (
                    <div className="animate-in fade-in slide-in-from-bottom-2 duration-300">
                        {loadingProjects ? (
                            <div className="flex justify-center h-64 items-center"><div className="animate-spin rounded-full h-10 w-10 border-b-2 border-amber-600"></div></div>
                        ) : (
                            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                {projects.length === 0 ? (
                                    <div className="col-span-full text-center py-20 bg-white rounded-xl border border-gray-200 border-dashed">
                                        <Briefcase className="h-12 w-12 text-gray-300 mx-auto mb-4" />
                                        <h3 className="text-lg font-medium text-gray-900">No Projects Yet</h3>
                                        <p className="text-gray-500 mb-6">Create your first project to get started.</p>
                                        <button
                                            onClick={() => navigate('/admin/add-project')}
                                            className="px-4 py-2 bg-amber-600 text-white rounded-lg hover:bg-amber-700 transition-colors"
                                        >
                                            Create Project
                                        </button>
                                    </div>
                                ) : (
                                    projects.map(project => (
                                        <div
                                            key={project.id}
                                            onClick={() => navigate(`/admin/edit-project/${project.id}`)}
                                            className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden hover:shadow-lg transition-shadow duration-300 flex flex-col h-full cursor-pointer"
                                        >
                                            {/* Banner */}
                                            <div className="h-48 w-full bg-gray-100 relative">
                                                {project.banner_url ? (
                                                    <img src={project.banner_url} alt={project.title} className="w-full h-full object-cover" />
                                                ) : (
                                                    <div className="flex items-center justify-center h-full text-gray-400">
                                                        <Briefcase className="h-10 w-10" />
                                                    </div>
                                                )}
                                                <div className="absolute top-3 right-3">
                                                    <span className={`px-2.5 py-1 rounded-full text-xs font-semibold uppercase tracking-wide border shadow-sm
                                                        ${project.status === 'active' ? 'bg-green-100 text-green-700 border-green-200' :
                                                            project.status === 'completed' ? 'bg-gray-100 text-gray-700 border-gray-200' :
                                                                'bg-amber-100 text-amber-700 border-amber-200'}`
                                                    }>
                                                        {project.status || 'Upcoming'}
                                                    </span>
                                                </div>
                                            </div>

                                            {/* Content */}
                                            <div className="p-5 flex-1 flex flex-col">
                                                <div className="flex justify-between items-start mb-2">
                                                    <div>
                                                        <h3 className="font-bold text-gray-900 text-lg leading-tight line-clamp-1">{project.title}</h3>
                                                        <p className="text-xs text-gray-500 font-mono mt-1">{project.project_code}</p>
                                                    </div>
                                                </div>

                                                <p className="text-gray-600 text-sm line-clamp-2 mb-4 flex-1">
                                                    {project.description}
                                                </p>

                                                <div className="border-t border-gray-100 pt-4 flex items-center justify-between mt-auto">
                                                    <div className="flex items-center gap-2">
                                                        <div className="w-8 h-8 rounded-full bg-gray-100 flex items-center justify-center text-xs font-bold text-gray-600 border border-gray-200">
                                                            {project.manager?.first_name?.[0] || '?'}{project.manager?.last_name?.[0] || '?'}
                                                        </div>
                                                        <div className="text-xs">
                                                            <p className="text-gray-500">Manager</p>
                                                            <p className="font-medium text-gray-900 truncate max-w-[100px]">
                                                                {project.manager ? `${project.manager.first_name} ${project.manager.last_name}` : 'Unassigned'}
                                                            </p>
                                                        </div>
                                                    </div>

                                                    {/* Count Placeholder: In future, use real count from Supabase */}
                                                    {/* <div className="flex items-center gap-1 text-gray-500 text-xs">
                                                        <Users className="h-4 w-4" />
                                                        <span>12 Members</span>
                                                    </div> */}
                                                </div>
                                            </div>
                                        </div>
                                    ))
                                )}
                            </div>
                        )}
                    </div>
                )}
            </main>

            {/* Volunteer Modal (Same as before) */}
            {selectedVolunteer && (
                <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm transition-all" onClick={() => setSelectedVolunteer(null)}>
                    <div className="bg-white w-full max-w-4xl max-h-[90vh] overflow-y-auto rounded-2xl shadow-2xl animate-in fade-in zoom-in-95 duration-200" onClick={e => e.stopPropagation()}>
                        <div className="sticky top-0 bg-white border-b border-gray-100 p-6 flex justify-between items-start z-10">
                            <div className="flex items-center gap-4">
                                <div className="bg-gradient-to-br from-amber-500 to-orange-600 w-16 h-16 rounded-full flex items-center justify-center text-white font-bold text-2xl shadow-lg">
                                    {selectedVolunteer.first_name?.[0]}{selectedVolunteer.last_name?.[0]}
                                </div>
                                <div>
                                    <h2 className="text-2xl font-bold text-gray-900">
                                        {selectedVolunteer.first_name} {selectedVolunteer.middle_name} {selectedVolunteer.last_name}
                                    </h2>
                                    <p className="text-amber-600 font-medium">{selectedVolunteer.ilj_id}</p>
                                </div>
                            </div>
                            <button onClick={() => setSelectedVolunteer(null)} className="p-2 hover:bg-gray-100 rounded-full transition-colors"><X className="h-6 w-6 text-gray-500" /></button>
                        </div>
                        <div className="p-6 grid grid-cols-1 md:grid-cols-2 gap-8">
                            <section>
                                <h3 className="flex items-center gap-2 text-lg font-semibold text-gray-900 mb-4 border-b pb-2"><User className="h-5 w-5 text-amber-500" /> Personal Details</h3>
                                <div className="space-y-4">
                                    <DetailItem label="Full Name" value={`${selectedVolunteer.first_name} ${selectedVolunteer.middle_name || ''} ${selectedVolunteer.last_name}`} />
                                    <DetailItem label="Date of Birth" value={formatDate(selectedVolunteer.dob)} />
                                    <DetailItem label="Age" value={selectedVolunteer.age} />
                                    <DetailItem label="Gender" value={selectedVolunteer.gender} />
                                </div>
                            </section>
                            <section>
                                <h3 className="flex items-center gap-2 text-lg font-semibold text-gray-900 mb-4 border-b pb-2"><Phone className="h-5 w-5 text-amber-500" /> Contact & Address</h3>
                                <div className="space-y-4">
                                    <DetailItem label="Email" value={selectedVolunteer.email} />
                                    <DetailItem label="Mobile" value={selectedVolunteer.mobile_number} />
                                    <DetailItem label="Address" value={`${selectedVolunteer.address_line1 || ''}, ${selectedVolunteer.address_line2 || ''}`} />
                                    <DetailItem label="Location" value={`${selectedVolunteer.district}, ${selectedVolunteer.city}`} />
                                </div>
                            </section>
                            <section>
                                <h3 className="flex items-center gap-2 text-lg font-semibold text-gray-900 mb-4 border-b pb-2"><Briefcase className="h-5 w-5 text-amber-500" /> Professional & Skills</h3>
                                <div className="space-y-4">
                                    <DetailItem label="Occupation" value={selectedVolunteer.occupation} />
                                    <DetailItem label="Qualification" value={selectedVolunteer.qualification} />
                                    <div><p className="text-xs font-medium text-gray-500 uppercase">Skills</p><div className="flex flex-wrap gap-2 mt-1">{selectedVolunteer.skills?.split(',').map((s, i) => <span key={i} className="px-2 py-1 bg-gray-100 text-xs rounded border">{s.trim()}</span>)}</div></div>
                                </div>
                            </section>
                            <section>
                                <h3 className="flex items-center gap-2 text-lg font-semibold text-gray-900 mb-4 border-b pb-2"><Heart className="h-5 w-5 text-amber-500" /> Volunteering</h3>
                                <div className="space-y-4">
                                    <DetailItem label="Preference" value={selectedVolunteer.volunteering_preference1} highlight />
                                    <DetailItem label="Availability" value={selectedVolunteer.availability_days} />
                                    <DetailItem label="Mode" value={selectedVolunteer.participation_mode} />
                                </div>
                            </section>
                            <section className="md:col-span-2">
                                <h3 className="flex items-center gap-2 text-lg font-semibold text-gray-900 mb-4 border-b pb-2"><BookOpen className="h-5 w-5 text-amber-500" /> Other</h3>
                                <div className="grid md:grid-cols-2 gap-4">
                                    <DetailItem label="Dharmik Studies" value={selectedVolunteer.dharmik_studies} />
                                    <DetailItem label="Referred By" value={selectedVolunteer.referred_by} />
                                </div>
                            </section>
                        </div>
                        <div className="bg-gray-50 px-6 py-4 border-t border-gray-200 flex justify-end"><button onClick={() => setSelectedVolunteer(null)} className="px-6 py-2 bg-white border rounded hover:bg-gray-50">Close</button></div>
                    </div>
                </div>
            )}
        </div>
    );
};

const DetailItem = ({ label, value, highlight }) => {
    if (!value) return null;
    return <div className="flex flex-col"><span className="text-xs font-medium text-gray-500 uppercase">{label}</span><span className={`text-base ${highlight ? 'text-amber-700 font-semibold' : 'text-gray-900'}`}>{value}</span></div>
};

export default AdminDashboard;
