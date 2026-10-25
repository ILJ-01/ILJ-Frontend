import React, { useState } from "react";
import { Star, MessageSquare, Send, CheckCircle2, MapPin, Calendar, Clock, Sparkles, Filter, ChevronDown, ChevronUp, User } from "lucide-react";
import { Button } from "@/components/ui/button";
import { supabase } from "../lib/supabase";

const RATING_LABELS = [
  "Select a rating",
  "Needs Improvement",
  "Fair",
  "Good",
  "Very Good",
  "Outstanding / Mindblowing!",
];

export default function ProjectFeedbackSection({
  project,
  testimonials = [],
  onFeedbackAdded,
  defaultOpenForm = false,
}) {
  const isJainific =
    project?.project_code === "PRJ-003" ||
    project?.title?.toLowerCase().includes("jainific");

  const [isFormOpen, setIsFormOpen] = useState(defaultOpenForm || testimonials.length === 0);
  const [rating, setRating] = useState(5);
  const [hoverRating, setHoverRating] = useState(0);
  const [comments, setComments] = useState("");
  const [isAnonymous, setIsAnonymous] = useState(false);
  const [name, setName] = useState("");
  const [age, setAge] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [submitSuccess, setSubmitSuccess] = useState(false);
  const [filterRating, setFilterRating] = useState("all");

  const activeRating = hoverRating || rating;

  // Calculate statistics
  const totalReviews = testimonials.length;
  const avgRating = totalReviews > 0
    ? (testimonials.reduce((sum, t) => sum + (Number(t.rating) || 5), 0) / totalReviews).toFixed(1)
    : "5.0";

  const filteredTestimonials = testimonials.filter((t) => {
    if (filterRating === "all") return true;
    return Number(t.rating) === Number(filterRating);
  });

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!comments.trim()) {
      alert("Please enter your feedback comments.");
      return;
    }
    if (!isAnonymous && !name.trim()) {
      alert("Please provide your name or choose to submit anonymously.");
      return;
    }

    setSubmitting(true);
    try {
      const parsedAge = age && !isNaN(parseInt(age, 10)) ? parseInt(age, 10) : null;
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

      if (onFeedbackAdded && data) {
        onFeedbackAdded(data);
      }

      setTimeout(() => {
        setSubmitSuccess(false);
        setIsFormOpen(false);
      }, 3500);
    } catch (err) {
      console.error("Feedback submit error:", err);
      alert("Failed to submit feedback. " + (err.message || "Please check connection."));
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <section id="feedback-section" className="w-full px-2 sm:px-6 md:px-12 mt-14 scroll-mt-24">
      {/* Jainific 3.0 Event Highlight Banner */}
      {isJainific && (
        <div className="relative overflow-hidden rounded-3xl bg-gradient-to-br from-[#ae2b2b] via-[#8a1e1e] to-[#4a0d0d] text-white p-6 sm:p-8 mb-10 shadow-xl border border-red-900/30">
          <div className="absolute -right-12 -bottom-12 w-64 h-64 bg-amber-400/10 rounded-full blur-3xl pointer-events-none" />
          <div className="relative z-10 flex flex-col lg:flex-row items-start lg:items-center justify-between gap-6">
            <div className="space-y-3">
              <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-white/15 backdrop-blur-md text-amber-300 text-xs font-bold uppercase tracking-wider">
                <Sparkles className="w-3.5 h-3.5" />
                <span>Exhibition 3.0 — Malad Edition</span>
              </div>
              <h3 className="text-2xl sm:text-3xl font-extrabold font-serif tracking-tight">
                Jainific 3.0 Malad — 1st November 2026
              </h3>
              <p className="text-white/80 text-sm sm:text-base max-w-2xl leading-relaxed">
                Experience the convergence of timeless Jain wisdom and modern science through interactive exhibits, models, and scriptural evidences.
              </p>
              <div className="flex flex-wrap items-center gap-x-6 gap-y-2.5 pt-1 text-xs sm:text-sm text-amber-100/90 font-medium">
                <div className="flex items-center gap-2 bg-black/20 px-3 py-1.5 rounded-xl backdrop-blur-xs">
                  <Calendar className="w-4 h-4 text-amber-300" />
                  <span>📅 1st November 2026</span>
                </div>
                <div className="flex items-center gap-2 bg-black/20 px-3 py-1.5 rounded-xl backdrop-blur-xs">
                  <Clock className="w-4 h-4 text-amber-300" />
                  <span>⏰ 11:00 AM to 8:00 PM</span>
                </div>
                <div className="flex items-center gap-2 bg-black/20 px-3 py-1.5 rounded-xl backdrop-blur-xs">
                  <MapPin className="w-4 h-4 text-amber-300" />
                  <span>📍 MKES Law College, N.K. College Campus, SV Road, Malad (West)</span>
                </div>
              </div>
            </div>

            <div className="flex flex-col sm:flex-row lg:flex-col gap-3 shrink-0 w-full sm:w-auto">
              <Button
                onClick={() => setIsFormOpen((prev) => !prev)}
                className="bg-amber-400 hover:bg-amber-300 text-gray-950 font-bold px-6 py-3 rounded-xl shadow-lg hover:shadow-xl transition-all cursor-pointer flex items-center justify-center gap-2"
              >
                <MessageSquare className="w-4 h-4" />
                {isFormOpen ? "Hide Feedback Form" : "Share Your Feedback"}
              </Button>
              <a
                href="https://maps.google.com/?q=MKES+Law+College+SV+Road+Malad+West"
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center justify-center gap-2 px-5 py-2.5 rounded-xl bg-white/10 hover:bg-white/20 text-white font-medium text-xs backdrop-blur-md border border-white/20 transition-all text-center"
              >
                <MapPin className="w-3.5 h-3.5" /> Open in Google Maps
              </a>
            </div>
          </div>
        </div>
      )}

      {/* Header Bar */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-[#ae2b2b]/15 pb-5 mb-8">
        <div>
          <span className="text-xs font-bold uppercase tracking-widest text-[#ae2b2b]">
            Community Voices
          </span>
          <h2 className="text-2xl sm:text-3xl font-bold text-gray-900 font-serif mt-1">
            {isJainific ? "Jainific 3.0 Feedback & Reviews" : "Voices of Impact & Feedback"}
          </h2>
        </div>

        <div className="flex flex-wrap items-center gap-3">
          {totalReviews > 0 && (
            <div className="flex items-center gap-2.5 bg-[#ae2b2b]/5 border border-[#ae2b2b]/15 px-4 py-2 rounded-full">
              <div className="flex text-amber-400 gap-0.5">
                {[...Array(5)].map((_, i) => (
                  <Star key={i} className="h-4 w-4 fill-amber-400 text-amber-400" />
                ))}
              </div>
              <span className="text-xs font-bold text-[#ae2b2b]">
                {avgRating} ({totalReviews} Review{totalReviews > 1 ? "s" : ""})
              </span>
            </div>
          )}

          <Button
            onClick={() => setIsFormOpen((prev) => !prev)}
            className="bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white px-5 py-2 rounded-xl text-xs sm:text-sm font-semibold flex items-center gap-2 cursor-pointer shadow-sm hover:shadow-md transition-all"
          >
            <MessageSquare className="h-4 w-4" />
            {isFormOpen ? "Close Form" : "Write Feedback"}
            {isFormOpen ? <ChevronUp className="h-3.5 w-3.5" /> : <ChevronDown className="h-3.5 w-3.5" />}
          </Button>
        </div>
      </div>

      {/* Feedback Collection Form */}
      {isFormOpen && (
        <div className="mb-12 rounded-3xl border border-[#ae2b2b]/20 bg-gradient-to-br from-white via-[#fffcfb] to-amber-50/20 p-6 sm:p-8 shadow-xl relative overflow-hidden transition-all duration-300">
          <div className="absolute top-0 inset-x-0 h-1.5 bg-gradient-to-r from-[#ae2b2b] via-[#d66b3a] to-amber-400" />

          {submitSuccess ? (
            <div className="py-10 text-center animate-in fade-in zoom-in-95 duration-300">
              <div className="mx-auto mb-4 h-16 w-16 rounded-full bg-emerald-50 text-emerald-600 flex items-center justify-center ring-8 ring-emerald-50/50">
                <CheckCircle2 className="h-8 w-8" />
              </div>
              <h3 className="text-2xl font-bold text-gray-900 font-serif">
                Thank You for Your Feedback!
              </h3>
              <p className="mt-2 text-sm text-gray-600 max-w-md mx-auto">
                Your feedback on Jainific 3.0 has been submitted successfully and is now displayed on the page.
              </p>
            </div>
          ) : (
            <form onSubmit={handleSubmit} className="space-y-6">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 border-b border-gray-100 pb-4">
                <div>
                  <h3 className="text-xl sm:text-2xl font-bold text-gray-900 font-serif">
                    {isJainific ? "Give Feedback for Jainific 3.0" : "Share Your Experience"}
                  </h3>
                  <p className="text-xs sm:text-sm text-gray-500 mt-0.5">
                    Your insights help us enrich future sessions and exhibitions.
                  </p>
                </div>
                {isJainific && (
                  <span className="text-xs bg-amber-100 text-amber-800 font-semibold px-3 py-1 rounded-full w-fit">
                    📅 1st Nov 2026 • Malad
                  </span>
                )}
              </div>

              {/* Star Rating Section */}
              <div className="bg-amber-50/50 rounded-2xl p-4 sm:p-5 border border-amber-200/60">
                <label className="block text-xs font-bold uppercase tracking-wider text-amber-900 mb-2">
                  Overall Rating <span className="text-red-500">*</span>
                </label>
                <div className="flex flex-col sm:flex-row sm:items-center gap-4">
                  <div className="flex items-center gap-1.5">
                    {[1, 2, 3, 4, 5].map((star) => (
                      <button
                        key={star}
                        type="button"
                        onClick={() => setRating(star)}
                        onMouseEnter={() => setHoverRating(star)}
                        onMouseLeave={() => setHoverRating(0)}
                        className="p-1 rounded-lg transition-transform hover:scale-125 focus:outline-none"
                      >
                        <Star
                          className={`h-8 w-8 transition-colors ${
                            star <= activeRating
                              ? "fill-amber-400 text-amber-400 drop-shadow-xs"
                              : "text-gray-300 fill-gray-100"
                          }`}
                        />
                      </button>
                    ))}
                  </div>
                  <span className="text-sm font-semibold text-amber-900">
                    {RATING_LABELS[activeRating] || "Select a rating"}
                  </span>
                </div>
              </div>

              {/* Feedback Comments */}
              <div>
                <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1.5">
                  Your Feedback / Experience <span className="text-red-500">*</span>
                </label>
                <textarea
                  rows={4}
                  required
                  value={comments}
                  onChange={(e) => setComments(e.target.value)}
                  placeholder={
                    isJainific
                      ? "Share your feedback, thoughts on the exhibits and models, or suggestions for the upcoming Jainific 3.0..."
                      : "Share your experience, thoughts, and suggestions..."
                  }
                  className="w-full p-3.5 border border-gray-200 rounded-xl bg-white focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] outline-none text-sm leading-relaxed"
                />
              </div>

              {/* Anonymous Checkbox */}
              <div className="flex items-center gap-3 p-3 bg-gray-50 rounded-xl border border-gray-100">
                <input
                  type="checkbox"
                  id="anonymous-toggle"
                  checked={isAnonymous}
                  onChange={(e) => setIsAnonymous(e.target.checked)}
                  className="h-4 w-4 rounded border-gray-300 text-[#ae2b2b] focus:ring-[#ae2b2b]"
                />
                <label htmlFor="anonymous-toggle" className="text-xs sm:text-sm font-medium text-gray-700 cursor-pointer">
                  Submit anonymously (your name and age will be kept private)
                </label>
              </div>

              {/* Personal Details: Only Name and Age */}
              {!isAnonymous && (
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-1">
                  <div>
                    <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1">
                      Your Name <span className="text-red-500">*</span>
                    </label>
                    <input
                      type="text"
                      required
                      value={name}
                      onChange={(e) => setName(e.target.value)}
                      placeholder="e.g. Paras Shah"
                      className="w-full p-3 border border-gray-200 rounded-xl bg-white focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] outline-none text-sm"
                    />
                  </div>

                  <div>
                    <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 mb-1">
                      Age
                    </label>
                    <input
                      type="number"
                      value={age}
                      onChange={(e) => setAge(e.target.value)}
                      placeholder="e.g. 24"
                      className="w-full p-3 border border-gray-200 rounded-xl bg-white focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] outline-none text-sm"
                    />
                  </div>
                </div>
              )}

              {/* Submit Buttons */}
              <div className="flex items-center justify-end gap-3 pt-3">
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => setIsFormOpen(false)}
                  className="rounded-xl px-5"
                >
                  Cancel
                </Button>
                <Button
                  type="submit"
                  disabled={submitting}
                  className="bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white px-7 py-2.5 rounded-xl font-bold flex items-center gap-2 cursor-pointer shadow-md hover:shadow-lg transition-all"
                >
                  {submitting ? (
                    <span>Submitting...</span>
                  ) : (
                    <>
                      <Send className="w-4 h-4" /> Submit Feedback
                    </>
                  )}
                </Button>
              </div>
            </form>
          )}
        </div>
      )}

      {/* Filter Chips if testimonials exist */}
      {totalReviews > 0 && (
        <div className="flex items-center gap-2 mb-6 overflow-x-auto pb-2 text-xs">
          <span className="text-gray-500 font-semibold flex items-center gap-1 shrink-0">
            <Filter className="w-3.5 h-3.5" /> Filter:
          </span>
          <button
            onClick={() => setFilterRating("all")}
            className={`px-3 py-1 rounded-full font-medium transition-all ${
              filterRating === "all"
                ? "bg-[#ae2b2b] text-white shadow-xs"
                : "bg-gray-100 text-gray-600 hover:bg-gray-200"
            }`}
          >
            All ({totalReviews})
          </button>
          {[5, 4, 3].map((num) => {
            const count = testimonials.filter((t) => Number(t.rating) === num).length;
            if (count === 0) return null;
            return (
              <button
                key={num}
                onClick={() => setFilterRating(num.toString())}
                className={`px-3 py-1 rounded-full font-medium transition-all flex items-center gap-1 ${
                  filterRating === num.toString()
                    ? "bg-amber-400 text-gray-950 font-bold shadow-xs"
                    : "bg-gray-100 text-gray-600 hover:bg-gray-200"
                }`}
              >
                <span>{num}</span>
                <Star className="w-3 h-3 fill-current inline" />
                <span>({count})</span>
              </button>
            );
          })}
        </div>
      )}

      {/* Testimonials Grid / List */}
      {filteredTestimonials.length > 0 ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 sm:gap-8">
          {filteredTestimonials.map((t) => {
            const displayName = t.is_anonymous
              ? "Anonymous Visitor"
              : t.name || "Community Member";
            const initial = displayName.charAt(0).toUpperCase();
            const ratingCount = Number(t.rating) || 5;

            // Extract session/topic if formatted as [Session: XYZ]
            const sessionMatch = t.comments?.match(/^\[Session:\s*([^\]]+)\]\s*(.*)$/s);
            const sessionBadge = sessionMatch ? sessionMatch[1] : null;
            const commentBody = sessionMatch ? sessionMatch[2] : t.comments;

            return (
              <div
                key={t.id || Math.random()}
                className="relative group rounded-3xl border border-[#ae2b2b]/10 bg-gradient-to-b from-white to-[#fffcfb] p-6 sm:p-7 shadow-[0_4px_24px_-6px_rgba(174,43,43,0.06)] hover:shadow-xl hover:border-[#ae2b2b]/25 hover:-translate-y-1 transition-all duration-300 flex flex-col justify-between overflow-hidden"
              >
                {/* Accent Top Bar */}
                <div className="absolute top-0 inset-x-0 h-1 bg-gradient-to-r from-[#ae2b2b] via-[#d66b3a] to-amber-400 opacity-80 group-hover:opacity-100 transition-opacity" />

                <div>
                  {/* Rating Stars and Session Badge */}
                  <div className="flex items-center justify-between gap-2 mb-3">
                    <div className="flex items-center gap-1">
                      {[...Array(5)].map((_, i) => (
                        <Star
                          key={i}
                          className={`h-4 w-4 ${
                            i < ratingCount
                              ? "fill-amber-400 text-amber-400"
                              : "text-gray-200 fill-gray-100"
                          }`}
                        />
                      ))}
                    </div>

                    {sessionBadge && (
                      <span className="text-[10px] font-bold uppercase tracking-wider bg-[#ae2b2b]/10 text-[#ae2b2b] px-2.5 py-0.5 rounded-full truncate max-w-[170px]" title={sessionBadge}>
                        {sessionBadge.replace("Jainific 3.0 Malad - 1st November 2026", "Jainific 3.0")}
                      </span>
                    )}
                  </div>

                  {/* Comment Body */}
                  <p className="text-gray-800 leading-relaxed font-serif text-base sm:text-lg italic break-words relative z-10">
                    "{commentBody}"
                  </p>
                </div>

                {/* Submitter Info Footer */}
                <div className="mt-6 pt-4 border-t border-gray-100 flex items-center justify-between gap-3">
                  <div className="flex items-center gap-3 min-w-0">
                    <div className="h-10 w-10 rounded-full bg-gradient-to-br from-[#ae2b2b] to-[#5c1212] text-white flex items-center justify-center font-bold text-sm shadow-md shadow-red-900/20 ring-2 ring-[#ae2b2b]/10 shrink-0">
                      {initial}
                    </div>
                    <div className="flex flex-col min-w-0">
                      <span className="text-sm font-bold text-gray-900 truncate">
                        {displayName}
                      </span>
                      {!t.is_anonymous && (t.age || t.city) && (
                        <span className="text-xs text-[#ae2b2b]/80 font-medium truncate flex items-center gap-1.5">
                          {t.age && <span>Age: {t.age}</span>}
                          {t.age && t.city && <span>•</span>}
                          {t.city && (
                            <span className="flex items-center gap-1">
                              <MapPin className="h-3 w-3 inline" /> {t.city}
                            </span>
                          )}
                        </span>
                      )}
                    </div>
                  </div>

                  {t.created_at && (
                    <span className="text-[10px] text-gray-400 shrink-0 font-mono">
                      {new Date(t.created_at).toLocaleDateString("en-IN", {
                        day: "numeric",
                        month: "short",
                      })}
                    </span>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      ) : (
        <div className="rounded-3xl border border-dashed border-gray-300 p-8 sm:p-12 text-center bg-gray-50/50">
          <div className="mx-auto mb-4 h-16 w-16 rounded-full bg-[#ae2b2b]/10 text-[#ae2b2b] flex items-center justify-center">
            <MessageSquare className="h-7 w-7" />
          </div>
          <h3 className="text-xl font-bold text-gray-900 font-serif">
            {isJainific
              ? "Be the First to Review Jainific 3.0 Malad!"
              : "No Feedback Yet"}
          </h3>
          <p className="mt-2 text-sm text-gray-600 max-w-md mx-auto">
            {isJainific
              ? "Share what you learned or experienced from the scientific models and scriptural exhibits at MKES Law College, Malad."
              : "Share your experience and thoughts about this project with our community."}
          </p>
          <Button
            onClick={() => setIsFormOpen(true)}
            className="mt-5 bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white px-6 py-2.5 rounded-xl font-semibold shadow-sm hover:shadow-md cursor-pointer inline-flex items-center gap-2"
          >
            <Star className="w-4 h-4 fill-current" /> Share Your Feedback
          </Button>
        </div>
      )}
    </section>
  );
}
