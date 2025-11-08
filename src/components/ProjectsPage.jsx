import React, { useState, useRef } from "react";

const ProjectsPage = () => {
  const [selectedProject, setSelectedProject] = useState(null);
  const scrollContainerRef = useRef(null);

  const projects = [
    {
      id: 1,
      title: "Self-Defense Workshop",
      status: "Completed",
      description:
        "A safety and empowerment workshop for Jain girls and women, organized by I ❤️ Jinshasan.",
      date: "June 2025",
      image: "/images/selfdefense.jpg",
    },
    {
      id: 2,
      title: "The Sanskar Library",
      status: "Ongoing",
      description:
        "A community event encouraging donation and exchange of Jain religious books.",
      date: "April 2025",
      image: "/images/bookdrive.jpg",
    },
    {
      id: 3,
      title: "Jainism - A Scientific Lens",
      status: "Completed",
      description:
        "A 6-week Sunday series focused on self-awareness and spiritual connection.",
      date: "July–August 2025",
      image: "/images/shibir.jpg",
    },
    {
      id: 4,
      title: "Spiritual Shibir Series",
      status: "Completed",
      description:
        "A 6-week Sunday series focused on self-awareness and spiritual connection.",
      date: "July–August 2025",
      image: "../assets/MainBanner.jpeg",
    },
    {
      id: 5,
      title: "Youth Awareness Drive",
      status: "Ongoing",
      description:
        "An initiative to spread spiritual awareness and compassion among youth.",
      date: "September 2025",
      image: "../assets/MainBanner.jpeg",
    },
    {
      id: 6,
      title: "Eco Living Camp",
      status: "Completed",
      description:
        "A weekend camp promoting mindful and eco-friendly living through Jain principles.",
      date: "October 2025",
      image: "../assets/MainBanner.jpeg",
    },
  ];

  // Function to scroll smoothly left/right
  const scroll = (direction) => {
    const container = scrollContainerRef.current;
    if (!container) return;

    const scrollAmount = container.offsetWidth * 0.9; // scroll by ~90% width
    container.scrollBy({
      left: direction === "left" ? -scrollAmount : scrollAmount,
      behavior: "smooth",
    });
  };

  return (
    <div className="font-serif relative" style={{ padding: "20px" }}>
      {/* Heading */}
      <h1
        className="font-serif text-[28px] font-bold text-left"
        style={{ color: "#ae2b2b", margin: "0px 0px 20px 10px" }}
      >
        Projects
      </h1>

      {/* Scrollable Project Cards */}
      <div className="relative group no-scrollbar">
        {/* Left Scroll Button */}
        <button
          onClick={() => scroll("left")}
          className="hidden md:flex items-center justify-center absolute left-0 top-1/2 -translate-y-1/2 bg-[#ae2b2b] text-white w-10 h-10 rounded-full opacity-0 group-hover:opacity-90 transition-all duration-300 shadow-md hover:scale-110 z-10"
        >
          ‹
        </button>

        {/* Scroll Container */}
        <div
          ref={scrollContainerRef}
          className="flex gap-4 overflow-x-auto px-4 py-2 mx-auto snap-x snap-mandatory no-scrollbar"
          style={{
            scrollBehavior: "smooth",
            WebkitOverflowScrolling: "touch",
          }}
        >
          {projects.map((project) => (
            <div
              key={project.id}
              onClick={() => setSelectedProject(project)}
              className="
                snap-start flex-shrink-0 bg-white shadow-md rounded-2xl overflow-hidden
                hover:shadow-xl transition-transform transform hover:-translate-y-1 cursor-pointer
                w-[90%] sm:w-[48%] md:w-[32%] lg:w-[23%]
              "
            >
              {project.image && (
                <img
                  src={project.image}
                  alt={project.title}
                  className="h-48 w-full object-cover"
                />
              )}
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

      {/* Project Detail Modal */}
      {selectedProject && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-2xl shadow-lg max-w-lg w-full p-6 relative">
            <button
              onClick={() => setSelectedProject(null)}
              className="absolute top-3 right-3 text-gray-500 hover:text-gray-700 text-xl"
            >
              ×
            </button>

            {selectedProject.image && (
              <img
                src={selectedProject.image}
                alt={selectedProject.title}
                className="h-56 w-full object-cover rounded-lg mb-4"
              />
            )}
            <h2
              className="text-2xl font-bold mb-2"
              style={{ color: "#ae2b2b" }}
            >
              {selectedProject.title}
            </h2>
            <p className="text-sm text-gray-500 mb-2">
              {selectedProject.date}
            </p>
            <p className="text-gray-700 leading-relaxed">
              {selectedProject.description}
            </p>
            <p
              className={`mt-4 inline-block px-3 py-1 text-xs font-medium rounded-full ${
                selectedProject.status === "Ongoing"
                  ? "bg-green-100 text-green-700"
                  : "bg-gray-200 text-gray-600"
              }`}
            >
              {selectedProject.status}
            </p>
          </div>
        </div>
      )}
    </div>
  );
};

export default ProjectsPage;
