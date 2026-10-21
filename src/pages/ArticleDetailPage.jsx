import { useState, useEffect } from "react";
import { useParams, Link, useNavigate } from "react-router-dom";
import { supabase } from "@/lib/supabase";
import fallbackArticles from "@/data/articles.json";
import {
  ArrowLeft,
  Calendar,
  Clock,
  User,
  Share2,
  Check,
  Bookmark,
  MessageCircle,
  Sparkles,
  ChevronRight,
  HelpCircle,
  Heart
} from "lucide-react";

export default function ArticleDetailPage() {
  const { slug } = useParams();
  const navigate = useNavigate();

  const [article, setArticle] = useState(null);
  const [loading, setLoading] = useState(true);
  const [scrollProgress, setScrollProgress] = useState(0);
  const [copied, setCopied] = useState(false);

  useEffect(() => {
    fetchArticle();
    window.scrollTo({ top: 0, behavior: "instant" });
  }, [slug]);

  // Track reading scroll progress
  useEffect(() => {
    const handleScroll = () => {
      const totalHeight = document.documentElement.scrollHeight - window.innerHeight;
      if (totalHeight > 0) {
        const currentProgress = (window.scrollY / totalHeight) * 100;
        setScrollProgress(Math.min(100, Math.max(0, currentProgress)));
      }
    };

    window.addEventListener("scroll", handleScroll, { passive: true });
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  const fetchArticle = async () => {
    try {
      setLoading(true);
      const { data, error } = await supabase
        .from("articles")
        .select("*")
        .eq("slug", slug)
        .eq("is_published", true)
        .maybeSingle();

      if (error || !data) {
        // Fallback to local articles data
        const local = fallbackArticles.find((a) => a.slug === slug) || fallbackArticles[0];
        setArticle(local);
      } else {
        setArticle(data);
      }
    } catch (err) {
      console.error("Error fetching article:", err);
      const local = fallbackArticles.find((a) => a.slug === slug) || fallbackArticles[0];
      setArticle(local);
    } finally {
      setLoading(false);
    }
  };

  const handleShare = async () => {
    const shareUrl = window.location.href;
    if (navigator.share) {
      try {
        await navigator.share({
          title: article?.title,
          text: article?.subtitle,
          url: shareUrl,
        });
      } catch (err) {
        // Fallback to clipboard
        copyToClipboard(shareUrl);
      }
    } else {
      copyToClipboard(shareUrl);
    }
  };

  const copyToClipboard = (text) => {
    navigator.clipboard.writeText(text);
    setCopied(true);
    setTimeout(() => setCopied(false), 2500);
  };

  // Custom formatted markdown parser for the article content
  const renderFormattedContent = (content) => {
    if (!content) return null;

    // Split by double newline or block patterns
    const rawParagraphs = content.split(/\n\n+/);

    return rawParagraphs.map((block, index) => {
      const trimmed = block.trim();

      // Horizontal rule
      if (trimmed === "---") {
        return (
          <hr
            key={index}
            className="my-10 border-t-2 border-[#ae2b2b]/15 max-w-xs mx-auto"
          />
        );
      }

      // H3 Heading (### Heading)
      if (trimmed.startsWith("### ")) {
        return (
          <h3
            key={index}
            className="text-2xl sm:text-3xl font-serif font-bold text-[#ae2b2b] mt-10 mb-4 tracking-tight"
          >
            {trimmed.replace(/^###\s+/, "")}
          </h3>
        );
      }

      // H2 Heading (## Heading)
      if (trimmed.startsWith("## ")) {
        return (
          <h2
            key={index}
            className="text-3xl sm:text-4xl font-serif font-bold text-gray-900 mt-12 mb-6 tracking-tight border-b border-gray-200 pb-3"
          >
            {trimmed.replace(/^##\s+/, "")}
          </h2>
        );
      }

      // Blockquote (> Text)
      if (trimmed.startsWith("> ")) {
        const quoteText = trimmed.replace(/^>\s*/gm, "").replace(/\*+/g, "");
        return (
          <div
            key={index}
            className="my-8 p-6 sm:p-8 bg-gradient-to-r from-[#ae2b2b]/8 to-[#ae2b2b]/2 border-l-4 border-[#ae2b2b] rounded-r-2xl shadow-sm"
          >
            <p className="font-serif italic text-lg sm:text-xl text-gray-900 leading-relaxed">
              "{quoteText}"
            </p>
          </div>
        );
      }

      // Image (![Alt text](url))
      const imageMatch = trimmed.match(/^!\[(.*?)\]\((.*?)\)$/);
      if (imageMatch) {
        const altText = imageMatch[1];
        const imageUrl = imageMatch[2];
        return (
          <figure key={index} className="my-10">
            <div className="rounded-2xl overflow-hidden border border-gray-200 shadow-md bg-white">
              <img
                src={imageUrl}
                alt={altText}
                className="w-full h-auto object-cover max-h-[600px]"
                loading="lazy"
              />
            </div>
            {altText && (
              <figcaption className="text-center text-xs sm:text-sm text-gray-500 mt-3 font-serif italic">
                {altText}
              </figcaption>
            )}
          </figure>
        );
      }

      // Bullet List (- item or * item)
      if (trimmed.startsWith("- ") || trimmed.startsWith("* ")) {
        const items = trimmed.split("\n").filter((l) => l.trim().length > 0);
        return (
          <ul key={index} className="my-5 space-y-2.5 pl-6 list-none">
            {items.map((item, i) => {
              const cleanItem = item.replace(/^[-*]\s+/, "");
              // Parse **bold** inside item
              const parts = cleanItem.split(/(\*\*.*?\*\*)/g);
              return (
                <li key={i} className="flex items-start gap-3 text-base sm:text-lg text-gray-700 leading-relaxed">
                  <span className="w-2 h-2 rounded-full bg-[#ae2b2b] mt-2.5 shrink-0" />
                  <span>
                    {parts.map((part, pIdx) => {
                      if (part.startsWith("**") && part.endsWith("**")) {
                        return (
                          <strong key={pIdx} className="font-bold text-gray-900">
                            {part.slice(2, -2)}
                          </strong>
                        );
                      }
                      return part;
                    })}
                  </span>
                </li>
              );
            })}
          </ul>
        );
      }

      // Regular Paragraph with inline **bold** and *italic*
      // Handle line breaks (trailing 2 spaces or explicit \n)
      const lines = block.split(/\n/);
      return (
        <p
          key={index}
          className="text-base sm:text-lg text-gray-700 leading-relaxed font-sans mb-5"
        >
          {lines.map((line, lIdx) => {
            // Parse bold & italics
            const segments = line.split(/(\*\*.*?\*\*|\*.*?\*)/g);
            return (
              <span key={lIdx}>
                {segments.map((seg, sIdx) => {
                  if (seg.startsWith("**") && seg.endsWith("**")) {
                    return (
                      <strong key={sIdx} className="font-bold text-gray-900">
                        {seg.slice(2, -2)}
                      </strong>
                    );
                  }
                  if (seg.startsWith("*") && seg.endsWith("*")) {
                    return (
                      <em key={sIdx} className="italic text-gray-800">
                        {seg.slice(1, -1)}
                      </em>
                    );
                  }
                  return seg;
                })}
                {lIdx < lines.length - 1 && <br />}
              </span>
            );
          })}
        </p>
      );
    });
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-[#faf8f5] flex items-center justify-center py-20">
        <div className="text-center">
          <div className="inline-block animate-spin rounded-full h-10 w-10 border-4 border-[#ae2b2b] border-t-transparent mb-4" />
          <p className="text-gray-500 font-serif">Loading article...</p>
        </div>
      </div>
    );
  }

  if (!article) {
    return (
      <div className="min-h-screen bg-[#faf8f5] flex items-center justify-center py-20 px-4">
        <div className="text-center max-w-md bg-white p-8 rounded-2xl shadow-sm border border-gray-200">
          <h2 className="text-2xl font-bold font-serif text-gray-900 mb-2">
            Article Not Found
          </h2>
          <p className="text-gray-600 text-sm mb-6">
            The article you are looking for might have been moved or is currently unavailable.
          </p>
          <Link
            to="/articles"
            className="inline-flex items-center gap-2 bg-[#ae2b2b] text-white px-5 py-2.5 rounded-full text-sm font-semibold hover:bg-[#8f1f1f] transition"
          >
            <ArrowLeft className="h-4 w-4" />
            Back to All Articles
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-[#faf8f5] text-gray-900 font-sans pb-24">
      {/* Scroll Reading Progress Bar */}
      <div className="fixed top-0 left-0 right-0 h-1 bg-gray-200 z-50">
        <div
          className="h-full bg-[#ae2b2b] transition-all duration-150 ease-out"
          style={{ width: `${scrollProgress}%` }}
        />
      </div>

      {/* Top Breadcrumb & Nav Bar */}
      <div className="bg-white border-b border-gray-200 sticky top-0 z-40 shadow-xs">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 py-3.5 flex items-center justify-between">
          <Link
            to="/articles"
            className="inline-flex items-center gap-2 text-xs sm:text-sm font-semibold text-gray-600 hover:text-[#ae2b2b] transition"
          >
            <ArrowLeft className="h-4 w-4" />
            All Articles
          </Link>

          <div className="flex items-center gap-2">
            <button
              onClick={handleShare}
              className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-semibold bg-gray-100 hover:bg-gray-200 text-gray-700 transition cursor-pointer"
              title="Share article"
            >
              {copied ? (
                <>
                  <Check className="h-3.5 w-3.5 text-emerald-600" />
                  <span className="text-emerald-700 font-bold">Copied!</span>
                </>
              ) : (
                <>
                  <Share2 className="h-3.5 w-3.5" />
                  <span>Share</span>
                </>
              )}
            </button>
          </div>
        </div>
      </div>

      {/* Main Reader Container */}
      <article className="max-w-4xl mx-auto px-4 sm:px-6 pt-10">
        {/* Category Pill */}
        <div className="flex items-center gap-2 text-xs font-bold text-[#ae2b2b] uppercase tracking-wider mb-4">
          <Sparkles className="h-4 w-4" />
          <span>{article.category || "Jain Philosophy & Wisdom"}</span>
        </div>

        {/* H1 Title */}
        <h1 className="text-3xl sm:text-5xl font-serif font-bold text-gray-900 leading-tight mb-5 tracking-tight">
          {article.title}
        </h1>

        {/* Subtitle / Question Hook */}
        {article.subtitle && (
          <p className="text-lg sm:text-2xl text-gray-600 font-serif leading-relaxed italic mb-8">
            {article.subtitle}
          </p>
        )}

        {/* Author & Publication Metadata */}
        <div className="flex flex-wrap items-center justify-between gap-4 py-5 border-y border-gray-200 mb-8">
          <div className="flex items-center gap-3.5">
            <div className="w-12 h-12 rounded-full bg-[#ae2b2b]/10 text-[#ae2b2b] flex items-center justify-center font-serif font-bold text-base shadow-xs">
              ILJ
            </div>
            <div>
              <p className="text-sm font-bold text-gray-900">{article.author}</p>
              <p className="text-xs text-gray-500">
                {article.author_role || "ILJ Research & Philosophy Pod"}
              </p>
            </div>
          </div>

          <div className="flex items-center gap-4 text-xs sm:text-sm text-gray-500">
            <span className="flex items-center gap-1.5">
              <Calendar className="h-4 w-4 text-gray-400" />
              {new Date(article.published_at).toLocaleDateString("en-US", {
                month: "long",
                day: "numeric",
                year: "numeric"
              })}
            </span>
            <span>•</span>
            <span className="flex items-center gap-1.5">
              <Clock className="h-4 w-4 text-gray-400" />
              {article.read_time || "4 min read"}
            </span>
          </div>
        </div>

        {/* Cover Image */}
        {article.cover_image && (
          <div className="mb-12 rounded-3xl overflow-hidden shadow-lg border border-gray-200">
            <img
              src={article.cover_image}
              alt={article.title}
              className="w-full h-auto object-cover max-h-[540px]"
            />
          </div>
        )}

        {/* Formatted Article Content */}
        <div className="prose prose-lg max-w-none text-gray-800">
          {renderFormattedContent(article.content)}
        </div>

        {/* Tags Section */}
        {article.tags && article.tags.length > 0 && (
          <div className="mt-12 pt-6 border-t border-gray-200 flex flex-wrap items-center gap-2">
            <span className="text-xs font-bold text-gray-500 uppercase tracking-wider mr-2">
              Topics:
            </span>
            {article.tags.map((tag, idx) => (
              <span
                key={idx}
                className="text-xs bg-gray-100 hover:bg-gray-200 text-gray-700 px-3 py-1.5 rounded-full transition"
              >
                #{tag}
              </span>
            ))}
          </div>
        )}

        {/* Bottom Interactive Reflection Box */}
        <section className="mt-14 bg-gradient-to-br from-white to-[#fff8f5] rounded-3xl p-8 sm:p-10 border border-[#ae2b2b]/20 shadow-md">
          <div className="flex items-center gap-2 text-xs font-bold uppercase tracking-wider text-[#ae2b2b] mb-3">
            <Heart className="h-4 w-4 fill-[#ae2b2b]" /> Reflection for the Day
          </div>
          <h3 className="text-2xl font-serif font-bold text-gray-900 mb-3">
            How has Anekantavada shifted your perspective today?
          </h3>
          <p className="text-gray-600 text-sm sm:text-base leading-relaxed mb-6 font-serif">
            The next time you find yourself in a heated argument or feeling deeply misunderstood, pause for a single breath and ask:
            <br />
            <strong className="text-gray-900">
              "What part of reality might they be experiencing that I haven't seen yet?"
            </strong>
          </p>

          <div className="flex flex-wrap items-center gap-4">
            <button
              onClick={handleShare}
              className="inline-flex items-center gap-2 bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white px-5 py-2.5 rounded-full text-sm font-semibold transition shadow cursor-pointer"
            >
              <Share2 className="h-4 w-4" />
              {copied ? "Link Copied!" : "Share This Article"}
            </button>

            <Link
              to="/ask-question"
              className="inline-flex items-center gap-2 bg-white hover:bg-gray-50 text-gray-800 px-5 py-2.5 rounded-full text-sm font-semibold border border-gray-200 shadow-xs transition"
            >
              <HelpCircle className="h-4 w-4 text-[#ae2b2b]" />
              Ask a Follow-Up Question
            </Link>
          </div>
        </section>

        {/* Next Series Preview Card */}
        <section className="mt-8 bg-white rounded-3xl p-6 sm:p-8 border border-gray-200 shadow-sm flex flex-col sm:flex-row items-start sm:items-center justify-between gap-6">
          <div>
            <span className="text-xs font-bold text-amber-700 bg-amber-50 px-2.5 py-1 rounded-md mb-2 inline-block">
              Part 2 • Coming Soon
            </span>
            <h4 className="text-lg sm:text-xl font-serif font-bold text-gray-900">
Are We Angry at What Happened or What We Think Happened?            </h4>
            <p className="text-xs sm:text-sm text-gray-500 mt-1">
              Exploring the cognitive divide between what actually happened and what we thought happened.
            </p>
          </div>
          <Link
            to="/articles"
            className="inline-flex items-center gap-1.5 text-xs sm:text-sm font-bold text-[#ae2b2b] hover:underline shrink-0"
          >
            Explore More <ChevronRight className="h-4 w-4" />
          </Link>
        </section>
      </article>
    </div>
  );
}
