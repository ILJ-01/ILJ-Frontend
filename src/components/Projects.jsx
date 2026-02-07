import React, { useRef, useState, useEffect } from "react";
import { useNavigate } from "react-router";
import { supabase } from "../lib/supabase";
// Import fallback data
import fallbackProjects from "../data/projects-minimal.json";

// 1️⃣ Auto-import all images from the projects folder (Fallback mechanism)
const projectImages = import.meta.glob(
  "../assets/projects/*.{png,jpg,jpeg,webp}",
  { eager: true }
);

// 2️⃣ Utility function to get correct image path
const getImage = (fileName) => {
  // If fileName is an absolute URL (from Supabase), return it directly
  if (fileName && (fileName.startsWith("http") || fileName.startsWith("data:"))) {
    return fileName;
  }
  const path = `../assets/projects/${fileName}`;
  return projectImages[path]?.default || "";
};

const Projects = () => {
  const navigate = useNavigate();
  const scrollContainerRef = useRef(null);
  const [projectsData, setProjectsData] = useState([]);
  const [loading, setLoading] = useState(true);

  // Fetch Projects from Supabase
  useEffect(() => {
    const fetchProjects = async () => {
      try {
        const { data, error } = await supabase
          .from("projects")
          .select("*");

        if (error) {
          console.error("Error fetching projects:", error);
          // Fallback
          setProjectsData(fallbackProjects);
        } else if (data && data.length > 0) {
          // Filter out private projects for homepage
          let visibleProjects = data.filter(p => p.visibility !== 'private');

          // Define the custom order
          const customOrder = [
            "Veer Vanshaj: Self Defence Workshop",
            "Sanskaar Library",
            "Jainific",
            "Digital Jainism",
            "Blogs",
            "Website Development"
          ];

          // Sort the data based on the custom order
          const sortedData = visibleProjects.sort((a, b) => {
            const indexA = customOrder.indexOf(a.title);
            const indexB = customOrder.indexOf(b.title);

            // If both are in the list, sort by their index
            if (indexA !== -1 && indexB !== -1) {
              return indexA - indexB;
            }

            // If only A is in the list, it comes first
            if (indexA !== -1) return -1;

            // If only B is in the list, it comes first
            if (indexB !== -1) return 1;

            // If neither is in the list, keep original order (or sort by created_at if needed, 
            // but currently we just returned via select("*"))
            return 0;
          });

          setProjectsData(sortedData);
        } else {
          // Empty data from DB
          setProjectsData(fallbackProjects);
        }
      } catch (err) {
        console.error("Unexpected error fetching projects:", err);
        setProjectsData(fallbackProjects);
      } finally {
        setLoading(false);
      }
    };

    fetchProjects();
  }, []);

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

  if (loading) {
    return <div className="py-10 text-center text-gray-500 font-serif">Loading Projects...</div>;
  }

  return (
    <div className="font-serif relative" style={{ padding: "20px" }}>
      <h1
        className="font-serif text-[28px] font-bold text-left"
        style={{ color: "#ae2b2b", margin: "0px 0px 20px 10px" }}
      >
        Our Projects
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
          {projectsData.map((project) => (
            <div
              key={project.id}
              onClick={() => {
                // Determine navigation path:
                // If it has 'created_at' (Supabase), use ID (UUID).
                // Otherwise (Static JSON), use Title.
                const navId = project.created_at ? project.id : project.title;
                navigate(`/project/${navId}`);
              }}
              className="
                snap-start shrink-0 bg-white shadow-md rounded-2xl overflow-hidden
                hover:shadow-xl transition-transform transform hover:-translate-y-1 cursor-pointer
                w-[90%] sm:w-[48%] md:w-[32%] lg:w-[23%]
              "
            >
              {/* 4️⃣ Load image automatically */}
              <img
                src={project.banner_url || getImage(project.image)}
                alt={project.title}
                className="h-48 w-full object-cover"
                onError={(e) => {
                  // Fallback if image fails to load
                  e.target.src = "https://via.placeholder.com/400x300?text=ILJ+Project";
                }}
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
                <div className="flex gap-2 mt-3">
                  <span
                    className={`inline-block px-3 py-1 text-xs font-medium rounded-full ${project.status === "active" || project.status === "Ongoing"
                      ? "bg-green-100 text-green-700"
                      : "bg-gray-200 text-gray-600"
                      }`}
                  >
                    {project.status.toUpperCase()}
                  </span>
                </div>
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
