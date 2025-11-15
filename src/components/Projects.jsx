import React, { useState, useRef } from "react";

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
  const [selectedProject, setSelectedProject] = useState(null);
  const scrollContainerRef = useRef(null);

  // 3️⃣ Use ONLY file names for image
  const projects = [
    {
      id: 1,
      title: "Veer Vanshaj",
      status: "Completed",
      description:
        "The Veer Vanshaj - Self Defence Workshop empowers individuals, especially women, with the skills and confidence to protect themselves in any situation. The initiative offers practical self-defence training, focusing on building physical strength, awareness, and mental resilience. Launched with the aim of ensuring safety and independence, the workshops have already gained momentum with multiple successful sessions. Our future vision includes expanding this impactful program across Mumbai, reaching more individuals in need of self-defence training.",
      date: "June 2025",
      image: "VeerVansaj.jpeg",
    },
    {
      id: 2,
      title: "The Sanskar Library",
      status: "Ongoing",
      description:
        "The Sanskaar Library is an initiative designed to nurture reading habits and instill moral values in children through curated books. By creating a rotating library system that promotes morals, ethics, principles of Jainism and personal growth, we aim to build a foundation of knowledge and integrity among the younger generation. Currently, the library operates in several pathshalas (religious schools) in Dombivli, with over 200 books available for circulation. We are committed to expanding the library across Mumbai, providing more children with access to inspirational and educational resources.",
      date: "April 2025",
      image: "SanskarLibrary.jpeg",
    },
    {
      id: 3,
      title: "Jainism - A Scientific Lens",
      status: "Completed",
      description:
        "Jainism: A Scientific Lens is an innovative exhibition designed to explore the intersection of ancient Jain principles and modern science. The exhibition features interactive models, charts, and experiments that demonstrate the compatibility of Jain teachings with scientific concepts like E=MC², Theory of Evolution, Sustainability, and Law of Attraction. After the successful launch of the first exhibition in Dombivli, we are now expanding to other cities to further engage the public and promote awareness of Jainism’s relevance in the modern world.",
      date: "July–August 2025",
      image: "ScientificLens.jpeg",
    },
    {
      id: 4,
      title: "Spiritual Shibir Series",
      status: "Completed",
      description:
        "A 6-week Sunday series focused on self-awareness and spiritual connection.",
      date: "July–August 2025",
      image: "Shibir.jpeg",
    },
    {
      id: 5,
      title: "Promotion of Jainism on Social Media",
      status: "Ongoing",
      description:
        "We are committed to spreading the timeless wisdom of Jainism through modern channels. Our Promotion of Jainism on Social Media, primarily through the Instagram page @ilovejinshasan, seeks to inspire a global audience by highlighting the profound values and principles of Jain philosophy. Through engaging content such as the Veer Gatha Series, Festive Series, Veer Vigyan Series, we aim to promote awareness and foster a deeper connection to Jainism. With plans for future series covering topics like Anekantvad, our social media presence is steadily growing, empowering individuals to embrace teachings if Jainism in everyday life.",
      date: "September 2025",
      image: "Jainism_SocialMedia.jpeg",
    },
    
  ];

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
              onClick={() => setSelectedProject(project)}
              className="
                snap-start flex-shrink-0 bg-white shadow-md rounded-2xl overflow-hidden
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

            <img
              src={getImage(selectedProject.image)}
              alt={selectedProject.title}
              className="h-56 w-full object-cover rounded-lg mb-4"
            />

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

export default Projects;
