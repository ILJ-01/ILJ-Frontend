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
import "./styles/global.css";

function App() {
  return (
    <AuthProvider>
      <Router>
        <div className="app">
          <Navbar />
          <main className="content">
            <Routes>
              <Route path="/" element={<Home />} />
              <Route path="/blogs" element={<Blogs />} />
              <Route path="/blog/*" element={<Blogs />} />
              <Route path="/aboutus" element={<AboutUs />} />
              <Route path="/projects" element={<Projects />} />
              <Route path="/project/:title" element={<Project />} />
              <Route path="/profile" element={<Profile />} />
              <Route path="/form" element={<Form />} />
              <Route path="/volunteer-registration" element={<VolunteerRegistration />} />
              <Route path="/admin" element={<AdminLogin />} />
              <Route path="/admin/dashboard" element={<AdminDashboard />} />
              <Route path="/admin/add-project" element={<AdminAddProject />} />
              <Route path="/admin/edit-project/:id" element={<AdminEditProject />} />
            </Routes>
          </main>
          <Footer />
        </div>
      </Router>
    </AuthProvider>
  );
}

export default App;
