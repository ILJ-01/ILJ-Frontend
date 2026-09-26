import { useState } from "react";
import { motion } from "framer-motion";
import {
  CalendarDays, CheckCircle2, Clock3, Heart, IndianRupee, MapPin,
  MessageCircle, Upload, Users, Utensils, X
} from "lucide-react";
import { supabase } from "../lib/supabase";

const RECONNECT_PROJECT_ID = "644691e8-6498-4d89-a46b-3f0184c94dc1";
const WHATSAPP_GROUP_URL = "https://chat.whatsapp.com/BpzRM5VKU8f4dOmsPXZhnR?s=cl&p=a&mlu=4&ilr=4";

const highlights = [
  "Life Hacks for Real Life",
  "Stories That Hit Different",
  "Body Reset & Mind Detox",
  "Crazy Fun Challenges",
  "Sandhya Bhakti Vibes",
];

export default function ReconnectRegistrationPage() {
  const [form, setForm] = useState({
    full_name: "",
    whatsapp_number: "",
    dob: "",
    gender: "Male",
    address: "",
  });
  const [paymentScreenshot, setPaymentScreenshot] = useState(null);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [error, setError] = useState("");

  const updateForm = (event) => {
    const { name, value } = event.target;
    setForm((current) => ({ ...current, [name]: value }));
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    setError("");

    if (!paymentScreenshot) {
      setError("Please upload your payment screenshot to complete registration.");
      return;
    }

    if (paymentScreenshot.size > 6 * 1024 * 1024) {
      setError("Please upload an image smaller than 6 MB.");
      return;
    }

    setIsSubmitting(true);
    try {
      const extension = paymentScreenshot.name.split(".").pop()?.toLowerCase() || "jpg";
      const fileName = `reconnect-${Date.now()}-${crypto.randomUUID()}.${extension}`;
      const filePath = `event-payments/${fileName}`;

      const { error: uploadError } = await supabase.storage
        .from("project-gallery")
        .upload(filePath, paymentScreenshot, { contentType: paymentScreenshot.type });
      if (uploadError) throw uploadError;

      const { data: publicUrlData } = supabase.storage
        .from("project-gallery")
        .getPublicUrl(filePath);

      const { error: insertError } = await supabase
        .from("event_registrations")
        .insert({
          project_id: RECONNECT_PROJECT_ID,
          full_name: form.full_name.trim(),
          whatsapp_number: form.whatsapp_number.trim(),
          mobile_number: form.whatsapp_number.trim(),
          dob: form.dob,
          gender: form.gender,
          address: form.address.trim(),
          payment_screenshot_url: publicUrlData.publicUrl,
        });
      if (insertError) throw insertError;

      setSubmitted(true);
      window.scrollTo({ top: 0, behavior: "smooth" });
    } catch (submissionError) {
      console.error("Reconnect registration failed:", submissionError);
      setError("We could not submit your registration. Please check your connection and try again.");
    } finally {
      setIsSubmitting(false);
    }
  };

  if (submitted) {
    return (
      <div className="min-h-screen bg-[#fff8ed] px-4 py-16 sm:py-24">
        <motion.section
          initial={{ opacity: 0, y: 24 }}
          animate={{ opacity: 1, y: 0 }}
          className="mx-auto max-w-xl border border-[#ead1a4] bg-white px-6 py-10 text-center shadow-[0_24px_70px_rgba(83,28,43,0.16)] sm:px-10"
        >
          <div className="mx-auto mb-5 grid h-16 w-16 place-items-center rounded-full bg-[#f4e1b9] text-[#7b1d3b]">
            <CheckCircle2 size={34} />
          </div>
          <p className="mb-2 text-xs font-bold uppercase tracking-[0.26em] text-[#b77812]">Reconnect 2026</p>
          <h1 className="font-serif text-4xl font-bold text-[#1e2949]">Your spot is reserved.</h1>
          <p className="mx-auto mt-4 max-w-md leading-7 text-slate-600">
            Thank you, {form.full_name}. We have received your registration and payment proof for Reconnect.
          </p>
          <div className="my-7 border-y border-[#f0dfc1] py-5 text-left text-sm leading-7 text-slate-700">
            <p><strong>5–7 November 2026</strong> · 8 AM–7 PM</p>
            <p>Shree Riddhi Siddhi Aadarsh Shwetambar Murtipujak Jain Sangh, Marve Road, Malad (W)</p>
          </div>
          <a
            href={WHATSAPP_GROUP_URL}
            target="_blank"
            rel="noreferrer"
            className="inline-flex w-full items-center justify-center gap-2 bg-[#25D366] px-5 py-3.5 font-bold text-white transition hover:bg-[#1eb85a]"
          >
            <MessageCircle size={19} /> Join the WhatsApp group
          </a>
        </motion.section>
      </div>
    );
  }

  return (
    <div className="min-h-screen overflow-hidden bg-[#fff8ed] text-[#1e2949]">
      <section className="relative isolate overflow-hidden bg-[#24122d] px-4 py-14 text-white sm:px-6 sm:py-20">
        <div className="absolute inset-0 -z-10 bg-[radial-gradient(circle_at_15%_0%,rgba(226,164,60,.34),transparent_27%),radial-gradient(circle_at_87%_50%,rgba(123,29,59,.62),transparent_33%),linear-gradient(145deg,#15244a_0%,#381333_53%,#7b1d3b_100%)]" />
        <div className="absolute -left-16 top-8 -z-10 h-44 w-44 rounded-full border border-[#f2be58]/30" />
        <div className="absolute -right-10 bottom-[-70px] -z-10 h-64 w-64 rounded-full border-[28px] border-[#f2be58]/10" />
        <motion.div initial={{ opacity: 0, y: 18 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.55 }} className="mx-auto max-w-5xl text-center">
          <div className="mb-6 inline-flex items-center gap-2 border border-[#f2be58]/60 bg-white/10 px-4 py-2 text-xs font-bold uppercase tracking-[0.21em] text-[#ffe5ae]">
            <Heart size={15} fill="currentColor" /> A 3-day Diwali camp
          </div>
          <h1 className="font-serif text-5xl font-black tracking-tight sm:text-7xl">RECONNECT</h1>
          <p className="mt-1 font-serif text-2xl italic text-[#ffdca0] sm:text-4xl">with Soul · Shasan · Nature</p>
          <p className="mx-auto mt-5 max-w-2xl text-base font-medium text-white/90 sm:text-xl">Escape the noise. Enter the calm. Reconnect with what matters.</p>
          <p className="mx-auto mt-7 max-w-4xl border-y border-[#f2be58]/40 py-3 text-sm leading-6 text-[#fff1d5] sm:text-base">
            Blessings &amp; Divine Presence: Aacharya Shree Vimalkirti Suriji M.S. and Sadhviji Shree Jinrakshita Shreeji M.S.
          </p>
        </motion.div>
      </section>

      <main className="mx-auto grid max-w-6xl gap-10 px-4 py-10 sm:px-6 lg:grid-cols-[1fr_1.08fr] lg:gap-14 lg:py-16">
        <aside className="space-y-7 lg:sticky lg:top-7 lg:self-start">
          <div>
            <p className="text-xs font-bold uppercase tracking-[0.2em] text-[#b77812]">Samvat 2083 starts here</p>
            <h2 className="mt-2 font-serif text-3xl font-bold leading-tight text-[#2b2449]">Good people. Brighter tomorrows.</h2>
          </div>

          <div className="grid grid-cols-1 gap-px overflow-hidden border border-[#e5c891] bg-[#e5c891] sm:grid-cols-2">
            {[
              [CalendarDays, "Dates", "5–7 November 2026"],
              [Clock3, "Time", "8 AM to 7 PM"],
              [Users, "For", "Boys and girls · Age 11–18"],
              [IndianRupee, "Fees", "₹100 · Non-refundable"],
              [Utensils, "Included", "Breakfast, lunch & dinner"],
              [MapPin, "Venue", "Malad (W), Mumbai"],
            ].map(([Icon, label, value]) => (
              <div key={label} className="bg-[#fffdf7] p-4">
                <Icon size={19} className="mb-2 text-[#8b1b43]" />
                <p className="text-[11px] font-bold uppercase tracking-wider text-[#9a6518]">{label}</p>
                <p className="mt-1 text-sm font-semibold leading-5 text-[#252341]">{value}</p>
              </div>
            ))}
          </div>

          <div className="border-l-4 border-[#b77812] bg-[#f9edcf] p-5">
            <p className="font-serif text-lg font-bold text-[#56203a]">What awaits you</p>
            <ul className="mt-3 space-y-2 text-sm leading-5 text-[#4a4655]">
              {highlights.map((highlight) => <li key={highlight}>• {highlight}</li>)}
            </ul>
          </div>

          <p className="text-sm leading-6 text-slate-600">
            <strong className="text-[#56203a]">Venue:</strong> Shree Riddhi Siddhi Aadarsh Shwetambar Murtipujak Jain Sangh, Marve Road, Malad (W).<br />
            <strong className="text-[#56203a]">Contact:</strong> 9323806706 · Limited seats.
          </p>
        </aside>

        <motion.section initial={{ opacity: 0, y: 18 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} className="border border-[#ead1a4] bg-white shadow-[0_18px_60px_rgba(83,28,43,0.12)]">
          <div className="border-b border-[#ead1a4] bg-[#fff9ed] p-6 sm:p-8">
            <p className="text-xs font-bold uppercase tracking-[0.2em] text-[#b77812]">Limited seats</p>
            <h2 className="mt-2 font-serif text-3xl font-bold text-[#2b2449]">Secure your spot</h2>
            <p className="mt-2 text-sm leading-6 text-slate-600">Pay ₹100, upload the payment proof, and send us your details.</p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-6 p-6 sm:p-8">
            <div className="grid gap-5 sm:grid-cols-2">
              <label className="block sm:col-span-2">
                <span className="mb-2 block text-sm font-bold text-[#33294a]">Full name</span>
                <input required name="full_name" value={form.full_name} onChange={updateForm} autoComplete="name" className="w-full border border-[#dbc9af] px-4 py-3 outline-none transition focus:border-[#8b1b43] focus:ring-2 focus:ring-[#8b1b43]/15" placeholder="Your full name" />
              </label>
              <label className="block">
                <span className="mb-2 block text-sm font-bold text-[#33294a]">WhatsApp number</span>
                <input required name="whatsapp_number" value={form.whatsapp_number} onChange={updateForm} inputMode="tel" pattern="[0-9+() -]{8,20}" className="w-full border border-[#dbc9af] px-4 py-3 outline-none transition focus:border-[#8b1b43] focus:ring-2 focus:ring-[#8b1b43]/15" placeholder="e.g. 9323806706" />
              </label>
              <label className="block">
                <span className="mb-2 block text-sm font-bold text-[#33294a]">Date of birth</span>
                <input required type="date" name="dob" value={form.dob} onChange={updateForm} className="w-full border border-[#dbc9af] px-4 py-3 outline-none transition focus:border-[#8b1b43] focus:ring-2 focus:ring-[#8b1b43]/15" />
              </label>
            </div>

            <fieldset>
              <legend className="mb-2 text-sm font-bold text-[#33294a]">Gender</legend>
              <div className="flex gap-3">
                {["Male", "Female"].map((gender) => (
                  <label key={gender} className={`cursor-pointer border px-5 py-3 text-sm font-semibold transition ${form.gender === gender ? "border-[#8b1b43] bg-[#fff1f4] text-[#7b1d3b]" : "border-[#dbc9af] text-slate-600 hover:border-[#b77812]"}`}>
                    <input type="radio" name="gender" value={gender} checked={form.gender === gender} onChange={updateForm} className="sr-only" />
                    {gender}
                  </label>
                ))}
              </div>
            </fieldset>

            <label className="block">
              <span className="mb-2 block text-sm font-bold text-[#33294a]">Address</span>
              <textarea required name="address" value={form.address} onChange={updateForm} rows="3" className="w-full resize-y border border-[#dbc9af] px-4 py-3 outline-none transition focus:border-[#8b1b43] focus:ring-2 focus:ring-[#8b1b43]/15" placeholder="Your full address" />
            </label>

            <section className="border border-[#edd4a8] bg-[#fff9ed] p-5 sm:p-6">
              <div className="flex flex-col items-center gap-5 sm:flex-row sm:items-start">
                <img src="/veer_vanshaj_qr.jpeg" alt="Payment QR code" className="h-40 w-40 border-4 border-white object-contain shadow-sm" />
                <div className="text-center sm:text-left">
                  <p className="font-serif text-xl font-bold text-[#56203a]">Pay ₹100</p>
                  <p className="mt-1 text-sm leading-6 text-slate-600">Scan this QR code with any UPI app. The registration fee is non-refundable.</p>
                  <p className="mt-3 text-xs font-bold uppercase tracking-wide text-[#9a6518]">Then upload your payment screenshot</p>
                </div>
              </div>
            </section>

            <label className="block cursor-pointer border-2 border-dashed border-[#d7bf91] bg-[#fffdf8] p-5 text-center transition hover:border-[#8b1b43]">
              <input required type="file" accept="image/png,image/jpeg,image/webp" onChange={(event) => { setPaymentScreenshot(event.target.files?.[0] || null); setError(""); }} className="sr-only" />
              {paymentScreenshot ? (
                <span className="inline-flex items-center gap-2 text-sm font-bold text-[#27613d]"><CheckCircle2 size={20} /> {paymentScreenshot.name}</span>
              ) : (
                <span className="inline-flex items-center gap-2 text-sm font-bold text-[#7b1d3b]"><Upload size={20} /> Upload payment screenshot</span>
              )}
              <span className="mt-2 block text-xs text-slate-500">PNG, JPG, or WEBP · maximum 6 MB</span>
            </label>

            {error && <p className="flex items-center gap-2 border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700"><X size={16} /> {error}</p>}

            <button disabled={isSubmitting} type="submit" className="w-full bg-[#7b1d3b] px-5 py-4 font-bold text-white transition hover:bg-[#5e132d] disabled:cursor-not-allowed disabled:opacity-70">
              {isSubmitting ? "Submitting your registration…" : "Confirm registration"}
            </button>
          </form>
        </motion.section>
      </main>
    </div>
  );
}
