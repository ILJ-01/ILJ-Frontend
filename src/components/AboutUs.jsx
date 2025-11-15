import React from "react";

function About() {
  return (
    <div className="font-serif flex flex-col items-center justify-center text-center py-5 gap-10 w-full">
      {/* What is ILF Foundation */}
      <div className="w-full bg-[#ae2b2b]">
        <div className="mx-auto m-5">
          <h1 className="text-white text-[48px] text-center">What is I Love Jinshasan?</h1>
          <p className="text-white text-[22px] mx-5 text-center">
            A collective devoted to the timeless values of the Jinshasan.
            We empower individuals to convert devotion into
            action, skills into seva, and vision into legacy.
          </p>
        </div>
      </div>

      {/* Values */}
      <div className="mx-auto p-5">
        <h1 className="text-[36px] text-[#ae2b2b] mb-3">Our values</h1>
        <div className="flex flex-wrap gap-5 justify-center">
          <div className="bg-white rounded-[12px] p-5 max-w-[250px] shadow-md">
            <img
              src="/about-us-vision.png"
              alt="Our Vision"
              className="rounded-lg w-[150px] h-[150px] object-cover mx-auto mb-2"
            />
            <p>
              To inspire a global movement of Jain youth, fostering
              respect for Jainism and safe guarding Jinshasan for
              a better future.
            </p>
          </div>

          <div className="bg-white rounded-[12px] p-5 max-w-[250px] shadow-md">
            <img
              src="/about-us-mission.png"
              alt="Our Vision"
              className="rounded-lg w-[150px] h-[150px] object-cover mx-auto mb-2"
            />
            <p>
              To spread the teachings of Jainism to every heart,
              empowering Jain youth, and safeguard the
              integrity of Jinshasan through selfless service and
              unwavering dedication.
            </p>
          </div>

          <div className="bg-white rounded-[12px] p-5 max-w-[250px] shadow-md">
            <img
              src="/about-us-belief.png"
              alt="Our Vision"
              className="rounded-lg w-[150px] h-[150px] object-cover mx-auto mb-2"
            />
            <p>
              Dev-Guru-Dharma is our foundation -- Jinshasan is
              our identity. We believe that love for Jinshasan
              must reflect in our actions, not just our words.
              True Happiness lies in serving Jinshasan.
            </p>
          </div>
        </div>
      </div>

      {/* Why Join Us? */}
      <div className="flex flex-col gap-7 w-full mx-auto m-5">
        <h1 className="w-fit text-[#ae2b2b] text-[36px] mx-auto mb-3 text-center">Why Join Us?</h1>

        <div className="sm:w-2/3 bg-[#ae2b2b] rounded-r-full p-5">
          <h1 className="ml-4 text-[42px] text-white font-bold text-justify">
            Purposeful Volunteering
          </h1>
        </div>
        <div className="mx-10 text-[#ae2b2b] text-[24px] text-justify">
          Turn your time and talents into meaningful contributions for Jinshasan.
        </div>

        <div className="bg-[#ae2b2b] rounded-l-full p-5 sm:w-2/3 ml-auto">
          <h1 className="w-fit ml-auto text-[42px] text-white font-bold">
            Grow While You Serve
          </h1>
        </div>
        <div className="ml-10 sm:ml-auto mr-5 text-[#ae2b2b] text-[24px] text-left">
          <ul className="list-disc">
            <li>Learn event/project management.</li>
            <li>Build leadership & communication skills.</li>
            <li>Deepen your spiritual connection.</li>
            <li>Network with like-minded youth</li>
          </ul>
        </div>

        <div className="sm:w-2/3 bg-[#ae2b2b] rounded-r-full p-5 mr-5">
          <h1 className="ml-4 text-[42px] text-white font-bold text-left">
            Values We Live By
          </h1>
        </div>
        <div className="mx-10 text-[#ae2b2b] text-[24px] text-left">
          <ul className="list-disc">
            <li>Respect. Responsibility. Teamwork.</li>
            <li>Promote Jainism with humility and clarity.</li>
            <li>Serve with sincerity, always.</li>
          </ul>
        </div>

        <div className="sm:w-2/3 bg-[#ae2b2b] rounded-l-full p-5 ml-auto">
          <h1 className="w-fit ml-auto text-[42px] text-white font-bold">
            Recognition That Matters
          </h1>
        </div>
        <div className="ml-10 sm:ml-auto mr-5 text-[#ae2b2b] text-[24px] text-justify">
          <ul className="list-disc">
            <li>Certificates, gift vouchers, & social media shoutouts.</li>
            <li>Promotion based on commitment & impact.</li>
            <li>"Volunteer of the year" and other awards.</li>
          </ul>
        </div>
      </div>
    </div>
  );
}

export default About;
