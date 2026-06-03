import { useState, useEffect, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import { supabase, supabaseUrl } from '../lib/supabase';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';
import {
    Search, Filter, LogOut, MapPin, Mail, Phone,
    X, User, Briefcase, Heart, BookOpen, Plus, LayoutGrid, Users,
    Calendar, CheckSquare, Clock, Menu, Trash2, Shield, Award, TrendingUp, Download, Ticket, Lightbulb, Activity
} from 'lucide-react';

import AdminEvents from './admin/AdminEvents';
import AdminTasks from './admin/AdminTasks';
import AdminTimesheets from './admin/AdminTimesheets';
import AdminAppraisals from './admin/AdminAppraisals';
import AdminInquiries from './admin/AdminInquiries';
import AdminEventRegistrations from './admin/AdminEventRegistrations';
import AdminIdeas from './admin/AdminIdeas';
import AdminSTC from './admin/AdminSTC';
import AdminKalyanMitras from './admin/AdminKalyanMitras';
import AdminOpportunities from './admin/AdminOpportunities';

const RANKS = [
    { title: "Volunteer", minHours: 0, minSTC: 0, order: 0 },
    { title: "ILJ Elite Volunteer", minHours: 100, minSTC: 25, order: 1 },
    { title: "ILJ Premier Volunteer", minHours: 750, minSTC: 100, order: 2 },
    { title: "ILJ Prestige Volunteer", minHours: 1750, minSTC: 150, order: 3 },
    { title: "ILJ Legacy Volunteer", minHours: 3000, minSTC: 250, order: 4 }
];

const AdminDashboard = () => {
    const navigate = useNavigate();
    // Persist active tab in sessionStorage so it survives navigation to sub-pages
    const [activeTab, setActiveTab] = useState(() => {
        return sessionStorage.getItem('adminActiveTab') || 'volunteers';
    });

    // Volunteers State
    const [volunteers, setVolunteers] = useState([]);
    const [loadingVolunteers, setLoadingVolunteers] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');
    const [selectedLevelFilter, setSelectedLevelFilter] = useState('');
    const [showFilters, setShowFilters] = useState(false);
    const [selectedVolunteer, setSelectedVolunteer] = useState(null);
    const [filters, setFilters] = useState({ district: '', skills: '', volunteering_preference1: '' });
    const [options, setOptions] = useState({ districts: [], preferences: [], skills: [] });
    const [authLoading, setAuthLoading] = useState(true);

    // Projects State
    const [projects, setProjects] = useState([]);
    const [loadingProjects, setLoadingProjects] = useState(true);
    const [showArchivedProjects, setShowArchivedProjects] = useState(false);

    // Persist activeTab to sessionStorage whenever it changes
    useEffect(() => {
        sessionStorage.setItem('adminActiveTab', activeTab);
    }, [activeTab]);

    useEffect(() => {
        const checkAuth = async () => {
            const { data: { session } } = await supabase.auth.getSession();
            if (!session) {
                navigate('/admin');
                return;
            }
            // Only fetch data after auth is confirmed
            setAuthLoading(false);
            fetchVolunteers();
            fetchProjects();
        };
        checkAuth();
    }, [navigate]);

    const fetchVolunteers = async () => {
        try {
            setLoadingVolunteers(true);
            const { data, error } = await supabase
                .from('volunteers')
                .select('*')
                .order('created_at', { ascending: false });

            if (error) throw error;

            // Fetch total approved hours for each volunteer
            const { data: hourData, error: hourError } = await supabase
                .from('timesheets')
                .select('volunteer_id, hours')
                .eq('status', 'approved');

            if (hourError) throw hourError;

            // Fetch STC completions
            const { data: stcData, error: stcError } = await supabase
                .from('spiritual_task_assignments')
                .select('volunteer_id')
                .eq('status', 'completed');

            if (stcError) throw stcError;

            // Aggregate hours
            const hourMap = (hourData || []).reduce((acc, curr) => {
                acc[curr.volunteer_id] = (acc[curr.volunteer_id] || 0) + Number(curr.hours);
                return acc;
            }, {});

            // Aggregate STC
            const stcMap = (stcData || []).reduce((acc, curr) => {
                acc[curr.volunteer_id] = (acc[curr.volunteer_id] || 0) + 1;
                return acc;
            }, {});

            // Merge stats into volunteers list
            const volunteersWithStats = (data || []).map(v => ({
                ...v,
                totalHours: Math.round((hourMap[v.id] || 0) * 10) / 10,
                totalSTC: stcMap[v.id] || 0
            }));

            setVolunteers(volunteersWithStats);

            const districts = [...new Set(volunteersWithStats.map(v => v.district).filter(Boolean).map(d => d.trim()))].sort();
            const allPrefs = volunteersWithStats.flatMap(v => [v.volunteering_preference1, v.volunteering_preference2, v.volunteering_preference3]).filter(Boolean);
            const preferences = [...new Set(allPrefs)].sort();
            const allSkills = volunteersWithStats.map(v => v.skills).filter(Boolean).flatMap(skillStr => skillStr.split(',').map(s => s.trim()));
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

    const handleLogout = async () => {
        await supabase.auth.signOut();
        navigate('/admin');
    };

    const handleExport = async () => {
        try {
            const XLSX = await import("xlsx");
            const workbook = XLSX.utils.book_new();

            // 1. Volunteers
            const { data: volData } = await supabase.from('volunteers').select('*').order('created_at');
            const volSheetData = (volData || []).map(v => ({
                ILJ_ID: v.ilj_id,
                First_Name: v.first_name,
                Last_Name: v.last_name,
                Email: v.email,
                Mobile: v.mobile_number,
                Gender: v.gender,
                Age: v.age,
                District: v.district,
                City: v.city,
                State: v.state,
                Sangh_Name: v.sangh_name,
                Designation: v.designation,
                Role: v.role,
                Occupation: v.occupation,
                Qualification: v.qualification,
                Skills: v.skills,
                Volunteering_Pref_1: v.volunteering_preference1,
                Volunteering_Pref_2: v.volunteering_preference2,
                Volunteering_Pref_3: v.volunteering_preference3,
                Kalyan_Mitra: v.kalyan_mitra,
                Joined_At: v.created_at ? new Date(v.created_at).toLocaleDateString() : 'N/A'
            }));
            const volSheet = XLSX.utils.json_to_sheet(volSheetData);
            XLSX.utils.book_append_sheet(workbook, volSheet, "Volunteers");

            // 2. Projects
            const { data: projData } = await supabase.from('projects').select('*, manager:manager_id(first_name, last_name)').order('created_at');
            const projSheetData = (projData || []).map(p => ({
                Project_Code: p.project_code,
                Title: p.title,
                Status: p.status,
                Budget: p.budget,
                Created_At: p.created_at ? new Date(p.created_at).toLocaleDateString() : 'N/A',
                Manager_Name: p.manager ? `${p.manager.first_name || ''} ${p.manager.last_name || ''}`.trim() : 'Unknown'
            }));
            const projSheet = XLSX.utils.json_to_sheet(projSheetData);
            XLSX.utils.book_append_sheet(workbook, projSheet, "Pods");

            // 3. Events
            const { data: eventData } = await supabase.from('events').select('*').order('created_at');
            const eventSheetData = (eventData || []).map(e => ({
                Event_Title: e.title,
                Date: e.date,
                Location: e.location,
                Status: e.status,
                Capacity: e.capacity,
                Created_At: e.created_at ? new Date(e.created_at).toLocaleDateString() : 'N/A'
            }));
            const eventSheet = XLSX.utils.json_to_sheet(eventSheetData);
            XLSX.utils.book_append_sheet(workbook, eventSheet, "Events");

            // 4. Tasks
            const { data: taskData } = await supabase.from('tasks').select('*, assignee:assignee_id(first_name, last_name, ilj_id), project:project_id(title)').order('created_at');
            const taskSheetData = (taskData || []).map(t => ({
                Task_Title: t.title,
                Project: t.project?.title || 'Unknown',
                Assignee: t.assignee ? `${t.assignee.first_name || ''} ${t.assignee.last_name || ''} (${t.assignee.ilj_id || 'No ID'})`.trim() : 'Unassigned',
                Status: t.status,
                Deadline: t.deadline ? new Date(t.deadline).toLocaleDateString() : 'N/A'
            }));
            const taskSheet = XLSX.utils.json_to_sheet(taskSheetData);
            XLSX.utils.book_append_sheet(workbook, taskSheet, "Tasks");

            // 5. Timesheets
            const { data: tsData } = await supabase.from('timesheets').select('*, volunteer:volunteer_id(first_name, last_name, ilj_id), project:project_id(title)').order('created_at');
            const tsSheetData = (tsData || []).map(t => ({
                Date_Worked: t.date_worked ? new Date(t.date_worked).toLocaleDateString() : 'N/A',
                Volunteer: t.volunteer ? `${t.volunteer.first_name || ''} ${t.volunteer.last_name || ''} (${t.volunteer.ilj_id || 'No ID'})`.trim() : 'Unknown',
                Project: t.project?.title || 'Unknown',
                Role: t.role,
                Hours: t.hours,
                Status: t.status
            }));
            const tsSheet = XLSX.utils.json_to_sheet(tsSheetData);
            XLSX.utils.book_append_sheet(workbook, tsSheet, "Timesheets");

            XLSX.writeFile(workbook, "ILJ_Admin_Data.xlsx");
        } catch (error) {
            console.error("Export failed:", error);
            alert("Failed to export data. See console for details.");
        }
    };

    // --- Search & Filter Logic (Volunteers) ---
    const levelCounts = useMemo(() => {
        const counts = { Standard: 0, Elite: 0, Premier: 0, Prestige: 0, Legacy: 0 };
        volunteers.forEach(v => {
            const rank = (v.rank || '').toLowerCase();
            if (rank.includes('elite')) counts.Elite++;
            else if (rank.includes('premier')) counts.Premier++;
            else if (rank.includes('prestige')) counts.Prestige++;
            else if (rank.includes('legacy')) counts.Legacy++;
            else counts.Standard++;
        });
        return counts;
    }, [volunteers]);

    // --- Search & Filter Logic (Volunteers) ---
    const filteredVolunteers = useMemo(() => {
        return volunteers.filter(volunteer => {
            const searchLower = searchTerm.toLowerCase();
            const matchesSearch = searchTerm === '' || Object.values(volunteer).some(val =>
                String(val || '').toLowerCase().includes(searchLower)
            );
            const matchesDistrict = !filters.district || (volunteer.district || '').includes(filters.district);
            const matchesPreference = !filters.volunteering_preference1 ||
                [volunteer.volunteering_preference1, volunteer.volunteering_preference2, volunteer.volunteering_preference3].includes(filters.volunteering_preference1);
            const matchesSkill = !filters.skills || (volunteer.skills || '').toLowerCase().includes(filters.skills.toLowerCase());
            
            const rankStr = (volunteer.rank || '').toLowerCase();
            const matchesLevel = !selectedLevelFilter || 
                (selectedLevelFilter === 'Standard' 
                    ? (!volunteer.rank || rankStr === 'volunteer' || rankStr === 'intern')
                    : rankStr.includes(selectedLevelFilter.toLowerCase())
                );

            return matchesSearch && matchesDistrict && matchesSkill && matchesPreference && matchesLevel;
        });
    }, [volunteers, searchTerm, filters, selectedLevelFilter]);

    const clearFilters = () => {
        setFilters({ district: '', skills: '', volunteering_preference1: '' });
        setSearchTerm('');
        setSelectedLevelFilter('');
    };

    const formatDate = (dateString) => {
        if (!dateString) return 'N/A';
        return new Date(dateString).toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' });
    };

    const downloadProfilePDF = (volunteer) => {
        const doc = new jsPDF();
        
        // Brand Header
        doc.setFillColor(174, 43, 43); // #ae2b2b crimson
        doc.rect(0, 0, 210, 30, 'F');
        
        doc.setTextColor(255, 255, 255);
        doc.setFont('Helvetica', 'bold');
        doc.setFontSize(20);
        doc.text("I LOVE JINSHASAN", 15, 20);
        
        doc.setFontSize(10);
        doc.setFont('Helvetica', 'normal');
        doc.text("Volunteer Profile Report", 150, 20);
        
        // Title: Volunteer Name
        doc.setTextColor(30, 30, 30);
        doc.setFont('Helvetica', 'bold');
        doc.setFontSize(18);
        doc.text(`${volunteer.first_name || ''} ${volunteer.middle_name || ''} ${volunteer.last_name || ''}`.replace(/\s+/g, ' ').trim(), 15, 45);
        
        doc.setFont('Helvetica', 'bold');
        doc.setFontSize(12);
        doc.setTextColor(174, 43, 43);
        doc.text(`ILJ ID: ${volunteer.ilj_id || 'N/A'}`, 15, 52);
        
        doc.setDrawColor(220, 220, 220);
        doc.line(15, 56, 195, 56);
        
        const personalInfo = [
            ["Full Name", `${volunteer.first_name || ''} ${volunteer.middle_name || ''} ${volunteer.last_name || ''}`.replace(/\s+/g, ' ').trim()],
            ["Date of Birth", formatDate(volunteer.dob)],
            ["Age", volunteer.age ? String(volunteer.age) : 'N/A'],
            ["Gender", volunteer.gender || 'N/A'],
            ["Sangh Name", volunteer.sangh_name || 'N/A']
        ];
        
        const contactInfo = [
            ["Email Address", volunteer.email || 'N/A'],
            ["Mobile Number", volunteer.mobile_number || 'N/A'],
            ["District / City", `${volunteer.district || 'N/A'} / ${volunteer.city || 'N/A'}`],
            ["Full Address", `${volunteer.address_line1 || ''} ${volunteer.address_line2 || ''}`.trim() || 'N/A'],
            ["State / Pincode", `${volunteer.state || 'N/A'} - ${volunteer.pincode || 'N/A'}`]
        ];

        const professionalInfo = [
            ["Occupation", volunteer.occupation || 'N/A'],
            ["Qualification", volunteer.qualification || 'N/A'],
            ["Specialization", volunteer.specialization || 'N/A'],
            ["Skills", volunteer.skills || 'N/A'],
            ["Hobbies", volunteer.hobbies || 'N/A']
        ];

        const volunteeringInfo = [
            ["Preference 1", volunteer.volunteering_preference1 || 'N/A'],
            ["Preference 2", volunteer.volunteering_preference2 || 'N/A'],
            ["Preference 3", volunteer.volunteering_preference3 || 'N/A'],
            ["Availability Days", volunteer.availability_days || 'N/A'],
            ["Participation Mode", volunteer.participation_mode || 'N/A'],
            ["Time Commitment", volunteer.time_commitment || 'N/A']
        ];

        const activityMetrics = [
            ["Total Hours Worked", `${volunteer.totalHours || 0} hrs`],
            ["Spiritual Tasks (STC)", `${volunteer.totalSTC || 0} completed`],
            ["Current Level", volunteer.rank || 'Volunteer'],
            ["Designation", volunteer.designation || 'N/A'],
            ["Kalyan Mitra", volunteer.kalyan_mitra || 'N/A']
        ];

        let currentY = 62;

        const drawSection = (title, data) => {
            doc.setFont('Helvetica', 'bold');
            doc.setFontSize(13);
            doc.setTextColor(174, 43, 43);
            doc.text(title, 15, currentY);
            currentY += 4;
            
            autoTable(doc, {
                startY: currentY,
                margin: { left: 15, right: 15 },
                theme: 'striped',
                headStyles: { fillColor: [174, 43, 43] },
                styles: { fontSize: 9, cellPadding: 2.5 },
                columnStyles: { 0: { fontStyle: 'bold', width: 45 } },
                body: data,
                showHead: false
            });
            
            currentY = doc.lastAutoTable.finalY + 8;
        };

        drawSection("Personal Details", personalInfo);
        drawSection("Contact & Location Details", contactInfo);
        
        doc.addPage();
        currentY = 20;
        
        drawSection("Professional & Skills", professionalInfo);
        drawSection("Volunteering Preferences", volunteeringInfo);
        drawSection("Activity & Organization Metrics", activityMetrics);
        
        doc.save(`${volunteer.first_name}_${volunteer.last_name}_Profile.pdf`);
    };

    const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

    if (authLoading) {
        return (
            <div className="min-h-screen bg-gray-50 flex items-center justify-center">
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-[#ae2b2b]"></div>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-gray-50 font-sans pb-12">
            {/* Top Navigation */}
            <nav className="bg-white shadow-sm border-b border-gray-200 sticky top-0 z-20">
                <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <div className="flex justify-between h-16 items-center">
                        <div className="flex items-center gap-3">
                            {/* Mobile Hamburger Button */}
                            <button
                                onClick={() => setIsMobileMenuOpen(true)}
                                className="md:hidden p-2 text-gray-600 hover:bg-gray-100 rounded-lg"
                            >
                                <Menu className="h-6 w-6" />
                            </button>

                            <div className="bg-[#ae2b2b]/10 p-2 rounded-lg hidden md:block">
                                <User className="h-6 w-6 text-[#ae2b2b]" />
                            </div>
                            <span className="font-bold text-xl text-gray-800">Admin<span className="text-[#ae2b2b]">Portal</span></span>
                        </div>

                        {/* Desktop Logout */}
                        <button onClick={handleLogout} className="hidden md:flex items-center gap-2 text-gray-600 hover:text-[#ae2b2b] transition-colors px-3 py-2 rounded-md hover:bg-gray-50">
                            <LogOut className="h-5 w-5" />
                            <span className="hidden sm:inline">Logout</span>
                        </button>
                    </div>
                </div>
            </nav>

            {/* Mobile Navigation Drawer */}
            {isMobileMenuOpen && (
                <>
                    {/* Overlay */}
                    <div
                        className="fixed inset-0 bg-black/50 z-40 md:hidden"
                        onClick={() => setIsMobileMenuOpen(false)}
                    />

                    {/* Drawer */}
                    <div className="fixed inset-y-0 left-0 w-64 bg-white z-50 shadow-2xl transform transition-transform duration-300 ease-in-out md:hidden flex flex-col">
                        <div className="p-4 border-b border-gray-100 flex items-center justify-between">
                            <span className="font-bold text-xl text-gray-800">Admin<span className="text-[#ae2b2b]">Portal</span></span>
                            <button
                                onClick={() => setIsMobileMenuOpen(false)}
                                className="p-2 text-gray-500 hover:bg-gray-100 rounded-lg"
                            >
                                <X className="h-6 w-6" />
                            </button>
                        </div>

                        <div className="flex-1 overflow-y-auto py-4 px-3 space-y-1">
                            {[
                                { id: 'volunteers', label: 'Volunteers', icon: Users },
                                { id: 'kalyan_mitras', label: 'Kalyan Mitras', icon: Users },
                                { id: 'projects', label: 'Pods', icon: LayoutGrid },
                                { id: 'events', label: 'Events', icon: Calendar },
                                { id: 'event-registrations', label: 'Event Registrations', icon: Ticket },
                                { id: 'tasks', label: 'Tasks', icon: CheckSquare },
                                { id: 'timesheets', label: 'Time Sheets', icon: Clock },
                                { id: 'appraisals', label: 'Appraisals', icon: TrendingUp },
                                { id: 'inquiries', label: 'Inquiries', icon: Mail },
                                { id: 'ideas', label: 'Ideas', icon: Lightbulb },
                                { id: 'stc', label: 'Spiritual Tasks', icon: Activity },
                                { id: 'opportunities', label: 'Opportunities', icon: Briefcase },
                            ].map((item) => {
                                const Icon = item.icon;
                                const isActive = activeTab === item.id;
                                return (
                                    <button
                                        key={item.id}
                                        onClick={() => {
                                            setActiveTab(item.id);
                                            setIsMobileMenuOpen(false);
                                        }}
                                        className={`w-full flex items-center gap-3 px-3 py-3 rounded-lg font-medium transition-colors ${isActive
                                            ? 'bg-[#ae2b2b]/5 text-[#ae2b2b]'
                                            : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'
                                            }`}
                                    >
                                        <Icon className={`h-5 w-5 ${isActive ? 'text-[#ae2b2b]' : 'text-gray-400'}`} />
                                        {item.label}
                                    </button>
                                );
                            })}
                        </div>

                        <div className="p-4 border-t border-gray-100">
                            <button
                                onClick={handleLogout}
                                className="w-full flex items-center gap-3 px-3 py-3 rounded-lg font-medium text-red-600 hover:bg-red-50 transition-colors"
                            >
                                <LogOut className="h-5 w-5" />
                                Logout
                            </button>
                        </div>
                    </div>
                </>
            )}

            <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

                {/* Dashboard Tabs & Actions */}
                <div className="mb-8 flex flex-col xl:flex-row xl:items-center justify-between gap-4">
                    <div>
                        <h1 className="text-2xl font-bold text-gray-900">Dashboard</h1>
                        <p className="text-gray-500 mt-1">Manage your team and projects effectively.</p>
                    </div>

                    <div className="flex flex-wrap items-center gap-2">
                        {/* Export Button */}
                        <button
                            onClick={handleExport}
                            className="flex items-center gap-2 bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition-all shadow-md font-semibold text-sm whitespace-nowrap"
                        >
                            <Download className="h-4 w-4" /> Export Excel
                        </button>

                        {/* Tab Switcher (Desktop Only) */}
                        <div className="hidden md:flex bg-gray-200 p-1 rounded-lg items-center overflow-x-auto max-w-full">
                            <button onClick={() => setActiveTab('volunteers')} className={`flex items-center gap-2 px-3 py-2 rounded-md font-medium text-sm whitespace-nowrap transition-all ${activeTab === 'volunteers' ? 'bg-white text-[#ae2b2b] shadow-sm' : 'text-gray-600 hover:text-gray-900'}`}>
                                <Users className="h-4 w-4" /> Volunteers
                            </button>
                            <button onClick={() => setActiveTab('kalyan_mitras')} className={`flex items-center gap-2 px-3 py-2 rounded-md font-medium text-sm whitespace-nowrap transition-all ${activeTab === 'kalyan_mitras' ? 'bg-white text-[#ae2b2b] shadow-sm' : 'text-gray-600 hover:text-gray-900'}`}>
                                <Users className="h-4 w-4" /> Kalyan Mitras
                            </button>
                            <button onClick={() => setActiveTab('projects')} className={`flex items-center gap-2 px-3 py-2 rounded-md font-medium text-sm whitespace-nowrap transition-all ${activeTab === 'projects' ? 'bg-white text-[#ae2b2b] shadow-sm' : 'text-gray-600 hover:text-gray-900'}`}>
                                <LayoutGrid className="h-4 w-4" /> Pods
                            </button>
                            <button onClick={() => setActiveTab('events')} className={`flex items-center gap-2 px-3 py-2 rounded-md font-medium text-sm whitespace-nowrap transition-all ${activeTab === 'events' ? 'bg-white text-[#ae2b2b] shadow-sm' : 'text-gray-600 hover:text-gray-900'}`}>
                                <Calendar className="h-4 w-4" /> Events
                            </button>
                            <button onClick={() => setActiveTab('event-registrations')} className={`flex items-center gap-2 px-3 py-2 rounded-md font-medium text-sm whitespace-nowrap transition-all ${activeTab === 'event-registrations' ? 'bg-white text-[#ae2b2b] shadow-sm' : 'text-gray-600 hover:text-gray-900'}`}>
                                <Ticket className="h-4 w-4" /> Registrations
                            </button>
                            <button onClick={() => setActiveTab('tasks')} className={`flex items-center gap-2 px-3 py-2 rounded-md font-medium text-sm whitespace-nowrap transition-all ${activeTab === 'tasks' ? 'bg-white text-[#ae2b2b] shadow-sm' : 'text-gray-600 hover:text-gray-900'}`}>
                                <CheckSquare className="h-4 w-4" /> Tasks
                            </button>
                            <button onClick={() => setActiveTab('timesheets')} className={`flex items-center gap-2 px-3 py-2 rounded-md font-medium text-sm whitespace-nowrap transition-all ${activeTab === 'timesheets' ? 'bg-white text-[#ae2b2b] shadow-sm' : 'text-gray-600 hover:text-gray-900'}`}>
                                <Clock className="h-4 w-4" /> Approvals
                            </button>
                            <button onClick={() => setActiveTab('appraisals')} className={`flex items-center gap-2 px-3 py-2 rounded-md font-medium text-sm whitespace-nowrap transition-all ${activeTab === 'appraisals' ? 'bg-white text-[#ae2b2b] shadow-sm' : 'text-gray-600 hover:text-gray-900'}`}>
                                <TrendingUp className="h-4 w-4" /> Appraisals
                            </button>
                            <button onClick={() => setActiveTab('inquiries')} className={`flex items-center gap-2 px-3 py-2 rounded-md font-medium text-sm whitespace-nowrap transition-all ${activeTab === 'inquiries' ? 'bg-white text-[#ae2b2b] shadow-sm' : 'text-gray-600 hover:text-gray-900'}`}>
                                <Mail className="h-4 w-4" /> Inquiries
                            </button>
                            <button onClick={() => setActiveTab('ideas')} className={`flex items-center gap-2 px-3 py-2 rounded-md font-medium text-sm whitespace-nowrap transition-all ${activeTab === 'ideas' ? 'bg-white text-[#ae2b2b] shadow-sm' : 'text-gray-600 hover:text-gray-900'}`}>
                                <Lightbulb className="h-4 w-4" /> Ideas
                            </button>
                            <button onClick={() => setActiveTab('stc')} className={`flex items-center gap-2 px-3 py-2 rounded-md font-medium text-sm whitespace-nowrap transition-all ${activeTab === 'stc' ? 'bg-white text-[#ae2b2b] shadow-sm' : 'text-gray-600 hover:text-gray-900'}`}>
                                <Activity className="h-4 w-4" /> STC
                            </button>
                            <button onClick={() => setActiveTab('opportunities')} className={`flex items-center gap-2 px-3 py-2 rounded-md font-medium text-sm whitespace-nowrap transition-all ${activeTab === 'opportunities' ? 'bg-white text-[#ae2b2b] shadow-sm' : 'text-gray-600 hover:text-gray-900'}`}>
                                <Briefcase className="h-4 w-4" /> Opportunities
                            </button>
                        </div>

                        {/* Action Buttons */}
                        {activeTab === 'projects' && (
                            <div className="flex items-center gap-2">
                                <button
                                    onClick={() => setShowArchivedProjects(!showArchivedProjects)}
                                    className={`px-4 py-2 rounded-lg border text-sm font-medium transition-all ${showArchivedProjects ? 'bg-amber-100 border-amber-300 text-amber-700' : 'bg-white border-gray-200 text-gray-600 hover:bg-gray-50'}`}
                                >
                                    {showArchivedProjects ? 'Show Active' : 'Show Archived'}
                                </button>
                                <button onClick={() => navigate('/admin/add-project')} className="flex items-center gap-2 bg-[#ae2b2b] text-white px-4 py-2 rounded-lg hover:bg-[#8b1e1e] transition-all shadow-md font-semibold text-sm whitespace-nowrap">
                                    <Plus className="h-5 w-5" /> Add Pod
                                </button>
                            </div>
                        )}
                        {activeTab === 'volunteers' && (
                            <div className="flex items-center gap-2">

                            </div>
                        )}
                    </div>
                </div>

                {/* --- TAB CONTENT: VOLUNTEERS --- */}
                {activeTab === 'volunteers' && (
                    <>
                        {/* Level Summary Cards */}
                        <div className="grid grid-cols-2 md:grid-cols-5 gap-4 mb-6">
                            {[
                                { id: 'Standard', label: 'Standard', count: levelCounts.Standard, bg: 'bg-gray-50 border-gray-200 text-gray-700 hover:bg-gray-100', activeBg: 'bg-gray-200 border-gray-400 text-gray-900 shadow-sm ring-2 ring-gray-400/20' },
                                { id: 'Elite', label: 'Elite', count: levelCounts.Elite, bg: 'bg-amber-50 border-amber-200 text-amber-700 hover:bg-amber-100/50', activeBg: 'bg-amber-100 border-amber-400 text-amber-900 shadow-sm ring-2 ring-amber-400/20' },
                                { id: 'Premier', label: 'Premier', count: levelCounts.Premier, bg: 'bg-emerald-50 border-emerald-200 text-emerald-700 hover:bg-emerald-100/50', activeBg: 'bg-emerald-100 border-emerald-400 text-emerald-900 shadow-sm ring-2 ring-emerald-400/20' },
                                { id: 'Prestige', label: 'Prestige', count: levelCounts.Prestige, bg: 'bg-blue-50 border-blue-200 text-blue-700 hover:bg-blue-100/50', activeBg: 'bg-blue-100 border-blue-400 text-blue-900 shadow-sm ring-2 ring-blue-400/20' },
                                { id: 'Legacy', label: 'Legacy', count: levelCounts.Legacy, bg: 'bg-purple-50 border-purple-200 text-purple-700 hover:bg-purple-100/50', activeBg: 'bg-purple-100 border-purple-400 text-purple-900 shadow-sm ring-2 ring-purple-400/20' }
                            ].map(level => {
                                const isActive = selectedLevelFilter === level.id;
                                return (
                                    <div
                                        key={level.id}
                                        onClick={() => setSelectedLevelFilter(isActive ? '' : level.id)}
                                        className={`p-4 rounded-xl border cursor-pointer transition-all duration-200 flex flex-col justify-between hover:scale-[1.02] ${isActive ? level.activeBg : level.bg}`}
                                    >
                                        <span className="text-xs font-bold uppercase tracking-wider opacity-85">{level.label}</span>
                                        <div className="flex items-baseline justify-between mt-2">
                                            <span className="text-2xl font-black">{level.count}</span>
                                            {isActive && <span className="text-[10px] font-black bg-white/60 px-1.5 py-0.5 rounded">Selected</span>}
                                        </div>
                                    </div>
                                );
                            })}
                        </div>

                        {/* Search & Filter Controls */}
                        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-4 mb-6">
                            <div className="flex flex-col md:flex-row gap-4">
                                <div className="flex-1 relative">
                                    <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" />
                                    <input
                                        type="text"
                                        placeholder="Search ANY field..."
                                        className="w-full pl-10 pr-4 py-2.5 bg-gray-50 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-gray-400 focus:bg-white transition-all"
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
                            <div className="flex justify-center h-64 items-center"><div className="animate-spin rounded-full h-10 w-10 border-b-2 border-[#ae2b2b]"></div></div>
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
                                            className="bg-white rounded-xl shadow-sm border border-gray-200 hover:border-[#ae2b2b]/50 hover:shadow-md transition-all p-5 cursor-pointer group"
                                        >
                                            <div className="flex flex-col md:flex-row justify-between gap-4 md:items-center">
                                                <div className="flex items-start gap-4">
                                                    <div className="bg-gray-100 w-12 h-12 rounded-full flex items-center justify-center text-[#ae2b2b] font-bold text-lg border border-gray-200 shrink-0 group-hover:bg-[#ae2b2b]/10 transition-colors">
                                                        {volunteer.first_name?.[0]}{volunteer.last_name?.[0]}
                                                    </div>
                                                    <div>
                                                        <h3 className="text-lg font-bold text-gray-900 group-hover:text-[#ae2b2b] transition-colors">
                                                            {volunteer.first_name} {volunteer.last_name}
                                                        </h3>
                                                        <div className="flex flex-wrap gap-2 mt-1">
                                                            <span className="text-xs font-medium bg-blue-50 text-blue-700 px-2 py-0.5 rounded border border-blue-100">{volunteer.ilj_id || 'No ID'}</span>
                                                            <span className="text-xs font-bold bg-amber-50 text-amber-700 px-2 py-0.5 rounded border border-amber-100 flex items-center gap-1 uppercase tracking-tight">
                                                                <Award className="h-3 w-3" />
                                                                {volunteer.rank || 'Volunteer'}
                                                            </span>
                                                            {volunteer.designation && (
                                                                <span className="text-xs font-bold bg-blue-50 text-blue-700 px-2 py-0.5 rounded border border-blue-100 flex items-center gap-1 uppercase tracking-tight">
                                                                    <Briefcase className="h-3 w-3" />
                                                                    {volunteer.designation}
                                                                </span>
                                                            )}
                                                            {volunteer.secondary_designation && (
                                                                <span className="text-xs font-bold bg-purple-50 text-purple-700 px-2 py-0.5 rounded border border-purple-100 flex items-center gap-1 uppercase tracking-tight">
                                                                    <Shield className="h-3 w-3" />
                                                                    {volunteer.secondary_designation}
                                                                </span>
                                                            )}
                                                        </div>
                                                    </div>
                                                </div>
                                                <div className="grid grid-cols-1 sm:grid-cols-5 gap-x-4 gap-y-1 text-sm text-gray-600 flex-1 md:ml-8">
                                                    <div className="flex items-center gap-2"><MapPin className="h-4 w-4 text-gray-400" /><span className="truncate">{volunteer.city}</span></div>
                                                    <div className="flex items-center gap-2"><Mail className="h-4 w-4 text-gray-400" /><span className="truncate text-ellipsis overflow-hidden max-w-[120px]" title={volunteer.email}>{volunteer.email}</span></div>
                                                    <div className="flex items-center gap-2"><Phone className="h-4 w-4 text-gray-400" /><span>{volunteer.mobile_number}</span></div>
                                                    <div className="flex items-center gap-2"><Clock className="h-4 w-4 text-[#ae2b2b]" /><span>{volunteer.totalHours || 0} hrs</span></div>
                                                    <div className="flex items-center gap-2"><Activity className="h-4 w-4 text-[#ae2b2b]" /><span>STC: {volunteer.totalSTC || 0}</span></div>
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
                            <div className="flex justify-center h-64 items-center"><div className="animate-spin rounded-full h-10 w-10 border-b-2 border-[#ae2b2b]"></div></div>
                        ) : (
                            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                {projects.filter(p => showArchivedProjects ? p.status === 'archived' : p.status !== 'archived').length === 0 ? (
                                    <div className="col-span-full text-center py-20 bg-white rounded-xl border border-gray-200 border-dashed">
                                        <Briefcase className="h-12 w-12 text-gray-300 mx-auto mb-4" />
                                        <h3 className="text-lg font-medium text-gray-900">No {showArchivedProjects ? 'Archived ' : ''}Pods Found</h3>
                                        {!showArchivedProjects && <p className="text-gray-500 mb-6">Create your first pod to get started.</p>}
                                        {!showArchivedProjects && (
                                            <button
                                                onClick={() => navigate('/admin/add-project')}
                                                className="px-4 py-2 bg-[#ae2b2b] text-white rounded-lg hover:bg-[#8b1e1e] transition-colors"
                                            >
                                                Create Pod
                                            </button>
                                        )}
                                    </div>
                                ) : (
                                    projects.filter(p => showArchivedProjects ? p.status === 'archived' : p.status !== 'archived').map(project => (
                                        <div
                                            key={project.id}
                                            onClick={() => navigate(`/admin/edit-project/${project.id}`)}
                                            className={`bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden hover:shadow-lg transition-shadow duration-300 flex flex-col h-full cursor-pointer ${project.status === 'archived' ? 'opacity-75 grayscale-[0.5]' : ''}`}
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
                                                            project.status === 'completed' ? 'bg-blue-100 text-blue-700 border-blue-200' :
                                                                project.status === 'archived' ? 'bg-gray-100 text-gray-700 border-gray-200' :
                                                                    'bg-[#ae2b2b]/10 text-[#ae2b2b] border-[#ae2b2b]/20'}`
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

                {/* --- TAB CONTENT: EVENTS --- */}
                {activeTab === 'events' && (
                    <div className="animate-in fade-in slide-in-from-bottom-2 duration-300">
                        <AdminEvents />
                    </div>
                )}

                {/* --- TAB CONTENT: TASKS --- */}
                {activeTab === 'tasks' && (
                    <div className="animate-in fade-in slide-in-from-bottom-2 duration-300">
                        <AdminTasks />
                    </div>
                )}

                {/* --- TAB CONTENT: TIMESHEETS --- */}
                {activeTab === 'timesheets' && (
                    <div className="animate-in fade-in slide-in-from-bottom-2 duration-300">
                        <AdminTimesheets />
                    </div>
                )}
                {activeTab === 'appraisals' && (
                    <div className="animate-in fade-in slide-in-from-bottom-2 duration-300">
                        <AdminAppraisals />
                    </div>
                )}
                {activeTab === 'inquiries' && (
                    <div className="animate-in fade-in slide-in-from-bottom-2 duration-300">
                        <AdminInquiries />
                    </div>
                )}
                {activeTab === 'event-registrations' && (
                    <div className="animate-in fade-in slide-in-from-bottom-2 duration-300">
                        <AdminEventRegistrations />
                    </div>
                )}
                {activeTab === 'ideas' && (
                    <div className="animate-in fade-in slide-in-from-bottom-2 duration-300">
                        <AdminIdeas />
                    </div>
                )}
                {activeTab === 'stc' && (
                    <div className="animate-in fade-in slide-in-from-bottom-2 duration-300">
                        <AdminSTC />
                    </div>
                )}
                {activeTab === 'opportunities' && (
                    <div className="animate-in fade-in slide-in-from-bottom-2 duration-300">
                        <AdminOpportunities />
                    </div>
                )}
            </main>

            {/* Volunteer Modal (Same as before) */}
            {selectedVolunteer && (
                <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm transition-all" onClick={() => setSelectedVolunteer(null)}>
                    <div className="bg-white w-full max-w-4xl max-h-[90vh] overflow-y-auto rounded-2xl shadow-2xl animate-in fade-in zoom-in-95 duration-200" onClick={e => e.stopPropagation()}>
                        <div className="sticky top-0 bg-white border-b border-gray-100 p-6 flex justify-between items-start z-10">
                            <div className="flex items-center gap-4">
                                <div className="bg-gradient-to-br from-[#ae2b2b] to-[#5c1212] w-16 h-16 rounded-full flex items-center justify-center text-white font-bold text-2xl shadow-lg">
                                    {selectedVolunteer.first_name?.[0]}{selectedVolunteer.last_name?.[0]}
                                </div>
                                <div>
                                    <h2 className="text-2xl font-bold text-gray-900">
                                        {selectedVolunteer.first_name} {selectedVolunteer.middle_name} {selectedVolunteer.last_name}
                                    </h2>
                                    <div className="flex items-center gap-2 mt-1 flex-wrap">
                                        <p className="text-[#ae2b2b] font-medium">{selectedVolunteer.ilj_id}</p>
                                        <span className="h-4 w-px bg-gray-300"></span>
                                        <div className="flex items-center gap-1 text-amber-600 font-bold text-xs uppercase tracking-wider">
                                            <Award className="h-4 w-4" />
                                            {selectedVolunteer.rank || 'Volunteer'}
                                        </div>
                                        {selectedVolunteer.designation && (
                                            <>
                                                <span className="h-4 w-px bg-gray-300"></span>
                                                <div className="flex items-center gap-1 text-blue-600 font-bold text-xs uppercase tracking-wider">
                                                    <Briefcase className="h-3.5 w-3.5" />
                                                    {selectedVolunteer.designation}
                                                </div>
                                            </>
                                        )}
                                        {selectedVolunteer.secondary_designation && (
                                            <>
                                                <span className="h-4 w-px bg-gray-300"></span>
                                                <div className="flex items-center gap-1 text-purple-600 font-bold text-xs uppercase tracking-wider">
                                                    <Shield className="h-3.5 w-3.5" />
                                                    {selectedVolunteer.secondary_designation}
                                                </div>
                                            </>
                                        )}
                                    </div>
                                </div>
                            </div>
                            <div className="flex items-center gap-2">
                                <button
                                    onClick={() => downloadProfilePDF(selectedVolunteer)}
                                    className="flex items-center gap-2 bg-[#ae2b2b] text-white px-4 py-2 rounded-xl text-sm font-semibold hover:bg-[#8b1e1e] transition-all shadow-sm"
                                    title="Download Profile PDF"
                                >
                                    <Download className="h-4 w-4" />
                                    <span className="hidden sm:inline">Download PDF</span>
                                </button>
                                <button onClick={() => setSelectedVolunteer(null)} className="p-2 hover:bg-gray-100 rounded-full transition-colors"><X className="h-6 w-6 text-gray-500" /></button>
                            </div>
                        </div>
                        <div className="p-6 grid grid-cols-1 md:grid-cols-2 gap-8">
                            <section>
                                <h3 className="flex items-center gap-2 text-lg font-semibold text-gray-900 mb-4 border-b pb-2"><User className="h-5 w-5 text-[#ae2b2b]" /> Personal Details</h3>
                                <div className="space-y-4">
                                    <DetailItem label="Full Name" value={`${selectedVolunteer.first_name} ${selectedVolunteer.middle_name || ''} ${selectedVolunteer.last_name}`} />
                                    <DetailItem label="Date of Birth" value={formatDate(selectedVolunteer.dob)} />
                                    <DetailItem label="Age" value={selectedVolunteer.age} />
                                    <DetailItem label="Gender" value={selectedVolunteer.gender} />
                                </div>
                            </section>
                            <section>
                                <h3 className="flex items-center gap-2 text-lg font-semibold text-gray-900 mb-4 border-b pb-2"><Phone className="h-5 w-5 text-[#ae2b2b]" /> Contact & Address</h3>
                                <div className="space-y-4">
                                    <DetailItem label="Email" value={selectedVolunteer.email} />
                                    <DetailItem label="Mobile" value={selectedVolunteer.mobile_number} />
                                    <DetailItem label="Address" value={`${selectedVolunteer.address_line1 || ''}, ${selectedVolunteer.address_line2 || ''}`} />
                                    <DetailItem label="Location" value={`${selectedVolunteer.district}, ${selectedVolunteer.city}`} />
                                </div>
                            </section>
                            <section>
                                <h3 className="flex items-center gap-2 text-lg font-semibold text-gray-900 mb-4 border-b pb-2"><Briefcase className="h-5 w-5 text-[#ae2b2b]" /> Professional & Skills</h3>
                                <div className="space-y-4">
                                    <DetailItem label="Occupation" value={selectedVolunteer.occupation} />
                                    <DetailItem label="Qualification" value={selectedVolunteer.qualification} />
                                    <div><p className="text-xs font-medium text-gray-500 uppercase">Skills</p><div className="flex flex-wrap gap-2 mt-1">{selectedVolunteer.skills?.split(',').map((s, i) => <span key={i} className="px-2 py-1 bg-gray-100 text-xs rounded border">{s.trim()}</span>)}</div></div>
                                </div>
                            </section>
                            <section>
                                <h3 className="flex items-center gap-2 text-lg font-semibold text-gray-900 mb-4 border-b pb-2"><Heart className="h-5 w-5 text-[#ae2b2b]" /> Volunteering</h3>
                                <div className="space-y-4">
                                    <DetailItem label="Preference 1" value={selectedVolunteer.volunteering_preference1} highlight />
                                    <DetailItem label="Preference 2" value={selectedVolunteer.volunteering_preference2} />
                                    <DetailItem label="Preference 3" value={selectedVolunteer.volunteering_preference3} />
                                    <DetailItem label="Availability" value={selectedVolunteer.availability_days} />
                                    <DetailItem label="Mode" value={selectedVolunteer.participation_mode} />
                                </div>
                            </section>
                            <section>
                                <h3 className="flex items-center gap-2 text-lg font-semibold text-gray-900 mb-4 border-b pb-2"><Award className="h-5 w-5 text-[#ae2b2b]" /> Activity & Contribution</h3>
                                <div className="space-y-4">
                                    <DetailItem label="Total Hours Worked" value={`${selectedVolunteer.totalHours || 0} hrs`} highlight />
                                    <DetailItem label="Spiritual Tasks (STC)" value={`${selectedVolunteer.totalSTC || 0} completed`} highlight />
                                    <DetailItem label="Level / Rank" value={selectedVolunteer.rank || 'Volunteer'} />
                                </div>
                            </section>
                            <section>
                                <h3 className="flex items-center gap-2 text-lg font-semibold text-gray-900 mb-4 border-b pb-2"><BookOpen className="h-5 w-5 text-[#ae2b2b]" /> Other</h3>
                                <div className="space-y-4">
                                    <DetailItem label="Dharmik Studies" value={selectedVolunteer.dharmik_studies} />
                                    <DetailItem label="Referred By" value={selectedVolunteer.referred_by} />
                                </div>
                            </section>

                            <section className="md:col-span-2 bg-gray-50 p-4 rounded-xl border border-gray-200">
                                <h3 className="flex items-center gap-2 text-lg font-semibold text-gray-900 mb-4"><Users className="h-5 w-5 text-[#ae2b2b]" /> Assign Roles</h3>
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                    {/* Kalyan Mitra Section */}
                                    <div className="space-y-4">
                                        <div className="flex items-center justify-between bg-white p-3 rounded-lg border border-gray-200">
                                            <div>
                                                <p className="text-xs font-medium text-gray-500 uppercase">Current Kalyan Mitra</p>
                                                <p className="text-base font-semibold text-[#ae2b2b]">{selectedVolunteer.kalyan_mitra || "Not Assigned"}</p>
                                            </div>
                                        </div>

                                        <div className="relative">
                                            <label className="text-sm font-medium text-gray-700 mb-1 block">Search & Assign New Mitra</label>
                                            <div className="relative">
                                                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
                                                <input
                                                    type="text"
                                                    placeholder="Search volunteer name..."
                                                    className="w-full pl-9 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#ae2b2b] focus:border-transparent outline-none text-sm"
                                                    onChange={(e) => {
                                                        const term = e.target.value.toLowerCase();
                                                        const dropdown = document.getElementById('mitra-dropdown');
                                                        if (dropdown) {
                                                            dropdown.style.display = term ? 'block' : 'none';
                                                            const items = dropdown.querySelectorAll('.mitra-item');
                                                            items.forEach(item => {
                                                                const name = item.dataset.name.toLowerCase();
                                                                item.style.display = name.includes(term) ? 'flex' : 'none';
                                                            });
                                                        }
                                                    }}
                                                />
                                            </div>

                                            <div id="mitra-dropdown" className="hidden absolute z-20 w-full mt-1 bg-white border border-gray-200 rounded-lg shadow-lg max-h-60 overflow-y-auto">
                                                {volunteers.filter(v => v.id !== selectedVolunteer.id).map(v => (
                                                    <div
                                                        key={v.id}
                                                        data-name={`${v.first_name} ${v.last_name}`}
                                                        className="mitra-item flex items-center justify-between p-3 hover:bg-gray-50 cursor-pointer border-b border-gray-100 last:border-0"
                                                        onClick={async () => {
                                                            const confirmAssign = window.confirm(`Assign ${v.first_name} ${v.last_name} as Kalyan Mitra for ${selectedVolunteer.first_name}?`);
                                                            if (confirmAssign) {
                                                                try {
                                                                    const mitraName = `${v.first_name} ${v.last_name}`;
                                                                    const response = await fetch(`${supabaseUrl}/functions/v1/assign-kalyan-mitra`, {
                                                                        method: 'POST',
                                                                        headers: { 'Content-Type': 'application/json' },
                                                                        body: JSON.stringify({
                                                                            volunteer_id: selectedVolunteer.id,
                                                                            kalyan_mitra: mitraName
                                                                        })
                                                                    });
                                                                    const result = await response.json();
                                                                    if (!response.ok || result.error) throw new Error(result.error);
                                                                    const updated = { ...selectedVolunteer, kalyan_mitra: mitraName };
                                                                    setSelectedVolunteer(updated);
                                                                    setVolunteers(prev => prev.map(vol => vol.id === updated.id ? updated : vol));
                                                                    document.getElementById('mitra-dropdown').style.display = 'none';
                                                                } catch (err) { alert(`Error: ${err.message}`); }
                                                            }
                                                        }}
                                                    >
                                                        <div className="flex items-center gap-3">
                                                            <div className="w-8 h-8 rounded-full bg-gray-100 flex items-center justify-center text-xs font-bold text-gray-600">
                                                                {v.first_name?.[0]}{v.last_name?.[0]}
                                                            </div>
                                                            <div>
                                                                <p className="text-sm font-medium text-gray-900">{v.first_name} {v.last_name}</p>
                                                                <p className="text-xs text-gray-500">{v.ilj_id}</p>
                                                            </div>
                                                        </div>
                                                        <Plus className="h-4 w-4 text-[#ae2b2b]" />
                                                    </div>
                                                ))}
                                            </div>
                                        </div>



                                        {/* Rank & Designation Field */}
                                        <div className="bg-white p-4 rounded-xl border border-gray-200 shadow-sm space-y-4">
                                            {/* Rank Selector */}
                                            <div>
                                                <label className="text-xs font-bold text-gray-500 uppercase tracking-widest mb-2 block">Assign Level / Rank</label>
                                                <div className="flex gap-2">
                                                    <select
                                                        id="rank-selector"
                                                        value={selectedVolunteer.rank || 'Volunteer'}
                                                        onChange={async (e) => {
                                                            const newRank = e.target.value;
                                                            if (!newRank) return;

                                                            if (window.confirm(`Are you sure you want to assign the level/rank ${newRank} to this volunteer?`)) {
                                                                try {
                                                                    const { error } = await supabase
                                                                        .from('volunteers')
                                                                        .update({ rank: newRank })
                                                                        .eq('id', selectedVolunteer.id);

                                                                    if (error) throw error;

                                                                    const updated = { ...selectedVolunteer, rank: newRank };
                                                                    setSelectedVolunteer(updated);
                                                                    setVolunteers(prev => prev.map(vol => vol.id === updated.id ? updated : vol));
                                                                    // alert("Rank updated successfully!");
                                                                } catch (err) {
                                                                    alert(`Error updating rank: ${err.message}`);
                                                                }
                                                            }
                                                        }}
                                                        className="flex-1 p-2.5 bg-white border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#ae2b2b] outline-none"
                                                    >
                                                        {RANKS.map(r => (
                                                            <option key={r.title} value={r.title}>
                                                                {r.title} (min {r.minHours}h)
                                                            </option>
                                                        ))}
                                                    </select>
                                                </div>
                                            </div>

                                            {/* Designation Input */}
                                            <div>
                                                <label className="text-xs font-bold text-gray-500 uppercase tracking-widest mb-2 block">Set Designation</label>
                                                <div className="flex gap-2">
                                                    <input
                                                        type="text"
                                                        id="designation-input"
                                                        placeholder="e.g. Lead Designer"
                                                        className="flex-1 p-2.5 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#ae2b2b] outline-none"
                                                        defaultValue={selectedVolunteer.designation || ""}
                                                    />
                                                    <button
                                                        onClick={async () => {
                                                            const newVal = document.getElementById('designation-input').value;
                                                            try {
                                                                const { error } = await supabase
                                                                    .from('volunteers')
                                                                    .update({ designation: newVal || null })
                                                                    .eq('id', selectedVolunteer.id);

                                                                if (error) throw error;
                                                                const updated = { ...selectedVolunteer, designation: newVal || null };
                                                                setSelectedVolunteer(updated);
                                                                setVolunteers(prev => prev.map(vol => vol.id === updated.id ? updated : vol));
                                                                alert("Designation updated!");
                                                            } catch (err) { alert(`Error: ${err.message}`); }
                                                        }}
                                                        className="bg-[#ae2b2b] text-white px-4 py-2 rounded-lg text-sm font-bold hover:bg-[#8b1e1e] transition-colors shadow-sm"
                                                    >
                                                        Update
                                                    </button>
                                                </div>
                                            </div>

                                            {/* Secondary Designation (Chair Person / Vice Chair Person) */}
                                            <div>
                                                <label className="text-xs font-bold text-gray-500 uppercase tracking-widest mb-2 block">Secondary Designation</label>
                                                <div className="flex gap-2">
                                                    <select
                                                        id="secondary-designation-selector"
                                                        defaultValue={selectedVolunteer.secondary_designation || ""}
                                                        className="flex-1 p-2.5 bg-white border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#ae2b2b] outline-none"
                                                    >
                                                        <option value="">None</option>
                                                        <option value="Chair Person">Chair Person</option>
                                                        <option value="Vice Chair Person">Vice Chair Person</option>
                                                    </select>
                                                    <button
                                                        onClick={async () => {
                                                            const newVal = document.getElementById('secondary-designation-selector').value;
                                                            try {
                                                                const { error } = await supabase
                                                                    .from('volunteers')
                                                                    .update({ secondary_designation: newVal || null })
                                                                    .eq('id', selectedVolunteer.id);

                                                                if (error) throw error;
                                                                const updated = { ...selectedVolunteer, secondary_designation: newVal || null };
                                                                setSelectedVolunteer(updated);
                                                                setVolunteers(prev => prev.map(vol => vol.id === updated.id ? updated : vol));
                                                                alert("Secondary designation updated!");
                                                            } catch (err) { alert(`Error: ${err.message}`); }
                                                        }}
                                                        className="bg-[#ae2b2b] text-white px-4 py-2 rounded-lg text-sm font-bold hover:bg-[#8b1e1e] transition-colors shadow-sm"
                                                    >
                                                        Update
                                                    </button>
                                                </div>
                                                <p className="text-xs text-gray-400 mt-1">This is a dual designation — held alongside the primary designation above.</p>
                                            </div>
                                        </div>
                                    </div>

                                    {/* Team Leader Section */}
                                    <div className="space-y-6">
                                        <div className="bg-white p-4 rounded-xl border border-gray-200 shadow-sm">
                                            <div className="flex items-center justify-between mb-4">
                                                <h4 className="text-sm font-bold text-gray-700 uppercase tracking-wider flex items-center gap-2">
                                                    <Shield className="h-4 w-4 text-blue-600" />
                                                    Current Leadership Roles
                                                </h4>
                                                <span className="bg-blue-100 text-blue-700 text-[10px] font-bold px-2 py-0.5 rounded-full">
                                                    {selectedVolunteer.team_leader_for ? selectedVolunteer.team_leader_for.split(',').filter(Boolean).length : 0} Teams
                                                </span>
                                            </div>

                                            <div className="space-y-2">
                                                {selectedVolunteer.team_leader_for && selectedVolunteer.team_leader_for.split('|').filter(Boolean).map(role => (
                                                    <div key={role} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg border border-gray-100 group">
                                                        <span className="text-sm font-medium text-gray-800">{role.trim()}</span>
                                                        <button
                                                            onClick={async () => {
                                                                if (window.confirm(`Remove "${role.trim()}" leadership role from ${selectedVolunteer.first_name}?`)) {
                                                                    try {
                                                                        const currentTeams = selectedVolunteer.team_leader_for.split('|').map(t => t.trim()).filter(Boolean);
                                                                        const newTeams = currentTeams.filter(t => t !== role.trim());
                                                                        const teamString = newTeams.join('|');

                                                                        const { error } = await supabase
                                                                            .from('volunteers')
                                                                            .update({ team_leader_for: teamString || null })
                                                                            .eq('id', selectedVolunteer.id);

                                                                        if (error) throw error;

                                                                        const updated = { ...selectedVolunteer, team_leader_for: teamString || null };
                                                                        setSelectedVolunteer(updated);
                                                                        setVolunteers(prev => prev.map(vol => vol.id === updated.id ? updated : vol));
                                                                    } catch (err) {
                                                                        alert(`Error: ${err.message}`);
                                                                    }
                                                                }
                                                            }}
                                                            className="p-1.5 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded-md transition-colors opacity-0 group-hover:opacity-100"
                                                            title="Delete Assignment"
                                                        >
                                                            <Trash2 className="h-4 w-4" />
                                                        </button>
                                                    </div>
                                                ))}
                                                {!selectedVolunteer.team_leader_for && (
                                                    <div className="text-center py-6 border-2 border-dashed border-gray-100 rounded-xl">
                                                        <p className="text-sm text-gray-400 italic">No teams assigned to this volunteer</p>
                                                    </div>
                                                )}
                                            </div>
                                        </div>

                                        <div className="bg-blue-50/50 p-4 rounded-xl border border-blue-100">
                                            <label className="text-xs font-bold text-blue-700 uppercase tracking-widest mb-3 block">Assign To New Team</label>
                                            <div className="flex gap-2">
                                                <select
                                                    id="team-selector"
                                                    className="flex-1 p-2.5 bg-white border border-blue-200 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none"
                                                >
                                                    <option value="">Select a team...</option>
                                                    {[
                                                        "Research & Documentation",
                                                        "Content Writing (Articles, Blogs, Scripts)",
                                                        "Public Speaking, Acting & Stage Activities",
                                                        "Graphic Design & Video Editing",
                                                        "Photography & Videography",
                                                        "Event Planning & Management",
                                                        "Marketing & Outreach",
                                                        "Pathshala & Educational Activities",
                                                        "IT & Technical Support"
                                                    ].map(team => {
                                                        const currentTeams = selectedVolunteer.team_leader_for ? selectedVolunteer.team_leader_for.split('|').map(t => t.trim()) : [];
                                                        if (currentTeams.includes(team)) return null;
                                                        return <option key={team} value={team}>{team}</option>;
                                                    })}
                                                </select>
                                                <button
                                                    onClick={async () => {
                                                        const selector = document.getElementById('team-selector');
                                                        const teamName = selector.value;
                                                        if (!teamName) return;

                                                        try {
                                                            const currentTeams = selectedVolunteer.team_leader_for ? selectedVolunteer.team_leader_for.split('|').map(t => t.trim()).filter(Boolean) : [];
                                                            const newTeams = [...new Set([...currentTeams, teamName])];
                                                            const teamString = newTeams.join('|');

                                                            const { error } = await supabase
                                                                .from('volunteers')
                                                                .update({ team_leader_for: teamString })
                                                                .eq('id', selectedVolunteer.id);

                                                            if (error) throw error;

                                                            const updated = { ...selectedVolunteer, team_leader_for: teamString };
                                                            setSelectedVolunteer(updated);
                                                            setVolunteers(prev => prev.map(vol => vol.id === updated.id ? updated : vol));
                                                            selector.value = ""; // Reset selector
                                                        } catch (err) {
                                                            alert(`Error: ${err.message}`);
                                                        }
                                                    }}
                                                    className="bg-blue-600 text-white px-4 py-2 rounded-lg text-sm font-bold hover:bg-blue-700 transition-colors shadow-sm flex items-center gap-2"
                                                >
                                                    <Plus className="h-4 w-4" /> Add
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    {/* System Roles Section */}
                                    <div className="space-y-6 md:col-span-2">
                                        <div className="bg-gray-50 p-4 rounded-xl border border-gray-200">
                                            <h4 className="text-sm font-bold text-gray-700 uppercase tracking-wider flex items-center gap-2 mb-4">
                                                <Activity className="h-4 w-4 text-purple-600" />
                                                System Roles
                                            </h4>
                                            <div className="flex flex-col sm:flex-row flex-wrap gap-6">
                                                {/* IT Admin Toggle */}
                                                <label className="flex items-center gap-3 cursor-pointer">
                                                    <div className="relative">
                                                        <input 
                                                            type="checkbox" 
                                                            className="sr-only peer"
                                                            checked={selectedVolunteer.is_it_admin || false}
                                                            onChange={async (e) => {
                                                                const newVal = e.target.checked;
                                                                try {
                                                                    const { error } = await supabase
                                                                        .from('volunteers')
                                                                        .update({ is_it_admin: newVal })
                                                                        .eq('id', selectedVolunteer.id);
                                                                    if (error) throw error;
                                                                    
                                                                    const updated = { ...selectedVolunteer, is_it_admin: newVal };
                                                                    setSelectedVolunteer(updated);
                                                                    setVolunteers(prev => prev.map(vol => vol.id === updated.id ? updated : vol));
                                                                } catch (err) {
                                                                    alert(`Error updating IT Admin role: ${err.message}`);
                                                                }
                                                            }}
                                                        />
                                                        <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-purple-600"></div>
                                                    </div>
                                                    <span className="text-sm font-medium text-gray-900">IT Admin (Master DB)</span>
                                                </label>

                                                {/* Onboarding Team Toggle */}
                                                <label className="flex items-center gap-3 cursor-pointer">
                                                    <div className="relative">
                                                        <input 
                                                            type="checkbox" 
                                                            className="sr-only peer"
                                                            checked={selectedVolunteer.is_onboarding_team || false}
                                                            onChange={async (e) => {
                                                                const newVal = e.target.checked;
                                                                try {
                                                                    const { error } = await supabase
                                                                        .from('volunteers')
                                                                        .update({ is_onboarding_team: newVal })
                                                                        .eq('id', selectedVolunteer.id);
                                                                    if (error) throw error;
                                                                    
                                                                    const updated = { ...selectedVolunteer, is_onboarding_team: newVal };
                                                                    setSelectedVolunteer(updated);
                                                                    setVolunteers(prev => prev.map(vol => vol.id === updated.id ? updated : vol));
                                                                } catch (err) {
                                                                    alert(`Error updating Onboarding Team role: ${err.message}`);
                                                                }
                                                            }}
                                                        />
                                                        <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
                                                    </div>
                                                    <span className="text-sm font-medium text-gray-900">Onboarding Team</span>
                                                </label>

                                                {/* Pod Manager Toggle */}
                                                <label className="flex items-center gap-3 cursor-pointer">
                                                    <div className="relative">
                                                        <input 
                                                            type="checkbox" 
                                                            className="sr-only peer"
                                                            checked={selectedVolunteer.is_pod_team || false}
                                                            onChange={async (e) => {
                                                                const newVal = e.target.checked;
                                                                try {
                                                                    const { error } = await supabase
                                                                        .from('volunteers')
                                                                        .update({ is_pod_team: newVal })
                                                                        .eq('id', selectedVolunteer.id);
                                                                    if (error) throw error;
                                                                    
                                                                    if (!newVal) {
                                                                        // Clear manager_id from all projects managed by this volunteer
                                                                        const { error: projError } = await supabase
                                                                            .from('projects')
                                                                            .update({ manager_id: null })
                                                                            .eq('manager_id', selectedVolunteer.id);
                                                                        if (projError) console.error("Error clearing project managers:", projError);
                                                                        
                                                                        setProjects(prev => prev.map(p => 
                                                                            p.manager_id === selectedVolunteer.id ? { ...p, manager_id: null } : p
                                                                        ));
                                                                    }
                                                                    
                                                                    const updated = { ...selectedVolunteer, is_pod_team: newVal };
                                                                    setSelectedVolunteer(updated);
                                                                    setVolunteers(prev => prev.map(vol => vol.id === updated.id ? updated : vol));
                                                                } catch (err) {
                                                                    alert(`Error updating Pod Manager role: ${err.message}`);
                                                                }
                                                            }}
                                                        />
                                                        <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-green-600"></div>
                                                    </div>
                                                    <span className="text-sm font-medium text-gray-900">Pod Manager Hub</span>
                                                </label>
                                            </div>

                                            {/* Specific Pod Selection for Pod Manager */}
                                            {selectedVolunteer.is_pod_team && (
                                                <div className="mt-6 pt-6 border-t border-gray-200">
                                                    <h5 className="text-xs font-bold text-gray-500 uppercase tracking-wider mb-3">Managed Pods / Projects</h5>
                                                    <div className="bg-white border border-gray-200 rounded-lg p-3 max-h-48 overflow-y-auto space-y-2">
                                                        {projects.length > 0 ? (
                                                            projects.map(project => {
                                                                const isManaged = project.manager_id === selectedVolunteer.id;
                                                                return (
                                                                    <label key={project.id} className="flex items-center gap-3 cursor-pointer p-1.5 hover:bg-gray-50 rounded transition-colors">
                                                                        <input 
                                                                            type="checkbox" 
                                                                            className="w-4 h-4 rounded border-gray-300 text-[#ae2b2b] focus:ring-[#ae2b2b]"
                                                                            checked={isManaged}
                                                                            onChange={async (e) => {
                                                                                const shouldAssign = e.target.checked;
                                                                                try {
                                                                                    const { error } = await supabase
                                                                                        .from('projects')
                                                                                        .update({ manager_id: shouldAssign ? selectedVolunteer.id : null })
                                                                                        .eq('id', project.id);
                                                                                    
                                                                                    if (error) throw error;
                                                                                    
                                                                                    // Update local projects state
                                                                                    setProjects(prev => prev.map(p => 
                                                                                        p.id === project.id ? { ...p, manager_id: shouldAssign ? selectedVolunteer.id : null } : p
                                                                                    ));
                                                                                } catch (err) {
                                                                                    alert(`Error updating pod access: ${err.message}`);
                                                                                }
                                                                            }}
                                                                        />
                                                                        <span className="text-sm font-medium text-gray-800">{project.title} <span className="text-xs text-gray-400 font-mono">({project.project_code})</span></span>
                                                                    </label>
                                                                );
                                                            })
                                                        ) : (
                                                            <p className="text-xs italic text-gray-400 p-2">No projects/pods found.</p>
                                                        )}
                                                    </div>
                                                    <p className="text-[11px] text-gray-400 mt-2">Checking a pod updates the pod's manager to this volunteer in real-time. Unchecking removes them as manager.</p>
                                                </div>
                                            )}
                                        </div>
                                    </div>

                                </div>
                            </section>

                        </div>
                        <div className="bg-gray-50 px-6 py-4 border-t border-gray-200 flex justify-end"><button onClick={() => setSelectedVolunteer(null)} className="px-6 py-2 bg-white border rounded hover:bg-gray-50">Close</button></div>
                    </div>
                </div>
            )}
            
            {/* --- TAB CONTENT: KALYAN MITRAS --- */}
            {activeTab === 'kalyan_mitras' && (
                <AdminKalyanMitras volunteers={volunteers} />
            )}
        </div>
    );
};

const DetailItem = ({ label, value, highlight }) => {
    if (!value) return null;
    return <div className="flex flex-col"><span className="text-xs font-medium text-gray-500 uppercase">{label}</span><span className={`text-base ${highlight ? 'text-[#ae2b2b] font-semibold' : 'text-gray-900'}`}>{value}</span></div>
};

export default AdminDashboard;
