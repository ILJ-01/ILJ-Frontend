import { useState, useEffect } from "react";
import { Link, useNavigate, useLocation } from "react-router-dom";
import { useAuth } from "@/context/AuthContext";
import LoginModal from "./LoginModal";
import "./Navbar.css";
import logo from "../assets/Logo-19.png";

function Navbar() {
  const [isOpen, setIsOpen] = useState(false);
  const [showLoginModal, setShowLoginModal] = useState(false);
  const navigate = useNavigate();
  const location = useLocation();
  const { isLoggedIn, user } = useAuth();

  // Get user initials for the profile icon
  const userInitials = isLoggedIn && user
    ? `${user.first_name?.[0] || ''}${user.last_name?.[0] || ''}`.toUpperCase()
    : '';

  const handleProfileClick = () => {
    if (isLoggedIn) {
      navigate('/dashboard');
    }
  };

  /* 
    Added logic to check for ?login=true query param 
    and open the login modal automatically.
    This supports the "Login to Apply" redirection flow.
  */
  useEffect(() => {
    const params = new URLSearchParams(location.search);
    if (params.get('login') === 'true') {
      setShowLoginModal(true);

      // Remove the query param to strict mode doesn't loop or keep it dirty
      // We use navigate with replace to update URL without adding history entry
      navigate(location.pathname, { replace: true });
    }
  }, [location.search, navigate]);

  const handleRegisterClick = () => {
    navigate('/volunteer-registration');
  };

  return (
    <>
      <nav className="navbar">
        {/* Logo - Left on mobile */}
        <div className="logo">
          <Link to="/" onClick={() => setIsOpen(false)}>
            <img src={logo} alt="I Love Jinshasan" className="logo-img" />
          </Link>
        </div>

        {/* Desktop Links (Hidden on Mobile) */}
        <ul className="nav-links">
          <li><Link to="/" onClick={() => setIsOpen(false)}>HOME</Link></li>
          <li><Link to="/aboutus" onClick={() => setIsOpen(false)}>ABOUT US</Link></li>
          <li><Link to="/projects" onClick={() => setIsOpen(false)}>PROJECTS</Link></li>
          <li><Link to="/articles" onClick={() => setIsOpen(false)}>ARTICLES</Link></li>
          {isLoggedIn && (
            <li><Link to="/dashboard" onClick={() => setIsOpen(false)}>DASHBOARD</Link></li>
          )}
        </ul>

        {/* Right Side: Profile & Auth & Hamburger */}
        <div className="navbar-right">

          {/* Desktop Auth Buttons */}
          {!isLoggedIn && (
            <div className="nav-auth-buttons hidden-mobile">
              <button
                className="nav-btn nav-btn-outline"
                onClick={() => setShowLoginModal(true)}
              >
                LOGIN
              </button>
              <button
                className="nav-btn nav-btn-solid"
                onClick={handleRegisterClick}
              >
                JOIN AS VOLUNTEER
              </button>
            </div>
          )}

          {/* Profile Icon */}
          <div className="profile-icon-container">
            {isLoggedIn ? (
              <button
                className="profile-icon-btn"
                onClick={handleProfileClick}
                aria-label="Profile"
              >
                {userInitials ? (
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
                <span className="online-indicator"></span>
              </button>
            ) : (
              // Mobile Guest Profile Icon (Optional, or just hide and use hamburger)
              // User said "logo , account profile , hamburger" for mobile. 
              // Even if guest, "account profile" implies a login trigger.
              <button
                className="profile-icon-btn mobile-only-icon"
                onClick={() => setShowLoginModal(true)}
                aria-label="Login"
              >
                <svg
                  className="profile-icon-svg"
                  viewBox="0 0 24 24"
                  fill="none"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <circle cx="12" cy="8" r="4" stroke="currentColor" strokeWidth="2" />
                  <path d="M5 20C5 17.2386 8.13401 15 12 15C15.866 15 19 17.2386 19 20" stroke="currentColor" strokeWidth="2" strokeLinecap="round" />
                </svg>
              </button>
            )}
          </div>

          <div
            className="hamburger"
            onClick={() => setIsOpen(true)}
          >
            ☰
          </div>
        </div>
      </nav>

      {/* Sidebar Panel */}
      <div className={`side-panel ${isOpen ? "open" : ""}`}>
        <button className="close-btn" onClick={() => setIsOpen(false)}>✕</button>
        <ul>
          <li><Link to="/" onClick={() => setIsOpen(false)}>HOME</Link></li>
          <li><Link to="/aboutus" onClick={() => setIsOpen(false)}>ABOUT US</Link></li>
          <li><Link to="/projects" onClick={() => setIsOpen(false)}>PROJECTS</Link></li>
          <li><Link to="/articles" onClick={() => setIsOpen(false)}>ARTICLES</Link></li>

          {!isLoggedIn && (
            <div className="px-2 mt-4 space-y-2">
              <button
                className="mobile-nav-btn"
                onClick={() => { setShowLoginModal(true); setIsOpen(false); }}
              >
                LOGIN
              </button>
              <Link
                to="/volunteer-registration"
                className="mobile-nav-btn solid"
                onClick={() => setIsOpen(false)}
              >
                JOIN AS VOLUNTEER
              </Link>
            </div>
          )}
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
