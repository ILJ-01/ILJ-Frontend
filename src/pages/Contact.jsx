

import "../pages/Contact.css";
import {
  FaEnvelope,
  FaPhoneAlt,
  FaFacebookF,
  FaInstagram,
  FaYoutube,
  FaWhatsapp,
  FaMapMarkerAlt
} from "react-icons/fa";

export default function Contact() {
  return (
    <div>
    <h1> Contact Us </h1>
    {/* === Connect With Us Row === */}
{/* <div className="contact-connect-row">
 <h3 className="connect-title">Connect With Us</h3> 
  <div className="social-icons">
    <a href="https://wa.me/1234567890" target="_blank" rel="noopener noreferrer" className="social wa">
      <FaWhatsapp />
    </a>
    <a href="https://www.instagram.com/" target="_blank" rel="noopener noreferrer" className="social insta">
      <FaInstagram />
    </a>
    <a href="https://www.youtube.com/" target="_blank" rel="noopener noreferrer" className="social yt">
      <FaYoutube />
    </a>
    <a href="https://www.facebook.com/" target="_blank" rel="noopener noreferrer" className="social fb">
      <FaFacebookF />
    </a>
  </div>
</div> */}

    <section className="contact-wrapper">
      {/* ===== LEFT SIDE : CONTACT CARDS ===== */}
      <div className="contact-left">
        {/* === Email Card === */}
        <div className="contact-card email-card">
          <div className="icon-container">
            <FaEnvelope className="contact-icon" />
          </div>
          <div className="contact-info">
            <h3>Email Us</h3>
            <p><strong>ILJ@gmail.com</strong></p>
            {/* <span>Response in 2–4 hours</span> */}
          </div>
        </div>

        {/* === Call Card === */}
        <div className="contact-card call-card">
          <div className="icon-container">
            <FaPhoneAlt className="contact-icon" />
          </div>
          <div className="contact-info">
            <h3>Call Us</h3>
            <p><strong>+1 (555) 987-6543</strong></p>
            <span>Available 9 AM – 6 PM EST</span>
          </div>
        </div>

        {/* === Location Card === */}
<div className="contact-card location-card">
  <div className="icon-container">
    <FaMapMarkerAlt className="contact-icon" />
  </div>
  <div className="contact-info">
    <h3>Our Location</h3>
    <p><strong>A-Wing, Manibhadra Tower,
       Sarvodaya Nagar, Mulund West, Mumbai, Maharashtra, 400080 India.</strong></p>
    {/* <span>Visit us anytime during working hours</span> */}
  </div>
</div>


        {/* === Connect Card === */}
        <div className="contact-card connect-card">
          <div className="contact-info">
            <h3>Connect With Us</h3>
            <div className="social-icons">
              <a href="#" className="social fb"><FaFacebookF /></a>
              <a href="#" className="social insta"><FaInstagram /></a>
              <a href="#" className="social yt"><FaYoutube /></a>
              <a href="#" className="social wa"><FaWhatsapp /></a>
            </div>
          </div>
        </div>
      </div>

      {/* ===== RIGHT SIDE : CONTACT FORM ===== */}
      <div className="contact-form-container">
        <h2 className="form-title">Get in Touch</h2>
        <p className="form-subtitle">
          This form is for you to send us your queries or give suggestions 
          regarding the jainsism books and articles.
        </p>

        <form className="contact-form">
          <div className="form-row">
            <input type="text" placeholder="Your Name" required />
            <input type="email" placeholder="Your Email" required />
          </div>

          <input type="text" placeholder="Subject" required />
          <textarea rows="5" placeholder="Message" required></textarea>

          <div className="form-button-container">
            <button type="submit" className="send-button">Send Message</button>
          </div>
        </form>
      </div>
    </section>
    </div>
  );
}
