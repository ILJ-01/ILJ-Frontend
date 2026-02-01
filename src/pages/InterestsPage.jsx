import {
    FileText, Mic, Palette, Camera, Calendar, Megaphone, School, Code,
    Search, ArrowRight, Info, CheckCircle2, ShieldCheck, Users
} from "lucide-react";
import { motion } from "framer-motion";

const interests = [
    {
        title: "Research & Documentation",
        manager: "Jainam Sheth",
        description: "Research on various scriptures, philosophies, history, social issues, or contemporary topics and presenting structured insights or references.",
        icon: FileText,
        color: "bg-blue-50 text-blue-600 border-blue-100"
    },
    {
        title: "Content Writing (Articles, Blogs, Scripts)",
        manager: "Jainam Mehta",
        description: "Creating meaningful written content such as articles, captions, scripts, blogs, or educational material aligned with Jain values.",
        icon: FileText,
        color: "bg-emerald-50 text-emerald-600 border-emerald-100"
    },
    {
        title: "Public Speaking, Acting & Stage Activities",
        manager: "Aayushi Sanghavi",
        description: "Delivering talks, anchoring sessions, moderating discussions, or representing ILJ Foundation at events, Pathshalas, or public forums.",
        icon: Mic,
        color: "bg-purple-50 text-purple-600 border-purple-100"
    },
    {
        title: "Graphic Design & Video Editing",
        manager: "Aayushi Sanghavi",
        description: "Designing posters, reels, presentations, banners, or editing visuals/videos for events, social media, and awareness campaigns.",
        icon: Palette,
        color: "bg-orange-50 text-orange-600 border-orange-100"
    },
    {
        title: "Photography & Videography",
        manager: "Aayushi Sanghavi",
        description: "Capturing photos and videos during events, sessions, exhibitions, and activities for documentation and promotion.",
        icon: Camera,
        color: "bg-rose-50 text-rose-600 border-rose-100"
    },
    {
        title: "Event Planning & Management",
        manager: "Smit Mehta",
        description: "Planning, coordinating, and executing events including logistics, volunteer coordination, registrations, and on-ground support.",
        icon: Calendar,
        color: "bg-amber-50 text-amber-600 border-amber-100"
    },
    {
        title: "Marketing & Outreach",
        manager: "Charmi Dedhia",
        description: "Promoting ILJ initiatives through online/offline marketing such as social media campaigns, outreach, branding, or collaborations.",
        icon: Megaphone,
        color: "bg-indigo-50 text-indigo-600 border-indigo-100"
    },
    {
        title: "IT & Technical Support",
        manager: "Smit Mehta and Meet Mehta",
        description: "Handling websites, forms, databases, automation tools, or providing technical support for digital initiatives.",
        icon: Code,
        color: "bg-cyan-50 text-cyan-600 border-cyan-100"
    },
    {
        title: "Pathshala & Educational Activities",
        manager: "Jeel Doshi",
        description: "Supporting initiatives related to Pathshala such as sanskaar library, teaching assistance, activity planning, or student engagement.",
        icon: School,
        color: "bg-teal-50 text-teal-600 border-teal-100"
    }
];

const specializedRoles = [
    {
        title: "Defending Jainism",
        subroles: [
            {
                name: "On Social Media",
                details: "Responding respectfully to misinformation, creating awareness content, and promoting Jain philosophy through digital platforms."
            },
            {
                name: "On Field",
                details: "Participating in discussions, awareness drives, dialogues, or community engagements to represent Jain values in real-world settings."
            }
        ],
        icon: ShieldCheck,
        color: "text-[#ae2b2b]"
    },
    {
        title: "Community & Gov Relations",
        description: "Helping build and manage relationships with community groups and government bodies for coordination, collaboration, and outreach.",
        icon: Users,
        color: "text-[#ae2b2b]"
    }
];

