import { useState, useEffect, useMemo } from "react";
import { supabase } from "@/lib/supabase";
import {
  Heart,
  Search,
  Filter,
  Download,
  Trash2,
  Eye,
  CheckCircle2,
  X,
  FileSpreadsheet,
  Clock,
  User,
  Phone,
  Building2,
  Calendar,
  Sparkles,
  Award,
  ShieldCheck,
  RefreshCw,
  Home,
  Users
} from "lucide-react";
import * as XLSX from "xlsx";

const STATUS_COLORS = {
  submitted: "bg-blue-50 text-blue-700 border-blue-200",
  shortlisted: "bg-amber-50 text-amber-700 border-amber-200",
  verified: "bg-emerald-50 text-emerald-700 border-emerald-200",
  rejected: "bg-gray-100 text-gray-600 border-gray-200",
};

export default function AdminSamarpanam() {
  const [nominations, setNominations] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState("");
  const [statusFilter, setStatusFilter] = useState("all");
  const [selectedNomination, setSelectedNomination] = useState(null);
  const [adminNotes, setAdminNotes] = useState("");
  const [isSavingNotes, setIsSavingNotes] = useState(false);

  useEffect(() => {
    fetchNominations();
  }, []);

  const fetchNominations = async () => {
    setLoading(true);
    try {
      const { data, error } = await supabase
        .from("samarpanam_nominations")
        .select("*")
        .order("created_at", { ascending: false });

      if (error) throw error;
      setNominations(data || []);
    } catch (err) {
      console.error("Error fetching nominations:", err);
    } finally {
      setLoading(false);
    }
  };

  const handleStatusChange = async (id, newStatus) => {
    try {
      const { error } = await supabase
        .from("samarpanam_nominations")
        .update({ status: newStatus })
        .eq("id", id);

      if (error) throw error;

      setNominations((prev) =>
        prev.map((n) => (n.id === id ? { ...n, status: newStatus } : n))
      );

      if (selectedNomination && selectedNomination.id === id) {
        setSelectedNomination((prev) => ({ ...prev, status: newStatus }));
      }
    } catch (err) {
      console.error("Error updating status:", err);
      alert("Failed to update status.");
    }
  };

  const handleSaveNotes = async () => {
    if (!selectedNomination) return;
    setIsSavingNotes(true);
    try {
      const { error } = await supabase
        .from("samarpanam_nominations")
        .update({ admin_notes: adminNotes })
        .eq("id", selectedNomination.id);

      if (error) throw error;

      setNominations((prev) =>
        prev.map((n) => (n.id === selectedNomination.id ? { ...n, admin_notes: adminNotes } : n))
      );
      setSelectedNomination((prev) => ({ ...prev, admin_notes: adminNotes }));
      alert("Notes saved successfully.");
    } catch (err) {
      console.error("Error saving notes:", err);
      alert("Failed to save notes.");
    } finally {
      setIsSavingNotes(false);
    }
  };

  const handleDelete = async (id) => {
    if (!confirm("Are you sure you want to delete this nomination?")) return;
    try {
      const { error } = await supabase
        .from("samarpanam_nominations")
        .delete()
        .eq("id", id);

      if (error) throw error;

      setNominations((prev) => prev.filter((n) => n.id !== id));
      if (selectedNomination && selectedNomination.id === id) {
        setSelectedNomination(null);
      }
    } catch (err) {
      console.error("Error deleting nomination:", err);
      alert("Failed to delete nomination.");
    }
  };

  const handleExport = () => {
    const exportData = filteredNominations.map((n) => ({
      ID: n.id,
      Status: n.status || "submitted",
      Created_At: new Date(n.created_at).toLocaleString(),

      // Nominee
      Nominee_Name: n.nominee_name,
      Nominee_Mobile: n.nominee_mobile,
      Nominee_Age: n.nominee_age || "N/A",
      Nominee_Address: n.nominee_address,
      Nominee_Marital_Status: n.nominee_marital_status === "Other (Please Specify)" ? n.nominee_marital_status_other : n.nominee_marital_status,
      Wife_Name: n.nominee_wife_name,
      Wife_Mobile: n.nominee_wife_mobile || "N/A",

      // Seva
      Seva_Areas: Array.isArray(n.seva_areas) ? n.seva_areas.join(", ") : n.seva_areas,
      Seva_Areas_Other: n.seva_areas_other || "N/A",
      Associated_Sangh: n.sangh_name || "N/A",
      Sangh_Trustee_Contact: n.sangh_head_contact || "N/A",
      Involvement_Duration: n.involvement_duration,
      Hours_Per_Week: n.hours_per_week,
      Total_Hours_Till_Date: n.total_hours_till_date || "N/A",
      Contribution_Description: n.contribution_description,
      Significant_Achievements: n.initiatives_achievements || "N/A",

      // Wife's Support
      Wife_Support_Description: n.wife_support_description || "N/A",
      Wife_Incident_Story: n.wife_incident_story || "N/A",

      // Nominator
      Nominator_Name: n.nominator_name,
      Nominator_Mobile: n.nominator_mobile,
      Nominator_Age: n.nominator_age || "N/A",
      Nominator_Gender: n.nominator_gender || "N/A",
      Nominator_Address: n.nominator_address,
      Relationship: n.relationship_with_nominee === "Other (Please Specify)" ? n.relationship_other : n.relationship_with_nominee,

      // Admin
      Admin_Notes: n.admin_notes || "N/A",
    }));

    const ws = XLSX.utils.json_to_sheet(exportData);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, "Nominations");
    XLSX.writeFile(wb, `samarpanam_nominations_${new Date().toISOString().split("T")[0]}.xlsx`);
  };

  const openDetails = (nomination) => {
    setSelectedNomination(nomination);
    setAdminNotes(nomination.admin_notes || "");
  };

  const filteredNominations = useMemo(() => {
    return nominations.filter((n) => {
      const q = searchTerm.toLowerCase();
      const matchesSearch =
        (n.nominee_name && n.nominee_name.toLowerCase().includes(q)) ||
        (n.nominee_mobile && n.nominee_mobile.includes(q)) ||
        (n.nominee_wife_name && n.nominee_wife_name.toLowerCase().includes(q)) ||
        (n.nominator_name && n.nominator_name.toLowerCase().includes(q)) ||
        (n.nominator_mobile && n.nominator_mobile.includes(q)) ||
        (n.sangh_name && n.sangh_name.toLowerCase().includes(q));

      const matchesStatus =
        statusFilter === "all" || (n.status || "submitted") === statusFilter;

      return matchesSearch && matchesStatus;
    });
  }, [nominations, searchTerm, statusFilter]);

  const uniqueNomineesCount = useMemo(() => {
    const mobiles = new Set(nominations.map((n) => n.nominee_mobile));
    return mobiles.size;
  }, [nominations]);

  const shortlistedCount = useMemo(() => {
    return nominations.filter((n) => n.status === "shortlisted").length;
  }, [nominations]);

  return (
    <div className="space-y-6">

      {/* Header and Stats */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 border-b border-gray-200 pb-5">
        <div>
          <div className="flex items-center gap-2">
            <Heart className="h-6 w-6 text-[#ae2b2b] fill-[#ae2b2b]" />
            <h1 className="text-2xl font-bold text-gray-900 font-serif">
              SAMARPANAM Nominations
            </h1>
          </div>
          <p className="text-sm text-gray-500 mt-1">
            Honouring the Silent Strength Behind Shasan Seva — Review and manage submissions
          </p>
        </div>

        <div className="flex gap-2">
          <button
            onClick={fetchNominations}
            disabled={loading}
            className="flex items-center gap-1.5 px-3 py-2 border border-gray-200 bg-white hover:bg-gray-50 text-gray-700 rounded-lg text-xs font-semibold shadow-xs cursor-pointer"
          >
            <RefreshCw className={`h-3.5 w-3.5 ${loading ? "animate-spin" : ""}`} /> Refresh
          </button>
          <button
            onClick={handleExport}
            disabled={filteredNominations.length === 0}
            className="flex items-center gap-1.5 px-4 py-2 bg-green-600 hover:bg-green-700 text-white rounded-lg text-xs font-semibold shadow-xs transition cursor-pointer disabled:opacity-50"
          >
            <FileSpreadsheet className="h-4 w-4" /> Export Excel ({filteredNominations.length})
          </button>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="bg-white p-4 rounded-2xl border border-gray-100 shadow-xs">
          <span className="text-xs font-bold uppercase text-gray-400">Total Nominations</span>
          <p className="text-2xl font-bold text-gray-900 mt-1">{nominations.length}</p>
        </div>
        <div className="bg-white p-4 rounded-2xl border border-gray-100 shadow-xs">
          <span className="text-xs font-bold uppercase text-gray-400">Unique Shasan Sevaks</span>
          <p className="text-2xl font-bold text-[#ae2b2b] mt-1">{uniqueNomineesCount}</p>
        </div>
        <div className="bg-white p-4 rounded-2xl border border-gray-100 shadow-xs">
          <span className="text-xs font-bold uppercase text-gray-400">Shortlisted</span>
          <p className="text-2xl font-bold text-amber-600 mt-1">{shortlistedCount}</p>
        </div>
        <div className="bg-white p-4 rounded-2xl border border-gray-100 shadow-xs">
          <span className="text-xs font-bold uppercase text-gray-400">New / Submitted</span>
          <p className="text-2xl font-bold text-blue-600 mt-1">
            {nominations.filter((n) => !n.status || n.status === "submitted").length}
          </p>
        </div>
      </div>

      {/* Search and Filters */}
      <div className="flex flex-col sm:flex-row gap-3 bg-white p-3 rounded-2xl border border-gray-100 shadow-xs">
        <div className="relative flex-1">
          <Search className="absolute left-3.5 top-3 h-4 w-4 text-gray-400" />
          <input
            type="text"
            placeholder="Search by Nominee, Wife, Nominator, Mobile, or Sangh..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full pl-9 pr-4 py-2 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-1 focus:ring-[#ae2b2b] outline-none text-xs sm:text-sm font-medium"
          />
        </div>

        <div className="flex items-center gap-2">
          <Filter className="h-4 w-4 text-gray-400 shrink-0" />
          <select
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)}
            className="px-3 py-2 rounded-xl border border-gray-200 focus:border-[#ae2b2b] outline-none text-xs sm:text-sm font-medium bg-white"
          >
            <option value="all">All Statuses</option>
            <option value="submitted">Submitted</option>
            <option value="shortlisted">Shortlisted</option>
            <option value="verified">Verified</option>
            <option value="rejected">Rejected</option>
          </select>
        </div>
      </div>

      {/* Nominations List */}
      {loading ? (
        <div className="text-center py-16 bg-white rounded-2xl border border-gray-100">
          <div className="h-8 w-8 border-2 border-[#ae2b2b] border-t-transparent rounded-full animate-spin mx-auto mb-2" />
          <p className="text-sm text-gray-500">Loading nominations...</p>
        </div>
      ) : filteredNominations.length === 0 ? (
        <div className="text-center py-16 bg-white rounded-2xl border border-dashed border-gray-200">
          <Heart className="h-10 w-10 text-gray-300 mx-auto mb-2" />
          <p className="text-base font-bold text-gray-700">No nominations found</p>
          <p className="text-xs text-gray-400 mt-1">Try adjusting your search or filters.</p>
        </div>
      ) : (
        <div className="grid gap-4">
          {filteredNominations.map((item) => {
            const statusKey = item.status || "submitted";
            const statusStyle = STATUS_COLORS[statusKey] || STATUS_COLORS.submitted;

            return (
              <div
                key={item.id}
                className="bg-white p-5 rounded-2xl border border-gray-100 shadow-xs hover:shadow-md transition flex flex-col md:flex-row justify-between gap-4 items-start"
              >
                <div className="space-y-3 flex-1 w-full">
                  {/* Top Badges */}
                  <div className="flex flex-wrap items-center gap-2">
                    <span className="text-xs font-serif font-bold px-2.5 py-0.5 rounded-md bg-red-50 text-[#ae2b2b] border border-red-100">
                      SAMARPANAM 2026
                    </span>
                    <span className={`text-xs font-semibold px-2.5 py-0.5 rounded-md border capitalize ${statusStyle}`}>
                      {statusKey}
                    </span>
                    <span className="text-xs text-gray-400">
                      • {new Date(item.created_at).toLocaleDateString()} at{" "}
                      {new Date(item.created_at).toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" })}
                    </span>
                  </div>

                  {/* Main Info */}
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-1">
                    {/* Nominee & Wife */}
                    <div className="bg-gray-50/70 p-3 rounded-xl border border-gray-100 space-y-1">
                      <span className="text-[10px] font-bold uppercase tracking-wider text-gray-400 block">
                        Shasan Sevak & Wife
                      </span>
                      <p className="text-sm font-bold text-gray-900">
                        {item.nominee_name}{" "}
                        <span className="text-xs font-normal text-gray-500">({item.nominee_mobile})</span>
                      </p>
                      <p className="text-xs text-[#ae2b2b] font-semibold">
                        Wife: <span className="text-gray-800">{item.nominee_wife_name}</span>{" "}
                        {item.nominee_wife_mobile && (
                          <span className="text-gray-400 font-normal">({item.nominee_wife_mobile})</span>
                        )}
                      </p>
                    </div>

                    {/* Nominator */}
                    <div className="bg-gray-50/70 p-3 rounded-xl border border-gray-100 space-y-1">
                      <span className="text-[10px] font-bold uppercase tracking-wider text-gray-400 block">
                        Nominator
                      </span>
                      <p className="text-sm font-bold text-gray-900">
                        {item.nominator_name}{" "}
                        <span className="text-xs font-normal text-gray-500">({item.nominator_mobile})</span>
                      </p>
                      <p className="text-xs text-gray-600">
                        Relationship:{" "}
                        <strong className="text-gray-800">
                          {item.relationship_with_nominee === "Other (Please Specify)"
                            ? item.relationship_other
                            : item.relationship_with_nominee}
                        </strong>
                      </p>
                    </div>
                  </div>

                  {/* Seva Areas Tags */}
                  <div className="flex flex-wrap gap-1.5 pt-1">
                    {Array.isArray(item.seva_areas) &&
                      item.seva_areas.map((area, idx) => (
                        <span
                          key={idx}
                          className="text-[11px] font-medium px-2 py-0.5 rounded-full bg-amber-50 text-amber-900 border border-amber-200"
                        >
                          {area}
                        </span>
                      ))}
                    {item.seva_areas_other && (
                      <span className="text-[11px] font-medium px-2 py-0.5 rounded-full bg-amber-50 text-amber-900 border border-amber-200">
                        Other: {item.seva_areas_other}
                      </span>
                    )}
                  </div>

                  {/* Sangh & Contribution Excerpt */}
                  <div className="text-xs text-gray-600 space-y-1">
                    {item.sangh_name && (
                      <p>
                        <strong className="text-gray-700">Sangh:</strong> {item.sangh_name}{" "}
                        {item.sangh_head_contact && `(Contact: ${item.sangh_head_contact})`}
                      </p>
                    )}
                    <p className="line-clamp-2 italic text-gray-700">
                      "{item.contribution_description}"
                    </p>
                  </div>
                </div>

                {/* Actions */}
                <div className="flex md:flex-col gap-2 shrink-0 w-full md:w-auto pt-2 md:pt-0 border-t md:border-t-0 border-gray-100">
                  <button
                    onClick={() => openDetails(item)}
                    className="flex-1 md:flex-initial inline-flex items-center justify-center gap-1.5 px-3 py-2 bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white rounded-xl text-xs font-bold transition shadow-xs cursor-pointer"
                  >
                    <Eye className="h-3.5 w-3.5" /> View Details
                  </button>

                  <select
                    value={item.status || "submitted"}
                    onChange={(e) => handleStatusChange(item.id, e.target.value)}
                    className="px-2.5 py-1.5 rounded-xl border border-gray-200 text-xs font-medium bg-white outline-none cursor-pointer"
                  >
                    <option value="submitted">Submitted</option>
                    <option value="shortlisted">Shortlisted</option>
                    <option value="verified">Verified</option>
                    <option value="rejected">Rejected</option>
                  </select>

                  <button
                    onClick={() => handleDelete(item.id)}
                    className="p-2 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded-xl transition cursor-pointer"
                    title="Delete Nomination"
                  >
                    <Trash2 className="h-4 w-4" />
                  </button>
                </div>
              </div>
            );
          })}
        </div>
      )}

      {/* DETAIL MODAL */}
      {selectedNomination && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center p-3 sm:p-4 bg-black/60 backdrop-blur-xs overflow-y-auto"
          onClick={() => setSelectedNomination(null)}
        >
          <div
            className="bg-white w-full max-w-3xl max-h-[92vh] overflow-y-auto rounded-3xl shadow-2xl animate-in fade-in zoom-in-95 duration-200 relative my-auto"
            onClick={(e) => e.stopPropagation()}
          >
            {/* Modal Header */}
            <div className="sticky top-0 bg-white border-b border-gray-100 p-5 sm:p-6 flex justify-between items-start z-10">
              <div>
                <span className="text-xs font-bold uppercase tracking-widest text-[#ae2b2b]">
                  SAMARPANAM NOMINATION
                </span>
                <h2 className="text-xl sm:text-2xl font-bold text-gray-900 font-serif mt-0.5">
                  {selectedNomination.nominee_name} & {selectedNomination.nominee_wife_name}
                </h2>
                <p className="text-xs text-gray-400 mt-1">
                  Submitted on {new Date(selectedNomination.created_at).toLocaleString()}
                </p>
              </div>

              <button
                onClick={() => setSelectedNomination(null)}
                className="p-2 rounded-full hover:bg-gray-100 text-gray-400 hover:text-gray-700 transition"
              >
                <X className="h-5 w-5" />
              </button>
            </div>

            {/* Modal Content */}
            <div className="p-6 sm:p-8 space-y-6">

              {/* Status & Quick Change */}
              <div className="flex flex-wrap items-center justify-between gap-3 p-4 rounded-2xl bg-gray-50 border border-gray-100">
                <div className="flex items-center gap-2">
                  <span className="text-xs font-bold uppercase text-gray-500">Current Status:</span>
                  <span
                    className={`text-xs font-bold px-3 py-1 rounded-full border capitalize ${
                      STATUS_COLORS[selectedNomination.status || "submitted"]
                    }`}
                  >
                    {selectedNomination.status || "submitted"}
                  </span>
                </div>

                <div className="flex items-center gap-2">
                  <span className="text-xs text-gray-500">Change:</span>
                  {["submitted", "shortlisted", "verified", "rejected"].map((st) => (
                    <button
                      key={st}
                      onClick={() => handleStatusChange(selectedNomination.id, st)}
                      className={`text-xs font-semibold px-2.5 py-1 rounded-lg border capitalize cursor-pointer transition ${
                        (selectedNomination.status || "submitted") === st
                          ? "bg-[#ae2b2b] text-white border-[#ae2b2b]"
                          : "bg-white text-gray-600 border-gray-200 hover:bg-gray-100"
                      }`}
                    >
                      {st}
                    </button>
                  ))}
                </div>
              </div>

              {/* 1. Nominator Details */}
              <div className="rounded-2xl border border-gray-100 p-5 space-y-3">
                <h3 className="text-xs font-bold uppercase tracking-wider text-[#ae2b2b] border-b pb-2 flex items-center gap-1.5">
                  <User className="h-4 w-4" /> 1. Nominator Information
                </h3>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 text-xs sm:text-sm">
                  <div><strong>Full Name:</strong> {selectedNomination.nominator_name}</div>
                  <div><strong>Mobile:</strong> {selectedNomination.nominator_mobile}</div>
                  <div><strong>Age:</strong> {selectedNomination.nominator_age || "N/A"}</div>
                  <div><strong>Gender:</strong> {selectedNomination.nominator_gender || "N/A"}</div>
                  <div>
                    <strong>Relationship:</strong>{" "}
                    {selectedNomination.relationship_with_nominee === "Other (Please Specify)"
                      ? selectedNomination.relationship_other
                      : selectedNomination.relationship_with_nominee}
                  </div>
                  <div className="sm:col-span-2">
                    <strong>Residential Address:</strong>
                    <p className="mt-0.5 text-gray-700 bg-gray-50 p-2.5 rounded-lg border border-gray-100">
                      {selectedNomination.nominator_address}
                    </p>
                  </div>
                </div>
              </div>

              {/* 2. Nominee Details */}
              <div className="rounded-2xl border border-gray-100 p-5 space-y-3">
                <h3 className="text-xs font-bold uppercase tracking-wider text-[#ae2b2b] border-b pb-2 flex items-center gap-1.5">
                  <Award className="h-4 w-4" /> 2. Shasan Sevak & Wife Details
                </h3>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 text-xs sm:text-sm">
                  <div><strong>Shasan Sevak:</strong> {selectedNomination.nominee_name}</div>
                  <div><strong>Mobile:</strong> {selectedNomination.nominee_mobile}</div>
                  <div><strong>Age:</strong> {selectedNomination.nominee_age || "N/A"}</div>
                  <div>
                    <strong>Marital Status:</strong>{" "}
                    {selectedNomination.nominee_marital_status === "Other (Please Specify)"
                      ? selectedNomination.nominee_marital_status_other
                      : selectedNomination.nominee_marital_status}
                  </div>
                  <div>
                    <strong>Full Name of Wife:</strong>{" "}
                    <span className="font-bold text-[#ae2b2b]">{selectedNomination.nominee_wife_name}</span>
                  </div>
                  <div><strong>Wife's Mobile:</strong> {selectedNomination.nominee_wife_mobile || "N/A"}</div>
                  <div className="sm:col-span-2">
                    <strong>Nominee's Address:</strong>
                    <p className="mt-0.5 text-gray-700 bg-gray-50 p-2.5 rounded-lg border border-gray-100">
                      {selectedNomination.nominee_address}
                    </p>
                  </div>
                </div>
              </div>

              {/* 3. Seva Details */}
              <div className="rounded-2xl border border-gray-100 p-5 space-y-3">
                <h3 className="text-xs font-bold uppercase tracking-wider text-[#ae2b2b] border-b pb-2 flex items-center gap-1.5">
                  <Building2 className="h-4 w-4" /> 3. Details of Jinshasan Seva
                </h3>
                <div className="space-y-3 text-xs sm:text-sm">
                  <div>
                    <strong className="block mb-1.5">Areas of Seva:</strong>
                    <div className="flex flex-wrap gap-1.5">
                      {Array.isArray(selectedNomination.seva_areas) &&
                        selectedNomination.seva_areas.map((a, idx) => (
                          <span
                            key={idx}
                            className="px-2.5 py-1 rounded-lg bg-amber-50 text-amber-900 border border-amber-200 text-xs font-medium"
                          >
                            {a}
                          </span>
                        ))}
                      {selectedNomination.seva_areas_other && (
                        <span className="px-2.5 py-1 rounded-lg bg-amber-50 text-amber-900 border border-amber-200 text-xs font-medium">
                          Other: {selectedNomination.seva_areas_other}
                        </span>
                      )}
                    </div>
                  </div>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-1">
                    <div><strong>Involvement Duration:</strong> {selectedNomination.involvement_duration}</div>
                    <div><strong>Hours Per Week:</strong> {selectedNomination.hours_per_week}</div>
                    <div><strong>Total Hours Till Date:</strong> {selectedNomination.total_hours_till_date || "N/A"}</div>
                    <div><strong>Associated Sangh:</strong> {selectedNomination.sangh_name || "N/A"}</div>
                    <div className="sm:col-span-2">
                      <strong>Trustee / Head Reference Contact:</strong> {selectedNomination.sangh_head_contact || "N/A"}
                    </div>
                  </div>

                  <div className="pt-2">
                    <strong>Nominee's Contribution:</strong>
                    <p className="mt-1 text-gray-800 bg-gray-50 p-3 rounded-xl border border-gray-100 leading-relaxed whitespace-pre-line">
                      {selectedNomination.contribution_description}
                    </p>
                  </div>

                  {selectedNomination.initiatives_achievements && (
                    <div className="pt-1">
                      <strong>Significant Initiatives / Achievements:</strong>
                      <p className="mt-1 text-gray-800 bg-gray-50 p-3 rounded-xl border border-gray-100 leading-relaxed whitespace-pre-line">
                        {selectedNomination.initiatives_achievements}
                      </p>
                    </div>
                  )}
                </div>
              </div>

              {/* 4. Wife's Support & Incident Story */}
              <div className="rounded-2xl border border-rose-100 bg-rose-50/30 p-5 space-y-3">
                <h3 className="text-xs font-bold uppercase tracking-wider text-[#ae2b2b] border-b border-rose-200/60 pb-2 flex items-center gap-1.5">
                  <Heart className="h-4 w-4 fill-[#ae2b2b]" /> 4. Wife's Support & Incident
                </h3>
                <div className="space-y-3 text-xs sm:text-sm">
                  <div>
                    <strong>How She Supported His Jinshasan Seva:</strong>
                    <p className="mt-1 text-gray-800 bg-white p-3 rounded-xl border border-rose-100 leading-relaxed whitespace-pre-line">
                      {selectedNomination.wife_support_description || "Not provided."}
                    </p>
                  </div>

                  <div>
                    <strong>Incident Reflecting Her Support / Sacrifice:</strong>
                    <p className="mt-1 text-gray-800 bg-white p-3 rounded-xl border border-rose-100 leading-relaxed whitespace-pre-line">
                      {selectedNomination.wife_incident_story || "Not provided."}
                    </p>
                  </div>
                </div>
              </div>

              {/* 5. Admin Notes */}
              <div className="rounded-2xl border border-gray-200 p-5 space-y-3">
                <h3 className="text-xs font-bold uppercase tracking-wider text-gray-700">
                  Admin Internal Notes
                </h3>
                <textarea
                  rows="3"
                  value={adminNotes}
                  onChange={(e) => setAdminNotes(e.target.value)}
                  placeholder="Add internal notes for verification, calls made, or committee decision..."
                  className="w-full p-3 rounded-xl border border-gray-200 focus:border-[#ae2b2b] focus:ring-1 focus:ring-[#ae2b2b] outline-none text-xs sm:text-sm font-medium"
                ></textarea>
                <div className="flex justify-end">
                  <button
                    onClick={handleSaveNotes}
                    disabled={isSavingNotes}
                    className="px-4 py-2 bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white text-xs font-bold rounded-xl transition cursor-pointer disabled:opacity-50"
                  >
                    {isSavingNotes ? "Saving..." : "Save Admin Notes"}
                  </button>
                </div>
              </div>

            </div>

            {/* Modal Footer */}
            <div className="sticky bottom-0 bg-gray-50 border-t border-gray-100 p-4 px-6 flex justify-between items-center rounded-b-3xl">
              <button
                onClick={() => handleDelete(selectedNomination.id)}
                className="text-red-600 hover:text-red-700 text-xs font-semibold flex items-center gap-1 cursor-pointer"
              >
                <Trash2 className="h-3.5 w-3.5" /> Delete Nomination
              </button>

              <button
                onClick={() => setSelectedNomination(null)}
                className="px-5 py-2 rounded-xl bg-gray-200 hover:bg-gray-300 text-gray-800 text-xs font-bold transition cursor-pointer"
              >
                Close
              </button>
            </div>

          </div>
        </div>
      )}

    </div>
  );
}
