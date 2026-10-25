import { useState, useEffect, useRef } from "react";
import { Link, useParams, useSearchParams, useNavigate } from "react-router-dom";
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
  ArrowRight,
  Clock,
  Copy,
  Check,
  RefreshCw,
  ExternalLink,
  MessageCircleQuestion,
  Lock,
  ChevronLeft
} from "lucide-react";
import {
  decodeQuestionToken,
  getQuestionThreadUrl
} from "@/lib/questionUtils";

export default function AskQuestionPage() {
  const { token: routeToken } = useParams();
  const [searchParams, setSearchParams] = useSearchParams();
  const navigate = useNavigate();

  // Thread token can come from route param (/ask-question/:token) or search params (?thread=... or ?q=... or ?id=...)
  const activeToken = routeToken || searchParams.get("thread") || searchParams.get("q") || searchParams.get("id") || "";

  // Form State (for asking initial question)
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
  const [submittedQuestion, setSubmittedQuestion] = useState(null);
  const [formError, setFormError] = useState("");

  // Thread / Conversation State
  const [threadData, setThreadData] = useState(null);
  const [loadingThread, setLoadingThread] = useState(false);
  const [threadError, setThreadError] = useState("");
  const [followupText, setFollowupText] = useState("");
  const [isSubmittingFollowup, setIsSubmittingFollowup] = useState(false);
  const [copiedLink, setCopiedLink] = useState(false);
  const [isRefreshing, setIsRefreshing] = useState(false);

  const conversationEndRef = useRef(null);

  // Load thread data whenever activeToken changes
  useEffect(() => {
    if (activeToken) {
      fetchThread(activeToken);
    } else {
      setThreadData(null);
    }
  }, [activeToken]);

  // Scroll to bottom of conversation
  useEffect(() => {
    if (threadData && conversationEndRef.current) {
      conversationEndRef.current.scrollIntoView({ behavior: "smooth" });
    }
  }, [threadData?.conversation?.length]);

  const fetchThread = async (token) => {
    setLoadingThread(true);
    setThreadError("");
    try {
      const cleanToken = (token || "").trim();
      const isUuid = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(cleanToken);
      const decodedTicketNo = decodeQuestionToken(cleanToken);

      // Check if user passed ticket number directly like "1013" or "ILJ-Q1013"
      const rawNumberMatch = cleanToken.match(/^(?:ILJ-Q)?(\d+)$/i);
      const rawTicketNo = rawNumberMatch ? parseInt(rawNumberMatch[1], 10) : null;
      const targetTicketNo = decodedTicketNo || rawTicketNo;

      let query = supabase.from("questions").select("*");
      const conditions = [`access_token.eq.${cleanToken}`];

      if (targetTicketNo) {
        conditions.push(`ticket_no.eq.${targetTicketNo}`);
      }
      if (isUuid) {
        conditions.push(`id.eq.${cleanToken}`);
      }

      query = query.or(conditions.join(","));

      const { data, error } = await query.maybeSingle();

      if (error) throw error;
      if (!data) {
        setThreadError("Conversation thread not found. The link might be invalid or expired.");
        setThreadData(null);
      } else {
        // Normalize conversation array
        let conv = Array.isArray(data.conversation) ? data.conversation : [];
        if (conv.length === 0 && data.question) {
          conv = [
            {
              id: "initial-q",
              sender: "user",
              sender_name: data.name || "You",
              text: data.question,
              created_at: data.created_at,
            },
          ];
          if (data.admin_reply) {
            conv.push({
              id: "initial-a",
              sender: "admin",
              sender_name: "ILJ Mentor",
              text: data.admin_reply,
              created_at: data.replied_at || data.created_at,
            });
          }
        }
        setThreadData({ ...data, conversation: conv });
      }
    } catch (err) {
      console.error("Error fetching thread:", err);
      setThreadError("Unable to load conversation. Please check your connection and try again.");
    } finally {
      setLoadingThread(false);
      setIsRefreshing(false);
    }
  };

  const handleRefresh = () => {
    if (activeToken) {
      setIsRefreshing(true);
      fetchThread(activeToken);
    }
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmitInitialQuestion = async (e) => {
    e.preventDefault();
    setFormError("");

    if (!form.name.trim()) {
      setFormError("Please enter your name.");
      return;
    }
    if (!form.phone_no.trim()) {
      setFormError("Please enter your phone number.");
      return;
    }
    if (!form.question.trim()) {
      setFormError("Please type your question.");
      return;
    }

    setIsSubmitting(true);

    try {
      const parsedAge =
        form.age && !isNaN(parseInt(form.age, 10)) ? parseInt(form.age, 10) : null;

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

      const { data, error: insertError } = await supabase
        .from("questions")
        .insert(payload)
        .select()
        .single();

      if (insertError) throw insertError;

      setSubmittedQuestion(data);
      window.scrollTo({ top: 0, behavior: "smooth" });
    } catch (err) {
      console.error("Error submitting question:", err);
      setFormError("Failed to submit your question. Please check your connection and try again.");
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleResetForm = () => {
    setForm({
      name: "",
      phone_no: "",
      email: "",
      gender: "Male",
      address: "",
      age: "",
      question: "",
    });
    setSubmittedQuestion(null);
    setFormError("");
    navigate("/ask-question");
  };

  const handleSendFollowup = async (e) => {
    e.preventDefault();
    if (!followupText.trim() || !threadData) return;

    setIsSubmittingFollowup(true);
    const tokenToUse = threadData.access_token || threadData.id;

    try {
      // Use RPC for atomic update and status reset
      const { data, error } = await supabase.rpc("add_question_followup", {
        p_token: tokenToUse,
        p_message: followupText.trim(),
        p_sender_name: threadData.name || "User",
      });

      if (error) throw error;

      if (data && data.success) {
        setThreadData((prev) => ({
          ...prev,
          conversation: data.conversation,
          status: "pending",
        }));
        setFollowupText("");
      } else {
        throw new Error(data?.error || "Failed to post follow-up");
      }
    } catch (err) {
      console.error("Error posting follow-up:", err);
      // Fallback: direct Supabase update
      try {
        const newMsg = {
          id: crypto.randomUUID ? crypto.randomUUID() : String(Date.now()),
          sender: "user",
          sender_name: threadData.name || "User",
          text: followupText.trim(),
          created_at: new Date().toISOString(),
        };
        const updatedConv = [...(threadData.conversation || []), newMsg];
        const { error: fallbackError } = await supabase
          .from("questions")
          .update({
            conversation: updatedConv,
            status: "pending",
          })
          .eq("id", threadData.id);

        if (fallbackError) throw fallbackError;

        setThreadData((prev) => ({
          ...prev,
          conversation: updatedConv,
          status: "pending",
        }));
        setFollowupText("");
      } catch (fallbackErr) {
        alert("Failed to submit follow-up. Please try again.");
      }
    } finally {
      setIsSubmittingFollowup(false);
    }
  };

  const handleCopyLink = (token) => {
    const url = getQuestionThreadUrl(token);
    navigator.clipboard.writeText(url);
    setCopiedLink(true);
    setTimeout(() => setCopiedLink(false), 3000);
  };

  // ==========================================
  // RENDER 1: ACTIVE CONVERSATION THREAD VIEW
  // ==========================================
  if (activeToken) {
    return (
      <div className="min-h-screen bg-gradient-to-b from-[#fbf8f7] via-white to-[#faf7f6] py-8 sm:py-12 px-4 sm:px-6 lg:px-8">
        <div className="max-w-4xl mx-auto">
          
          {/* Top Bar Navigation */}
          <div className="flex items-center justify-between gap-4 mb-6">
            <Link
              to="/ask-question"
              className="inline-flex items-center gap-1.5 text-xs sm:text-sm font-semibold text-gray-600 hover:text-[#ae2b2b] transition-colors"
            >
              <ChevronLeft className="h-4 w-4" /> Ask a New Question
            </Link>

            <button
              onClick={handleRefresh}
              disabled={isRefreshing || loadingThread}
              className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg border border-gray-200 bg-white hover:bg-gray-50 text-xs font-semibold text-gray-700 shadow-xs transition-colors cursor-pointer disabled:opacity-50"
              title="Refresh conversation"
            >
              <RefreshCw className={`h-3.5 w-3.5 ${isRefreshing ? "animate-spin text-[#ae2b2b]" : ""}`} />
              Refresh
            </button>
          </div>

          {loadingThread ? (
            <div className="bg-white rounded-3xl p-12 border border-gray-100 shadow-xl text-center">
              <div className="h-10 w-10 border-3 border-[#ae2b2b] border-t-transparent rounded-full animate-spin mx-auto mb-4" />
              <h3 className="text-lg font-bold text-gray-900 font-serif">Loading your conversation...</h3>
              <p className="text-sm text-gray-500 mt-1">Retrieving mentor responses and discussion history.</p>
            </div>
          ) : threadError ? (
            <div className="bg-white rounded-3xl p-8 sm:p-12 border border-red-100 shadow-xl text-center max-w-xl mx-auto">
              <div className="mx-auto mb-4 h-16 w-16 rounded-full bg-red-50 text-red-600 flex items-center justify-center">
                <HelpCircle className="h-8 w-8" />
              </div>
              <h2 className="text-xl sm:text-2xl font-bold text-gray-900 font-serif">Thread Not Found</h2>
              <p className="mt-2 text-sm text-gray-600 leading-relaxed">{threadError}</p>
              <div className="mt-6 flex flex-col sm:flex-row gap-3 justify-center">
                <Link
                  to="/ask-question"
                  className="px-6 py-2.5 rounded-xl bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white font-semibold text-sm transition"
                >
                  Submit a Question
                </Link>
                <Link
                  to="/"
                  className="px-6 py-2.5 rounded-xl border border-gray-200 hover:bg-gray-50 text-gray-700 font-semibold text-sm transition"
                >
                  Return Home
                </Link>
              </div>
            </div>
          ) : threadData ? (
            <div className="space-y-6">
              
              {/* Thread Info Header Card */}
              <div className="bg-white rounded-3xl p-6 sm:p-8 border border-[#ae2b2b]/15 shadow-xl relative overflow-hidden">
                <div className="absolute top-0 left-0 right-0 h-1.5 bg-gradient-to-r from-[#ae2b2b] via-[#8f1f1f] to-[#ae2b2b]" />

                <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-5 border-b border-gray-100">
                  <div>
                    <div className="flex flex-wrap items-center gap-2 mb-1.5">
                      <span className="text-xs font-bold uppercase tracking-wider px-2.5 py-0.5 rounded-full bg-[#ae2b2b]/10 text-[#ae2b2b]">
                        Ticket #{threadData.ticket_no ? `ILJ-Q${threadData.ticket_no}` : "Discussion"}
                      </span>

                      {/* Status Badge */}
                      {threadData.status === "closed" ? (
                        <span className="text-xs font-bold px-2.5 py-0.5 rounded-full bg-gray-100 text-gray-700 flex items-center gap-1">
                          <Lock className="h-3 w-3" /> Closed
                        </span>
                      ) : threadData.status === "answered" ? (
                        <span className="text-xs font-bold px-2.5 py-0.5 rounded-full bg-emerald-50 text-emerald-700 border border-emerald-100 flex items-center gap-1">
                          <CheckCircle2 className="h-3 w-3" /> Answered
                        </span>
                      ) : (
                        <span className="text-xs font-bold px-2.5 py-0.5 rounded-full bg-amber-50 text-amber-800 border border-amber-200/60 flex items-center gap-1.5">
                          <span className="h-2 w-2 rounded-full bg-amber-500 animate-pulse" />
                          Awaiting Mentor Reply
                        </span>
                      )}
                    </div>

                    <h1 className="text-xl sm:text-2xl font-bold text-gray-900 font-serif">
                      Question by {threadData.name}
                    </h1>
                    <p className="text-xs sm:text-sm text-gray-500 mt-0.5 flex items-center gap-2">
                      <Clock className="h-3.5 w-3.5" />
                      Started on {new Date(threadData.created_at).toLocaleDateString("en-IN", {
                        day: "numeric",
                        month: "short",
                        year: "numeric",
                        hour: "2-digit",
                        minute: "2-digit",
                      })}
                    </p>
                  </div>

                  {/* Copy Link Button */}
                  <div className="shrink-0 flex items-center gap-2">
                    <button
                      onClick={() => handleCopyLink(threadData.access_token || threadData.id)}
                      className={`inline-flex items-center gap-1.5 px-3.5 py-2 rounded-xl text-xs font-bold transition-all shadow-xs cursor-pointer border ${
                        copiedLink
                          ? "bg-emerald-50 border-emerald-300 text-emerald-700"
                          : "bg-white border-gray-200 text-gray-700 hover:bg-gray-50"
                      }`}
                      title="Copy private link to this question"
                    >
                      {copiedLink ? (
                        <>
                          <Check className="h-3.5 w-3.5 text-emerald-600" />
                          <span>Link Copied!</span>
                        </>
                      ) : (
                        <>
                          <Copy className="h-3.5 w-3.5 text-gray-500" />
                          <span>Copy Conversation Link</span>
                        </>
                      )}
                    </button>
                  </div>
                </div>

                {/* Submitter Info Strip */}
                <div className="pt-4 flex flex-wrap gap-x-5 gap-y-1 text-xs text-gray-500">
                  {threadData.gender && <span>Gender: <strong className="text-gray-700">{threadData.gender}</strong></span>}
                  {threadData.age && <span>Age: <strong className="text-gray-700">{threadData.age}</strong></span>}
                  {threadData.address && <span>Location: <strong className="text-gray-700">{threadData.address}</strong></span>}
                </div>
              </div>

              {/* Conversation Messages Container */}
              <div className="bg-white rounded-3xl p-6 sm:p-8 border border-gray-100 shadow-xl space-y-6">
                <div className="flex items-center justify-between pb-3 border-b border-gray-100">
                  <h3 className="text-sm font-bold uppercase tracking-wider text-gray-500 flex items-center gap-2">
                    <MessageSquare className="h-4 w-4 text-[#ae2b2b]" /> Conversation History
                  </h3>
                  <span className="text-xs text-gray-400">
                    {threadData.conversation?.length || 0} message{(threadData.conversation?.length || 0) === 1 ? "" : "s"}
                  </span>
                </div>

                <div className="space-y-5">
                  {threadData.conversation?.map((msg, index) => {
                    const isUser = msg.sender === "user";
                    return (
                      <div
                        key={msg.id || index}
                        className={`flex gap-3.5 ${isUser ? "items-start" : "items-start"}`}
                      >
                        {/* Avatar / Icon */}
                        <div
                          className={`h-9 w-9 rounded-full flex items-center justify-center shrink-0 text-xs font-bold shadow-xs ${
                            isUser
                              ? "bg-amber-100 text-amber-900 border border-amber-200"
                              : "bg-[#ae2b2b] text-white ring-4 ring-[#ae2b2b]/10"
                          }`}
                        >
                          {isUser ? <User className="h-4 w-4" /> : <ShieldCheck className="h-4 w-4" />}
                        </div>

                        {/* Message Content Bubble */}
                        <div className="flex-1">
                          <div className="flex items-baseline gap-2 mb-1">
                            <span className="text-xs font-bold text-gray-900">
                              {isUser ? msg.sender_name || threadData.name || "You" : "ILJ Official Mentor"}
                            </span>
                            <span className="text-[11px] text-gray-400">
                              {msg.created_at
                                ? new Date(msg.created_at).toLocaleTimeString("en-IN", {
                                    hour: "2-digit",
                                    minute: "2-digit",
                                    day: "numeric",
                                    month: "short",
                                  })
                                : ""}
                            </span>
                          </div>

                          <div
                            className={`p-4 sm:p-5 rounded-2xl text-sm leading-relaxed whitespace-pre-line shadow-xs ${
                              isUser
                                ? "bg-amber-50/50 border border-amber-100/90 text-gray-900 font-serif"
                                : "bg-gradient-to-br from-[#ae2b2b]/5 via-white to-[#ae2b2b]/10 border-l-4 border-[#ae2b2b] border-t border-r border-b border-gray-100 text-gray-900 font-sans"
                            }`}
                          >
                            {!isUser && (
                              <div className="inline-flex items-center gap-1.5 text-[11px] font-bold text-[#ae2b2b] uppercase tracking-wider mb-2">
                                <BookOpen className="h-3.5 w-3.5" /> Guidance & Response
                              </div>
                            )}
                            <p className="text-gray-900 font-medium">{msg.text}</p>
                          </div>
                        </div>
                      </div>
                    );
                  })}

                  {/* Waiting Indicator Card (when user asked and waiting for mentor) */}
                  {threadData.status === "pending" && (
                    <div className="mt-4 p-5 rounded-2xl bg-amber-50/70 border border-amber-200/70 flex items-start gap-3.5 animate-in fade-in">
                      <div className="h-9 w-9 rounded-full bg-amber-100 text-amber-700 flex items-center justify-center shrink-0">
                        <Clock className="h-5 w-5 animate-pulse" />
                      </div>
                      <div>
                        <h4 className="text-sm font-bold text-amber-900">
                          Waiting for answer from our mentors...
                        </h4>
                        <p className="text-xs sm:text-sm text-amber-800/80 mt-1 leading-relaxed">
                          Your question has been received. Our knowledgeable mentors and scholars are reviewing it.
                          Once answered, you will see the response right here, and an update will be sent to your WhatsApp number ({threadData.phone_no}).
                        </p>
                      </div>
                    </div>
                  )}

                  <div ref={conversationEndRef} />
                </div>

                {/* Follow-up Question Input */}
                <div className="pt-6 border-t border-gray-100">
                  {threadData.status === "closed" ? (
                    <div className="p-5 rounded-2xl bg-gray-50 border border-gray-200 text-center">
                      <Lock className="h-6 w-6 text-gray-400 mx-auto mb-2" />
                      <h4 className="text-sm font-bold text-gray-800">
                        This conversation has been closed by the mentor.
                      </h4>
                      <p className="text-xs text-gray-500 mt-1 max-w-md mx-auto">
                        We hope your doubts were clarified! If you have queries about a different topic, please feel free to start a new question.
                      </p>
                      <button
                        onClick={handleResetForm}
                        className="mt-4 px-5 py-2.5 rounded-xl bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white font-semibold text-xs shadow-sm transition cursor-pointer"
                      >
                        Ask a New Question
                      </button>
                    </div>
                  ) : (
                    <form onSubmit={handleSendFollowup} className="space-y-3">
                      <label className="block text-xs font-bold uppercase tracking-wider text-gray-700">
                        Ask a Follow-up Question / Doubt:
                      </label>
                      <textarea
                        rows="3"
                        required
                        value={followupText}
                        onChange={(e) => setFollowupText(e.target.value)}
                        placeholder="Type your follow-up doubt or question here... (Our mentors will reply back on this same thread)"
                        className="w-full p-4 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15 outline-none text-sm font-medium transition resize-y leading-relaxed"
                      />
                      <div className="flex items-center justify-between gap-4">
                        <span className="text-xs text-gray-400 hidden sm:inline">
                          This discussion remains private and linked to your phone number.
                        </span>
                        <button
                          type="submit"
                          disabled={isSubmittingFollowup || !followupText.trim()}
                          className="px-6 py-2.5 rounded-xl bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white font-bold text-xs tracking-wide shadow-md transition-all flex items-center gap-2 cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed ml-auto"
                        >
                          {isSubmittingFollowup ? (
                            <>
                              <div className="h-3.5 w-3.5 border-2 border-white border-t-transparent rounded-full animate-spin" />
                              <span>Sending Follow-up...</span>
                            </>
                          ) : (
                            <>
                              <Send className="h-3.5 w-3.5" />
                              <span>Send Follow-up</span>
                            </>
                          )}
                        </button>
                      </div>
                    </form>
                  )}
                </div>

              </div>

            </div>
          ) : null}

        </div>
      </div>
    );
  }

  // ==========================================
  // RENDER 2: INITIAL QUESTION FORM & SUCCESS
  // ==========================================
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
            Share your question with us. A private link will be generated where our mentors will answer you and you can continue the conversation anytime!
          </p>
        </div>

        {submittedQuestion ? (
          /* Upgraded Success Screen with Unique Link */
          <div className="max-w-xl mx-auto bg-white rounded-3xl p-8 sm:p-12 border border-[#ae2b2b]/15 shadow-xl text-center animate-in fade-in zoom-in-95 duration-300">
            <div className="mx-auto mb-6 h-18 w-18 rounded-full bg-emerald-50 text-emerald-600 flex items-center justify-center ring-8 ring-emerald-50/50">
              <CheckCircle2 className="h-10 w-10" />
            </div>

            <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-50 text-emerald-700 text-xs font-bold uppercase tracking-wider mb-3 border border-emerald-200">
              Ticket #{submittedQuestion.ticket_no ? `ILJ-Q${submittedQuestion.ticket_no}` : "Created"}
            </div>

            <h2 className="text-2xl sm:text-3xl font-bold text-gray-900 font-serif">
              Your Question Link is Ready!
            </h2>
            <p className="mt-2 text-gray-600 text-sm sm:text-base leading-relaxed">
              We have created a unique conversation link for you. Our mentors will review your question and reply back here.
            </p>

            {/* Generated Unique Link Box */}
            <div className="mt-6 p-4 rounded-2xl bg-gray-50 border border-gray-200 text-left space-y-2">
              <div className="flex items-center justify-between">
                <span className="text-[11px] font-bold uppercase tracking-wider text-gray-500">
                  Your Private Discussion Link:
                </span>
                {copiedLink && (
                  <span className="text-xs font-bold text-emerald-600 flex items-center gap-1">
                    <Check className="h-3 w-3" /> Copied!
                  </span>
                )}
              </div>

              <div className="flex items-center gap-2">
                <input
                  type="text"
                  readOnly
                  value={getQuestionThreadUrl(submittedQuestion.access_token || submittedQuestion.id)}
                  className="w-full text-xs font-mono bg-white border border-gray-300 rounded-lg p-2.5 text-gray-800 select-all outline-none"
                />
                <button
                  onClick={() => handleCopyLink(submittedQuestion.access_token || submittedQuestion.id)}
                  className="p-2.5 rounded-lg bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white shrink-0 transition cursor-pointer shadow-xs"
                  title="Copy Link"
                >
                  <Copy className="h-4 w-4" />
                </button>
              </div>

              <p className="text-[11px] text-gray-500 leading-normal">
                💡 Bookmark or save this link. You will also receive an update on WhatsApp at <strong>{submittedQuestion.phone_no}</strong> once our mentor responds.
              </p>
            </div>

            {/* Next Actions */}
            <div className="mt-8 flex flex-col sm:flex-row gap-3 justify-center">
              <button
                onClick={() => {
                  const token = submittedQuestion.access_token || submittedQuestion.id;
                  navigate(`/ask-question?thread=${encodeURIComponent(token)}`);
                }}
                className="px-6 py-3 rounded-xl bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white font-semibold text-sm transition-all shadow-md shadow-red-900/10 cursor-pointer flex items-center justify-center gap-2"
              >
                <span>View Question & Conversation</span>
                <ArrowRight className="h-4 w-4" />
              </button>
              <button
                onClick={handleResetForm}
                className="px-6 py-3 rounded-xl border border-gray-200 hover:bg-gray-50 text-gray-700 font-semibold text-sm transition-all cursor-pointer"
              >
                Ask Another Question
              </button>
            </div>
          </div>
        ) : (
          /* Form & Guidance Cards */
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
            
            {/* Left Column: Inspiring Guidance Card */}
            <div className="lg:col-span-5 space-y-6">
              <div className="bg-gradient-to-br from-[#5c1212] via-[#8f1f1f] to-[#ae2b2b] text-white p-7 sm:p-8 rounded-3xl shadow-xl relative overflow-hidden">
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
                  Feel free to ask anything. A personal conversation link will be created just for you!
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
                    <span>Ask follow-ups anytime on your unique link until resolved.</span>
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
                  Please provide your details below so we can generate your personal question thread.
                </p>
              </div>

              {formError && (
                <div className="mb-6 p-4 rounded-xl bg-red-50 border border-red-200 text-red-700 text-sm">
                  {formError}
                </div>
              )}

              <form onSubmit={handleSubmitInitialQuestion} className="space-y-5">
                
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
                      placeholder="e.g. Meet Mehta"
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
                        placeholder="e.g. 9172387009"
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
                        placeholder="e.g. name@example.com"
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
                    <div className="grid grid-cols-2 gap-2">
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
                        placeholder="e.g. 21"
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
                      placeholder="e.g. Mumbai, Maharashtra"
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
                  />
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
                      <span>Generating Unique Question Link...</span>
                    </>
                  ) : (
                    <>
                      <Send className="h-4 w-4" />
                      <span>Submit Question & Get Thread Link</span>
                    </>
                  )}
                </button>

                <p className="text-center text-xs text-gray-400">
                  A unique private link will be generated where all ongoing conversation will take place.
                </p>
              </form>
            </div>

          </div>
        )}

      </div>
    </div>
  );
}
