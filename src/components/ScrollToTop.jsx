import { useEffect } from "react";
import { useLocation } from "react-router-dom";

export default function ScrollToTop() {
  const { pathname } = useLocation();

  // Disable browser's native scroll restoration — this is what causes
  // mobile "back" to land at the bottom of the previous page.
  useEffect(() => {
    if ("scrollRestoration" in history) {
      history.scrollRestoration = "manual";
    }
  }, []);

  // Scroll to top on every React Router navigation
  useEffect(() => {
    window.scrollTo({ top: 0, left: 0, behavior: "instant" });
  }, [pathname]);

  // Scroll to top on browser back/forward button (popstate)
  useEffect(() => {
    const onPopState = () => {
      // Small timeout so React has time to render the new route first
      setTimeout(() => {
        window.scrollTo({ top: 0, left: 0, behavior: "instant" });
      }, 0);
    };
    window.addEventListener("popstate", onPopState);
    return () => window.removeEventListener("popstate", onPopState);
  }, []);

  return null;
}
