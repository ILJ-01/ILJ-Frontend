import VolunteerForm from "@/components/VolunteerForm";
import { Shield, BookOpen } from "lucide-react";
import { Link } from "react-router-dom";

export default function VolunteerRegistration() {
    return (
        <div className="min-h-screen bg-[#fafafa] pb-12">
            {/* Decorative Header */}
            <div className="bg-[#ae2b2b] text-white py-20 text-center relative overflow-hidden">
                {/* Subtle pattern overlay could go here */}
                <div className="absolute top-0 left-0 w-full h-full opacity-10 pointer-events-none"
                    style={{ backgroundImage: 'radial-gradient(circle at 1px 1px, white 1px, transparent 0)', backgroundSize: '40px 40px' }}>
                </div>

                <h1 className="relative text-4xl md:text-6xl font-serif font-bold mb-6 tracking-wide drop-shadow-md">
                    Volunteer Registration
                </h1>
                <p className="relative text-lg md:text-2xl max-w-3xl mx-auto px-4 font-light text-red-50 italic">
                    "Your time and skills can shape the future of Jinshasan."
                </p>
            </div>

            <div className="container mx-auto px-4 -mt-10 relative z-10 mb-20">
                <div className="bg-white rounded-xl shadow-2xl p-6 md:p-10 border-t-4 border-[#ae2b2b]">
                    <div className="flex flex-col md:flex-row justify-between items-center gap-4 mb-8 bg-gray-50/50 p-4 rounded-xl border border-gray-100">
                        <p className="text-gray-600 text-sm md:text-base leading-relaxed max-w-2xl">
                            This form collects essential information to understand your background, interests, and availability,
                            so we can meaningfully engage you in activities aligned with Jain values and community service.
                        </p>
                        <div className="flex items-center gap-3">
                            <Link
                                to="/interests"
                                target="_blank"
                                className="flex items-center gap-2 text-[#ae2b2b] font-semibold hover:bg-[#ae2b2b] hover:text-white transition-all px-4 py-2.5 rounded-lg border border-[#ae2b2b]/20 bg-[#ae2b2b]/5 shadow-sm whitespace-nowrap text-sm"
                            >
                                <BookOpen className="h-4 w-4" /> About Interests
                            </Link>
                            <Link
                                to="/policies"
                                target="_blank"
                                className="flex items-center gap-2 text-gray-600 font-semibold hover:bg-gray-100 transition-all px-4 py-2.5 rounded-lg border border-gray-200 bg-white shadow-sm whitespace-nowrap text-sm"
                            >
                                <Shield className="h-4 w-4" /> View Policies
                            </Link>
                        </div>
                    </div>
                    <VolunteerForm />
                </div>
            </div>
        </div>
    );
}
