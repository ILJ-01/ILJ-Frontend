import React, { useEffect, useState } from 'react';
import { Link, useParams } from "react-router-dom";
import { useNavigate } from "react-router";
import projects from "../data/projects-full.json";
import LoadingSpinner from "./LoadingSpinner.jsx";
import { supabase } from "../lib/supabase";
import { useAuth } from "../context/AuthContext";
import { User, Phone, Mail, CheckCircle, Clock, Calendar, Shield, ArrowLeft } from "lucide-react";
import { Button } from "@/components/ui/button";

const projectThumbs = import.meta.glob(
  "../assets/projects/*.{png,jpg,jpeg,webp}",
  { eager: true }
);

const getThumb = (fileName) => {
  const path = `../assets/projects/${fileName}`;
  return projectThumbs[path]?.default || "";
};

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

export default function Project() {
  const navigate = useNavigate();
  const { title } = useParams(); // Acts as 'id' for DB projects
  const { user, isLoggedIn } = useAuth();

  const [project, setProject] = useState(null);
  const [loading, setLoading] = useState(true);
  const [applicationStatus, setApplicationStatus] = useState(null); // 'pending', 'approved', or null
  const [isApplying, setIsApplying] = useState(false);

  // Check if params is a UUID (Database Project) or a Title (Static JSON)
  const isUuid = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(title);

  useEffect(() => {
    async function loadData() {
      setLoading(true);

      if (isUuid) {
        // 1. Fetch from Supabase
        try {
          const { data, error } = await supabase
            .from('projects')
            .select(`
              *,
              manager:manager_id (
                first_name, last_name, ilj_id, mobile_number, email
              )
            `)
            .eq('id', title)
            .single();

          if (error) throw error;
          setProject({ ...data, type: 'db' });

          // 2. Check application status if logged in
          if (isLoggedIn && user) {
            const { data: appData, error: appError } = await supabase
              .from('project_volunteers')
              .select('status')
              .eq('project_id', title)
              .eq('volunteer_id', user.id)
              .single();

            if (!appError && appData) {
              setApplicationStatus(appData.status);
            }
          }

        } catch (err) {
          console.error("Error loading project:", err);
          // navigate('/projects'); // Optional: redirect on error
        }
      } else {
        // 1. Fetch from JSON
        const found = projects.find((p) => p.title === title);
        if (found) {
          setProject({ ...found, type: 'static' });
        } else {
          // navigate('/projects');
        }
      }
      setLoading(false);
    }

    loadData();
  }, [title, isUuid, isLoggedIn, user, navigate]);

  const handleApply = async () => {
    if (!isLoggedIn) {
      alert("Please login to volunteer for this project.");
      return;
    }

    setIsApplying(true);
    try {
      const { error } = await supabase
        .from('project_volunteers')
        .insert({
          project_id: project.id,
          volunteer_id: user.id,
          status: 'pending'
        });

      if (error) throw error;

      setApplicationStatus('pending');
      // alert("Application submitted successfully!"); 
    } catch (err) {
      console.error("Error applying:", err);
      alert("Failed to apply. You may have already applied.");
    } finally {
      setIsApplying(false);
    }
  };

  if (loading) return <LoadingSpinner />;
  if (!project) return <div className="p-10 text-center">Project not found</div>;

  // --- RENDER FOR STATIC JSON PROJECTS ---
  if (project.type === 'static') {
    const gallery = getGalleryImages();
    return (
      <div className="px-6 py-8 font-serif max-w-7xl mx-auto">
        <button onClick={() => navigate(-1)} className="text-[#ae2b2b] mb-6 font-semibold hover:underline flex items-center gap-2">
          <ArrowLeft size={18} /> Back
        </button>

        <div className="grid md:grid-cols-2 gap-8">
          <img src={getThumb(project.image)} className="w-full h-80 rounded-2xl object-cover shadow-xl" alt={project.title} />
          <div>
            <h1 className="text-4xl font-bold text-[#ae2b2b] mb-3">{project.title}</h1>
            <p className="text-gray-500 mb-4">{project.date}</p>
            <span className={`px-3 py-1 text-xs rounded-full ${project.status === "Ongoing" ? "bg-green-100 text-green-700" : "bg-gray-200 text-gray-700"}`}>
              {project.status}
            </span>
            <p className="mt-6 text-gray-700 leading-relaxed text-lg">{project.description}</p>

            <div className='flex flex-wrap gap-3 mt-8'>
              {project.link && (
                <Link to={`/form?formLink=${encodeURIComponent(project.link)}`} target="_blank">
                  <Button className="bg-[#ae2b2b] hover:bg-[#912323]">Open Form / Link</Button>
                </Link>
              )}
              {project.feedback && (
                <Link to={`/form?formLink=${encodeURIComponent(project.feedback)}`} target="_blank">
                  <Button variant="outline" className="text-[#ae2b2b] border-[#ae2b2b]">Share Feedback</Button>
                </Link>
              )}
            </div>
          </div>
        </div>

        {gallery.length > 0 && (
          <>
            <h2 className="mt-16 mb-6 text-2xl font-bold text-[#ae2b2b]">Project Gallery</h2>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
              {gallery.map((img, i) => (
                <img key={i} src={img} className="rounded-xl object-cover h-48 w-full shadow hover:scale-105 transition duration-300" alt="Gallery" />
              ))}
            </div>
          </>
        )}
      </div>
    );
  }

  // --- RENDER FOR DYNAMIC DB PROJECTS ---
  return (
    <div className="min-h-screen bg-gray-50/50 pb-20">
      {/* Hero Banner */}
      <div className="max-w-7xl mx-auto px-6 py-8">
        <button onClick={() => navigate('/projects')} className="text-[#ae2b2b] mb-6 font-semibold hover:underline flex items-center gap-2">
          <ArrowLeft size={18} /> Back to Projects
        </button>

        {/* Simple Banner Image */}
        <div className="w-full h-64 md:h-96 rounded-2xl overflow-hidden shadow-md mb-8 bg-gray-100">
          {project.banner_url ? (
            <img src={project.banner_url} alt={project.title} className="w-full h-full object-cover" />
          ) : (
            <div className="w-full h-full flex items-center justify-center text-gray-400 bg-gray-200">
              No Banner Image
            </div>
          )}
        </div>

        {/* Header Section */}
        <div className="mb-8">
          <div className="flex flex-wrap items-center gap-3 mb-4">
            <span className={`px-3 py-1 text-xs font-bold rounded-full uppercase tracking-wider shadow-sm ${project.status === 'active' ? "bg-green-100 text-green-700" :
              project.status === 'completed' ? "bg-gray-100 text-gray-700" :
                "bg-[#ae2b2b]/10 text-[#ae2b2b]"
              }`}>
              {project.status || 'Upcoming'}
            </span>
            <span className="px-3 py-1 text-xs font-bold rounded-full uppercase tracking-wider bg-gray-100 text-gray-600 border border-gray-200">
              {project.project_code}
            </span>
          </div>

          <h1 className="text-3xl md:text-5xl font-serif font-bold text-[#ae2b2b] mb-2 leading-tight">
            {project.title}
          </h1>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-6 grid grid-cols-1 lg:grid-cols-3 gap-8">

        {/* Left Column: Details */}
        <div className="lg:col-span-2 space-y-8">
          <div className="bg-white rounded-2xl p-8 shadow-sm border border-gray-100">
            <h2 className="text-2xl font-bold text-gray-800 mb-4 font-serif">About Project</h2>
            <div className="prose prose-red max-w-none text-gray-600 leading-relaxed whitespace-pre-line">
              {project.description}
            </div>
          </div>

          {/* Manager Contact Card (Only for logged in) */}
          {isLoggedIn && project.manager && (
            <div className="bg-gradient-to-br from-[#ae2b2b]/5 to-white rounded-2xl p-6 border border-[#ae2b2b]/10 shadow-sm flex flex-col md:flex-row gap-6 items-start md:items-center">
              <div className="bg-[#ae2b2b]/10 p-4 rounded-full text-[#ae2b2b]">
                <User size={32} />
              </div>
              <div className="flex-1">
                <p className="text-xs font-bold text-[#ae2b2b] uppercase tracking-widest mb-1">Project Manager</p>
                <h3 className="text-xl font-semibold text-gray-900">{project.manager.first_name} {project.manager.last_name}</h3>
                <p className="text-sm text-gray-500 mb-3">{project.manager.ilj_id}</p>

                <div className="flex flex-wrap gap-4 text-sm">
                  <div className="flex items-center gap-2 text-gray-700 bg-white px-3 py-1.5 rounded-lg border border-[#ae2b2b]/10 shadow-sm">
                    <Phone size={14} className="text-[#ae2b2b]" />
                    {project.manager.mobile_number}
                  </div>
                  <div className="flex items-center gap-2 text-gray-700 bg-white px-3 py-1.5 rounded-lg border border-[#ae2b2b]/10 shadow-sm">
                    <Mail size={14} className="text-[#ae2b2b]" />
                    {project.manager.email}
                  </div>
                </div>
              </div>
            </div>
          )}
        </div>

        {/* Right Column: Actions */}
        <div className="space-y-6">
          <div className="bg-white rounded-2xl p-6 shadow-md border-t-4 border-[#ae2b2b] sticky top-24">
            <h3 className="text-lg font-bold text-gray-900 mb-4 font-serif">Join the Mission</h3>

            {!isLoggedIn ? (
              <div className="text-center py-4 bg-gray-50 rounded-xl border border-dashed border-gray-300">
                <Shield className="w-10 h-10 text-gray-400 mx-auto mb-2" />
                <p className="text-gray-600 mb-3">Please login to apply for this project.</p>
                <Link to="/admin">
                  {/* Assuming user might look for login, but usually navbar handles it. 
                            We can just show a message or direct to login if we had a dedicated login page route easily accessible */}
                  <Button variant="outline">Login to Apply</Button>
                </Link>
              </div>
            ) : (
              <div>
                {applicationStatus === 'approved' ? (
                  <div className="bg-green-50 border border-green-200 rounded-xl p-4 text-center">
                    <div className="mx-auto w-12 h-12 bg-green-100 rounded-full flex items-center justify-center mb-2">
                      <CheckCircle className="w-6 h-6 text-green-600" />
                    </div>
                    <h4 className="font-bold text-green-800">You are a Member!</h4>
                    <p className="text-sm text-green-600 mt-1">Check your dashboard for tasks.</p>
                  </div>
                ) : applicationStatus === 'pending' ? (
                  <div className="bg-[#ae2b2b]/5 border border-[#ae2b2b]/20 rounded-xl p-4 text-center">
                    <div className="mx-auto w-12 h-12 bg-[#ae2b2b]/10 rounded-full flex items-center justify-center mb-2">
                      <Clock className="w-6 h-6 text-[#ae2b2b]" />
                    </div>
                    <h4 className="font-bold text-[#ae2b2b]">Request Pending</h4>
                    <p className="text-sm text-[#ae2b2b] mt-1">Approval sent to manager.</p>
                  </div>
                ) : (
                  <div className="space-y-3">
                    <p className="text-sm text-gray-600 mb-4">
                      Ready to contribute? Click below to request to join this project team.
                    </p>
                    <Button
                      onClick={handleApply}
                      disabled={isApplying}
                      className="w-full bg-[#ae2b2b] hover:bg-[#8f1f1f] text-lg py-6 shadow-lg shadow-red-100"
                    >
                      {isApplying ? "Applying..." : "I'm Interested to Volunteer"}
                    </Button>
                  </div>
                )}
              </div>
            )}


          </div>
        </div>
      </div>
    </div>
  );
}