import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { supabase } from "../lib/supabase";
import { Calendar, User, Phone, Mail, MapPin, ArrowLeft, Clock, CheckCircle, Upload } from "lucide-react";
import { downloadICS } from "../lib/ics";

const SESSIONS = [
  { id: "what_if_wrong", title: "What if you are Wrong?", date: "2nd August, 2026 Sunday", venue: "Aspee Auditorium", time: "10:15 AM to 12:30 PM" },
  { id: "autopilot_off", title: "Autopilot Mode: Off", date: "9th August, 2026 Sunday", venue: "Aspee Auditorium", time: "10:15 AM to 12:30 PM" },
  { id: "simple_ample", title: "Simple is Ample", date: "16th August, 2026 Sunday", venue: "Aspee Auditorium", time: "10:15 AM to 12:30 PM" },
  { id: "darr_jeet", title: "Darr ke Aage Jeet Hai", date: "23rd August, 2026 Sunday", venue: "Aspee Auditorium", time: "10:15 AM to 12:30 PM" },
  { id: "shasan_future", title: "Shasan: Present To Future", date: "30th August, 2026 Sunday", venue: "Aspee Auditorium", time: "10:15 AM to 12:30 PM" }
];

export default function ReflectRegistrationPage({ project }) {
  const navigate = useNavigate();
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [paymentScreenshot, setPaymentScreenshot] = useState(null);
  const [registrationId, setRegistrationId] = useState("");

  const [form, setForm] = useState({
    full_name: "",
    email: "",
    address: "",
    dob: "",
    contact_no: "",
    education_details: "",
    hobbies: "", // Used for Instagram ID (optional)
    how_did_you_hear: "",
    how_did_you_hear_other: ""
  });

  // Keep track of selected session IDs.
  // By default, let's select "All".
  const [selectedSessionIds, setSelectedSessionIds] = useState(SESSIONS.map(s => s.id));
  const [isAllSelected, setIsAllSelected] = useState(true);

  const handleSessionChange = (id) => {
    let updated;
    if (selectedSessionIds.includes(id)) {
      updated = selectedSessionIds.filter(sId => sId !== id);
      setIsAllSelected(false);
    } else {
      updated = [...selectedSessionIds, id];
      if (updated.length === SESSIONS.length) {
        setIsAllSelected(true);
      }
    }
    setSelectedSessionIds(updated);
  };

  const handleAllChange = () => {
    if (isAllSelected) {
      setSelectedSessionIds([]);
      setIsAllSelected(false);
    } else {
      setSelectedSessionIds(SESSIONS.map(s => s.id));
      setIsAllSelected(true);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (selectedSessionIds.length === 0) {
      alert("Please select at least one session to register.");
      return;
    }

    if (!paymentScreenshot) {
      alert("Please upload the payment screenshot.");
      return;
    }

    setIsSubmitting(true);

    try {
      // 1. Upload Payment Screenshot to Storage (project-gallery / event-payments)
      let finalPaymentImageUrl = null;
      const fileExt = paymentScreenshot.name.split('.').pop();
      const fileName = `${Date.now()}-${Math.random().toString(36).substring(2)}.${fileExt}`;
      const filePath = `event-payments/${fileName}`;

      const { error: uploadError } = await supabase.storage
        .from('project-gallery')
        .upload(filePath, paymentScreenshot);

      if (uploadError) throw uploadError;

      const { data: { publicUrl } } = supabase.storage
        .from('project-gallery')
        .getPublicUrl(filePath);

      finalPaymentImageUrl = publicUrl;

      // 2. Generate Unique Registration ID R-XXX (count of existing registrations + 1)
      const { count, error: countError } = await supabase
        .from("event_registrations")
        .select("id", { count: "exact", head: true })
        .eq("project_id", project.id);

      if (countError) throw countError;

      const nextRegNum = (count || 0) + 1;
      const generatedRegId = `R-${String(nextRegNum).padStart(3, '0')}`;
      setRegistrationId(generatedRegId);

      // 3. Construct sessions serialization
      const selectedTitles = SESSIONS
        .filter(s => selectedSessionIds.includes(s.id))
        .map(s => s.title);
      
      const serializedSessions = isAllSelected 
        ? `All ( ${selectedTitles.join(", ")} )`
        : selectedTitles.join(", ");

      const finalHowDidYouHear = form.how_did_you_hear === "Other"
        ? (form.how_did_you_hear_other ? `Other: ${form.how_did_you_hear_other}` : "Other")
        : form.how_did_you_hear;

      // 4. Insert registration record into database
      const { error: insertError } = await supabase
        .from("event_registrations")
        .insert({
          project_id: project.id,
          full_name: form.full_name,
          whatsapp_number: form.contact_no,
          mobile_number: form.contact_no,
          email: form.email || null,
          address: form.address || null,
          dob: form.dob || null,
          education_details: form.education_details || null,
          hobbies: form.hobbies || null, // Used for Insta ID
          dharmik_education: finalHowDidYouHear || null, // How did you hear about this workshop
          fathers_name: serializedSessions, // Store selected sessions here
          payment_screenshot_url: finalPaymentImageUrl,
          supported_file_url: generatedRegId // Store generated registration ID
        });

      if (insertError) throw insertError;

      // Trigger confirmation email
      if (form.email) {
        try {
          await supabase.functions.invoke("send-event-registration-email", {
            body: {
              to: form.email,
              applicant_name: form.full_name,
              project_title: project.title,
              event_date: "August 2026 (Multiple Sundays)",
              whatsapp_link: "https://chat.whatsapp.com/Eh5vnYfP6dUKPn2wkE1wzk?mode=gi_t"
            }
          });
        } catch (emailErr) {
          console.error("Email sending failed quietly:", emailErr);
        }
      }

      setSubmitted(true);
    } catch (err) {
      console.error("Error submitting registration:", err);
      alert("Failed to submit registration. Please try again.");
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleDownloadCalendar = () => {
    const event = {
      title: "Reflect: Look Beyond your Version Sessions",
      description: "Sundays in August 2026. Conducted by Muniraj MuktiMandan Vijayji M.S.",
      startTime: new Date("2026-08-02T10:15:00"),
      endTime: new Date("2026-08-30T12:30:00")
    };
    downloadICS(event, "Reflect_Look_Beyond_Your_Version.ics");
  };

  if (submitted) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8 font-sans">
        <div className="max-w-md w-full bg-white p-8 rounded-2xl shadow-xl border border-gray-100 text-center animate-in fade-in zoom-in-95 duration-500">
          <div className="mx-auto flex items-center justify-center h-20 w-20 rounded-full bg-green-100 mb-6">
            <CheckCircle className="h-10 w-10 text-green-600" />
          </div>
          <h2 className="text-3xl font-bold text-gray-900 mb-2 font-serif">Seat Booked Successfully!</h2>
          {registrationId && (
            <div className="my-4 inline-block bg-emerald-100 text-emerald-800 font-mono font-bold text-lg px-4 py-2 rounded-xl border border-emerald-200">
              Registration ID: {registrationId}
            </div>
          )}
          <p className="text-gray-650 mb-6">
            Thank you for registering for <span className="font-semibold text-gray-900">{project.title}</span>.
            {form.email ? " A confirmation email has been sent to your inbox." : " We look forward to seeing you!"}
          </p>

          <div className="bg-amber-50/50 border border-amber-100 p-4 rounded-xl mb-6 text-left text-sm text-gray-700">
            <span className="font-bold text-amber-900 block mb-2">Booked Sessions:</span>
            <ul className="list-disc pl-5 space-y-1">
              {SESSIONS.filter(s => selectedSessionIds.includes(s.id)).map(s => (
                <li key={s.id}>
                  <strong>{s.title}</strong> - {s.date}
                </li>
              ))}
            </ul>
          </div>

          <div className="flex flex-col gap-3 mb-6">
            <button
              onClick={handleDownloadCalendar}
              className="w-full flex justify-center py-3 px-4 border border-gray-300 rounded-lg shadow-sm text-sm font-semibold text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-200 transition-all items-center"
            >
              <Calendar className="h-4 w-4 mr-2 text-gray-500" />
              Add to Calendar
            </button>
          </div>

          <div className="bg-emerald-50 border border-emerald-200 p-5 rounded-xl mb-6 text-left">
            <h3 className="text-emerald-800 font-bold mb-1 text-md text-center">Important Next Step</h3>
            <p className="text-emerald-700 text-sm mb-4 text-center">Please join the official WhatsApp group for session updates!</p>
            <a
              href="https://chat.whatsapp.com/Eh5vnYfP6dUKPn2wkE1wzk?mode=gi_t"
              target="_blank"
              rel="noopener noreferrer"
              className="w-full flex justify-center items-center py-3 px-4 border border-transparent rounded-lg shadow-sm text-sm font-bold text-white bg-[#25D366] hover:bg-[#128C7E] focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-[#25D366] transition-all"
            >
              Join WhatsApp Group
            </a>
          </div>

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
    <div className="min-h-screen w-full bg-gray-50 py-6 sm:py-12 px-3 sm:px-6 lg:px-8 font-sans overflow-y-auto touch-pan-y">
      <div className="max-w-3xl mx-auto w-full">
        <button
          onClick={() => navigate(-1)}
          className="flex items-center text-gray-500 hover:text-gray-900 mb-6 font-medium transition-colors group cursor-pointer"
        >
          <ArrowLeft className="h-5 w-5 mr-1 group-hover:-translate-x-1 transition-transform" /> Back to Pod
        </button>

        <div className="bg-white rounded-2xl shadow-xl border border-gray-100 overflow-visible md:overflow-hidden animate-in fade-in slide-in-from-bottom-8 duration-500">
          
          {/* Header Banner */}
          <div className="bg-gradient-to-r from-[#5c1212] to-[#ae2b2b] p-6 sm:p-8 text-white relative overflow-hidden">
            <div className="absolute top-0 right-0 -mr-8 -mt-8 opacity-10 pointer-events-none">
              <Calendar size={180} />
            </div>
            <div className="relative z-10 w-full md:w-5/6">
              <span className="uppercase tracking-widest text-xs font-bold text-white/80 bg-black/20 px-3 py-1 rounded inline-block mb-3">
                PRJ-008-02
              </span>
              <p className="text-white/90 text-sm font-medium mb-1 uppercase tracking-wide">
                Shri Riddhi Siddhi Adarsh Shwetambar Murtipujak Jain Sangh, Marve Road, Malad (West) and I ❤️ Jinshasan presents
              </p>
              <h1 className="text-3xl sm:text-4xl font-bold font-serif leading-tight mb-4">
                Reflect: Look Beyond your Version
              </h1>
              
              <div className="grid sm:grid-cols-2 gap-4 mt-6 pt-4 border-t border-white/20">
                <div className="flex items-start gap-2 bg-white/10 p-3 rounded-lg backdrop-blur-sm">
                  <div>
                    <span className="text-[10px] text-white/60 block uppercase font-bold tracking-wider">Blessings</span>
                    <span className="text-sm font-semibold">P.Pu. Aacharya Vimalkirti Suriji M.S.</span>
                  </div>
                </div>
                <div className="flex items-start gap-2 bg-white/10 p-3 rounded-lg backdrop-blur-sm">
                  <div>
                    <span className="text-[10px] text-white/60 block uppercase font-bold tracking-wider">Led By</span>
                    <span className="text-sm font-semibold">P.Pu. Muniraj MuktiMandan Vijayji M.S.</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div className="p-4 sm:p-6 md:p-10">
            
             {/* Presenting Information and venue info */}
             <div className="mb-8 bg-amber-50/50 rounded-xl p-5 border border-amber-200/60 text-sm text-gray-700 leading-relaxed space-y-4">
               <h4 className="font-bold text-amber-900 mb-2 font-serif text-base">Program Information & Venue</h4>
               <p className="mb-2">
                 All sessions are hosted at the prestigious <strong>Aspee Auditorium</strong>.
               </p>
               <p className="flex items-start gap-1 bg-white p-3 rounded-lg border border-amber-100 shadow-sm">
                 <MapPin className="h-5 w-5 text-[#ae2b2b] shrink-0 mt-0.5" />
                 <span>
                   <strong>Venue Address:</strong> Aspee Auditorium, Laxminarayan Mandir Complex, Malad - Marve Rd, next to Nutan School, Malad, Malad (West) 400064.
                 </span>
               </p>
               
               <div className="grid sm:grid-cols-2 gap-4 pt-2">
                 <div className="bg-white p-4 rounded-lg border border-amber-100 shadow-sm space-y-1">
                   <strong className="text-amber-900 block mb-1">Details:</strong>
                   <ul className="list-disc pl-5 space-y-1">
                     <li>Registration fees: <strong>₹200/-</strong></li>
                     <li>Age: 15-40 years</li>
                   </ul>
                 </div>
                 <div className="bg-white p-4 rounded-lg border border-amber-100 shadow-sm space-y-1">
                   <strong className="text-amber-900 block mb-1">For queries contact (WhatsApp Only):</strong>
                   <ul className="list-none space-y-1">
                     <li>Harsh Sanghavi: <strong>+91 87790 13669</strong></li>
                     <li>Bhavesh Doshi: <strong>+91 93238 06706</strong></li>
                   </ul>
                 </div>
               </div>
             </div>

            <form onSubmit={handleSubmit} className="space-y-8">
              
              {/* Personal Details */}
              <div className="bg-white p-5 sm:p-6 md:p-8 rounded-2xl border border-gray-100 shadow-sm relative overflow-hidden group hover:border-[#ae2b2b]/20 transition-colors">
                <div className="absolute top-0 left-0 w-1.5 h-full bg-[#ae2b2b]"></div>
                <div className="flex items-center gap-3 mb-6 border-b border-gray-50 pb-4">
                  <div className="bg-red-50 p-2 rounded-xl text-[#ae2b2b]">
                    <User className="h-5 w-5" />
                  </div>
                  <h3 className="text-xl font-bold text-gray-900 font-serif">Participant Information</h3>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-5">
                  <div className="space-y-1">
                    <label className="text-xs font-bold text-gray-700 uppercase tracking-wider">
                      Full Name <span className="text-[#ae2b2b]">*</span>
                    </label>
                    <input
                      type="text"
                      required
                      placeholder="Enter your full name"
                      value={form.full_name}
                      onChange={e => setForm({ ...form, full_name: e.target.value })}
                      className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all placeholder:text-gray-400 font-medium"
                    />
                  </div>

                  <div className="space-y-1">
                    <label className="text-xs font-bold text-gray-700 uppercase tracking-wider">
                      Contact No. (WhatsApp) <span className="text-[#ae2b2b]">*</span>
                    </label>
                    <div className="relative">
                      <Phone className="absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
                      <input
                        type="tel"
                        required
                        placeholder="+91 XXXXX XXXXX"
                        value={form.contact_no}
                        onChange={e => setForm({ ...form, contact_no: e.target.value })}
                        className="w-full rounded-xl border border-gray-200 pl-10 pr-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all placeholder:text-gray-400 font-medium"
                      />
                    </div>
                  </div>

                  <div className="space-y-1">
                    <label className="text-xs font-bold text-gray-700 uppercase tracking-wider">
                      Email Address <span className="text-[#ae2b2b]">*</span>
                    </label>
                    <div className="relative">
                      <Mail className="absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
                      <input
                        type="email"
                        required
                        placeholder="you@example.com"
                        value={form.email}
                        onChange={e => setForm({ ...form, email: e.target.value })}
                        className="w-full rounded-xl border border-gray-200 pl-10 pr-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all placeholder:text-gray-400 font-medium"
                      />
                    </div>
                  </div>

                  <div className="space-y-1">
                    <label className="text-xs font-bold text-gray-700 uppercase tracking-wider">
                      Date of Birth <span className="text-[#ae2b2b]">*</span>
                    </label>
                    <input
                      type="date"
                      required
                      value={form.dob}
                      onChange={e => setForm({ ...form, dob: e.target.value })}
                      className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all font-medium"
                    />
                  </div>

                  <div className="space-y-1 md:col-span-2">
                    <label className="text-xs font-bold text-gray-700 uppercase tracking-wider">
                      Professional Education <span className="text-[#ae2b2b]">*</span>
                    </label>
                    <input
                      type="text"
                      required
                      placeholder="e.g. MBA, MBBS, B.Tech, Student, Chartered Accountant"
                      value={form.education_details}
                      onChange={e => setForm({ ...form, education_details: e.target.value })}
                      className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all placeholder:text-gray-400 font-medium"
                    />
                  </div>

                  <div className="space-y-1 md:col-span-2">
                    <label className="text-xs font-bold text-gray-700 uppercase tracking-wider flex items-center justify-between">
                      <span>Instagram ID <span className="text-gray-400 lowercase font-normal">(optional)</span></span>
                    </label>
                    <input
                      type="text"
                      placeholder="e.g. @yourusername"
                      value={form.hobbies}
                      onChange={e => setForm({ ...form, hobbies: e.target.value })}
                      className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all placeholder:text-gray-400 font-medium"
                    />
                  </div>

                  <div className="space-y-1 md:col-span-2">
                    <label className="text-xs font-bold text-gray-700 uppercase tracking-wider">
                      Residential Address <span className="text-[#ae2b2b]">*</span>
                    </label>
                    <textarea
                      required
                      rows="3"
                      placeholder="Enter your residential address"
                      value={form.address}
                      onChange={e => setForm({ ...form, address: e.target.value })}
                      className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all placeholder:text-gray-400 font-medium resize-none"
                    ></textarea>
                  </div>

                  <div className="space-y-2 md:col-span-2 pt-2 border-t border-gray-100">
                    <label className="text-xs font-bold text-gray-700 uppercase tracking-wider">
                      How did you hear about this workshop? <span className="text-[#ae2b2b]">*</span>
                    </label>
                    <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-2.5">
                      {[
                        "Instagram",
                        "WhatsApp",
                        "Friend / Family",
                        "Sangh",
                        "Pujya Sahebji",
                        "Other"
                      ].map((option) => (
                        <label
                          key={option}
                          className={`flex items-center gap-2.5 p-3 rounded-xl border cursor-pointer transition-all text-sm font-medium select-none ${
                            form.how_did_you_hear === option
                              ? "bg-[#ae2b2b]/10 border-[#ae2b2b] text-[#ae2b2b] font-semibold"
                              : "bg-gray-50/50 border-gray-200 text-gray-700 hover:bg-gray-100"
                          }`}
                        >
                          <input
                            type="radio"
                            name="how_did_you_hear"
                            required
                            value={option}
                            checked={form.how_did_you_hear === option}
                            onChange={(e) => setForm({ ...form, how_did_you_hear: e.target.value })}
                            className="text-[#ae2b2b] focus:ring-[#ae2b2b]/20 h-4 w-4"
                          />
                          <span>{option === "Other" ? "Other (Please specify)" : option}</span>
                        </label>
                      ))}
                    </div>

                    {form.how_did_you_hear === "Other" && (
                      <div className="mt-3 animate-in fade-in slide-in-from-top-2">
                        <input
                          type="text"
                          required
                          placeholder="Please specify how you heard about us..."
                          value={form.how_did_you_hear_other}
                          onChange={(e) => setForm({ ...form, how_did_you_hear_other: e.target.value })}
                          className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all placeholder:text-gray-400 font-medium"
                        />
                      </div>
                    )}
                  </div>
                </div>
              </div>

              {/* Sessions Booking Card */}
              <div className="bg-white p-5 sm:p-6 md:p-8 rounded-2xl border border-gray-100 shadow-sm relative overflow-hidden group hover:border-[#ae2b2b]/20 transition-colors">
                <div className="absolute top-0 left-0 w-1.5 h-full bg-amber-500"></div>
                <div className="flex items-center justify-between gap-3 mb-6 border-b border-gray-50 pb-4">
                  <div className="flex items-center gap-3">
                    <div className="bg-amber-50 p-2 rounded-xl text-amber-600">
                      <Calendar className="h-5 w-5" />
                    </div>
                    <h3 className="text-xl font-bold text-gray-900 font-serif">Book your seat now</h3>
                  </div>

                  <label className="flex items-center gap-2 cursor-pointer bg-amber-50/60 hover:bg-amber-50 px-3 py-1.5 rounded-lg border border-amber-100 transition-colors select-none">
                    <input
                      type="checkbox"
                      checked={isAllSelected}
                      onChange={handleAllChange}
                      className="rounded border-amber-300 text-amber-600 focus:ring-amber-500/20 h-4 w-4"
                    />
                    <span className="text-xs font-bold text-amber-900 uppercase">Select All</span>
                  </label>
                </div>

                <div className="space-y-4">
                  {SESSIONS.map((session) => {
                    const isSelected = selectedSessionIds.includes(session.id);
                    return (
                      <div
                        key={session.id}
                        onClick={() => handleSessionChange(session.id)}
                        className={`p-4 rounded-xl border transition-all cursor-pointer select-none flex items-start justify-between gap-4 ${
                          isSelected
                            ? "bg-amber-50/30 border-amber-300/80 shadow-[0_2px_12px_rgba(245,158,11,0.05)]"
                            : "bg-white border-gray-100 hover:border-gray-200"
                        }`}
                      >
                        <div className="flex-1 min-w-0">
                          <div className="flex items-center gap-2 mb-1.5">
                            <span className="font-bold text-gray-900 text-base">{session.title}</span>
                          </div>
                          <div className="flex flex-wrap gap-x-4 gap-y-1.5 text-xs text-gray-500 font-medium">
                            <span className="flex items-center gap-1">
                              <Calendar className="h-3.5 w-3.5 text-gray-400" />
                              {session.date}
                            </span>
                            <span className="flex items-center gap-1">
                              <Clock className="h-3.5 w-3.5 text-gray-400" />
                              {session.time}
                            </span>
                            <span className="flex items-center gap-1">
                              <MapPin className="h-3.5 w-3.5 text-gray-400" />
                              {session.venue}
                            </span>
                          </div>
                        </div>
                        <input
                          type="checkbox"
                          checked={isSelected}
                          readOnly
                          className="rounded border-amber-300 text-amber-600 focus:ring-amber-500/20 h-5 w-5 mt-0.5 shrink-0 pointer-events-none"
                        />
                      </div>
                    );
                  })}
                </div>
              </div>
 
               {/* Payment Card */}
               <div className="bg-white p-5 sm:p-6 md:p-8 rounded-2xl border border-gray-100 shadow-sm relative overflow-hidden group hover:border-[#ae2b2b]/20 transition-colors space-y-6">
                 <div className="absolute top-0 left-0 w-1.5 h-full bg-[#ae2b2b]"></div>
                 
                 <div className="flex items-center gap-3 border-b border-gray-50 pb-4">
                   <div className="bg-red-50 p-2 rounded-xl text-[#ae2b2b]">
                     <Upload className="h-5 w-5" />
                   </div>
                   <h3 className="text-xl font-bold text-gray-900 font-serif">Payment & Verification</h3>
                 </div>

                 <div className="flex flex-col md:flex-row items-center gap-6 bg-gray-50/50 p-5 rounded-xl border border-gray-100 shadow-sm">
                   <div className="bg-white p-3 rounded-xl border border-gray-100 shadow-sm shrink-0">
                     <img src="/reflect_qr.jpeg" alt="Payment QR Code" className="w-48 h-48 sm:w-52 sm:h-52 object-contain rounded-lg" />
                   </div>
                   <div className="text-center md:text-left space-y-2">
                     <h4 className="font-bold text-gray-900 text-lg font-serif">Scan to Pay ₹200/-</h4>
                     <p className="text-gray-655 text-sm leading-relaxed">
                       Please use any UPI app (GPay, PhonePe, Paytm, etc.) to scan this QR code or pay to the UPI ID displayed on it to complete the registration fee of <strong>₹200</strong>.
                     </p>
                     <div className="bg-red-50/50 text-[#ae2b2b] p-3 rounded-lg border border-red-100/50 inline-block text-xs font-semibold">
                       After successful payment, please upload the screenshot below.
                     </div>
                   </div>
                 </div>

                 <div className="space-y-2">
                   <label className="text-xs font-bold text-gray-700 uppercase tracking-wider block">
                     Upload Payment Screenshot <span className="text-[#ae2b2b]">*</span>
                   </label>
                   <input
                     id="payment-screenshot-upload"
                     type="file"
                     required
                     accept="image/*"
                     onChange={e => setPaymentScreenshot(e.target.files[0])}
                     className="block w-full text-sm text-gray-600 file:mr-4 file:py-3 file:px-6 file:rounded-xl file:border-0 file:text-sm file:font-bold file:bg-[#ae2b2b]/10 file:text-[#ae2b2b] hover:file:bg-[#ae2b2b]/20 file:cursor-pointer file:shadow-sm cursor-pointer border border-gray-200 rounded-xl p-2 bg-gray-50"
                   />
                   <p className="text-xs text-gray-400 mt-1">PNG, JPG, JPEG formats up to 5MB</p>
                 </div>
               </div>

               {/* Submit */}
               <div className="pt-4">
                 <button
                   type="submit"
                   disabled={isSubmitting}
                   className="w-full flex justify-center py-4 px-4 border border-transparent rounded-xl shadow-lg text-base font-bold text-white bg-[#ae2b2b] hover:bg-[#8f1f1f] focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-[#ae2b2b] transition-all disabled:opacity-50"
                 >
                   {isSubmitting ? "Processing registration..." : "Book your seat now"}
                 </button>
               </div>

            </form>
          </div>
        </div>
      </div>
    </div>
  );
}
