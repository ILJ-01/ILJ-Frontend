import React, { useRef } from "react";
import { ChevronLeft, ChevronRight } from "lucide-react";

const InstagramReels = () => {
  const scrollContainerRef = useRef(null);

  const reelLinks = [
    "https://www.instagram.com/ilovejinshasan/reel/DUYPm0yjkQx/",
    "https://www.instagram.com/reel/DSKisFAjDe1/",
    "https://www.instagram.com/reel/DTNhc7UjAm9/",
    "https://www.instagram.com/reel/DSfJEvXDNQo/",
    "https://www.instagram.com/reel/DTkw94_DPv5/",
    "https://www.instagram.com/reel/DR7F-TTDEYz/",
    "https://www.instagram.com/reel/DR4hHQ6DEfO/",
    "https://www.instagram.com/reel/DUMnlARDB5q/",
    "https://www.instagram.com/reel/DSNHcy3jOq8/",
    "https://www.instagram.com/reel/DRpCqdMDI92/"
  ];

  // Extract reel code from URL
  const extractCode = (url) => {
    if (!url) return null;
    const match = url.match(/\/reel\/([^\/]+)/) || url.match(/\/p\/([^\/]+)/);
    return match ? match[1] : null;
  };

  const scroll = (direction) => {
    const container = scrollContainerRef.current;
    if (!container) return;

    const scrollAmount = container.offsetWidth * 0.9;
    container.scrollBy({
      left: direction === "left" ? -scrollAmount : scrollAmount,
      behavior: "smooth",
    });
  };

  return (
    <div className="font-serif relative px-5 py-10 max-w-7xl mx-auto">

      <h2
        className="text-3xl font-bold text-center mb-10 text-[#ae2b2b]"
      >
        Follow Us on Instagram
      </h2>

      <div className="relative group">

        {/* Left Button */}
        <button
          onClick={() => scroll("left")}
          className="hidden md:flex items-center justify-center absolute -left-5 top-1/2 -translate-y-1/2 
          bg-white text-[#ae2b2b] w-12 h-12 rounded-full shadow-lg border border-gray-100
          hover:bg-[#ae2b2b] hover:text-white transition-all duration-300 z-10"
        >
          <ChevronLeft className="h-6 w-6" />
        </button>

        {/* Scroll Container */}
        <div
          ref={scrollContainerRef}
          className="flex gap-6 overflow-x-auto px-4 py-4 snap-x snap-mandatory scroll-smooth no-scrollbar"
          style={{ scrollbarWidth: 'none', msOverflowStyle: 'none' }}
        >
          {reelLinks.map((url, index) => {
            const code = extractCode(url);
            if (!code) return null;

            return (
              <div
                key={index}
                className="
                    snap-center flex-shrink-0 bg-white shadow-lg rounded-2xl overflow-hidden
                    hover:shadow-2xl transition-all duration-300 hover:-translate-y-2
                    w-[85vw] sm:w-[350px]
                    border border-gray-100
                  "
              >
                <div className="relative w-full pt-[177.77%] bg-gray-100">
                  <iframe
                    src={`https://www.instagram.com/reel/${code}/embed`}
                    className="absolute top-0 left-0 w-full h-full"
                    frameBorder="0"
                    scrolling="no"
                    allow="autoplay; clipboard-write; encrypted-media; picture-in-picture; web-share"
                  ></iframe>
                </div>
              </div>
            );
          })}
        </div>

        {/* Right Button */}
        <button
          onClick={() => scroll("right")}
          className="hidden md:flex items-center justify-center absolute -right-5 top-1/2 -translate-y-1/2 
          bg-white text-[#ae2b2b] w-12 h-12 rounded-full shadow-lg border border-gray-100
          hover:bg-[#ae2b2b] hover:text-white transition-all duration-300 z-10"
        >
          <ChevronRight className="h-6 w-6" />
        </button>

      </div>
    </div>
  );
};

export default InstagramReels;
