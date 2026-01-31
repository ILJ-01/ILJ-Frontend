import { useState, useEffect } from 'react';
import { useAuth } from '@/context/AuthContext';
import { supabase } from '@/lib/supabase';
import { motion, useMotionValue, useTransform, useSpring } from 'framer-motion';
import { format } from 'date-fns';
import {
    User, Mail, Phone, MapPin, Briefcase,
    GraduationCap, Heart, Shield, Award, Sparkles, Layers,
    Calendar, CheckCircle2, RotateCw, Edit2, Save
} from 'lucide-react';
import { cn } from '@/lib/utils';

// Note: Assuming these components exist as they were used in the original Profile.jsx
// If not, standard HTML/Tailwind fallbacks are provided in the logic below where possible
// but for consistency we try to reuse them if the project has them.
// We will use standard HTML/Divs for cards to ensure no missing dependency errors if those UI components aren't perfectly set up in the new path context, 
// but styling them to match.

const Badge3D = ({ user }) => {
    const [isFlipped, setIsFlipped] = useState(false);
    const x = useMotionValue(0);
    const y = useMotionValue(0);
    const rotateX = useTransform(y, [-100, 100], [20, -20]);
    const rotateY = useTransform(x, [-100, 100], [-20, 20]);

    const springConfig = { damping: 20, stiffness: 200 };
    const rotateXSpring = useSpring(rotateX, springConfig);
    const rotateYSpring = useSpring(rotateY, springConfig);

    function handleMouseMove(event) {
        const rect = event.currentTarget.getBoundingClientRect();
        const width = rect.width;
        const height = rect.height;
        const mouseX = event.clientX - rect.left;
        const mouseY = event.clientY - rect.top;
        const xPct = mouseX / width - 0.5;
        const yPct = mouseY / height - 0.5;
        x.set(xPct * 200);
        y.set(yPct * 200);
    }

    function handleMouseLeave() {
        x.set(0); y.set(0);
    }

    const initials = `${user.first_name?.[0] || ''}${user.last_name?.[0] || ''}`.toUpperCase();

    return (
        <div className="perspective-container flex flex-col items-center gap-1 w-full" style={{ perspective: "1000px" }}>
            <motion.div
                style={{ rotateX: rotateXSpring, rotateY: rotateYSpring, transformStyle: "preserve-3d" }}
                onMouseMove={handleMouseMove}
                onMouseLeave={handleMouseLeave}
                onClick={() => setIsFlipped(!isFlipped)}
                className="relative w-full aspect-[1.586/1] cursor-pointer group shadow-xl hover:shadow-2xl transition-shadow rounded-2xl"
            >
                <motion.div
                    animate={{ rotateY: isFlipped ? 180 : 0 }}
                    transition={{ duration: 0.6, type: "spring", stiffness: 260, damping: 20 }}
                    style={{ transformStyle: "preserve-3d" }}
                    className="w-full h-full relative rounded-2xl"
                >
                    {/* FRONT */}
                    <div className="absolute inset-0 backface-hidden rounded-2xl overflow-hidden" style={{ backfaceVisibility: 'hidden' }}>
                        <div className="absolute inset-0 rounded-2xl p-[2px] bg-gradient-to-tr from-gray-300 via-white to-gray-300 shadow-2xl">
                            <div className="h-full w-full bg-gradient-to-br from-[#ae2b2b] via-[#8b1e1e] to-[#5c1212] rounded-[14px] p-6 flex flex-col justify-between text-white relative overflow-hidden">
                                <div className="absolute inset-0 z-50 opacity-0 group-hover:opacity-30 transition-opacity duration-500 pointer-events-none" style={{ background: 'linear-gradient(105deg, transparent 40%, rgba(255, 255, 255, 0.8) 45%, rgba(255, 255, 255, 0.1) 50%, transparent 54%)', mixBlendMode: 'overlay' }} />
                                <div className="absolute inset-0 opacity-10" style={{ backgroundImage: 'radial-gradient(circle at 2px 2px, white 1px, transparent 0)', backgroundSize: '24px 24px' }}></div>
                                <div className="absolute top-0 right-0 p-8 opacity-10 transform translate-x-1/3 -translate-y-1/3"><Shield size={200} /></div>

                                <div className="relative z-10 flex justify-between items-start">
                                    <div className="flex items-center gap-3">
                                        <div className="w-10 h-10 bg-white/20 backdrop-blur-md rounded-lg flex items-center justify-center border border-white/20"><Shield className="text-white" size={24} /></div>
                                        <div><p className="text-[10px] tracking-[0.2em] font-medium opacity-80 uppercase">Volunteer Pass</p><p className="text-sm font-bold font-serif">I Love Jinshasan</p></div>
                                    </div>
                                    <div className="bg-white/10 backdrop-blur-md px-3 py-1 rounded-full border border-white/20 shadow-inner"><span className="text-xs font-mono font-bold tracking-wider">{user.ilj_id}</span></div>
                                </div>

                                <div className="relative z-10 flex items-center gap-5 mt-4">
                                    <div className="h-20 w-20 rounded-xl bg-gradient-to-br from-white to-gray-200 shadow-lg flex items-center justify-center text-[#ae2b2b] font-serif font-bold text-3xl border-2 border-white/30 truncate">{initials}</div>
                                    <div><h2 className="text-xl font-bold leading-tight drop-shadow-sm">{user.first_name} {user.last_name}</h2><p className="text-xs text-red-100 mt-1 flex items-center gap-1">{user.occupation || 'Volunteer'}</p></div>
                                </div>

                                <div className="relative z-10 flex justify-between items-end mt-2">
                                    <div><p className="text-[9px] uppercase tracking-wider opacity-60">Member Since</p><p className="text-xs font-medium font-mono">{format(new Date(user.created_at || Date.now()), 'MMM yyyy')}</p></div>
                                    <div><p className="text-[9px] uppercase tracking-wider opacity-60 text-right">Status</p><div className="flex items-center gap-1.5 bg-green-500/20 px-2 py-0.5 rounded-full border border-green-400/30"><span className="relative flex h-2 w-2"><span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-green-400 opacity-75"></span><span className="relative inline-flex rounded-full h-2 w-2 bg-green-400"></span></span><span className="text-[10px] font-bold text-green-300">ACTIVE</span></div></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    {/* BACK */}
                    <div className="absolute inset-0 rounded-2xl overflow-hidden" style={{ backfaceVisibility: 'hidden', transform: 'rotateY(180deg)' }}>
                        <div className="absolute inset-0 rounded-2xl p-[2px] bg-gradient-to-bl from-gray-300 via-white to-gray-300 shadow-xl">
                            <div className="h-full w-full bg-gradient-to-br from-gray-100 via-white to-gray-300 rounded-[14px] flex items-center justify-center relative overflow-hidden">
                                <div className="absolute inset-0 opacity-40" style={{ backgroundImage: 'linear-gradient(45deg, transparent 45%, rgba(255,255,255,0.8) 50%, transparent 55%)', backgroundSize: '200% 200%' }}></div>
                                <div className="absolute inset-0 opacity-5" style={{ backgroundImage: 'radial-gradient(circle at center, black 1px, transparent 0)', backgroundSize: '16px 16px' }}></div>
                                <div className="relative z-10 text-center transform hover:scale-105 transition-transform duration-500">
                                    <p className="text-4xl md:text-5xl font-serif font-bold text-gray-800 drop-shadow-sm flex items-center justify-center gap-2">I <Heart className="inline w-10 h-10 md:w-12 md:h-12 text-red-600 fill-red-600 drop-shadow-md mx-2" /></p>
                                    <p className="text-3xl md:text-4xl font-serif font-bold text-[#ae2b2b] mt-2 tracking-wide drop-shadow-sm">Jinshasan</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </motion.div>
            </motion.div>
            <p className="text-xs text-gray-400 flex items-center gap-1 animate-pulse"><RotateCw size={12} /> Click card to flip</p>
        </div>
    );
};

