import React, { useState } from "react";

const ProjectsPage = () => {
  const [selectedProject, setSelectedProject] = useState(null);

  // Example projects — replace with API data later if needed
  const projects = [
    {
      id: 1,
      title: "Self-Defense Workshop",
      status: "Ongoing",
      description:
        "A safety and empowerment workshop for Jain girls and women, organized by I ❤️ Jinshasan.",
      date: "June 2025",
      image: "/images/selfdefense.jpg",
    },
    {
      id: 2,
      title: "The Sanskar Library",
      status: "Completed",
      description:
        "A community event encouraging donation and exchange of Jain religious books.",
      date: "April 2025",
      image: "/images/bookdrive.jpg",
    },
    {
      id: 3,
      title: "Jainism - A Scientific Lens",
      status: "Ongoing",
      description:
        "A 6-week Sunday series focused on self-awareness and spiritual connection.",
      date: "July–August 2025",
      image: "/images/shibir.jpg",
    },
    {
      id: 4,
      title: "Spiritual Shibir Series",
      status: "Ongoing",
      description:
        "A 6-week Sunday series focused on self-awareness and spiritual connection.",
      date: "July–August 2025",
      image: "../assets/MainBanner.jpeg",
    },
  ];

  return (
    <div className=" font-serif " style={{ padding: "20px"}}>
      {/* Heading */}
      <h1
        className="font-serif text-[28px] font-bold text-left "
        style={{ color: "#ae2b2b" , margin: "0px 0px 20px 10px"}}
      >
        Projects
      </h1>

      {/* Project Grid */}
      <div className="flex overflow-x-auto justify-center gap-8 grid grid-cols-4 mx-auto" style={{ padding: "20px"}}>
        {projects.map((project) => (
          <div
            key={project.id}
            onClick={() => setSelectedProject(project)}
            className="cursor-pointer bg-white shadow-md rounded-2xl overflow-hidden hover:shadow-xl transition-transform transform hover:-translate-y-1"
            style={{ padding: "10px"}}
          >
            {project.image && (
              <img
                src={project.image}
                alt={project.title}
                className="h-48 w-full object-cover"
              />
            )}
            <div className="p-4" style={{ padding: "15px 15px"}}>
              <h2
                className="text-xl truncate font-semibold mb-2"
                style={{ color: "#ae2b2b" }}
              >
                {project.title}
              </h2>
              <p className="text-gray-600 truncate text-sm line-clamp-3">
                {project.description}
              </p>
              <p
                className={`absolute mt-3 inline-block px-3 py-1 text-xs font-medium rounded-full ${
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

      {/* Project Detail Modal */}
      {selectedProject && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-2xl shadow-lg max-w-lg w-full p-6 relative">
            {/* Close Button */}
            <button
              onClick={() => setSelectedProject(null)}
              className="absolute top-3 right-3 text-gray-500 hover:text-gray-700 text-xl"
            >
              ×
            </button>

            {/* Modal Content */}
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
