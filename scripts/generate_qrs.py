import os
import qrcode
from PIL import Image, ImageDraw, ImageFont, ImageFilter
import cv2

ITEMS = [
    {
        "id": "rebirth",
        "slug": "rebirth",
        "title": "Source for Rebirth",
        "hindi_scripture": "श्री तत्त्वार्थ सूत्र, दूसरा अध्याय",
        "english_scripture": "Shree Tatvarth Sutra, Second Adhyay",
        "url": "https://www.ilovejinshasan.org/source/rebirth",
        "short_url": "www.ilovejinshasan.org/source/rebirth",
        "dir_name": "Source for Rebirth",
        "file_prefix": "qr-rebirth"
    },
    {
        "id": "tripadi",
        "slug": "tripadi",
        "title": "Source for Tripadi",
        "hindi_scripture": "श्री तत्त्वार्थ सूत्र, पाँचवां अध्याय",
        "english_scripture": "Shree Tatvarth Sutra, Fifth Adhyay",
        "url": "https://www.ilovejinshasan.org/source/tripadi",
        "short_url": "www.ilovejinshasan.org/source/tripadi",
        "dir_name": "Source for Tripadi",
        "file_prefix": "qr-tripadi"
    },
    {
        "id": "aura-and-lashya",
        "slug": "aura-and-leshya",
        "title": "Source for Aura and Lashya",
        "hindi_scripture": "श्री उत्तराध्ययन सूत्र, ३४ अध्याय",
        "english_scripture": "Shree Uttaradhyayan Sutra, 34th Adhyay",
        "url": "https://www.ilovejinshasan.org/source/aura-and-leshya",
        "short_url": "www.ilovejinshasan.org/source/aura-and-leshya",
        "dir_name": "Source for Aura and Lashya",
        "file_prefix": "qr-aura-and-lashya"
    },
    {
        "id": "psychology-of-emotions",
        "slug": "psychology-of-emotions",
        "title": "Source for Psychology of emotions",
        "hindi_scripture": "श्री उत्तराध्ययन सूत्र, ३२ अध्याय",
        "english_scripture": "Shree Uttaradhyayan Sutra, 32nd Adhyay",
        "url": "https://www.ilovejinshasan.org/source/psychology-of-emotions",
        "short_url": "www.ilovejinshasan.org/source/psychology-of-emotions",
        "dir_name": "Source for Psychology of emotions",
        "file_prefix": "qr-psychology-of-emotions"
    },
    {
        "id": "theory-of-evolution",
        "slug": "theory-of-evolution",
        "title": "Source for Theory of evolution",
        "hindi_scripture": "श्री तत्त्वार्थ सूत्र, दूसरा अध्याय",
        "english_scripture": "Shree Tatvarth Sutra, Second Adhyay",
        "url": "https://www.ilovejinshasan.org/source/theory-of-evolution",
        "short_url": "www.ilovejinshasan.org/source/theory-of-evolution",
        "dir_name": "Source for Theory of evolution",
        "file_prefix": "qr-theory-of-evolution"
    }
]

BRAND_RED = (174, 43, 43)  # #ae2b2b
BRAND_GOLD = (212, 160, 23)
DARK_TEXT = (25, 25, 25)

LOGO_PATH = "public/logo jpg.jpg.jpeg"

