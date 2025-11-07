import React from "react";

function About() {
  return (
    <div className="flex flex-col items-center justify-center text-center py-5 gap-10 w-full">
      <div className="w-full bg-[#551415]">
        <div className="max-w-[800px] mx-auto m-5">
          <h1 className="text-white text-[48px] text-justify">What is ILJ Foundation?</h1>
          <p className="text-white text-[22px] ml-7 text-justify">
            A collective devoted to the timeless values of the Jinshasan.
            We empower individuals to convert devotion into
            action, skills into seva, and vision into legacy.
          </p>
        </div>
      </div>

      <div className="x-auto p-5">
        <h1 className="text-[36px] text-[#551415] mb-3">Our values</h1>
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

      <div className="flex flex-col gap-7 max-w-[800px] w-full mx-auto m-5">
        <h1 className="w-fit text-[#551415] text-[36px] mb-3">Why Join Us?</h1>

        <div className="bg-[#551415] rounded-r-full p-5 sm:w-6/8">
          <h1 className="ml-4 text-[42px] text-white font-bold text-justify">
            Purposeful Volunteering
          </h1>
        </div>
        <div className="ml-6 text-[#551415] text-[24px]">
          Turn your time and talents into meaningful contributions for Jinshasan.
        </div>

        <div className="bg-[#551415] rounded-l-full p-5 sm:w-6/8 ml-auto">
          <h1 className="w-fit ml-auto text-[42px] text-white font-bold">
            Grow While You Serve
          </h1>
        </div>
        <div className="ml-auto text-[#551415] text-[24px] text-justify">
          <ul className="list-disc">
            <li>Learn event/project management.</li>
            <li>Build leadership & communication skills.</li>
            <li>Deepen your spiritual connection.</li>
            <li>Network with like-minded youth</li>
          </ul>
        </div>

        <div className="bg-[#551415] rounded-r-full p-5 sm:w-6/8">
          <h1 className="ml-4 text-[42px] text-white font-bold text-justify">
            Values We Live By
          </h1>
        </div>
        <div className="ml-6 text-[#551415] text-[24px] text-justify">
          <ul className="list-disc">
            <li>Respect. Responsibility. Teamwork.</li>
            <li>Promote Jainism with humility and clarity.</li>
            <li>Serve with sincerity, always.</li>
          </ul>
        </div>

        <div className="bg-[#551415] rounded-l-full p-5 sm:w-6/8 ml-auto">
          <h1 className="w-fit ml-auto text-[42px] text-white font-bold">
            Recognition That Matters
          </h1>
        </div>
        <div className="ml-auto text-[#551415] text-[24px] text-justify">
          <ul className="list-disc">
            <li>Learn event/project management.</li>
            <li>Build leadership & communication skills.</li>
            <li>Deepen your spiritual connection.</li>
            <li>Network with like-minded youth</li>
          </ul>
        </div>
      </div>
    </div>
  );
}

export default About;
