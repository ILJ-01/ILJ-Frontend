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
import AdminLogin from "./pages/AdminLogin";
import AdminDashboard from "./pages/AdminDashboard";
import AdminAddProject from "./pages/AdminAddProject";
import AdminEditProject from "./pages/AdminEditProject";
import InterestsPage from "./pages/InterestsPage";
import "./styles/global.css";

// Dashboard Imports
import DashboardLayout from "./components/dashboard/DashboardLayout";

import EventsPage from "./pages/dashboard/EventsPage";
import TasksPage from "./pages/dashboard/TasksPage";
import TimesheetPage from "./pages/dashboard/TimesheetPage";
import ProfilePage from "./pages/dashboard/ProfilePage";

import VolunteerDashboard from "./pages/dashboard/VolunteerDashboard";
import ManagerHub from "./pages/dashboard/ManagerHub";

import PoliciesPage from "./pages/dashboard/PoliciesPage";

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
            <Route path="/profile" element={<MainLayout><Profile /></MainLayout>} />
            <Route path="/form" element={<MainLayout><Form /></MainLayout>} />
            <Route path="/volunteer-registration" element={<MainLayout><VolunteerRegistration /></MainLayout>} />
            <Route path="/policies" element={<MainLayout><div className="bg-[#f8f9fa] pt-8 pb-16"><PoliciesPage /></div></MainLayout>} />
            <Route path="/interests" element={<MainLayout><InterestsPage /></MainLayout>} />

            {/* Admin Routes */}
            <Route path="/admin" element={<AdminLogin />} />
            <Route path="/admin/dashboard" element={<AdminDashboard />} />
            <Route path="/admin/add-project" element={<AdminAddProject />} />
            <Route path="/admin/edit-project/:id" element={<AdminEditProject />} />

            {/* Volunteer Dashboard Routes */}
            <Route path="/dashboard" element={<Navigate to="/dashboard/events" replace />} />
            <Route path="/dashboard/manager" element={<ProtectedRoute><DashboardLayout><ManagerHub /></DashboardLayout></ProtectedRoute>} />
            <Route path="/dashboard/events" element={<ProtectedRoute><DashboardLayout><EventsPage /></DashboardLayout></ProtectedRoute>} />
            <Route path="/dashboard/tasks" element={<ProtectedRoute><DashboardLayout><TasksPage /></DashboardLayout></ProtectedRoute>} />
            <Route path="/dashboard/policies" element={<ProtectedRoute><DashboardLayout><PoliciesPage /></DashboardLayout></ProtectedRoute>} />
            <Route path="/dashboard/timesheet" element={<ProtectedRoute><DashboardLayout><TimesheetPage /></DashboardLayout></ProtectedRoute>} />
            <Route path="/dashboard/profile" element={<ProtectedRoute><DashboardLayout><ProfilePage /></DashboardLayout></ProtectedRoute>} />

          </Routes>
        </div>
      </Router>
    </AuthProvider>
  );
}

export default App;
