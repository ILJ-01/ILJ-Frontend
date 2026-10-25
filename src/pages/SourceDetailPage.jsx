import { useState, useEffect } from "react";
import { useParams, Link, useNavigate } from "react-router-dom";
import { SOURCES, getSourceBySlug } from "@/data/sourceData";
import {
  BookOpen,
  Sparkles,
  ZoomIn,
  ZoomOut,
  Maximize2,
  X,
  ChevronLeft,
  ChevronRight,
  Share2,
  Copy,
  Check,
  MessageCircleQuestion,
  ExternalLink,
  Download,
  Scroll,
  Layers,
  ArrowRight,
  ShieldCheck,
  RotateCcw
} from "lucide-react";

export default function SourceDetailPage({ forcedSlug }) {
  const { slug: routeSlug } = useParams();
  const slug = forcedSlug || routeSlug;
  const navigate = useNavigate();

  const source = getSourceBySlug(slug);

  // Active image index
  const [activeImageIndex, setActiveImageIndex] = useState(0);
  const [viewMode, setViewMode] = useState("single"); // 'single' or 'stacked'

  // Lightbox Modal state
  const [lightboxOpen, setLightboxOpen] = useState(false);
  const [lightboxIndex, setLightboxIndex] = useState(0);
  const [zoomLevel, setZoomLevel] = useState(1);

  // Link copy toast
  const [copiedLink, setCopiedLink] = useState(false);

  // Reset active image when slug changes
  useEffect(() => {
    setActiveImageIndex(0);
    setViewMode("single");
    setLightboxOpen(false);
    setZoomLevel(1);
    window.scrollTo({ top: 0, behavior: "smooth" });
  }, [slug]);

  // Keyboard navigation for lightbox
  useEffect(() => {
    if (!lightboxOpen || !source) return;

    const handleKeyDown = (e) => {
      if (e.key === "Escape") {
        setLightboxOpen(false);
        setZoomLevel(1);
      } else if (e.key === "ArrowRight") {
        setLightboxIndex((prev) => (prev + 1) % source.images.length);
        setZoomLevel(1);
      } else if (e.key === "ArrowLeft") {
        setLightboxIndex((prev) => (prev - 1 + source.images.length) % source.images.length);
        setZoomLevel(1);
      }
    };

    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [lightboxOpen, source]);

  if (!source) {
    return (
      <div className="min-h-[70vh] flex items-center justify-center py-16 px-4 bg-gradient-to-b from-[#fbf8f7] to-white">
        <div className="max-w-md w-full bg-white rounded-3xl p-8 border border-gray-200 shadow-xl text-center">
          <BookOpen className="h-12 w-12 text-[#ae2b2b] mx-auto mb-4" />
          <h2 className="text-2xl font-bold text-gray-900 font-serif">Source Not Found</h2>
          <p className="text-sm text-gray-500 mt-2">
            The requested scripture source citation could not be found.
          </p>
          <div className="mt-6 flex flex-col gap-2">
            <Link
              to="/sources"
              className="px-6 py-2.5 rounded-xl bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white font-bold text-sm transition"
            >
              Browse All 5 Sources
            </Link>
            <Link
              to="/"
              className="px-6 py-2.5 rounded-xl border border-gray-200 hover:bg-gray-50 text-gray-700 font-semibold text-sm transition"
            >
              Return Home
            </Link>
          </div>
        </div>
      </div>
    );
  }

  // Find previous and next sources
  const currentIndex = SOURCES.findIndex((s) => s.id === source.id);
  const prevSource = SOURCES[(currentIndex - 1 + SOURCES.length) % SOURCES.length];
  const nextSource = SOURCES[(currentIndex + 1) % SOURCES.length];

  const currentUrl = typeof window !== "undefined" ? window.location.href : "";

  const handleCopy = () => {
    navigator.clipboard.writeText(currentUrl);
    setCopiedLink(true);
    setTimeout(() => setCopiedLink(false), 2500);
  };

  const handleWhatsAppShare = () => {
    const text = `Jai Jinendra,\n\nLook at this authentic Agam Scripture source for *${source.title}*:\n📖 ${source.scriptureHindi}\n${source.scriptureEnglish}\n\nView original texts & commentary here:\n${currentUrl}`;
    window.open(`https://wa.me/?text=${encodeURIComponent(text)}`, "_blank");
  };

  const openLightbox = (index) => {
    setLightboxIndex(index);
    setZoomLevel(1);
    setLightboxOpen(true);
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-[#fcf9f8] via-[#faf6f5] to-white py-8 sm:py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-5xl mx-auto space-y-8">
        
        {/* Navigation Breadcrumb / Top Bar */}
        <div className="flex flex-wrap items-center justify-between gap-3 text-xs sm:text-sm">
          <Link
            to="/sources"
            className="inline-flex items-center gap-1.5 font-bold text-gray-600 hover:text-[#ae2b2b] transition-colors"
          >
            <ChevronLeft className="h-4 w-4" /> All 5 Agam Sources
          </Link>

          <div className="flex items-center gap-2">
            <button
              onClick={handleWhatsAppShare}
              className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs shadow-xs transition cursor-pointer"
              title="Share on WhatsApp"
            >
              <Share2 className="h-3.5 w-3.5" />
              <span>Share</span>
            </button>

            <button
              onClick={handleCopy}
              className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg border border-gray-200 bg-white hover:bg-gray-50 text-gray-700 font-bold text-xs shadow-xs transition cursor-pointer"
              title="Copy page link"
            >
              {copiedLink ? (
                <>
                  <Check className="h-3.5 w-3.5 text-emerald-600" />
                  <span>Copied!</span>
                </>
              ) : (
                <>
                  <Copy className="h-3.5 w-3.5 text-gray-500" />
                  <span>Copy Link</span>
                </>
              )}
            </button>
          </div>
        </div>

        {/* Hero Scripture Header Card */}
        <div className="bg-white rounded-3xl p-6 sm:p-10 border border-[#ae2b2b]/15 shadow-xl relative overflow-hidden">
          <div className="absolute top-0 left-0 right-0 h-2 bg-gradient-to-r from-[#ae2b2b] via-[#cf4040] to-[#ae2b2b]" />

          {/* Background decorative watermark */}
          <div className="absolute -right-12 -bottom-12 opacity-5 pointer-events-none text-gray-900">
            <Scroll className="h-64 w-64" />
          </div>

          <div className="max-w-3xl">
            <div className="inline-flex items-center gap-2 px-3.5 py-1 rounded-full bg-[#ae2b2b]/10 text-[#ae2b2b] text-xs font-bold tracking-widest uppercase mb-4 border border-[#ae2b2b]/15">
              <Scroll className="h-3.5 w-3.5" />
              Shastriya Praman (आगम प्रमाण)
            </div>

            <h1 className="text-3xl sm:text-4xl md:text-5xl font-bold text-gray-900 font-serif leading-tight">
              {source.title}
            </h1>

            {/* Bilingual Scripture Reference Box */}
            <div className="mt-5 p-4 sm:p-5 rounded-2xl bg-gradient-to-br from-amber-50/70 via-red-50/30 to-amber-50/50 border border-amber-200/80">
              <span className="text-[11px] font-bold uppercase tracking-wider text-amber-900/70 block mb-1">
                Authentic Source Scripture:
              </span>
              <p className="text-xl sm:text-2xl font-bold text-[#ae2b2b] font-serif">
                {source.scriptureHindi}
              </p>
              <p className="text-base sm:text-lg font-semibold text-gray-800 font-serif mt-0.5">
                {source.scriptureEnglish}
              </p>
              {source.author && (
                <p className="text-xs sm:text-sm text-gray-600 font-medium mt-2 pt-2 border-t border-amber-200/60 flex items-center gap-1.5">
                  <ShieldCheck className="h-4 w-4 text-[#ae2b2b]" />
                  Discoursed / Composed by: <strong>{source.author}</strong>
                </p>
              )}
            </div>

            <p className="mt-4 text-sm sm:text-base text-gray-600 leading-relaxed font-serif">
              {source.shortSummary}
            </p>
          </div>
        </div>

        {/* Source Photos Showcase Card */}
        <div className="bg-white rounded-3xl p-6 sm:p-9 border border-gray-100 shadow-xl space-y-6">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-gray-100">
            <div>
              <h2 className="text-xl sm:text-2xl font-bold text-gray-900 font-serif flex items-center gap-2">
                <BookOpen className="h-5 w-5 text-[#ae2b2b]" />
                Original Manuscript / Book Scan
              </h2>
              <p className="text-xs sm:text-sm text-gray-500 mt-0.5">
                Click any page to zoom in and examine the Sanskrit / Prakrit / Hindi text in high resolution.
              </p>
            </div>

            {/* Multi-page controls (if 2+ images) */}
            {source.images.length > 1 && (
              <div className="flex items-center gap-2 shrink-0">
                <div className="inline-flex bg-gray-100 p-1 rounded-xl text-xs font-semibold">
                  <button
                    onClick={() => setViewMode("single")}
                    className={`px-3 py-1.5 rounded-lg transition cursor-pointer ${
                      viewMode === "single"
                        ? "bg-white text-gray-900 shadow-xs"
                        : "text-gray-600 hover:text-gray-900"
                    }`}
                  >
                    Tab View
                  </button>
                  <button
                    onClick={() => setViewMode("stacked")}
                    className={`px-3 py-1.5 rounded-lg transition cursor-pointer ${
                      viewMode === "stacked"
                        ? "bg-white text-gray-900 shadow-xs"
                        : "text-gray-600 hover:text-gray-900"
                    }`}
                  >
                    <Layers className="h-3.5 w-3.5 inline mr-1" />
                    All ({source.images.length})
                  </button>
                </div>
              </div>
            )}
          </div>

          {/* If Single View Mode with multiple images: show page selector tabs */}
          {source.images.length > 1 && viewMode === "single" && (
            <div className="flex flex-wrap items-center gap-2 pb-2">
              {source.images.map((img, idx) => (
                <button
                  key={idx}
                  onClick={() => setActiveImageIndex(idx)}
                  className={`px-4 py-2 rounded-xl text-xs font-bold transition-all cursor-pointer border ${
                    activeImageIndex === idx
                      ? "bg-[#ae2b2b] text-white border-[#ae2b2b] shadow-sm"
                      : "bg-gray-50 text-gray-700 border-gray-200 hover:bg-gray-100"
                  }`}
                >
                  Page {idx + 1} of {source.images.length}
                </button>
              ))}
            </div>
          )}

          {/* Single Image View */}
          {viewMode === "single" && (
            <div className="space-y-4">
              <div className="relative group bg-gray-900/5 rounded-2xl overflow-hidden border border-gray-200 shadow-sm flex items-center justify-center p-2 sm:p-4 min-h-[350px]">
                <img
                  src={source.images[activeImageIndex].url}
                  alt={source.images[activeImageIndex].label}
                  className="max-h-[750px] w-auto max-w-full rounded-xl object-contain shadow-md cursor-zoom-in transition-transform duration-300 group-hover:scale-[1.01]"
                  onClick={() => openLightbox(activeImageIndex)}
                />

                {/* Hover overlay button to zoom */}
                <button
                  onClick={() => openLightbox(activeImageIndex)}
                  className="absolute bottom-5 right-5 inline-flex items-center gap-2 px-4 py-2.5 rounded-xl bg-gray-900/85 hover:bg-black text-white text-xs font-bold backdrop-blur-sm shadow-lg transition-all cursor-pointer opacity-90 hover:opacity-100 hover:scale-105"
                >
                  <Maximize2 className="h-4 w-4" />
                  <span>Click to Enlarge / Zoom</span>
                </button>
              </div>

              {/* Caption Bar */}
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 p-4 rounded-xl bg-gray-50 border border-gray-200 text-xs text-gray-600">
                <div>
                  <strong className="text-gray-900 block font-semibold text-sm">
                    {source.images[activeImageIndex].label}
                  </strong>
                  <p className="mt-0.5 text-gray-500">
                    {source.images[activeImageIndex].caption}
                  </p>
                </div>

                <div className="flex items-center gap-2 shrink-0">
                  <a
                    href={source.images[activeImageIndex].url}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg border border-gray-200 bg-white hover:bg-gray-100 text-gray-700 font-semibold transition cursor-pointer"
                  >
                    <ExternalLink className="h-3.5 w-3.5" />
                    <span>Open Full Image</span>
                  </a>
                </div>
              </div>
            </div>
          )}

          {/* Stacked View: All pages shown vertically */}
          {viewMode === "stacked" && (
            <div className="space-y-8">
              {source.images.map((img, idx) => (
                <div key={idx} className="space-y-3">
                  <div className="flex items-center justify-between">
                    <span className="text-xs font-bold uppercase tracking-wider text-gray-500">
                      Page {idx + 1} of {source.images.length}: {img.label}
                    </span>
                    <button
                      onClick={() => openLightbox(idx)}
                      className="text-xs text-[#ae2b2b] hover:underline font-bold flex items-center gap-1 cursor-pointer"
                    >
                      <Maximize2 className="h-3 w-3" /> Enlarge Page {idx + 1}
                    </button>
                  </div>

                  <div
                    onClick={() => openLightbox(idx)}
                    className="bg-gray-900/5 rounded-2xl overflow-hidden border border-gray-200 p-2 sm:p-4 flex items-center justify-center cursor-zoom-in group hover:border-[#ae2b2b]/40 transition"
                  >
                    <img
                      src={img.url}
                      alt={img.label}
                      className="max-h-[700px] w-auto max-w-full rounded-xl object-contain shadow-md transition group-hover:scale-[1.008]"
                    />
                  </div>

                  <p className="text-xs text-gray-500 pl-1">{img.caption}</p>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Key Philosophical & Scientific Insights */}
        {source.highlights && source.highlights.length > 0 && (
          <div className="bg-white rounded-3xl p-6 sm:p-8 border border-gray-100 shadow-xl space-y-4">
            <h3 className="text-lg sm:text-xl font-bold text-gray-900 font-serif flex items-center gap-2">
              <Sparkles className="h-5 w-5 text-[#ae2b2b]" />
              Key Insights from this Sutra
            </h3>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4 pt-2">
              {source.highlights.map((point, pIdx) => (
                <div
                  key={pIdx}
                  className="p-4 rounded-2xl bg-amber-50/40 border border-amber-200/60 space-y-2"
                >
                  <div className="h-7 w-7 rounded-full bg-[#ae2b2b]/10 text-[#ae2b2b] flex items-center justify-center font-bold text-xs">
                    0{pIdx + 1}
                  </div>
                  <p className="text-xs sm:text-sm text-gray-700 leading-relaxed font-medium">
                    {point}
                  </p>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Have a Question Banner (Connected to /ask-question) */}
        <div className="bg-gradient-to-r from-[#5c1212] via-[#8f1f1f] to-[#ae2b2b] rounded-3xl p-6 sm:p-8 text-white shadow-xl relative overflow-hidden flex flex-col md:flex-row items-center justify-between gap-6">
          <div className="space-y-2 text-center md:text-left">
            <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-white/15 text-white text-xs font-bold uppercase tracking-wider backdrop-blur-xs">
              <MessageCircleQuestion className="h-3.5 w-3.5" /> Have Any Doubts?
            </span>
            <h3 className="text-xl sm:text-2xl font-bold font-serif">
              Have questions or curiosities about {source.topic}?
            </h3>
            <p className="text-xs sm:text-sm text-red-100 max-w-xl">
              Ask our experienced mentors and scholars. You will receive a unique conversation link with tailored guidance and follow-up discussion.
            </p>
          </div>

          <Link
            to="/ask-question"
            className="px-6 py-3.5 rounded-xl bg-white hover:bg-red-50 text-[#ae2b2b] font-bold text-sm shadow-lg transition-all shrink-0 hover:scale-105 active:scale-95 inline-flex items-center gap-2"
          >
            <span>Ask a Question</span>
            <ArrowRight className="h-4 w-4" />
          </Link>
        </div>

        {/* Previous / Next Source Navigation */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <Link
            to={`/source/${prevSource.slug}`}
            className="p-5 rounded-2xl bg-white border border-gray-200 hover:border-[#ae2b2b]/40 shadow-sm hover:shadow-md transition group flex items-center gap-3.5"
          >
            <div className="h-10 w-10 rounded-xl bg-gray-100 group-hover:bg-[#ae2b2b]/10 text-gray-600 group-hover:text-[#ae2b2b] flex items-center justify-center shrink-0 transition">
              <ChevronLeft className="h-5 w-5" />
            </div>
            <div className="overflow-hidden">
              <span className="text-[11px] font-bold uppercase tracking-wider text-gray-400 block">
                Previous Source
              </span>
              <span className="text-sm font-bold text-gray-900 group-hover:text-[#ae2b2b] transition truncate block font-serif">
                {prevSource.title}
              </span>
            </div>
          </Link>

          <Link
            to={`/source/${nextSource.slug}`}
            className="p-5 rounded-2xl bg-white border border-gray-200 hover:border-[#ae2b2b]/40 shadow-sm hover:shadow-md transition group flex items-center justify-end text-right gap-3.5"
          >
            <div className="overflow-hidden">
              <span className="text-[11px] font-bold uppercase tracking-wider text-gray-400 block">
                Next Source
              </span>
              <span className="text-sm font-bold text-gray-900 group-hover:text-[#ae2b2b] transition truncate block font-serif">
                {nextSource.title}
              </span>
            </div>
            <div className="h-10 w-10 rounded-xl bg-gray-100 group-hover:bg-[#ae2b2b]/10 text-gray-600 group-hover:text-[#ae2b2b] flex items-center justify-center shrink-0 transition">
              <ChevronRight className="h-5 w-5" />
            </div>
          </Link>
        </div>

      </div>

      {/* ==================================================== */}
      {/* FULLSCREEN LIGHTBOX MODAL (WITH ZOOM IN/OUT CONTROLS) */}
      {/* ==================================================== */}
      {lightboxOpen && (
        <div className="fixed inset-0 z-50 bg-black/95 backdrop-blur-md flex flex-col justify-between p-4 animate-in fade-in duration-200">
          
          {/* Lightbox Header Bar */}
          <div className="flex items-center justify-between text-white p-2">
            <div>
              <h4 className="text-sm font-bold font-serif">
                {source.images[lightboxIndex].label}
              </h4>
              <p className="text-xs text-gray-400">
                Page {lightboxIndex + 1} of {source.images.length} • {source.scriptureHindi}
              </p>
            </div>

            <div className="flex items-center gap-2">
              {/* Zoom Out */}
              <button
                onClick={() => setZoomLevel((z) => Math.max(1, z - 0.25))}
                disabled={zoomLevel <= 1}
                className="p-2 rounded-lg bg-white/10 hover:bg-white/20 text-white disabled:opacity-40 transition cursor-pointer"
                title="Zoom Out"
              >
                <ZoomOut className="h-4 w-4" />
              </button>

              {/* Reset Zoom */}
              <button
                onClick={() => setZoomLevel(1)}
                className="px-2.5 py-1.5 rounded-lg bg-white/10 hover:bg-white/20 text-white text-xs font-mono transition cursor-pointer"
                title="Reset Zoom"
              >
                {Math.round(zoomLevel * 100)}%
              </button>

              {/* Zoom In */}
              <button
                onClick={() => setZoomLevel((z) => Math.min(3, z + 0.25))}
                disabled={zoomLevel >= 3}
                className="p-2 rounded-lg bg-white/10 hover:bg-white/20 text-white disabled:opacity-40 transition cursor-pointer"
                title="Zoom In"
              >
                <ZoomIn className="h-4 w-4" />
              </button>

              {/* Close Modal */}
              <button
                onClick={() => {
                  setLightboxOpen(false);
                  setZoomLevel(1);
                }}
                className="p-2 rounded-lg bg-white/20 hover:bg-red-600 text-white transition cursor-pointer ml-3"
                title="Close Lightbox (Esc)"
              >
                <X className="h-5 w-5" />
              </button>
            </div>
          </div>

          {/* Lightbox Image Center Area */}
          <div className="flex-1 flex items-center justify-center relative overflow-auto p-2">
            {/* Previous Image Arrow */}
            {source.images.length > 1 && (
              <button
                onClick={() => {
                  setLightboxIndex((prev) => (prev - 1 + source.images.length) % source.images.length);
                  setZoomLevel(1);
                }}
                className="absolute left-4 top-1/2 -translate-y-1/2 p-3 rounded-full bg-white/15 hover:bg-white/30 text-white backdrop-blur-sm transition cursor-pointer z-10"
                title="Previous Page (Left Arrow)"
              >
                <ChevronLeft className="h-6 w-6" />
              </button>
            )}

            {/* Scaled Image */}
            <div className="max-h-[85vh] max-w-[90vw] overflow-auto flex items-center justify-center">
              <img
                src={source.images[lightboxIndex].url}
                alt={source.images[lightboxIndex].label}
                style={{ transform: `scale(${zoomLevel})`, transformOrigin: "center center" }}
                className="max-h-[80vh] w-auto max-w-full object-contain rounded-lg shadow-2xl transition-transform duration-200 select-none"
              />
            </div>

            {/* Next Image Arrow */}
            {source.images.length > 1 && (
              <button
                onClick={() => {
                  setLightboxIndex((prev) => (prev + 1) % source.images.length);
                  setZoomLevel(1);
                }}
                className="absolute right-4 top-1/2 -translate-y-1/2 p-3 rounded-full bg-white/15 hover:bg-white/30 text-white backdrop-blur-sm transition cursor-pointer z-10"
                title="Next Page (Right Arrow)"
              >
                <ChevronRight className="h-6 w-6" />
              </button>
            )}
          </div>

          {/* Lightbox Footer Thumbnail Strip */}
          {source.images.length > 1 && (
            <div className="flex items-center justify-center gap-2 p-2">
              {source.images.map((img, idx) => (
                <button
                  key={idx}
                  onClick={() => {
                    setLightboxIndex(idx);
                    setZoomLevel(1);
                  }}
                  className={`h-12 w-12 rounded-lg overflow-hidden border-2 transition cursor-pointer ${
                    lightboxIndex === idx ? "border-[#ae2b2b] scale-105" : "border-white/30 opacity-60 hover:opacity-100"
                  }`}
                >
                  <img src={img.url} alt={`Thumb ${idx + 1}`} className="h-full w-full object-cover" />
                </button>
              ))}
            </div>
          )}

        </div>
      )}

    </div>
  );
}
