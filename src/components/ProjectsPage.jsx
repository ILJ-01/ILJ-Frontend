import React from "react";
import projects from "../data/projects.json";
import {useNavigate} from "react-router";

// =============================
// 1️⃣ Auto-load thumbnails
// =============================
const projectThumbs = import.meta.glob(
  "../assets/projects/*.{png,jpg,jpeg,webp}",
  {eager: true}
);

const getThumb = (fileName) => {
  const path = `../assets/projects/${fileName}`;
  return projectThumbs[path]?.default || "";
};

const ProjectsPage = () => {
  const navigate = useNavigate();

  // =============================
  // 5️⃣ PROJECT GRID VIEW
  // =============================
  return (
    <div className="px-6 py-10 font-serif">
      <h1 className="text-4xl font-bold text-[#ae2b2b] mb-6">
        Our Projects
      </h1>

      <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-8">
        {projects.map((project) => {
          const thumb = getThumb(project.image);

          return (
            <div
              key={project.id}
              onClick={() => navigate(`/project/${project.id}`)}
              className="bg-white rounded-2xl shadow-md hover:shadow-xl transition cursor-pointer"
            >
              <img
                src={thumb}
                className="w-full h-48 object-cover rounded-t-2xl"
                alt={project.title}
              />

              <div className="p-5">
                <h2 className="text-xl font-semibold text-[#ae2b2b]">
                  {project.title}
                </h2>

                <p className="text-gray-600 text-sm line-clamp-2 mt-1">
                  {project.short}
                </p>

                <span
                  className={`mt-3 inline-block px-3 py-1 text-xs rounded-full ${
                    project.status === "Ongoing"
                      ? "bg-green-100 text-green-700"
                      : "bg-gray-200 text-gray-700"
                  }`}
                >
                  {project.status}
                </span>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
};

export default ProjectsPage;
