import React, { useState, useRef, useEffect } from "react";
import {
  Star,
  MessageSquare,
  Send,
  CheckCircle2,
  MapPin,
  Calendar,
  Clock,
  Sparkles,
  Filter,
  ChevronDown,
  ChevronUp,
  User,
  Heart,
  Quote,
  ArrowRight,
  Share2,
  Check,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { supabase } from "../lib/supabase";

const RATING_LABELS = [
  "",
  "Needs Improvement",
  "Fair",
  "Good",
  "Very Good",
  "Outstanding!",
];

const RATING_EMOJI = ["", "😐", "🙂", "😊", "🤩", "🤯"];

export default function ProjectFeedbackSection({
  project,
  testimonials = [],
  onFeedbackAdded,
  defaultOpenForm = false,
  openFormRequest = 0,
}) {
  const isJainific =
    project?.project_code === "PRJ-003" ||
    project?.title?.toLowerCase().includes("jainific");

  const [isFormOpen, setIsFormOpen] = useState(
    defaultOpenForm || testimonials.length === 0
  );
  const [rating, setRating] = useState(0);
  const [hoverRating, setHoverRating] = useState(0);
  const [comments, setComments] = useState("");
  const [isAnonymous, setIsAnonymous] = useState(false);
  const [name, setName] = useState("");
  const [age, setAge] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [submitSuccess, setSubmitSuccess] = useState(false);
  const [filterRating, setFilterRating] = useState("all");
  const [formStep, setFormStep] = useState(1); // 1 = rating, 2 = details
  const [sharedReviewId, setSharedReviewId] = useState(null);
  const formRef = useRef(null);

  const activeRating = hoverRating || rating;

  // Calculate statistics
  const totalReviews = testimonials.length;
  const avgRating =
    totalReviews > 0
      ? (
          testimonials.reduce((sum, t) => sum + (Number(t.rating) || 5), 0) /
          totalReviews
        ).toFixed(1)
      : "5.0";

  const filteredTestimonials = testimonials.filter((t) => {
    if (filterRating === "all") return true;
    return Number(t.rating) === Number(filterRating);
  });

  const shareReview = async (review, reviewId, reviewText, displayName) => {
    const shareUrl = `${window.location.origin}${window.location.pathname}#feedback-section`;
    const message = `“${reviewText}” — ${displayName}, ${Number(review.rating) || 5}/5\n${shareUrl}`;

    try {
      if (navigator.share) {
        await navigator.share({
          title: `${project?.title || "Project"} feedback`,
          text: message,
          url: shareUrl,
        });
      } else {
        await navigator.clipboard.writeText(message);
        setSharedReviewId(reviewId);
        window.setTimeout(() => setSharedReviewId(null), 2200);
      }
    } catch (error) {
      if (error?.name !== "AbortError") {
        try {
          await navigator.clipboard.writeText(message);
          setSharedReviewId(reviewId);
          window.setTimeout(() => setSharedReviewId(null), 2200);
        } catch (clipboardError) {
          console.error("Could not share feedback:", clipboardError);
        }
      }
    }
  };

  // Scroll to form when opened
  useEffect(() => {
    if (defaultOpenForm || openFormRequest > 0) setIsFormOpen(true);
  }, [defaultOpenForm, openFormRequest]);

  useEffect(() => {
    if (isFormOpen && formRef.current) {
      formRef.current.scrollIntoView({ behavior: "smooth", block: "center" });
    }
  }, [isFormOpen]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!rating) {
      alert("Please select a rating.");
      return;
    }
    if (!comments.trim()) {
      alert("Please enter your feedback.");
      return;
    }
    if (!isAnonymous && !name.trim()) {
      alert("Please provide your name or submit anonymously.");
      return;
    }

    setSubmitting(true);
    try {
      const parsedAge =
        age && !isNaN(parseInt(age, 10)) ? parseInt(age, 10) : null;
      const formattedComments = isJainific
        ? `[Session: Jainific 3.0 Malad - 1st November 2026] ${comments.trim()}`
        : comments.trim();

      const payload = {
        project_id: project.id,
        rating: rating || 5,
        comments: formattedComments,
        is_anonymous: isAnonymous,
        name: isAnonymous ? null : name.trim() || null,
        age: isAnonymous ? null : parsedAge,
        email: null,
        mobile: null,
        city: null,
      };

      const { data, error } = await supabase
        .from("project_feedback")
        .insert(payload)
        .select()
        .single();

      if (error) throw error;

      setSubmitSuccess(true);
      setComments("");
      setName("");
      setAge("");
      setRating(0);
      setFormStep(1);

      if (onFeedbackAdded && data) {
        onFeedbackAdded(data);
      }

      setTimeout(() => {
        setSubmitSuccess(false);
        setIsFormOpen(false);
      }, 4000);
    } catch (err) {
      console.error("Feedback submit error:", err);
      alert(
        "Failed to submit feedback. " +
          (err.message || "Please check connection.")
      );
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <section
      id="feedback-section"
      className="mx-auto mt-16 w-full max-w-6xl px-4 scroll-mt-24 sm:px-6 lg:px-8"
    >
      {/* ── Jainific 3.0 Event Banner ── */}
      {isJainific && (
        <div className="relative mb-10 overflow-hidden rounded-[1.75rem] border border-[#eadbd3] bg-[#f4ece5]">
          {/* Background */}
          <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_top_right,rgba(174,43,43,0.12),transparent_48%)]" />
          <div className="absolute -right-10 -top-20 h-64 w-64 rounded-full border border-[#ae2b2b]/10" />
          <div className="absolute -right-2 -top-12 h-48 w-48 rounded-full border border-[#ae2b2b]/10" />

          <div className="relative z-10 p-6 sm:p-9 lg:p-10">
            <div className="flex flex-col lg:flex-row items-start lg:items-center justify-between gap-8">
              <div className="flex-1 space-y-4">
                <div className="inline-flex items-center gap-2 rounded-full border border-[#ae2b2b]/10 bg-white/70 px-3 py-1.5 text-[10px] font-bold uppercase tracking-[0.16em] text-[#8c2925]">
                  <Sparkles className="h-3 w-3" />
                  <span>Exhibition 3.0 — Malad Edition</span>
                </div>

                <h3 className="text-3xl font-bold leading-tight tracking-tight text-[#271b18] sm:text-4xl" style={{textWrap: 'balance'}}>
                  Jainific 3.0
                  <span className="mt-1 block text-base font-medium tracking-normal text-[#6d5b54] sm:text-lg">
                    Malad — 1st November 2026
                  </span>
                </h3>

                <p className="max-w-xl text-sm leading-relaxed text-[#665650] sm:text-[15px]">
                  Tell us what stayed with you from the exhibits, experiments, and scriptural stories.
                </p>

                <div className="flex flex-wrap gap-3 pt-1">
                  {[
                    { icon: Calendar, text: "1st November 2026" },
                    { icon: Clock, text: "11 AM – 8 PM" },
                    { icon: MapPin, text: "MKES Law College, Malad (W)" },
                  ].map(({ icon: Icon, text }) => (
                    <div
                      key={text}
                      className="flex items-center gap-2 rounded-xl border border-[#e9dcd4] bg-white/65 px-3.5 py-2 text-[12px] text-[#665650]"
                    >
                      <Icon className="h-3.5 w-3.5 text-[#ae2b2b]" />
                      <span>{text}</span>
                    </div>
                  ))}
                </div>
              </div>

              <div className="flex flex-col gap-3 shrink-0 w-full sm:w-auto">
                <button
                  onClick={() => setIsFormOpen((prev) => !prev)}
                  className="group inline-flex items-center justify-center gap-2.5 rounded-xl bg-[#ae2b2b] px-6 py-3.5 text-sm font-bold text-white shadow-sm transition hover:bg-[#8f1f1f] focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[#ae2b2b]/40 focus-visible:ring-offset-2"
                >
                  <MessageSquare className="w-4 h-4" />
                  {isFormOpen ? "Hide Form" : "Share Feedback"}
                  <ArrowRight className="h-4 w-4 transition-transform group-hover:translate-x-0.5" />
                </button>
                <a
                  href="https://maps.google.com/?q=MKES+Law+College+SV+Road+Malad+West"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="inline-flex items-center justify-center gap-2 rounded-xl border border-[#d9c9bf] bg-white/60 px-5 py-2.5 text-center text-xs font-semibold text-[#6d5b54] transition hover:bg-white hover:text-[#ae2b2b]"
                >
                  <MapPin className="w-3.5 h-3.5" /> Open in Google Maps
                </a>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* ── Section Header ── */}
      <div className="flex flex-col sm:flex-row sm:items-end justify-between gap-4 mb-10">
        <div>
          <span className="text-[11px] font-bold uppercase tracking-[0.2em] text-[#ae2b2b]/70">
            Community Voices
          </span>
          <h2 className="text-2xl sm:text-3xl font-bold text-gray-900 mt-1.5 tracking-tight" style={{textWrap: 'balance'}}>
            {isJainific
              ? "Jainific 3.0 Feedback & Reviews"
              : "Voices of Impact & Feedback"}
          </h2>
        </div>

        <div className="flex flex-wrap items-center gap-3">
          {totalReviews > 0 && (
            <div className="flex items-center gap-2 bg-amber-50 border border-amber-100 px-4 py-2 rounded-full">
              <div className="flex text-amber-400 gap-0.5">
                {[...Array(5)].map((_, i) => (
                  <Star
                    key={i}
                    className="h-3.5 w-3.5 fill-amber-400 text-amber-400"
                  />
                ))}
              </div>
              <span className="text-xs font-semibold text-amber-800">
                {avgRating} · {totalReviews} review
                {totalReviews > 1 ? "s" : ""}
              </span>
            </div>
          )}

          <button
            onClick={() => setIsFormOpen((prev) => !prev)}
            className="bg-[#ae2b2b] hover:bg-[#961f1f] text-white px-5 py-2.5 rounded-xl text-[13px] font-semibold flex items-center gap-2 shadow-sm hover:shadow-md transition-all duration-200"
          >
            <MessageSquare className="h-3.5 w-3.5" />
            {isFormOpen ? "Close" : "Write Feedback"}
          </button>
        </div>
      </div>

      {/* ── Feedback Form ── */}
      {isFormOpen && (
        <div
          ref={formRef}
          className="mb-14 rounded-[1.75rem] bg-white border border-gray-200/80 shadow-[0_8px_40px_-12px_rgba(0,0,0,0.08)] relative overflow-hidden transition-all duration-500"
        >
          {/* Top accent */}
          <div className="h-1 bg-gradient-to-r from-[#ae2b2b] via-[#c74a2e] to-amber-400" />

          {submitSuccess ? (
            /* ── Success State ── */
            <div className="py-16 px-6 text-center">
              <div className="mx-auto mb-5 relative">
                <div className="h-20 w-20 rounded-full bg-emerald-50 flex items-center justify-center mx-auto ring-[12px] ring-emerald-50/50">
                  <CheckCircle2 className="h-10 w-10 text-emerald-500" />
                </div>
              </div>
              <h3 className="text-2xl font-bold text-gray-900 tracking-tight">
                Thank You!
              </h3>
              <p className="mt-2 text-sm text-gray-500 max-w-sm mx-auto leading-relaxed">
                Your feedback has been submitted and is now visible on this
                page. We truly appreciate your thoughts.
              </p>
            </div>
          ) : (
            <form onSubmit={handleSubmit} className="p-6 sm:p-8 lg:p-10">
              {/* Form Title */}
              <div className="flex flex-col sm:flex-row sm:items-start justify-between gap-3 mb-8">
                <div>
                  <h3 className="text-xl sm:text-2xl font-bold text-gray-900 tracking-tight">
                    {isJainific
                      ? "How was Jainific 3.0?"
                      : "Share Your Experience"}
                  </h3>
                  <p className="text-sm text-gray-400 mt-1">
                    Your insights help us improve future sessions.
                  </p>
                </div>
                {isJainific && (
                  <span className="text-[11px] font-semibold bg-amber-50 text-amber-700 border border-amber-200/60 px-3 py-1.5 rounded-lg w-fit whitespace-nowrap">
                    1st Nov 2026 · Malad
                  </span>
                )}
              </div>

              {/* Step indicator */}
              <div className="flex items-center gap-3 mb-8">
                <div className="flex items-center gap-2">
                  <div
                    className={`h-8 w-8 rounded-full flex items-center justify-center text-xs font-bold transition-colors duration-300 ${
                      formStep >= 1
                        ? "bg-[#ae2b2b] text-white"
                        : "bg-gray-100 text-gray-400"
                    }`}
                  >
                    1
                  </div>
                  <span className="text-xs font-medium text-gray-500 hidden sm:inline">
                    Rate & Review
                  </span>
                </div>
                <div className="flex-1 h-px bg-gray-200 max-w-[60px]" />
                <div className="flex items-center gap-2">
                  <div
                    className={`h-8 w-8 rounded-full flex items-center justify-center text-xs font-bold transition-colors duration-300 ${
                      formStep >= 2
                        ? "bg-[#ae2b2b] text-white"
                        : "bg-gray-100 text-gray-400"
                    }`}
                  >
                    2
                  </div>
                  <span className="text-xs font-medium text-gray-500 hidden sm:inline">
                    Your Details
                  </span>
                </div>
              </div>

              {/* Step 1: Rating & Comments */}
              {formStep === 1 && (
                <div className="space-y-6">
                  {/* Star Rating */}
                  <div className="text-center py-6 bg-gradient-to-b from-amber-50/60 to-transparent rounded-2xl border border-amber-100/50">
                    <p className="text-sm font-medium text-gray-600 mb-4">
                      How would you rate your experience?
                    </p>
                    <div className="flex items-center justify-center gap-2 sm:gap-3 mb-3">
                      {[1, 2, 3, 4, 5].map((star) => (
                        <button
                          key={star}
                          type="button"
                          onClick={() => setRating(star)}
                          onMouseEnter={() => setHoverRating(star)}
                          onMouseLeave={() => setHoverRating(0)}
                          className="p-1 rounded-xl transition-all duration-200 hover:scale-110 active:scale-95 focus:outline-none"
                        >
                          <Star
                            className={`h-10 w-10 sm:h-12 sm:w-12 transition-all duration-200 ${
                              star <= activeRating
                                ? "fill-amber-400 text-amber-400 drop-shadow-md"
                                : "text-gray-200 fill-gray-50 hover:text-gray-300"
                            }`}
                          />
                        </button>
                      ))}
                    </div>
                    {activeRating > 0 && (
                      <div className="flex items-center justify-center gap-2 text-sm">
                        <span className="text-xl">
                          {RATING_EMOJI[activeRating]}
                        </span>
                        <span className="font-semibold text-amber-800">
                          {RATING_LABELS[activeRating]}
                        </span>
                      </div>
                    )}
                  </div>

                  {/* Comment Box */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Tell us more{" "}
                      <span className="text-red-400">*</span>
                    </label>
                    <textarea
                      rows={4}
                      required
                      value={comments}
                      onChange={(e) => setComments(e.target.value)}
                      placeholder={
                        isJainific
                          ? "What did you enjoy most? Any suggestions for improvement?"
                          : "Share your experience, thoughts, and suggestions..."
                      }
                      className="w-full p-4 border border-gray-200 rounded-xl bg-gray-50/50 focus:bg-white focus:ring-2 focus:ring-[#ae2b2b]/15 focus:border-[#ae2b2b]/40 outline-none text-sm leading-relaxed transition-all duration-200 resize-none placeholder:text-gray-300"
                    />
                  </div>

                  {/* Next Button */}
                  <div className="flex justify-end pt-2">
                    <button
                      type="button"
                      onClick={() => {
                        if (!rating) {
                          alert("Please select a rating first.");
                          return;
                        }
                        if (!comments.trim()) {
                          alert("Please write your feedback.");
                          return;
                        }
                        setFormStep(2);
                      }}
                      className="group bg-[#ae2b2b] hover:bg-[#961f1f] text-white px-6 py-3 rounded-xl font-semibold text-sm flex items-center gap-2 shadow-sm hover:shadow-md transition-all duration-200"
                    >
                      Continue
                      <ArrowRight className="w-4 h-4 transition-transform group-hover:translate-x-0.5" />
                    </button>
                  </div>
                </div>
              )}

              {/* Step 2: Personal Details */}
              {formStep === 2 && (
                <div className="space-y-6">
                  {/* Summary of step 1 */}
                  <div className="flex items-start gap-4 p-4 bg-amber-50/60 rounded-xl border border-amber-100/50">
                    <div className="flex gap-0.5 shrink-0 mt-0.5">
                      {[...Array(5)].map((_, i) => (
                        <Star
                          key={i}
                          className={`h-4 w-4 ${
                            i < rating
                              ? "fill-amber-400 text-amber-400"
                              : "text-gray-200 fill-gray-100"
                          }`}
                        />
                      ))}
                    </div>
                    <p className="text-sm text-gray-600 italic leading-relaxed line-clamp-2 flex-1">
                      "{comments}"
                    </p>
                    <button
                      type="button"
                      onClick={() => setFormStep(1)}
                      className="text-xs text-[#ae2b2b] font-semibold hover:underline shrink-0"
                    >
                      Edit
                    </button>
                  </div>

                  {/* Anonymous Toggle */}
                  <label className="flex items-center gap-3 p-4 bg-gray-50 rounded-xl border border-gray-100 cursor-pointer group hover:bg-gray-100/70 transition-colors duration-200">
                    <div className="relative">
                      <input
                        type="checkbox"
                        checked={isAnonymous}
                        onChange={(e) => setIsAnonymous(e.target.checked)}
                        className="sr-only peer"
                      />
                      <div className="w-10 h-6 rounded-full bg-gray-200 peer-checked:bg-[#ae2b2b] transition-colors duration-200" />
                      <div className="absolute left-0.5 top-0.5 h-5 w-5 rounded-full bg-white shadow-sm transition-transform duration-200 peer-checked:translate-x-4" />
                    </div>
                    <span className="text-sm font-medium text-gray-700">
                      Submit anonymously
                    </span>
                  </label>

                  {/* Name & Age */}
                  {!isAnonymous && (
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-2">
                          Your Name{" "}
                          <span className="text-red-400">*</span>
                        </label>
                        <input
                          type="text"
                          required
                          value={name}
                          onChange={(e) => setName(e.target.value)}
                          placeholder="e.g. Paras Shah"
                          className="w-full p-3.5 border border-gray-200 rounded-xl bg-gray-50/50 focus:bg-white focus:ring-2 focus:ring-[#ae2b2b]/15 focus:border-[#ae2b2b]/40 outline-none text-sm transition-all duration-200 placeholder:text-gray-300"
                        />
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-2">
                          Age{" "}
                          <span className="text-gray-300 font-normal">
                            (optional)
                          </span>
                        </label>
                        <input
                          type="number"
                          value={age}
                          onChange={(e) => setAge(e.target.value)}
                          placeholder="e.g. 24"
                          className="w-full p-3.5 border border-gray-200 rounded-xl bg-gray-50/50 focus:bg-white focus:ring-2 focus:ring-[#ae2b2b]/15 focus:border-[#ae2b2b]/40 outline-none text-sm transition-all duration-200 placeholder:text-gray-300"
                        />
                      </div>
                    </div>
                  )}

                  {/* Action Buttons */}
                  <div className="flex items-center justify-between pt-4 border-t border-gray-100">
                    <button
                      type="button"
                      onClick={() => setFormStep(1)}
                      className="text-sm font-medium text-gray-500 hover:text-gray-700 transition-colors"
                    >
                      ← Back
                    </button>
                    <button
                      type="submit"
                      disabled={submitting}
                      className="bg-[#ae2b2b] hover:bg-[#961f1f] disabled:opacity-50 disabled:cursor-not-allowed text-white px-7 py-3 rounded-xl font-bold text-sm flex items-center gap-2.5 shadow-md shadow-red-900/10 hover:shadow-lg hover:shadow-red-900/15 transition-all duration-200"
                    >
                      {submitting ? (
                        <>
                          <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                          Submitting…
                        </>
                      ) : (
                        <>
                          <Send className="w-4 h-4" />
                          Submit Feedback
                        </>
                      )}
                    </button>
                  </div>
                </div>
              )}
            </form>
          )}
        </div>
      )}

      {/* ── Filter Chips ── */}
      {totalReviews > 0 && (
        <div className="flex items-center gap-2.5 mb-8 overflow-x-auto pb-2 scrollbar-hide">
          <span className="text-gray-400 font-medium flex items-center gap-1.5 shrink-0 text-xs">
            <Filter className="w-3.5 h-3.5" /> Filter
          </span>
          <button
            onClick={() => setFilterRating("all")}
            className={`px-3.5 py-1.5 rounded-full text-xs font-medium transition-all duration-200 ${
              filterRating === "all"
                ? "bg-gray-900 text-white shadow-sm"
                : "bg-gray-100 text-gray-500 hover:bg-gray-200"
            }`}
          >
            All ({totalReviews})
          </button>
          {[5, 4, 3, 2, 1].map((num) => {
            const count = testimonials.filter(
              (t) => Number(t.rating) === num
            ).length;
            if (count === 0) return null;
            return (
              <button
                key={num}
                onClick={() => setFilterRating(num.toString())}
                className={`px-3.5 py-1.5 rounded-full text-xs font-medium transition-all duration-200 flex items-center gap-1 ${
                  filterRating === num.toString()
                    ? "bg-amber-400 text-gray-900 font-bold shadow-sm"
                    : "bg-gray-100 text-gray-500 hover:bg-gray-200"
                }`}
              >
                {num}
                <Star className="w-3 h-3 fill-current" />
                <span className="text-[10px]">({count})</span>
              </button>
            );
          })}
        </div>
      )}

      {/* ── Testimonials Grid ── */}
      {filteredTestimonials.length > 0 ? (
        <div className="grid grid-cols-1 gap-4 lg:grid-cols-2">
          {filteredTestimonials.map((t, index) => {
            const displayName = t.is_anonymous
              ? "Anonymous Visitor"
              : t.name || "Community Member";
            const initial = displayName.charAt(0).toUpperCase();
            const ratingCount = Number(t.rating) || 5;

            const sessionMatch = t.comments?.match(
              /^\[Session:\s*([^\]]+)\]\s*(.*)$/s
            );
            const sessionBadge = sessionMatch ? sessionMatch[1] : null;
            const commentBody = sessionMatch ? sessionMatch[2] : t.comments;

            return (
              <div
                key={t.id || index}
                className="group relative flex flex-col justify-between rounded-2xl border border-[#eee8e4] bg-white p-5 transition duration-200 hover:border-[#d9c5ba] hover:shadow-[0_12px_36px_-24px_rgba(80,42,29,0.35)] sm:p-6"
              >
                {/* Stars Row */}
                <div>
                  <div className="flex items-center justify-between gap-2 mb-4">
                    <div className="flex items-center gap-0.5">
                      {[...Array(5)].map((_, i) => (
                        <Star
                          key={i}
                          className={`h-3.5 w-3.5 ${
                            i < ratingCount
                              ? "fill-amber-400 text-amber-400"
                              : "text-gray-100 fill-gray-50"
                          }`}
                        />
                      ))}
                    </div>
                    {sessionBadge && (
                      <span
                        className="text-[10px] font-semibold bg-[#ae2b2b]/[0.06] text-[#ae2b2b]/80 px-2.5 py-0.5 rounded-md truncate max-w-[150px]"
                        title={sessionBadge}
                      >
                        {sessionBadge.replace(
                          "Jainific 3.0 Malad - 1st November 2026",
                          "Jainific 3.0"
                        )}
                      </span>
                    )}
                  </div>

                  {/* Quote */}
                  <p className="text-gray-700 leading-relaxed text-[15px] break-words">
                    <Quote className="w-3.5 h-3.5 text-gray-200 inline -mt-1 mr-1" />
                    {commentBody}
                  </p>
                </div>

                {/* Author Footer */}
                <div className="mt-5 flex items-center justify-between gap-3 border-t border-[#f1ece8] pt-4">
                  <div className="flex items-center gap-3 min-w-0">
                    <div className="h-9 w-9 rounded-full bg-gradient-to-br from-[#ae2b2b] to-[#6b1515] text-white flex items-center justify-center font-bold text-xs shadow-sm shrink-0">
                      {initial}
                    </div>
                    <div className="flex flex-col min-w-0">
                      <span className="text-sm font-semibold text-gray-900 truncate">
                        {displayName}
                      </span>
                      {!t.is_anonymous && t.age && (
                        <span className="text-[11px] text-gray-400 font-medium">
                          Age {t.age}
                        </span>
                      )}
                    </div>
                  </div>
                  <div className="flex shrink-0 items-center gap-3">
                    {t.created_at && (
                      <span className="text-[11px] text-gray-400">
                        {new Date(t.created_at).toLocaleDateString("en-IN", {
                          day: "numeric",
                          month: "short",
                        })}
                      </span>
                    )}
                    <button
                      type="button"
                      onClick={() => shareReview(t, t.id || index, commentBody, displayName)}
                      aria-label={`Share feedback from ${displayName}`}
                      className="inline-flex items-center gap-1.5 rounded-full px-2.5 py-1.5 text-[11px] font-semibold text-[#8a6258] transition hover:bg-[#f8f1ed] hover:text-[#ae2b2b] focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[#ae2b2b]/30"
                    >
                      {sharedReviewId === (t.id || index) ? (
                        <><Check className="h-3.5 w-3.5" /> Copied</>
                      ) : (
                        <><Share2 className="h-3.5 w-3.5" /> Share</>
                      )}
                    </button>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      ) : (
        /* ── Empty State ── */
        <div className="rounded-2xl border border-dashed border-gray-200 p-10 sm:p-16 text-center">
          <div className="mx-auto mb-5 h-14 w-14 rounded-2xl bg-[#ae2b2b]/[0.06] text-[#ae2b2b] flex items-center justify-center">
            <Heart className="h-6 w-6" />
          </div>
          <h3 className="text-xl font-bold text-gray-900 tracking-tight">
            {isJainific
              ? "Be the First to Review Jainific 3.0!"
              : "No Feedback Yet"}
          </h3>
          <p className="mt-2 text-sm text-gray-400 max-w-md mx-auto leading-relaxed">
            {isJainific
              ? "Share what you experienced at the scientific models and scriptural exhibits."
              : "Share your experience and thoughts about this project."}
          </p>
          <button
            onClick={() => setIsFormOpen(true)}
            className="mt-6 bg-[#ae2b2b] hover:bg-[#961f1f] text-white px-6 py-2.5 rounded-xl font-semibold text-sm shadow-sm hover:shadow-md transition-all duration-200 inline-flex items-center gap-2"
          >
            <Star className="w-4 h-4 fill-current" /> Share Your Feedback
          </button>
        </div>
      )}
    </section>
  );
}
