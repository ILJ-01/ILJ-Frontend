import React from "react";
import "./MissionVision.css"; // import css file

const MissionVision = () => {
  return (
    <section className="mission-vision">
      <div className="container">
        <h2 className="heading">Mission & Vision</h2>
        
        <div className="cards">
          {/* Mission */}
          <div className="card">
            <h3 className="card-title">Our Mission</h3>
            <p className="card-text">
              To share valuable knowledge and insights with our readers, 
              empowering them with information that inspires, educates, and 
              creates positive impact.
            </p>
          </div>

          {/* Vision */}
          <div className="card">
            <h3 className="card-title">Our Vision</h3>
            <p className="card-text">
              To become a trusted platform where people discover meaningful 
              stories, ideas, and perspectives that shape a better tomorrow.
            </p>
          </div>
        </div>
      </div>
    </section>
  );
};

export default MissionVision;
