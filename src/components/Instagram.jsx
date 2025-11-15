import React, { useRef } from "react";

const InstagramReels = () => {
  const scrollContainerRef = useRef(null);

  // Just paste reel links here (newest first)
  const reelLinks = [
    "https://www.instagram.com/reel/DRChmRwDAUA/",
    "https://www.instagram.com/reel/DQwpP6uDNmZ/",
    "https://www.instagram.com/reel/DQWpQozDO0x/",
    "https://www.instagram.com/reel/DP85PjnDPn-/",
    "https://www.instagram.com/reel/DQrRS-_DHdp/",
  ];

  // Extract reel code from URL
  const extractCode = (url) => {
    const match = url.match(/\/reel\/([^\/]+)/);
    return match ? match[1] : null;
  };

  const scroll = (direction) => {
    const container = scrollContainerRef.current;
    if (!container) return;

    container.scrollBy({
      left: direction === "left" ? -container.offsetWidth * 0.9 : container.offsetWidth * 0.9,
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
          {reelLinks.map((url, index) => {
            const code = extractCode(url);
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
          })}
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
