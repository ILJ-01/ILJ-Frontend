import { useState, useEffect } from "react";
import { useAuth } from "@/context/AuthContext";
import { supabase } from "@/lib/supabase";
import {
    Users, Search, ChevronRight, X, Mail, Phone, MapPin,
    Briefcase, GraduationCap, Heart, Award, Sparkles, User, Clock,
    FileText, Mic, Palette, Camera, Calendar, Megaphone, School, Code, Shield, LayoutGrid
} from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";

export default function TeamLeaderHub() {
    const { user } = useAuth();
    const [volunteers, setVolunteers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState("");
    const [selectedVolunteer, setSelectedVolunteer] = useState(null);
    const [teams, setTeams] = useState([]);
    const [activeTeam, setActiveTeam] = useState("All");

    const teamMapping = {
        "Research & Documentation": { icon: FileText, color: "blue" },
        "Content Writing (Articles, Blogs, Scripts)": { icon: FileText, color: "indigo" },
        "Public Speaking, Acting & Stage Activities": { icon: Mic, color: "purple" },
        "Graphic Design & Video Editing": { icon: Palette, color: "pink" },
        "Photography & Videography": { icon: Camera, color: "rose" },
        "Event Planning & Management": { icon: Calendar, color: "orange" },
        "Marketing & Outreach": { icon: Megaphone, color: "amber" },
        "Pathshala & Educational Activities": { icon: School, color: "emerald" },
        "IT & Technical Support": { icon: Code, color: "cyan" }
    };

    useEffect(() => {
        if (user?.team_leader_for) {
            const parsedTeams = user.team_leader_for.split('|').map(t => t.trim());
            setTeams(parsedTeams);
            fetchInterestedVolunteers(parsedTeams);
        }
    }, [user]);

    const fetchInterestedVolunteers = async (teamList) => {
        setLoading(true);
        try {
            // Construct OR conditions for all teams and all preferences
            const orConditions = [];
            teamList.forEach(team => {
                orConditions.push(`volunteering_preference1.eq."${team}"`);
                orConditions.push(`volunteering_preference2.eq."${team}"`);
                orConditions.push(`volunteering_preference3.eq."${team}"`);
            });

            const { data, error } = await supabase
                .from('volunteers')
                .select('*')
                .or(orConditions.join(','))
                .order('created_at', { ascending: false });

            if (error) throw error;
            setVolunteers(data || []);
        } catch (error) {
            console.error("Fetch Team Volunteers Error:", error);
        } finally {
            setLoading(false);
        }
    };

    const getPreferenceLevel = (volunteer) => {
        const leaderTeams = user.team_leader_for.split('|').map(t => t.trim());
        const prefs = [volunteer.volunteering_preference1, volunteer.volunteering_preference2, volunteer.volunteering_preference3];

        for (let i = 0; i < prefs.length; i++) {
            if (leaderTeams.includes(prefs[i])) return i + 1;
        }
        return 0;
    };

    const filteredVolunteers = volunteers.filter(v => {
        const matchesSearch = `${v.first_name} ${v.last_name} ${v.ilj_id}`.toLowerCase().includes(searchTerm.toLowerCase());
        const matchesTeam = activeTeam === "All" ||
            [v.volunteering_preference1, v.volunteering_preference2, v.volunteering_preference3].includes(activeTeam);
        return matchesSearch && matchesTeam;
    });

    if (!user?.team_leader_for) {
        return (
            <div className="flex flex-col items-center justify-center h-[60vh] text-center px-4">
                <div className="bg-gray-100 p-6 rounded-full mb-4">
                    <Users className="h-12 w-12 text-gray-400" />
                </div>
                <h2 className="text-2xl font-bold text-gray-900">Access Denied</h2>
                <p className="text-gray-500 mt-2 max-w-md">
                    This hub is only accessible to designated Team Leaders. If you believe this is an error, please contact the administrator.
                </p>
            </div>
        );
    }

    return (
        <div className="space-y-8">
            {/* Header */}
            <div className="bg-gradient-to-r from-[#ae2b2b] to-[#5c1212] rounded-3xl p-8 text-white shadow-xl relative overflow-hidden">
                <div className="relative z-10 flex flex-col md:flex-row md:items-center justify-between gap-6">
                    <div>
                        <div className="flex items-center gap-3 mb-2">
                            <span className="bg-white/20 backdrop-blur-md px-3 py-1 rounded-full text-xs font-bold uppercase tracking-wider">Team Leader Hub</span>
                        </div>
                        <h1 className="text-3xl md:text-4xl font-serif font-bold italic">Leadership Hub</h1>
                        <p className="text-white/80 mt-2 max-w-2xl">
                            Manage and connect with volunteers who have expressed interest in your {teams.length > 1 ? 'teams' : 'team'}.
                        </p>
                        <div className="flex flex-wrap gap-2 mt-6">
                            <button
                                onClick={() => setActiveTeam("All")}
                                className={`px-4 py-2 rounded-xl text-xs font-bold transition-all border flex items-center gap-2 ${activeTeam === "All"
                                    ? 'bg-white text-[#ae2b2b] border-white shadow-lg'
                                    : 'bg-white/10 text-white border-white/20 hover:bg-white/20'
                                    }`}
                            >
                                <LayoutGrid className="h-3.5 w-3.5" /> All Teams
                            </button>
                            {teams.map(team => {
                                const Icon = teamMapping[team]?.icon || Shield;
                                return (
                                    <button
                                        key={team}
                                        onClick={() => setActiveTeam(team)}
                                        className={`px-4 py-2 rounded-xl text-xs font-bold transition-all border flex items-center gap-2 ${activeTeam === team
                                            ? 'bg-white text-[#ae2b2b] border-white shadow-lg'
                                            : 'bg-white/10 text-white border-white/20 hover:bg-white/20'
                                            }`}
                                    >
                                        <Icon className="h-3.5 w-3.5" /> {team}
                                    </button>
                                );
                            })}
                        </div>
                    </div>
                    <div className="bg-white/10 backdrop-blur-md p-4 rounded-2xl flex items-center gap-4 border border-white/10">
                        <div className="text-right">
                            <p className="text-xs text-white/60 uppercase font-bold tracking-widest">Total Interested</p>
                            <p className="text-3xl font-bold">{volunteers.length}</p>
                        </div>
                        <div className="w-px h-10 bg-white/20"></div>
                        <div className="bg-white/20 p-3 rounded-xl">
                            <Users className="h-6 w-6" />
                        </div>
                    </div>
                </div>

                {/* Decorative Elements */}
                <div className="absolute top-0 right-0 w-64 h-64 bg-white/5 rounded-full -translate-y-1/2 translate-x-1/2 blur-3xl"></div>
                <div className="absolute bottom-0 left-0 w-48 h-48 bg-black/10 rounded-full translate-y-1/2 -translate-x-1/2 blur-2xl"></div>
            </div>

            {/* List and Search */}
            <div className="space-y-4">
                <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                    <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                        Interested Volunteers
                        <span className="bg-gray-100 text-gray-600 text-xs px-2 py-0.5 rounded-full">{filteredVolunteers.length}</span>
                    </h2>
                    <div className="relative w-full md:w-80">
                        <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
                        <input
                            type="text"
                            placeholder="Search by name or ID..."
                            className="w-full pl-10 pr-4 py-2 bg-white border border-gray-200 rounded-xl focus:ring-2 focus:ring-[#ae2b2b] focus:border-transparent outline-none shadow-sm transition-all"
                            value={searchTerm}
                            onChange={(e) => setSearchTerm(e.target.value)}
                        />
                    </div>
                </div>

                {loading ? (
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                        {[1, 2, 3, 4, 5, 6].map(i => (
                            <div key={i} className="bg-white h-32 rounded-2xl border border-gray-100 animate-pulse"></div>
                        ))}
                    </div>
                ) : (
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                        {filteredVolunteers.map(volunteer => {
                            const level = getPreferenceLevel(volunteer);
                            return (
                                <motion.div
                                    key={volunteer.id}
                                    layout
                                    initial={{ opacity: 0, scale: 0.95 }}
                                    animate={{ opacity: 1, scale: 1 }}
                                    onClick={() => setSelectedVolunteer(volunteer)}
                                    className="bg-white border border-gray-200 rounded-2xl p-5 hover:border-[#ae2b2b] hover:shadow-lg transition-all cursor-pointer group relative overflow-hidden"
                                >
                                    <div className="flex items-start gap-4">
                                        <div className="w-12 h-12 rounded-full bg-gray-50 flex items-center justify-center text-[#ae2b2b] font-bold text-lg group-hover:bg-[#ae2b2b]/10 transition-colors">
                                            {volunteer.first_name?.[0]}{volunteer.last_name?.[0]}
                                        </div>
                                        <div className="flex-1 min-w-0">
                                            <h3 className="font-bold text-gray-900 truncate group-hover:text-[#ae2b2b] transition-colors">
                                                {volunteer.first_name} {volunteer.last_name}
                                            </h3>
                                            <p className="text-xs text-gray-500 font-mono">{volunteer.ilj_id}</p>
                                            <div className="flex flex-wrap gap-2 mt-2">
                                                <span className={`text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-full shadow-sm
                                                    ${level === 1 ? 'bg-green-100 text-green-700 border border-green-200' :
                                                        level === 2 ? 'bg-amber-100 text-amber-700 border border-amber-200' :
                                                            'bg-gray-100 text-gray-600 border border-gray-200'}
                                                `}>
                                                    {level === 1 ? '1st' : level === 2 ? '2nd' : '3rd'} Preference
                                                </span>
                                            </div>
                                        </div>
                                        <ChevronRight className="h-5 w-5 text-gray-300 group-hover:text-[#ae2b2b] transition-all" />
                                    </div>

                                    {/* Preference Dot */}
                                    <div className={`absolute top-0 right-0 w-8 h-8 -mr-4 -mt-4 rotate-45 
                                        ${level === 1 ? 'bg-green-500' : level === 2 ? 'bg-amber-500' : 'bg-gray-300'}
                                     opacity-20`}></div>
                                </motion.div>
                            );
                        })}

                        {filteredVolunteers.length === 0 && (
                            <div className="col-span-full py-12 text-center bg-gray-50 rounded-3xl border-2 border-dashed border-gray-200">
                                <Search className="h-10 w-10 text-gray-300 mx-auto mb-3" />
                                <p className="text-gray-500">No volunteers found matching that search.</p>
                            </div>
                        )}
                    </div>
                )}
            </div>

            {/* Details Modal */}
            <AnimatePresence>
                {selectedVolunteer && (
                    <div className="fixed inset-0 z-[60] flex items-center justify-center p-4">
                        <motion.div
                            initial={{ opacity: 0 }}
                            animate={{ opacity: 1 }}
                            exit={{ opacity: 0 }}
                            onClick={() => setSelectedVolunteer(null)}
                            className="absolute inset-0 bg-black/60 backdrop-blur-sm"
                        />
                        <motion.div
                            initial={{ scale: 0.9, opacity: 0, y: 20 }}
                            animate={{ scale: 1, opacity: 1, y: 0 }}
                            exit={{ scale: 0.9, opacity: 0, y: 20 }}
                            className="bg-white w-full max-w-4xl max-h-[90vh] overflow-hidden rounded-3xl shadow-2xl relative z-10 flex flex-col"
                        >
                            {/* Modal Header */}
                            <div className="relative h-32 flex-shrink-0 bg-[#ae2b2b]">
                                <div className="absolute inset-0 overflow-hidden">
                                    <div className="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full -translate-y-1/2 translate-x-1/2 blur-2xl"></div>
                                    <div className="absolute bottom-0 left-0 w-48 h-48 bg-black/10 rounded-full translate-y-1/2 -translate-x-1/2 blur-xl"></div>
                                </div>
                                <div className="absolute -bottom-12 left-8 flex items-end gap-6">
                                    <div className="w-24 h-24 rounded-3xl bg-white p-1.5 shadow-xl">
                                        <div className="w-full h-full rounded-2xl bg-gradient-to-br from-[#ae2b2b] to-[#5c1212] flex items-center justify-center text-white text-3xl font-bold border-4 border-white shadow-inner">
                                            {selectedVolunteer.first_name?.[0]}{selectedVolunteer.last_name?.[0]}
                                        </div>
                                    </div>
                                    <div className="mb-2 pb-1">
                                        <h2 className="text-2xl font-bold text-gray-900">{selectedVolunteer.first_name} {selectedVolunteer.last_name}</h2>
                                        <p className="text-[#ae2b2b] font-mono font-bold tracking-wider">{selectedVolunteer.ilj_id}</p>
                                    </div>
                                </div>
                                <button
                                    onClick={() => setSelectedVolunteer(null)}
                                    className="absolute top-4 right-4 p-2 bg-white/20 hover:bg-white/40 text-white rounded-full transition-colors backdrop-blur-md"
                                >
                                    <X className="h-6 w-6" />
                                </button>
                            </div>

                            {/* Modal Content */}
                            <div className="flex-1 overflow-y-auto p-8 pt-16">
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                                    <section className="space-y-6">
                                        <div>
                                            <h3 className="flex items-center gap-2 text-sm font-bold text-gray-400 uppercase tracking-widest mb-4">
                                                <User className="h-4 w-4" /> Personal Info
                                            </h3>
                                            <div className="bg-gray-50 rounded-2xl p-4 space-y-4">
                                                <DetailItem label="Full Name" value={`${selectedVolunteer.first_name} ${selectedVolunteer.middle_name || ''} ${selectedVolunteer.last_name}`} />
                                                <div className="grid grid-cols-2 gap-4">
                                                    <DetailItem label="Gender" value={selectedVolunteer.gender} />
                                                    <DetailItem label="Age" value={selectedVolunteer.age} />
                                                </div>
                                                <DetailItem label="District" value={selectedVolunteer.district} />
                                                <DetailItem label="City" value={selectedVolunteer.city} />
                                            </div>
                                        </div>

                                        <div>
                                            <h3 className="flex items-center gap-2 text-sm font-bold text-gray-400 uppercase tracking-widest mb-4">
                                                <Phone className="h-4 w-4" /> Contact Detail
                                            </h3>
                                            <div className="bg-gray-50 rounded-2xl p-4 space-y-4">
                                                <DetailItem icon={Mail} label="Email Address" value={selectedVolunteer.email} />
                                                <DetailItem icon={Phone} label="Mobile Number" value={selectedVolunteer.mobile_number} />
                                            </div>
                                        </div>
                                    </section>

                                    <section className="space-y-6">
                                        <div>
                                            <h3 className="flex items-center gap-2 text-sm font-bold text-gray-400 uppercase tracking-widest mb-4">
                                                <Award className="h-4 w-4" /> Volunteering Profile
                                            </h3>
                                            <div className="bg-[#ae2b2b]/5 border border-[#ae2b2b]/10 rounded-2xl p-4 space-y-4">
                                                <div className="flex items-start gap-4">
                                                    <div className="p-2 bg-[#ae2b2b] text-white rounded-lg">
                                                        <Heart className="h-4 w-4" />
                                                    </div>
                                                    <div>
                                                        <p className="text-xs text-gray-500 font-bold uppercase">Preference for Your Team</p>
                                                        <p className="text-lg font-bold text-[#ae2b2b]">
                                                            {getPreferenceLevel(selectedVolunteer) === 1 ? 'Primary (1st)' :
                                                                getPreferenceLevel(selectedVolunteer) === 2 ? 'Secondary (2nd)' : 'Tertiary (3rd)'} Choice
                                                        </p>
                                                    </div>
                                                </div>
                                                <DetailItem label="Availability" value={selectedVolunteer.availability_days} />
                                                <DetailItem label="Time Commitment" value={selectedVolunteer.time_commitment} />
                                                <DetailItem label="Mode" value={selectedVolunteer.participation_mode} />
                                            </div>
                                        </div>

                                        <div>
                                            <h3 className="flex items-center gap-2 text-sm font-bold text-gray-400 uppercase tracking-widest mb-4">
                                                <GraduationCap className="h-4 w-4" /> Background
                                            </h3>
                                            <div className="bg-gray-50 rounded-2xl p-4 space-y-4">
                                                <DetailItem label="Occupation" value={selectedVolunteer.occupation} />
                                                <DetailItem label="Qualification" value={selectedVolunteer.qualification} />
                                                <div>
                                                    <p className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">Skills</p>
                                                    <div className="flex flex-wrap gap-2">
                                                        {selectedVolunteer.skills?.split(',').map((s, i) => (
                                                            <span key={i} className="px-3 py-1 bg-white text-gray-600 text-xs font-medium rounded-full border border-gray-200 shadow-sm">
                                                                {s.trim()}
                                                            </span>
                                                        ))}
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </section>
                                </div>

                                <div className="mt-8 pt-6 border-t border-gray-100 flex justify-between items-center">
                                    <div className="flex items-center gap-2 text-gray-400 italic text-sm">
                                        <Clock className="h-4 w-4" />
                                        Joined on {new Date(selectedVolunteer.created_at).toLocaleDateString()}
                                    </div>
                                    <button
                                        onClick={() => setSelectedVolunteer(null)}
                                        className="px-8 py-3 bg-[#ae2b2b] text-white rounded-2xl font-bold shadow-lg hover:shadow-red-900/20 transition-all hover:-translate-y-0.5"
                                    >
                                        Close Details
                                    </button>
                                </div>
                            </div>
                        </motion.div>
                    </div>
                )}
            </AnimatePresence>
        </div>
    );
}

const DetailItem = ({ icon: Icon, label, value }) => {
    if (!value) return null;
    return (
        <div className="flex items-start gap-3">
            {Icon && <Icon className="h-4 w-4 text-gray-400 mt-0.5" />}
            <div>
                <p className="text-[10px] text-gray-400 font-bold uppercase tracking-wider">{label}</p>
                <p className="text-gray-900 font-medium">{value}</p>
            </div>
        </div>
    );
};