export default function InterestsPage() {
    return (
        <div className="min-h-screen bg-[#fcfcfc] pb-20">
            {/* Hero Section */}
            <div className="bg-[#ae2b2b] text-white py-24 px-4 text-center relative overflow-hidden">
                <div className="absolute top-0 left-0 w-full h-full opacity-10 pointer-events-none">
                    <svg width="100%" height="100%" xmlns="http://www.w3.org/2000/svg">
                        <defs>
                            <pattern id="grid" width="40" height="40" patternUnits="userSpaceOnUse">
                                <path d="M 40 0 L 0 0 0 40" fill="none" stroke="white" strokeWidth="0.5" />
                            </pattern>
                        </defs>
                        <rect width="100%" height="100%" fill="url(#grid)" />
                    </svg>
                </div>

                <motion.div
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    className="max-w-4xl mx-auto relative z-10"
                >
                    <span className="inline-block px-4 py-1.5 bg-white/10 backdrop-blur-md rounded-full text-sm font-medium mb-6 tracking-wide border border-white/20">
                        VOLUNTEER OPPORTUNITIES
                    </span>
                    <h1 className="text-4xl md:text-6xl font-bold mb-6 tracking-tight">Areas of Interest</h1>
                    <p className="text-xl text-white/80 max-w-2xl mx-auto leading-relaxed">
                        Discover the diverse ways you can contribute to the ILJ Foundation. Find a role that matches your skills and passion for Jain values.
                    </p>
                </motion.div>
            </div>

            <div className="max-w-7xl mx-auto px-4 -mt-12 relative z-20">
                {/* Core Interests Grid */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-16">
                    {interests.map((item, idx) => (
                        <motion.div
                            key={item.title}
                            initial={{ opacity: 0, y: 20 }}
                            animate={{ opacity: 1, y: 0 }}
                            transition={{ delay: idx * 0.05 }}
                            className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-xl hover:-translate-y-1 transition-all duration-300 flex flex-col group"
                        >
                            <div className={`w-12 h-12 rounded-xl flex items-center justify-center mb-6 border transition-transform group-hover:scale-110 duration-300 ${item.color}`}>
                                <item.icon className="w-6 h-6" />
                            </div>

                            <h3 className="text-xl font-bold text-gray-900 mb-2">{item.title}</h3>
                            <div className="flex items-center gap-2 mb-4 text-sm font-semibold text-[#ae2b2b] bg-[#ae2b2b]/5 px-3 py-1 rounded-full w-fit">
                                <Users className="w-3.5 h-3.5" />
                                Team Leader: {item.manager}
                            </div>

                            <p className="text-gray-600 text-sm leading-relaxed mb-6 flex-1">
                                {item.description}
                            </p>

                            <div className="flex items-center gap-2 text-gray-400 text-xs font-medium uppercase tracking-widest border-t border-gray-50 pt-4">
                                <CheckCircle2 className="w-3 h-3 text-green-500" />
                                Available Opportunity
                            </div>
                        </motion.div>
                    ))}
                </div>

                {/* Specialized Roles Section */}
                <div className="bg-white rounded-3xl p-8 md:p-12 shadow-sm border border-gray-100">
                    <div className="max-w-3xl mb-12">
                        <h2 className="text-3xl font-bold text-gray-900 mb-4 flex items-center gap-3">
                            <ShieldCheck className="w-8 h-8 text-[#ae2b2b]" />
                            Specialized Contributions
                        </h2>
                        <p className="text-gray-600 leading-relaxed">
                            Beyond core functional roles, we also seek volunteers for mission-critical activities that help promote and preserve Jain values in the modern world.
                        </p>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                        {specializedRoles.map((section, idx) => (
                            <div key={section.title} className="space-y-6">
                                <div className="flex items-center gap-3 text-xl font-bold text-gray-900">
                                    <div className="w-10 h-10 rounded-lg bg-gray-50 flex items-center justify-center">
                                        <section.icon className="w-5 h-5 text-[#ae2b2b]" />
                                    </div>
                                    {section.title}
                                </div>

                                {section.subroles ? (
                                    <div className="space-y-4">
                                        {section.subroles.map(sub => (
                                            <div key={sub.name} className="bg-gray-50/50 rounded-xl p-5 border border-gray-100 hover:bg-white hover:shadow-md transition-all duration-300">
                                                <h4 className="font-bold text-gray-900 mb-2 flex items-center gap-2">
                                                    <div className="w-1.5 h-1.5 rounded-full bg-[#ae2b2b]" />
                                                    {sub.name}
                                                </h4>
                                                <p className="text-gray-600 text-sm leading-relaxed italic border-l-2 border-[#ae2b2b]/20 pl-3">
                                                    {sub.details}
                                                </p>
                                            </div>
                                        ))}
                                    </div>
                                ) : (
                                    <div className="bg-[#ae2b2b]/5 rounded-xl p-6 border border-[#ae2b2b]/10 border-dashed">
                                        <p className="text-gray-700 leading-relaxed">
                                            {section.description}
                                        </p>
                                    </div>
                                )}
                            </div>
                        ))}
                    </div>
                </div>


            </div>
        </div>
    );
}
