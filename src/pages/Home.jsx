
import HeroCarousel from "../components/HeroCarousel";
import MissionVision from "../components/MissionVision";
import Cardview from "../components/Cardview";
import Instagram from "../components/Instagram";
import "../pages/Home.css";
import { useEffect } from "react";


export default function Home() {

useEffect(() => {
    // Load Instagram embed script
    const script = document.createElement("script");
    script.src = "https://www.instagram.com/embed.js";
    script.async = true;
    document.body.appendChild(script);
  }, []);


  return (
    <div className="home-container">
      <HeroCarousel />
      {/* <Cardview /> */}
      <Instagram />

      <MissionVision />
    </div>
  );
}
