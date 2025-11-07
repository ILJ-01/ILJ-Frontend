import React from "react";
import "./MissionVision.css"; // import css file

const MissionVision = () => {
  return (
    <section className="mission-vision">
      <div className="container">
        <h2 className="text-[#ae2b2b] mb-[20px] font-bold text-[28px]">Mission & Vision</h2>

        <div className="flex flex-col gap-3">
          {/* Vision */}
          <div className="card grid grid-cols-[auto_1fr] sm:gap-10 items-center">
            <img
              src="/about-us-vision.png"
              alt="Our Vision"
              className="rounded-lg w-0 h-0 sm:w-[150px] sm:h-[150px] object-cover"
            />
            <div>
              <h2 className="text-[#4a4a8c] text-[20px] mb-[15px]">Our Vision</h2>
              <p className="text-[#555] text-[16px] lh-[1.6]">
                To inspire a global movement of Jain youth, fostering
                respect for Jainism and safe guarding Jinshasan for
                a better future.
              </p>
            </div>
          </div>

          {/* Mission */}
          <div className="card grid grid-cols-[1fr_auto] sm:gap-10 items-center">
            <div>
              <h2 className="text-[#4a4a8c] text-[20px] mb-[15px]">Our Mission</h2>
              <p className="text-[#555] text-[16px] lh-[1.6]">
                To spread the teachings of Jainism to every heart,
                empowering Jain youth, and safeguard the
                integrity of Jinshasan through selfless service and
                unwavering dedication.
              </p>
            </div>
            <img
              src="/about-us-mission.png"
              alt="Our Mission"
              className="rounded-lg w-0 h-0 sm:w-[150px] sm:h-[150px] object-cover"
            />
          </div>

          {/* Belief */}
          <div className="card grid grid-cols-[auto_1fr] sm:gap-10 items-center">
            <img
              src="/about-us-belief.png"
              alt="Our Belief"
              className="rounded-lg w-0 h-0 sm:w-[150px] sm:h-[150px] object-cover"
            />
            <div>
              <h2 className="text-[#4a4a8c] text-[20px] mb-[15px]">Our Vision</h2>
              <p className="text-[#555] text-[16px] lh-[1.6]">
                Dev-Guru-Dharma is our foundation -- Jinshasan is
                our identity. We believe that love for Jinshasan
                must reflect in our actions, not just our words.
                True Happiness lies in serving Jinshasan.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default MissionVision;
