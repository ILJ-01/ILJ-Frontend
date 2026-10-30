import { Link } from "react-router-dom";
import { SOURCES } from "@/data/sourceData";
import {
  Scroll,
  BookOpen,
  ArrowRight,
  Sparkles,
  Layers,
  HelpCircle,
  ShieldCheck,
  CheckCircle2
} from "lucide-react";

export default function SourcesIndexPage() {
  return (
    <div className="min-h-screen bg-gradient-to-b from-[#fcf9f8] via-[#faf6f5] to-white py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-6xl mx-auto space-y-12">
        
        {/* Hero Section */}
        <div className="text-center max-w-3xl mx-auto space-y-4">
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-[#ae2b2b]/10 text-[#ae2b2b] text-xs font-bold tracking-widest uppercase shadow-xs">
            <Scroll className="h-3.5 w-3.5" />
            Shastriya Praman • आगम प्रमाण
          </div>

          <h1 className="text-3xl sm:text-5xl font-bold text-gray-900 font-serif tracking-tight leading-tight">
            Original Scriptural Sources
          </h1>

          <p className="text-base sm:text-lg text-gray-600 font-serif leading-relaxed">
            Authentic Agam verses, original manuscripts, and commentary proving core Jain spiritual and scientific principles.
          </p>

          <p className="text-xs sm:text-sm text-gray-500">
            Scanned directly from authentic classical editions of Shree Tatvarth Sutra & Shree Uttaradhyayan Sutra.
          </p>
        </div>

        {/* 5 Source Cards Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {SOURCES.map((source, index) => (
            <Link
              key={source.id}
              to={`/source/${source.slug}`}
              className="bg-white rounded-3xl overflow-hidden border border-gray-200 hover:border-[#ae2b2b]/50 shadow-md hover:shadow-xl transition-all duration-300 flex flex-col group hover:-translate-y-1"
            >
              {/* Card Thumbnail Area */}
              <div className="relative h-56 bg-gray-900/5 overflow-hidden flex items-center justify-center p-3 border-b border-gray-100">
                {source.images && source.images.length > 0 ? (
                  <img
                    src={source.images[0].url}
                    alt={source.title}
                    className="h-full w-auto object-contain rounded-lg shadow-sm group-hover:scale-105 transition-transform duration-300"
                  />
                ) : (
                  <div className="h-full w-full flex items-center justify-center text-[#ae2b2b]/30">
                    <BookOpen className="h-16 w-16" />
                  </div>
                )}
                <div className="absolute top-3 left-3 bg-[#ae2b2b] text-white text-[10px] font-bold uppercase tracking-wider px-2.5 py-1 rounded-full shadow-sm">
                  Exhibit 0{index + 1}
                </div>
                {source.images && source.images.length > 1 && (
                  <div className="absolute top-3 right-3 bg-black/75 backdrop-blur-xs text-white text-[10px] font-bold px-2 py-0.5 rounded-md flex items-center gap-1">
                    <Layers className="h-3 w-3" />
                    {source.images.length} Pages
                  </div>
                )}
              </div>

              {/* Card Body */}
              <div className="p-6 flex-1 flex flex-col justify-between space-y-4">
                <div className="space-y-2">
                  <span className="text-[11px] font-bold uppercase tracking-wider text-[#ae2b2b]">
                    {source.topic}
                  </span>
                  <h3 className="text-xl font-bold text-gray-900 font-serif group-hover:text-[#ae2b2b] transition-colors leading-snug">
                    {source.title}
                  </h3>

                  <div className="p-3 rounded-xl bg-amber-50/60 border border-amber-200/60 text-xs">
                    <strong className="block font-serif text-[#ae2b2b] text-sm">
                      {source.scriptureHindi}
                    </strong>
                    <span className="text-gray-600 font-medium">
                      {source.scriptureEnglish}
                    </span>
                  </div>

                  <p className="text-xs text-gray-500 line-clamp-3 leading-relaxed">
                    {source.shortSummary}
                  </p>
                </div>

                <div className="pt-4 border-t border-gray-100 flex items-center justify-between text-xs font-bold text-[#ae2b2b]">
                  <span>View Source & Manuscript</span>
                  <ArrowRight className="h-4 w-4 group-hover:translate-x-1 transition-transform" />
                </div>
              </div>
            </Link>
          ))}
        </div>

        {/* Bottom Banner */}
        <div className="bg-gradient-to-br from-[#5c1212] via-[#8f1f1f] to-[#ae2b2b] rounded-3xl p-8 text-white shadow-xl flex flex-col sm:flex-row items-center justify-between gap-6">
          <div className="space-y-2 text-center sm:text-left">
            <h3 className="text-2xl font-bold font-serif">
              Have Questions Regarding Any Scriptural Source?
            </h3>
            <p className="text-sm text-red-100 max-w-xl">
              Submit your doubts through our Q&A portal and receive answers directly from our scholars with a private conversation link.
            </p>
          </div>

          <Link
            to="/ask-question"
            className="px-6 py-3.5 rounded-xl bg-white text-[#ae2b2b] font-bold text-sm shadow-md hover:bg-gray-100 transition whitespace-nowrap"
          >
            Ask a Question
          </Link>
        </div>

      </div>
    </div>
  );
}
