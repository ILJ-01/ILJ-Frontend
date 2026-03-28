import { useState, useEffect } from "react";
import { useAuth } from "@/context/AuthContext";
import { supabase } from "@/lib/supabase";
import {
    Users, Search, ChevronRight, X, Mail, Phone, MapPin,
    Heart, Award, Sparkles, User, Clock,
    FileSpreadsheet, Loader2, Download
} from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import * as XLSX from 'xlsx';

export default function KalyanMitraHub() {
    const { user } = useAuth();
    const [volunteers, setVolunteers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState("");
    const [selectedVolunteer, setSelectedVolunteer] = useState(null);

    useEffect(() => {
        if (user) {
            fetchAssignedVolunteers();
        }
    }, [user]);

    const fetchAssignedVolunteers = async () => {
        setLoading(true);
        try {
            const fullName = `${user.first_name} ${user.last_name}`.trim();

            // Search for volunteers where kalyan_mitra matches the current user's name
            // exact match might fail if there are extra spaces, so we could try ilike
            // but for now let's try exact match first as that's how it's likely stored

            const { data, error } = await supabase
                .from('volunteers')
                .select('*')
                .ilike('kalyan_mitra', `%${fullName}%`)
                .order('first_name', { ascending: true });

            if (error) throw error;
            setVolunteers(data || []);
        } catch (error) {
            console.error("Fetch Kalyan Mitra Volunteers Error:", error);
        } finally {
            setLoading(false);
        }
    };

    const handleExport = () => {
        const exportData = volunteers.map(vol => ({
            ILJ_ID: vol.ilj_id,
            First_Name: vol.first_name,
            Last_Name: vol.last_name,
            Email: vol.email,
            Mobile: vol.mobile_number,
            Gender: vol.gender,
            Age: vol.age,
            District: vol.district,
            City: vol.city,
            State: vol.state,
            Sangh_Name: vol.sangh_name,
            Designation: vol.designation,
            Role: vol.role,
            Occupation: vol.occupation,
            Qualification: vol.qualification,
            Skills: vol.skills,
            Joined_At: vol.created_at ? new Date(vol.created_at).toLocaleDateString() : 'N/A'
        }));

        const ws = XLSX.utils.json_to_sheet(exportData);
        const wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, ws, "My Volunteers");
        XLSX.writeFile(wb, `KalyanMitra_Volunteers_${new Date().toISOString().split('T')[0]}.xlsx`);
    };

    // Filter volunteers based on search term
    const filteredVolunteers = volunteers.filter(volunteer => {
        const searchLower = searchTerm.toLowerCase();
        return (
            volunteer.first_name?.toLowerCase().includes(searchLower) ||
            volunteer.last_name?.toLowerCase().includes(searchLower) ||
            volunteer.email?.toLowerCase().includes(searchLower) ||
            volunteer.mobile_number?.includes(searchTerm)
        );
    });

    return (
        <div className="min-h-screen bg-[#f8f9fa] p-4 md:p-8 font-sans">
            <div className="max-w-7xl mx-auto space-y-6">

                {/* Header Section */}
                <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
                    <div>
                        <h1 className="text-3xl font-serif font-bold text-gray-900">
                            <span className="text-[#ae2b2b]">Kalyan Mitra</span> Hub
                        </h1>
                        <p className="text-gray-500 mt-1">Manage and guide your assigned volunteers.</p>
                    </div>
                    <div className="flex gap-3">
                        <button
                            onClick={handleExport}
                            disabled={loading || volunteers.length === 0}
                            className="flex items-center gap-2 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                        >
                            <FileSpreadsheet className="h-4 w-4" /> Export List
                        </button>
                    </div>
                </div>

                {/* Search & Stats */}
                <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div className="md:col-span-2 relative">
                        <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 h-5 w-5" />
                        <input
                            type="text"
                            placeholder="Search by name, email, or phone..."
                            className="w-full pl-10 pr-4 py-3 rounded-xl border border-gray-200 focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all outline-none"
                            value={searchTerm}
                            onChange={(e) => setSearchTerm(e.target.value)}
                        />
                    </div>
                    <div className="bg-white p-3 rounded-xl border border-gray-200 flex items-center justify-between px-6 shadow-sm">
                        <span className="text-gray-500 font-medium">Total Assigned</span>
                        <span className="text-2xl font-bold text-[#ae2b2b]">{volunteers.length}</span>
                    </div>
                </div>

                {/* Volunteers List */}
                {loading ? (
                    <div className="flex justify-center items-center h-64">
                        <Loader2 className="h-8 w-8 animate-spin text-[#ae2b2b]" />
                    </div>
                ) : filteredVolunteers.length === 0 ? (
                    <div className="text-center py-12 bg-white rounded-2xl border border-dashed border-gray-300">
                        <Users className="h-12 w-12 text-gray-300 mx-auto mb-3" />
                        <h3 className="text-lg font-medium text-gray-900">No volunteers found</h3>
                        <p className="text-gray-500">
                            {searchTerm ? "Try adjusting your search terms." : "You have not been assigned any volunteers yet."}
                        </p>
                    </div>
                ) : (
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <AnimatePresence>
                            {filteredVolunteers.map((vol) => (
                                <motion.div
                                    layout
                                    initial={{ opacity: 0, scale: 0.9 }}
                                    animate={{ opacity: 1, scale: 1 }}
                                    exit={{ opacity: 0, scale: 0.9 }}
                                    key={vol.id}
                                    onClick={() => setSelectedVolunteer(vol)}
                                    className="bg-white p-5 rounded-xl shadow-sm border border-gray-100 hover:shadow-md hover:border-[#ae2b2b]/30 transition-all cursor-pointer group"
                                >
                                    <div className="flex items-start justify-between mb-4">
                                        <div className="flex items-center gap-3">
                                            <div className="h-10 w-10 rounded-full bg-[#ae2b2b]/10 flex items-center justify-center text-[#ae2b2b] font-bold">
                                                {vol.first_name?.[0]}{vol.last_name?.[0]}
                                            </div>
                                            <div>
                                                <h3 className="font-bold text-gray-900 group-hover:text-[#ae2b2b] transition-colors">
                                                    {vol.first_name} {vol.last_name}
                                                </h3>
                                                <p className="text-xs text-gray-500">{vol.ilj_id || 'No ID'}</p>
                                            </div>
                                        </div>
                                        <ChevronRight className="h-5 w-5 text-gray-300 group-hover:text-[#ae2b2b] group-hover:translate-x-1 transition-all" />
                                    </div>

                                    <div className="space-y-2 text-sm text-gray-600">
                                        <div className="flex items-center gap-2">
                                            <Mail className="h-3.5 w-3.5" />
                                            <span className="truncate">{vol.email}</span>
                                        </div>
                                        <div className="flex items-center gap-2">
                                            <Phone className="h-3.5 w-3.5" />
                                            <span>{vol.mobile_number}</span>
                                        </div>
                                        <div className="flex items-center gap-2">
                                            <MapPin className="h-3.5 w-3.5" />
                                            <span className="truncate">{vol.city || 'Unknown City'}, {vol.state || 'Unknown State'}</span>
                                        </div>
                                    </div>
                                </motion.div>
                            ))}
                        </AnimatePresence>
                    </div>
                )}
            </div>

            {/* Volunteer Details Modal */}
            <AnimatePresence>
                {selectedVolunteer && (
                    <motion.div
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                        className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4"
                        onClick={() => setSelectedVolunteer(null)}
                    >
                        <motion.div
                            initial={{ scale: 0.95, opacity: 0 }}
                            animate={{ scale: 1, opacity: 1 }}
                            exit={{ scale: 0.95, opacity: 0 }}
                            onClick={(e) => e.stopPropagation()}
                            className="bg-white rounded-2xl w-full max-w-2xl max-h-[90vh] overflow-y-auto shadow-2xl"
                        >
                            <div className="p-6 border-b border-gray-100 flex justify-between items-center sticky top-0 bg-white z-10">
                                <h2 className="text-xl font-bold text-gray-800">Volunteer Details</h2>
                                <button
                                    onClick={() => setSelectedVolunteer(null)}
                                    className="p-2 hover:bg-gray-100 rounded-full transition-colors"
                                >
                                    <X className="h-5 w-5 text-gray-500" />
                                </button>
                            </div>

                            <div className="p-6 space-y-6">
                                {/* Profile Header */}
                                <div className="flex items-center gap-4">
                                    <div className="h-16 w-16 rounded-full bg-[#ae2b2b] text-white flex items-center justify-center text-2xl font-bold shadow-lg">
                                        {selectedVolunteer.first_name?.[0]}{selectedVolunteer.last_name?.[0]}
                                    </div>
                                    <div>
                                        <h3 className="text-2xl font-bold text-gray-900">
                                            {selectedVolunteer.first_name} {selectedVolunteer.last_name}
                                        </h3>
                                        <p className="text-gray-500 flex items-center gap-2 mt-1">
                                            <span className="bg-gray-100 px-2 py-0.5 rounded text-xs font-semibold uppercase tracking-wide">
                                                {selectedVolunteer.gender || 'N/A'}
                                            </span>
                                            <span>•</span>
                                            <span>{selectedVolunteer.city}, {selectedVolunteer.state}</span>
                                        </p>
                                    </div>
                                </div>

                                {/* Detailed Info Grid */}
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                    <div className="space-y-4">
                                        <div className="flex items-start gap-3">
                                            <Mail className="h-5 w-5 text-gray-400 mt-0.5" />
                                            <div>
                                                <p className="text-xs font-semibold text-gray-500 uppercase">Email</p>
                                                <p className="text-gray-900">{selectedVolunteer.email}</p>
                                            </div>
                                        </div>
                                        <div className="flex items-start gap-3">
                                            <Phone className="h-5 w-5 text-gray-400 mt-0.5" />
                                            <div>
                                                <p className="text-xs font-semibold text-gray-500 uppercase">Phone</p>
                                                <p className="text-gray-900">{selectedVolunteer.mobile_number}</p>
                                            </div>
                                        </div>
                                        <div className="flex items-start gap-3">
                                            <User className="h-5 w-5 text-gray-400 mt-0.5" />
                                            <div>
                                                <p className="text-xs font-semibold text-gray-500 uppercase">Age</p>
                                                <p className="text-gray-900">{selectedVolunteer.age || 'N/A'}</p>
                                            </div>
                                        </div>
                                    </div>

                                    <div className="space-y-4">
                                        <div className="flex items-start gap-3">
                                            <Award className="h-5 w-5 text-gray-400 mt-0.5" />
                                            <div>
                                                <p className="text-xs font-semibold text-gray-500 uppercase">Occupation</p>
                                                <p className="text-gray-900">{selectedVolunteer.occupation || 'N/A'}</p>
                                            </div>
                                        </div>
                                        <div className="flex items-start gap-3">
                                            <Heart className="h-5 w-5 text-gray-400 mt-0.5" />
                                            <div>
                                                <p className="text-xs font-semibold text-gray-500 uppercase">Sangh</p>
                                                <p className="text-gray-900">{selectedVolunteer.sangh_name || 'N/A'}</p>
                                            </div>
                                        </div>
                                        <div className="flex items-start gap-3">
                                            <Clock className="h-5 w-5 text-gray-400 mt-0.5" />
                                            <div>
                                                <p className="text-xs font-semibold text-gray-500 uppercase">Joined On</p>
                                                <p className="text-gray-900">
                                                    {selectedVolunteer.created_at
                                                        ? new Date(selectedVolunteer.created_at).toLocaleDateString()
                                                        : 'N/A'}
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                {/* Preferences */}
                                <div className="bg-gray-50 p-4 rounded-xl border border-gray-200">
                                    <h4 className="font-bold text-gray-800 mb-3 flex items-center gap-2">
                                        <Sparkles className="h-4 w-4 text-[#ae2b2b]" /> Volunteering Preferences
                                    </h4>
                                    <div className="flex flex-wrap gap-2">
                                        {[
                                            selectedVolunteer.volunteering_preference1,
                                            selectedVolunteer.volunteering_preference2,
                                            selectedVolunteer.volunteering_preference3
                                        ].filter(Boolean).map((pref, i) => (
                                            <span key={i} className="bg-white border border-gray-200 px-3 py-1 rounded-full text-sm text-gray-700">
                                                {pref}
                                            </span>
                                        ))}
                                    </div>
                                </div>
                            </div>
                        </motion.div>
                    </motion.div>
                )}
            </AnimatePresence>
        </div>
    );
}
