import Projects from "../components/Projects";
import Instagram from "../components/Instagram"
import ExhibitionBanner from "../assets/ExhibitionBanner.jpeg";

export default function Home() {
  return (
    <div className="home-container">
      <img src={ExhibitionBanner} className='mx-auto' alt="I ❤️ Jinshasan" />
      <Projects />
      <Instagram />
    </div>
  );
}
