import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import { AuthProvider } from "./context/AuthContext";
import Navbar from "./components/Navbar";
import Footer from "./components/Footer";
import Home from "./pages/Home";
import Blogs from "./pages/Blogs";
import AboutUs from "./pages/AboutUs";
import Projects from "./pages/Projects";
import Profile from "./pages/Profile";
import Form from "./components/Form.jsx";
import VolunteerRegistration from "./pages/VolunteerRegistration";
import Project from "./components/Project.jsx";
import EventRegistrationPage from "./pages/EventRegistrationPage.jsx";
import CookieConsent from "./components/CookieConsent";
import AdminLogin from "./pages/AdminLogin";
import AdminDashboard from "./pages/AdminDashboard";
import AdminAddProject from "./pages/AdminAddProject";
import AdminEditProject from "./pages/AdminEditProject";
import AdminInquiries from "./pages/admin/AdminInquiries";
import InterestsPage from "./pages/InterestsPage";
import PrivacyPolicy from "./pages/PrivacyPolicy";
import TermsOfService from "./pages/TermsOfService";
import "./styles/global.css";

// Dashboard Imports
import DashboardLayout from "./components/dashboard/DashboardLayout";

import EventsPage from "./pages/dashboard/EventsPage";
import TasksPage from "./pages/dashboard/TasksPage";
import TimesheetPage from "./pages/dashboard/TimesheetPage";
import ProfilePage from "./pages/dashboard/ProfilePage";

import VolunteerIdeas from "./pages/dashboard/VolunteerIdeas";
import ManagerHub from "./pages/dashboard/ManagerHub";

import PoliciesPage from "./pages/dashboard/PoliciesPage";
import TeamLeaderHub from "./pages/dashboard/TeamLeaderHub";
import KalyanMitraHub from "./pages/dashboard/KalyanMitraHub";
import IdeasHub from "./pages/dashboard/IdeasHub";
import VolunteerSTC from "./pages/dashboard/VolunteerSTC";
import AssignedProjectsPage from "./pages/dashboard/AssignedProjectsPage";
import ItAdminHub from "./pages/dashboard/ItAdminHub";
import OnboardingHub from "./pages/dashboard/OnboardingHub";
import MasterSheet from "./pages/dashboard/MasterSheet";
import PodManagementHub from "./pages/dashboard/PodManagementHub";

// Helper components for routing structure
import { useAuth } from "./context/AuthContext";
import { Navigate } from "react-router-dom";

const MainLayout = ({ children }) => (
  <>
    <Navbar />
    <main className="content">{children}</main>
    <Footer />
  </>
);

const ProtectedRoute = ({ children }) => {
  const { user, loading } = useAuth();
  if (loading) return <div>Loading...</div>;
  if (!user) return <Navigate to="/" replace />;
  return children;
};

