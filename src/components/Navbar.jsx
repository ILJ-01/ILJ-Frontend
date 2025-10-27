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
            <img src={logo} alt="Logo" className="logo-img" />
          </Link>
        </div>
        <ul className="nav-links">
          <li><Link to="/" onClick={() => setIsOpen(false)}>Home</Link></li>
          <li><Link to="/about" onClick={() => setIsOpen(false)}>About</Link></li>
          <li><Link to="/blogs" onClick={() => setIsOpen(false)}>Blog</Link></li>
          <li><Link to="/contact" onClick={() => setIsOpen(false)}>Contact</Link></li>
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
          <li><Link to="/" onClick={() => setIsOpen(false)}>Home</Link></li>
          <li><Link to="/about" onClick={() => setIsOpen(false)}>About</Link></li>
          <li><Link to="/blogs" onClick={() => setIsOpen(false)}>Blog</Link></li>
          <li><Link to="/contact" onClick={() => setIsOpen(false)}>Contact</Link></li>
        </ul>
      </div>

      {/* Background Overlay */}
      {isOpen && <div className="overlay" onClick={() => setIsOpen(false)} />}
    </>
  );
}

export default Navbar;
