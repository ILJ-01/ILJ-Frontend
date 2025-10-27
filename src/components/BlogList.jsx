import React from "react";
import "./Blog.css";

const BlogList = ({ blogs, onSelectBlog }) => {
  return (
    <div className="blog-list">
        <h1 className="blogPage-header">Articles</h1>
      {blogs.map((blog) => (
        <div 
          key={blog.id} 
          className="blog-card" 
          onClick={() => onSelectBlog(blog)}
        >
          <div className="blog-content">
            <h2 className="blog-title">{blog.title}</h2>
            <p className="blog-subtitle">{blog.subtitle}</p>
            <div className="blog-meta">
              <span>{blog.author}</span> • <span>{blog.date}</span>
            </div>
          </div>
          {blog.image && (
            <div className="blog-image">
               <img
                src={blog.image && blog.image.data
                  ? `data:${blog.image.contentType};base64,${blog.image.data}` // Base64 format
                  : "https://via.placeholder.com/150"} // Fallback image
                alt={blog.title}
                style={{ width: "150px", height: "150px" }}
              />

            </div>
          )}
        </div>
      ))}
    </div>
  );
};

export default BlogList;
