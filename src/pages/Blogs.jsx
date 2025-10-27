import React, { useState, useEffect } from "react";
import BlogList from "../components/BlogList";
import BlogDetail from "../components/BlogDetail";

const BlogPage = () => {
  const [blogs, setBlogs] = useState([]);        // State for storing articles
  const [selectedBlog, setSelectedBlog] = useState(null);   // State for selected blog

  // Fetch articles from the backend API on component mount
  useEffect(() => {
    const fetchBlogs = async () => {
      try {
        const response = await fetch('http://localhost:5000/api/articles');  // Fetch from backend API
        const data = await response.json();  // Convert response to JSON
        setBlogs(data);  // Store the fetched articles in state
      } catch (error) {
        console.error('Error fetching blogs:', error);  // Handle any errors
      }
    };

    fetchBlogs();
  }, []);  // Empty dependency array to ensure it runs only once when the component mounts

  return (
    <div>
      {!selectedBlog ? (
        <BlogList blogs={blogs} onSelectBlog={setSelectedBlog} />  // Pass blogs to BlogList
      ) : (
        <BlogDetail blog={selectedBlog} onBack={() => setSelectedBlog(null)} />  // Show detailed view when a blog is selected
      )}
    </div>
  );
};

export default BlogPage;
