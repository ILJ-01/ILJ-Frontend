import React, {useEffect, useState} from 'react';
import {Link, useParams} from "react-router-dom";
import {useNavigate} from "react-router";
import projects from "../data/projects-full.json";
import LoadingSpinner from "./LoadingSpinner.jsx";

const projectThumbs = import.meta.glob(
  "../assets/projects/*.{png,jpg,jpeg,webp}",
  {eager: true}
);

const getThumb = (fileName) => {
  const path = `../assets/projects/${fileName}`;
  return projectThumbs[path]?.default || "";
};

const allGallery = import.meta.glob(
  "../assets/projectImages/**/*.{png,jpg,jpeg,webp}",
  {eager: true}
);

const getGalleryImages = (projectId) => {
  const folder = `../assets/projectImages/${projectId}/`;

  return Object.keys(allGallery)
    .filter((img) => img.startsWith(folder))
    .map((img) => allGallery[img].default);
};

export default function Project() {
  const navigate = useNavigate();

  const { title } = useParams();
  const [openProject, setOpenProject] = useState(null);

  useEffect(() => {
    const project = projects.find((project) => project.title === title);

    if (!project) {
      navigate('/projects');
      return;
    }
    setOpenProject(project);
  }, [title, navigate]);

  const gallery = getGalleryImages();

  if (openProject === null) {
    return (
      <LoadingSpinner />
    );
  }

  return (
    <div className="px-6 py-8 font-serif">
      <button
        onClick={() => navigate(-1)}
        className="text-[#ae2b2b] mb-6 font-semibold hover:underline"
      >
        ← Back
      </button>

      <div className="grid md:grid-cols-2 gap-8">
        <img
          src={getThumb(openProject.image)}
          className="w-full h-72 rounded-xl object-cover shadow-lg"
          alt={openProject.title}
        />

        <div>
          <h1 className="text-4xl font-bold text-[#ae2b2b] mb-3">
            {openProject.title}
          </h1>
          <p className="text-gray-500 mb-2">{openProject.date}</p>

          <span
            className={`px-3 py-1 text-xs rounded-full ${
              openProject.status === "Ongoing"
                ? "bg-green-100 text-green-700"
                : "bg-gray-200 text-gray-700"
            }`}
          >
              {openProject.status}
            </span>

          <p className="mt-4 text-gray-700 leading-relaxed">
            {openProject.description}
          </p>

          <div className='flex gap-2'>
            {openProject.link && (
              <Link
                to={`/form?formLink=${encodeURIComponent(openProject.link)}`}
                target="_blank"
                className="mt-6 inline-block bg-[#ae2b2b] text-white px-5 py-2 rounded-lg shadow-md hover:scale-105 transition"
              >
                Open Form / Link
              </Link>
            )}

            {openProject.feedback && (
              <Link
                to={`/form?formLink=${encodeURIComponent(openProject.feedback)}`}
                target="_blank"
                className="mt-6 inline-block bg-[#ae2b2b] text-white px-5 py-2 rounded-lg shadow-md hover:scale-105 transition"
              >
                Share Feedback
              </Link>
            )}
          </div>
        </div>
      </div>

      <h2 className="mt-10 mb-4 text-2xl font-semibold text-[#ae2b2b]">
        Project Gallery
      </h2>

      {gallery.length === 0 ? (
        <p className="text-gray-500">No gallery images uploaded.</p>
      ) : (
        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
          {gallery.map((img, i) => (
            <img
              key={i}
              src={img}
              className="rounded-xl object-cover h-40 shadow hover:scale-105 transition"
              alt={openProject.title}
            />
          ))}
        </div>
      )}
    </div>
  );
}