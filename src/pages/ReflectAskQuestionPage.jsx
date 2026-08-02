import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { supabase } from "../lib/supabase";
import { ArrowLeft, HelpCircle, Send, CheckCircle, Sparkles } from "lucide-react";

const SESSIONS = [
  "What if you are Wrong?",
  "Autopilot Mode: Off",
  "Simple is Ample",
  "Darr ke Aage Jeet Hai",
  "Shasan: Present To Future"
];

// Fallback project ID for Reflect PRJ-008-02 if needed
const REFLECT_PROJECT_ID = "e65d8362-e612-4217-b769-cf74719c8d5a";

export default function ReflectAskQuestionPage() {
  const navigate = useNavigate();
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);

  const [form, setForm] = useState({
    session: "",
    is_anonymous: false,
    name: "",
    mobile: "",
    age: "",
    email: "",
    city: "",
    question: ""
  });

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!form.question.trim()) {
      alert("Please write your question before submitting.");
      return;
    }

    setIsSubmitting(true);

    try {
      // Find Reflect project ID from database if needed
      let targetProjectId = REFLECT_PROJECT_ID;
      const { data: pData } = await supabase
        .from("projects")
        .select("id")
        .eq("project_code", "PRJ-008-02")
        .single();
      
      if (pData?.id) {
        targetProjectId = pData.id;
      }

      const payload = {
        project_id: targetProjectId,
        session: form.session || null,
        is_anonymous: form.is_anonymous,
        name: form.is_anonymous ? null : (form.name || null),
        mobile: form.is_anonymous ? null : (form.mobile || null),
        age: form.is_anonymous || !form.age ? null : parseInt(form.age),
        email: form.is_anonymous ? null : (form.email || null),
        city: form.is_anonymous ? null : (form.city || null),
        question: form.question.trim()
      };

      const { error } = await supabase
        .from("reflect_questions")
        .insert(payload);

      if (error) throw error;

      setSubmitted(true);
    } catch (err) {
      console.error("Error submitting reflect question:", err);
      alert("Failed to submit question. Please try again.");
    } finally {
      setIsSubmitting(false);
    }
  };

  const resetForm = () => {
    setForm({
      session: "",
      is_anonymous: false,
      name: "",
      mobile: "",
      age: "",
      email: "",
      city: "",
      question: ""
    });
    setSubmitted(false);
  };

  return (
    <div className="min-h-screen w-full bg-gray-50/80 py-6 sm:py-12 px-3 sm:px-6 lg:px-8 font-sans overflow-y-auto touch-pan-y">
      <div className="max-w-2xl mx-auto w-full">
        {/* Back Button */}
        <button
          onClick={() => navigate(-1)}
          className="flex items-center text-gray-500 hover:text-gray-900 mb-6 font-medium transition-colors group cursor-pointer"
        >
          <ArrowLeft className="h-5 w-5 mr-1.5 group-hover:-translate-x-1 transition-transform" />
          Back
        </button>

        {submitted ? (
          <div className="bg-white p-8 sm:p-10 rounded-3xl shadow-xl border border-gray-100 text-center animate-in fade-in zoom-in-95 duration-500">
            <div className="mx-auto flex items-center justify-center h-20 w-20 rounded-full bg-emerald-100 mb-6">
              <CheckCircle className="h-10 w-10 text-emerald-600" />
            </div>
            <h2 className="text-3xl font-bold text-gray-900 mb-3 font-serif">Question Submitted!</h2>
            <p className="text-gray-600 mb-6 leading-relaxed max-w-md mx-auto">
              Thank you for asking your question. Our panel will address questions submitted for the <strong>Reflect Workshop</strong>.
            </p>
            <div className="bg-amber-50/70 border border-amber-200/60 rounded-2xl p-4 mb-8 text-left text-sm text-amber-900">
              <div className="flex items-center gap-2 font-bold mb-1">
                <Sparkles className="h-4 w-4 text-amber-600" /> Note:
              </div>
              Your question has been securely sent to the workshop organizers.
            </div>

            <div className="flex flex-col sm:flex-row gap-3 justify-center">
              <button
                onClick={resetForm}
                className="py-3.5 px-6 rounded-xl font-semibold border border-gray-200 text-gray-700 bg-white hover:bg-gray-50 transition-colors shadow-sm cursor-pointer"
              >
                Ask Another Question
              </button>
              <button
                onClick={() => navigate("/project/PRJ-008-02")}
                className="py-3.5 px-6 rounded-xl font-semibold text-white bg-[#ae2b2b] hover:bg-[#8f1f1f] transition-all shadow-md cursor-pointer"
              >
                View Reflect Workshop
              </button>
            </div>
          </div>
        ) : (
          <div className="bg-white rounded-3xl shadow-xl border border-gray-100 overflow-hidden animate-in fade-in slide-in-from-bottom-6 duration-500">
            {/* Header */}
            <div className="bg-gradient-to-r from-[#5c1212] via-[#8b1e1e] to-[#ae2b2b] p-6 sm:p-8 text-white relative overflow-hidden">
              <div className="absolute -right-8 -top-8 opacity-10 pointer-events-none">
                <HelpCircle size={180} />
              </div>
              <div className="relative z-10">
                <span className="inline-flex items-center gap-1.5 uppercase tracking-widest text-[11px] font-bold text-amber-300 bg-black/30 backdrop-blur-xs px-3 py-1 rounded-full mb-3 border border-amber-400/20">
                  <HelpCircle className="h-3.5 w-3.5" /> Reflect Workshop
                </span>
                <h1 className="text-2xl sm:text-3xl font-bold font-serif leading-tight">
                  Ask a Question
                </h1>
                <p className="text-white/80 text-sm mt-2 leading-relaxed">
                  Have doubts, thoughts, or queries related to the Reflect sessions? Ask your question here. You can also submit anonymously.
                </p>
              </div>
            </div>

            {/* Form */}
            <form onSubmit={handleSubmit} className="p-6 sm:p-8 space-y-6">
              
              {/* Select Session */}
              <div>
                <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">
                  Select Workshop Session <span className="text-gray-400 font-normal lowercase">(optional)</span>
                </label>
                <select
                  value={form.session}
                  onChange={(e) => setForm({ ...form, session: e.target.value })}
                  className="w-full p-3.5 border border-gray-200 rounded-xl bg-gray-50/50 focus:bg-white focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] outline-none text-sm font-medium text-gray-800 transition-all"
                >
                  <option value="">-- All Sessions / General Question --</option>
                  {SESSIONS.map((sess) => (
                    <option key={sess} value={sess}>
                      {sess}
                    </option>
                  ))}
                </select>
              </div>

              {/* Anonymous Checkbox */}
              <div className="bg-amber-50/60 border border-amber-200/50 p-4 rounded-2xl">
                <label className="flex items-center gap-3 cursor-pointer select-none">
                  <input
                    type="checkbox"
                    checked={form.is_anonymous}
                    onChange={(e) => setForm({ ...form, is_anonymous: e.target.checked })}
                    className="h-5 w-5 rounded border-amber-300 text-[#ae2b2b] focus:ring-[#ae2b2b]/20 cursor-pointer"
                  />
                  <div>
                    <span className="font-bold text-gray-900 text-sm block">Ask Anonymously</span>
                    <span className="text-xs text-gray-500">Your name and personal details will not be recorded with your question.</span>
                  </div>
                </label>
              </div>

              {/* Personal Details (If NOT anonymous) */}
              {!form.is_anonymous && (
                <div className="space-y-4 animate-in fade-in slide-in-from-top-2 duration-300 bg-gray-50/70 p-4 sm:p-5 rounded-2xl border border-gray-100">
                  <h4 className="text-xs font-bold uppercase tracking-wider text-gray-500 border-b border-gray-200 pb-2">
                    Your Information <span className="text-gray-400 lowercase font-normal">(optional)</span>
                  </h4>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                      <label className="block text-xs font-semibold text-gray-600 mb-1">Full Name</label>
                      <input
                        type="text"
                        placeholder="Enter your name"
                        value={form.name}
                        onChange={(e) => setForm({ ...form, name: e.target.value })}
                        className="w-full p-3 border border-gray-200 rounded-xl bg-white focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] outline-none text-sm"
                      />
                    </div>
                    <div>
                      <label className="block text-xs font-semibold text-gray-600 mb-1">Contact No. (WhatsApp)</label>
                      <input
                        type="tel"
                        placeholder="+91 XXXXX XXXXX"
                        value={form.mobile}
                        onChange={(e) => setForm({ ...form, mobile: e.target.value })}
                        className="w-full p-3 border border-gray-200 rounded-xl bg-white focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] outline-none text-sm"
                      />
                    </div>
                  </div>

                  <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
                    <div>
                      <label className="block text-xs font-semibold text-gray-600 mb-1">Age</label>
                      <input
                        type="number"
                        placeholder="e.g. 24"
                        value={form.age}
                        onChange={(e) => setForm({ ...form, age: e.target.value })}
                        className="w-full p-3 border border-gray-200 rounded-xl bg-white focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] outline-none text-sm"
                      />
                    </div>
                    <div>
                      <label className="block text-xs font-semibold text-gray-600 mb-1">Email Address</label>
                      <input
                        type="email"
                        placeholder="you@example.com"
                        value={form.email}
                        onChange={(e) => setForm({ ...form, email: e.target.value })}
                        className="w-full p-3 border border-gray-200 rounded-xl bg-white focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] outline-none text-sm"
                      />
                    </div>
                    <div>
                      <label className="block text-xs font-semibold text-gray-600 mb-1">City</label>
                      <input
                        type="text"
                        placeholder="e.g. Mumbai"
                        value={form.city}
                        onChange={(e) => setForm({ ...form, city: e.target.value })}
                        className="w-full p-3 border border-gray-200 rounded-xl bg-white focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] outline-none text-sm"
                      />
                    </div>
                  </div>
                </div>
              )}

              {/* Question Textarea */}
              <div>
                <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">
                  Your Question / Query <span className="text-[#ae2b2b]">*</span>
                </label>
                <textarea
                  required
                  rows="5"
                  placeholder="Write your question in detail here..."
                  value={form.question}
                  onChange={(e) => setForm({ ...form, question: e.target.value })}
                  className="w-full p-4 border border-gray-200 rounded-2xl bg-gray-50/50 focus:bg-white focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] outline-none text-sm font-medium leading-relaxed"
                ></textarea>
              </div>

              {/* Submit Button */}
              <button
                type="submit"
                disabled={isSubmitting}
                className="w-full flex items-center justify-center gap-2 py-4 px-6 rounded-2xl font-bold text-white bg-gradient-to-r from-[#ae2b2b] to-[#8f1f1f] hover:from-[#992727] hover:to-[#7f1919] shadow-lg shadow-red-100 transition-all hover:scale-[1.01] active:scale-[0.99] disabled:opacity-50 cursor-pointer"
              >
                {isSubmitting ? (
                  "Submitting..."
                ) : (
                  <>
                    <Send className="h-4 w-4" /> Submit Question
                  </>
                )}
              </button>
            </form>
          </div>
        )}
      </div>
    </div>
  );
}
