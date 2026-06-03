import React, { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import { Card, CardHeader, CardTitle, CardDescription, CardContent, CardFooter } from "./ui/card";
import { Button } from "./ui/button";
import { Cookie } from "lucide-react";

export default function CookieConsent() {
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    // Check if the user has already made a choice
    const consent = localStorage.getItem("ilj-cookie-consent");
    if (!consent) {
      // Delay slightly for a smoother entry animation
      const timer = setTimeout(() => {
        setIsVisible(true);
      }, 1000);
      return () => clearTimeout(timer);
    }
  }, []);

  const handleAccept = () => {
    localStorage.setItem("ilj-cookie-consent", "accepted");
    setIsVisible(false);
  };

  const handleReject = () => {
    localStorage.setItem("ilj-cookie-consent", "rejected");
    setIsVisible(false);
  };

  if (!isVisible) return null;

  return (
    <div className="fixed bottom-4 left-4 right-4 md:bottom-6 md:right-6 md:left-auto max-w-none md:max-w-md w-auto md:w-[380px] z-[9999] animate-in fade-in slide-in-from-bottom-10 duration-500">
      <Card className="bg-white/95 border-t-4 border-t-[#ae2b2b] border-gray-100 shadow-[0_10px_30px_rgba(0,0,0,0.1)] backdrop-blur-md overflow-hidden rounded-2xl">
        <CardHeader className="pb-2">
          <CardTitle className="text-lg font-bold text-gray-900 font-serif flex items-center gap-2.5">
            <div className="bg-[#ae2b2b]/10 p-2 rounded-xl text-[#ae2b2b]">
              <Cookie className="h-5 w-5" />
            </div>
            Cookie Consent
          </CardTitle>
          <CardDescription className="text-sm text-gray-500 font-medium leading-relaxed pt-2">
            We use cookies to enhance your experience. By accepting, you consent to our use of cookies as detailed in our{" "}
            <Link to="/privacy-policy" className="text-[#ae2b2b] hover:underline font-semibold transition-colors">
              Privacy Policy
            </Link>
            .
          </CardDescription>
        </CardHeader>
        <CardContent className="pb-3 text-xs text-gray-400">
          This choice will persist in your browser settings. You can review your preferences at any time.
        </CardContent>
        <CardFooter className="flex items-center gap-3 justify-end pt-2">
          <Button
            variant="outline"
            onClick={handleReject}
            className="text-gray-600 border-gray-200 hover:bg-gray-50 hover:text-gray-900 text-xs font-bold py-2 px-4 h-9 rounded-lg transition-all"
          >
            Decline
          </Button>
          <Button
            onClick={handleAccept}
            className="bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white text-xs font-bold py-2 px-4 h-9 rounded-lg transition-all shadow-md hover:shadow-lg hover:-translate-y-0.5"
          >
            Accept Cookies
          </Button>
        </CardFooter>
      </Card>
    </div>
  );
}
