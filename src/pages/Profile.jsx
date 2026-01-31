import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '@/context/AuthContext';
import { motion, useMotionValue, useTransform, useSpring } from 'framer-motion';
import { format } from 'date-fns';
import {
    User, Mail, Phone, MapPin, Briefcase,
    GraduationCap, Heart, LogOut, Shield, Award, Sparkles, Layers,
    Calendar, CheckCircle2, RotateCw
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Separator } from '@/components/ui/separator';

const InfoItem = ({ icon: Icon, label, value, delay }) => (
    <motion.div
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay, duration: 0.4 }}
        className="flex items-center p-3 rounded-lg bg-gray-50 hover:bg-red-50/30 transition-colors border border-transparent hover:border-red-100"
    >
        <div className="p-2 mr-4 bg-white rounded-full shadow-sm text-[#ae2b2b]">
            <Icon size={18} />
        </div>
        <div className="flex-1 overflow-hidden">
            <p className="text-xs font-medium text-gray-500 uppercase tracking-wider">{label}</p>
            <p className="text-sm font-semibold text-gray-800 truncate" title={value}>{value || 'N/A'}</p>
        </div>
    </motion.div>
);

const Badge3D = ({ user }) => {
    const [isFlipped, setIsFlipped] = useState(false);

    // Mouse Tilt Values
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
        x.set(0);
        y.set(0);
    }

    const initials = `${user.first_name?.[0] || ''}${user.last_name?.[0] || ''}`.toUpperCase();

    return (
        <div className="perspective-container flex flex-col items-center gap-1">
            <motion.div
                style={{
                    rotateX: rotateXSpring,
                    rotateY: rotateYSpring,
                    transformStyle: "preserve-3d"
                }}
                onMouseMove={handleMouseMove}
                onMouseLeave={handleMouseLeave}
                onClick={() => setIsFlipped(!isFlipped)}
                className="relative w-full max-w-sm aspect-[1.586/1] cursor-pointer group"
            >
                {/* Metallic Edge Effect (Applied to container to frame both sides) */}
                <motion.div
                    animate={{ rotateY: isFlipped ? 180 : 0 }}
                    transition={{ duration: 0.6, type: "spring", stiffness: 260, damping: 20 }}
                    style={{ transformStyle: "preserve-3d" }}
                    className="w-full h-full relative rounded-2xl"
                >
                    {/* FRONT FACE */}
                    <div
                        className="absolute inset-0 backface-hidden rounded-2xl overflow-hidden"
                        style={{ backfaceVisibility: 'hidden' }}
                    >
                        {/* Metallic Border Container */}
                        <div className="absolute inset-0 rounded-2xl p-[2px] bg-gradient-to-tr from-gray-300 via-white to-gray-300 shadow-2xl">
                            {/* Card Content */}
                            <div className="h-full w-full bg-gradient-to-br from-[#ae2b2b] via-[#8b1e1e] to-[#5c1212] rounded-[14px] p-6 flex flex-col justify-between text-white relative overflow-hidden">

                                {/* Glossy Reflection */}
                                <div
                                    className="absolute inset-0 z-50 opacity-0 group-hover:opacity-30 transition-opacity duration-500 pointer-events-none"
                                    style={{
                                        background: 'linear-gradient(105deg, transparent 40%, rgba(255, 255, 255, 0.8) 45%, rgba(255, 255, 255, 0.1) 50%, transparent 54%)',
                                        mixBlendMode: 'overlay',
                                    }}
                                />

                                {/* Background Pattern */}
                                <div className="absolute inset-0 opacity-10"
                                    style={{ backgroundImage: 'radial-gradient(circle at 2px 2px, white 1px, transparent 0)', backgroundSize: '24px 24px' }}
                                ></div>

                                <div className="absolute top-0 right-0 p-8 opacity-10 transform translate-x-1/3 -translate-y-1/3">
                                    <Shield size={200} />
                                </div>

                                {/* Header */}
                                <div className="relative z-10 flex justify-between items-start">
                                    <div className="flex items-center gap-3">
                                        <div className="w-10 h-10 bg-white/20 backdrop-blur-md rounded-lg flex items-center justify-center border border-white/20">
                                            <Shield className="text-white" size={24} />
                                        </div>
                                        <div>
                                            <p className="text-[10px] tracking-[0.2em] font-medium opacity-80 uppercase">Volunteer Pass</p>
                                            <p className="text-sm font-bold font-serif">I Love Jinshasan</p>
                                        </div>
                                    </div>
                                    <div className="bg-white/10 backdrop-blur-md px-3 py-1 rounded-full border border-white/20 shadow-inner">
                                        <span className="text-xs font-mono font-bold tracking-wider">{user.ilj_id}</span>
                                    </div>
                                </div>

                                {/* Main Identity */}
                                <div className="relative z-10 flex items-center gap-5 mt-4">
                                    <div className="h-20 w-20 rounded-xl bg-gradient-to-br from-white to-gray-200 shadow-lg flex items-center justify-center text-[#ae2b2b] font-serif font-bold text-3xl border-2 border-white/30 truncate">
                                        {initials}
                                    </div>
                                    <div>
                                        <h2 className="text-xl font-bold leading-tight drop-shadow-sm">{user.first_name} {user.last_name}</h2>
                                        <p className="text-xs text-red-100 mt-1 flex items-center gap-1">
                                            <StarIcon className="w-3 h-3 text-yellow-400 fill-yellow-400" />
                                            {user.occupation || 'Volunteer'}
                                        </p>
                                    </div>
                                </div>

                                {/* Footer */}
                                <div className="relative z-10 flex justify-between items-end mt-2">
                                    <div>
                                        <p className="text-[9px] uppercase tracking-wider opacity-60">Member Since</p>
                                        <p className="text-xs font-medium font-mono">{format(new Date(user.created_at || Date.now()), 'MMM yyyy')}</p>
                                    </div>
                                    <div>
                                        <p className="text-[9px] uppercase tracking-wider opacity-60 text-right">Status</p>
                                        <div className="flex items-center gap-1.5 bg-green-500/20 px-2 py-0.5 rounded-full border border-green-400/30">
                                            <span className="relative flex h-2 w-2">
                                                <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-green-400 opacity-75"></span>
                                                <span className="relative inline-flex rounded-full h-2 w-2 bg-green-400"></span>
                                            </span>
                                            <span className="text-[10px] font-bold text-green-300">ACTIVE</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    {/* BACK FACE */}
                    <div
                        className="absolute inset-0 rounded-2xl overflow-hidden"
                        style={{
                            backfaceVisibility: 'hidden',
                            transform: 'rotateY(180deg)'
                        }}
                    >
                        {/* Metallic Border Container Back */}
                        <div className="absolute inset-0 rounded-2xl p-[2px] bg-gradient-to-bl from-gray-300 via-white to-gray-300 shadow-xl">
                            <div className="h-full w-full bg-gradient-to-br from-gray-100 via-white to-gray-300 rounded-[14px] flex items-center justify-center relative overflow-hidden">
                                {/* Metal Shine Effect */}
                                <div className="absolute inset-0 opacity-40"
                                    style={{
                                        backgroundImage: 'linear-gradient(45deg, transparent 45%, rgba(255,255,255,0.8) 50%, transparent 55%)',
                                        backgroundSize: '200% 200%',
                                    }}
                                ></div>

                                {/* Subtle Texture */}
                                <div className="absolute inset-0 opacity-5"
                                    style={{ backgroundImage: 'radial-gradient(circle at center, black 1px, transparent 0)', backgroundSize: '16px 16px' }}
                                ></div>

                                <div className="relative z-10 text-center transform hover:scale-105 transition-transform duration-500">
                                    <motion.p
                                        className="text-4xl md:text-5xl font-serif font-bold text-gray-800 drop-shadow-sm flex items-center justify-center gap-2"
                                        animate={{ scale: [1, 1.1, 1] }}
                                        transition={{ duration: 2, repeat: Infinity }}
                                    >
                                        I <Heart className="inline w-10 h-10 md:w-12 md:h-12 text-red-600 fill-red-600 drop-shadow-md mx-2" />
                                    </motion.p>
                                    <p className="text-3xl md:text-4xl font-serif font-bold text-[#ae2b2b] mt-2 tracking-wide drop-shadow-sm">
                                        Jinshasan
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </motion.div>
            </motion.div>

            <p className="text-xs text-gray-400 flex items-center gap-1 animate-pulse">
                <RotateCw size={12} /> Click card to flip
            </p>
        </div>
    );
};

