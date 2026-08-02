import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { supabase } from "../lib/supabase";
import { 
  ArrowLeft, HelpCircle, Send, CheckCircle, Sparkles, Search, 
  MessageSquare, Copy, Clock, ShieldCheck, RefreshCw 
} from "lucide-react";

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
  const [activeTab, setActiveTab] = useState("ask"); // 'ask' or 'track'
  
  // Submit State
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submittedCode, setSubmittedCode] = useState("");
  const [copied, setCopied] = useState(false);

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

  // Track / Search State
  const [searchQuery, setSearchQuery] = useState("");
  const [isSearching, setIsSearching] = useState(false);
  const [searchResults, setSearchResults] = useState(null);
  const [hasSearched, setHasSearched] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!form.question.trim()) {
      alert("Please write your question before submitting.");
      return;
    }

    setIsSubmitting(true);

    try {
      let targetProjectId = REFLECT_PROJECT_ID;
      const { data: pData } = await supabase
        .from("projects")
        .select("id")
        .eq("project_code", "PRJ-008-02")
        .single();
      
      if (pData?.id) {
        targetProjectId = pData.id;
      }

      // Generate 6-char unique reference code
      const generatedCode = `Q-${Math.random().toString(36).substring(2, 7).toUpperCase()}`;

      const payload = {
        project_id: targetProjectId,
        reference_code: generatedCode,
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

      setSubmittedCode(generatedCode);
    } catch (err) {
      console.error("Error submitting reflect question:", err);
      alert("Failed to submit question. Please try again.");
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleSearch = async (e) => {
    e?.preventDefault();
    if (!searchQuery.trim()) return;

    setIsSearching(true);
    setHasSearched(true);
    const query = searchQuery.trim();

    try {
      // Search by reference_code, mobile, or email
      const { data: results, error } = await supabase
        .from("reflect_questions")
        .select("*")
        .or(`reference_code.ilike.%${query}%,mobile.ilike.%${query}%,email.ilike.%${query}%`)
        .order("created_at", { ascending: false });

      if (error) throw error;
      setSearchResults(results || []);
    } catch (err) {
      console.error("Error searching questions:", err);
      setSearchResults([]);
    } finally {
      setIsSearching(false);
    }
  };

  const copyCodeToClipboard = (code) => {
    navigator.clipboard.writeText(code);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
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
    setSubmittedCode("");
    setActiveTab("ask");
  };

  return (
    <div className="min-h-screen w-full bg-gray-50/80 py-6 sm:py-12 px-3 sm:px-6 lg:px-8 font-sans overflow-y-auto touch-pan-y">
      <div className="max-w-2xl mx-auto w-full">
        {/* Top Back Navigation */}
        <button
          onClick={() => navigate(-1)}
          className="flex items-center text-gray-500 hover:text-gray-900 mb-6 font-medium transition-colors group cursor-pointer"
        >
          <ArrowLeft className="h-5 w-5 mr-1.5 group-hover:-translate-x-1 transition-transform" />
          Back
        </button>

        {/* Header Banner */}
        <div className="bg-gradient-to-r from-[#5c1212] via-[#8b1e1e] to-[#ae2b2b] p-6 sm:p-8 text-white rounded-3xl shadow-xl relative overflow-hidden mb-6">
          <div className="absolute -right-8 -top-8 opacity-10 pointer-events-none">
            <HelpCircle size={180} />
          </div>
          <div className="relative z-10">
            <span className="inline-flex items-center gap-1.5 uppercase tracking-widest text-[11px] font-bold text-amber-300 bg-black/30 backdrop-blur-xs px-3 py-1 rounded-full mb-3 border border-amber-400/20">
              <HelpCircle className="h-3.5 w-3.5" /> Reflect Workshop Portal
            </span>
            <h1 className="text-2xl sm:text-3xl font-bold font-serif leading-tight">
              Questions & Answers
            </h1>
            <p className="text-white/80 text-sm mt-2 leading-relaxed">
              Ask your questions regarding Reflect workshop sessions or check replies from the organizers.
            </p>

            {/* Mode Switcher Tabs */}
            <div className="flex bg-black/30 p-1 rounded-2xl mt-6 border border-white/10 max-w-sm">
              <button
                type="button"
                onClick={() => setActiveTab("ask")}
                className={`flex-1 py-2 px-4 rounded-xl text-xs font-bold transition-all cursor-pointer flex items-center justify-center gap-2 ${
                  activeTab === "ask" ? "bg-white text-[#ae2b2b] shadow-md" : "text-white/80 hover:text-white"
                }`}
              >
                <Send className="h-3.5 w-3.5" /> Ask Question
              </button>
              <button
                type="button"
                onClick={() => setActiveTab("track")}
                className={`flex-1 py-2 px-4 rounded-xl text-xs font-bold transition-all cursor-pointer flex items-center justify-center gap-2 ${
                  activeTab === "track" ? "bg-white text-[#ae2b2b] shadow-md" : "text-white/80 hover:text-white"
                }`}
              >
                <Search className="h-3.5 w-3.5" /> Check Reply
              </button>
            </div>
          </div>
        </div>

        {/* TAB 1: ASK QUESTION */}
        {activeTab === "ask" && (
          <>
            {submittedCode ? (
              <div className="bg-white p-8 sm:p-10 rounded-3xl shadow-xl border border-gray-100 text-center animate-in fade-in zoom-in-95 duration-500">
                <div className="mx-auto flex items-center justify-center h-20 w-20 rounded-full bg-emerald-100 mb-6">
                  <CheckCircle className="h-10 w-10 text-emerald-600" />
                </div>
                <h2 className="text-2xl sm:text-3xl font-bold text-gray-900 mb-2 font-serif">Question Submitted!</h2>
                <p className="text-gray-600 mb-6 leading-relaxed max-w-md mx-auto text-sm sm:text-base">
                  Your question has been sent to the Reflect workshop panel.
                </p>

                {/* Reference Code Box */}
                <div className="bg-amber-50/80 border border-amber-200/80 rounded-2xl p-5 mb-6 text-center max-w-md mx-auto">
                  <span className="text-xs font-bold uppercase tracking-wider text-amber-800 block mb-1">
                    Your Question Reference Code
                  </span>
                  <div className="flex items-center justify-center gap-3 my-2">
                    <span className="font-mono font-extrabold text-2xl text-[#ae2b2b] tracking-wider">
                      {submittedCode}
                    </span>
                    <button
                      onClick={() => copyCodeToClipboard(submittedCode)}
                      className="p-2 rounded-xl bg-amber-100 hover:bg-amber-200 text-amber-900 transition-colors cursor-pointer"
                      title="Copy Reference Code"
                    >
                      <Copy className="h-4 w-4" />
                    </button>
                  </div>
                  {copied && (
                    <span className="text-xs font-semibold text-emerald-600 block animate-in fade-in">
                      Copied to clipboard!
                    </span>
                  )}
                  <p className="text-xs text-amber-900/80 mt-2">
                    Save this reference code to track the official reply in the <strong>Check Reply</strong> tab!
                  </p>
                </div>

                <div className="flex flex-col sm:flex-row gap-3 justify-center">
                  <button
                    onClick={() => {
                      setSearchQuery(submittedCode);
                      setActiveTab("track");
                      setTimeout(() => {
                        const fakeEvent = { preventDefault: () => {} };
                        handleSearch(fakeEvent);
                      }, 100);
                    }}
                    className="py-3.5 px-6 rounded-xl font-bold text-white bg-[#ae2b2b] hover:bg-[#8f1f1f] transition-all shadow-md cursor-pointer text-sm"
                  >
                    Track Status Now
                  </button>
                  <button
                    onClick={resetForm}
                    className="py-3.5 px-6 rounded-xl font-semibold border border-gray-200 text-gray-700 bg-white hover:bg-gray-50 transition-colors shadow-sm cursor-pointer text-sm"
                  >
                    Ask Another Question
                  </button>
                </div>
              </div>
            ) : (
              <div className="bg-white rounded-3xl shadow-xl border border-gray-100 overflow-hidden animate-in fade-in slide-in-from-bottom-4 duration-400">
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
                        <span className="text-xs text-gray-500">Your name and contact details will not be recorded.</span>
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
                    className="w-full flex items-center justify-center gap-2 py-4 px-6 rounded-2xl font-bold text-white bg-gradient-to-r from-[#ae2b2b] to-[#8f1f1f] hover:from-[#992727] hover:to-[#7f1919] shadow-lg shadow-red-100 transition-all hover:scale-[1.01] active:scale-[0.99] disabled:opacity-50 cursor-pointer text-base"
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
          </>
        )}

        {/* TAB 2: TRACK / CHECK REPLY */}
        {activeTab === "track" && (
          <div className="bg-white rounded-3xl shadow-xl border border-gray-100 p-6 sm:p-8 animate-in fade-in slide-in-from-bottom-4 duration-400">
            <h3 className="text-xl font-bold text-gray-900 font-serif mb-2">
              Track Question Status & Reply
            </h3>
            <p className="text-xs sm:text-sm text-gray-500 mb-6">
              Enter your <strong>Reference Code</strong> (e.g. <code>Q-8F9A1</code>), Mobile Number, or Email to view the official response from the Reflect team.
            </p>

            <form onSubmit={handleSearch} className="flex gap-2 mb-8">
              <input
                type="text"
                placeholder="Enter Reference Code, Mobile, or Email..."
                required
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="flex-1 p-3.5 border border-gray-200 rounded-2xl bg-gray-50/50 focus:bg-white focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] outline-none text-sm font-medium"
              />
              <button
                type="submit"
                disabled={isSearching}
                className="px-6 py-3.5 rounded-2xl font-bold text-white bg-[#ae2b2b] hover:bg-[#8f1f1f] transition-all shadow-md cursor-pointer flex items-center gap-2 text-sm shrink-0"
              >
                {isSearching ? <RefreshCw className="h-4 w-4 animate-spin" /> : <Search className="h-4 w-4" />}
                Search
              </button>
            </form>

            {/* Results Section */}
            {hasSearched && (
              <div className="space-y-6">
                {isSearching ? (
                  <div className="text-center py-10 text-gray-500">Searching database...</div>
                ) : !searchResults || searchResults.length === 0 ? (
                  <div className="text-center py-10 bg-gray-50 rounded-2xl border border-dashed border-gray-200">
                    <HelpCircle className="h-10 w-10 text-gray-400 mx-auto mb-2" />
                    <h4 className="font-bold text-gray-800">No question found</h4>
                    <p className="text-xs text-gray-500 mt-1">Please double check your Reference Code, Mobile, or Email.</p>
                  </div>
                ) : (
                  <div className="space-y-6">
                    {searchResults.map((item) => (
                      <div
                        key={item.id}
                        className="border border-gray-200 rounded-2xl p-5 sm:p-6 bg-white shadow-sm space-y-4"
                      >
                        {/* Header Badges */}
                        <div className="flex flex-wrap items-center justify-between gap-2 border-b border-gray-100 pb-3">
                          <div className="flex items-center gap-2">
                            {item.reference_code && (
                              <span className="font-mono font-bold text-xs bg-amber-100 text-amber-900 px-2.5 py-1 rounded-lg border border-amber-200">
                                {item.reference_code}
                              </span>
                            )}
                            <span className="text-xs font-semibold text-gray-600 bg-gray-100 px-2.5 py-1 rounded-lg">
                              {item.session || "General Question"}
                            </span>
                          </div>
                          <span className="text-xs text-gray-400">
                            Submitted on {new Date(item.created_at).toLocaleDateString()}
                          </span>
                        </div>

                        {/* Question Text */}
                        <div>
                          <span className="text-[11px] font-bold uppercase tracking-wider text-gray-400 block mb-1">
                            Question
                          </span>
                          <p className="text-gray-900 font-serif text-base sm:text-lg leading-relaxed bg-gray-50 p-4 rounded-xl border border-gray-100">
                            "{item.question}"
                          </p>
                        </div>

                        {/* Reply Section */}
                        {item.admin_reply ? (
                          <div className="bg-gradient-to-br from-[#ae2b2b]/5 to-[#ae2b2b]/10 border-l-4 border-[#ae2b2b] p-4 sm:p-5 rounded-r-2xl space-y-2 animate-in fade-in">
                            <div className="flex items-center justify-between gap-2">
                              <span className="inline-flex items-center gap-1.5 text-xs font-bold text-[#ae2b2b] bg-white px-2.5 py-1 rounded-full border border-[#ae2b2b]/20 shadow-xs">
                                <ShieldCheck className="h-3.5 w-3.5 text-[#ae2b2b]" /> Official Admin / Panel Reply
                              </span>
                              {item.replied_at && (
                                <span className="text-[11px] text-gray-500 font-medium">
                                  {new Date(item.replied_at).toLocaleDateString()}
                                </span>
                              )}
                            </div>
                            <p className="text-gray-900 font-medium text-sm sm:text-base leading-relaxed pt-1 whitespace-pre-line">
                              {item.admin_reply}
                            </p>
                          </div>
                        ) : (
                          <div className="bg-amber-50/70 border border-amber-200/60 p-4 rounded-xl text-xs text-amber-900 flex items-center gap-3">
                            <Clock className="h-5 w-5 text-amber-600 shrink-0" />
                            <div>
                              <strong>Pending Response:</strong> Your question is received and is currently being reviewed by the Reflect workshop panel. Please check back soon!
                            </div>
                          </div>
                        )}
                      </div>
                    ))}
                  </div>
                )}
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
