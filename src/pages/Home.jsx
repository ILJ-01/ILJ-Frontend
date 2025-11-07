import HeroCarousel from "../components/HeroCarousel";
import MissionVision from "../components/MissionVision";
import ProjectsPage from "../components/ProjectsPage";
import img1 from "../assets/MainBanner.jpeg";

export default function Home() {
  return (
    <div className="home-container">
      <img src={img1} alt="" />
      {/* <HeroCarousel /> */}
      <MissionVision />
      <ProjectsPage/>
    </div>
  );
}
