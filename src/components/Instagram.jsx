import React, { useRef, useState, useEffect } from "react";
import { supabase } from "../lib/supabase";

const InstagramReels = () => {
  const scrollContainerRef = useRef(null);
  const [reelLinks, setReelLinks] = useState([]);
  const [loading, setLoading] = useState(true);

  // 1. Fallback Static Links (Used if API & DB fail)
  const fallbackReelLinks = [
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


  useEffect(() => {
    const fetchReels = async () => {
      setLoading(true);
      const accessToken = import.meta.env.VITE_INSTAGRAM_ACCESS_TOKEN;

      // STRATEGY 1: Try Instagram API (Most "Automatic")
      if (accessToken) {
        try {
          // Fetch media from Instagram Graph API
          const response = await fetch(
            `https://graph.instagram.com/me/media?fields=id,media_type,media_url,permalink,thumbnail_url&access_token=${accessToken}`
          );

          if (!response.ok) throw new Error("Instagram API request failed");

          const data = await response.json();

          // Filter for Reels/Videos
          // Note: 'media_type' is usually VIDEO for reels. 
          // We map 'permalink' because our embed logic uses the post URL.
          const apiReels = data.data
            .filter(item => item.media_type === 'VIDEO')
            .map(item => item.permalink);

          if (apiReels.length > 0) {
            setReelLinks(apiReels);
            setLoading(false);
            return; // Success!
          }
        } catch (err) {
          console.warn("Instagram API fetch failed:", err);
          // Continue to Strategy 2...
        }
      } else {
        console.log("No VITE_INSTAGRAM_ACCESS_TOKEN found. Skipping API fetch.");
        console.log("To enable Instagram API fetching, please set VITE_INSTAGRAM_ACCESS_TOKEN in your .env file.");
        console.log("You can generate a long-lived access token from Facebook Developer Console.");
      }

      // STRATEGY 2: Try Supabase Database (Dynamic Manual Entry)
      try {
        const { data, error } = await supabase
          .from("instagram_reels")
          .select("url")
          .eq('is_active', true)
          .order("created_at", { ascending: false });

        if (!error && data && data.length > 0) {
          const dbUrls = data.map(item => item.url);
          setReelLinks(dbUrls);
          setLoading(false);
          return;
        }
      } catch (err) {
        console.error("Supabase fetch error:", err);
      }

      // STRATEGY 3: Fallback (Static)
      setReelLinks(fallbackReelLinks);
      setLoading(false);
    };

    fetchReels();
  }, []);

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
    <div className="font-serif relative px-5 py-10">

      <h1
        className="font-serif text-[28px] font-bold text-left mb-5"
        style={{ color: "#ae2b2b" }}
      >
        Instagram Reels
      </h1>

      <div className="relative group no-scrollbar">

        {/* Left Button */}
        <button
          onClick={() => scroll("left")}
          className="hidden md:flex items-center justify-center absolute left-0 top-1/2 -translate-y-1/2 
          bg-[#ae2b2b] text-white w-10 h-10 rounded-full opacity-0 group-hover:opacity-90 
          transition-all duration-300 shadow-md hover:scale-110 z-10"
        >
          ‹
        </button>

        {/* Scroll Container */}
        <div
          ref={scrollContainerRef}
          className="flex gap-4 overflow-x-auto px-4 py-2 mx-auto snap-x snap-mandatory no-scrollbar"
        >
          {loading ? (
            // Skeleton Loaders
            [1, 2, 3, 4].map((n) => (
              <div key={n} className="flex-shrink-0 w-[90%] sm:w-[48%] md:w-[32%] lg:w-[23%] h-[550px] bg-gray-200 animate-pulse rounded-2xl"></div>
            ))
          ) : (
            reelLinks.map((url, index) => {
              const code = extractCode(url);
              if (!code) return null;

              return (
                <div
                  key={index}
                  className="
                    snap-start flex-shrink-0 bg-white shadow-md rounded-2xl overflow-hidden
                    hover:shadow-xl transition-transform hover:-translate-y-1 cursor-pointer
                    w-[90%] sm:w-[48%] md:w-[32%] lg:w-[23%]
                  "
                >
                  <iframe
                    src={`https://www.instagram.com/reel/${code}/embed`}
                    className="w-full h-[550px] rounded-xl"
                    frameBorder="0"
                    scrolling="no"
                    allow="autoplay; encrypted-media; fullscreen; picture-in-picture"
                  ></iframe>
                </div>
              );
            })
          )}
        </div>

        {/* Right Button */}
        <button
          onClick={() => scroll("right")}
          className="hidden md:flex items-center justify-center absolute right-0 top-1/2 -translate-y-1/2 
          bg-[#ae2b2b] text-white w-10 h-10 rounded-full opacity-0 group-hover:opacity-90 
          transition-all duration-300 shadow-md hover:scale-110 z-10"
        >
          ›
        </button>

      </div>
    </div>
  );
};

export default InstagramReels;