function App() {
  return (
    <AuthProvider>
      <Router>
        <div className="app">
          <CookieConsent />
          {/* Conditionally render Navbar/Footer based on route if needed, or handle inside layout */}
          {/* For simplicity we keep main site structure separate from dashboard */}

          <Routes>
            {/* Main Public Site */}
            <Route path="/" element={<MainLayout><Home /></MainLayout>} />
            <Route path="/blogs" element={<MainLayout><Blogs /></MainLayout>} />
            <Route path="/blog/*" element={<MainLayout><Blogs /></MainLayout>} />
            <Route path="/aboutus" element={<MainLayout><AboutUs /></MainLayout>} />
            <Route path="/projects" element={<MainLayout><Projects /></MainLayout>} />
            <Route path="/project/:title" element={<MainLayout><Project /></MainLayout>} />
            <Route path="/projects/:id/event-registration" element={<MainLayout><EventRegistrationPage /></MainLayout>} />
            <Route path="/profile" element={<MainLayout><Profile /></MainLayout>} />
            <Route path="/form" element={<MainLayout><Form /></MainLayout>} />
            <Route path="/volunteer-registration" element={<MainLayout><VolunteerRegistration /></MainLayout>} />
            <Route path="/policies" element={<MainLayout><div className="bg-[#f8f9fa] pt-8 pb-16"><PoliciesPage /></div></MainLayout>} />
            <Route path="/interests" element={<MainLayout><InterestsPage /></MainLayout>} />
            <Route path="/privacy-policy" element={<MainLayout><PrivacyPolicy /></MainLayout>} />
            <Route path="/terms" element={<MainLayout><TermsOfService /></MainLayout>} />

            {/* Admin Routes */}
            <Route path="/admin" element={<AdminLogin />} />
            <Route path="/admin/dashboard" element={<AdminDashboard />} />
            <Route path="/admin/add-project" element={<AdminAddProject />} />
            <Route path="/admin/edit-project/:id" element={<AdminEditProject />} />
            <Route path="/admin/inquiries" element={<AdminInquiries />} />

            {/* Volunteer Dashboard Routes */}
            <Route path="/dashboard" element={<Navigate to="/dashboard/events" replace />} />
            <Route path="/dashboard/share-idea" element={<ProtectedRoute><DashboardLayout><VolunteerIdeas /></DashboardLayout></ProtectedRoute>} />
            <Route path="/dashboard/manager" element={<ProtectedRoute><DashboardLayout><ManagerHub /></DashboardLayout></ProtectedRoute>} />
            <Route path="/dashboard/events" element={<ProtectedRoute><DashboardLayout><EventsPage /></DashboardLayout></ProtectedRoute>} />
            <Route path="/dashboard/tasks" element={<ProtectedRoute><DashboardLayout><TasksPage /></DashboardLayout></ProtectedRoute>} />
            <Route path="/dashboard/policies" element={<ProtectedRoute><DashboardLayout><PoliciesPage /></DashboardLayout></ProtectedRoute>} />
            <Route path="/dashboard/timesheet" element={<ProtectedRoute><DashboardLayout><TimesheetPage /></DashboardLayout></ProtectedRoute>} />
            <Route path="/dashboard/profile" element={<ProtectedRoute><DashboardLayout><ProfilePage /></DashboardLayout></ProtectedRoute>} />
            <Route path="/dashboard/team-leader" element={<ProtectedRoute><DashboardLayout><TeamLeaderHub /></DashboardLayout></ProtectedRoute>} />
            <Route path="/dashboard/kalyan-mitra" element={<ProtectedRoute><DashboardLayout><KalyanMitraHub /></DashboardLayout></ProtectedRoute>} />
            <Route path="/dashboard/ideas" element={<ProtectedRoute><DashboardLayout><IdeasHub /></DashboardLayout></ProtectedRoute>} />
            <Route path="/dashboard/stc" element={<ProtectedRoute><DashboardLayout><VolunteerSTC /></DashboardLayout></ProtectedRoute>} />
            <Route path="/dashboard/assigned-projects" element={<ProtectedRoute><DashboardLayout><AssignedProjectsPage /></DashboardLayout></ProtectedRoute>} />
            <Route path="/dashboard/it-admin" element={<ProtectedRoute><DashboardLayout><ItAdminHub /></DashboardLayout></ProtectedRoute>} />
            <Route path="/dashboard/onboarding" element={<ProtectedRoute><DashboardLayout><OnboardingHub /></DashboardLayout></ProtectedRoute>} />
            <Route path="/dashboard/master-sheet" element={<ProtectedRoute><DashboardLayout><MasterSheet /></DashboardLayout></ProtectedRoute>} />
            <Route path="/dashboard/pod-management" element={<ProtectedRoute><DashboardLayout><PodManagementHub /></DashboardLayout></ProtectedRoute>} />

          </Routes>
        </div>
      </Router>
    </AuthProvider>
  );
}

export default App;
