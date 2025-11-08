import ProjectsPage from "../components/ProjectsPage";
import Instagram from "../components/Instagram"
import img1 from "../assets/MainBanner.jpeg";

export default function Home() {
  return (
    <div className="home-container">
      <img src={img1} alt="I ❤️ Jinshasan" />
      {/* <HeroCarousel /> */}
      <ProjectsPage/>
      {/* <Instagram/> */}
    </div>
  );
}
