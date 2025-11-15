import Contact from "../components/Contact";
import AboutUs from "../components/AboutUs"

export default function Home() {
  return (
    <div className="home-container">
      <AboutUs/>
      <Contact/>
    </div>
  );
}
