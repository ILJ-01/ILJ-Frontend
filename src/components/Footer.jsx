import React from "react";
import { Link } from "react-router-dom";
import {
  FaEnvelope,
  FaPhoneAlt,
  FaFacebookF,
  FaInstagram,
  FaYoutube,
  FaWhatsapp,
  FaMapMarkerAlt,
} from "react-icons/fa";
import { FaXTwitter } from "react-icons/fa6";
import "./Footer.css";

export default function Footer() {
  const currentYear = new Date().getFullYear();

  return (
    <footer className="bg-[#5c1212] text-white py-12 px-5 font-serif">
      <div className="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">

        {/* Contact Us */}
        <div>
          <h3 className="text-xl font-bold mb-4 text-white uppercase tracking-wider">Contact Us</h3>
          <ul className="space-y-4 text-sm text-gray-200">
            <li className="flex items-start gap-3">
              <FaEnvelope className="mt-1 text-white shrink-0" />
              <span>ilovejinshasan@gmail.com</span>
            </li>
            <li className="flex items-start gap-3">
              <FaPhoneAlt className="mt-1 text-white shrink-0" />
              <span>+91 7045355421</span>
            </li>
            <li className="flex items-start gap-3">
              <FaMapMarkerAlt className="mt-1 text-white shrink-0" />
              <span>
                A-Wing, Manibhadra Tower, Sarvodaya Nagar, Mulund West, Mumbai, 400080 India.
              </span>
            </li>
          </ul>
        </div>

        {/* Follow Us */}
        <div>
          <h3 className="text-xl font-bold mb-4 text-white uppercase tracking-wider">Follow Us</h3>
          <div className="flex gap-4">
            <a href="https://www.instagram.com/ilovejinshasan/" target="_blank" rel="noopener noreferrer" className="bg-white p-2 rounded-full text-[#ae2b2b] hover:bg-gray-200 transition">
              <FaInstagram />
            </a>
            <a href="https://www.facebook.com/ilovejinshasan/about/" target="_blank" rel="noopener noreferrer" className="bg-white p-2 rounded-full text-[#ae2b2b] hover:bg-gray-200 transition">
              <FaFacebookF />
            </a>
            <a href="https://www.youtube.com/@ilovejinshasan" target="_blank" rel="noopener noreferrer" className="bg-white p-2 rounded-full text-[#ae2b2b] hover:bg-gray-200 transition">
              <FaYoutube />
            </a>
            <a href="https://chat.whatsapp.com/Hq32AgfdZ5tBRqFenGzrzj" target="_blank" rel="noopener noreferrer" className="bg-white p-2 rounded-full text-[#ae2b2b] hover:bg-gray-200 transition">
              <FaWhatsapp />
            </a>
            <a href="https://x.com/ilovejinshasan" target="_blank" rel="noopener noreferrer" className="bg-white p-2 rounded-full text-[#ae2b2b] hover:bg-gray-200 transition">
              <FaXTwitter />
            </a>
          </div>
        </div>

        {/* Resources */}
        <div>
          <h3 className="text-xl font-bold mb-4 text-white uppercase tracking-wider">Resources</h3>

        </div>

        {/* Quick Links */}
        <div>
          <h3 className="text-xl font-bold mb-4 text-white uppercase tracking-wider">Quick Links</h3>
          <ul className="space-y-2 text-sm text-gray-200">
            <li><Link to="/" className="hover:text-white transition">Home</Link></li>
            <li><Link to="/blogs" className="hover:text-white transition">Articles</Link></li>
            <li><Link to="/policies" className="hover:text-white transition">Privacy Policy</Link></li>
            <li><Link to="/projects" className="hover:text-white transition">Projects</Link></li>
            <li><Link to="/aboutus" className="hover:text-white transition">About Us</Link></li>
          </ul>
        </div>

      </div>

      <div className="border-t border-white/20 mt-10 pt-6 text-center text-sm text-gray-300">
        <p>&copy; {currentYear} I Love Jinshasan. All rights reserved.</p>
      </div>
    </footer>
  );
}
