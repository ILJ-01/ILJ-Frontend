import React, { useRef } from "react"
import projects from "../data/projects-minimal.json";
import {useNavigate} from "react-router";

// 1️⃣ Auto-import all images from the projects folder
const projectImages = import.meta.glob(
  "../assets/projects/*.{png,jpg,jpeg,webp}",
  { eager: true }
);

// 2️⃣ Utility function to get correct image path
const getImage = (fileName) => {
  const path = `../assets/projects/${fileName}`;
  return projectImages[path]?.default || "";
};

const Projects = () => {
  const navigate = useNavigate();
  const scrollContainerRef = useRef(null);

  // Scroll function
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
    <div className="font-serif relative" style={{ padding: "20px" }}>
      <h1
        className="font-serif text-[28px] font-bold text-left"
        style={{ color: "#ae2b2b", margin: "0px 0px 20px 10px" }}
      >
        Projects
      </h1>

      <div className="relative group no-scrollbar">
        {/* Left Scroll Button */}
        <button
          onClick={() => scroll("left")}
          className="hidden md:flex items-center justify-center absolute left-0 top-1/2 -translate-y-1/2 bg-[#ae2b2b] text-white w-10 h-10 rounded-full opacity-0 group-hover:opacity-90 transition-all duration-300 shadow-md hover:scale-110 z-10"
        >
          ‹
        </button>

        {/* Cards Container */}
        <div
          ref={scrollContainerRef}
          className="flex gap-4 overflow-x-auto px-4 py-2 mx-auto snap-x snap-mandatory no-scrollbar"
        >
          {projects.map((project) => (
            <div
              key={project.id}
              onClick={() => navigate(`/project/${project.title}`)}
              className="
                snap-start shrink-0 bg-white shadow-md rounded-2xl overflow-hidden
                hover:shadow-xl transition-transform transform hover:-translate-y-1 cursor-pointer
                w-[90%] sm:w-[48%] md:w-[32%] lg:w-[23%]
              "
            >
              {/* 4️⃣ Load image automatically */}
              <img
                src={getImage(project.image)}
                alt={project.title}
                className="h-48 w-full object-cover"
              />

              <div className="p-4">
                <h2
                  className="text-xl font-semibold mb-1 truncate"
                  style={{ color: "#ae2b2b" }}
                >
                  {project.title}
                </h2>
                <p className="text-gray-600 text-sm line-clamp-3">
                  {project.description}
                </p>
                <p
                  className={`mt-3 inline-block px-3 py-1 text-xs font-medium rounded-full ${
                    project.status === "Ongoing"
                      ? "bg-green-100 text-green-700"
                      : "bg-gray-200 text-gray-600"
                  }`}
                >
                  {project.status}
                </p>
              </div>
            </div>
          ))}
        </div>

        {/* Right Scroll Button */}
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

export default Projects;
