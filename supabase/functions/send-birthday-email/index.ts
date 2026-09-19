import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const RESEND_API_KEY = Deno.env.get("RESEND_API_KEY");
const SUPABASE_URL = Deno.env.get("SUPABASE_URL");
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type, x-admin-secret",
};

function generateBirthdayEmailHtml(name: string): string {
  const volunteerName = name && name.trim().length > 0 ? name.trim() : "Volunteer";
  return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Happy Birthday from Team I ♥️ Jinshasan</title>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      background-color: #f7f5f5;
      margin: 0;
      padding: 0;
      -webkit-font-smoothing: antialiased;
    }
    .wrapper {
      max-width: 600px;
      margin: 30px auto;
      background-color: #ffffff;
      border-radius: 16px;
      overflow: hidden;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
      border: 1px solid #ebe5e5;
    }
    .header {
      background: linear-gradient(135deg, #ae2b2b 0%, #8b1f1f 100%);
      padding: 40px 24px;
      text-align: center;
      color: #ffffff;
    }
    .header-badge {
      display: inline-block;
      background: rgba(255, 255, 255, 0.2);
      border: 1px solid rgba(255, 255, 255, 0.4);
      padding: 6px 16px;
      border-radius: 20px;
      font-size: 13px;
      font-weight: 600;
      letter-spacing: 0.5px;
      margin-bottom: 12px;
      text-transform: uppercase;
    }
    .header h1 {
      margin: 0;
      font-size: 28px;
      font-weight: 800;
      letter-spacing: -0.5px;
    }
    .content {
      padding: 36px 32px;
      color: #2d3748;
      font-size: 16px;
      line-height: 1.7;
    }
    .salutation {
      font-size: 18px;
      font-weight: 700;
      color: #1a202c;
      margin-bottom: 18px;
    }
    .highlight-card {
      background: #fff8f8;
      border-left: 4px solid #ae2b2b;
      padding: 16px 20px;
      border-radius: 0 10px 10px 0;
      margin: 24px 0;
      color: #4a5568;
      font-style: italic;
    }
    .qr-section {
      background: #fafafa;
      border: 1px dashed #d1d5db;
      border-radius: 14px;
      padding: 24px;
      text-align: center;
      margin: 28px 0;
    }
    .qr-title {
      font-size: 15px;
      font-weight: 700;
      color: #1f2937;
      margin-bottom: 6px;
    }
    .qr-subtitle {
      font-size: 13px;
      color: #6b7280;
      margin-bottom: 16px;
    }
    .qr-image {
      max-width: 250px;
      width: 100%;
      height: auto;
      border-radius: 12px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
      border: 1px solid #e5e7eb;
      display: inline-block;
    }
    .closing {
      margin-top: 28px;
      font-size: 16px;
      color: #2d3748;
    }
    .closing strong {
      color: #ae2b2b;
      font-size: 17px;
    }
    .footer {
      background-color: #f7f5f5;
      padding: 24px;
      text-align: center;
      font-size: 12px;
      color: #8c9ba5;
      border-top: 1px solid #ede8e8;
    }
  </style>
</head>
<body>
  <div class="wrapper">
    <div class="header">
      <div class="header-badge">Birthday Wishes 🎂✨</div>
      <h1>Happy Birthday!</h1>
    </div>
    
    <div class="content">
      <div class="salutation">Dear ${volunteerName},</div>
      
      <p>
        Happy Birthday! 🎂✨ On your special day, Team I ♥️ Jinshasan wants to take a moment to celebrate you. 
        Your dedication, selfless service, and unwavering spirit bring immense light and positive energy to our mission. 
        We are deeply grateful to have you as a vital part of our family.
      </p>

      <div class="highlight-card">
        May this year bring you boundless joy, vibrant health, great success, and deeper spiritual fulfillment. Keep shining and inspiring those around you!
      </div>

      <p>
        As you celebrate your special day, you can also make it more meaningful by supporting our noble cause. Scan the QR code below to make a voluntary contribution and help us spread goodness further.
      </p>

      <div class="qr-section">
        <div class="qr-title">Support Our Mission 🌸</div>
        <div class="qr-subtitle">Scan via Paytm / PhonePe / GPay / Any UPI App</div>
        <a href="https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/email-assets/birthday-donation-qr.jpeg" target="_blank" style="text-decoration: none;">
          <img 
            src="https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/email-assets/birthday-donation-qr.jpeg" 
            alt="Contribute via Paytm / UPI - 9769045975@ptyes" 
            class="qr-image"
          />
        </a>
        <div style="font-size: 13px; color: #4b5563; margin-top: 10px; font-weight: 600;">
          UPI ID: <span style="color: #ae2b2b;">9769045975@ptyes</span>
        </div>
      </div>

      <div class="closing">
        Warm regards,<br/>
        <strong>Team I ♥️ Jinshasan</strong>
      </div>
    </div>

    <div class="footer">
      <p style="margin: 0 0 6px 0;">&copy; ${new Date().getFullYear()} Team I ♥️ Jinshasan. All rights reserved.</p>
      <p style="margin: 0;">You received this email because you are a cherished member of the I Love Jinshasan volunteer family.</p>
    </div>
  </div>
</body>
</html>
  `.trim();
}

async function sendEmailViaResend(to: string, name: string): Promise<{ success: boolean; id?: string; error?: string }> {
  if (!RESEND_API_KEY) {
    return { success: false, error: "RESEND_API_KEY not configured" };
  }

  const html = generateBirthdayEmailHtml(name);

  try {
    const res = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${RESEND_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        from: "Team I ♥️ Jinshasan <no-reply@emails.ilovejinshasan.org>",
        to: [to],
        subject: "Happy Birthday from Team I ♥️ Jinshasan! 🎂✨",
        html: html,
        attachments: [
          {
            filename: "donation-qr.jpeg",
            path: "https://pdcgcqsgzupoyzklvoju.supabase.co/storage/v1/object/public/project-gallery/email-assets/birthday-donation-qr.jpeg",
          },
        ],
      }),
    });

    const data = await res.json();
    if (!res.ok) {
      console.error("Resend API error:", data);
      return { success: false, error: data?.message || "Failed to send email" };
    }

    return { success: true, id: data.id };
  } catch (err: any) {
    console.error("Error sending email via Resend:", err);
    return { success: false, error: err.message };
  }
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabase = createClient(
      SUPABASE_URL ?? "",
      SUPABASE_SERVICE_ROLE_KEY ?? ""
    );

    let body: any = {};
    if (req.method === "POST") {
      try {
        const text = await req.text();
        if (text) body = JSON.parse(text);
      } catch (e) {
        console.warn("Could not parse request body as JSON:", e);
      }
    }

    // 1. Test Mode: Send to explicit test_email
    if (body.test_email) {
      console.log(`Sending test birthday email to ${body.test_email}`);
      const result = await sendEmailViaResend(body.test_email, body.name || "Test Volunteer");
      return new Response(JSON.stringify({ mode: "test", ...result }), {
        status: result.success ? 200 : 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // 2. Fetch today's birthdays in IST
    const currentYear = new Date().getFullYear();
    const { data: volunteers, error: rpcError } = await supabase.rpc("get_todays_birthdays");

    if (rpcError) {
      console.error("RPC get_todays_birthdays error:", rpcError);
      throw rpcError;
    }

    console.log(`Found ${volunteers?.length || 0} birthdays to process today.`);

    const results = [];
    if (volunteers && volunteers.length > 0) {
      for (const vol of volunteers) {
        const fullName = `${vol.first_name || ""} ${vol.last_name || ""}`.trim();
        const sendResult = await sendEmailViaResend(vol.email, vol.first_name || fullName);

        if (sendResult.success) {
          // Log sent email to prevent duplicate sends
          await supabase.from("birthday_email_logs").insert({
            volunteer_id: vol.id,
            email: vol.email,
            sent_year: currentYear,
            status: "sent",
            resend_id: sendResult.id,
          });
        } else {
          // Log failure
          await supabase.from("birthday_email_logs").insert({
            volunteer_id: vol.id,
            email: vol.email,
            sent_year: currentYear,
            status: "failed",
          });
        }

        results.push({
          id: vol.id,
          ilj_id: vol.ilj_id,
          name: fullName,
          email: vol.email,
          ...sendResult,
        });
      }
    }

    return new Response(
      JSON.stringify({
        success: true,
        processed_count: volunteers?.length || 0,
        results,
      }),
      {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (error: any) {
    console.error("Top-level function error:", error);
    return new Response(
      JSON.stringify({ success: false, error: error.message }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  }
});
