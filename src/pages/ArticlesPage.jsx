import { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import { supabase } from "@/lib/supabase";
import fallbackArticles from "@/data/articles.json";
import {
  BookOpen,
  Calendar,
  Clock,
  User,
  Search,
  ArrowRight,
  Sparkles,
  Share2,
  Tag,
  HelpCircle
} from "lucide-react";

export default function ArticlesPage() {
  const [articles, setArticles] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedCategory, setSelectedCategory] = useState("All");

  useEffect(() => {
    fetchArticles();
  }, []);

  const fetchArticles = async () => {
    try {
      setLoading(true);
      const { data, error } = await supabase
        .from("articles")
        .select("*")
        .eq("is_published", true)
        .order("published_at", { ascending: false });

      if (error || !data || data.length === 0) {
        // Fallback to static articles data
        setArticles(fallbackArticles);
      } else {
        setArticles(data);
      }
    } catch (err) {
      console.error("Error fetching articles:", err);
      setArticles(fallbackArticles);
    } finally {
      setLoading(false);
    }
  };

  // Derive unique categories
  const categories = [
    "All",
    ...new Set(articles.map((a) => a.category).filter(Boolean))
  ];

  // Filter articles based on search query and category
  const filteredArticles = articles.filter((article) => {
    const matchesSearch =
      article.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      (article.subtitle && article.subtitle.toLowerCase().includes(searchQuery.toLowerCase())) ||
      (article.excerpt && article.excerpt.toLowerCase().includes(searchQuery.toLowerCase())) ||
      (article.tags && article.tags.some((t) => t.toLowerCase().includes(searchQuery.toLowerCase())));

    const matchesCategory =
      selectedCategory === "All" || article.category === selectedCategory;

    return matchesSearch && matchesCategory;
  });

  const featuredArticle = filteredArticles[0] || articles[0];
  const regularArticles = filteredArticles.slice(1);

  return (
    <div className="min-h-screen bg-[#faf8f5] text-gray-800 font-sans pb-20">
      {/* 1. Hero Banner */}
      <section className="relative overflow-hidden bg-gradient-to-b from-[#ae2b2b] via-[#912020] to-[#751616] text-white pt-16 pb-20 px-4 sm:px-6 lg:px-8">
        {/* Subtle patterned background circles */}
        <div className="absolute -top-24 -right-24 w-96 h-96 bg-white/5 rounded-full blur-2xl pointer-events-none" />
        <div className="absolute -bottom-24 -left-24 w-96 h-96 bg-amber-400/10 rounded-full blur-2xl pointer-events-none" />

        <div className="max-w-5xl mx-auto text-center relative z-10">
          <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-white/10 backdrop-blur-md text-amber-200 text-xs sm:text-sm font-medium tracking-wide mb-5 border border-white/15">
            <Sparkles className="h-4 w-4" /> Team I Love Jinshasan • Publications & Wisdom
          </div>

          <h1 className="text-3xl sm:text-5xl lg:text-6xl font-serif font-bold tracking-tight text-white mb-6">
            Articles & Reflections
          </h1>

          <p className="max-w-2xl mx-auto text-base sm:text-xl text-gray-200 leading-relaxed font-serif">
            Exploring timeless Jain philosophical wisdom, modern psychological relevance, and thought-provoking perspectives for daily life.
          </p>

          {/* Search Bar */}
          <div className="mt-8 max-w-xl mx-auto relative">
            <div className="relative flex items-center">
              <Search className="absolute left-4 h-5 w-5 text-gray-400" />
              <input
                type="text"
                placeholder="Search articles by title, topic, or keyword..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full pl-12 pr-4 py-3.5 rounded-full bg-white text-gray-900 placeholder-gray-400 text-sm sm:text-base shadow-xl focus:outline-none focus:ring-2 focus:ring-amber-400 transition"
              />
              {searchQuery && (
                <button
                  onClick={() => setSearchQuery("")}
                  className="absolute right-4 text-xs font-semibold text-gray-400 hover:text-gray-600 bg-gray-100 hover:bg-gray-200 px-2 py-1 rounded-full"
                >
                  Clear
                </button>
              )}
            </div>
          </div>
        </div>
      </section>

      {/* 2. Category Filter Pills */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 -mt-6 relative z-20">
        <div className="bg-white rounded-2xl shadow-md border border-gray-100 p-2 sm:p-3 flex items-center gap-2 overflow-x-auto no-scrollbar">
          {categories.map((cat) => (
            <button
              key={cat}
              onClick={() => setSelectedCategory(cat)}
              className={`px-4 py-2 rounded-xl text-xs sm:text-sm font-semibold transition whitespace-nowrap cursor-pointer ${
                selectedCategory === cat
                  ? "bg-[#ae2b2b] text-white shadow-sm"
                  : "text-gray-600 hover:text-gray-900 hover:bg-gray-100"
              }`}
            >
              {cat}
            </button>
          ))}
        </div>
      </section>

      {/* 3. Main Content Area */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mt-12">
        {loading ? (
          <div className="py-24 text-center">
            <div className="inline-block animate-spin rounded-full h-10 w-10 border-4 border-[#ae2b2b] border-t-transparent mb-4" />
            <p className="text-gray-500 font-serif">Loading Articles...</p>
          </div>
        ) : filteredArticles.length === 0 ? (
          <div className="text-center py-20 bg-white rounded-3xl border border-gray-200 p-8 shadow-sm">
            <BookOpen className="h-12 w-12 text-gray-400 mx-auto mb-4" />
            <h3 className="text-xl font-bold text-gray-800 font-serif mb-2">
              No articles match your search
            </h3>
            <p className="text-gray-500 text-sm max-w-md mx-auto mb-6">
              Try searching with different terms or select "All" from the category filters.
            </p>
            <button
              onClick={() => {
                setSearchQuery("");
                setSelectedCategory("All");
              }}
              className="px-5 py-2.5 rounded-full bg-[#ae2b2b] text-white text-sm font-semibold hover:bg-[#8f1f1f] transition cursor-pointer"
            >
              Reset Filters
            </button>
          </div>
        ) : (
          <div className="space-y-12">
            {/* Featured Article Card (Large Spotlight) */}
            {featuredArticle && (
              <div className="bg-white rounded-3xl overflow-hidden border border-gray-100 shadow-lg hover:shadow-xl transition-all duration-300">
                <div className="grid grid-cols-1 lg:grid-cols-12 gap-0">
                  {/* Image column */}
                  <div className="lg:col-span-7 relative group overflow-hidden bg-gray-900 min-h-[300px] sm:min-h-[400px]">
                    <img
                      src={featuredArticle.cover_image || "/cover_mobile_20260204_092551_0000.png"}
                      alt={featuredArticle.title}
                      className="w-full h-full object-cover object-center group-hover:scale-105 transition-transform duration-500"
                    />
                    <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent lg:hidden" />
                    <div className="absolute top-4 left-4">
                      <span className="bg-[#ae2b2b] text-white text-xs font-bold uppercase tracking-wider px-3.5 py-1.5 rounded-full shadow-md">
                        Featured Publication
                      </span>
                    </div>
                  </div>

                  {/* Content column */}
                  <div className="lg:col-span-5 p-6 sm:p-10 flex flex-col justify-between bg-white">
                    <div>
                      {/* Category & Read Time */}
                      <div className="flex items-center gap-3 text-xs font-semibold text-gray-500 mb-3">
                        <span className="text-[#ae2b2b] font-bold uppercase tracking-wide">
                          {featuredArticle.category}
                        </span>
                        <span>•</span>
                        <span className="flex items-center gap-1">
                          <Clock className="h-3.5 w-3.5" />
                          {featuredArticle.read_time || "4 min read"}
                        </span>
                      </div>

                      {/* Title */}
                      <Link to={`/articles/${featuredArticle.slug}`}>
                        <h2 className="text-2xl sm:text-3xl font-serif font-bold text-gray-900 hover:text-[#ae2b2b] transition-colors leading-tight mb-4">
                          {featuredArticle.title}
                        </h2>
                      </Link>

                      {/* Excerpt */}
                      <p className="text-gray-600 text-sm sm:text-base leading-relaxed line-clamp-4 mb-6">
                        {featuredArticle.excerpt || featuredArticle.subtitle}
                      </p>

                      {/* Tags */}
                      {featuredArticle.tags && (
                        <div className="flex flex-wrap gap-1.5 mb-6">
                          {featuredArticle.tags.slice(0, 4).map((tag, idx) => (
                            <span
                              key={idx}
                              className="text-xs bg-gray-100 text-gray-600 px-2.5 py-1 rounded-md"
                            >
                              #{tag}
                            </span>
                          ))}
                        </div>
                      )}
                    </div>

                    {/* Author & CTA Button */}
                    <div className="pt-6 border-t border-gray-100 flex flex-wrap items-center justify-between gap-4">
                      <div className="flex items-center gap-3">
                        <div className="w-10 h-10 rounded-full bg-[#ae2b2b]/10 text-[#ae2b2b] flex items-center justify-center font-bold text-sm">
                          ILJ
                        </div>
                        <div>
                          <p className="text-xs font-bold text-gray-900">
                            {featuredArticle.author}
                          </p>
                          <p className="text-[11px] text-gray-500">
                            {new Date(featuredArticle.published_at).toLocaleDateString("en-US", {
                              month: "short",
                              day: "numeric",
                              year: "numeric"
                            })}
                          </p>
                        </div>
                      </div>

                      <Link
                        to={`/articles/${featuredArticle.slug}`}
                        className="inline-flex items-center gap-2 bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white px-5 py-2.5 rounded-full text-sm font-semibold transition-all shadow-md hover:shadow-lg transform hover:-translate-y-0.5"
                      >
                        Read Full Article
                        <ArrowRight className="h-4 w-4" />
                      </Link>
                    </div>
                  </div>
                </div>
              </div>
            )}

            {/* Regular Articles Grid */}
            {regularArticles.length > 0 && (
              <div>
                <h3 className="text-xl sm:text-2xl font-serif font-bold text-gray-900 mb-6 flex items-center gap-2">
                  <BookOpen className="h-5 w-5 text-[#ae2b2b]" />
                  More Articles
                </h3>

                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                  {regularArticles.map((article) => (
                    <article
                      key={article.id}
                      className="bg-white rounded-2xl overflow-hidden border border-gray-100 shadow-sm hover:shadow-lg transition-all duration-300 flex flex-col justify-between group"
                    >
                      <div>
                        {/* Thumbnail */}
                        <Link
                          to={`/articles/${article.slug}`}
                          className="block relative aspect-[16/9] overflow-hidden bg-gray-100"
                        >
                          <img
                            src={article.cover_image || "/cover_mobile_20260204_092551_0000.png"}
                            alt={article.title}
                            className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                          />
                          <span className="absolute top-3 left-3 bg-black/60 backdrop-blur-md text-white text-[11px] font-semibold px-2.5 py-1 rounded-full">
                            {article.category}
                          </span>
                        </Link>

                        {/* Text Content */}
                        <div className="p-6">
                          <div className="flex items-center gap-2 text-xs text-gray-400 mb-2">
                            <Clock className="h-3.5 w-3.5" />
                            <span>{article.read_time || "4 min read"}</span>
                          </div>

                          <Link to={`/articles/${article.slug}`}>
                            <h4 className="text-lg font-bold font-serif text-gray-900 hover:text-[#ae2b2b] transition leading-snug mb-2 line-clamp-2">
                              {article.title}
                            </h4>
                          </Link>

                          <p className="text-gray-600 text-xs sm:text-sm line-clamp-3 leading-relaxed mb-4">
                            {article.excerpt || article.subtitle}
                          </p>
                        </div>
                      </div>

                      {/* Footer Info */}
                      <div className="px-6 pb-6 pt-3 border-t border-gray-100 flex items-center justify-between text-xs text-gray-500">
                        <span className="font-medium text-gray-700">{article.author}</span>
                        <Link
                          to={`/articles/${article.slug}`}
                          className="text-[#ae2b2b] font-bold hover:underline inline-flex items-center gap-1"
                        >
                          Read <ArrowRight className="h-3.5 w-3.5" />
                        </Link>
                      </div>
                    </article>
                  ))}
                </div>
              </div>
            )}
          </div>
        )}

        {/* 4. Bottom Engagement & Ask Question CTA Card */}
        <div className="mt-16 bg-gradient-to-br from-[#ae2b2b] to-[#801b1b] rounded-3xl p-8 sm:p-12 text-white relative overflow-hidden shadow-xl">
          <div className="relative z-10 max-w-2xl">
            <span className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-white/10 text-amber-200 text-xs font-semibold uppercase tracking-wider mb-4 border border-white/15">
              <HelpCircle className="h-3.5 w-3.5" /> Engage & Reflect
            </span>
            <h3 className="text-2xl sm:text-3xl font-serif font-bold text-white mb-3">
              Have a Question About Jain Philosophy?
            </h3>
            <p className="text-white/80 text-sm sm:text-base leading-relaxed mb-6 font-serif">
              Our spiritual and research pod welcomes questions, curiosity, and sincere dialogue. Submit your query to get thoughtful, scripture-grounded answers.
            </p>
            <div className="flex flex-wrap gap-4">
              <Link
                to="/ask-question"
                className="bg-white text-[#ae2b2b] font-bold px-6 py-3 rounded-full text-sm shadow hover:bg-gray-100 transition transform hover:-translate-y-0.5"
              >
                Ask a Question
              </Link>
              <Link
                to="/volunteer-registration"
                className="bg-white/15 hover:bg-white/20 text-white font-semibold px-6 py-3 rounded-full text-sm border border-white/20 transition"
              >
                Join as Content Volunteer
              </Link>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
