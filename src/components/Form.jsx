import React, {useEffect, useState} from "react";
import {useNavigate, useSearchParams} from "react-router";

export default function Form() {
  const navigate = useNavigate();
  const [form, setForm] = useState(null);
  const [searchParams] = useSearchParams();

  useEffect(() => {
    const redirectUrl = searchParams.get('formLink');

    if (redirectUrl) {
      const decodedUrl = decodeURIComponent(redirectUrl);

      if (decodedUrl) {
        setForm(decodedUrl);
        return;
      }
    }

    navigate('/');
  }, [searchParams, navigate]);

  return (
    <div className="w-full h-screen">
      <iframe
        src={form}
        className="w-full h-full border-0"
        title="Google Form"
      />
    </div>
  );
}