import "../components/Instagram.css";

export default function Instagram() {   
   
      return (
      <div className="instagram-section">
        <h2 className="insta-title">Latest Instagram Reels</h2>
        <div className="reels-container">
          {/* Replace URLs below with your actual reel links */}
          <blockquote
            className="instagram-media"
            data-instgrm-captioned
            data-instgrm-permalink="https://www.instagram.com/reel/DQrRS-_DHdp/?igsh=a3JtcDcwcjJvYXp0"
            data-instgrm-version="14"
          ></blockquote>

          <blockquote
            className="instagram-media"
            data-instgrm-captioned
            data-instgrm-permalink="https://www.instagram.com/reel/DQWpQozDO0x/?igsh=MWhpeTJ0M3ByemxpMQ=="
            data-instgrm-version="14"
          ></blockquote>

          <blockquote
            className="instagram-media"
            data-instgrm-captioned
            data-instgrm-permalink="https://www.instagram.com/reel/DP85PjnDPn-/?igsh=MWs0dnZncDVldzlhbQ=="
            data-instgrm-version="14"
          ></blockquote>

          <blockquote
            className="instagram-media"
            data-instgrm-captioned
            data-instgrm-permalink="https://www.instagram.com/reel/DQrRS-_DHdp/?igsh=a3JtcDcwcjJvYXp0"
            data-instgrm-version="14"
          ></blockquote>
        </div>
      </div>
    // </div>
  );
}
