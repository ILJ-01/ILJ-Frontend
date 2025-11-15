import {
  FaEnvelope,
  FaPhoneAlt,
  FaFacebookF,
  FaInstagram,
  FaYoutube,
  FaWhatsapp,
  FaMapMarkerAlt,
} from "react-icons/fa";

export default function Contact() {
  return (
    <div className="font-serif px-5 py-10 bg-[#fafafa]">
      {/* Heading */}
      <h1
        className="text-[28px] font-bold text-center mb-10"
        style={{ color: "#ae2b2b" }}
      >
        Contact Us
      </h1>

      {/* Wrapper */}
      <section className="flex flex-col lg:flex-row gap-8 justify-center items-start">
        {/* ===== LEFT SECTION ===== */}
        <div className="bg-[#f5f5f5] rounded-2xl shadow-md p-6 flex flex-col gap-5 w-full max-w-md">
          {/* Email Card */}
          <div className="flex items-center bg-white border border-gray-200 rounded-xl shadow-sm hover:shadow-md transition-all p-4">
            <div className="flex items-center justify-center w-14 h-14 rounded-xl bg-[#ae2b2b]/10 mr-4">
              <FaEnvelope className="text-[#ae2b2b] text-xl" />
            </div>
            <div>
              <h3 className="font-semibold text-gray-800">Email Us</h3>
              <p className="text-gray-700 font-medium">ilovejinshasan@gmail.com</p>
            </div>
          </div>

          {/* Call Card */}
          <div className="flex items-center bg-white border border-gray-200 rounded-xl shadow-sm hover:shadow-md transition-all p-4">
            <div className="flex items-center justify-center w-14 h-14 rounded-xl bg-[#ae2b2b]/10 mr-4">
              <FaPhoneAlt className="text-[#ae2b2b] text-xl" />
            </div>
            <div>
              <h3 className="font-semibold text-gray-800">Call Us</h3>
              <p className="text-gray-700 font-medium">+91 7045355421</p>
              <span className="text-xs text-gray-500">
                Available 9 AM – 6 PM
              </span>
            </div>
          </div>

          {/* Location Card */}
          <div className="flex items-start bg-white border border-gray-200 rounded-xl shadow-sm hover:shadow-md transition-all p-4">
            <div className="flex items-center justify-center w-14 h-14 rounded-xl bg-[#ae2b2b]/10 mr-4">
              <FaMapMarkerAlt className="text-[#ae2b2b] text-xl" />
            </div>
            <div>
              <h3 className="font-semibold text-gray-800 mb-1">Our Location</h3>
              <p className="text-gray-700 text-sm leading-snug">
                A-Wing, Manibhadra Tower, Sarvodaya Nagar, Mulund West, Mumbai,
                Maharashtra, 400080 India.
              </p>
            </div>
          </div>

          {/* Social Connect */}
          <div className="bg-white border border-gray-200 rounded-xl shadow-sm hover:shadow-md transition-all p-4">
            <h3 className="font-semibold text-gray-800 mb-3">
              Connect With Us
            </h3>
            <div className="flex items-center gap-4">
              <a
                href="https://www.facebook.com/ilovejinshasan/about/"
                className="flex items-center justify-center w-10 h-10 rounded-full bg-[#1877f2] text-white hover:scale-110 transition-transform"
              >
                <FaFacebookF />
              </a>
              <a
                href="https://www.instagram.com/ilovejinshasan/"
                className="flex items-center justify-center w-10 h-10 rounded-full bg-[#e1306c] text-white hover:scale-110 transition-transform"
              >
                <FaInstagram />
              </a>
              <a
                href="https://www.youtube.com/@ilovejinshasan"
                className="flex items-center justify-center w-10 h-10 rounded-full bg-[#ff0000] text-white hover:scale-110 transition-transform"
              >
                <FaYoutube />
              </a>
              <a
                href="https://chat.whatsapp.com/Hq32AgfdZ5tBRqFenGzrzj"
                className="flex items-center justify-center w-10 h-10 rounded-full bg-[#25d366] text-white hover:scale-110 transition-transform"
              >
                <FaWhatsapp />
              </a>
            </div>
          </div>
        </div>

        {/* ===== RIGHT SECTION ===== */}
        <div className="bg-white rounded-2xl shadow-md border border-gray-100 p-6 w-full max-w-xl">
          <h2
            className="text-[22px] font-bold mb-3 border-l-4 pl-3"
            style={{ borderColor: "#ae2b2b", color: "#ae2b2b" }}
          >
            Get in Touch
          </h2>
          <p className="text-gray-600 mb-6 text-sm leading-relaxed">
            This form is for you to send us your queries or give suggestions.
          </p>

          <form className="flex flex-col gap-4">
            {/* Name & Email */}
            <div className="flex flex-col sm:flex-row gap-4">
              <input
                type="text"
                placeholder="Your Name"
                className="flex-1 px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:border-[#ae2b2b] focus:ring-1 focus:ring-[#ae2b2b] text-sm"
              />
              <input
                type="email"
                placeholder="Your Email"
                className="flex-1 px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:border-[#ae2b2b] focus:ring-1 focus:ring-[#ae2b2b] text-sm"
              />
            </div>

            {/* Subject */}
            <input
              type="text"
              placeholder="Subject"
              className="px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:border-[#ae2b2b] focus:ring-1 focus:ring-[#ae2b2b] text-sm"
            />

            {/* Message */}
            <textarea
              rows="5"
              placeholder="Message"
              className="px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:border-[#ae2b2b] focus:ring-1 focus:ring-[#ae2b2b] text-sm"
            ></textarea>

            {/* Button */}
            <div className="flex justify-center mt-2">
              <button
                type="submit"
                className="bg-[#ae2b2b] text-white font-semibold px-6 py-2 rounded-full hover:bg-[#911f1f] transition-all duration-200"
              >
                Send Message
              </button>
            </div>
          </form>
        </div>
      </section>
    </div>
  );
}