const InfoItem = ({ icon: Icon, label, value, delay, isEditing, field, onChange, type = "text", options = [] }) => (
    <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} transition={{ delay, duration: 0.4 }} className="flex items-center p-3 rounded-lg bg-gray-50 hover:bg-gray-100 transition-colors border border-transparent hover:border-gray-200">
        <div className="p-2 mr-4 bg-white rounded-full shadow-sm text-[#ae2b2b]"><Icon size={18} /></div>
        <div className="flex-1">
            <p className="text-xs font-medium text-gray-500 uppercase tracking-wider">{label}</p>
            {isEditing ? (
                type === "select" ? (
                    <select className="w-full mt-1 p-1 border rounded text-sm bg-white focus:ring-1 focus:ring-gray-400 border-gray-300 focus:outline-none" value={value} onChange={(e) => onChange(field, e.target.value)}>
                        <option value="">Select...</option>
                        {options.map(opt => <option key={opt} value={opt}>{opt}</option>)}
                    </select>
                ) : (
                    <input className="w-full mt-1 p-1 border rounded text-sm bg-white focus:ring-1 focus:ring-gray-400 border-gray-300 focus:outline-none" type={type} value={value} onChange={(e) => onChange(field, e.target.value)} />
                )
            ) : (
                <p className="text-sm font-semibold text-gray-800 truncate" title={value}>{value || 'N/A'}</p>
            )}
        </div>
    </motion.div>
);

