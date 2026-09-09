import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { supabase } from "../lib/supabase";
import {
  Calendar, User, Phone, Mail, MapPin, ArrowLeft, Clock,
  CheckCircle, Upload, Shield, Award, AlertCircle, Sparkles
} from "lucide-react";
import { downloadICS } from "../lib/ics";

export default function VeerVanshajRegistrationPage({ project }) {
  const navigate = useNavigate();
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [paymentScreenshot, setPaymentScreenshot] = useState(null);
  const [registrationId, setRegistrationId] = useState("");

  const [form, setForm] = useState({
    full_name: "",
    gender: "Male",
    dob: "",
    whatsapp_number: "",
    email: "",
    address: "",
    is_vihar_sevika: "No",
    vihar_seva_head_name: "",
    vihar_seva_head_contact: ""
  });

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (!paymentScreenshot) {
      alert("Please upload the payment screenshot.");
      return;
    }

    if (form.is_vihar_sevika === "Yes") {
      if (!form.vihar_seva_head_name.trim() || !form.vihar_seva_head_contact.trim()) {
        alert("Please provide your Vihar group captain's name and contact number.");
        return;
      }
    }

    setIsSubmitting(true);

    try {
      // 1. Upload Payment Screenshot to Storage (project-gallery / event-payments)
      let finalPaymentImageUrl = null;
      const fileExt = paymentScreenshot.name.split('.').pop();
      const fileName = `veer-vanshaj-${Date.now()}-${Math.random().toString(36).substring(2)}.${fileExt}`;
      const filePath = `event-payments/${fileName}`;

      const { error: uploadError } = await supabase.storage
        .from('project-gallery')
        .upload(filePath, paymentScreenshot);

      if (uploadError) throw uploadError;

      const { data: { publicUrl } } = supabase.storage
        .from('project-gallery')
        .getPublicUrl(filePath);

      finalPaymentImageUrl = publicUrl;

      // 2. Generate Unique Registration ID VV-XXX (count of existing registrations for PRJ-002 + 1)
      const targetProjectId = project?.id || "c3d175f3-dd6e-4000-bd32-ebe20b589705";
      const { count, error: countError } = await supabase
        .from("event_registrations")
        .select("id", { count: "exact", head: true })
        .eq("project_id", targetProjectId);

      if (countError) throw countError;

      const nextRegNum = (count || 0) + 1;
      const generatedRegId = `VV-${String(nextRegNum).padStart(3, '0')}`;
      setRegistrationId(generatedRegId);

      // 3. Insert registration record into database
      const { error: insertError } = await supabase
        .from("event_registrations")
        .insert({
          project_id: targetProjectId,
          full_name: form.full_name,
          gender: form.gender,
          dob: form.dob || null,
          whatsapp_number: form.whatsapp_number,
          mobile_number: form.whatsapp_number,
          email: form.email || null,
          address: form.address || null,
          is_vihar_sevika: form.is_vihar_sevika === "Yes",
          vihar_seva_head_name: form.is_vihar_sevika === "Yes" ? form.vihar_seva_head_name : null,
          vihar_seva_head_contact: form.is_vihar_sevika === "Yes" ? form.vihar_seva_head_contact : null,
          payment_screenshot_url: finalPaymentImageUrl,
          supported_file_url: generatedRegId
        });

      if (insertError) throw insertError;

      // 4. Send Confirmation Email directly via edge function (skip whatsapp group)
      if (form.email) {
        try {
          await supabase.functions.invoke("send-event-registration-email", {
            body: {
              to: form.email,
              applicant_name: form.full_name,
              project_title: "VEER VANSHAJ 4.0 – BECOME UNSTOPPABLE!",
              event_date: "30th Sept – 11th Oct 2026 (6:30 AM – 8:00 AM)"
              // No whatsapp_link provided intentionally
            }
          });
        } catch (emailErr) {
          console.error("Confirmation email sending failed quietly:", emailErr);
        }
      }

      setSubmitted(true);
    } catch (err) {
      console.error("Error submitting Veer Vanshaj registration:", err);
      alert("Failed to submit registration. Please try again.");
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleDownloadCalendar = () => {
    const event = {
      title: "VEER VANSHAJ 4.0 – Krav Maga Self-Defence Workshop",
      description: "12-Day Intensive Self-Defence Workshop at PlayersTurf, Malad (W). 6:30 AM - 8:00 AM daily.",
      startTime: new Date("2026-09-30T06:30:00"),
      endTime: new Date("2026-10-11T08:00:00")
    };
    downloadICS(event, "Veer_Vanshaj_4_0_Workshop.ics");
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

          <p className="text-gray-600 mb-6">
            Thank you for registering for <span className="font-semibold text-gray-900">VEER VANSHAJ 4.0 – BECOME UNSTOPPABLE!</span>.
            {form.email ? " A confirmation email has been sent to your email." : " We look forward to seeing you at the workshop!"}
          </p>

          <div className="bg-amber-50/60 border border-amber-200/80 p-4 rounded-xl mb-6 text-left text-sm text-gray-700 space-y-2">
            <span className="font-bold text-amber-900 block text-base font-serif">Workshop Details:</span>
            <div className="flex items-center gap-2">
              <span className="text-base">🗓️</span>
              <span><strong>Dates:</strong> 30th Sept – 11th Oct 2026 (12 Days)</span>
            </div>
            <div className="flex items-center gap-2">
              <span className="text-base">⏰</span>
              <span><strong>Time:</strong> 6:30 AM – 8:00 AM</span>
            </div>
            <div className="flex items-start gap-2">
              <span className="text-base">📍</span>
              <span><strong>Venue:</strong> PlayersTurf, Kothari Milestone Mall, SV Road, Malad (W)</span>
            </div>
            <div className="flex items-center gap-2">
              <span className="text-base">👥</span>
              <span><strong>Age:</strong> 11 years and above</span>
            </div>
            <div className="flex items-center gap-2">
              <span className="text-base">💸</span>
              <span><strong>Investment:</strong> ₹5,000 (approx ₹300 per hour)</span>
            </div>
          </div>

          <div className="flex flex-col gap-3 mb-6">
            <button
              onClick={handleDownloadCalendar}
              className="w-full flex justify-center py-3 px-4 border border-gray-300 rounded-lg shadow-sm text-sm font-semibold text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-200 transition-all items-center cursor-pointer"
            >
              <Calendar className="h-4 w-4 mr-2 text-gray-500" />
              Add to Calendar
            </button>
          </div>

          <button
            onClick={() => navigate(`/project/${project?.id || 'c3d175f3-dd6e-4000-bd32-ebe20b589705'}`)}
            className="w-full flex justify-center py-3 px-4 border border-transparent rounded-lg shadow-md text-sm font-semibold text-white bg-[#ae2b2b] hover:bg-[#8f1f1f] focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-[#ae2b2b] transition-all cursor-pointer"
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
          <div className="bg-gradient-to-r from-[#4a0d0d] via-[#821818] to-[#ae2b2b] p-6 sm:p-8 text-white relative overflow-hidden">
            <div className="absolute top-0 right-0 -mr-10 -mt-10 opacity-10 pointer-events-none">
              <Shield size={200} />
            </div>
            <div className="relative z-10 w-full md:w-5/6">
              <div className="flex flex-wrap items-center gap-2 mb-3">
                <span className="uppercase tracking-widest text-xs font-bold text-white/90 bg-black/30 px-3 py-1 rounded inline-block">
                  PRJ-002
                </span>
                <span className="uppercase tracking-widest text-xs font-bold text-amber-300 bg-amber-950/40 border border-amber-400/30 px-3 py-1 rounded inline-block">
                  Self Defence Workshop
                </span>
              </div>

              <p className="text-white/80 text-xs sm:text-sm font-medium mb-1 uppercase tracking-wide">
                Shri Riddhi Siddhi Aadarsh Shwetambar Murtipujak Jain Sangh  <br />
                Shri Mumbai Jain Sangh Sanghathan  <br /> Team I ❤️ Jinshasan
              </p>

              <h1 className="text-2xl sm:text-4xl font-bold font-serif leading-tight mb-3">
                VEER VANSHAJ 4.0 – BECOME UNSTOPPABLE! 🥋🔥
              </h1>
              <p className="text-white/90 text-sm sm:text-base leading-relaxed mb-6 font-light">
                Are you prepared to protect yourself and your loved ones? Equip yourself with real-world Krav Maga skills in this transformative 12-day self-defense workshop.
              </p>

              {/* Event Meta Cards */}
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3 pt-5 border-t border-white/20 text-xs">
                <div className="flex items-center gap-3 bg-white/10 p-3 rounded-xl backdrop-blur-sm border border-white/10">
                  <span className="text-2xl shrink-0">🗓️</span>
                  <div>
                    <span className="text-white/70 block uppercase font-bold text-[10px] tracking-wider">Dates</span>
                    <span className="font-bold text-white text-sm">30th Sept – 11th Oct 2026</span>
                  </div>
                </div>

                <div className="flex items-center gap-3 bg-white/10 p-3 rounded-xl backdrop-blur-sm border border-white/10">
                  <span className="text-2xl shrink-0">⏰</span>
                  <div>
                    <span className="text-white/70 block uppercase font-bold text-[10px] tracking-wider">Time</span>
                    <span className="font-bold text-white text-sm">6:30 AM – 8:00 AM</span>
                  </div>
                </div>

                <div className="flex items-center gap-3 bg-white/10 p-3 rounded-xl backdrop-blur-sm border border-white/10">
                  <span className="text-2xl shrink-0">👥</span>
                  <div>
                    <span className="text-white/70 block uppercase font-bold text-[10px] tracking-wider">Age</span>
                    <span className="font-bold text-white text-sm">11 years and above</span>
                  </div>
                </div>

                <div className="flex items-center gap-3 bg-white/10 p-3 rounded-xl backdrop-blur-sm border border-white/10 sm:col-span-2 lg:col-span-2">
                  <span className="text-2xl shrink-0">📍</span>
                  <div>
                    <span className="text-white/70 block uppercase font-bold text-[10px] tracking-wider">Venue</span>
                    <span className="font-bold text-white text-sm">PlayersTurf, Kothari Milestone Mall, SV Road, Malad (W)</span>
                  </div>
                </div>

                <div className="flex items-center gap-3 bg-white/10 p-3 rounded-xl backdrop-blur-sm border border-white/10 sm:col-span-2 lg:col-span-1">
                  <span className="text-2xl shrink-0">💸</span>
                  <div>
                    <span className="text-white/70 block uppercase font-bold text-[10px] tracking-wider">Investment</span>
                    <span className="font-bold text-white text-sm">₹5,000 <span className="text-[11px] font-normal text-white/80">(approx ₹300 per hour)</span></span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div className="p-4 sm:p-6 md:p-10">

            {/* Program Highlights & Venue */}
            <div className="mb-8 bg-amber-50/50 rounded-xl p-5 border border-amber-200/60 text-sm text-gray-700 leading-relaxed space-y-4">
              <div className="flex items-center gap-2">
                <Award className="h-5 w-5 text-[#ae2b2b]" />
                <h4 className="font-bold text-amber-900 font-serif text-base">What You Will Learn</h4>
              </div>

              <div className="grid sm:grid-cols-2 gap-2 text-sm">
                <div className="flex items-start gap-2 bg-white p-2.5 rounded-lg border border-amber-100 shadow-sm">
                  <span className="text-green-600 font-bold shrink-0">✓</span>
                  <span>Knockout punches, kicks & choke-release moves</span>
                </div>
                <div className="flex items-start gap-2 bg-white p-2.5 rounded-lg border border-amber-100 shadow-sm">
                  <span className="text-green-600 font-bold shrink-0">✓</span>
                  <span>High-stress weapon defense (knife & threat releases)</span>
                </div>
                <div className="flex items-start gap-2 bg-white p-2.5 rounded-lg border border-amber-100 shadow-sm">
                  <span className="text-green-600 font-bold shrink-0">✓</span>
                  <span>Proven street-smart survival tactics & situational awareness</span>
                </div>
                <div className="flex items-start gap-2 bg-white p-2.5 rounded-lg border border-amber-100 shadow-sm">
                  <span className="text-green-600 font-bold shrink-0">✓</span>
                  <span>Unmatched physical & mental confidence</span>
                </div>
              </div>

              <div className="bg-white p-3.5 rounded-lg border border-amber-100 shadow-sm flex items-start gap-2">
                <MapPin className="h-5 w-5 text-[#ae2b2b] shrink-0 mt-0.5" />
                <div>
                  <strong className="text-gray-900 block">Venue:</strong>
                  <a
                    href="https://maps.google.com/?q=PlayersTurf+Kothari+Milestone+Mall+Malad+West"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-[#ae2b2b] hover:underline font-medium"
                  >
                    PlayersTurf, Kothari Milestone Mall, SV Road, Malad (W)
                  </a>
                </div>
              </div>

              <p className="text-xs text-amber-950/80 italic bg-amber-100/50 p-3 rounded-lg border border-amber-200/60">
                ⚡ <em>Do not wait for the danger to arrive. Take charge of your safety before you need it. Seats are filling fast! Be the Veer in your Vanshaj!</em>
              </p>
            </div>

            <form onSubmit={handleSubmit} className="space-y-8">

              {/* Participant Information */}
              <div className="bg-white p-5 sm:p-6 md:p-8 rounded-2xl border border-gray-100 shadow-sm relative overflow-hidden group hover:border-[#ae2b2b]/20 transition-colors">
                <div className="absolute top-0 left-0 w-1.5 h-full bg-[#ae2b2b]"></div>
                <div className="flex items-center gap-3 mb-6 border-b border-gray-50 pb-4">
                  <div className="bg-red-50 p-2 rounded-xl text-[#ae2b2b]">
                    <User className="h-5 w-5" />
                  </div>
                  <h3 className="text-xl font-bold text-gray-900 font-serif">Participant Information</h3>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-5">
                  <div className="space-y-1 md:col-span-2">
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
                      Gender <span className="text-[#ae2b2b]">*</span>
                    </label>
                    <div className="grid grid-cols-3 gap-2">
                      {["Male", "Female", "Other"].map((genderOption) => (
                        <label
                          key={genderOption}
                          className={`flex items-center justify-center p-3 rounded-xl border cursor-pointer transition-all text-sm font-semibold select-none ${form.gender === genderOption
                              ? "bg-[#ae2b2b]/10 border-[#ae2b2b] text-[#ae2b2b]"
                              : "bg-gray-50/50 border-gray-200 text-gray-700 hover:bg-gray-100"
                            }`}
                        >
                          <input
                            type="radio"
                            name="gender"
                            value={genderOption}
                            checked={form.gender === genderOption}
                            onChange={(e) => setForm({ ...form, gender: e.target.value })}
                            className="sr-only"
                          />
                          <span>{genderOption}</span>
                        </label>
                      ))}
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

                  <div className="space-y-1">
                    <label className="text-xs font-bold text-gray-700 uppercase tracking-wider">
                      WhatsApp Number <span className="text-[#ae2b2b]">*</span>
                    </label>
                    <div className="relative">
                      <Phone className="absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
                      <input
                        type="tel"
                        required
                        placeholder="+91 XXXXX XXXXX"
                        value={form.whatsapp_number}
                        onChange={e => setForm({ ...form, whatsapp_number: e.target.value })}
                        className="w-full rounded-xl border border-gray-200 pl-10 pr-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all placeholder:text-gray-400 font-medium"
                      />
                    </div>
                    <p className="text-[11px] text-gray-400">For receiving workshop updates and timings</p>
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
                    <p className="text-[11px] text-gray-400">Registration receipt will be sent here</p>
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
                </div>
              </div>

              {/* Vihar Sevak / Sevika Verification */}
              <div className="bg-white p-5 sm:p-6 md:p-8 rounded-2xl border border-gray-100 shadow-sm relative overflow-hidden group hover:border-[#ae2b2b]/20 transition-colors space-y-4">
                <div className="absolute top-0 left-0 w-1.5 h-full bg-amber-500"></div>
                <div className="flex items-center gap-3 border-b border-gray-50 pb-4">
                  <div className="bg-amber-50 p-2 rounded-xl text-amber-600">
                    <Shield className="h-5 w-5" />
                  </div>
                  <h3 className="text-xl font-bold text-gray-900 font-serif">Vihar Seva Verification</h3>
                </div>

                <div className="space-y-2">
                  <label className="text-xs font-bold text-gray-700 uppercase tracking-wider block">
                    Are you an active vihar sevak / sevika? <span className="text-[#ae2b2b]">*</span>
                  </label>
                  <div className="grid grid-cols-2 gap-3 max-w-md">
                    {["No", "Yes"].map((option) => (
                      <label
                        key={option}
                        className={`flex items-center justify-center p-3 rounded-xl border cursor-pointer transition-all text-sm font-semibold select-none ${form.is_vihar_sevika === option
                            ? "bg-amber-50 border-amber-400 text-amber-900 shadow-sm"
                            : "bg-gray-50/50 border-gray-200 text-gray-700 hover:bg-gray-100"
                          }`}
                      >
                        <input
                          type="radio"
                          name="is_vihar_sevika"
                          value={option}
                          checked={form.is_vihar_sevika === option}
                          onChange={(e) => setForm({ ...form, is_vihar_sevika: e.target.value })}
                          className="sr-only"
                        />
                        <span>{option}</span>
                      </label>
                    ))}
                  </div>
                </div>

                {form.is_vihar_sevika === "Yes" && (
                  <div className="pt-3 border-t border-amber-100/60 grid grid-cols-1 md:grid-cols-2 gap-4 animate-in fade-in slide-in-from-top-2 duration-300">
                    <div className="space-y-1">
                      <label className="text-xs font-bold text-gray-700 uppercase tracking-wider">
                        Name of your Vihar Group Captain <span className="text-[#ae2b2b]">*</span>
                      </label>
                      <input
                        type="text"
                        required={form.is_vihar_sevika === "Yes"}
                        placeholder="Enter captain's name"
                        value={form.vihar_seva_head_name}
                        onChange={e => setForm({ ...form, vihar_seva_head_name: e.target.value })}
                        className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all placeholder:text-gray-400 font-medium"
                      />
                    </div>

                    <div className="space-y-1">
                      <label className="text-xs font-bold text-gray-700 uppercase tracking-wider">
                        Contact Number of your Vihar Group Captain <span className="text-[#ae2b2b]">*</span>
                      </label>
                      <div className="relative">
                        <Phone className="absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
                        <input
                          type="tel"
                          required={form.is_vihar_sevika === "Yes"}
                          placeholder="+91 XXXXX XXXXX"
                          value={form.vihar_seva_head_contact}
                          onChange={e => setForm({ ...form, vihar_seva_head_contact: e.target.value })}
                          className="w-full rounded-xl border border-gray-200 pl-10 pr-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all placeholder:text-gray-400 font-medium"
                        />
                      </div>
                    </div>
                  </div>
                )}
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
                    <img
                      src="/veer_vanshaj_qr.jpeg"
                      alt="Veer Vanshaj Payment QR Code"
                      className="w-48 h-56 sm:w-52 sm:h-60 object-contain rounded-lg"
                    />
                  </div>
                  <div className="text-center md:text-left space-y-2">
                    <div className="inline-block bg-amber-100 text-amber-800 font-bold text-xs px-3 py-1 rounded-full uppercase tracking-wider">
                      12-Day Intensive Training
                    </div>
                    <h4 className="font-bold text-gray-900 text-xl font-serif">Scan to Pay ₹5,000/-</h4>
                    <p className="text-gray-600 text-sm leading-relaxed">
                      Please use any UPI app (GPay, PhonePe, Paytm, etc.) to scan this QR code or pay directly to UPI ID: <strong className="text-gray-900 font-mono">prakashkaspale@okhdfcbank</strong> to complete the workshop fee of <strong>₹5,000</strong>.
                    </p>
                    <div className="bg-red-50 text-[#ae2b2b] p-3 rounded-lg border border-red-100 inline-block text-xs font-semibold">
                      After successful payment, please upload the screenshot below for verification.
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

              {/* Submit Button */}
              <div className="pt-2">
                <button
                  type="submit"
                  disabled={isSubmitting}
                  className="w-full flex justify-center py-4 px-4 border border-transparent rounded-xl shadow-lg text-base font-bold text-white bg-[#ae2b2b] hover:bg-[#8f1f1f] focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-[#ae2b2b] transition-all disabled:opacity-50 cursor-pointer"
                >
                  {isSubmitting ? "Processing registration..." : "Confirm & Book Your Spot (₹5,000)"}
                </button>
              </div>

            </form>
          </div>
        </div>
      </div>
    </div>
  );
}
