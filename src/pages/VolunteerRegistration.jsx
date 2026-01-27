import VolunteerForm from "@/components/VolunteerForm";

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
                    <p className="text-gray-600 mb-8 text-center max-w-4xl mx-auto leading-relaxed">
                        This form collects essential information to understand your background, interests, and availability,
                        so we can meaningfully engage you in activities aligned with Jain values and community service.
                    </p>
                    <VolunteerForm />
                </div>
            </div>
        </div>
    );
}