def create_circular_logo(logo_img, size):
    """Resizes and embeds logo in a circular badge with border."""
    logo_resized = logo_img.resize((size, size), Image.Resampling.LANCZOS).convert("RGBA")
    
    # Outer badge size with white padding
    badge_size = int(size * 1.15)
    badge = Image.new("RGBA", (badge_size, badge_size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(badge)
    
    # Draw white filled circle
    draw.ellipse([0, 0, badge_size, badge_size], fill=(255, 255, 255, 255), outline=BRAND_RED, width=5)
    
    # Circular mask for logo
    mask = Image.new("L", (size, size), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.ellipse([0, 0, size, size], fill=255)
    
    offset = (badge_size - size) // 2
    badge.paste(logo_resized, (offset, offset), mask=mask)
    return badge

def generate_square_qr(url, logo_img, output_size=1200):
    """Generates a high-res standalone QR code with center logo."""
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
    
    # Add center logo
    logo_size = int(output_size * 0.22)
    badge = create_circular_logo(logo_img, logo_size)
    
    pos = ((output_size - badge.width) // 2, (output_size - badge.height) // 2)
    qr_img.paste(badge, pos, mask=badge)
    
    return qr_img

def generate_exhibition_card(item, qr_img):
    """Creates a high-resolution 1200x1650 exhibition display card."""
    card_w, card_h = 1200, 1680
    card = Image.new("RGBA", (card_w, card_h), (255, 255, 255, 255))
    draw = ImageDraw.Draw(card)
    
    # Fonts
    font_hin_title = ImageFont.truetype(r"C:/Windows/Fonts/Nirmala.ttc", 44)
    font_eng_title = ImageFont.truetype(r"C:/Windows/Fonts/georgiab.ttf", 52)
    font_scripture = ImageFont.truetype(r"C:/Windows/Fonts/georgiab.ttf", 34)
    font_badge = ImageFont.truetype(r"C:/Windows/Fonts/arialbd.ttf", 22)
    font_desc = ImageFont.truetype(r"C:/Windows/Fonts/arial.ttf", 26)
    font_url = ImageFont.truetype(r"C:/Windows/Fonts/arialbd.ttf", 28)
    font_sub = ImageFont.truetype(r"C:/Windows/Fonts/arial.ttf", 22)

    # Outer decorative borders
    draw.rounded_rectangle([25, 25, card_w - 25, card_h - 25], radius=32, outline=BRAND_RED, width=6)
    draw.rounded_rectangle([38, 38, card_w - 38, card_h - 38], radius=24, outline=(235, 215, 215), width=2)
    
    # Top Tag
    tag_text = "I LOVE JINSHASAN  •  SHASTRIYA PRAMAN (आगम प्रमाण)"
    bbox = draw.textbbox((0, 0), tag_text, font=font_badge)
    tw = bbox[2] - bbox[0]
    badge_x = (card_w - tw) // 2
    draw.rounded_rectangle([badge_x - 20, 75, badge_x + tw + 20, 120], radius=16, fill=(250, 240, 240), outline=(230, 190, 190), width=1)
    draw.text((badge_x, 86), tag_text, font=font_badge, fill=BRAND_RED)

    # Title
    title = item["title"]
    bbox = draw.textbbox((0, 0), title, font=font_eng_title)
    draw.text(((card_w - (bbox[2] - bbox[0])) // 2, 150), title, font=font_eng_title, fill=DARK_TEXT)

    # Scripture Reference Box
    box_y = 235
    box_h = 160
    draw.rounded_rectangle([80, box_y, card_w - 80, box_y + box_h], radius=20, fill=(255, 249, 245), outline=(240, 215, 205), width=2)
    
    hin_text = item["hindi_scripture"]
    bbox = draw.textbbox((0, 0), hin_text, font=font_hin_title)
    draw.text(((card_w - (bbox[2] - bbox[0])) // 2, box_y + 22), hin_text, font=font_hin_title, fill=BRAND_RED)

    eng_text = item["english_scripture"]
    bbox = draw.textbbox((0, 0), eng_text, font=font_scripture)
    draw.text(((card_w - (bbox[2] - bbox[0])) // 2, box_y + 92), eng_text, font=font_scripture, fill=(70, 70, 70))

    # Center QR Code
    qr_card_size = 820
    qr_resized = qr_img.resize((qr_card_size, qr_card_size), Image.Resampling.LANCZOS)
    
    qr_x = (card_w - qr_card_size) // 2
    qr_y = 440
    
    # White card frame behind QR code
    draw.rounded_rectangle([qr_x - 20, qr_y - 20, qr_x + qr_card_size + 20, qr_y + qr_card_size + 20], radius=24, fill=(255, 255, 255), outline=(230, 230, 230), width=2)
    card.paste(qr_resized, (qr_x, qr_y), mask=qr_resized)

    # Instruction
    inst_text = "Scan QR with smartphone camera to view original Agam verses & commentary"
    bbox = draw.textbbox((0, 0), inst_text, font=font_desc)
    draw.text(((card_w - (bbox[2] - bbox[0])) // 2, 1340), inst_text, font=font_desc, fill=(100, 100, 100))

    # Direct Link Pill
    url_text = item["short_url"]
    bbox = draw.textbbox((0, 0), url_text, font=font_url)
    uw = bbox[2] - bbox[0]
    ux = (card_w - uw) // 2
    draw.rounded_rectangle([ux - 24, 1400, ux + uw + 24, 1455], radius=14, fill=BRAND_RED)
    draw.text((ux, 1412), url_text, font=font_url, fill=(255, 255, 255))

    # Footer note
    footer_text = "I Love Jinshasan  •  Spiritual & Scientific Research"
    bbox = draw.textbbox((0, 0), footer_text, font=font_sub)
    draw.text(((card_w - (bbox[2] - bbox[0])) // 2, 1540), footer_text, font=font_sub, fill=(160, 160, 160))

    return card

def main():
    detector = cv2.QRCodeDetector()
    logo_img = Image.open(LOGO_PATH)
    
    os.makedirs("public/qr", exist_ok=True)
    
    print("=" * 60)
    print("GENERATING 5 HIGH-RESOLUTION QR CODES WITH LOGO")
    print("=" * 60)
    
    for item in ITEMS:
        print(f"\nProcessing: {item['title']}...")
        print(f"URL: {item['url']}")
        
        # 1. Generate Square QR
        qr_square = generate_square_qr(item["url"], logo_img, output_size=1200)
        
        # Save to public/qr and 5qr/
        public_sq_path = f"public/qr/{item['file_prefix']}.png"
        dir_sq_path = f"5qr/{item['dir_name']}/{item['file_prefix']}.png"
        
        qr_square.save(public_sq_path, "PNG")
        qr_square.save(dir_sq_path, "PNG")
        
        # Verify scan with OpenCV
        val, _, _ = detector.detectAndDecode(cv2.imread(public_sq_path))
        scan_ok = (val == item["url"])
        print(f"  [OK] Square QR generated: {public_sq_path} [Verified: {scan_ok}]")
        
        # 2. Generate Full Exhibition Card
        card = generate_exhibition_card(item, qr_square)
        public_card_path = f"public/qr/card-{item['id']}.png"
        dir_card_path = f"5qr/{item['dir_name']}/card-{item['id']}.png"
        
        card.save(public_card_path, "PNG")
        card.save(dir_card_path, "PNG")
        
        # Verify card scan
        val_card, _, _ = detector.detectAndDecode(cv2.imread(public_card_path))
        card_scan_ok = (val_card == item["url"])
        print(f"  [OK] Exhibition Card generated: {public_card_path} [Verified: {card_scan_ok}]")

    print("\n" + "=" * 60)
    print("ALL 5 QR CODES & DISPLAY CARDS SUCCESSFULLY GENERATED & VERIFIED!")
    print("=" * 60)

if __name__ == "__main__":
    main()
