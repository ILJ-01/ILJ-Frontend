import { Swiper, SwiperSlide } from "swiper/react";
import { Autoplay, Pagination, Navigation } from "swiper/modules";
import "swiper/css";
import "swiper/css/pagination";
import "swiper/css/navigation";
import "./HeroCarousel.css";

import img1 from "../assets/ILJ-Complete-logo.png";
import img2 from "../assets/Img2.jpeg";
import img3 from "../assets/Img3.jpeg";
import video1 from "../assets/ILJ-Complete-logo.png";
import img4 from "../assets/Img4.jpeg";

export default function HeroCarousel() {
  const slides = [
    { type: "image", src: img1, caption: "Community Meetups" },
    { type: "image", src: img2, caption: "Workshops & Events" },
    { type: "video", src: video1, caption: "Highlights" },
    { type: "image", src: img3, caption: "Creative Projects" },
    { type: "image", src: img4, caption: "Memorable Moments" },
  ];

  return (
    <div className="hero-carousel">
      <Swiper
        spaceBetween={30}
        centeredSlides={true}
        autoplay={{
          delay: 5000,
          disableOnInteraction: false,
        }}
        pagination={{ clickable: true }}
        navigation={true}
        modules={[Autoplay, Pagination, Navigation]}
        className="mySwiper"
      >
        {slides.map((slide, index) => (
          <SwiperSlide key={index}>
            {slide.type === "image" ? (
              <img src={slide.src} alt={`slide-${index}`} />
            ) : (
              <video src={slide.src} autoPlay muted loop />
            )}
            {/* <div className="caption">{slide.caption}</div> */}
          </SwiperSlide>
        ))}
      </Swiper>
    </div>
  );
}
