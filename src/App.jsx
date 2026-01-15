import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Navbar from "./components/Navbar";
import Footer from "./components/Footer";
import Home from "./pages/Home";
import Blogs from "./pages/Blogs";
import AboutUs from "./pages/AboutUs";
import Projects from "./pages/Projects";
import Feedback from "./components/Feedback.jsx";
import Project from "./components/Project.jsx";
import "./styles/global.css";

function App() {
  return (
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
            <Route path="/project/:id" element={<Project />} />
            <Route path="/feedback" element={<Feedback />} />
          </Routes>
        </main>
        <Footer />
      </div>
    </Router>
  );
}

export default App;
