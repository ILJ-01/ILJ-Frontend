import { useState } from "react";
import { Link } from "react-router-dom";
import { supabase } from "@/lib/supabase";
import {
  Heart,
  Calendar,
  Clock,
  MapPin,
  User,
  Users,
  Phone,
  Home,
  Award,
  CheckCircle2,
  AlertCircle,
  Sparkles,
  ShieldCheck,
  Send,
  Building2,
  FileText,
  HeartHandshake,
  ArrowRight
} from "lucide-react";

const SEVA_AREAS_OPTIONS = [
  "Pathshala / Religious Education",
  "Sangh Administration / Management",
  "Sadhu–Sadhvi Bhagwant Vaiyavach",
  "Jain Literature / Publications",
  "Religious Events / Aayojan",
  "Jivdaya / Animal Welfare",
  "Tirth / Mandir / Derasar Seva",
  "Youth Development / Sanskar",
  "Digital / Technology-based Shasan Seva",
  "Religious Awareness / Prachar-Prasar",
  "Tapasya / Aaradhana-related Seva",
  "Other (Please Specify)"
];

const RELATIONSHIP_OPTIONS = [
  "Family / Relative",
  "Friend",
  "Fellow Shasan Sevak",
  "Sangh Member",
  "Acquaintance",
  "Self",
  "Other (Please Specify)"
];

const MARITAL_STATUS_OPTIONS = [
  "Married",
  "Widower",
  "Other (Please Specify)"
];

const INVOLVEMENT_DURATION_OPTIONS = [
  "Less than 1 year",
  "1–3 years",
  "3–5 years",
  "5–10 years",
  "10–20 years",
  "More than 20 years",
  "Not Sure"
];

const HOURS_PER_WEEK_OPTIONS = [
  "Less than 5 hours per week",
  "5–10 hours per week",
  "10–20 hours per week",
  "20–30 hours per week",
  "More than 30 hours per week",
  "Not Sure"
];

