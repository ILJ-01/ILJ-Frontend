import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { useAuth } from "@/context/AuthContext";
import LoginModal from "./LoginModal";
import "./Navbar.css";
import logo from "../assets/heart-logo.png";

function Navbar() {
  const [isOpen, setIsOpen] = useState(false);
  const [showLoginModal, setShowLoginModal] = useState(false);
  const navigate = useNavigate();
  const { isLoggedIn, user } = useAuth();

  // Get user initials for the profile icon
  const userInitials = isLoggedIn && user
    ? `${user.first_name?.[0] || ''}${user.last_name?.[0] || ''}`.toUpperCase()
    : '';

  const handleProfileClick = () => {
    if (isLoggedIn) {
      navigate('/dashboard');
    } else {
      setShowLoginModal(true);
    }
  };

  return (
    <>
      <nav className="navbar">
        {/* Profile Icon - Left of hamburger on mobile, left of nav on desktop */}
        <div className="profile-icon-container">
          <button
            className="profile-icon-btn"
            onClick={handleProfileClick}
            aria-label="Profile"
          >
            {isLoggedIn && userInitials ? (
              <span className="profile-initials">{userInitials}</span>
            ) : (
              <svg
                className="profile-icon-svg"
                viewBox="0 0 24 24"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <circle cx="12" cy="8" r="4" stroke="currentColor" strokeWidth="2" />
                <path d="M5 20C5 17.2386 8.13401 15 12 15C15.866 15 19 17.2386 19 20" stroke="currentColor" strokeWidth="2" strokeLinecap="round" />
              </svg>
            )}
            {isLoggedIn && <span className="online-indicator"></span>}
          </button>
        </div>

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
          {isLoggedIn && (
            <li><Link to="/dashboard" onClick={() => setIsOpen(false)}>DASHBOARD</Link></li>
          )}
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
          {isLoggedIn && (
            <li><Link to="/dashboard" onClick={() => setIsOpen(false)}>DASHBOARD</Link></li>
          )}
        </ul>
      </div>

      {/* Background Overlay */}
      {isOpen && <div className="overlay" onClick={() => setIsOpen(false)} />}

      {/* Login Modal */}
      <LoginModal
        isOpen={showLoginModal}
        onClose={() => setShowLoginModal(false)}
      />
    </>
  );
}

export default Navbar;
