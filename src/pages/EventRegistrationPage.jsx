import { useState, useEffect } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { supabase } from "../lib/supabase";
import { Calendar, User, Users, Phone, Mail, MapPin, Upload, ArrowLeft } from "lucide-react";
import { downloadICS } from "../lib/ics";

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
        address: '',
        dob: '',
        mobile_number: '',
        is_vihar_sevika: 'No',
        fathers_name: '',
        emergency_contact_name: '',
        emergency_contact_number: '',
        emergency_contact_relation: '',
        payment_date: '',
        vihar_seva_head_name: '',
        vihar_seva_head_contact: '',
        mothers_name: '',
        contact_no_3: '',
        education_details: '',
        dharmik_education: '',
        hobbies: '',
        medical_information: ''
    });
    const [eventPaymentImage, setEventPaymentImage] = useState(null);
    const [photographFile, setPhotographFile] = useState(null);
    const [isEventSubmitting, setIsEventSubmitting] = useState(false);
    const [submitted, setSubmitted] = useState(false);

    useEffect(() => {
        const fetchProject = async () => {
            try {
                const { data, error } = await supabase
                    .from('projects')
                    .select('id, title, project_code, description, next_event_date, is_event_registration_enabled, registration_link')
                    .eq('id', id)
                    .single();

                if (error || !data) throw error;

                // If registration is disabled AND no registration link is present, kick them out
                if (!data.is_event_registration_enabled && !data.registration_link) {
                    navigate(`/project/${data.id}`);
                    return;
                }

                if (data.project_code === 'PRJ-002') {
                    window.location.href = 'https://docs.google.com/forms/d/e/1FAIpQLSe5cPsvyKeh-h2xLw2j2nThavaQGM_Ov5fYwIHjUphNMemyaA/viewform';
                    return;
                }

                // Treat sub-pods with registration_link as PRJ-008 to reuse the Shibir form logic
                if (data.registration_link && data.project_code !== 'PRJ-008') {
                    data.project_code = 'PRJ-008';
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

            let finalPhotographUrl = null;
            if (photographFile) {
                const fileExt = photographFile.name.split('.').pop();
                const fileName = `photo-${Date.now()}-${Math.random().toString(36).substring(2)}.${fileExt}`;
                const { error: uploadError } = await supabase.storage.from('project-gallery').upload(`event-payments/${fileName}`, photographFile);
                if (!uploadError) {
                    finalPhotographUrl = supabase.storage.from('project-gallery').getPublicUrl(`event-payments/${fileName}`).data.publicUrl;
                }
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
                    payment_screenshot_url: finalPaymentImageUrl,
                    dob: eventForm.dob || null,
                    mobile_number: eventForm.mobile_number || null,
                    is_vihar_sevika: eventForm.is_vihar_sevika === 'Yes',
                    fathers_name: eventForm.fathers_name || null,
                    emergency_contact_name: eventForm.emergency_contact_name || null,
                    emergency_contact_number: eventForm.emergency_contact_number || null,
                    emergency_contact_relation: eventForm.emergency_contact_relation || null,
                    payment_date: eventForm.payment_date || null,
                    photograph_url: finalPhotographUrl,
                    vihar_seva_head_name: eventForm.is_vihar_sevika === 'Yes' ? eventForm.vihar_seva_head_name || null : null,
                    vihar_seva_head_contact: eventForm.is_vihar_sevika === 'Yes' ? eventForm.vihar_seva_head_contact || null : null,
                    mothers_name: eventForm.mothers_name || null,
                    contact_no_3: eventForm.contact_no_3 || null,
                    education_details: eventForm.education_details || null,
                    dharmik_education: eventForm.dharmik_education || null,
                    hobbies: eventForm.hobbies || null,
                    medical_information: eventForm.medical_information || null
                });

            if (insertError) throw insertError;

            // Send Email Confirmation directly via our new edge function if an email is provided
            if (eventForm.email && (project.project_code === 'PRJ-002' || project.project_code === 'PRJ-008')) {
                try {
                    const { data, error } = await supabase.functions.invoke('send-event-registration-email', {
                        body: {
                            to: eventForm.email,
                            applicant_name: eventForm.full_name,
                            project_title: project.title,
                            event_date: project.next_event_date,
                            whatsapp_link: project.project_code === 'PRJ-008' ? 'https://chat.whatsapp.com/Eh5vnYfP6dUKPn2wkE1wzk?mode=gi_t' : undefined
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
                    <p className="text-gray-600 mb-6">
                        Thank you for registering for <span className="font-semibold text-gray-900">{project.title}</span>.
                        {eventForm.email ? " A confirmation email has been sent to your inbox." : " We look forward to seeing you!"}
                    </p>

                    <div className="flex flex-col gap-3 mb-6">
                        <button
                            onClick={() => {
                                const event = {
                                    title: project.title,
                                    description: project.description || "Thank you for registering!",
                                    startTime: project.next_event_date ? new Date(project.next_event_date) : new Date(),
                                    endTime: project.next_event_date ? new Date(project.next_event_date) : new Date(),
                                };
                                downloadICS(event, `${project.title.replace(/\s+/g, '_')}.ics`);
                            }}
                            className="w-full flex justify-center py-3 px-4 border border-gray-300 rounded-lg shadow-sm text-sm font-semibold text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-200 transition-all items-center"
                        >
                            <Calendar className="h-4 w-4 mr-2 text-gray-500" />
                            Add to Calendar
                        </button>
                    </div>

                    {project.project_code === 'PRJ-008' && (
                        <div className="bg-emerald-50 border border-emerald-200 p-5 rounded-xl mb-6 text-left">
                            <h3 className="text-emerald-800 font-bold mb-1 text-md text-center">Important Next Step</h3>
                            <p className="text-emerald-700 text-sm mb-4 text-center">Please join the official WhatsApp group for Shibir updates and confirmation!</p>
                            <a
                                href="https://chat.whatsapp.com/Eh5vnYfP6dUKPn2wkE1wzk?mode=gi_t"
                                target="_blank"
                                rel="noopener noreferrer"
                                className="w-full flex justify-center items-center py-3 px-4 border border-transparent rounded-lg shadow-sm text-sm font-bold text-white bg-[#25D366] hover:bg-[#128C7E] focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-[#25D366] transition-all"
                            >
                                Join WhatsApp Group
                            </a>
                        </div>
                    )}

                    <button
                        onClick={() => navigate(`/project/${project.id}`)}
                        className="w-full flex justify-center py-3 px-4 border border-transparent rounded-lg shadow-md text-sm font-semibold text-white bg-[#ae2b2b] hover:bg-[#8f1f1f] focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-[#ae2b2b] transition-all"
                    >
                        ← Return to Pod Details
                    </button>
                </div>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-gray-50 py-8 sm:py-12 px-3 sm:px-6 lg:px-8 font-sans">
            <div className="max-w-3xl mx-auto">
                <button
                    onClick={() => navigate(-1)}
                    className="flex items-center text-gray-500 hover:text-gray-900 mb-6 font-medium transition-colors group"
                >
                    <ArrowLeft className="h-5 w-5 mr-1 group-hover:-translate-x-1 transition-transform" /> Back to Pod
                </button>

                <div className="bg-white rounded-2xl shadow-xl border border-gray-100 overflow-hidden animate-in fade-in slide-in-from-bottom-8 duration-500">

                    {/* Banner Header */}
                    <div className="bg-gradient-to-r from-[#5c1212] to-[#ae2b2b] p-6 sm:p-8 text-white relative overflow-hidden">
                        <div className="absolute top-0 right-0 -mr-8 -mt-8 opacity-20">
                            <Calendar size={150} />
                        </div>
                        <div className="relative z-10 w-full md:w-3/4">
                            <span className="uppercase tracking-widest text-xs font-bold text-white/80 bg-black/20 px-3 py-1 rounded inline-block mb-3">
                                {project.project_code}
                            </span>
                            {project.project_code === 'PRJ-008' ? (
                                <>
                                    <h1 className="text-3xl sm:text-4xl font-bold font-serif leading-tight mb-2">
                                        Reconnect <br/> <span className="text-lg sm:text-xl font-normal text-white/90">with Soul . Shasan . Nature</span>
                                    </h1>
                                    <p className="text-white/90 text-lg">A 3 days religious residential Shibir</p>
                                </>
                            ) : (
                                <>
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
                                </>
                            )}
                        </div>
                    </div>

                    <div className="p-4 sm:p-6 md:p-10">
                        {project.project_code === 'PRJ-008' && (
                            <div className="mb-8 prose prose-amber max-w-none bg-[#fff6ed] rounded-xl p-4 sm:p-6 border border-amber-200/60 shadow-sm">


                                <div className="grid md:grid-cols-2 gap-4 mb-6">
                                    <div className="bg-white p-4 rounded-xl shadow-sm border border-amber-100">
                                        <h5 className="font-bold text-gray-900 border-b border-amber-100 pb-2 mb-3 text-sm flex items-center justify-center bg-amber-50 rounded px-2">Dates</h5>
                                        <p className="text-sm text-center text-gray-700">31st December 2026 –<br />1st January –<br />2nd January 2027<br /><span className="text-amber-800 font-semibold mt-1 block text-xs">(For Boys only – Age: 12 yrs to 18 yrs)</span></p>
                                    </div>
                                    <div className="bg-white p-4 rounded-xl shadow-sm border border-amber-100">
                                        <h5 className="font-bold text-gray-900 border-b border-amber-100 pb-2 mb-3 text-sm flex items-center justify-center bg-amber-50 rounded px-2">Venue</h5>
                                        <p className="text-sm text-center text-gray-700">
                                            <a href="https://maps.app.goo.gl/WJ2kFGtr21hmVW6M8" target="_blank" rel="noopener noreferrer" className="font-bold text-[#ae2b2b] hover:underline">
                                                Piyushpani Tirth
                                            </a>
                                            <br />Ghodbunder Road, Varsova Village,<br />Mira Road, Dist. Thane – 401107 (Mumbai)
                                        </p>
                                    </div>
                                </div>

                                <div className="grid md:grid-cols-2 gap-4 text-sm text-gray-800 text-center mb-6">
                                    <div className="bg-gradient-to-br from-amber-50 to-white p-4 rounded-xl shadow-sm border border-amber-100">
                                        <span className="block font-bold text-amber-900 mb-2 border-b border-amber-100 pb-2 text-xs uppercase tracking-wide">Blessings and Divine Presence</span>
                                        <span className="font-semibold text-gray-800">Saral Swabhavi Param Pujya Acharya <br /> Shree VimalKirtisuri Maharaj Saheb</span>
                                    </div>
                                    <div className="bg-gradient-to-br from-amber-50 to-white p-4 rounded-xl shadow-sm border border-amber-100">
                                        <span className="block font-bold text-amber-900 mb-2 border-b border-amber-100 pb-2 text-xs uppercase tracking-wide">Guidance</span>
                                        <span className="font-semibold text-gray-800">Param Pujya Muniraj Shree Muktimandan Vijayji Maharaj Saheb</span>
                                    </div>
                                </div>

                                <div className="bg-white p-5 rounded-xl shadow-sm border border-amber-100 mb-6">
                                    <h5 className="font-bold text-gray-900 mb-3 text-sm flex items-center bg-amber-50 inline-block px-3 py-1 rounded">Notes</h5>
                                    <ul className="list-decimal pl-5 text-sm space-y-2.5 text-gray-700 leading-relaxed marker:text-amber-600 marker:font-bold">
                                        <li>Form will be accepted with completion of registration fees of <strong>₹100 only</strong>.</li>
                                        <li>Shibirarthi boys have to reach venue on the evening of <strong>30th December, Wednesday by 4:00 PM</strong>.<br />And departure has to be done on <strong>2nd January 2027 morning</strong> after Navkarshi.</li>
                                        <li>Scan the QR code to make payment and attach the payment details with this duly filled form.</li>
                                    </ul>
                                </div>

                                <div className="text-sm text-gray-700 bg-white p-4 rounded-xl shadow-sm border border-amber-100 mb-6 text-center">
                                    <span className="font-bold text-amber-900 border-b border-amber-100 pb-1 inline-block mb-3 text-xs uppercase tracking-wide">Transport</span>
                                    <p className="font-medium text-gray-800">Pickup & drop facilities will be available by bus from Mulund or Borivali <span className="text-gray-500 font-normal">(Details will be shared later)</span>.</p>
                                </div>

                                <div className="text-center bg-gray-900 text-white p-4 sm:p-5 rounded-xl shadow-lg mt-6 w-full overflow-hidden">
                                    <p className="text-amber-400 font-bold text-xs uppercase tracking-widest mb-2 sm:mb-1.5">For Further Queries or Assistance Call:</p>
                                    <div className="flex flex-col sm:flex-row justify-center items-center gap-2 sm:gap-6 font-mono font-bold text-base sm:text-lg">
                                        <span className="whitespace-nowrap">Hardik Shah :</span>
                                        <div className="flex flex-wrap justify-center items-center gap-3 sm:gap-6">
                                            <span className="whitespace-nowrap">📞 9930409832</span>
                                            <span className="text-gray-500 hidden sm:inline">|</span>
                                            <span className="whitespace-nowrap">📞 7021376402</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        )}
                        <h3 className="text-xl font-semibold text-gray-800 mb-8 border-b border-gray-100 pb-4">Participant Details</h3>

                        <form onSubmit={handleEventFormSubmit} className="space-y-8">

                            {/* SECTION 1: Personal & Contact Information */}
                            <div className="bg-white p-5 sm:p-6 md:p-8 rounded-2xl border border-gray-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] relative overflow-hidden group hover:border-[#ae2b2b]/20 transition-colors">
                                <div className="absolute top-0 left-0 w-1.5 h-full bg-[#ae2b2b] opacity-80"></div>
                                <div className="flex items-center gap-3 mb-6 sm:mb-8 border-b border-gray-50 pb-4">
                                    <div className="bg-red-50 p-2.5 rounded-xl text-[#ae2b2b]">
                                        <User className="h-5 w-5" />
                                    </div>
                                    <h3 className="text-xl font-bold text-gray-900 font-serif">Personal & Contact Details</h3>
                                </div>
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-6">
                                    <div className="space-y-2">
                                        <label className="text-sm font-bold text-gray-700 tracking-wide flex items-center gap-2">
                                            Full Name <span className="text-[#ae2b2b]">*</span>
                                        </label>
                                        <input
                                            type="text"
                                            required
                                            placeholder="Enter your full name"
                                            value={eventForm.full_name}
                                            onChange={e => setEventForm({ ...eventForm, full_name: e.target.value })}
                                            className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all shadow-sm placeholder:text-gray-400 font-medium"
                                        />
                                    </div>

                                    <div className="space-y-2">
                                        <label className="text-sm font-bold text-gray-700 tracking-wide flex items-center gap-2">
                                            WhatsApp Number <span className="text-[#ae2b2b]">*</span>
                                        </label>
                                        <div className="relative">
                                            <Phone className="absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
                                            <input
                                                type="tel"
                                                required
                                                placeholder="+91 XXXXX XXXXX"
                                                value={eventForm.whatsapp_number}
                                                onChange={e => setEventForm({ ...eventForm, whatsapp_number: e.target.value })}
                                                className="w-full rounded-xl border border-gray-200 pl-10 pr-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all shadow-sm placeholder:text-gray-400 font-medium"
                                            />
                                        </div>
                                    </div>

                                    <div className="space-y-2">
                                        <label className="text-sm font-bold text-gray-700 tracking-wide flex items-center gap-2">
                                            Email Address <span className="text-[#ae2b2b]">*</span>
                                        </label>
                                        <div className="relative">
                                            <Mail className="absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
                                            <input
                                                type="email"
                                                required
                                                placeholder="you@example.com"
                                                value={eventForm.email}
                                                onChange={e => setEventForm({ ...eventForm, email: e.target.value })}
                                                className="w-full rounded-xl border border-gray-200 pl-10 pr-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all shadow-sm placeholder:text-gray-400 font-medium"
                                            />
                                        </div>
                                    </div>

                                    {project.project_code !== 'PRJ-002' && (
                                        <div className="space-y-2">
                                            <label className="text-sm font-bold text-gray-700 tracking-wide flex items-center gap-2">
                                                Age <span className="text-[#ae2b2b]">*</span>
                                            </label>
                                            <input
                                                type="number"
                                                required
                                                placeholder="Your age"
                                                value={eventForm.age}
                                                onChange={e => setEventForm({ ...eventForm, age: e.target.value })}
                                                className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all shadow-sm placeholder:text-gray-400 font-medium"
                                            />
                                        </div>
                                    )}

                                    {(project.project_code === 'PRJ-002' || project.project_code === 'PRJ-008') && (
                                        <>
                                            <div className="space-y-2">
                                                <label className="text-sm font-bold text-gray-700 tracking-wide flex items-center gap-2">
                                                    Date of Birth <span className="text-[#ae2b2b]">*</span>
                                                </label>
                                                <input
                                                    type="date"
                                                    required
                                                    value={eventForm.dob}
                                                    onChange={e => setEventForm({ ...eventForm, dob: e.target.value })}
                                                    className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all shadow-sm font-medium"
                                                />
                                            </div>
                                            <div className="space-y-2">
                                                <label className="text-sm font-bold text-gray-700 tracking-wide flex items-center gap-2">
                                                    Alternate Contact No. <span className="text-[#ae2b2b]">{project.project_code === 'PRJ-008' ? '' : '*'}</span>
                                                </label>
                                                <div className="relative">
                                                    <Phone className="absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
                                                    <input
                                                        type="tel"
                                                        required={project.project_code !== 'PRJ-008'}
                                                        placeholder="+91 XXXXX XXXXX"
                                                        value={eventForm.mobile_number}
                                                        onChange={e => setEventForm({ ...eventForm, mobile_number: e.target.value })}
                                                        className="w-full rounded-xl border border-gray-200 pl-10 pr-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all shadow-sm placeholder:text-gray-400 font-medium"
                                                    />
                                                </div>
                                            </div>
                                        </>
                                    )}

                                    {project.project_code !== 'PRJ-002' && project.project_code !== 'PRJ-008' && (
                                        <div className="space-y-2 md:col-span-2">
                                            <label className="text-sm font-bold text-gray-700 tracking-wide flex items-center gap-2">
                                                Sangh Name <span className="text-[#ae2b2b]">*</span>
                                            </label>
                                            <input
                                                type="text"
                                                required
                                                placeholder="Your Sangh Name"
                                                value={eventForm.sangh_name}
                                                onChange={e => setEventForm({ ...eventForm, sangh_name: e.target.value })}
                                                className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all shadow-sm placeholder:text-gray-400 font-medium"
                                            />
                                        </div>
                                    )}

                                    <div className="space-y-2 md:col-span-2">
                                        <label className="text-sm font-bold text-gray-700 tracking-wide flex items-center gap-2">
                                            Residential Address <span className="text-[#ae2b2b]">*</span>
                                        </label>
                                        <div className="relative">
                                            <MapPin className="absolute left-4 top-4 h-4 w-4 text-gray-400" />
                                            <textarea
                                                required
                                                rows="3"
                                                placeholder="Street, City, State, Pincode"
                                                value={eventForm.address}
                                                onChange={e => setEventForm({ ...eventForm, address: e.target.value })}
                                                className="w-full rounded-xl border border-gray-200 pl-10 pr-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all shadow-sm placeholder:text-gray-400 font-medium resize-none"
                                            ></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            {/* SECTION 2: Family & Event Specific Details */}
                            {(project.project_code === 'PRJ-002' || project.project_code === 'PRJ-008') && (
                                <div className="bg-white p-5 sm:p-6 md:p-8 rounded-2xl border border-gray-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] relative overflow-hidden group hover:border-[#ae2b2b]/20 transition-colors">
                                    <div className="absolute top-0 left-0 w-1.5 h-full bg-indigo-500 opacity-80"></div>
                                    <div className="flex items-center gap-3 mb-6 sm:mb-8 border-b border-gray-50 pb-4">
                                        <div className="bg-indigo-50 p-2.5 rounded-xl text-indigo-600">
                                            <Users className="h-5 w-5" />
                                        </div>
                                        <h3 className="text-xl font-bold text-gray-900 font-serif">Additional Details</h3>
                                    </div>

                                    <div className="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-6">
                                        <div className="space-y-2">
                                            <label className="text-sm font-bold text-gray-700 tracking-wide flex items-center gap-2">
                                                Father's Name <span className="text-[#ae2b2b]">*</span>
                                            </label>
                                            <input
                                                type="text"
                                                required
                                                placeholder="Father's full name"
                                                value={eventForm.fathers_name}
                                                onChange={e => setEventForm({ ...eventForm, fathers_name: e.target.value })}
                                                className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all shadow-sm placeholder:text-gray-400 font-medium"
                                            />
                                        </div>

                                        {project.project_code === 'PRJ-008' && (
                                            <>
                                                <div className="space-y-2">
                                                    <label className="text-sm font-bold text-gray-700 tracking-wide flex items-center gap-2">
                                                        Mother's Name <span className="text-[#ae2b2b]">*</span>
                                                    </label>
                                                    <input
                                                        type="text"
                                                        required
                                                        placeholder="Mother's full name"
                                                        value={eventForm.mothers_name}
                                                        onChange={e => setEventForm({ ...eventForm, mothers_name: e.target.value })}
                                                        className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all shadow-sm placeholder:text-gray-400 font-medium"
                                                    />
                                                </div>
                                                <div className="md:col-span-2 mt-4 mb-2 flex items-center gap-3 border-b border-gray-50 pb-2">
                                                    <div className="bg-amber-50 p-2 rounded-lg text-amber-600">
                                                        <User className="h-4 w-4" />
                                                    </div>
                                                    <h4 className="text-lg font-bold text-gray-900 font-serif">Shibirarthi Details</h4>
                                                </div>
                                                <div className="space-y-2 md:col-span-2">
                                                    <label className="text-sm font-bold text-gray-700 tracking-wide flex items-center gap-2">
                                                        Education Details <span className="text-[#ae2b2b]">*</span>
                                                    </label>
                                                    <input
                                                        type="text"
                                                        required
                                                        placeholder="e.g. B.Com, Engineering, School Student"
                                                        value={eventForm.education_details}
                                                        onChange={e => setEventForm({ ...eventForm, education_details: e.target.value })}
                                                        className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all shadow-sm placeholder:text-gray-400 font-medium"
                                                    />
                                                </div>
                                                <div className="space-y-2 md:col-span-2">
                                                    <label className="text-sm font-bold text-gray-700 tracking-wide flex items-center gap-2">
                                                        Dharmik Education (Religious) <span className="text-[#ae2b2b]">*</span>
                                                    </label>
                                                    <input
                                                        type="text"
                                                        required
                                                        placeholder="e.g. Jainism courses, Pathshala details"
                                                        value={eventForm.dharmik_education}
                                                        onChange={e => setEventForm({ ...eventForm, dharmik_education: e.target.value })}
                                                        className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all shadow-sm placeholder:text-gray-400 font-medium"
                                                    />
                                                </div>
                                                <div className="space-y-2 md:col-span-2">
                                                    <label className="text-sm font-bold text-gray-700 tracking-wide flex items-center gap-2">
                                                        Hobbies / Skills
                                                    </label>
                                                    <input
                                                        type="text"
                                                        placeholder="Your hobbies and interests"
                                                        value={eventForm.hobbies}
                                                        onChange={e => setEventForm({ ...eventForm, hobbies: e.target.value })}
                                                        className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all shadow-sm placeholder:text-gray-400 font-medium"
                                                    />
                                                </div>
                                                <div className="space-y-2 md:col-span-2">
                                                    <label className="text-sm font-bold text-gray-700 tracking-wide flex items-center gap-2">
                                                        Any Medical Condition <span className="text-[#ae2b2b]">*</span>
                                                    </label>
                                                    <input
                                                        type="text"
                                                        required
                                                        placeholder="State 'None' or describe securely"
                                                        value={eventForm.medical_information}
                                                        onChange={e => setEventForm({ ...eventForm, medical_information: e.target.value })}
                                                        className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all shadow-sm placeholder:text-gray-400 font-medium"
                                                    />
                                                </div>
                                            </>
                                        )}

                                        {project.project_code === 'PRJ-002' && (
                                            <>
                                                <div className="space-y-2 md:col-span-2 bg-rose-50/50 p-5 rounded-xl border border-rose-100">
                                                    <label className="text-sm font-bold text-gray-700 tracking-wide flex items-center gap-2">
                                                        Are you an active Vihar Sevika? <span className="text-[#ae2b2b]">*</span>
                                                    </label>
                                                    <select
                                                        required
                                                        value={eventForm.is_vihar_sevika}
                                                        onChange={e => setEventForm({ ...eventForm, is_vihar_sevika: e.target.value })}
                                                        className="w-full rounded-xl border border-gray-300 px-4 py-3 bg-white text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all shadow-sm font-medium mt-2"
                                                    >
                                                        <option value="No">No</option>
                                                        <option value="Yes">Yes</option>
                                                    </select>
                                                </div>

                                                {eventForm.is_vihar_sevika === 'Yes' && (
                                                    <>
                                                        <div className="space-y-2">
                                                            <label className="text-sm font-bold text-gray-700 tracking-wide flex items-center gap-2">
                                                                Name of your Vihar Seva Head <span className="text-[#ae2b2b]">*</span>
                                                            </label>
                                                            <input
                                                                type="text"
                                                                required
                                                                placeholder="Vihar Seva Head Name"
                                                                value={eventForm.vihar_seva_head_name}
                                                                onChange={e => setEventForm({ ...eventForm, vihar_seva_head_name: e.target.value })}
                                                                className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all shadow-sm placeholder:text-gray-400 font-medium"
                                                            />
                                                        </div>
                                                        <div className="space-y-2">
                                                            <label className="text-sm font-bold text-gray-700 tracking-wide flex items-center gap-2">
                                                                Contact Details of your Head <span className="text-[#ae2b2b]">*</span>
                                                            </label>
                                                            <input
                                                                type="text"
                                                                required
                                                                placeholder="Contact Details"
                                                                value={eventForm.vihar_seva_head_contact}
                                                                onChange={e => setEventForm({ ...eventForm, vihar_seva_head_contact: e.target.value })}
                                                                className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all shadow-sm placeholder:text-gray-400 font-medium"
                                                            />
                                                        </div>
                                                    </>
                                                )}

                                                <div className="w-full h-px bg-gray-100 md:col-span-2 my-2"></div>

                                                <div className="space-y-2">
                                                    <label className="text-sm font-bold text-gray-700 tracking-wide flex items-center gap-2">
                                                        Emergency Contact Name <span className="text-[#ae2b2b]">*</span>
                                                    </label>
                                                    <input
                                                        type="text"
                                                        required
                                                        placeholder="Who to contact in emergency"
                                                        value={eventForm.emergency_contact_name}
                                                        onChange={e => setEventForm({ ...eventForm, emergency_contact_name: e.target.value })}
                                                        className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all shadow-sm placeholder:text-gray-400 font-medium"
                                                    />
                                                </div>
                                                <div className="space-y-2">
                                                    <label className="text-sm font-bold text-gray-700 tracking-wide flex items-center gap-2">
                                                        Emergency Contact Number <span className="text-[#ae2b2b]">*</span>
                                                    </label>
                                                    <input
                                                        type="tel"
                                                        required
                                                        placeholder="Emergency contact number"
                                                        value={eventForm.emergency_contact_number}
                                                        onChange={e => setEventForm({ ...eventForm, emergency_contact_number: e.target.value })}
                                                        className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all shadow-sm placeholder:text-gray-400 font-medium"
                                                    />
                                                </div>
                                                <div className="space-y-2 md:col-span-2">
                                                    <label className="text-sm font-bold text-gray-700 tracking-wide flex items-center gap-2">
                                                        Relation to Emergency Contact <span className="text-[#ae2b2b]">*</span>
                                                    </label>
                                                    <input
                                                        type="text"
                                                        required
                                                        placeholder="e.g., Mother, Brother, Friend"
                                                        value={eventForm.emergency_contact_relation}
                                                        onChange={e => setEventForm({ ...eventForm, emergency_contact_relation: e.target.value })}
                                                        className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all shadow-sm placeholder:text-gray-400 font-medium"
                                                    />
                                                </div>
                                            </>
                                        )}
                                    </div>
                                </div>
                            )}

                            {/* SECTION 3: Required Uploads and Payments */}
                            <div className="bg-gradient-to-br from-[#fffcfb] to-[#fff5f5] p-5 sm:p-6 md:p-8 rounded-2xl border border-[#ae2b2b]/20 shadow-[0_4px_20px_-4px_rgba(174,43,43,0.1)] relative overflow-hidden">
                                <div className="flex items-center gap-3 mb-6 border-b border-[#ae2b2b]/10 pb-4">
                                    <div className="bg-[#ae2b2b] p-2.5 rounded-xl text-white">
                                        <Upload className="h-5 w-5" />
                                    </div>
                                    <h3 className="text-xl font-bold text-gray-900 font-serif">Verification & Payment</h3>
                                </div>

                                {(project.project_code === 'PRJ-002' || project.project_code === 'PRJ-008') && (
                                    <div className="mb-6 sm:mb-8 p-4 sm:p-6 bg-white rounded-xl border border-gray-200 shadow-sm">
                                        <label className="text-sm font-bold text-gray-900 tracking-wide flex items-center gap-2 mb-3">
                                            Upload Recent Photograph <span className="text-[#ae2b2b]">*</span>
                                        </label>
                                        <input
                                            type="file"
                                            required
                                            accept="image/*"
                                            onChange={e => setPhotographFile(e.target.files[0])}
                                            className="block w-full text-sm text-gray-600 file:mr-4 file:py-3 file:px-6 file:rounded-xl file:border-0 file:text-sm file:font-bold file:bg-[#ae2b2b]/10 file:text-[#ae2b2b] hover:file:bg-[#ae2b2b]/20 file:cursor-pointer file:shadow-sm cursor-pointer border border-gray-200 rounded-xl p-2 bg-gray-50"
                                        />
                                        <p className="text-xs text-gray-500 mt-2">Provides us with a clear image for ID verification purposes.</p>
                                    </div>
                                )}

                                <div className="mb-6 flex flex-col md:flex-row items-center gap-6 sm:gap-8 bg-white p-4 sm:p-6 rounded-xl border border-[#ae2b2b]/10 shadow-sm">
                                    <div className="bg-white p-2 sm:p-3 rounded-2xl border border-gray-100 shadow-sm shrink-0">
                                        <img src="/paymentqr.jpeg" alt="Payment QR Code" className="w-56 h-56 sm:w-60 sm:h-60 object-contain rounded-xl" />
                                    </div>
                                    <div className="text-center md:text-left space-y-3">
                                        <h4 className="font-bold text-gray-900 text-xl font-serif">Scan to Pay</h4>
                                        <p className="text-gray-600 leading-relaxed text-sm">Please use any UPI app to scan this QR code and complete your event registration payment of <span className="font-bold text-gray-900">₹100</span>.</p>
                                        <div className="bg-red-50 text-[#ae2b2b] p-4 rounded-xl border border-red-100 inline-block">
                                            <p className="font-bold text-sm tracking-wide">After successful payment, please upload the screenshot below.</p>
                                        </div>
                                    </div>
                                </div>

                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4 sm:gap-6 bg-white p-4 sm:p-6 rounded-xl border border-gray-200 shadow-sm">
                                    <div className="space-y-2">
                                        <label className="text-sm font-bold text-gray-700 tracking-wide flex items-center gap-2">
                                            Payment Screenshot <span className="text-[#ae2b2b]">*</span>
                                        </label>
                                        <input
                                            id="event-payment-upload"
                                            type="file"
                                            required
                                            accept="image/*"
                                            onChange={e => setEventPaymentImage(e.target.files[0])}
                                            className="block w-full text-sm text-gray-600 file:mr-4 file:py-3 file:px-6 file:rounded-xl file:border-0 file:text-sm file:font-bold file:bg-[#ae2b2b]/10 file:text-[#ae2b2b] hover:file:bg-[#ae2b2b]/20 file:cursor-pointer file:shadow-sm cursor-pointer border border-gray-200 rounded-xl p-2 bg-gray-50 flex-1"
                                        />
                                    </div>

                                    {(project.project_code === 'PRJ-002' || project.project_code === 'PRJ-008') && (
                                        <div className="space-y-2">
                                            <label className="text-sm font-bold text-gray-700 tracking-wide flex items-center gap-2">
                                                Payment Date <span className="text-[#ae2b2b]">*</span>
                                            </label>
                                            <input
                                                type="date"
                                                required
                                                value={eventForm.payment_date}
                                                onChange={e => setEventForm({ ...eventForm, payment_date: e.target.value })}
                                                className="w-full rounded-xl border border-gray-200 px-4 py-3 h-[60px] bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all shadow-sm font-medium"
                                            />
                                        </div>
                                    )}
                                </div>
                            </div>

                            <div className="mt-10 pt-4">
                                <button
                                    type="submit"
                                    disabled={isEventSubmitting}
                                    className="w-full flex justify-center py-4 px-4 rounded-xl shadow-lg shadow-[#ae2b2b]/20 text-lg font-bold text-white bg-gradient-to-r from-[#8f1f1f] to-[#ae2b2b] hover:from-[#5c1212] hover:to-[#8f1f1f] focus:outline-none focus:ring-4 focus:ring-[#ae2b2b]/30 transition-all hover:-translate-y-1 hover:shadow-xl disabled:opacity-70 disabled:cursor-not-allowed disabled:transform-none"
                                >
                                    {isEventSubmitting ? (
                                        <span className="flex items-center gap-3">
                                            <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-white"></div> Processing...
                                        </span>
                                    ) : (
                                        'Submit Secure Registration'
                                    )}
                                </button>
                                <p className="text-center text-sm text-gray-500 mt-4 font-medium flex justify-center gap-2"><MapPin className="w-4 h-4" /> Your information is securely transmitted</p>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    );
}
