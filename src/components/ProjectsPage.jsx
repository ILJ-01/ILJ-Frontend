import React, { useEffect, useState } from "react";
import projects from "../data/projects-full.json";
import { useNavigate } from "react-router";
import { supabase } from "../lib/supabase";
import { useAuth } from "../context/AuthContext";
import { User, Phone, Mail, CheckCircle, Clock } from "lucide-react";

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

const ProjectsPage = () => {
  const navigate = useNavigate();
  const { user, isLoggedIn } = useAuth();

  const [dbProjects, setDbProjects] = useState([]);
  const [loading, setLoading] = useState(true);
  const [myApplications, setMyApplications] = useState({}); // Map of project_id -> status

  useEffect(() => {
    fetchDbProjects();
    if (isLoggedIn && user) {
      fetchMyApplications();
    }
  }, [isLoggedIn, user]);

  const fetchDbProjects = async () => {
    try {
      const { data, error } = await supabase
        .from('projects')
        .select(`
                *,
                manager:manager_id (
                    first_name, last_name, ilj_id, mobile_number, email
                )
            `)
        .order('created_at', { ascending: false });

      if (error) throw error;

      // Filter: Show private projects only if logged in
      const visibleData = (data || []).filter(p => {
        if (p.visibility === 'private' && !user) return false;
        return true;
      });

      setDbProjects(visibleData);
    } catch (err) {
      console.error("Error fetching projects:", err);
    } finally {
      setLoading(false);
    }
  };

  const fetchMyApplications = async () => {
    try {
      const { data, error } = await supabase
        .from('project_volunteers')
        .select('project_id, status')
        .eq('volunteer_id', user.id);

      if (error) throw error;

      const appMap = {};
      data.forEach(app => {
        appMap[app.project_id] = app.status;
      });
      setMyApplications(appMap);
    } catch (err) {
      console.error("Error fetching applications:", err);
    }
  };

  const handleInterest = async (e, projectId) => {
    e.stopPropagation(); // Prevent card click
    if (!isLoggedIn) {
      alert("Please login to register interest.");
      return;
    }

    try {
      const { error } = await supabase
        .from('project_volunteers')
        .insert({
          project_id: projectId,
          volunteer_id: user.id,
          status: 'pending'
        });

      if (error) throw error;

      // Update local state
      setMyApplications(prev => ({ ...prev, [projectId]: 'pending' }));
      alert("Your interest has been registered! An admin will review your request.");
    } catch (err) {
      console.error("Error registering interest:", err);
      alert("Failed to register interest. You may have already applied.");
    }
  };

  // =============================
  // 5️⃣ PROJECT GRID VIEW
  // =============================
  return (
    <div className="px-6 py-10 font-serif min-h-screen">
      <h1 className="text-4xl font-bold text-[#ae2b2b] mb-10 text-center">
        Our Projects
      </h1>

      <div className="max-w-7xl mx-auto space-y-16">

        {/* SECTION 1: DATABASE PROJECTS (Dynamic) */}
        {dbProjects.length > 0 && (
          <section>
            <h2 className="text-2xl font-bold text-gray-800 mb-6 border-l-4 border-[#ae2b2b] pl-4">Active Initiatives</h2>
            <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-8">
              {dbProjects.map((project) => (
                <div
                  key={project.id}
                  onClick={() => navigate(`/project/${project.id}`)}
                  className="bg-white rounded-2xl shadow-md hover:shadow-xl transition flex flex-col overflow-hidden border border-gray-100 cursor-pointer group"
                >
                  {/* Banner */}
                  <div className="h-48 w-full bg-gray-200 relative overflow-hidden">
                    {project.banner_url ? (
                      <img src={project.banner_url} alt={project.title} className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500" />
                    ) : (
                      <div className="flex items-center justify-center h-full text-gray-400 font-medium">No Image</div>
                    )}
                    <span className={`absolute top-3 right-3 px-3 py-1 text-xs font-bold rounded-full uppercase tracking-wider shadow-sm
                                    ${project.status === 'active' ? "bg-green-100 text-green-700" :
                        project.status === 'completed' ? "bg-gray-100 text-gray-700" :
                          "bg-[#ae2b2b]/10 text-[#ae2b2b]"}
                                `}>
                      {project.status || 'Upcoming'}
                    </span>
                  </div>

                  <div className="p-6 flex-1 flex flex-col">
                    <div className="mb-4">
                      <h2 className="text-xl font-bold text-[#ae2b2b] leading-tight mb-2 group-hover:text-[#8f1f1f] transition-colors">{project.title}</h2>
                      <p className="text-xs text-gray-500 font-mono mb-3">{project.project_code}</p>
                      <p className="text-gray-600 text-sm line-clamp-3">{project.description}</p>
                    </div>

                    <div className="mt-auto pt-4 border-t border-gray-100">
                      {/* Manager Details - Simplified for card view */}
                      <div className="flex items-center justify-between text-sm text-gray-500">
                        <span className="flex items-center gap-1">
                          <User className="h-3.5 w-3.5" />
                          Manager
                        </span>

                        {myApplications[project.id] === 'approved' && (
                          <span className="text-xs bg-green-100 text-green-700 px-2 py-0.5 rounded font-medium flex items-center gap-1">
                            <CheckCircle className="h-3 w-3" /> Member
                          </span>
                        )}
                        {myApplications[project.id] === 'pending' && (
                          <span className="text-xs bg-[#ae2b2b]/10 text-[#ae2b2b] px-2 py-0.5 rounded font-medium flex items-center gap-1">
                            <Clock className="h-3 w-3" /> Pending
                          </span>
                        )}
                      </div>

                      <button className="w-full mt-4 text-[#ae2b2b] font-medium text-sm flex items-center justify-center group-hover:underline">
                        View Details & Apply →
                      </button>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </section>
        )}

        {/* SECTION 2: ARCHIVED / STATIC PROJECTS (Legacy) */}
        <section>
          <h2 className="text-2xl font-bold text-gray-800 mb-6 border-l-4 border-gray-400 pl-4">Past & Ongoing Works</h2>
          <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-8">
            {projects.map((project) => {
              const thumb = getThumb(project.image);

              return (
                <div
                  key={project.id}
                  onClick={() => navigate(`/project/${project.title}`)}
                  className="bg-white rounded-2xl shadow-md hover:shadow-xl transition cursor-pointer flex flex-col border border-gray-100"
                >
                  <img
                    src={thumb}
                    className="w-full h-48 object-cover rounded-t-2xl"
                    alt={project.title}
                  />

                  <div className="p-5 flex-1">
                    <h2 className="text-xl font-semibold text-[#ae2b2b]">
                      {project.title}
                    </h2>

                    <p className="text-gray-600 text-sm line-clamp-2 mt-1">
                      {project.short}
                    </p>

                    <span
                      className={`mt-3 inline-block px-3 py-1 text-xs rounded-full ${project.status === "Ongoing"
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
        </section>

      </div>
    </div>
  );
};

export default ProjectsPage;