export default function SamarpanamPage() {
  const [form, setForm] = useState({
    // Nominator
    nominator_name: "",
    nominator_mobile: "",
    nominator_age: "",
    nominator_gender: "",
    nominator_address: "",
    relationship_with_nominee: "",
    relationship_other: "",

    // Nominee
    nominee_name: "",
    nominee_mobile: "",
    nominee_age: "",
    nominee_address: "",
    nominee_marital_status: "Married",
    nominee_marital_status_other: "",
    nominee_wife_name: "",
    nominee_wife_mobile: "",

    // Seva Details
    seva_areas: [],
    seva_areas_other: "",
    sangh_name: "",
    sangh_head_contact: "",
    involvement_duration: "",
    hours_per_week: "",
    total_hours_till_date: "",
    contribution_description: "",
    initiatives_achievements: "",

    // Wife's Support
    wife_support_description: "",
    wife_incident_story: "",

    // Declarations
    decl_authenticity: false,
    consent_truth: false,
    consent_contact: false,
    consent_decision: false,
  });

  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [error, setError] = useState("");

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    setForm((prev) => {
      const updated = {
        ...prev,
        [name]: type === "checkbox" ? checked : value,
      };

      // Auto-populate nominee details if "Self" is selected as relationship
      if (name === "relationship_with_nominee") {
        if (value === "Self") {
          updated.nominee_name = prev.nominator_name;
          updated.nominee_mobile = prev.nominator_mobile;
          updated.nominee_age = prev.nominator_age;
          updated.nominee_address = prev.nominator_address;
        }
      }

      // If user edits nominator fields while relationship is "Self", mirror to nominee
      if (prev.relationship_with_nominee === "Self") {
        if (name === "nominator_name") updated.nominee_name = value;
        if (name === "nominator_mobile") updated.nominee_mobile = value;
        if (name === "nominator_age") updated.nominee_age = value;
        if (name === "nominator_address") updated.nominee_address = value;
      }

      return updated;
    });
  };

  const handleSevaAreaToggle = (area) => {
    setForm((prev) => {
      const current = prev.seva_areas;
      const exists = current.includes(area);
      const updated = exists
        ? current.filter((item) => item !== area)
        : [...current, area];
      return { ...prev, seva_areas: updated };
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");

    // Validate Mandatory Fields
    if (!form.nominator_name.trim()) return setError("Please enter Nominator's Full Name.");
    if (!form.nominator_mobile.trim()) return setError("Please enter Nominator's Mobile Number.");
    if (!form.nominator_age || !String(form.nominator_age).trim()) return setError("Please enter Nominator's Age.");
    if (!form.nominator_address.trim()) return setError("Please enter Nominator's Residential Address.");
    if (!form.relationship_with_nominee) return setError("Please select Relationship with the Nominee.");
    if (form.relationship_with_nominee === "Other (Please Specify)" && !form.relationship_other.trim()) {
      return setError("Please specify your relationship with the nominee.");
    }

    if (!form.nominee_name.trim()) return setError("Please enter Nominee's Full Name.");
    if (!form.nominee_mobile.trim()) return setError("Please enter Nominee's Mobile Number.");
    if (!form.nominee_age || !String(form.nominee_age).trim()) return setError("Please enter Nominee's Age.");
    if (!form.nominee_address.trim()) return setError("Please enter Nominee's Residential Address.");
    if (!form.nominee_marital_status) return setError("Please select Nominee's Marital Status.");
    if (form.nominee_marital_status === "Other (Please Specify)" && !form.nominee_marital_status_other.trim()) {
      return setError("Please specify nominee's marital status.");
    }
    if (!form.nominee_wife_name.trim()) return setError("Please enter Full Name of Nominee's Wife.");

    if (form.seva_areas.length === 0) return setError("Please select at least one Area of Jinshasan Seva.");
    if (form.seva_areas.includes("Other (Please Specify)") && !form.seva_areas_other.trim()) {
      return setError("Please specify the other area of Jinshasan Seva.");
    }

    if (form.sangh_name.trim() && !form.sangh_head_contact.trim()) {
      return setError("Contact number of Sangh/Organisation head/trustee is mandatory when Sangh name is provided.");
    }

    if (!form.involvement_duration) return setError("Please select how long the nominee has been involved in Seva.");
    if (!form.hours_per_week) return setError("Please select approximate hours devoted per week.");
    if (!form.contribution_description.trim()) {
      return setError("Please briefly describe the nominee's contribution to Jinshasan.");
    }

    // Check Declarations
    if (!form.decl_authenticity || !form.consent_truth || !form.consent_contact || !form.consent_decision) {
      return setError("Please accept all declarations and consent checkboxes before submitting.");
    }

    setIsSubmitting(true);

    try {
      const cleanNomMob = form.nominee_mobile.trim().replace(/\D/g, "");
      const cleanNominatorMob = form.nominator_mobile.trim().replace(/\D/g, "");

      // Duplicate protection: Check if this nominator has already nominated this nominee
      const { data: existing, error: checkError } = await supabase
        .from("samarpanam_nominations")
        .select("id")
        .eq("nominator_mobile", cleanNominatorMob)
        .eq("nominee_mobile", cleanNomMob)
        .limit(1);

      if (checkError) console.error("Duplicate check error:", checkError);

      if (existing && existing.length > 0) {
        setError("You have already submitted a nomination for this Shasan Sevak. If you have additional updates, please contact the organizing committee.");
        setIsSubmitting(false);
        return;
      }

      const payload = {
        nominator_name: form.nominator_name.trim(),
        nominator_mobile: cleanNominatorMob || form.nominator_mobile.trim(),
        nominator_age: form.nominator_age ? parseInt(form.nominator_age, 10) : null,
        nominator_gender: form.nominator_gender || null,
        nominator_address: form.nominator_address.trim(),
        relationship_with_nominee: form.relationship_with_nominee,
        relationship_other: form.relationship_other.trim() || null,

        nominee_name: form.nominee_name.trim(),
        nominee_mobile: cleanNomMob || form.nominee_mobile.trim(),
        nominee_age: form.nominee_age ? parseInt(form.nominee_age, 10) : null,
        nominee_address: form.nominee_address.trim(),
        nominee_marital_status: form.nominee_marital_status,
        nominee_marital_status_other: form.nominee_marital_status_other.trim() || null,
        nominee_wife_name: form.nominee_wife_name.trim(),
        nominee_wife_mobile: form.nominee_wife_mobile.trim() || null,

        seva_areas: form.seva_areas,
        seva_areas_other: form.seva_areas_other.trim() || null,
        sangh_name: form.sangh_name.trim() || null,
        sangh_head_contact: form.sangh_head_contact.trim() || null,
        involvement_duration: form.involvement_duration,
        hours_per_week: form.hours_per_week,
        total_hours_till_date: form.total_hours_till_date ? parseFloat(form.total_hours_till_date) : null,
        contribution_description: form.contribution_description.trim(),
        initiatives_achievements: form.initiatives_achievements.trim() || null,

        wife_support_description: form.wife_support_description.trim() || null,
        wife_incident_story: form.wife_incident_story.trim() || null,

        declaration_authenticity: true,
        consent_verification: true,
        status: "submitted",
      };

      const { error: insertError } = await supabase
        .from("samarpanam_nominations")
        .insert(payload);

      if (insertError) throw insertError;

      setSubmitted(true);
      window.scrollTo({ top: 0, behavior: "smooth" });
    } catch (err) {
      console.error("Error submitting nomination:", err);
      setError("Failed to submit nomination. Please verify your details and try again.");
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleReset = () => {
    setForm({
      nominator_name: "",
      nominator_mobile: "",
      nominator_age: "",
      nominator_gender: "",
      nominator_address: "",
      relationship_with_nominee: "",
      relationship_other: "",
      nominee_name: "",
      nominee_mobile: "",
      nominee_age: "",
      nominee_address: "",
      nominee_marital_status: "Married",
      nominee_marital_status_other: "",
      nominee_wife_name: "",
      nominee_wife_mobile: "",
      seva_areas: [],
      seva_areas_other: "",
      sangh_name: "",
      sangh_head_contact: "",
      involvement_duration: "",
      hours_per_week: "",
      total_hours_till_date: "",
      contribution_description: "",
      initiatives_achievements: "",
      wife_support_description: "",
      wife_incident_story: "",
      decl_authenticity: false,
      consent_truth: false,
      consent_contact: false,
      consent_decision: false,
    });
    setSubmitted(false);
    setError("");
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-[#fbf8f7] via-[#fffdfc] to-[#f8f5f4] py-10 px-4 sm:px-6 lg:px-8">
      <div className="max-w-4xl mx-auto">

        {/* Header & Hero */}
        <div className="text-center mb-10 sm:mb-12">
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-[#ae2b2b]/10 text-[#ae2b2b] text-xs font-bold tracking-widest uppercase mb-4 shadow-xs">
            A I <Heart className="h-3.5 w-3.5 fill-[#ae2b2b]" />
             Jinshasan Initiative
          </div>

          <h1 className="text-3xl sm:text-5xl font-bold text-gray-900 font-serif tracking-tight leading-tight">
            SAMARPANAM
          </h1>
          <p className="mt-2 text-lg sm:text-2xl text-[#ae2b2b] font-serif font-semibold">
            Honouring the Silent Strength Behind Shasan Seva
          </p>

          <div className="mt-5 max-w-3xl mx-auto text-sm sm:text-base text-gray-600 leading-relaxed space-y-3 font-serif">
            <p>
              Behind every dedicated Shasan Sevak is often a life partner whose unwavering support,
              understanding and sacrifices make his contribution to Jinshasan possible.
            </p>
            <p>
              <strong className="text-gray-900">SAMARPANAM</strong> is an initiative to recognize and honour these women
              whose invaluable support enables their husbands to dedicate their time, energy and efforts towards Jinshasan Seva.
              If you know a married individual who has been actively and sincerely contributing to Jinshasan Seva,
              we invite you to nominate him so that his wife's contribution can be recognized and celebrated.
            </p>
          </div>

          {/* Event Details Badge Card */}
          <div className="mt-7 inline-block w-full max-w-2xl text-left bg-gradient-to-br from-white to-[#fff8f5] p-5 sm:p-6 rounded-2xl border border-[#ae2b2b]/20 shadow-md">
            <div className="flex items-center gap-2 text-xs font-bold uppercase tracking-wider text-[#ae2b2b] mb-3">
              <Sparkles className="h-4 w-4" /> SAMARPANAM Event Details
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 text-xs sm:text-sm text-gray-700">
              <div className="flex items-start gap-2.5">
                <Calendar className="h-4 w-4 text-[#ae2b2b] shrink-0 mt-0.5" />
                <div>
                  <span className="font-bold text-gray-900 block">Date</span>
                  15 November 2026
                </div>
              </div>
              <div className="flex items-start gap-2.5">
                <Clock className="h-4 w-4 text-[#ae2b2b] shrink-0 mt-0.5" />
                <div>
                  <span className="font-bold text-gray-900 block">Time</span>
                  10 AM Onwards
                </div>
              </div>
              <div className="flex items-start gap-2.5 sm:col-span-1">
                <MapPin className="h-4 w-4 text-[#ae2b2b] shrink-0 mt-0.5" />
                <div>
                  <span className="font-bold text-gray-900 block">Venue</span>
                  Aspee Auditorium, Laxminarayan Mandir Complex, Marve Road, Malad West, Mumbai 400064
                </div>
              </div>
            </div>

            {/* Form Submission Deadline Notice */}
            <div className="mt-4 pt-3.5 border-t border-[#ae2b2b]/15 bg-[#ae2b2b]/5 -mx-5 -mb-5 sm:-mx-6 sm:-mb-6 p-4 rounded-b-2xl flex items-start gap-2.5">
              <div className="h-2 w-2 rounded-full bg-[#ae2b2b] shrink-0 mt-1.5" />
              <div className="text-xs sm:text-sm">
                <span className="font-bold text-gray-900">Form Submission Deadline: </span>
                <span className="font-bold text-[#ae2b2b]">31st October 2026</span>
                <p className="text-gray-600 mt-0.5 font-medium">
                  We will consider all submissions received up to 31st October.
                </p>
              </div>
            </div>
          </div>
        </div>

        {submitted ? (
          /* Confirmation Screen */
          <div className="bg-white rounded-3xl p-8 sm:p-12 border border-[#ae2b2b]/20 shadow-xl text-center animate-in fade-in zoom-in-95 duration-300 max-w-2xl mx-auto">
            <div className="mx-auto mb-6 h-20 w-20 rounded-full bg-emerald-50 text-emerald-600 flex items-center justify-center ring-8 ring-emerald-50/50">
              <CheckCircle2 className="h-10 w-10" />
            </div>

            <h2 className="text-2xl sm:text-3xl font-bold text-gray-900 font-serif">
              Thank you for submitting your nomination for SAMARPANAM!
            </h2>

            <div className="mt-5 space-y-3 text-gray-600 text-sm sm:text-base leading-relaxed">
              <p>
                Your nomination has been received for consideration. Our organizing committee may contact you for additional information or verification.
              </p>
              <p className="font-semibold text-[#ae2b2b] font-serif text-base sm:text-lg">
                Together, let us recognize the silent sacrifices and invaluable support behind Jinshasan Seva.
              </p>
            </div>

            <div className="mt-8 flex flex-col sm:flex-row gap-3 justify-center">
              <button
                onClick={handleReset}
                className="px-6 py-3 rounded-xl bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white font-semibold text-sm transition-all shadow-md shadow-red-900/10 cursor-pointer"
              >
                Submit Another Nomination
              </button>
              <Link
                to="/"
                className="px-6 py-3 rounded-xl border border-gray-200 hover:bg-gray-50 text-gray-700 font-semibold text-sm transition-all text-center inline-flex items-center justify-center gap-1.5"
              >
                Return to Home <ArrowRight className="h-4 w-4" />
              </Link>
            </div>
          </div>
        ) : (
          /* The Form */
          <form onSubmit={handleSubmit} className="space-y-8">

            {error && (
              <div className="p-4 rounded-2xl bg-red-50 border border-red-200 text-red-700 text-sm flex items-start gap-3 shadow-xs">
                <AlertCircle className="h-5 w-5 text-red-600 shrink-0 mt-0.5" />
                <div>
                  <strong className="block font-semibold">Please check the required information</strong>
                  {error}
                </div>
              </div>
            )}

            {/* SECTION 1: Nominator Details */}
            <div className="bg-white rounded-3xl p-6 sm:p-8 border border-gray-100 shadow-md">
              <div className="flex items-center gap-3 border-b border-gray-100 pb-4 mb-6">
                <div className="h-9 w-9 rounded-xl bg-[#ae2b2b]/10 text-[#ae2b2b] flex items-center justify-center font-bold text-sm">
                  1
                </div>
                <div>
                  <h2 className="text-lg sm:text-xl font-bold text-gray-900 font-serif">
                    Details of the Nominator
                  </h2>
                  <p className="text-xs text-gray-500">Person submitting the nomination</p>
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-5">
                {/* 1. Full Name */}
                <div className="sm:col-span-2">
                  <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                    1. Full Name <span className="text-[#ae2b2b]">*</span>
                  </label>
                  <input
                    type="text"
                    name="nominator_name"
                    required
                    value={form.nominator_name}
                    onChange={handleChange}
                    placeholder="Enter your full name"
                    className="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition"
                  />
                </div>

                {/* 2. Mobile Number */}
                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                    2. Mobile Number <span className="text-[#ae2b2b]">*</span>
                    <span className="text-gray-400 font-normal lowercase ml-1">(WhatsApp preferred)</span>
                  </label>
                  <input
                    type="tel"
                    name="nominator_mobile"
                    required
                    value={form.nominator_mobile}
                    onChange={handleChange}
                    placeholder="e.g. 9876543210"
                    className="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition"
                  />
                </div>

                {/* 3. Age */}
                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                    3. Age <span className="text-[#ae2b2b]">*</span>
                  </label>
                  <input
                    type="number"
                    name="nominator_age"
                    required
                    min="15"
                    max="120"
                    value={form.nominator_age}
                    onChange={handleChange}
                    placeholder="e.g. 35"
                    className="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition"
                  />
                </div>

                {/* 4. Gender */}
                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                    4. Gender <span className="text-gray-400 font-normal lowercase">(optional)</span>
                  </label>
                  <select
                    name="nominator_gender"
                    value={form.nominator_gender}
                    onChange={handleChange}
                    className="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium bg-white"
                  >
                    <option value="">-- Select Gender --</option>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                  </select>
                </div>

                {/* 6. Relationship with the Nominee */}
                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                    6. Relationship with the Nominee <span className="text-[#ae2b2b]">*</span>
                  </label>
                  <select
                    name="relationship_with_nominee"
                    required
                    value={form.relationship_with_nominee}
                    onChange={handleChange}
                    className="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium bg-white"
                  >
                    <option value="">-- Select Relationship --</option>
                    {RELATIONSHIP_OPTIONS.map((opt) => (
                      <option key={opt} value={opt}>{opt}</option>
                    ))}
                  </select>
                </div>

                {/* Conditional Other for Relationship */}
                {form.relationship_with_nominee === "Other (Please Specify)" && (
                  <div className="sm:col-span-2 animate-in fade-in">
                    <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                      Please Specify Relationship <span className="text-[#ae2b2b]">*</span>
                    </label>
                    <input
                      type="text"
                      name="relationship_other"
                      required
                      value={form.relationship_other}
                      onChange={handleChange}
                      placeholder="Specify your relationship"
                      className="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition"
                    />
                  </div>
                )}

                {/* 5. Residential Address */}
                <div className="sm:col-span-2">
                  <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                    5. Residential Address <span className="text-[#ae2b2b]">*</span>
                    <span className="text-gray-400 font-normal lowercase block sm:inline sm:ml-2">
                      (Include area, city, state and PIN code)
                    </span>
                  </label>
                  <textarea
                    name="nominator_address"
                    required
                    rows="2"
                    value={form.nominator_address}
                    onChange={handleChange}
                    placeholder="Enter full address with PIN code"
                    className="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition"
                  ></textarea>
                </div>

              </div>
            </div>

            {/* SECTION 2: Nominee Details */}
            <div className="bg-white rounded-3xl p-6 sm:p-8 border border-gray-100 shadow-md">
              <div className="flex items-center justify-between border-b border-gray-100 pb-4 mb-6">
                <div className="flex items-center gap-3">
                  <div className="h-9 w-9 rounded-xl bg-[#ae2b2b]/10 text-[#ae2b2b] flex items-center justify-center font-bold text-sm">
                    2
                  </div>
                  <div>
                    <h2 className="text-lg sm:text-xl font-bold text-gray-900 font-serif">
                      Details of the Shasan Sevak Being Nominated
                    </h2>
                    <p className="text-xs text-gray-500">Person actively involved in Jinshasan Seva</p>
                  </div>
                </div>

                {form.relationship_with_nominee === "Self" && (
                  <span className="text-xs bg-emerald-50 text-emerald-700 font-semibold px-3 py-1 rounded-full border border-emerald-200">
                    Auto-populated from Nominator
                  </span>
                )}
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-5">
                {/* 7. Full Name of Shasan Sevak */}
                <div className="sm:col-span-2">
                  <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                    7. Full Name of Shasan Sevak <span className="text-[#ae2b2b]">*</span>
                  </label>
                  <input
                    type="text"
                    name="nominee_name"
                    required
                    value={form.nominee_name}
                    onChange={handleChange}
                    placeholder="Full name of the Shasan Sevak"
                    className="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition"
                  />
                </div>

                {/* 8. Mobile Number */}
                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                    8. Mobile Number <span className="text-[#ae2b2b]">*</span>
                  </label>
                  <input
                    type="tel"
                    name="nominee_mobile"
                    required
                    value={form.nominee_mobile}
                    onChange={handleChange}
                    placeholder="Nominee's contact number"
                    className="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition"
                  />
                </div>

                {/* 9. Age */}
                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                    9. Age <span className="text-[#ae2b2b]">*</span>
                  </label>
                  <input
                    type="number"
                    name="nominee_age"
                    required
                    min="18"
                    max="120"
                    value={form.nominee_age}
                    onChange={handleChange}
                    placeholder="e.g. 42"
                    className="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition"
                  />
                </div>

                {/* 10. Residential Address */}
                <div className="sm:col-span-2">
                  <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                    10. Residential Address <span className="text-[#ae2b2b]">*</span>
                    <span className="text-gray-400 font-normal lowercase block sm:inline sm:ml-2">
                      (Include area, city, state and PIN code)
                    </span>
                  </label>
                  <textarea
                    name="nominee_address"
                    required
                    rows="2"
                    value={form.nominee_address}
                    onChange={handleChange}
                    placeholder="Nominee's address with area, city and PIN code"
                    className="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition"
                  ></textarea>
                </div>

                {/* 11. Marital Status */}
                <div className="sm:col-span-2">
                  <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                    11. Marital Status <span className="text-[#ae2b2b]">*</span>
                  </label>
                  <select
                    name="nominee_marital_status"
                    required
                    value={form.nominee_marital_status}
                    onChange={handleChange}
                    className="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium bg-white"
                  >
                    {MARITAL_STATUS_OPTIONS.map((opt) => (
                      <option key={opt} value={opt}>{opt}</option>
                    ))}
                  </select>
                </div>

                {/* Conditional Other for Marital Status */}
                {form.nominee_marital_status === "Other (Please Specify)" && (
                  <div className="sm:col-span-2 animate-in fade-in">
                    <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                      Please Specify Marital Status <span className="text-[#ae2b2b]">*</span>
                    </label>
                    <input
                      type="text"
                      name="nominee_marital_status_other"
                      required
                      value={form.nominee_marital_status_other}
                      onChange={handleChange}
                      placeholder="Specify marital status"
                      className="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition"
                    />
                  </div>
                )}

                {/* 12. Full Name of Wife */}
                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                    12. Full Name of Wife <span className="text-[#ae2b2b]">*</span>
                  </label>
                  <input
                    type="text"
                    name="nominee_wife_name"
                    required
                    value={form.nominee_wife_name}
                    onChange={handleChange}
                    placeholder="Wife's full name"
                    className="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition"
                  />
                </div>

                {/* 13. Wife's Mobile Number */}
                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                    13. Wife's Mobile Number <span className="text-gray-400 font-normal lowercase">(optional, WhatsApp preferred)</span>
                  </label>
                  <input
                    type="tel"
                    name="nominee_wife_mobile"
                    value={form.nominee_wife_mobile}
                    onChange={handleChange}
                    placeholder="e.g. 9876543210"
                    className="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition"
                  />
                </div>

              </div>
            </div>

            {/* SECTION 3: Details of Jinshasan Seva */}
            <div className="bg-white rounded-3xl p-6 sm:p-8 border border-gray-100 shadow-md">
              <div className="flex items-center gap-3 border-b border-gray-100 pb-4 mb-6">
                <div className="h-9 w-9 rounded-xl bg-[#ae2b2b]/10 text-[#ae2b2b] flex items-center justify-center font-bold text-sm">
                  3
                </div>
                <div>
                  <h2 className="text-lg sm:text-xl font-bold text-gray-900 font-serif">
                    Details of Jinshasan Seva
                  </h2>
                  <p className="text-xs text-gray-500">Service areas, time devoted and key achievements</p>
                </div>
              </div>

              <div className="space-y-6">
                {/* 14. Area(s) of Jinshasan Seva */}
                <div>
                  <div className="flex justify-between items-baseline mb-2">
                    <label className="block text-xs font-bold uppercase tracking-wider text-gray-700">
                      14. Area(s) of Jinshasan Seva <span className="text-[#ae2b2b]">*</span>
                    </label>
                    <span className="text-xs text-gray-400">Select all that apply</span>
                  </div>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-2.5">
                    {SEVA_AREAS_OPTIONS.map((area) => {
                      const isSelected = form.seva_areas.includes(area);
                      return (
                        <label
                          key={area}
                          onClick={() => handleSevaAreaToggle(area)}
                          className={`flex items-start gap-3 p-3 rounded-xl border text-xs sm:text-sm font-medium transition-all cursor-pointer select-none ${
                            isSelected
                              ? "bg-[#ae2b2b]/5 border-[#ae2b2b] text-[#ae2b2b]"
                              : "bg-gray-50/60 border-gray-200 text-gray-700 hover:bg-gray-100"
                          }`}
                        >
                          <input
                            type="checkbox"
                            checked={isSelected}
                            onChange={() => {}} // handled by label onClick
                            className="mt-0.5 rounded text-[#ae2b2b] focus:ring-[#ae2b2b]"
                          />
                          <span>{area}</span>
                        </label>
                      );
                    })}
                  </div>

                  {/* Conditional Other Field for Seva Areas */}
                  {form.seva_areas.includes("Other (Please Specify)") && (
                    <div className="mt-3 animate-in fade-in">
                      <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                        Please Specify Other Area of Seva <span className="text-[#ae2b2b]">*</span>
                      </label>
                      <input
                        type="text"
                        name="seva_areas_other"
                        required
                        value={form.seva_areas_other}
                        onChange={handleChange}
                        placeholder="Enter other area of seva"
                        className="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition"
                      />
                    </div>
                  )}
                </div>

                {/* 15 & 16: Sangh/Organisation Details */}
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-5 pt-2">
                  <div>
                    <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                      15. Name of Sangh / Organization(s) Associated With
                      <span className="text-gray-400 font-normal lowercase ml-1">(optional)</span>
                    </label>
                    <textarea
                      name="sangh_name"
                      rows="2"
                      value={form.sangh_name}
                      onChange={handleChange}
                      placeholder="e.g. Shree Jain Sangh, Malad"
                      className="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition"
                    ></textarea>
                  </div>

                  <div>
                    <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                      16. Contact number of Sangh/Org head/trustee for reference
                      {form.sangh_name.trim() ? (
                        <span className="text-[#ae2b2b] font-bold ml-1">* (Mandatory)</span>
                      ) : (
                        <span className="text-gray-400 font-normal lowercase ml-1">(if Q15 answered)</span>
                      )}
                    </label>
                    <input
                      type="tel"
                      name="sangh_head_contact"
                      required={!!form.sangh_name.trim()}
                      value={form.sangh_head_contact}
                      onChange={handleChange}
                      placeholder="e.g. 9876543210"
                      className="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition"
                    />
                  </div>
                </div>

                {/* 17, 18, 19: Time & Duration */}
                <div className="grid grid-cols-1 sm:grid-cols-3 gap-5 pt-2">
                  <div>
                    <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                      17. Involvement Duration <span className="text-[#ae2b2b]">*</span>
                    </label>
                    <select
                      name="involvement_duration"
                      required
                      value={form.involvement_duration}
                      onChange={handleChange}
                      className="w-full px-3.5 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-xs sm:text-sm font-medium bg-white"
                    >
                      <option value="">-- Select Duration --</option>
                      {INVOLVEMENT_DURATION_OPTIONS.map((opt) => (
                        <option key={opt} value={opt}>{opt}</option>
                      ))}
                    </select>
                  </div>

                  <div>
                    <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                      18. Hours Devoted Per Week <span className="text-[#ae2b2b]">*</span>
                    </label>
                    <select
                      name="hours_per_week"
                      required
                      value={form.hours_per_week}
                      onChange={handleChange}
                      className="w-full px-3.5 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-xs sm:text-sm font-medium bg-white"
                    >
                      <option value="">-- Select Hours --</option>
                      {HOURS_PER_WEEK_OPTIONS.map((opt) => (
                        <option key={opt} value={opt}>{opt}</option>
                      ))}
                    </select>
                  </div>

                  <div>
                    <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                      19. Total Hours Till Date
                      <span className="text-gray-400 font-normal lowercase ml-1">(optional)</span>
                    </label>
                    <input
                      type="number"
                      name="total_hours_till_date"
                      min="0"
                      value={form.total_hours_till_date}
                      onChange={handleChange}
                      placeholder="e.g. 500"
                      className="w-full px-3.5 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-xs sm:text-sm font-medium transition"
                    />
                  </div>
                </div>

                {/* 20. Contribution Description */}
                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1">
                    20. Briefly Describe the Nominee's Contribution to Jinshasan <span className="text-[#ae2b2b]">*</span>
                  </label>
                  <p className="text-xs text-gray-400 mb-2">
                    Please describe the activities undertaken, responsibilities handled, key contributions and impact created through his Shasan Seva.
                  </p>
                  <textarea
                    name="contribution_description"
                    required
                    rows="4"
                    value={form.contribution_description}
                    onChange={handleChange}
                    placeholder="Describe specific activities, leadership roles, responsibilities handled and impact created..."
                    className="w-full p-4 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition leading-relaxed resize-y"
                  ></textarea>
                </div>

                {/* 21. Significant Initiatives / Achievements */}
                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1">
                    21. Significant Initiatives / Achievements of the Nominee
                    <span className="text-gray-400 font-normal lowercase ml-1">(optional)</span>
                  </label>
                  <p className="text-xs text-gray-400 mb-2">
                    Mention any notable projects, initiatives, achievements or milestones.
                  </p>
                  <textarea
                    name="initiatives_achievements"
                    rows="3"
                    value={form.initiatives_achievements}
                    onChange={handleChange}
                    placeholder="Any major projects initiated, key recognitions, or milestones achieved..."
                    className="w-full p-4 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition leading-relaxed resize-y"
                  ></textarea>
                </div>

              </div>
            </div>

            {/* SECTION 4: Wife's Contribution and Support */}
            <div className="bg-white rounded-3xl p-6 sm:p-8 border border-[#ae2b2b]/15 shadow-md relative overflow-hidden">
              <div className="absolute top-0 right-0 h-32 w-32 bg-[#ae2b2b]/5 rounded-bl-full pointer-events-none" />

              <div className="flex items-center gap-3 border-b border-gray-100 pb-4 mb-6">
                <div className="h-9 w-9 rounded-xl bg-[#ae2b2b]/10 text-[#ae2b2b] flex items-center justify-center font-bold text-sm">
                  4
                </div>
                <div>
                  <h2 className="text-lg sm:text-xl font-bold text-gray-900 font-serif">
                    Wife's Contribution and Support
                  </h2>
                  <p className="text-xs text-gray-500">Recognizing the silent foundation behind the Shasan Sevak</p>
                </div>
              </div>

              <div className="space-y-6">
                {/* 22. Wife's Support */}
                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1">
                    22. How Has the Nominee's Wife Supported His Jinshasan Seva?
                    <span className="text-gray-400 font-normal lowercase ml-1">(optional)</span>
                  </label>
                  <p className="text-xs text-gray-400 mb-2">
                    Please describe how she has encouraged, supported or contributed to her husband's Shasan Seva (e.g. managing household responsibilities, encouraging his participation, accompanying him, etc.).
                  </p>
                  <textarea
                    name="wife_support_description"
                    rows="4"
                    value={form.wife_support_description}
                    onChange={handleChange}
                    placeholder="Describe her daily support, adjustments made, encouragement given, and sacrifices..."
                    className="w-full p-4 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition leading-relaxed resize-y"
                  ></textarea>
                </div>

                {/* 23. Particular Incident */}
                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1">
                    23. Share Any Particular Incident That Reflects Her Support, Sacrifice or Dedication
                    <span className="text-gray-400 font-normal lowercase ml-1">(optional)</span>
                  </label>
                  <p className="text-xs text-gray-400 mb-2">
                    If you are aware of any meaningful incident or example, please share it.
                  </p>
                  <textarea
                    name="wife_incident_story"
                    rows="3"
                    value={form.wife_incident_story}
                    onChange={handleChange}
                    placeholder="Share any special memory or moment of unwavering support..."
                    className="w-full p-4 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition leading-relaxed resize-y"
                  ></textarea>
                </div>
              </div>
            </div>

            {/* SECTION 5: Declaration and Submission */}
            <div className="bg-white rounded-3xl p-6 sm:p-8 border border-gray-100 shadow-md">
              <div className="flex items-center gap-3 border-b border-gray-100 pb-4 mb-6">
                <div className="h-9 w-9 rounded-xl bg-[#ae2b2b]/10 text-[#ae2b2b] flex items-center justify-center font-bold text-sm">
                  5
                </div>
                <div>
                  <h2 className="text-lg sm:text-xl font-bold text-gray-900 font-serif">
                    Declaration and Submission
                  </h2>
                  <p className="text-xs text-gray-500">Please review and confirm the statements below</p>
                </div>
              </div>

              <div className="space-y-4">
                {/* 24. Declaration of Authenticity */}
                <label className="flex items-start gap-3 p-3.5 rounded-2xl border border-gray-200 bg-gray-50/70 hover:bg-gray-50 cursor-pointer transition select-none">
                  <input
                    type="checkbox"
                    name="decl_authenticity"
                    required
                    checked={form.decl_authenticity}
                    onChange={handleChange}
                    className="mt-1 rounded text-[#ae2b2b] focus:ring-[#ae2b2b] shrink-0"
                  />
                  <span className="text-xs sm:text-sm text-gray-800 leading-relaxed font-medium">
                    24. <strong>Declaration of Authenticity:</strong> I hereby declare that the information provided in this nomination form is true and accurate to the best of my knowledge. <span className="text-[#ae2b2b]">*</span>
                  </span>
                </label>

                {/* 25. Consent for Verification */}
                <div className="space-y-2.5 pt-2">
                  <p className="text-xs font-bold uppercase tracking-wider text-gray-700">
                    25. Consent for Verification <span className="text-[#ae2b2b]">*</span>
                  </p>

                  <label className="flex items-start gap-3 p-3.5 rounded-2xl border border-gray-200 bg-gray-50/70 hover:bg-gray-50 cursor-pointer transition select-none">
                    <input
                      type="checkbox"
                      name="consent_truth"
                      required
                      checked={form.consent_truth}
                      onChange={handleChange}
                      className="mt-1 rounded text-[#ae2b2b] focus:ring-[#ae2b2b] shrink-0"
                    />
                    <span className="text-xs sm:text-sm text-gray-700 leading-relaxed">
                      I confirm that the information provided in this form are true to the best of my knowledge.
                    </span>
                  </label>

                  <label className="flex items-start gap-3 p-3.5 rounded-2xl border border-gray-200 bg-gray-50/70 hover:bg-gray-50 cursor-pointer transition select-none">
                    <input
                      type="checkbox"
                      name="consent_contact"
                      required
                      checked={form.consent_contact}
                      onChange={handleChange}
                      className="mt-1 rounded text-[#ae2b2b] focus:ring-[#ae2b2b] shrink-0"
                    />
                    <span className="text-xs sm:text-sm text-gray-700 leading-relaxed">
                      I understand that the SAMARPANAM organizing committee may contact me and the individuals mentioned in this nomination for verification and event-related purposes. I confirm that I have informed the individuals whose contact details I am sharing, or have their permission to do so.
                    </span>
                  </label>

                  <label className="flex items-start gap-3 p-3.5 rounded-2xl border border-gray-200 bg-gray-50/70 hover:bg-gray-50 cursor-pointer transition select-none">
                    <input
                      type="checkbox"
                      name="consent_decision"
                      required
                      checked={form.consent_decision}
                      onChange={handleChange}
                      className="mt-1 rounded text-[#ae2b2b] focus:ring-[#ae2b2b] shrink-0"
                    />
                    <span className="text-xs sm:text-sm text-gray-700 leading-relaxed">
                      I understand that submission of a nomination does not guarantee selection for felicitation, and the organizing committee's decision will be final.
                    </span>
                  </label>
                </div>
              </div>

              {/* Official Communication Notice */}
              <div className="mt-6 p-4 sm:p-5 rounded-2xl bg-[#ae2b2b]/5 border border-[#ae2b2b]/20 text-gray-800 text-xs sm:text-sm leading-relaxed space-y-2">
                <div className="flex items-center gap-2 font-bold text-[#ae2b2b]">
                  <Phone className="h-4 w-4 shrink-0" />
                  <span>Important Notice</span>
                </div>
                <p>
                  Please note that all official communications, updates, and inquiries related to SAMARPANAM will be conducted through the official Team I ❤️ Jinshasan contact number:{" "}
                  <a href="tel:+917045355421" className="font-bold text-[#ae2b2b] hover:underline whitespace-nowrap">
                    +91 7045355421
                  </a>.
                </p>
                <p className="text-gray-600">
                  We request you to save this number and rely solely on updates sent from it for all official information regarding the event.
                </p>
              </div>

              {/* Submit Button */}
              <div className="mt-8 pt-6 border-t border-gray-100">
                <button
                  type="submit"
                  disabled={isSubmitting}
                  className="w-full py-4 px-6 rounded-2xl bg-gradient-to-r from-[#ae2b2b] to-[#8f1f1f] hover:from-[#9c2424] hover:to-[#7a1717] text-white font-bold text-base tracking-wide shadow-xl shadow-red-900/20 hover:shadow-2xl hover:scale-[1.008] active:scale-[0.99] transition-all flex items-center justify-center gap-2 cursor-pointer disabled:opacity-60 disabled:cursor-not-allowed"
                >
                  {isSubmitting ? (
                    <>
                      <div className="h-5 w-5 border-2 border-white border-t-transparent rounded-full animate-spin" />
                      <span>Submitting Nomination...</span>
                    </>
                  ) : (
                    <>
                      <Send className="h-5 w-5" />
                      <span>SUBMIT NOMINATION</span>
                    </>
                  )}
                </button>
              </div>

            </div>

          </form>
        )}

      </div>
    </div>
  );
}
