import { createElement, useState } from "react";
import {
  CalendarDays, CheckCircle2, Clock3, Heart, IndianRupee, MapPin,
  Download, MessageCircle, Upload, Users, Utensils, X, ZoomIn
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
    email: "",
    dob: "",
    gender: "Male",
    address: "",
  });
  const [paymentScreenshot, setPaymentScreenshot] = useState(null);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [error, setError] = useState("");
  const [isQrModalOpen, setIsQrModalOpen] = useState(false);

  const updateForm = (event) => {
    const { name, value } = event.target;
    setForm((current) => ({ ...current, [name]: value }));
  };

  const handleDownloadQr = () => {
    const link = document.createElement("a");
    link.href = "/veer_vanshaj_qr.jpeg";
    link.download = "Reconnect_Payment_QR.jpeg";
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
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

      const { count, error: countError } = await supabase
        .from("event_registrations")
        .select("id", { count: "exact", head: true })
        .eq("project_id", RECONNECT_PROJECT_ID);
      if (countError) throw countError;

      const registrationId = `RC-${String((count || 0) + 1).padStart(3, "0")}`;

      const { error: insertError } = await supabase
        .from("event_registrations")
        .insert({
          project_id: RECONNECT_PROJECT_ID,
          full_name: form.full_name.trim(),
          whatsapp_number: form.whatsapp_number.trim(),
          mobile_number: form.whatsapp_number.trim(),
          email: form.email.trim() || null,
          dob: form.dob,
          gender: form.gender,
          address: form.address.trim(),
          payment_screenshot_url: publicUrlData.publicUrl,
          supported_file_url: registrationId,
        });
      if (insertError) throw insertError;

      if (form.email.trim()) {
        try {
          const { error: emailError } = await supabase.functions.invoke("send-event-registration-email", {
            body: {
              to: form.email.trim(),
              applicant_name: form.full_name.trim(),
              project_title: "RECONNECT – with Soul, Shasan and Nature",
              registration_id: registrationId,
              event_date: "5th – 7th November 2026 (3 Days)",
              timing: "8:00 AM – 7:00 PM",
              venue: "Shree Riddhi Siddhi Aadarsh Shwetambar Murtipujak Jain Sangh, Marve Road, Malad (W)",
              amount_paid: "₹100/- (refundable)",
              whatsapp_link: WHATSAPP_GROUP_URL,
            },
          });
          if (emailError) console.error("Reconnect confirmation email failed:", emailError);
        } catch (emailError) {
          console.error("Reconnect confirmation email failed:", emailError);
        }
      }

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
      <div className="min-h-screen bg-gray-50 px-4 py-12 sm:px-6 sm:py-16">
        <section
          className="mx-auto max-w-xl rounded-2xl border border-gray-100 bg-white px-6 py-10 text-center shadow-xl sm:px-10"
        >
          <div className="mx-auto mb-5 grid h-16 w-16 place-items-center rounded-full bg-green-100 text-green-600">
            <CheckCircle2 size={34} />
          </div>
          <p className="mb-2 text-xs font-bold uppercase tracking-[0.26em] text-[#ae2b2b]">Reconnect 2026</p>
          <h1 className="font-serif text-4xl font-bold text-gray-900">Your spot is reserved.</h1>
          <p className="mx-auto mt-4 max-w-md leading-7 text-slate-600">
            Thank you, {form.full_name}. We have received your registration and payment proof for Reconnect.
            {form.email ? " A confirmation email has been sent to your inbox." : ""}
          </p>
          <div className="my-7 rounded-xl border border-amber-200 bg-amber-50/60 p-5 text-left text-sm leading-7 text-gray-700">
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
        </section>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 px-3 py-6 font-sans sm:px-6 sm:py-12">
      <div className="mx-auto max-w-6xl overflow-hidden rounded-2xl border border-gray-100 bg-white shadow-xl">
      <section className="relative isolate overflow-hidden bg-gradient-to-r from-[#4a0d0d] via-[#821818] to-[#ae2b2b] px-5 py-8 text-white sm:px-8 sm:py-10">
        <div className="absolute right-0 top-0 -mr-14 -mt-14 -z-10 h-56 w-56 rounded-full bg-white/10" />
        <div className="relative z-10">
          <div className="mb-4 inline-flex items-center gap-2 rounded bg-black/25 px-3 py-1 text-xs font-bold uppercase tracking-[0.21em] text-amber-200">
            <Heart size={15} fill="currentColor" /> A 3-day Diwali camp
          </div>
          <h1 className="font-serif text-4xl font-bold tracking-tight sm:text-5xl">RECONNECT</h1>
          <p className="mt-1 font-serif text-2xl italic text-amber-200 sm:text-3xl">with Soul · Shasan · Nature</p>
          <p className="mt-4 max-w-3xl text-sm font-medium leading-6 text-white/90 sm:text-base">Escape the noise. Enter the calm. Reconnect with what matters.</p>
          <p className="mt-6 max-w-4xl border-t border-white/20 pt-4 text-sm leading-6 text-white/90">
            Blessings &amp; Divine Presence: Aacharya Shree Vimalkirti Suriji M.S. and Sadhviji Shree Jinrakshita Shreeji M.S.
          </p>
        </div>
      </section>

      <main className="grid gap-8 p-5 sm:p-8 lg:grid-cols-[0.82fr_1.18fr]">
        <aside className="space-y-6">
          <div>
            <p className="text-xs font-bold uppercase tracking-[0.2em] text-[#ae2b2b]">Samvat 2083 starts here</p>
            <h2 className="mt-2 font-serif text-2xl font-bold leading-tight text-gray-900">Good people. Brighter tomorrows.</h2>
          </div>

          <div className="grid grid-cols-1 gap-3 sm:grid-cols-2">
            {[
              [CalendarDays, "Dates", "5–7 November 2026"],
              [Clock3, "Time", "8 AM to 7 PM"],
              [Users, "For", "Boys and girls · Age 11–18"],
              [IndianRupee, "Fees", "₹100 · refundable"],
              [Utensils, "Included", "Breakfast, lunch & dinner"],
              [MapPin, "Venue", "Malad (W), Mumbai"],
            ].map(([Icon, label, value]) => (
              <div key={label} className="flex gap-3 rounded-xl border border-amber-200/70 bg-amber-50/60 p-3">
                {createElement(Icon, { size: 20, className: "mt-0.5 shrink-0 text-[#ae2b2b]" })}
                <div><p className="text-[10px] font-bold uppercase tracking-wider text-amber-900">{label}</p>
                <p className="mt-0.5 text-sm font-semibold leading-5 text-gray-800">{value}</p></div>
              </div>
            ))}
          </div>

          <div className="rounded-xl border border-amber-200/70 bg-amber-50/60 p-5">
            <p className="font-serif text-lg font-bold text-amber-900">What awaits you</p>
            <ul className="mt-3 space-y-2 text-sm leading-5 text-gray-700">
              {highlights.map((highlight) => <li key={highlight}>• {highlight}</li>)}
            </ul>
          </div>

          <p className="rounded-xl bg-gray-50 p-4 text-sm leading-6 text-gray-600">
            <strong className="text-gray-900">Venue:</strong> Shree Riddhi Siddhi Aadarsh Shwetambar Murtipujak Jain Sangh, Marve Road, Malad (W).<br />
            <strong className="text-gray-900">Contact:</strong> 9323806706 · Limited seats.
          </p>
        </aside>

        <section className="overflow-hidden rounded-xl border border-gray-100 bg-white shadow-sm">
          <div className="border-b border-gray-100 bg-gray-50 p-6">
            <p className="text-xs font-bold uppercase tracking-[0.2em] text-[#ae2b2b]">Limited seats</p>
            <h2 className="mt-2 font-serif text-2xl font-bold text-gray-900">Secure your spot</h2>
            <p className="mt-2 text-sm leading-6 text-gray-600">Pay ₹100, upload the payment proof, and send us your details.</p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-6 p-6">
            <div className="grid gap-5 sm:grid-cols-2">
              <label className="block sm:col-span-2">
                <span className="mb-2 block text-sm font-bold text-gray-700">Full name</span>
                <input required name="full_name" value={form.full_name} onChange={updateForm} autoComplete="name" className="w-full rounded-lg border border-gray-300 px-4 py-3 outline-none transition focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15" placeholder="Your full name" />
              </label>
              <label className="block">
                <span className="mb-2 block text-sm font-bold text-gray-700">WhatsApp number</span>
                <input required name="whatsapp_number" value={form.whatsapp_number} onChange={updateForm} inputMode="tel" pattern="[0-9+() -]{8,20}" className="w-full rounded-lg border border-gray-300 px-4 py-3 outline-none transition focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15" placeholder="e.g. 9323806706" />
              </label>
              <label className="block">
                <span className="mb-2 block text-sm font-bold text-gray-700">Email</span>
                <input type="email" name="email" value={form.email} onChange={updateForm} autoComplete="email" className="w-full rounded-lg border border-gray-300 px-4 py-3 outline-none transition focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15" placeholder="you@example.com" />
              </label>
              <label className="block">
                <span className="mb-2 block text-sm font-bold text-gray-700">Date of birth</span>
                <input required type="date" name="dob" value={form.dob} onChange={updateForm} className="w-full rounded-lg border border-gray-300 px-4 py-3 outline-none transition focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15" />
              </label>
            </div>

            <fieldset>
              <legend className="mb-2 text-sm font-bold text-gray-700">Gender</legend>
              <div className="flex gap-3">
                {["Male", "Female"].map((gender) => (
                  <label key={gender} className={`cursor-pointer rounded-lg border px-5 py-3 text-sm font-semibold transition ${form.gender === gender ? "border-[#ae2b2b] bg-red-50 text-[#ae2b2b]" : "border-gray-300 text-gray-600 hover:border-[#ae2b2b]"}`}>
                    <input type="radio" name="gender" value={gender} checked={form.gender === gender} onChange={updateForm} className="sr-only" />
                    {gender}
                  </label>
                ))}
              </div>
            </fieldset>

            <label className="block">
              <span className="mb-2 block text-sm font-bold text-gray-700">Address</span>
              <textarea required name="address" value={form.address} onChange={updateForm} rows="3" className="w-full resize-y rounded-lg border border-gray-300 px-4 py-3 outline-none transition focus:border-[#ae2b2b] focus:ring-2 focus:ring-[#ae2b2b]/15" placeholder="Your full address" />
            </label>

            <section className="relative overflow-hidden rounded-2xl border border-gray-100 bg-white p-5 shadow-sm sm:p-6">
              <div className="absolute inset-y-0 left-0 w-1.5 bg-[#ae2b2b]" />
              <div className="mb-5 flex items-center gap-3 border-b border-gray-100 pb-4">
                <div className="rounded-xl bg-red-50 p-2 text-[#ae2b2b]"><IndianRupee size={20} /></div>
                <div><h3 className="font-serif text-xl font-bold text-gray-900">Payment &amp; verification</h3><p className="text-xs text-gray-500">Your seat is confirmed after payment proof is uploaded.</p></div>
              </div>
              <div className="flex flex-col items-center gap-6 rounded-xl border border-gray-100 bg-gray-50/70 p-5 xl:flex-row xl:items-start">
                <div className="flex w-full shrink-0 flex-col items-center sm:w-auto">
                  <button type="button" onClick={() => setIsQrModalOpen(true)} className="group relative rounded-xl border border-gray-200 bg-white p-3 shadow-sm transition hover:border-[#ae2b2b]/50 hover:shadow-md" title="Click to enlarge QR code">
                    <img src="/veer_vanshaj_qr.jpeg" alt="Reconnect payment QR code" className="h-52 w-48 rounded-lg object-contain sm:h-56 sm:w-52" />
                    <span className="absolute inset-0 flex flex-col items-center justify-center gap-1.5 rounded-xl bg-black/40 text-xs font-bold text-white opacity-0 backdrop-blur-[1px] transition-opacity group-hover:opacity-100"><ZoomIn size={27} />Click to enlarge</span>
                    <span className="mt-2 flex items-center justify-center gap-1 text-[11px] font-semibold text-[#ae2b2b]"><ZoomIn size={14} />Tap to zoom QR</span>
                  </button>
                  <button type="button" onClick={handleDownloadQr} className="mt-2.5 flex w-full items-center justify-center gap-1.5 rounded-lg border border-gray-300 bg-white px-3 py-2 text-xs font-semibold text-gray-800 shadow-sm transition hover:bg-gray-100"><Download size={14} className="text-[#ae2b2b]" />Download QR code</button>
                </div>
                <div className="min-w-0 text-center xl:text-left">
                  <span className="inline-block rounded-full bg-amber-100 px-3 py-1 text-xs font-bold uppercase tracking-wider text-amber-800">Reconnect · 3-day Diwali camp</span>
                  <h4 className="mt-3 font-serif text-xl font-bold text-gray-900">Scan to pay ₹100</h4>
                  <p className="mt-2 text-sm leading-6 text-gray-600">Use any UPI app—GPay, PhonePe, Paytm, or your banking app—to scan this QR code. The fee is refundable.</p>
                  <p className="mt-3 inline-block rounded-lg border border-red-100 bg-red-50 p-3 text-xs font-semibold text-[#ae2b2b]">After successful payment, upload the screenshot below for verification.</p>
                  <div className="mt-4 flex flex-wrap justify-center gap-2 text-xs font-medium text-gray-600 xl:justify-start">
                    <span className="rounded-full bg-white px-3 py-1.5 shadow-sm">1. Scan &amp; pay</span>
                    <span className="rounded-full bg-white px-3 py-1.5 shadow-sm">2. Upload proof</span>
                    <span className="rounded-full bg-white px-3 py-1.5 shadow-sm">3. Confirm seat</span>
                  </div>
                </div>
              </div>
            </section>

            <label className="block cursor-pointer rounded-xl border-2 border-dashed border-gray-300 bg-gray-50 p-5 text-center transition hover:border-[#ae2b2b]">
              <input required type="file" accept="image/png,image/jpeg,image/webp" onChange={(event) => { setPaymentScreenshot(event.target.files?.[0] || null); setError(""); }} className="sr-only" />
              {paymentScreenshot ? (
                <span className="inline-flex items-center gap-2 text-sm font-bold text-[#27613d]"><CheckCircle2 size={20} /> {paymentScreenshot.name}</span>
              ) : (
                <span className="inline-flex items-center gap-2 text-sm font-bold text-[#ae2b2b]"><Upload size={20} /> Upload payment screenshot</span>
              )}
              <span className="mt-2 block text-xs text-slate-500">PNG, JPG, or WEBP · maximum 6 MB</span>
            </label>

            {error && <p className="flex items-center gap-2 border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700"><X size={16} /> {error}</p>}

            <button disabled={isSubmitting} type="submit" className="w-full rounded-lg bg-[#ae2b2b] px-5 py-4 font-bold text-white shadow-md transition hover:bg-[#8f1f1f] disabled:cursor-not-allowed disabled:opacity-70">
              {isSubmitting ? "Submitting your registration…" : "Confirm registration"}
            </button>
          </form>
        </section>
      </main>
      </div>
      {isQrModalOpen && (
        <div className="fixed inset-0 z-[9999] flex items-center justify-center bg-black/80 p-4 backdrop-blur-sm" onClick={() => setIsQrModalOpen(false)}>
          <div className="relative flex w-full max-w-md flex-col items-center rounded-2xl bg-white p-5 shadow-2xl sm:p-6" onClick={(event) => event.stopPropagation()}>
            <button type="button" onClick={() => setIsQrModalOpen(false)} className="absolute right-3.5 top-3.5 rounded-full bg-gray-100 p-2 text-gray-400 transition hover:bg-gray-200 hover:text-gray-900" aria-label="Close QR modal"><X size={20} /></button>
            <h3 className="mb-1 font-serif text-xl font-bold text-gray-900">Scan to pay ₹100</h3>
            <p className="mb-4 text-center text-xs text-gray-500">Reconnect registration fee · Non-refundable</p>
            <div className="flex w-full justify-center rounded-xl border border-gray-200 bg-gray-50 p-3 shadow-inner sm:p-4"><img src="/veer_vanshaj_qr.jpeg" alt="Enlarged Reconnect payment QR code" className="max-h-[60vh] w-full rounded-lg object-contain shadow-sm" /></div>
            <div className="mt-4 flex w-full gap-2">
              <button type="button" onClick={handleDownloadQr} className="flex flex-1 items-center justify-center gap-2 rounded-xl bg-[#ae2b2b] px-4 py-2.5 text-xs font-bold text-white shadow-md transition hover:bg-[#8f1f1f]"><Download size={16} />Download QR code</button>
              <button type="button" onClick={() => setIsQrModalOpen(false)} className="rounded-xl bg-gray-100 px-4 py-2.5 text-xs font-semibold text-gray-700 transition hover:bg-gray-200">Close</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
