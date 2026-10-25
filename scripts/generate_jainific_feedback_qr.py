import os
import qrcode
from PIL import Image, ImageDraw, ImageFont
import cv2

BRAND_RED = (174, 43, 43)    # #ae2b2b
BRAND_DARK = (45, 12, 12)
BRAND_GOLD = (212, 160, 23)
DARK_TEXT = (25, 25, 25)

LOGO_PATH = "public/logo jpg.jpg.jpeg"
FEEDBACK_URL = "https://www.ilovejinshasan.org/jainific-feedback"
SHORT_URL = "www.ilovejinshasan.org/jainific-feedback"

def create_circular_logo(logo_img, size):
    """Resizes and embeds logo in a circular badge with border."""
    logo_resized = logo_img.resize((size, size), Image.Resampling.LANCZOS).convert("RGBA")
    badge_size = int(size * 1.15)
    badge = Image.new("RGBA", (badge_size, badge_size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(badge)
    
    # White background circle with brand red ring
    draw.ellipse([0, 0, badge_size, badge_size], fill=(255, 255, 255, 255), outline=BRAND_RED, width=5)
    
    # Circular mask for logo
    mask = Image.new("L", (size, size), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.ellipse([0, 0, size, size], fill=255)
    
    offset = (badge_size - size) // 2
    badge.paste(logo_resized, (offset, offset), mask=mask)
    return badge

def generate_square_qr(url, logo_img, output_size=1200):
    """Generates high-res standalone QR code with center logo."""
    qr = qrcode.QRCode(
        version=None,
        error_correction=qrcode.constants.ERROR_CORRECT_H,
        box_size=24,
        border=3
    )
    qr.add_data(url)
    qr.make(fit=True)
    
    qr_img = qr.make_image(fill_color="#ae2b2b", back_color="white").convert("RGBA")
    qr_img = qr_img.resize((output_size, output_size), Image.Resampling.LANCZOS)
    
    logo_size = int(output_size * 0.22)
    badge = create_circular_logo(logo_img, logo_size)
    pos = ((output_size - badge.width) // 2, (output_size - badge.height) // 2)
    qr_img.paste(badge, pos, mask=badge)
    return qr_img

def generate_feedback_card(qr_img):
    """Creates a high-resolution 1200x1680 exhibition display card for Jainific 3.0 feedback."""
    card_w, card_h = 1200, 1680
    card = Image.new("RGBA", (card_w, card_h), (255, 255, 255, 255))
    draw = ImageDraw.Draw(card)
    
    # Fonts
    font_hin_title = ImageFont.truetype(r"C:/Windows/Fonts/Nirmala.ttc", 40)
    font_main_title = ImageFont.truetype(r"C:/Windows/Fonts/georgiab.ttf", 52)
    font_event_sub = ImageFont.truetype(r"C:/Windows/Fonts/georgiab.ttf", 30)
    font_venue = ImageFont.truetype(r"C:/Windows/Fonts/arial.ttf", 25)
    font_badge = ImageFont.truetype(r"C:/Windows/Fonts/arialbd.ttf", 22)
    font_desc = ImageFont.truetype(r"C:/Windows/Fonts/arial.ttf", 26)
    font_url = ImageFont.truetype(r"C:/Windows/Fonts/arialbd.ttf", 28)
    font_sub = ImageFont.truetype(r"C:/Windows/Fonts/arial.ttf", 22)

    # Outer decorative borders
    draw.rounded_rectangle([25, 25, card_w - 25, card_h - 25], radius=32, outline=BRAND_RED, width=6)
    draw.rounded_rectangle([38, 38, card_w - 38, card_h - 38], radius=24, outline=(235, 215, 215), width=2)
    
    # Top Tag Badge
    tag_text = "I LOVE JINSHASAN  •  EXHIBITION FEEDBACK"
    bbox = draw.textbbox((0, 0), tag_text, font=font_badge)
    tw = bbox[2] - bbox[0]
    badge_x = (card_w - tw) // 2
    draw.rounded_rectangle([badge_x - 22, 65, badge_x + tw + 22, 110], radius=16, fill=(250, 240, 240), outline=(230, 190, 190), width=1)
    draw.text((badge_x, 76), tag_text, font=font_badge, fill=BRAND_RED)

    # Main Title
    title = "Jainific 3.0 Malad — Feedback"
    bbox = draw.textbbox((0, 0), title, font=font_main_title)
    draw.text(((card_w - (bbox[2] - bbox[0])) // 2, 135), title, font=font_main_title, fill=DARK_TEXT)

    # Event Details Reference Box
    box_y = 215
    box_h = 175
    draw.rounded_rectangle([80, box_y, card_w - 80, box_y + box_h], radius=20, fill=(255, 249, 245), outline=(240, 215, 205), width=2)
    
    date_time_text = "Date: 1st November 2026   |   Time: 11:00 AM to 8:00 PM"
    bbox = draw.textbbox((0, 0), date_time_text, font=font_event_sub)
    draw.text(((card_w - (bbox[2] - bbox[0])) // 2, box_y + 24), date_time_text, font=font_event_sub, fill=BRAND_RED)

    venue_text = "Venue: MKES Law College, N.K. College Campus, SV Road, Malad (West)"
    bbox = draw.textbbox((0, 0), venue_text, font=font_venue)
    draw.text(((card_w - (bbox[2] - bbox[0])) // 2, box_y + 75), venue_text, font=font_venue, fill=(60, 60, 60))

    tagline = "A Scientific Lens: Connecting Jain Philosophy & Modern Science"
    bbox = draw.textbbox((0, 0), tagline, font=font_sub)
    draw.text(((card_w - (bbox[2] - bbox[0])) // 2, box_y + 122), tagline, font=font_sub, fill=(120, 120, 120))

    # Center QR Code
    qr_card_size = 800
    qr_resized = qr_img.resize((qr_card_size, qr_card_size), Image.Resampling.LANCZOS)
    
    qr_x = (card_w - qr_card_size) // 2
    qr_y = 430
    
    draw.rounded_rectangle([qr_x - 20, qr_y - 20, qr_x + qr_card_size + 20, qr_y + qr_card_size + 20], radius=24, fill=(255, 255, 255), outline=(230, 230, 230), width=2)
    card.paste(qr_resized, (qr_x, qr_y), mask=qr_resized)

    # Instruction
    inst_text = "Scan QR with your phone camera to share your valuable review"
    bbox = draw.textbbox((0, 0), inst_text, font=font_desc)
    draw.text(((card_w - (bbox[2] - bbox[0])) // 2, 1300), inst_text, font=font_desc, fill=(90, 90, 90))

    # Direct Link Pill
    bbox = draw.textbbox((0, 0), SHORT_URL, font=font_url)
    uw = bbox[2] - bbox[0]
    ux = (card_w - uw) // 2
    draw.rounded_rectangle([ux - 24, 1360, ux + uw + 24, 1415], radius=14, fill=BRAND_RED)
    draw.text((ux, 1372), SHORT_URL, font=font_url, fill=(255, 255, 255))

    # Footer note
    footer_text = "I Love Jinshasan  •  Voices of Impact & Inspiration"
    bbox = draw.textbbox((0, 0), footer_text, font=font_sub)
    draw.text(((card_w - (bbox[2] - bbox[0])) // 2, 1530), footer_text, font=font_sub, fill=(160, 160, 160))

    return card

def main():
    detector = cv2.QRCodeDetector()
    logo_img = Image.open(LOGO_PATH)
    os.makedirs("public/qr", exist_ok=True)

    print("Generating Jainific 3.0 Feedback QR Code...")
    print(f"URL: {FEEDBACK_URL}")

    # 1. Square Standalone QR
    qr_square = generate_square_qr(FEEDBACK_URL, logo_img, output_size=1200)
    sq_path = "public/qr/qr-jainific-feedback.png"
    qr_square.save(sq_path, "PNG")

    # Verify scan
    val, _, _ = detector.detectAndDecode(cv2.imread(sq_path))
    print(f"[OK] Square QR saved: {sq_path} [Verified Scan: {val == FEEDBACK_URL}]")

    # 2. Exhibition Display Card
    card = generate_feedback_card(qr_square)
    card_path = "public/qr/card-jainific-feedback.png"
    card.save(card_path, "PNG")

    val_card, _, _ = detector.detectAndDecode(cv2.imread(card_path))
    print(f"[OK] Exhibition Card saved: {card_path} [Verified Scan: {val_card == FEEDBACK_URL}]")

if __name__ == "__main__":
    main()
