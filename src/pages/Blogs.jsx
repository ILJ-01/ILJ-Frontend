import React, { useState, useEffect } from "react";
import BlogList from "../components/BlogList";
import BlogDetail from "../components/BlogDetail";

const BlogPage = () => {
  const [blogs, setBlogs] = useState([]);        // State for storing articles
  const [selectedBlog, setSelectedBlog] = useState(null);   // State for selected blog
  const [loading, setLoading] = useState(true); //  New: Loading state

  // Fetch articles from the backend API on component mount
  useEffect(() => {
    const fetchBlogs = async () => {
      try {
        setLoading(true); //  Start loading before fetching
        const response = await fetch('https://ilj-backend.vercel.app/api/articles');  // Fetch from backend API
        const data = await response.json();  // Convert response to JSON
        setBlogs(data);  // Store the fetched articles in state
      } catch (error) {
        console.error('Error fetching blogs:', error);  // Handle any errors
      } finally {
        setLoading(false); //  Stop loading after fetching (success or error)
      }
    };

    fetchBlogs();
  }, []);  // Empty dependency array to ensure it runs only once when the component mounts

    // 👇 Show a loading spinner or text while fetching data
  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
      <div
        className="w-12 h-12 border-4 border-gray-200 border-t-[#ae2b2b] rounded-full animate-spin"
        role="status"
      ></div>
    </div>

    );
  }

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
