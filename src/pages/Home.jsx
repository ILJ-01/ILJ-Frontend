import React from "react";
import { Link } from "react-router-dom";
import { FaPray, FaBriefcase, FaLandmark } from "react-icons/fa";
import Projects from "../components/Projects";
import Instagram from "../components/Instagram";

export default function Home() {
  return (
    <div className="bg-white min-h-screen font-serif text-[#ae2b2b]">

      {/* 1. Banner Section */}
      <div className="w-full relative">
        {/* Mobile Banner */}
        <img
          src="/cover_mobile_20260204_092551_0000.png"
          alt="ILJ Banner"
          className="w-full h-auto object-cover block md:hidden"
        />
        {/* Desktop Banner */}
        <img
          src="/Website cover page_20260203_234914_0000.png"
          alt="ILJ Banner"
          className="w-full h-auto object-cover hidden md:block"
        />
      </div>

      {/* 2. What is ILJ Section */}
      <section className="py-20 px-5 max-w-7xl mx-auto text-center">
        <h2 className="text-3xl md:text-5xl font-bold mb-12 text-[#ae2b2b] font-serif">
          What is Team I Love Jinshasan?
        </h2>

        <p className="max-w-3xl mx-auto text-lg md:text-xl text-gray-700 leading-relaxed mb-16">
          We are a mission driven organization that transforms how the world perceives and practices Jainism. We focus on three core transitions:
        </p>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-10">

          {/* Card 1 */}
          <div className="bg-white p-8 rounded-2xl shadow-[0_10px_30px_rgba(0,0,0,0.08)] hover:shadow-[0_15px_40px_rgba(174,43,43,0.15)] transition-all duration-300 transform hover:-translate-y-2 border border-gray-100 flex flex-col items-center">
            <div className="w-20 h-20 bg-[#ae2b2b]/10 rounded-full flex items-center justify-center mb-6 text-[#ae2b2b]">
              <FaPray className="text-3xl" />
            </div>
            <h3 className="text-2xl font-bold text-gray-900 mb-4 font-serif">From Faith to Function</h3>
            <p className="text-gray-600 leading-relaxed">
              We take deep-rooted devotion and give it a practical outlet, turning belief into actionable service.
            </p>
          </div>

          {/* Card 2 */}
          <div className="bg-white p-8 rounded-2xl shadow-[0_10px_30px_rgba(0,0,0,0.08)] hover:shadow-[0_15px_40px_rgba(174,43,43,0.15)] transition-all duration-300 transform hover:-translate-y-2 border border-gray-100 flex flex-col items-center">
            <div className="w-20 h-20 bg-[#ae2b2b]/10 rounded-full flex items-center justify-center mb-6 text-[#ae2b2b]">
              <FaBriefcase className="text-3xl" />
            </div>
            <h3 className="text-2xl font-bold text-gray-900 mb-4 font-serif">From Career to Contribution</h3>
            <p className="text-gray-600 leading-relaxed">
              We help professionals use their unique skills—from tech to teaching—to serve the community meaningfuly.
            </p>
          </div>

          {/* Card 3 */}
          <div className="bg-white p-8 rounded-2xl shadow-[0_10px_30px_rgba(0,0,0,0.08)] hover:shadow-[0_15px_40px_rgba(174,43,43,0.15)] transition-all duration-300 transform hover:-translate-y-2 border border-gray-100 flex flex-col items-center">
            <div className="w-20 h-20 bg-[#ae2b2b]/10 rounded-full flex items-center justify-center mb-6 text-[#ae2b2b]">
              <FaLandmark className="text-3xl" />
            </div>
            <h3 className="text-2xl font-bold text-gray-900 mb-4 font-serif">From History to Heritage</h3>
            <p className="text-gray-600 leading-relaxed">
              We ensure our "Ancient Wisdom" isn't just a story from the past, but a living legacy for the future.
            </p>
          </div>

        </div>
      </section>

      {/* 3. Project Grid Section */}
      <section className="py-10 bg-gray-50">
        <Projects />
      </section>

      {/* 4. Instagram Reels Section */}
      <section className="py-10 bg-white">
        <Instagram />
      </section>

      {/* 5. Why Join Us Section */}
      <section className="py-16 px-5 bg-[#fff5f5]">
        <div className="max-w-6xl mx-auto flex flex-col md:flex-row items-center gap-10">

          <div className="flex-1">
            <h2 className="text-3xl font-bold mb-6 text-[#ae2b2b]">
              Why Join Us
            </h2>
            <p className="text-lg text-gray-700 leading-relaxed mb-6">
              Joining us means turning your time and talents into meaningful service for Jinshasan. Our volunteering is purposeful - guided by respect, responsibility, and teamwork - while helping you grow along the way. You gain hands-on experience, build leadership and communication skills, deepen your spiritual connection, and connect with like-minded youth. We value sincere service and recognize commitment through certificates, acknowledgments, and growth opportunities because here, service leads to transformation.
            </p>
            <Link
              to="/volunteer-registration"
              className="inline-block bg-[#ae2b2b] text-white font-bold py-3 px-8 rounded-full shadow-lg hover:bg-[#801b1b] transform hover:-translate-y-1 transition duration-300"
            >
              Register Now
            </Link>
          </div>

          {/* Optional: We could put an image here if desired, but sticking to text as requested. 
              The prompt image showed a "Volunteer Section" with text left and button right (or bottom). 
              I've put button below text.
          */}
        </div>
      </section>

    </div>
  );
}
