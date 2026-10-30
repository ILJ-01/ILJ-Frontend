import React, { useEffect, useState, useRef } from "react";
import { Link, useLocation, useParams } from "react-router-dom";
import { useNavigate } from "react-router";
import projects from "../data/projects-full.json";
import LoadingSpinner from "./LoadingSpinner.jsx";
import { supabase } from "../lib/supabase";
import { useAuth } from "../context/AuthContext";
import {
  User,
  Phone,
  Mail,
  CheckCircle,
  Clock,
  Calendar,
  Shield,
  ArrowLeft,
  MessageSquare,
  MapPin,
  Star,
  X,
  Quote,
  HelpCircle,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Carousel,
  CarouselContent,
  CarouselItem,
  CarouselNext,
  CarouselPrevious,
} from "@/components/ui/carousel";
import {
  Dialog,
  DialogContent,
  DialogTrigger,
  DialogTitle,
} from "@/components/ui/dialog";
import { Card, CardContent, CardFooter } from "@/components/ui/card";
import Autoplay from "embla-carousel-autoplay";
import Instagram from "./Instagram";
import KivaRegForm from "./KivaRegForm";
import ProjectFeedbackSection from "./ProjectFeedbackSection";

const projectThumbs = import.meta.glob(
  "../assets/projects/*.{png,jpg,jpeg,webp}",
  { eager: true },
);

const getThumb = (fileName) => {
  const path = `../assets/projects/${fileName}`;
  return projectThumbs[path]?.default || "";
};

const allGallery = import.meta.glob(
  "../assets/projectImages/**/*.{png,jpg,jpeg,webp}",
  { eager: true },
);

const getGalleryImages = (projectId) => {
  const folder = `../assets/projectImages/${projectId}/`;

  return Object.keys(allGallery)
    .filter((img) => img.startsWith(folder))
    .map((img) => allGallery[img].default);
};

const SHIBIR_SESSIONS = [
  "17th Oct: Overcoming Fear Session",
];

const JAINIFIC_SESSIONS = [
  "Jainific 3.0 Malad - 1st November 2026",
  "Exhibit: Rebirth (Second Adhyay)",
  "Exhibit: Tripadi (Fifth Adhyay)",
  "Exhibit: Aura & Leshya (34th Adhyay)",
  "Exhibit: Psychology of emotions (32nd Adhyay)",
  "Exhibit: Theory of evolution (Second Adhyay)",
  "General Exhibition Feedback",
];