export default function ProfilePage() {
    const { user, refreshUser } = useAuth();
    const [isEditing, setIsEditing] = useState(false);

    const [saving, setSaving] = useState(false);
    const [stats, setStats] = useState({ totalHours: 0, eventsCount: 0 });

    // Form State
    const [formData, setFormData] = useState({});

    // Hardcoded options for now, can be fetched if needed
    const preferenceOptions = [
        "Teaching", "Event Management", "Content Creation", "Technical Support",
        "Social Media", "Fundraising", "Community Outreach", "Design", "Medical",
        "Legal", "Other"
    ];

    useEffect(() => {
        if (user) {
            fetchStats();
            setFormData({
                mobile_number: user.mobile_number || "",
                skills: user.skills || "",
                availability_days: user.availability_days || "Flexible",
                participation_mode: user.participation_mode || "Voluntary (Seva-based)",
                hobbies: user.hobbies || "",
                occupation: user.occupation || "",

                // Preferences
                volunteering_preference1: user.volunteering_preference1 || "",
                volunteering_preference2: user.volunteering_preference2 || "",
                volunteering_preference3: user.volunteering_preference3 || "",

                // Address fields
                address_line1: user.address_line1 || "",
                city: user.city || "",
                state: user.state || "",
                pincode: user.pincode || ""
            });
        }
    }, [user]);

    const handleUpdate = (field, value) => {
        setFormData(prev => ({ ...prev, [field]: value }));
    };

    const fetchStats = async () => {
        try {
            const [timesheetRes, eventsRes] = await Promise.all([
                supabase.from('timesheets').select('hours').eq('volunteer_id', user.id).eq('status', 'approved'),
                supabase.from('event_interests').select('id', { count: 'exact', head: true }).eq('volunteer_id', user.id)
            ]);

            const hours = timesheetRes.data?.reduce((acc, curr) => acc + (Number(curr.hours) || 0), 0) || 0;
            const events = eventsRes.count || 0;

            setStats({ totalHours: hours, eventsCount: events });
        } catch (error) {
            console.error("Error fetching stats:", error);
        }
    };

    const handleSave = async () => {
        setSaving(true);
        try {
            const { error } = await supabase
                .from('volunteers')
                .update(formData)
                .eq('id', user.id);

            if (error) throw error;

            await refreshUser();
            setIsEditing(false);
            alert("Profile updated!");
        } catch (err) {
            console.error("Profile Save Error:", err);
            alert("Failed to save profile.");
        } finally {
            setSaving(false);
        }
    };

    if (!user) return null;

    const sections = [
        {
            title: "Contact Details",
            icon: Phone,
            items: [
                { icon: Mail, label: "Email", value: user.email, isRaw: true }, // ReadOnly
                { icon: Phone, label: "Mobile", value: formData.mobile_number, isEditing: isEditing, field: 'mobile_number', onChange: handleUpdate }
            ]
        },
        {
            title: "Personal Info",
            icon: User,
            items: [
                { icon: User, label: "Full Name", value: `${user.first_name} ${user.middle_name || ''} ${user.last_name}`, isRaw: true },
                { icon: Calendar, label: "DOB", value: user.dob ? format(new Date(user.dob), 'MMMM d, yyyy') : 'N/A', isRaw: true },
                { icon: User, label: "Gender", value: user.gender, isRaw: true },
            ]
        },
        {
            title: "Volunteering Preferences",
            icon: Heart,
            items: [
                { icon: CheckCircle2, label: "1st Preference", value: formData.volunteering_preference1, isEditing: isEditing, field: 'volunteering_preference1', onChange: handleUpdate, type: "select", options: preferenceOptions },
                { icon: CheckCircle2, label: "2nd Preference", value: formData.volunteering_preference2, isEditing: isEditing, field: 'volunteering_preference2', onChange: handleUpdate, type: "select", options: preferenceOptions },
                { icon: CheckCircle2, label: "3rd Preference", value: formData.volunteering_preference3, isEditing: isEditing, field: 'volunteering_preference3', onChange: handleUpdate, type: "select", options: preferenceOptions },
            ]
        }
    ];

    return (
        <div className="min-h-screen bg-[#f8f9fa] pt-0 md:pt-4 px-0 md:px-0 font-sans">
            <div className="max-w-7xl mx-auto grid grid-cols-1 lg:grid-cols-12 gap-8">

                {/* Left: Badge & Stats */}
                <motion.div initial={{ opacity: 0, x: -20 }} animate={{ opacity: 1, x: 0 }} transition={{ duration: 0.6 }} className="lg:col-span-4 space-y-6">
                    <div className="perspective-container flex justify-center lg:block w-full">
                        <Badge3D user={user} />
                    </div>

                    <div className="bg-white rounded-xl shadow-md border-none overflow-hidden">
                        <div className="p-4 border-b border-gray-100 bg-gray-50"><h3 className="text-lg font-serif font-bold text-gray-800">Quick Stats</h3></div>
                        <div className="p-4 grid grid-cols-2 gap-4">
                            <div className="bg-[#ae2b2b]/5 p-4 rounded-xl text-center border border-[#ae2b2b]/10">
                                <p className="text-2xl font-bold text-[#ae2b2b]">{stats.totalHours}</p>
                                <p className="text-xs text-gray-500 uppercase tracking-wide mt-1">Total Hours</p>
                            </div>
                            <div className="bg-gray-50 p-4 rounded-xl text-center border border-gray-200">
                                <p className="text-2xl font-bold text-gray-800">{stats.eventsCount}</p>
                                <p className="text-xs text-gray-500 uppercase tracking-wide mt-1">Events</p>
                            </div>



                            <div className="col-span-2 bg-gray-50 p-4 rounded-xl flex items-center justify-between">
                                <div className="text-left w-full">
                                    <p className="text-xs text-gray-500 uppercase">Participation Mode</p>
                                    {isEditing ? (
                                        <select className="w-full mt-1 text-sm border p-1 rounded" value={formData.participation_mode} onChange={e => handleUpdate('participation_mode', e.target.value)}>
                                            <option>Voluntary (Seva-based)</option>
                                            <option>Paid Basis (Project or Role-based)</option>
                                            <option>Flexible / Open to Discussion</option>
                                        </select>
                                    ) : (
                                        <p className="font-semibold text-gray-800 text-sm truncate">{formData.participation_mode || 'N/A'}</p>
                                    )}
                                </div>
                            </div>
                        </div>
                    </div>
                </motion.div>

                {/* Right: Details */}
                <div className="lg:col-span-8 space-y-6">
                    <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                        <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.2, duration: 0.6 }}>
                            <h1 className="text-3xl md:text-4xl font-serif font-bold text-gray-900">
                                <span className="text-[#ae2b2b]">Hello,</span> {user.first_name}
                            </h1>
                            <p className="text-gray-500 text-lg">Manage your profile details below.</p>
                        </motion.div>
                        <button
                            onClick={() => isEditing ? handleSave() : setIsEditing(true)}
                            disabled={saving}
                            className={`flex items-center gap-2 px-6 py-2.5 rounded-full font-medium shadow-md transition-all
                                ${isEditing
                                    ? 'bg-green-600 hover:bg-green-700 text-white'
                                    : 'bg-white text-gray-700 border border-gray-200 hover:border-gray-400 hover:text-gray-900'
                                }
                            `}
                        >
                            {isEditing ? (
                                <>
                                    {saving ? <RotateCw className="h-4 w-4 animate-spin" /> : <Save className="h-4 w-4" />}
                                    Save Changes
                                </>
                            ) : (
                                <>
                                    <Edit2 className="h-4 w-4" /> Edit Profile
                                </>
                            )}
                        </button>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                        {/* Dynamic Sections */}
                        {sections.map((section, idx) => (
                            <motion.div key={section.title} initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.3 + (idx * 0.1), duration: 0.5 }}>
                                <div className="h-full bg-white rounded-xl border border-gray-100 shadow-sm hover:shadow-md transition-shadow">
                                    <div className="p-4 border-b border-gray-100 bg-gray-50/50 flex items-center gap-2">
                                        <section.icon className="h-5 w-5 text-[#ae2b2b]" />
                                        <h3 className="font-bold text-gray-800">{section.title}</h3>
                                    </div>
                                    <div className="p-4 space-y-3">
                                        {section.items.map((item, i) => (
                                            <InfoItem
                                                key={i}
                                                {...item}
                                                isEditing={item.isEditing} // Pass specific edit flag
                                                field={item.field}
                                                onChange={item.onChange}
                                            />
                                        ))}
                                    </div>
                                </div>
                            </motion.div>
                        ))}

                        {/* Professional (Kept separate or merge?) - User asked for preferences, let's keep professional simple */}
                        <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.6, duration: 0.5 }}>
                            <div className="h-full bg-white rounded-xl border border-gray-100 shadow-sm hover:shadow-md transition-shadow">
                                <div className="p-4 border-b border-gray-100 bg-gray-50/50 flex items-center gap-2">
                                    <Briefcase className="h-5 w-5 text-[#ae2b2b]" />
                                    <h3 className="font-bold text-gray-800">Professional</h3>
                                </div>
                                <div className="p-4 space-y-3">
                                    <InfoItem icon={GraduationCap} label="Qualification" value={user.qualification} isRaw={true} />
                                    <InfoItem icon={Briefcase} label="Occupation" value={user.occupation} isRaw={true} />
                                </div>
                            </div>
                        </motion.div>

                        {/* Skills & Hobbies */}
                        <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.7 }} className="md:col-span-2">
                            <div className="bg-white rounded-xl border border-gray-100 shadow-sm p-6 mb-6">
                                <h3 className="flex items-center gap-2 font-bold text-gray-800 mb-4 border-b pb-2">
                                    <Award className="h-5 w-5 text-[#ae2b2b]" /> Interests & Skills
                                </h3>
                                <div className="space-y-4">
                                    <div>
                                        <p className="text-sm font-medium text-gray-500 mb-2 uppercase">Hobbies</p>
                                        {isEditing ? (
                                            <textarea className="w-full border p-2 rounded text-sm focus:ring-1 focus:ring-gray-400 focus:outline-none" rows="2" value={formData.hobbies} onChange={e => handleUpdate('hobbies', e.target.value)} />
                                        ) : (
                                            <div className="flex flex-wrap gap-2">
                                                {formData.hobbies?.split(',').filter(Boolean).map((h, i) => <span key={i} className="px-3 py-1 bg-white border border-gray-200 rounded-full text-sm text-gray-700 shadow-sm">{h.trim()}</span>)}
                                                {!formData.hobbies && <span className="text-gray-400 italic text-sm">No hobbies listed</span>}
                                            </div>
                                        )}
                                    </div>
                                    <div className="h-px bg-gray-100"></div>
                                    <div>
                                        <p className="text-sm font-medium text-gray-500 mb-2 uppercase">Skills</p>
                                        {isEditing ? (
                                            <textarea className="w-full border p-2 rounded text-sm focus:ring-1 focus:ring-gray-400 focus:outline-none" rows="2" value={formData.skills} onChange={e => handleUpdate('skills', e.target.value)} />
                                        ) : (
                                            <div className="flex flex-wrap gap-2">
                                                {formData.skills?.split(',').filter(Boolean).map((s, i) => <span key={i} className="px-3 py-1 bg-red-50 text-[#ae2b2b] border border-red-100 rounded-full text-sm font-medium shadow-sm">{s.trim()}</span>)}
                                                {!formData.skills && <span className="text-gray-400 italic text-sm">No skills listed</span>}
                                            </div>
                                        )}
                                    </div>
                                </div>
                            </div>

                            {/* Address Card */}
                            <div className="bg-white rounded-xl border border-gray-100 shadow-sm p-6">
                                <div className="flex items-start gap-4">
                                    <div className="p-3 bg-red-50 rounded-full text-[#ae2b2b] shrink-0"><MapPin size={24} /></div>
                                    <div className="flex-1">
                                        <h3 className="font-serif font-bold text-gray-900 text-lg mb-1">Residential Address</h3>
                                        {isEditing ? (
                                            <div className="grid grid-cols-1 md:grid-cols-2 gap-3 mt-2">
                                                <input placeholder="Address Line 1" className="border p-2 rounded text-sm" value={formData.address_line1} onChange={e => handleUpdate('address_line1', e.target.value)} />
                                                <input placeholder="City" className="border p-2 rounded text-sm" value={formData.city} onChange={e => handleUpdate('city', e.target.value)} />
                                                <input placeholder="State" className="border p-2 rounded text-sm" value={formData.state} onChange={e => handleUpdate('state', e.target.value)} />
                                                <input placeholder="Pincode" className="border p-2 rounded text-sm" value={formData.pincode} onChange={e => handleUpdate('pincode', e.target.value)} />
                                            </div>
                                        ) : (
                                            <p className="text-gray-600 leading-relaxed">
                                                {formData.address_line1}, <br />
                                                {formData.city}, {formData.state} - {formData.pincode}
                                            </p>
                                        )}
                                    </div>
                                </div>
                            </div>
                        </motion.div>
                    </div>
                </div>
            </div>
        </div>
    );
}
