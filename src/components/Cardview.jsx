
import "../components/Cardview.css"

export default function Home() {

    return (
      <div className="cards-section">
        <div className="card">
          <img src="src\assets\Img3.jpeg" alt="Adventure" className="card-image" />
          <h3 className="card-title">Adventure Trips</h3>
          <p className="card-content">
            Embark on thrilling adventures through mountains, rivers, and unexplored trails.
          </p>
          <button className="card-button">Show More</button>
        </div>

        <div className="card">
          <img src="/images/beach.jpg" alt="Beach" className="card-image" />
          <h3 className="card-title">Beach Holidays</h3>
          <p className="card-content">
            Relax on serene beaches, enjoy water sports, and soak up the tropical vibes.
          </p>
          <button className="card-button">Show More</button>
        </div>

        <div className="card">
          <img src="/images/culture.jpg" alt="Culture" className="card-image" />
          <h3 className="card-title">Cultural Tours</h3>
          <p className="card-content">
            Discover local traditions, history, and cuisine with guided cultural tours.
          </p>
          <button className="card-button">Show More</button>
        </div>

        <div className="card">
          <img src="/images/nature.jpg" alt="Nature" className="card-image" />
          <h3 className="card-title">Nature Escapes</h3>
          <p className="card-content">
            Experience the beauty of nature with peaceful getaways in forests and valleys.
          </p>
          <button className="card-button">Show More</button>
        </div>
      </div>

    );
}