export default function Project() {
  const navigate = useNavigate();
  const location = useLocation();
  const { title } = useParams(); // Acts as 'id' for DB projects
  const { user, isLoggedIn } = useAuth();

  const [project, setProject] = useState(null);
  const [loading, setLoading] = useState(true);
  const [applicationStatus, setApplicationStatus] = useState(null); // 'pending', 'approved', or null
  const [isApplying, setIsApplying] = useState(false);
  const [dbGallery, setDbGallery] = useState([]);
  const [dbTestimonials, setDbTestimonials] = useState([]);
  const [subpods, setSubpods] = useState([]);
  const [subHeads, setSubHeads] = useState([]);
  const [revaSessions, setRevaSessions] = useState([]);
  const [kivaSessions, setKivaSessions] = useState([]);

  // Inquiry & Feedback State
  const [isInquiryOpen, setIsInquiryOpen] = useState(false);
  const [isQnaOpen, setIsQnaOpen] = useState(false);
  const [isFeedbackOpen, setIsFeedbackOpen] = useState(false);
  const [feedbackOpenRequest, setFeedbackOpenRequest] = useState(0);
  const [submitting, setSubmitting] = useState(false);
  const [inquiryForm, setInquiryForm] = useState({
    name: "",
    email: "",
    mobile: "",
    message: "",
    sangh_name: "",
    sangh_address: "",
    proposed_venue: "",
    proposed_dates: "",
    how_did_you_know: "",
  });
  const [qnaForm, setQnaForm] = useState({
    name: "",
    email: "",
    mobile: "",
    message: "",
  });
  const [feedbackForm, setFeedbackForm] = useState({
    rating: 5,
    session: "",
    comments: "",
    is_anonymous: false,
    name: "",
    email: "",
    mobile: "",
    age: "",
    city: "",
  });

  const [eventForm, setEventForm] = useState({
    full_name: "",
    whatsapp_number: "",
    age: "",
    address: "",
    sangh_name: "",
  });
  const [eventPaymentImage, setEventPaymentImage] = useState(null);
  const [isEventSubmitting, setIsEventSubmitting] = useState(false);
  const [isEventFormOpen, setIsEventFormOpen] = useState(false);

  const ratingLabels = ["Poor", "Fair", "Good", "Very good", "Excellent"];

  // Check if params is a UUID (Database Project) or a Title (Static JSON)
  const isUuid =
    /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(
      title,
    );

  useEffect(() => {
    async function loadData() {
      setLoading(true);

      try {
        let dbQuery = supabase
          .from("projects")
          .select(
            `
            *,
            manager:manager_id (
              first_name, last_name, ilj_id, mobile_number, email
            )
          `,
          );

        if (isUuid) {
          dbQuery = dbQuery.eq("id", title);
        } else {
          // If title is "Jainific", "jainific", or matches project title
          dbQuery = dbQuery.ilike("title", title);
        }

        const { data, error } = await dbQuery.maybeSingle();

        if (data) {
          const projectId = data.id;
          if (data.status === "archived" && !user?.isITAdmin) {
            setProject(null);
            navigate("/projects");
            return;
          }
          setProject({ ...data, type: "db" });

          const { data: photosData } = await supabase
            .from("project_photos")
            .select("photo_url")
            .eq("project_id", projectId);
          if (photosData) setDbGallery(photosData.map((p) => p.photo_url));

          const { data: testData } = await supabase
            .from("project_feedback")
            .select("*")
            .eq("project_id", projectId)
            .order("created_at", { ascending: false });
          if (testData) setDbTestimonials(testData);

          const { data: subpodsData } = await supabase
            .from("projects")
            .select("*")
            .eq("parent_project_id", projectId);
          if (subpodsData) {
            const visibleSubpods = subpodsData.filter((sub) => {
              if (sub.project_code === "PRJ-008-01") return false; // Temporarily hide Reconnect
              if (sub.status === "archived" && !user?.isITAdmin) return false;
              if (sub.visibility === "private" && !isLoggedIn) return false;
              return true;
            });
            setSubpods(visibleSubpods);
          }

          if (data.sub_head_ids && data.sub_head_ids.length > 0) {
            const { data: shData } = await supabase
              .from("volunteers")
              .select("id, first_name, last_name, ilj_id, mobile_number, email")
              .in("id", data.sub_head_ids);
            if (shData) setSubHeads(shData);
          } else {
            setSubHeads([]);
          }

          if (data.project_code === "PRJ-010") {
            const { data: sessionData } = await supabase
              .from("reva_sessions")
              .select("*")
              .order("date", { ascending: true })
              .order("time", { ascending: true });
            if (sessionData) setRevaSessions(sessionData);
          } else if (data.project_code === "PRJ-009") {
            const { data: sessionData } = await supabase
              .from("kiva_sessions")
              .select("*")
              .order("date", { ascending: true })
              .order("time", { ascending: true });
            if (sessionData) setKivaSessions(sessionData);
          }

          // 2. Check application status if logged in
          if (isLoggedIn && user) {
            const { data: appData, error: appError } = await supabase
              .from("project_volunteers")
              .select("status")
              .eq("project_id", projectId)
              .eq("volunteer_id", user.id)
              .single();

            if (!appError && appData) {
              setApplicationStatus(appData.status);
            }
          }
        } else {
          // Fallback to static JSON if not found in DB
          const found = projects.find(
            (p) => p.title.toLowerCase() === title.toLowerCase(),
          );
          if (found) {
            setProject({ ...found, type: "static" });
            // For Jainific static fallback, load its testimonials from DB
            if (found.title?.toLowerCase().includes("jainific")) {
              const { data: testData } = await supabase
                .from("project_feedback")
                .select("*")
                .eq("project_id", "134f3fc8-8546-4bb3-b39a-e671bfcb0808")
                .order("created_at", { ascending: false });
              if (testData) setDbTestimonials(testData);
            }
          }
        }
      } catch (err) {
        console.error("Error loading project:", err);
      } finally {
        setLoading(false);
      }
    }

    loadData();
  }, [title, isUuid, isLoggedIn, user, navigate]);

  useEffect(() => {
    const params = new URLSearchParams(location.search);
    const open =
      params.get("open") || params.get("modal") || params.get("form") || params.get("feedback");

    if (open === "feedback" || params.get("feedback") === "true") {
      setTimeout(() => {
        const el = document.getElementById("feedback-section");
        if (el) el.scrollIntoView({ behavior: "smooth" });
      }, 400);
    } else if (open === "inquiry") {
      setIsInquiryOpen(true);
    } else if (open === "qna") {
      setIsQnaOpen(true);
    }
  }, [location.search]);

  const handleApply = async () => {
    if (!isLoggedIn) {
      alert("Please login to volunteer for this project.");
      return;
    }

    setIsApplying(true);
    try {
      const { error } = await supabase.from("project_volunteers").insert({
        project_id: project.id,
        volunteer_id: user.id,
        status: "pending",
      });

      if (error) throw error;

      setApplicationStatus("pending");
      // alert("Application submitted successfully!");
    } catch (err) {
      console.error("Error applying:", err);
      alert("Failed to apply. You may have already applied.");
    } finally {
      setIsApplying(false);
    }
  };

  const handleInquirySubmit = async (e) => {
    e.preventDefault();
    setSubmitting(true);
    try {
      const { error } = await supabase.from("project_inquiries").insert({
        project_id: project.id,
        ...inquiryForm,
      });
      if (error) throw error;
      alert("Inquiry sent successfully! We will contact you soon.");
      setIsInquiryOpen(false);
      setInquiryForm({
        name: "",
        email: "",
        mobile: "",
        message: "",
        sangh_name: "",
        sangh_address: "",
        proposed_venue: "",
        proposed_dates: "",
        how_did_you_know: "",
      });
    } catch (error) {
      console.error("Inquiry Error:", error);
      alert("Failed to send inquiry.");
    } finally {
      setSubmitting(false);
    }
  };

  const handleQnaSubmit = async (e) => {
    e.preventDefault();
    setSubmitting(true);
    try {
      const { error } = await supabase.from("project_inquiries").insert({
        project_id: project.id,
        ...qnaForm,
      });
      if (error) throw error;
      alert("Query submitted successfully! We will get back to you soon.");
      setIsQnaOpen(false);
      setQnaForm({ name: "", email: "", mobile: "", message: "" });
    } catch (error) {
      console.error("QnA Error:", error);
      alert("Failed to submit query.");
    } finally {
      setSubmitting(false);
    }
  };

  const handleFeedbackSubmit = async (e) => {
    e.preventDefault();
    setSubmitting(true);
    try {
      const parsedAge =
        feedbackForm.age && !isNaN(parseInt(feedbackForm.age, 10))
          ? parseInt(feedbackForm.age, 10)
          : null;

      const finalComments = feedbackForm.session
        ? `[Session: ${feedbackForm.session}] ${feedbackForm.comments}`
        : feedbackForm.comments;

      const payload = {
        project_id: project.id,
        rating: feedbackForm.rating,
        comments: finalComments,
        is_anonymous: feedbackForm.is_anonymous,
        name: feedbackForm.is_anonymous ? null : feedbackForm.name || null,
        email: feedbackForm.is_anonymous ? null : feedbackForm.email || null,
        mobile: feedbackForm.is_anonymous ? null : feedbackForm.mobile || null,
        age: feedbackForm.is_anonymous ? null : parsedAge,
        city: feedbackForm.is_anonymous ? null : feedbackForm.city || null,
      };

      const { data: insertedFb, error } = await supabase
        .from("project_feedback")
        .insert(payload)
        .select()
        .single();
      if (error) throw error;
      alert("Thank you for your feedback!");
      setIsFeedbackOpen(false);
      if (insertedFb) {
        setDbTestimonials((prev) => [insertedFb, ...prev]);
      }
      setFeedbackForm({
        rating: 5,
        session: "",
        comments: "",
        is_anonymous: false,
        name: "",
        email: "",
        mobile: "",
        age: "",
        city: "",
      });
    } catch (error) {
      console.error("Feedback Error:", error);
      alert("Failed to submit feedback. " + (error.message || ""));
    } finally {
      setSubmitting(false);
    }
  };

  const handleEventFormSubmit = async (e) => {
    e.preventDefault();
    setIsEventSubmitting(true);
    let payment_url = "";

    try {
      if (eventPaymentImage) {
        const fileExt = eventPaymentImage.name.split(".").pop();
        const fileName = `${Date.now()}_${Math.random().toString(36).substring(7)}.${fileExt}`;

        const { error: uploadError } = await supabase.storage
          .from("event-payments")
          .upload(fileName, eventPaymentImage);

        if (uploadError) throw uploadError;

        const {
          data: { publicUrl },
        } = supabase.storage.from("event-payments").getPublicUrl(fileName);

        payment_url = publicUrl;
      }

      const { error } = await supabase.from("event_registrations").insert({
        project_id: project.id,
        payment_screenshot_url: payment_url,
        ...eventForm,
      });
      if (error) throw error;

      alert("Registration submitted successfully!");
      setEventForm({
        full_name: "",
        whatsapp_number: "",
        age: "",
        address: "",
        sangh_name: "",
      });
      setEventPaymentImage(null);

      // Clear file input manually if needed (optional)
      const fileInput = document.getElementById("event-payment-upload");
      if (fileInput) fileInput.value = "";
    } catch (error) {
      console.error("Event Registration Error:", error);
      alert("Failed to submit registration.");
    } finally {
      setIsEventSubmitting(false);
    }
  };

  if (loading) return <LoadingSpinner />;
  if (!project) return <div className="p-10 text-center">Pod not found</div>;

  // --- RENDER FOR STATIC JSON PROJECTS ---
  if (project.type === "static") {
    const gallery = getGalleryImages();
    return (
      <div className="px-6 py-8 font-serif max-w-7xl mx-auto">
        <button
          onClick={() => navigate(-1)}
          className="text-[#ae2b2b] mb-6 font-semibold hover:underline flex items-center gap-2"
        >
          <ArrowLeft size={18} /> Back
        </button>

        <div className="grid md:grid-cols-2 gap-8">
          <img
            src={getThumb(project.image)}
            className="w-full h-80 rounded-2xl object-cover shadow-xl"
            alt={project.title}
          />
          <div>
            <h1 className="text-4xl font-bold text-[#ae2b2b] mb-3">
              {project.title}
            </h1>
            <p className="text-gray-500 mb-4">{project.date}</p>
            <span
              className={`px-3 py-1 text-xs rounded-full ${project.status === "Ongoing" ? "bg-green-100 text-green-700" : "bg-gray-200 text-gray-700"}`}
            >
              {project.status}
            </span>
            <p className="mt-6 text-gray-700 leading-relaxed text-lg">
              {project.description}
            </p>

            <div className="flex flex-wrap gap-3 mt-8">
              {project.link && (
                <Link
                  to={`/form?formLink=${encodeURIComponent(project.link)}`}
                  target="_blank"
                >
                  <Button className="bg-[#ae2b2b] hover:bg-[#912323]">
                    Open Form / Link
                  </Button>
                </Link>
              )}
              {project.feedback && (
                <Link
                  to={`/form?formLink=${encodeURIComponent(project.feedback)}`}
                  target="_blank"
                >
                  <Button
                    variant="outline"
                    className="text-[#ae2b2b] border-[#ae2b2b]"
                  >
                    Share Feedback
                  </Button>
                </Link>
              )}
            </div>
          </div>
        </div>

        {gallery.length > 0 && (
          <>
            <h2 className="mt-16 mb-6 text-2xl font-bold text-[#ae2b2b]">
              Pod Gallery
            </h2>
            <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-4">
              {gallery.map((img, i) => (
                <img
                  key={i}
                  src={img}
                  className="rounded-xl object-cover h-48 w-full shadow hover:scale-105 transition duration-300"
                  alt="Gallery"
                />
              ))}
            </div>
          </>
        )}

        <ProjectFeedbackSection
          project={{
            ...project,
            id: project.id || "134f3fc8-8546-4bb3-b39a-e671bfcb0808",
          }}
          testimonials={dbTestimonials}
          onFeedbackAdded={(newFb) =>
            setDbTestimonials((prev) => [newFb, ...prev])
          }
        />
      </div>
    );
  }

  // --- RENDER FOR DYNAMIC DB PROJECTS ---
  return (
    <div className="min-h-screen bg-gray-50/50 pb-20">
      {/* Hero Banner */}
      <div className="max-w-7xl mx-auto px-6 py-8">
        <button
          onClick={() => navigate("/projects")}
          className="text-[#ae2b2b] mb-6 font-semibold hover:underline flex items-center gap-2"
        >
          <ArrowLeft size={18} /> Back to Pods
        </button>

        {/* Simple Banner Image */}
        <div className="w-full h-64 md:h-96 rounded-2xl overflow-hidden shadow-md mb-8 bg-gray-100">
          {project.banner_url ? (
            <img
              src={project.banner_url}
              alt={project.title}
              className="w-full h-full object-cover"
            />
          ) : (
            <div className="w-full h-full flex items-center justify-center text-gray-400 bg-gray-200">
              No Banner Image
            </div>
          )}
        </div>

        {/* Header Section */}
        <div className="mb-8">
          <div className="flex flex-wrap items-center gap-3 mb-4">
            <span
              className={`px-3 py-1 text-xs font-bold rounded-full uppercase tracking-wider shadow-sm ${
                project.status === "active"
                  ? "bg-green-100 text-green-700"
                  : project.status === "completed"
                    ? "bg-gray-100 text-gray-700"
                    : "bg-[#ae2b2b]/10 text-[#ae2b2b]"
              }`}
            >
              {project.status || "Upcoming"}
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
            <h2 className="text-2xl font-bold text-gray-800 mb-4 font-serif">
              About Pod
            </h2>
            <div className="prose prose-red max-w-none text-gray-600 leading-relaxed whitespace-pre-line">
              {project.description}
            </div>
          </div>

          {subpods.length > 0 && (
            <div className="bg-white rounded-2xl p-8 shadow-sm border border-gray-100 mt-8">
              <h2 className="text-2xl font-bold text-gray-800 mb-4 font-serif">
                Shibirs & Sub-Pods
              </h2>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                {subpods.map((sub) => (
                  <Link
                    key={sub.id}
                    to={`/project/${sub.id}`}
                    className="block border rounded-xl p-4 hover:shadow-md transition-shadow hover:border-[#ae2b2b]/50 group"
                  >
                    <h3 className="font-bold text-[#ae2b2b] text-lg group-hover:underline">
                      {sub.title}
                    </h3>
                    <p className="text-gray-600 text-sm mt-1">
                      {sub.description?.substring(0, 100)}
                      {sub.description?.length > 100 ? "..." : ""}
                    </p>
                  </Link>
                ))}
              </div>
            </div>
          )}

          {/* Upcoming Schedule for REVA or Kiva */}
          {(project.project_code === "PRJ-010" ||
            project.project_code === "PRJ-009") && (
            <div className="bg-white rounded-2xl p-8 shadow-sm border border-gray-100 mt-8 font-sans">
              <h2 className="text-2xl font-bold text-gray-800 mb-4 font-serif flex items-center gap-2">
                <Calendar className="text-[#ae2b2b] w-6 h-6" /> Upcoming
                Schedule
              </h2>
              {(project.project_code === "PRJ-010"
                ? revaSessions
                : kivaSessions
              ).length === 0 ? (
                <p className="text-gray-500 bg-gray-50 p-6 rounded-xl text-center border border-dashed border-gray-200 text-sm">
                  No sessions scheduled currently.
                </p>
              ) : (
                <div className="overflow-x-auto border border-gray-200 rounded-xl shadow-sm">
                  <table className="w-full text-left border-collapse">
                    <thead>
                      <tr className="bg-gray-50 border-b border-gray-200 text-xs uppercase tracking-wider text-[#ae2b2b] font-bold">
                        <th className="p-4">Date</th>
                        <th className="p-4">Time</th>
                        <th className="p-4">Venue</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100">
                      {(project.project_code === "PRJ-010"
                        ? revaSessions
                        : kivaSessions
                      ).map((session) => {
                        const formatTime12h = (timeStr) => {
                          if (!timeStr) return "";
                          const [hours, minutes] = timeStr.split(":");
                          const h = parseInt(hours, 10);
                          const ampm = h >= 12 ? "PM" : "AM";
                          const h12 = h % 12 || 12;
                          return `${h12}:${minutes} ${ampm}`;
                        };
                        return (
                          <tr
                            key={session.id}
                            className="hover:bg-[#ae2b2b]/5 transition-colors text-sm"
                          >
                            <td className="p-4 whitespace-nowrap text-gray-900 font-medium">
                              <div className="flex items-center gap-2">
                                <Calendar className="h-4 w-4 text-[#ae2b2b]/70" />
                                {new Date(session.date).toLocaleDateString(
                                  "en-IN",
                                  {
                                    day: "numeric",
                                    month: "long",
                                    year: "numeric",
                                  },
                                )}
                              </div>
                            </td>
                            <td className="p-4 whitespace-nowrap text-gray-600">
                              <div className="flex items-center gap-2">
                                <Clock className="h-4 w-4 text-gray-400" />
                                {formatTime12h(session.time)}
                              </div>
                            </td>
                            <td className="p-4 text-gray-700">
                              <div className="flex items-start gap-2">
                                <MapPin className="h-4 w-4 text-gray-400 shrink-0 mt-0.5" />
                                {session.venue}
                              </div>
                            </td>
                          </tr>
                        );
                      })}
                    </tbody>
                  </table>
                </div>
              )}
            </div>
          )}

          {/* Manager & Sub-Heads Contact Card */}
          {isLoggedIn &&
            (project.manager ||
              (project.display_sub_heads && subHeads.length > 0)) && (
              <div className="bg-linear-to-br from-[#ae2b2b]/5 to-white rounded-2xl p-6 border border-[#ae2b2b]/10 shadow-sm space-y-6">
                {project.manager && (
                  <div className="flex flex-col md:flex-row gap-6 items-start md:items-center">
                    <div className="bg-[#ae2b2b]/10 p-4 rounded-full text-[#ae2b2b] shrink-0">
                      <User size={32} />
                    </div>
                    <div className="flex-1">
                      <p className="text-xs font-bold text-[#ae2b2b] uppercase tracking-widest mb-1">
                        Pod Head / Manager
                      </p>
                      <h3 className="text-xl font-semibold text-gray-900">
                        {project.manager.first_name} {project.manager.last_name}
                      </h3>
                      <p className="text-sm text-gray-500 mb-3">
                        {project.manager.ilj_id}
                      </p>

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

                {project.display_sub_heads && subHeads.length > 0 && (
                  <div className="border-t border-gray-100 pt-6">
                    <p className="text-xs font-bold text-[#ae2b2b] uppercase tracking-widest mb-3">
                      Pod Sub-Heads
                    </p>
                    <div className="grid gap-4 sm:grid-cols-2">
                      {subHeads.map((sh) => (
                        <div
                          key={sh.id}
                          className="bg-white p-4 rounded-xl border border-gray-200 flex items-center gap-3"
                        >
                          <div className="bg-gray-100 text-gray-600 w-10 h-10 rounded-full flex items-center justify-center font-bold text-sm shrink-0">
                            {sh.first_name[0]}
                            {sh.last_name[0]}
                          </div>
                          <div className="min-w-0">
                            <p className="font-semibold text-gray-900 truncate">
                              {sh.first_name} {sh.last_name}
                            </p>
                            <p className="text-xs text-gray-500 font-mono">
                              {sh.ilj_id}
                            </p>
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            )}

          {/* Upcoming Event Registration / Exhibition Banner */}
          {((project.is_event_registration_enabled && project.next_event_date) ||
            project.project_code === "PRJ-003" ||
            project.title?.toLowerCase().includes("jainific")) && (
            <div className="bg-white rounded-2xl p-6 sm:p-8 shadow-sm border border-l-4 border-l-[#ae2b2b]">
              <div className="flex items-center justify-between gap-3 mb-4 border-b border-gray-100 pb-3">
                <h2 className="text-xl sm:text-2xl font-bold text-[#ae2b2b] font-serif flex items-center gap-2">
                  <Calendar className="text-[#ae2b2b] w-5 h-5 sm:w-6 sm:h-6" />
                  {project.project_code === "PRJ-003" || project.title?.toLowerCase().includes("jainific")
                    ? "Upcoming Exhibition Details"
                    : "Upcoming Event Registration"}
                </h2>
                {(project.project_code === "PRJ-003" || project.title?.toLowerCase().includes("jainific")) && (
                  <span className="text-xs bg-amber-100 text-amber-800 font-bold px-3 py-1 rounded-full uppercase tracking-wider">
                    Jainific 3.0
                  </span>
                )}
              </div>

              <div className="flex flex-col lg:flex-row items-start lg:items-center justify-between gap-6 p-4 sm:p-5 bg-gradient-to-br from-gray-50 to-amber-50/20 rounded-xl border border-gray-200">
                <div className="flex-1 space-y-4">
                  {project.project_code === "PRJ-003" || project.title?.toLowerCase().includes("jainific") ? (
                    <div>
                      <h3 className="font-bold text-gray-900 text-lg sm:text-xl font-serif">
                        Jainific 3.0 Malad — A Scientific Lens
                      </h3>
                      <p className="text-gray-600 text-xs sm:text-sm mt-1">
                        An interactive exhibition connecting ancient Jain Agamic science with modern physics, biology, and psychology.
                      </p>
                      <div className="flex flex-wrap items-center gap-x-6 gap-y-2 text-gray-700 mt-3 text-sm">
                        <div className="flex items-center gap-2">
                          <MapPin className="w-4 h-4 text-[#ae2b2b] shrink-0" />
                          <a
                            href="https://maps.google.com/?q=MKES+Law+College+SV+Road+Malad+West"
                            target="_blank"
                            rel="noopener noreferrer"
                            className="font-medium hover:text-[#ae2b2b] hover:underline transition-colors"
                          >
                            MKES Law College, N.K. College Campus, SV Road, Malad (West)
                          </a>
                        </div>
                        <div className="flex items-center gap-2">
                          <Clock className="w-4 h-4 text-[#ae2b2b] shrink-0" />
                          <span className="font-medium text-gray-800">11:00 AM to 8:00 PM</span>
                        </div>
                      </div>
                    </div>
                  ) : project.project_code === "PRJ-008" ? (
                    <div>
                      <h3 className="font-bold text-gray-900 text-lg">
                        Reflect: Look Beyond your Version
                      </h3>
                      <div className="flex items-center gap-2 text-gray-700 mt-2">
                        <MapPin className="w-5 h-5 text-[#ae2b2b]" />
                        <a
                          href="https://maps.google.com/?q=Aspee+Auditorium+Malad+West"
                          target="_blank"
                          rel="noopener noreferrer"
                          className="font-medium hover:text-[#ae2b2b] hover:underline transition-colors"
                        >
                          Aspee Auditorium, Malad (West)
                        </a>
                      </div>
                    </div>
                  ) : project.project_code === "PRJ-002" ? (
                    <div>
                      <h3 className="font-bold text-gray-900 text-lg">
                        VEER VANSHAJ 4.0 – BECOME UNSTOPPABLE!
                      </h3>
                      <div className="flex items-center gap-2 text-gray-700 mt-2">
                        <MapPin className="w-5 h-5 text-[#ae2b2b]" />
                        <a
                          href="https://maps.google.com/?q=StarOm+Sejal+Opp+Malad+Gymkhana+Nr+Aspee+Auditorium+Marve+Road+Malad+West"
                          target="_blank"
                          rel="noopener noreferrer"
                          className="font-medium hover:text-[#ae2b2b] hover:underline transition-colors"
                        >
                          Terrace Area, StarOm Sejal, Opp Malad Gymkhana, Nr Aspee Auditorium, Marve Road, Malad W
                        </a>
                      </div>
                    </div>
                  ) : null}

                  <div>
                    <p className="text-xs font-bold text-gray-500 uppercase tracking-widest mb-1">
                      Event Date & Timing
                    </p>
                    <p className="text-lg sm:text-xl font-bold text-gray-900">
                      {project.project_code === "PRJ-003" || project.title?.toLowerCase().includes("jainific")
                        ? "📅 1st November 2026 | ⏰ 11:00 AM to 8:00 PM"
                        : project.project_code === "PRJ-008"
                        ? "Sundays in August 2026 (2nd, 9th, 16th, 23rd, 30th)"
                        : project.next_event_date}
                    </p>
                  </div>
                </div>

                <div className="shrink-0 w-full sm:w-auto flex flex-col sm:flex-row lg:flex-col gap-2.5">
                  {project.project_code === "PRJ-003" || project.title?.toLowerCase().includes("jainific") ? (
                    <>
                      <Button
                        onClick={() => setFeedbackOpenRequest((request) => request + 1)}
                        className="bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white px-6 py-2.5 rounded-xl font-bold border-0 cursor-pointer shadow-md hover:shadow-lg transition-all"
                      >
                        <MessageSquare className="w-4 h-4 mr-1.5" /> Share Feedback
                      </Button>
                      <Button
                        variant="outline"
                        onClick={() => navigate("/sources")}
                        className="border-[#ae2b2b]/30 text-[#ae2b2b] hover:bg-[#ae2b2b]/10 px-5 py-2.5 rounded-xl font-medium cursor-pointer"
                      >
                        10 Scriptural Exhibits →
                      </Button>
                    </>
                  ) : (
                    <Link
                      to={
                        project.project_code === "PRJ-008"
                          ? "/projects/e65d8362-e612-4217-b769-cf74719c8d5a/event-registration"
                          : `/projects/${project.id}/event-registration`
                      }
                    >
                      <Button className="bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white px-8 py-2 border-0 cursor-pointer">
                        Click to Register
                      </Button>
                    </Link>
                  )}
                </div>
              </div>
            </div>
          )}
        </div>

        {/* Right Column: Actions */}
        <div className="space-y-6 sticky top-24 h-fit">
          {/* Shibir Links */}
          {(project.registration_link || project.qna_link) && (
            <div className="bg-white rounded-2xl p-6 shadow-md border-t-4 border-[#ae2b2b]">
              <h3 className="text-lg font-bold text-gray-900 mb-4 font-serif">
                Shibir Registration & Info
              </h3>
              <div className="space-y-3">
                {project.registration_link && (
                  <Link
                    to={`/projects/${project.id}/event-registration`}
                    className="block"
                  >
                    <Button className="w-full bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white shadow-md">
                      Register for Shibir
                    </Button>
                  </Link>
                )}
                {project.qna_link && (
                  <Button
                    variant="outline"
                    onClick={() => setIsQnaOpen(true)}
                    className="w-full text-[#ae2b2b] border-[#ae2b2b] hover:bg-red-50"
                  >
                    Submit your QnA
                  </Button>
                )}
              </div>
            </div>
          )}

          {project.project_code === "PRJ-009" ? (
            <KivaRegForm projectId={project.id} />
          ) : (
            <div className="bg-white rounded-2xl p-6 shadow-md border-t-4 border-[#ae2b2b]">
              <h3 className="text-lg font-bold text-gray-900 mb-4 font-serif">
                Join the Mission
              </h3>

              {!isLoggedIn ? (
                <div className="text-center py-4 bg-gray-50 rounded-xl border border-dashed border-gray-300">
                  <Shield className="w-10 h-10 text-gray-400 mx-auto mb-2" />
                  <Link to="/?login=true" className="block group">
                    <p className="text-gray-600 mb-3 group-hover:text-[#ae2b2b] transition-colors font-medium">
                      Please login to apply for this project.
                    </p>
                    <Button variant="outline">Login to Apply</Button>
                  </Link>
                </div>
              ) : (
                <div>
                  {applicationStatus === "approved" ? (
                    <div className="bg-green-50 border border-green-200 rounded-xl p-4 text-center">
                      <div className="mx-auto w-12 h-12 bg-green-100 rounded-full flex items-center justify-center mb-2">
                        <CheckCircle className="w-6 h-6 text-green-600" />
                      </div>
                      <h4 className="font-bold text-green-800">
                        You are a Member!
                      </h4>
                      <p className="text-sm text-green-600 mt-1">
                        Check your dashboard for tasks.
                      </p>
                    </div>
                  ) : applicationStatus === "pending" ? (
                    <div className="bg-[#ae2b2b]/5 border border-[#ae2b2b]/20 rounded-xl p-4 text-center">
                      <div className="mx-auto w-12 h-12 bg-[#ae2b2b]/10 rounded-full flex items-center justify-center mb-2">
                        <Clock className="w-6 h-6 text-[#ae2b2b]" />
                      </div>
                      <h4 className="font-bold text-[#ae2b2b]">
                        Request Pending
                      </h4>
                      <p className="text-sm text-[#ae2b2b] mt-1">
                        Approval sent to manager.
                      </p>
                    </div>
                  ) : (
                    <div className="space-y-3">
                      <p className="text-sm text-gray-600 mb-4">
                        Ready to contribute? Click below to request to join this
                        pod team.
                      </p>
                      <Button
                        onClick={handleApply}
                        disabled={isApplying}
                        className="w-full bg-[#ae2b2b] hover:bg-[#8f1f1f] text-lg py-6 shadow-lg shadow-red-100"
                      >
                        {isApplying
                          ? "Applying..."
                          : "I'm Interested to Volunteer"}
                      </Button>
                    </div>
                  )}
                </div>
              )}
            </div>
          )}

          {/* Organize & Feedback Actions */}
          <div className="bg-white rounded-2xl p-6 shadow-md border border-gray-100 space-y-4">
            <h3 className="text-lg font-bold text-gray-900 mb-2 font-serif">
              More Actions
            </h3>

            {project.project_code !== "PRJ-009" && (
              <Button
                variant="outline"
                onClick={() => setIsInquiryOpen(true)}
                className="w-full justify-start text-gray-700 hover:text-[#ae2b2b] hover:border-[#ae2b2b]"
              >
                <MapPin className="mr-2 h-4 w-4" /> Organize in your area
              </Button>
            )}

            <Button
              variant="outline"
              onClick={() => setIsFeedbackOpen(true)}
              className="w-full justify-start text-gray-700 hover:text-[#ae2b2b] hover:border-[#ae2b2b] cursor-pointer"
            >
              <MessageSquare className="mr-2 h-4 w-4" /> Share Feedback
            </Button>

            {(project.project_code === "PRJ-008-02" || project.project_code === "PRJ-008") && (
              <Button
                variant="outline"
                onClick={() => navigate("/reflect-questions")}
                className="w-full justify-start text-[#ae2b2b] border-[#ae2b2b]/30 bg-[#ae2b2b]/5 hover:bg-[#ae2b2b]/10 font-semibold cursor-pointer"
              >
                <HelpCircle className="mr-2 h-4 w-4 text-[#ae2b2b]" /> Ask Workshop Question
              </Button>
            )}
          </div>
        </div>
      </div>

      {/* Database Gallery & Testimonials */}
      <div className="max-w-7xl mx-auto px-6 mt-12 grid grid-cols-1 gap-12">
        {dbGallery.length > 0 && (
          <div className="w-full relative px-2 sm:px-6 md:px-12">
            <h2 className="text-2xl font-bold text-gray-900 mb-6 font-serif border-b pb-4">
              Pod Gallery
            </h2>
            <Carousel
              opts={{
                align: "start",
                loop: true,
              }}
              plugins={[
                Autoplay({
                  delay: 3000,
                  stopOnInteraction: false,
                  stopOnMouseEnter: true,
                }),
              ]}
              className="w-full"
            >
              <CarouselContent className="-ml-2 sm:-ml-4">
                {dbGallery.map((img, i) => (
                  <CarouselItem
                    key={i}
                    className="pl-2 sm:pl-4 basis-full sm:basis-1/2 lg:basis-1/3 xl:basis-1/4"
                  >
                    <Dialog>
                      <DialogTrigger asChild>
                        <div className="p-1 cursor-pointer overflow-hidden rounded-xl">
                          <img
                            src={img}
                            className="rounded-xl object-cover h-48 sm:h-48 w-full shadow hover:scale-105 transition duration-300"
                            alt={`Gallery ${i}`}
                          />
                        </div>
                      </DialogTrigger>
                      <DialogContent className="max-w-4xl p-1 bg-transparent border-none shadow-none flex items-center justify-center">
                        <DialogTitle className="sr-only">
                          Project Photo {i + 1}
                        </DialogTitle>
                        <img
                          src={img}
                          alt={`Gallery ${i} Full`}
                          className="w-full max-h-[85vh] object-contain rounded-md"
                        />
                      </DialogContent>
                    </Dialog>
                  </CarouselItem>
                ))}
              </CarouselContent>
              <CarouselPrevious className="hidden md:flex bg-white/80 hover:bg-white border-none shadow-md -left-6 lg:-left-12" />
              <CarouselNext className="hidden md:flex bg-white/80 hover:bg-white border-none shadow-md -right-6 lg:-right-12" />
            </Carousel>
          </div>
        )}

        <ProjectFeedbackSection
          project={project}
          testimonials={dbTestimonials}
          openFormRequest={feedbackOpenRequest}
          defaultOpenForm={
            new URLSearchParams(location.search).get("open") === "feedback" ||
            new URLSearchParams(location.search).get("feedback") === "true" ||
            location.pathname.includes("feedback")
          }
          onFeedbackAdded={(newFb) =>
            setDbTestimonials((prev) => [newFb, ...prev])
          }
        />
      </div>

      {project.project_code === "PRJ-001" && (
        <div className="mt-12 w-full max-w-7xl mx-auto px-6">
          <h2 className="text-2xl font-bold text-gray-900 mb-6 font-serif border-b pb-4">
            Instagram Reels
          </h2>
          <div className="bg-white rounded-2xl p-6 shadow-sm">
            <Instagram />
          </div>
        </div>
      )}

      {/* Inquiry Modal */}
      {isInquiryOpen && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50 backdrop-blur-sm">
          <div className="bg-white rounded-2xl p-6 w-full max-w-md shadow-2xl relative max-h-[90vh] overflow-y-auto custom-scrollbar">
            <button
              onClick={() => setIsInquiryOpen(false)}
              className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"
            >
              <X className="h-5 w-5" />
            </button>
            <h3 className="text-xl font-bold text-gray-900 mb-1">
              Organize Pod
            </h3>
            <p className="text-sm text-gray-500 mb-4">
              Interested in bringing this pod to your area? Let us know!
            </p>

            <form onSubmit={handleInquirySubmit} className="space-y-4">
              <input
                type="text"
                placeholder="Your Name"
                required
                className="w-full p-3 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none"
                value={inquiryForm.name}
                onChange={(e) =>
                  setInquiryForm({ ...inquiryForm, name: e.target.value })
                }
              />
              <input
                type="tel"
                placeholder="Contact Number"
                required
                className="w-full p-3 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none"
                value={inquiryForm.mobile}
                onChange={(e) =>
                  setInquiryForm({ ...inquiryForm, mobile: e.target.value })
                }
              />

              {project?.project_code === "PRJ-002" ||
              project?.project_code === "PRJ-003" ? (
                <>
                  <input
                    type="text"
                    placeholder="Name of Sangh"
                    required
                    className="w-full p-3 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none"
                    value={inquiryForm.sangh_name}
                    onChange={(e) =>
                      setInquiryForm({
                        ...inquiryForm,
                        sangh_name: e.target.value,
                      })
                    }
                  />
                  <textarea
                    placeholder="Address of Sangh"
                    required
                    rows="2"
                    className="w-full p-3 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none"
                    value={inquiryForm.sangh_address}
                    onChange={(e) =>
                      setInquiryForm({
                        ...inquiryForm,
                        sangh_address: e.target.value,
                      })
                    }
                  />
                  {project?.project_code === "PRJ-002" && (
                    <input
                      type="text"
                      placeholder="Proposed dates and timing"
                      required
                      className="w-full p-3 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none"
                      value={inquiryForm.proposed_dates}
                      onChange={(e) =>
                        setInquiryForm({
                          ...inquiryForm,
                          proposed_dates: e.target.value,
                        })
                      }
                    />
                  )}
                  <textarea
                    placeholder={
                      project?.project_code === "PRJ-003"
                        ? "Address of proposed venue for exhibition"
                        : "Address of proposed venue for workshop"
                    }
                    required
                    rows="2"
                    className="w-full p-3 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none"
                    value={inquiryForm.proposed_venue}
                    onChange={(e) =>
                      setInquiryForm({
                        ...inquiryForm,
                        proposed_venue: e.target.value,
                      })
                    }
                  />
                  <textarea
                    placeholder={`How did you come to know about ${project?.project_code === "PRJ-003" ? "Jainific" : "Veer Vanshaj Self Defence Workshop"}?`}
                    required
                    rows="2"
                    className="w-full p-3 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none"
                    value={inquiryForm.how_did_you_know}
                    onChange={(e) =>
                      setInquiryForm({
                        ...inquiryForm,
                        how_did_you_know: e.target.value,
                      })
                    }
                  />
                </>
              ) : (
                <>
                  <input
                    type="email"
                    placeholder="Email Address"
                    required
                    className="w-full p-3 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none"
                    value={inquiryForm.email}
                    onChange={(e) =>
                      setInquiryForm({ ...inquiryForm, email: e.target.value })
                    }
                  />
                  <textarea
                    placeholder="Message (Location, estimated participants, etc.)"
                    required
                    rows="3"
                    className="w-full p-3 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none"
                    value={inquiryForm.message}
                    onChange={(e) =>
                      setInquiryForm({
                        ...inquiryForm,
                        message: e.target.value,
                      })
                    }
                  ></textarea>
                </>
              )}

              <Button
                type="submit"
                disabled={submitting}
                className="w-full bg-[#ae2b2b] hover:bg-[#912323]"
              >
                {submitting ? "Sending..." : "Send Inquiry"}
              </Button>
            </form>
          </div>
        </div>
      )}

      {/* QnA Modal */}
      {isQnaOpen && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50 backdrop-blur-sm">
          <div className="bg-white rounded-2xl p-6 w-full max-w-md shadow-2xl relative max-h-[90vh] overflow-y-auto custom-scrollbar">
            <button
              onClick={() => setIsQnaOpen(false)}
              className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"
            >
              <X className="h-5 w-5" />
            </button>
            <h3 className="text-xl font-bold text-gray-900 mb-1">
              Submit your QnA
            </h3>
            <p className="text-sm text-gray-500 mb-4">
              Have a question? We will address it during the Shibir.
            </p>

            <form onSubmit={handleQnaSubmit} className="space-y-4">
              <input
                type="text"
                placeholder="Your Name"
                required
                className="w-full p-3 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none"
                value={qnaForm.name}
                onChange={(e) =>
                  setQnaForm({ ...qnaForm, name: e.target.value })
                }
              />
              <input
                type="tel"
                placeholder="Contact Number"
                required
                className="w-full p-3 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none"
                value={qnaForm.mobile}
                onChange={(e) =>
                  setQnaForm({ ...qnaForm, mobile: e.target.value })
                }
              />
              <input
                type="email"
                placeholder="Email Address"
                required
                className="w-full p-3 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none"
                value={qnaForm.email}
                onChange={(e) =>
                  setQnaForm({ ...qnaForm, email: e.target.value })
                }
              />
              <textarea
                placeholder="Your Question / Query"
                required
                rows="4"
                className="w-full p-3 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none"
                value={qnaForm.message}
                onChange={(e) =>
                  setQnaForm({ ...qnaForm, message: e.target.value })
                }
              ></textarea>

              <Button
                type="submit"
                disabled={submitting}
                className="w-full bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white"
              >
                {submitting ? "Submitting..." : "Submit Question"}
              </Button>
            </form>
          </div>
        </div>
      )}

      {/* Feedback Modal */}
      {isFeedbackOpen && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-3 sm:p-4 z-50 backdrop-blur-sm overflow-y-auto">
          <div className="w-full max-w-md max-h-[90vh] overflow-y-auto custom-scrollbar rounded-3xl border border-white/60 bg-white shadow-[0_24px_80px_rgba(0,0,0,0.24)] relative my-auto">
            <div className="absolute inset-x-0 top-0 h-1 bg-linear-to-r from-[#ae2b2b] via-[#d66b3a] to-amber-400" />
            <div className="absolute -right-16 -top-16 h-40 w-40 rounded-full bg-[#ae2b2b]/8 blur-3xl pointer-events-none" />
            <div className="p-6 sm:p-7 relative">
              <button
                onClick={() => setIsFeedbackOpen(false)}
                className="absolute right-4 top-4 rounded-full p-2 text-gray-400 transition-colors hover:bg-gray-100 hover:text-gray-700"
              >
                <X className="h-5 w-5" />
              </button>
              <div className="mb-5 pr-10">
                <span className="inline-flex items-center rounded-full bg-[#ae2b2b]/10 px-3 py-1 text-[11px] font-bold uppercase tracking-[0.18em] text-[#ae2b2b]">
                  {project?.project_code === "PRJ-003" || project?.title?.toLowerCase().includes("jainific")
                    ? "Jainific 3.0 Feedback"
                    : "Project Feedback"}
                </span>
                <h3 className="mt-3 text-2xl font-bold text-gray-900">
                  {project?.project_code === "PRJ-003" || project?.title?.toLowerCase().includes("jainific")
                    ? "Share Feedback for Jainific 3.0"
                    : "Share Feedback"}
                </h3>
                {(project?.project_code === "PRJ-003" || project?.title?.toLowerCase().includes("jainific")) ? (
                  <div className="mt-2 text-xs bg-amber-50 border border-amber-200/60 p-2.5 rounded-xl text-amber-900 font-medium">
                    📅 1st November 2026 | ⏰ 11 AM to 8 PM <br />
                    📍 MKES Law College, N.K. College Campus, SV Road, Malad (West)
                  </div>
                ) : (
                  <p className="mt-1 text-sm leading-6 text-gray-500">
                    Tell us what stood out and how we can make the experience better.
                  </p>
                )}
              </div>

              <form onSubmit={handleFeedbackSubmit} className="space-y-4">
                {!(project?.project_code === "PRJ-003" || project?.title?.toLowerCase().includes("jainific")) && (
                  <div>
                    <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-1">
                      Select Shibir Session{" "}
                      <span className="text-gray-400 font-normal lowercase">
                        (optional)
                      </span>
                    </label>
                    <select
                      value={feedbackForm.session}
                      onChange={(e) =>
                        setFeedbackForm({
                          ...feedbackForm,
                          session: e.target.value,
                        })
                      }
                      className="w-full p-3 border border-gray-200 rounded-xl bg-gray-50/50 focus:bg-white focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] outline-none text-sm font-medium"
                    >
                      <option value="">
                        -- All Sessions / General Feedback --
                      </option>
                      {SHIBIR_SESSIONS.map((sess) => (
                        <option key={sess} value={sess}>
                          {sess}
                        </option>
                      ))}
                    </select>
                  </div>
                )}

                <div>
                  <div className="flex items-center justify-between gap-3 mb-2">
                    <label className="block text-sm font-medium text-gray-700">
                      Rating
                    </label>
                    <span className="rounded-full bg-amber-50 px-3 py-1 text-xs font-semibold text-amber-700">
                      {feedbackForm.rating}/5{" "}
                      {ratingLabels[feedbackForm.rating - 1]}
                    </span>
                  </div>
                  <div className="rounded-2xl border border-amber-100 bg-linear-to-b from-amber-50/70 to-white p-3 shadow-sm">
                    <div className="grid grid-cols-5 gap-2">
                      {[1, 2, 3, 4, 5].map((star) => (
                        <button
                          key={star}
                          type="button"
                          onClick={() =>
                            setFeedbackForm({ ...feedbackForm, rating: star })
                          }
                          aria-label={`Set rating to ${star} star${star > 1 ? "s" : ""}`}
                          aria-pressed={feedbackForm.rating >= star}
                          className={`group flex flex-col items-center justify-center gap-1 rounded-2xl border px-2 py-3 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 ${feedbackForm.rating >= star ? "border-amber-200 bg-white text-amber-400 shadow-md shadow-amber-100/60 scale-[1.03]" : "border-transparent bg-transparent text-gray-300 hover:border-amber-100 hover:bg-white hover:text-amber-300 hover:shadow-sm"}`}
                        >
                          <Star
                            className={`h-7 w-7 fill-current transition-all duration-200 ${feedbackForm.rating >= star ? "drop-shadow-sm" : "group-hover:scale-110"}`}
                          />
                          <span
                            className={`text-[11px] font-semibold tracking-wide transition-colors ${feedbackForm.rating >= star ? "text-amber-700" : "text-gray-400 group-hover:text-amber-500"}`}
                          >
                            {star}
                          </span>
                        </button>
                      ))}
                    </div>
                  </div>
                  <p className="mt-2 text-xs text-gray-500">
                    Tap a star to set your overall experience.
                  </p>
                </div>

                <label className="flex items-center gap-2 text-sm text-gray-600 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={feedbackForm.is_anonymous}
                    onChange={(e) =>
                      setFeedbackForm({
                        ...feedbackForm,
                        is_anonymous: e.target.checked,
                      })
                    }
                    className="rounded border-gray-300 text-[#ae2b2b] focus:ring-[#ae2b2b]"
                  />
                  Submit Anonymously
                </label>

                {!feedbackForm.is_anonymous && (
                  <div className="space-y-3 animate-in fade-in slide-in-from-top-2">
                    <input
                      type="text"
                      placeholder="Full Name"
                      required
                      className="w-full p-3 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none text-sm"
                      value={feedbackForm.name}
                      onChange={(e) =>
                        setFeedbackForm({
                          ...feedbackForm,
                          name: e.target.value,
                        })
                      }
                    />
                    <div>
                      <input
                        type="number"
                        placeholder="Age"
                        className="w-full p-3 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none text-sm"
                        value={feedbackForm.age}
                        onChange={(e) =>
                          setFeedbackForm({
                            ...feedbackForm,
                            age: e.target.value,
                          })
                        }
                      />
                    </div>
                    {!(project?.project_code === "PRJ-003" || project?.title?.toLowerCase().includes("jainific")) && (
                      <>
                        <div className="grid grid-cols-2 gap-3">
                          <input
                            type="tel"
                            placeholder="Mobile Number"
                            className="w-full p-3 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none text-sm"
                            value={feedbackForm.mobile}
                            onChange={(e) =>
                              setFeedbackForm({
                                ...feedbackForm,
                                mobile: e.target.value,
                              })
                            }
                          />
                          <input
                            type="text"
                            placeholder="City"
                            className="w-full p-3 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none text-sm"
                            value={feedbackForm.city}
                            onChange={(e) =>
                              setFeedbackForm({
                                ...feedbackForm,
                                city: e.target.value,
                              })
                            }
                          />
                        </div>
                        <input
                          type="email"
                          placeholder="Email Address"
                          className="w-full p-3 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none text-sm"
                          value={feedbackForm.email}
                          onChange={(e) =>
                            setFeedbackForm({
                              ...feedbackForm,
                              email: e.target.value,
                            })
                          }
                        />
                      </>
                    )}
                  </div>
                )}

                <textarea
                  placeholder="Your comments or suggestions..."
                  required
                  rows="4"
                  className="w-full p-3 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none"
                  value={feedbackForm.comments}
                  onChange={(e) =>
                    setFeedbackForm({
                      ...feedbackForm,
                      comments: e.target.value,
                    })
                  }
                ></textarea>

                <Button
                  type="submit"
                  disabled={submitting}
                  className="w-full rounded-xl bg-linear-to-r from-[#ae2b2b] to-[#8f1f1f] py-6 text-base font-semibold shadow-lg shadow-red-100 transition-transform hover:scale-[1.01] hover:from-[#992727] hover:to-[#7f1919]"
                >
                  {submitting ? "Submitting..." : "Submit Feedback"}
                </Button>
              </form>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
