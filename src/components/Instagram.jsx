import React, { useRef, useEffect, useState } from "react";

const Instagram = () => {
  const scrollContainerRef = useRef(null);
  const [scriptLoaded, setScriptLoaded] = useState(false);

  const reels = [
    "https://www.instagram.com/reel/DQrRS-_DHdp/",
    "https://www.instagram.com/reel/DQWpQozDO0x/",
    "https://www.instagram.com/reel/DP85PjnDPn-/",
    "https://www.instagram.com/reel/DQrRS-_DHdp/",
  ];

  // Smooth scroll left/right
  const scroll = (direction) => {
    const container = scrollContainerRef.current;
    if (!container) return;

    const scrollAmount = container.offsetWidth * 0.9;
    container.scrollBy({
      left: direction === "left" ? -scrollAmount : scrollAmount,
      behavior: "smooth",
    });
  };

  // Load Instagram embed script once
  useEffect(() => {
    if (window.instgrm) {
      setScriptLoaded(true);
      window.instgrm.Embeds.process();
      return;
    }

    const script = document.createElement("script");
    script.src = "https://www.instagram.com/embed.js";
    script.async = true;
    script.defer = true;
    script.onload = () => {
      setScriptLoaded(true);
      if (window.instgrm?.Embeds?.process) window.instgrm.Embeds.process();
    };
    document.body.appendChild(script);
  }, []);

  // Reprocess embeds when script loaded
  useEffect(() => {
    if (scriptLoaded && window.instgrm?.Embeds?.process) {
      window.instgrm.Embeds.process();
    }
  }, [scriptLoaded]);

  return (
    <div className="font-serif relative px-5 py-10">
      {/* Heading */}
      <h1
        className="font-serif text-[28px] font-bold text-left"
        style={{ color: "#ae2b2b", margin: "0px 0px 20px 10px" }}
      >
        Latest Instagram Reels
      </h1>

      {/* Scrollable Reels */}
      <div className="relative group no-scrollbar">
        {/* Left Button */}
        <button
          onClick={() => scroll("left")}
          className="hidden md:flex items-center justify-center absolute left-0 top-1/2 -translate-y-1/2 bg-[#ae2b2b] text-white w-10 h-10 rounded-full opacity-0 group-hover:opacity-90 transition-all duration-300 shadow-md hover:scale-110 z-10"
        >
          ‹
        </button>

        {/* Reels Container */}
        <div
          ref={scrollContainerRef}
          className="grid gap-4 overflow-x-auto px-4 py-2 mx-auto snap-x snap-mandatory no-scrollbar"
          style={{
            scrollBehavior: "smooth",
            WebkitOverflowScrolling: "touch",
          }}
        >
          {reels.map((url, index) => (
            <div
              key={index}
              className="
                 snap-start flex-shrink-0 bg-white shadow-md rounded-2xl 
                hover:shadow-xl transition-transform transform hover:-translate-y-1 cursor-pointer
                w-[90%] sm:w-[48%] md:w-[32%] lg:w-[23%]
              "
            >
              <blockquote
                className="instagram-media m-0"
                data-instgrm-permalink={url}
                data-instgrm-version="14"
                style={{
                  background: "transparent",
                  border: "none",
                  width: "100%",
                  minHeight: "400px",
                }}
              >
                <a href={url} target="_blank" rel="noopener noreferrer"></a>
              </blockquote>
            </div>
          ))}
        </div>

        {/* Right Button */}
        <button
          onClick={() => scroll("right")}
          className="hidden md:flex items-center justify-center absolute right-0 top-1/2 -translate-y-1/2 bg-[#ae2b2b] text-white w-10 h-10 rounded-full opacity-0 group-hover:opacity-90 transition-all duration-300 shadow-md hover:scale-110 z-10"
        >
          ›
        </button>
      </div>
    </div>
  );
};

export default Instagram;
