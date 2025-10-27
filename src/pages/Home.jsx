import HeroCarousel from "../components/HeroCarousel";
import MissionVision from "../components/MissionVision";

export default function Home() {
  return (
    <div className="home-container">
      <HeroCarousel />
      <MissionVision />
    </div>
  );
}
