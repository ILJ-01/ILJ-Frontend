import React from "react";
import "./Blog.css";

const BlogDetail = ({ blog, onBack }) => {
  // Function to render content with proper paragraphs
  const renderContent = (content) => {
    // Check if content exists
    if (!content) {
      return null;
    }

    // Split the content by newline characters (\n)
    const paragraphs = content.split('\n');

    // Map each paragraph to a <p> tag
    return paragraphs.map((paragraph, index) => (
      <p key={index} className="blog-detail-content-paragraph">
        {paragraph}
      </p>
    ));
  };

  return (
    <div className="blog-detail">
      <button className="back-btn" onClick={onBack}>← Back</button>
      <h1 className="blog-detail-title">{blog.title}</h1>
      <p className="blog-detail-meta">{blog.author} • {blog.date}</p>
      <img
        className="blog-detail-image"
        src={blog.image && blog.image.data
          ? `data:${blog.image.contentType};base64,${blog.image.data}`
          : "https://via.placeholder.com/150"}
        alt={blog.title}
      />
      
      {/* Render the formatted content here */}
      <div className="blog-detail-content-container">
        {renderContent(blog.content)}
      </div>
    </div>
  );
};

export default BlogDetail;