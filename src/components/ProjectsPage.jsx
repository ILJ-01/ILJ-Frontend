import React, { useState } from "react";

// =============================
// 1️⃣ Auto-load thumbnails
// =============================
const projectThumbs = import.meta.glob(
  "../assets/projects/*.{png,jpg,jpeg,webp}",
  { eager: true }
);

const getThumb = (fileName) => {
  const path = `../assets/projects/${fileName}`;
  return projectThumbs[path]?.default || "";
};

// =============================
// 2️⃣ Auto-load gallery images
// =============================
const allGallery = import.meta.glob(
  "../assets/projectImages/**/*.{png,jpg,jpeg,webp}",
  { eager: true }
);

const getGalleryImages = (projectId) => {
  const folder = `../assets/projectImages/${projectId}/`;

  return Object.keys(allGallery)
    .filter((img) => img.startsWith(folder))
    .map((img) => allGallery[img].default);
};

const ProjectsPage = () => {
  const [openProject, setOpenProject] = useState(null);

  // =============================
  // 3️⃣ Project List
  // =============================
  const projects = [
    {
      id: 1,
      title: "Veer Vanshaj",
      status: "Completed",
      short: "Self-defence workshop empowering women across Mumbai.",
      description:"The Veer Vanshaj - Self Defence Workshop empowers individuals, especially women, with the skills and confidence to protect themselves in any situation. The initiative offers practical self-defence training, focusing on building physical strength, awareness, and mental resilience. Launched with the aim of ensuring safety and independence, the workshops have already gained momentum with multiple successful sessions. Our future vision includes expanding this impactful program across Mumbai, reaching more individuals in need of self-defence training.",
      date: "June 2025",
      image: "VeerVansaj.jpeg",
      link: "",
    },
    {
      id: 2,
      title: "The Sanskar Library",
      status: "Ongoing",
      short: "A rotating library that promotes ethics & Jain values.",
      description:
        "The Sanskaar Library is an initiative designed to nurture reading habits and instill moral values in children through curated books. By creating a rotating library system that promotes morals, ethics, principles of Jainism and personal growth, we aim to build a foundation of knowledge and integrity among the younger generation. Currently, the library operates in several pathshalas (religious schools) in Dombivli, with over 200 books available for circulation. We are committed to expanding the library across Mumbai, providing more children with access to inspirational and educational resources.",
      date: "April 2025",
      image: "SanskarLibrary.jpeg",
      link: "",
    },
    {
      id: 3,
      title: "Jainism - A Scientific Lens",
      status: "Completed",
      short: "Exhibition connecting Jain philosophy & modern science.",
      description:
        "Jainism: A Scientific Lens is an innovative exhibition designed to explore the intersection of ancient Jain principles and modern science. The exhibition features interactive models, charts, and experiments that demonstrate the compatibility of Jain teachings with scientific concepts like E=MC², Theory of Evolution, Sustainability, and Law of Attraction. After the successful launch of the first exhibition in Dombivli, we are now expanding to other cities to further engage the public and promote awareness of Jainism’s relevance in the modern world.",
      date: "July–August 2025",
      image: "ScientificLens.jpeg",
      link: "",
    },
    {
      id: 4,
      title: "Spiritual Shibir Series",
      status: "Completed",
      short: "A 6-week series on self-awareness & spiritual growth.",
      description:
        "A 6-week Sunday series focused on self-awareness and spiritual connection.",
      date: "July–August 2025",
      image: "Shibir.jpeg",
    },
    {
      id: 5,
      title: "Promotion of Jainism on Social Media",
      status: "Ongoing",
      short: "Spreading values of Jainism through Instagram content.",
      description:
        "We are committed to spreading the timeless wisdom of Jainism through modern channels. Our Promotion of Jainism on Social Media, primarily through the Instagram page @ilovejinshasan, seeks to inspire a global audience by highlighting the profound values and principles of Jain philosophy. Through engaging content such as the Veer Gatha Series, Festive Series, Veer Vigyan Series, we aim to promote awareness and foster a deeper connection to Jainism. With plans for future series covering topics like Anekantvad, our social media presence is steadily growing, empowering individuals to embrace teachings if Jainism in everyday life.",
      date: "September 2025",
      image: "Jainism_SocialMedia.jpeg",
    },
  ];

  // =============================
  // 4️⃣ OPEN PROJECT VIEW
  // =============================
  if (openProject) {
    const gallery = getGalleryImages(openProject.id);
    const thumb = getThumb(openProject.image);

    return (
      <div className="px-6 py-8 font-serif">
        <button
          onClick={() => setOpenProject(null)}
          className="text-[#ae2b2b] mb-6 font-semibold hover:underline"
        >
          ← Back to Projects
        </button>

        <div className="grid md:grid-cols-2 gap-8">
          <img
            src={thumb}
            className="w-full h-72 rounded-xl object-cover shadow-lg"
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

            {openProject.link && (
              <a
                href={openProject.link}
                target="_blank"
                className="mt-6 inline-block bg-[#ae2b2b] text-white px-5 py-2 rounded-lg shadow-md hover:scale-105 transition"
              >
                Open Form / Link
              </a>
            )}
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
              />
            ))}
          </div>
        )}
      </div>
    );
  }

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
              onClick={() => setOpenProject(project)}
              className="bg-white rounded-2xl shadow-md hover:shadow-xl transition cursor-pointer"
            >
              <img
                src={thumb}
                className="w-full h-48 object-cover rounded-t-2xl"
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
