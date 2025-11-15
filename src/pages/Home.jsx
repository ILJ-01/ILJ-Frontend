import Projects from "../components/Projects";
import Instagram from "../components/Instagram"
import img1 from "../assets/MainBanner.jpeg";

export default function Home() {
  return (
    <div className="home-container">
      <img src={img1} alt="I ❤️ Jinshasan" />
      {/* <HeroCarousel /> */}
      <Projects/>
      <Instagram/>
    </div>
  );
}