const StarIcon = (props) => (
    <svg
        viewBox="0 0 24 24"
        fill="currentColor"
        stroke="currentColor"
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
        {...props}
    >
        <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
    </svg>
);

export default function Profile() {
    const navigate = useNavigate();
    const { user, isLoggedIn, logout, loading } = useAuth();

    // Safety check redirect
    useEffect(() => {
        if (!loading && !isLoggedIn) {
            navigate('/');
        }
    }, [isLoggedIn, loading, navigate]);

    if (loading || !user) {
        return (
            <div className="min-h-screen flex flex-col items-center justify-center bg-gray-50 gap-4">
                <div className="relative w-16 h-16">
                    <motion.div
                        animate={{ rotate: 360 }}
                        transition={{ duration: 1.5, repeat: Infinity, ease: "linear" }}
                        className="w-full h-full border-t-4 border-[#ae2b2b] rounded-full"
                    />
                </div>
                <p className="text-gray-500 font-serif animate-pulse">Loading Profile...</p>
            </div>
        );
    }

    const sections = [
        {
            title: "Contact Details",
            icon: Phone,
            items: [
                { icon: Mail, label: "Email", value: user.email },
                { icon: Phone, label: "Mobile", value: user.mobile_number },
                { icon: MapPin, label: "City", value: `${user.city}, ${user.state}` },
            ]
        },
        {
            title: "Personal Info",
            icon: User,
            items: [
                { icon: User, label: "Full Name", value: `${user.first_name} ${user.middle_name || ''} ${user.last_name}` },
                { icon: Calendar, label: "DOB", value: user.dob ? format(new Date(user.dob), 'MMMM d, yyyy') : 'N/A' },
                { icon: User, label: "Gender", value: user.gender },
            ]
        },
        {
            title: "Professional & Education",
            icon: Briefcase,
            items: [
                { icon: GraduationCap, label: "Qualification", value: user.qualification },
                { icon: Sparkles, label: "Specialization", value: user.specialization },
                { icon: Briefcase, label: "Occupation", value: user.occupation === 'Other' ? user.occupation_other : user.occupation },
            ]
        },
        {
            title: "Volunteering Preferences",
            icon: Heart,
            items: [
                { icon: CheckCircle2, label: "1st Preference", value: user.volunteering_preference1 },
                { icon: Layers, label: "2nd Preference", value: user.volunteering_preference2 || 'None' },
                { icon: Layers, label: "3rd Preference", value: user.volunteering_preference3 || 'None' },
            ]
        }
    ];

    return (
        <div className="min-h-screen bg-[#f8f9fa] pt-6 pb-20 px-4 md:px-8">
            <div className="max-w-7xl mx-auto grid grid-cols-1 lg:grid-cols-12 gap-8">

                {/* Left Column: Badge & Stats */}
                <motion.div
                    initial={{ opacity: 0, x: -20 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ duration: 0.6 }}
                    className="lg:col-span-4 space-y-6 lg:sticky lg:top-6 h-fit"
                >
                    <div className="perspective-container py-2">
                        <Badge3D user={user} />
                    </div>

                    <Card className="border-none shadow-md bg-white">
                        <CardHeader>
                            <CardTitle className="text-lg font-serif">Quick Stats</CardTitle>
                        </CardHeader>
                        <CardContent className="grid grid-cols-2 gap-4">


                            <div className="col-span-2 bg-gray-50 p-4 rounded-xl flex items-center justify-between">
                                <div className="text-left">
                                    <p className="text-xs text-gray-500 uppercase">Mode</p>
                                    <p className="font-semibold text-gray-800 text-sm">{user.participation_mode || 'N/A'}</p>
                                </div>
                                <Shield className="text-gray-300" size={24} />
                            </div>
                        </CardContent>
                    </Card>

                    <Button
                        onClick={() => { logout(); navigate('/'); }}
                        variant="outline"
                        className="w-full border-red-200 text-red-600 hover:bg-red-50 hover:text-red-700 h-12 text-md transition-all shadow-sm"
                    >
                        <LogOut className="mr-2 h-4 w-4" />
                        Sign Out
                    </Button>
                </motion.div>

                {/* Right Column: Detailed Info Grid */}
                <div className="lg:col-span-8 space-y-8">
                    <motion.div
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: 0.2, duration: 0.6 }}
                    >
                        <h1 className="text-3xl md:text-4xl font-serif font-bold text-gray-900 mb-2">
                            <span className="text-[#ae2b2b]">Hello,</span> {user.first_name}
                        </h1>
                        <p className="text-gray-500 text-lg">Here's your volunteer profile overview.</p>
                    </motion.div>

                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                        {sections.map((section, idx) => (
                            <motion.div
                                key={section.title}
                                initial={{ opacity: 0, y: 20 }}
                                animate={{ opacity: 1, y: 0 }}
                                transition={{ delay: 0.3 + (idx * 0.1), duration: 0.5 }}
                            >
                                <Card className="h-full border border-gray-100 shadow-sm hover:shadow-md transition-shadow duration-300">
                                    <CardHeader className="pb-3 border-b border-gray-100 bg-gray-50/50">
                                        <CardTitle className="flex items-center text-lg text-gray-800">
                                            <section.icon className="mr-2 h-5 w-5 text-[#ae2b2b]" />
                                            {section.title}
                                        </CardTitle>
                                    </CardHeader>
                                    <CardContent className="pt-4 space-y-3">
                                        {section.items.map((item, i) => (
                                            <InfoItem
                                                key={i}
                                                icon={item.icon}
                                                label={item.label}
                                                value={item.value}
                                                delay={0.4 + (i * 0.05)}
                                            />
                                        ))}
                                    </CardContent>
                                </Card>
                            </motion.div>
                        ))}

                        {/* Additional Info / Skills - span full width if odd count */}
                        <motion.div
                            initial={{ opacity: 0, y: 20 }}
                            animate={{ opacity: 1, y: 0 }}
                            transition={{ delay: 0.7 }}
                            className="md:col-span-2"
                        >
                            <Card className="border border-gray-100 shadow-sm bg-gradient-to-r from-gray-50 to-white">
                                <CardHeader>
                                    <CardTitle className="flex items-center text-lg text-gray-800">
                                        <Award className="mr-2 h-5 w-5 text-[#ae2b2b]" />
                                        Interests & Skills
                                    </CardTitle>
                                </CardHeader>
                                <CardContent>
                                    <div className="space-y-4">
                                        <div>
                                            <p className="text-sm font-medium text-gray-500 mb-2">HOBBIES</p>
                                            <div className="flex flex-wrap gap-2">
                                                {user.hobbies ? user.hobbies.split(',').map((hobby, i) => (
                                                    <span key={i} className="px-3 py-1 bg-white border border-gray-200 rounded-full text-sm text-gray-700 shadow-sm">
                                                        {hobby.trim()}
                                                    </span>
                                                )) : <span className="text-gray-400 italic text-sm">No hobbies listed</span>}
                                            </div>
                                        </div>
                                        <Separator />
                                        <div>
                                            <p className="text-sm font-medium text-gray-500 mb-2">SKILLS</p>
                                            <div className="flex flex-wrap gap-2">
                                                {user.skills ? user.skills.split(',').map((skill, i) => (
                                                    <span key={i} className="px-3 py-1 bg-white border border-red-100 text-[#ae2b2b] rounded-full text-sm font-medium shadow-sm">
                                                        {skill.trim()}
                                                    </span>
                                                )) : <span className="text-gray-400 italic text-sm">No skills listed</span>}
                                            </div>
                                        </div>
                                    </div>
                                </CardContent>
                            </Card>
                        </motion.div>
                    </div>

                    {/* Address Card */}
                    <motion.div
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: 0.8 }}
                    >
                        <Card className="border border-gray-100 shadow-sm">
                            <CardContent className="p-6 flex items-start gap-4">
                                <div className="p-3 bg-red-50 rounded-full text-[#ae2b2b] shrink-0">
                                    <MapPin size={24} />
                                </div>
                                <div>
                                    <h3 className="font-serif font-bold text-gray-900 text-lg mb-1">Residential Address</h3>
                                    <p className="text-gray-600 leading-relaxed">
                                        {user.address_line1}, {user.address_line2 && `${user.address_line2}, `}
                                        {user.city}, {user.district}, {user.state} - {user.pincode}, {user.country}
                                    </p>
                                </div>
                            </CardContent>
                        </Card>
                    </motion.div>
                </div>
            </div>
        </div>
    );
}
