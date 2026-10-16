import { useState } from "react";
import { Link } from "react-router-dom";
import { supabase } from "@/lib/supabase";
import {
  HelpCircle,
  Send,
  CheckCircle2,
  Sparkles,
  BookOpen,
  ShieldCheck,
  HeartHandshake,
  User,
  Phone,
  Mail,
  MapPin,
  Calendar,
  MessageSquare,
  ArrowRight
} from "lucide-react";

export default function AskQuestionPage() {
  const [form, setForm] = useState({
    name: "",
    phone_no: "",
    email: "",
    gender: "Male",
    address: "",
    age: "",
    question: "",
  });

  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [error, setError] = useState("");

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");

    if (!form.name.trim()) {
      setError("Please enter your name.");
      return;
    }
    if (!form.phone_no.trim()) {
      setError("Please enter your phone number.");
      return;
    }
    if (!form.question.trim()) {
      setError("Please type your question.");
      return;
    }

    setIsSubmitting(true);

    try {
      const parsedAge = form.age && !isNaN(parseInt(form.age, 10))
        ? parseInt(form.age, 10)
        : null;

      const payload = {
        name: form.name.trim(),
        phone_no: form.phone_no.trim(),
        email: form.email.trim() || null,
        gender: form.gender || null,
        address: form.address.trim() || null,
        age: parsedAge,
        question: form.question.trim(),
        status: "pending",
      };

      const { error: insertError } = await supabase
        .from("questions")
        .insert(payload);

      if (insertError) throw insertError;

      setSubmitted(true);
      window.scrollTo({ top: 0, behavior: "smooth" });
    } catch (err) {
      console.error("Error submitting question:", err);
      setError("Failed to submit your question. Please check your connection and try again.");
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleReset = () => {
    setForm({
      name: "",
      phone_no: "",
      email: "",
      gender: "Male",
      address: "",
      age: "",
      question: "",
    });
    setSubmitted(false);
    setError("");
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-[#fbf8f7] via-white to-[#faf7f6] py-10 px-4 sm:px-6 lg:px-8">
      <div className="max-w-5xl mx-auto">
        
        {/* Hero Section */}
        <div className="text-center max-w-3xl mx-auto mb-10 sm:mb-12">
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-[#ae2b2b]/10 text-[#ae2b2b] text-xs font-bold tracking-widest uppercase mb-4 shadow-xs">
            <Sparkles className="h-3.5 w-3.5" />
            Open Dialogue & Learning
          </div>
          <h1 className="text-3xl sm:text-5xl font-bold text-gray-900 font-serif tracking-tight leading-tight">
            Have a Question?
          </h1>
          <p className="mt-4 text-base sm:text-lg text-gray-600 font-serif leading-relaxed">
            Have a question, doubt, or something you'd like to discuss about Jainism or Life?
          </p>
          <p className="mt-1 text-sm sm:text-base text-gray-500">
            Share your question with us through this form, and we'll do our best to get back to you.
          </p>
        </div>

        {submitted ? (
          /* Success Screen */
          <div className="max-w-xl mx-auto bg-white rounded-3xl p-8 sm:p-12 border border-[#ae2b2b]/15 shadow-xl text-center animate-in fade-in zoom-in-95 duration-300">
            <div className="mx-auto mb-6 h-18 w-18 rounded-full bg-emerald-50 text-emerald-600 flex items-center justify-center ring-8 ring-emerald-50/50">
              <CheckCircle2 className="h-10 w-10" />
            </div>
            <h2 className="text-2xl sm:text-3xl font-bold text-gray-900 font-serif">
              Thank You!
            </h2>
            <p className="mt-3 text-gray-600 text-sm sm:text-base leading-relaxed">
              Your question has been received with gratitude. Our team and mentors will review it carefully and reach out to you.
            </p>

            <div className="mt-6 p-4 rounded-2xl bg-amber-50/70 border border-amber-200/70 text-amber-900 text-xs sm:text-sm text-left flex gap-3 items-start">
              <BookOpen className="h-5 w-5 text-[#ae2b2b] shrink-0 mt-0.5" />
              <div>
                <strong className="block font-semibold">Every curiosity is valued.</strong>
                Questions lead to clarity, and clarity leads to inner peace. Keep seeking knowledge.
              </div>
            </div>

            <div className="mt-8 flex flex-col sm:flex-row gap-3 justify-center">
              <button
                onClick={handleReset}
                className="px-6 py-3 rounded-xl bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white font-semibold text-sm transition-all shadow-md shadow-red-900/10 cursor-pointer"
              >
                Ask Another Question
              </button>
              <Link
                to="/"
                className="px-6 py-3 rounded-xl border border-gray-200 hover:bg-gray-50 text-gray-700 font-semibold text-sm transition-all text-center inline-flex items-center justify-center gap-1.5"
              >
                Return Home <ArrowRight className="h-4 w-4" />
              </Link>
            </div>
          </div>
        ) : (
          /* Form & Side Card */
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
            
            {/* Left Column: Inspiring Guidance Card */}
            <div className="lg:col-span-5 space-y-6">
              <div className="bg-gradient-to-br from-[#5c1212] via-[#8f1f1f] to-[#ae2b2b] text-white p-7 sm:p-8 rounded-3xl shadow-xl relative overflow-hidden">
                {/* Background decorative circles */}
                <div className="absolute -right-10 -bottom-10 h-44 w-44 rounded-full bg-white/5 blur-2xl pointer-events-none" />
                <div className="absolute -left-10 -top-10 h-36 w-36 rounded-full bg-white/5 blur-xl pointer-events-none" />

                <span className="inline-flex items-center gap-1.5 text-xs font-semibold tracking-wider uppercase px-3 py-1 rounded-full bg-white/15 text-white backdrop-blur-xs mb-4">
                  <HeartHandshake className="h-3.5 w-3.5" /> Safe & Respectful Space
                </span>

                <h3 className="text-xl sm:text-2xl font-bold font-serif leading-snug">
                  "No question is silly when asked with sincere intent."
                </h3>

                <p className="mt-3 text-red-100 text-sm leading-relaxed">
                  Have any questions or doubts related to Jainism, spirituality, or life in general? 
                  Feel free to ask anything. No question is too small!
                </p>

                <div className="mt-6 pt-6 border-t border-white/20 space-y-3.5 text-xs sm:text-sm text-red-50">
                  <div className="flex items-center gap-3">
                    <ShieldCheck className="h-4 w-4 text-amber-300 shrink-0" />
                    <span>Your details remain completely private and secure.</span>
                  </div>
                  <div className="flex items-center gap-3">
                    <BookOpen className="h-4 w-4 text-amber-300 shrink-0" />
                    <span>Researched answers from experienced mentors & scholars.</span>
                  </div>
                  <div className="flex items-center gap-3">
                    <MessageSquare className="h-4 w-4 text-amber-300 shrink-0" />
                    <span>Responses communicated via Phone or Email.</span>
                  </div>
                </div>
              </div>

              {/* Helpful Tips Card */}
              <div className="bg-white rounded-2xl p-6 border border-gray-100 shadow-sm space-y-3">
                <h4 className="text-sm font-bold text-gray-800 uppercase tracking-wider flex items-center gap-2">
                  <HelpCircle className="h-4 w-4 text-[#ae2b2b]" /> What can you ask?
                </h4>
                <ul className="text-xs sm:text-sm text-gray-600 space-y-2 list-disc list-inside">
                  <li>Philosophy, rituals, or core Jain concepts</li>
                  <li>Balancing modern career & spiritual principles</li>
                  <li>Everyday ethics, non-violence, and mindfulness</li>
                  <li>Overcoming anxiety, fear, or life challenges</li>
                </ul>
              </div>
            </div>

            {/* Right Column: Question Form */}
            <div className="lg:col-span-7 bg-white rounded-3xl p-6 sm:p-9 border border-gray-100 shadow-xl relative">
              <div className="border-b border-gray-100 pb-5 mb-6">
                <h2 className="text-xl sm:text-2xl font-bold text-gray-900 font-serif">
                  Ask Your Question
                </h2>
                <p className="mt-1 text-sm text-gray-500">
                  Please provide your details below so we can share our response with you.
                </p>
              </div>

              {error && (
                <div className="mb-6 p-4 rounded-xl bg-red-50 border border-red-200 text-red-700 text-sm">
                  {error}
                </div>
              )}

              <form onSubmit={handleSubmit} className="space-y-5">
                
                {/* Name */}
                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                    Full Name <span className="text-[#ae2b2b]">*</span>
                  </label>
                  <div className="relative">
                    <User className="absolute left-3.5 top-3.5 h-4 w-4 text-gray-400" />
                    <input
                      type="text"
                      name="name"
                      required
                      value={form.name}
                      onChange={handleChange}
                      className="w-full pl-10 pr-4 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition"
                    />
                  </div>
                </div>

                {/* Phone & Email */}
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                      Phone Number <span className="text-[#ae2b2b]">*</span>
                    </label>
                    <div className="relative">
                      <Phone className="absolute left-3.5 top-3.5 h-4 w-4 text-gray-400" />
                      <input
                        type="tel"
                        name="phone_no"
                        required
                        value={form.phone_no}
                        onChange={handleChange}
                      
                        className="w-full pl-10 pr-4 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition"
                      />
                    </div>
                  </div>

                  <div>
                    <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                      Email Address <span className="text-gray-400 font-normal lowercase">(optional)</span>
                    </label>
                    <div className="relative">
                      <Mail className="absolute left-3.5 top-3.5 h-4 w-4 text-gray-400" />
                      <input
                        type="email"
                        name="email"
                        value={form.email}
                        onChange={handleChange}
                
                        className="w-full pl-10 pr-4 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition"
                      />
                    </div>
                  </div>
                </div>

                {/* Gender & Age */}
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                      Gender
                    </label>
                    <div className="grid grid-cols-3 gap-2">
                      {["Male", "Female"].map((g) => (
                        <button
                          key={g}
                          type="button"
                          onClick={() => setForm((prev) => ({ ...prev, gender: g }))}
                          className={`py-2.5 text-xs font-semibold rounded-xl border transition-all text-center cursor-pointer ${
                            form.gender === g
                              ? "bg-[#ae2b2b] text-white border-[#ae2b2b] shadow-xs"
                              : "bg-gray-50 border-gray-200 text-gray-700 hover:bg-gray-100"
                          }`}
                        >
                          {g}
                        </button>
                      ))}
                    </div>
                  </div>

                  <div>
                    <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                      Age <span className="text-gray-400 font-normal lowercase">(optional)</span>
                    </label>
                    <div className="relative">
                      <Calendar className="absolute left-3.5 top-3.5 h-4 w-4 text-gray-400" />
                      <input
                        type="number"
                        name="age"
                        min="5"
                        max="120"
                        value={form.age}
                        onChange={handleChange}
                        
                        className="w-full pl-10 pr-4 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition"
                      />
                    </div>
                  </div>
                </div>

                {/* Address */}
                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                    Address / City <span className="text-gray-400 font-normal lowercase">(optional)</span>
                  </label>
                  <div className="relative">
                    <MapPin className="absolute left-3.5 top-3.5 h-4 w-4 text-gray-400" />
                    <input
                      type="text"
                      name="address"
                      value={form.address}
                      onChange={handleChange}
               
                      className="w-full pl-10 pr-4 py-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition"
                    />
                  </div>
                </div>

                {/* Question */}
                <div>
                  <div className="flex justify-between items-center mb-1.5">
                    <label className="block text-xs font-bold uppercase tracking-wider text-gray-700">
                      Your Question / Doubt <span className="text-[#ae2b2b]">*</span>
                    </label>
                    <span className="text-xs text-gray-400">Be as descriptive as you like</span>
                  </div>
                  <textarea
                    name="question"
                    required
                    rows="5"
                    value={form.question}
                    onChange={handleChange}
                    placeholder="Have any questions or doubts related to Jainism, spirituality, or life in general? Feel free to ask anything. No question is too small..."
                    className="w-full p-4 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition leading-relaxed resize-y"
                  ></textarea>
                </div>

                {/* Submit Button */}
                <button
                  type="submit"
                  disabled={isSubmitting}
                  className="w-full py-4 px-6 rounded-xl bg-gradient-to-r from-[#ae2b2b] to-[#8f1f1f] hover:from-[#9c2424] hover:to-[#7a1717] text-white font-bold text-sm tracking-wide shadow-lg shadow-red-900/15 hover:shadow-xl hover:scale-[1.008] active:scale-[0.99] transition-all flex items-center justify-center gap-2 cursor-pointer disabled:opacity-60 disabled:cursor-not-allowed"
                >
                  {isSubmitting ? (
                    <>
                      <div className="h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                      <span>Submitting Your Question...</span>
                    </>
                  ) : (
                    <>
                      <Send className="h-4 w-4" />
                      <span>Submit Question</span>
                    </>
                  )}
                </button>

                <p className="text-center text-xs text-gray-400">
                  By submitting, you agree to receive guidance or clarification on your inquiry.
                </p>
              </form>
            </div>

          </div>
        )}

      </div>
    </div>
  );
}
