import { useState, useEffect } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { supabase } from "../lib/supabase";
import { Calendar, User, Phone, Mail, MapPin, Upload, ArrowLeft } from "lucide-react";

export default function EventRegistrationPage() {
    const { id } = useParams();
    const navigate = useNavigate();

    const [project, setProject] = useState(null);
    const [loading, setLoading] = useState(true);

    const [eventForm, setEventForm] = useState({
        full_name: '',
        whatsapp_number: '',
        email: '',
        age: '',
        sangh_name: '',
        address: ''
    });
    const [eventPaymentImage, setEventPaymentImage] = useState(null);
    const [isEventSubmitting, setIsEventSubmitting] = useState(false);
    const [submitted, setSubmitted] = useState(false);

    useEffect(() => {
        const fetchProject = async () => {
            try {
                const { data, error } = await supabase
                    .from('projects')
                    .select('id, title, project_code, description, next_event_date, is_event_registration_enabled')
                    .eq('id', id)
                    .single();

                if (error || !data) throw error;

                // If registration is disabled, kick them out
                if (!data.is_event_registration_enabled) {
                    navigate(`/project/${data.id}`);
                }

                setProject(data);
            } catch (error) {
                console.error("Error fetching project:", error);
                navigate('/projects');
            } finally {
                setLoading(false);
            }
        };
        fetchProject();
    }, [id, navigate]);

    const handleEventFormSubmit = async (e) => {
        e.preventDefault();
        if (!project) return;
        setIsEventSubmitting(true);

        try {
            let finalPaymentImageUrl = null;

            // Upload Payment Image if provided
            if (eventPaymentImage) {
                const fileExt = eventPaymentImage.name.split('.').pop();
                const fileName = `${Date.now()}-${Math.random().toString(36).substring(2)}.${fileExt}`;
                const filePath = `event-payments/${fileName}`;

                const { error: uploadError } = await supabase.storage
                    .from('project-gallery') // Adjust bucket if needed
                    .upload(filePath, eventPaymentImage);

                if (uploadError) throw uploadError;

                const { data: { publicUrl } } = supabase.storage
                    .from('project-gallery')
                    .getPublicUrl(filePath);

                finalPaymentImageUrl = publicUrl;
            }

            // Insert Registration Record (including email)
            const { error: insertError } = await supabase
                .from('event_registrations')
                .insert({
                    project_id: project.id,
                    full_name: eventForm.full_name,
                    whatsapp_number: eventForm.whatsapp_number,
                    email: eventForm.email || null,
                    age: eventForm.age || null,
                    address: eventForm.address || null,
                    sangh_name: eventForm.sangh_name || null,
                    payment_screenshot_url: finalPaymentImageUrl
                });

            if (insertError) throw insertError;

            // Send Email Confirmation directly via our new edge function if an email is provided
            if (eventForm.email && project.project_code === 'PRJ-002') {
                try {
                    const { data, error } = await supabase.functions.invoke('send-event-registration-email', {
                        body: {
                            to: eventForm.email,
                            applicant_name: eventForm.full_name,
                            project_title: project.title,
                            event_date: project.next_event_date
                        }
                    });
                    console.log("Edge function invocation:", { data, error });
                } catch (emailErr) {
                    console.error("Email sending failed quietly:", emailErr);
                }
            }

            setSubmitted(true);
        } catch (error) {
            console.error("Error submitting event registration:", error);
            alert("Failed to submit registration. Please try again.");
        } finally {
            setIsEventSubmitting(false);
        }
    };

    if (loading) {
        return (
            <div className="min-h-screen bg-gray-50 flex items-center justify-center">
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-[#ae2b2b]"></div>
            </div>
        );
    }

    if (submitted) {
        return (
            <div className="min-h-screen bg-gray-50 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
                <div className="max-w-md w-full bg-white p-8 rounded-2xl shadow-xl border border-gray-100 text-center animate-in fade-in zoom-in-95 duration-500">
                    <div className="mx-auto flex items-center justify-center h-20 w-20 rounded-full bg-green-100 mb-6">
                        <Calendar className="h-10 w-10 text-green-600" />
                    </div>
                    <h2 className="text-3xl font-bold text-gray-900 mb-2 font-serif">Registration Confirmed!</h2>
                    <p className="text-gray-600 mb-8">
                        Thank you for registering for <span className="font-semibold text-gray-900">{project.title}</span>.
                        {eventForm.email ? " A confirmation email has been sent to your inbox." : " We look forward to seeing you!"}
                    </p>
                    <button
                        onClick={() => navigate(`/project/${project.id}`)}
                        className="w-full flex justify-center py-3 px-4 border border-transparent rounded-lg shadow-md text-sm font-semibold text-white bg-[#ae2b2b] hover:bg-[#8f1f1f] focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-[#ae2b2b] transition-all"
                    >
                        ← Return to Project Details
                    </button>
                </div>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8 font-sans">
            <div className="max-w-3xl mx-auto">
                <button
                    onClick={() => navigate(-1)}
                    className="flex items-center text-gray-500 hover:text-gray-900 mb-6 font-medium transition-colors group"
                >
                    <ArrowLeft className="h-5 w-5 mr-1 group-hover:-translate-x-1 transition-transform" /> Back to Project
                </button>

                <div className="bg-white rounded-2xl shadow-xl border border-gray-100 overflow-hidden animate-in fade-in slide-in-from-bottom-8 duration-500">

                    {/* Banner Header */}
                    <div className="bg-gradient-to-r from-[#5c1212] to-[#ae2b2b] p-8 text-white relative overflow-hidden">
                        <div className="absolute top-0 right-0 -mr-8 -mt-8 opacity-20">
                            <Calendar size={150} />
                        </div>
                        <div className="relative z-10 w-full md:w-3/4">
                            <span className="uppercase tracking-widest text-xs font-bold text-white/80 bg-black/20 px-3 py-1 rounded inline-block mb-3">
                                {project.project_code}
                            </span>
                            <h1 className="text-4xl font-bold font-serif leading-tight mb-2">
                                Event Registration
                            </h1>
                            <p className="text-white/90 text-lg">{project.title}</p>

                            {project.next_event_date && (
                                <div className="inline-flex items-center gap-2 bg-white/10 mt-4 px-4 py-2 rounded-lg backdrop-blur-sm border border-white/20">
                                    <Calendar className="h-5 w-5 text-amber-300" />
                                    <span className="font-medium tracking-wide">{project.next_event_date}</span>
                                </div>
                            )}
                        </div>
                    </div>

                    <div className="p-8 md:p-10">
                        <h3 className="text-xl font-semibold text-gray-800 mb-8 border-b border-gray-100 pb-4">Participant Details</h3>

                        <form onSubmit={handleEventFormSubmit} className="space-y-8">
                            <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                                <div className="space-y-2">
                                    <label className="text-sm font-semibold text-gray-700 flex items-center gap-2">
                                        <User className="h-4 w-4 text-[#ae2b2b]" /> Full Name <span className="text-red-500">*</span>
                                    </label>
                                    <input
                                        type="text"
                                        required
                                        placeholder="Enter your full name"
                                        value={eventForm.full_name}
                                        onChange={e => setEventForm({ ...eventForm, full_name: e.target.value })}
                                        className="w-full rounded-lg border border-gray-300 px-4 py-3 bg-gray-50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/50 focus:border-[#ae2b2b] transition-all"
                                    />
                                </div>

                                <div className="space-y-2">
                                    <label className="text-sm font-semibold text-gray-700 flex items-center gap-2">
                                        <Phone className="h-4 w-4 text-[#ae2b2b]" /> WhatsApp Number <span className="text-red-500">*</span>
                                    </label>
                                    <input
                                        type="tel"
                                        required
                                        placeholder="+91 XXXXX XXXXX"
                                        value={eventForm.whatsapp_number}
                                        onChange={e => setEventForm({ ...eventForm, whatsapp_number: e.target.value })}
                                        className="w-full rounded-lg border border-gray-300 px-4 py-3 bg-gray-50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/50 focus:border-[#ae2b2b] transition-all"
                                    />
                                </div>

                                <div className="space-y-2">
                                    <label className="text-sm font-semibold text-gray-700 flex items-center gap-2">
                                        <Mail className="h-4 w-4 text-[#ae2b2b]" /> Email Address <span className="text-red-500">*</span>
                                    </label>
                                    <input
                                        type="email"
                                        required
                                        placeholder="you@example.com"
                                        value={eventForm.email}
                                        onChange={e => setEventForm({ ...eventForm, email: e.target.value })}
                                        className="w-full rounded-lg border border-gray-300 px-4 py-3 bg-gray-50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/50 focus:border-[#ae2b2b] transition-all"
                                    />
                                </div>

                                <div className="space-y-2">
                                    <label className="text-sm font-semibold text-gray-700 flex items-center gap-2">
                                        <span className="h-4 w-4 text-[#ae2b2b] font-bold text-center leading-4 text-xs">A</span> Age <span className="text-red-500">*</span>
                                    </label>
                                    <input
                                        type="text"
                                        required
                                        placeholder="Your age"
                                        value={eventForm.age}
                                        onChange={e => setEventForm({ ...eventForm, age: e.target.value })}
                                        className="w-full rounded-lg border border-gray-300 px-4 py-3 bg-gray-50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/50 focus:border-[#ae2b2b] transition-all"
                                    />
                                </div>

                                <div className="space-y-2 md:col-span-2">
                                    <label className="text-sm font-semibold text-gray-700 flex items-center gap-2">
                                        <span className="h-4 w-4 text-[#ae2b2b] flex items-center justify-center font-bold text-xs uppercase">S</span> Sangh Name <span className="text-red-500">*</span>
                                    </label>
                                    <input
                                        type="text"
                                        required
                                        placeholder="Your Sangh Name"
                                        value={eventForm.sangh_name}
                                        onChange={e => setEventForm({ ...eventForm, sangh_name: e.target.value })}
                                        className="w-full rounded-lg border border-gray-300 px-4 py-3 bg-gray-50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/50 focus:border-[#ae2b2b] transition-all"
                                    />
                                </div>

                                <div className="space-y-2 md:col-span-2">
                                    <label className="text-sm font-semibold text-gray-700 flex items-center gap-2">
                                        <MapPin className="h-4 w-4 text-[#ae2b2b]" /> Address <span className="text-red-500">*</span>
                                    </label>
                                    <textarea
                                        required
                                        rows="3"
                                        placeholder="Street, City, State, Pincode"
                                        value={eventForm.address}
                                        onChange={e => setEventForm({ ...eventForm, address: e.target.value })}
                                        className="w-full rounded-lg border border-gray-300 px-4 py-3 bg-gray-50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/50 focus:border-[#ae2b2b] transition-all resize-none"
                                    ></textarea>
                                </div>
                            </div>

                            <div className="bg-amber-50 p-6 rounded-xl border border-amber-200 shadow-sm mt-8">
                                <label className="text-sm font-semibold text-amber-900 flex items-center gap-2 mb-2">
                                    <Upload className="h-5 w-5 text-amber-600" /> Payment Screenshot <span className="text-amber-700 font-normal"></span>
                                </label>
                                <div className="mb-6 flex flex-col md:flex-row items-center gap-8 bg-white p-6 rounded-xl border border-amber-100 shadow-sm">
                                    <div className="bg-white p-2 rounded-xl border border-gray-200 shadow-sm shrink-0">
                                        <img src="/paymentqr.jpeg" alt="Payment QR Code" className="w-56 h-56 sm:w-64 sm:h-64 object-contain rounded-lg" />
                                    </div>
                                    <div className="text-sm text-gray-600 text-center md:text-left">
                                        <p className="font-bold text-gray-900 text-lg mb-2">Scan to Pay</p>
                                        <p className="text-base mb-2">Please use this QR code to complete your event registration payment.</p>
                                        <p className="text-[#ae2b2b] mt-3 font-semibold text-base bg-red-50 p-3 rounded-lg border border-red-100">After successful payment, please upload the screenshot below.</p>
                                    </div>
                                </div>
                                <input
                                    id="event-payment-upload"
                                    type="file"
                                    accept="image/*"
                                    onChange={e => setEventPaymentImage(e.target.files[0])}
                                    className="block w-full text-sm text-gray-600 file:mr-4 file:py-3 file:px-6 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-white file:text-amber-700 hover:file:bg-gray-50 file:cursor-pointer file:shadow-sm cursor-pointer border border-amber-200/50 rounded-lg p-2 bg-white/50"
                                />
                            </div>

                            <div className="mt-10 border-t border-gray-100 pt-8">
                                <button
                                    type="submit"
                                    disabled={isEventSubmitting}
                                    className="w-full flex justify-center py-4 px-4 border border-transparent rounded-xl shadow-lg text-lg font-bold text-white bg-gradient-to-r from-[#5c1212] to-[#ae2b2b] hover:from-[#4a0e0e] hover:to-[#8f1f1f] focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-[#ae2b2b] transition-all disabled:opacity-70 disabled:cursor-not-allowed"
                                >
                                    {isEventSubmitting ? (
                                        <span className="flex items-center gap-2">
                                            <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-white"></div> Processing...
                                        </span>
                                    ) : (
                                        'Submit Registration'
                                    )}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    );
}
