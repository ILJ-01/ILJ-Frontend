import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import {
    Users, Award, TrendingUp, ChevronRight, Clock,
    CheckCircle2, AlertCircle, Search, Filter
} from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

const AdminAppraisals = () => {
    const [volunteers, setVolunteers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');
    const [filterByEligible, setFilterByEligible] = useState(true);

    const RANKS = [
        { title: "Intern", minHours: 0, order: 0 },
        { title: "Associate", minHours: 20, order: 1 },
        { title: "Assistant Manager", minHours: 100, order: 2 },
        { title: "Manager", minHours: 500, order: 3 },
        { title: "Senior Manager", minHours: 1000, order: 4 },
        { title: "Associate Director", minHours: 2000, order: 5 },
        { title: "Director", minHours: 4000, order: 6 }
    ];

    useEffect(() => {
        fetchPromotionData();
    }, []);

    const fetchPromotionData = async () => {
        setLoading(true);
        try {
            // 1. Fetch all volunteers
            const { data: volData, error: volError } = await supabase
                .from('volunteers')
                .select('id, first_name, last_name, ilj_id, rank, email');

            if (volError) throw volError;

            // 2. Fetch total approved hours for each volunteer
            const { data: hourData, error: hourError } = await supabase
                .from('timesheets')
                .select('volunteer_id, hours')
                .eq('status', 'approved');

            if (hourError) throw hourError;

            // 3. Aggregate hours
            const hourMap = hourData.reduce((acc, curr) => {
                acc[curr.volunteer_id] = (acc[curr.volunteer_id] || 0) + Number(curr.hours);
                return acc;
            }, {});

            // 4. Combine and calculate eligibility
            const combined = volData.map(v => {
                const totalHours = hourMap[v.id] || 0;
                const currentRank = v.rank || "Intern";

                // Find highest rank they are eligible for
                let eligibleRank = RANKS[0];
                for (let i = RANKS.length - 1; i >= 0; i--) {
                    if (totalHours >= RANKS[i].minHours) {
                        eligibleRank = RANKS[i];
                        break;
                    }
                }

                const currentRankObj = RANKS.find(r => r.title === currentRank) || RANKS[0];
                const isEligible = eligibleRank.order > currentRankObj.order;

                return {
                    ...v,
                    totalHours,
                    currentRank,
                    eligibleRank: eligibleRank.title,
                    isEligible,
                    nextRank: isEligible ? eligibleRank.title : null
                };
            });

            setVolunteers(combined);
        } catch (error) {
            console.error('Error fetching promotion data:', error);
        } finally {
            setLoading(false);
        }
    };

    const handlePromote = async (volunteerId, newRank) => {
        if (!window.confirm(`Are you sure you want to promote this volunteer to ${newRank}?`)) return;

        try {
            const { error } = await supabase
                .from('volunteers')
                .update({ rank: newRank })
                .eq('id', volunteerId);

            if (error) throw error;

            // Update local state
            setVolunteers(prev => prev.map(v =>
                v.id === volunteerId
                    ? { ...v, currentRank: newRank, isEligible: false }
                    : v
            ));

            alert(`Successfully promoted to ${newRank}!`);
        } catch (error) {
            alert(`Error promoting volunteer: ${error.message}`);
        }
    };

    const filteredList = volunteers.filter(v => {
        const matchesSearch = `${v.first_name} ${v.last_name} ${v.ilj_id}`.toLowerCase().includes(searchTerm.toLowerCase());
        const matchesFilter = filterByEligible ? v.isEligible : true;
        return matchesSearch && matchesFilter;
    });

    if (loading) {
        return (
            <div className="flex justify-center items-center h-64">
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-[#ae2b2b]"></div>
            </div>
        );
    }

    return (
        <div className="space-y-6">
            {/* Stats Overview */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div className="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm">
                    <div className="flex items-center gap-4">
                        <div className="bg-amber-50 p-3 rounded-xl">
                            <Award className="h-6 w-6 text-amber-600" />
                        </div>
                        <div>
                            <p className="text-sm text-gray-500 font-medium font-serif">Eligible for Promotion</p>
                            <h3 className="text-2xl font-bold text-gray-900">{volunteers.filter(v => v.isEligible).length}</h3>
                        </div>
                    </div>
                </div>
                <div className="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm">
                    <div className="flex items-center gap-4">
                        <div className="bg-green-50 p-3 rounded-xl">
                            <Clock className="h-6 w-6 text-green-600" />
                        </div>
                        <div>
                            <p className="text-sm text-gray-500 font-medium font-serif">Total Volunteering Hours</p>
                            <h3 className="text-2xl font-bold text-gray-900">
                                {Math.round(volunteers.reduce((sum, v) => sum + v.totalHours, 0))}
                            </h3>
                        </div>
                    </div>
                </div>
                <div className="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm">
                    <div className="flex items-center gap-4">
                        <div className="bg-blue-50 p-3 rounded-xl">
                            <Users className="h-6 w-6 text-blue-600" />
                        </div>
                        <div>
                            <p className="text-sm text-gray-500 font-medium font-serif">Total Volunteers</p>
                            <h3 className="text-2xl font-bold text-gray-900">{volunteers.length}</h3>
                        </div>
                    </div>
                </div>
            </div>

            {/* Controls */}
            <div className="flex flex-col md:flex-row gap-4 items-center justify-between bg-white p-4 rounded-2xl border border-gray-200">
                <div className="relative w-full md:w-96">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
                    <input
                        type="text"
                        placeholder="Search by name or ILJ ID..."
                        className="w-full pl-10 pr-4 py-2 border border-gray-200 rounded-xl focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] outline-none transition-all text-sm"
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                    />
                </div>
                <div className="flex items-center gap-2">
                    <button
                        onClick={() => setFilterByEligible(!filterByEligible)}
                        className={`flex items-center gap-2 px-4 py-2 rounded-xl text-sm font-bold transition-all border ${filterByEligible
                            ? 'bg-[#ae2b2b] text-white border-[#ae2b2b]'
                            : 'bg-white text-gray-600 border-gray-200 hover:bg-gray-50'
                            }`}
                    >
                        <TrendingUp className="h-4 w-4" />
                        {filterByEligible ? 'Showing Eligible' : 'Showing All'}
                    </button>
                </div>
            </div>

            {/* Volunteers List */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <AnimatePresence mode="popLayout">
                    {filteredList.map((volunteer) => (
                        <motion.div
                            key={volunteer.id}
                            layout
                            initial={{ opacity: 0, scale: 0.95 }}
                            animate={{ opacity: 1, scale: 1 }}
                            exit={{ opacity: 0, scale: 0.95 }}
                            className="bg-white p-5 rounded-2xl border border-gray-200 shadow-sm hover:shadow-md transition-shadow relative overflow-hidden group"
                        >
                            {volunteer.isEligible && (
                                <div className="absolute top-0 right-0 bg-[#ae2b2b] text-white text-[10px] font-black px-3 py-1 rounded-bl-xl uppercase tracking-widest animate-pulse">
                                    Promotion Ready
                                </div>
                            )}

                            <div className="flex items-start justify-between mb-4">
                                <div className="flex items-center gap-3">
                                    <div className="h-12 w-12 rounded-2xl bg-gradient-to-br from-gray-50 to-gray-100 flex items-center justify-center text-[#ae2b2b] font-serif font-bold text-lg border border-gray-200 shadow-inner">
                                        {volunteer.first_name[0]}{volunteer.last_name[0]}
                                    </div>
                                    <div>
                                        <h4 className="font-bold text-gray-900">{volunteer.first_name} {volunteer.last_name}</h4>
                                        <p className="text-xs text-gray-500 font-medium">#{volunteer.ilj_id}</p>
                                    </div>
                                </div>
                            </div>

                            <div className="space-y-3 mb-5">
                                <div className="flex items-center justify-between text-sm">
                                    <span className="text-gray-500">Current Rank</span>
                                    <span className="px-2 py-0.5 bg-gray-100 text-gray-700 rounded-md font-bold text-[10px] uppercase border border-gray-200">
                                        {volunteer.currentRank}
                                    </span>
                                </div>
                                <div className="flex items-center justify-between text-sm">
                                    <span className="text-gray-500">Total Hours</span>
                                    <span className="text-gray-900 font-bold flex items-center gap-1">
                                        <Clock className="h-3 w-3 text-[#ae2b2b]" />
                                        {Math.round(volunteer.totalHours * 10) / 10}
                                    </span>
                                </div>

                                {volunteer.isEligible && (
                                    <div className="mt-4 pt-4 border-t border-dashed border-gray-200">
                                        <div className="flex items-center gap-2 text-[#ae2b2b] mb-2">
                                            <TrendingUp className="h-4 w-4" />
                                            <span className="text-xs font-bold uppercase tracking-wider text-serif italic">Eligible for {volunteer.nextRank}</span>
                                        </div>
                                        <div className="w-full bg-gray-100 rounded-full h-1.5 overflow-hidden">
                                            <div
                                                className="bg-[#ae2b2b] h-full rounded-full"
                                                style={{ width: '100%' }}
                                            />
                                        </div>
                                    </div>
                                )}
                            </div>

                            {volunteer.isEligible && (
                                <button
                                    onClick={() => handlePromote(volunteer.id, volunteer.nextRank)}
                                    className="w-full bg-[#ae2b2b] text-white py-2.5 rounded-xl font-bold text-sm hover:bg-[#8b1e1e] transition-all shadow-sm flex items-center justify-center gap-2 group-hover:scale-[1.02] active:scale-95"
                                >
                                    <CheckCircle2 className="h-4 w-4" />
                                    Promote to {volunteer.nextRank}
                                </button>
                            )}
                        </motion.div>
                    ))}
                </AnimatePresence>

                {filteredList.length === 0 && (
                    <div className="col-span-full flex flex-col items-center justify-center py-12 text-center bg-gray-50 border-2 border-dashed border-gray-200 rounded-3xl">
                        <AlertCircle className="h-10 w-10 text-gray-300 mb-2" />
                        <p className="text-gray-500 font-medium">No volunteers found matching your criteria</p>
                    </div>
                )}
            </div>
        </div>
    );
};

export default AdminAppraisals;
