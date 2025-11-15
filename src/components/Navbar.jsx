import { useState } from "react";
import { Link } from "react-router-dom";
import "./Navbar.css";
import logo from "../assets/heart-logo.png";

function Navbar() {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <>
      <nav className="navbar">
        <div className="logo">
          <Link to="/" onClick={() => setIsOpen(false)}>
            <img src={logo} alt="I Love Jinshasan" className="logo-img" />
          </Link>
        </div>
        <ul className="nav-links">
          <li><Link to="/" onClick={() => setIsOpen(false)}>HOME</Link></li>
          <li><Link to="/projects" onClick={() => setIsOpen(false)}>PROJECTS</Link></li>
          <li><Link to="/blogs" onClick={() => setIsOpen(false)}>ARTICLES</Link></li>
          <li><Link to="/aboutus" onClick={() => setIsOpen(false)}>ABOUT US</Link></li>
        </ul>
        <div
          className="hamburger"
          onClick={() => setIsOpen(true)}
        >
          ☰
        </div>
      </nav>

      {/* Sidebar Panel */}
      <div className={`side-panel ${isOpen ? "open" : ""}`}>
        <button className="close-btn" onClick={() => setIsOpen(false)}>✕</button>
        <ul>
          <li><Link to="/" onClick={() => setIsOpen(false)}>HOME</Link></li>
          <li><Link to="/projects" onClick={() => setIsOpen(false)}>PROJECTS</Link></li>
          <li><Link to="/blogs" onClick={() => setIsOpen(false)}>ARTICLES</Link></li>
          <li><Link to="/aboutus" onClick={() => setIsOpen(false)}>ABOUT US</Link></li>
        </ul>
      </div>

      {/* Background Overlay */}
      {isOpen && <div className="overlay" onClick={() => setIsOpen(false)} />}
    </>
  );
}

export default Navbar;
