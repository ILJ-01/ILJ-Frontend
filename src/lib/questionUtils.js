/**
 * Question Thread & WhatsApp Utilities for /ask-question
 */

/**
 * Encodes a numeric ticket number into a clean, URL-safe string
 * e.g., 1001 -> 'SUxKLVExMDAx'
 */
export function encodeQuestionToken(ticketNo) {
  if (!ticketNo) return "";
  try {
    const raw = `ILJ-Q${ticketNo}`;
    const b64 = btoa(raw)
      .replace(/=/g, '')
      .replace(/\+/g, '-')
      .replace(/\//g, '_');
    return b64;
  } catch (err) {
    console.error("Error encoding ticket:", err);
    return String(ticketNo);
  }
}

/**
 * Decodes a URL-safe token back to the numeric ticket number
 */
export function decodeQuestionToken(token) {
  if (!token || typeof token !== 'string') return null;
  try {
    let str = token.replace(/-/g, '+').replace(/_/g, '/');
    while (str.length % 4 !== 0) str += '=';
    const decoded = atob(str);
    const match = decoded.match(/ILJ-Q(\d+)/i);
    if (match) {
      return parseInt(match[1], 10);
    }
  } catch (err) {
    // Not a base64 encoded token
  }
  return null;
}

/**
 * Sanitizes and formats an Indian phone number for wa.me links
 * e.g. "09172387009" -> "919172387009"
 * e.g. "9172387009"  -> "919172387009"
 * e.g. "+91 98200 12345" -> "919820012345"
 */
export function formatWhatsAppPhone(rawPhone) {
  if (!rawPhone) return "";
  let digits = String(rawPhone).replace(/\D/g, '');
  // Remove leading zeros (e.g. 09172387009 -> 9172387009)
  if (digits.startsWith('0')) {
    digits = digits.replace(/^0+/, '');
  }
  // Standard 10-digit Indian mobile number: prepend 91
  if (digits.length === 10) {
    digits = `91${digits}`;
  }
  return digits;
}

/**
 * Generates the full thread URL using current origin or production fallback
 */
export function getQuestionThreadUrl(tokenOrId) {
  const origin = typeof window !== 'undefined' && window.location.origin 
    ? window.location.origin 
    : 'https://www.ilovejinshasan.org';
  return `${origin}/ask-question?thread=${encodeURIComponent(tokenOrId)}`;
}

/**
 * Generates the WhatsApp link with prefilled dynamic message
 */
export function generateWhatsAppLink(phone, name, threadUrl) {
  const cleanPhone = formatWhatsAppPhone(phone);
  if (!cleanPhone) return "";

  const greetingName = name ? name.trim() : "Friend";
  const message = `Jai Jinendra ${greetingName},

We have replied to your question on I Love Jinshasan.

Click the link below to view the answer and continue the conversation:
${threadUrl}

Warm regards,
I Love Jinshasan Team`;

  return `https://wa.me/${cleanPhone}?text=${encodeURIComponent(message)}`;
}
