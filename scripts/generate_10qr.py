import os
import qrcode
from PIL import Image, ImageDraw, ImageFont, ImageFilter
import cv2

# New source items
ITEMS = [
    {
        "id": "theory-of-karma",
        "slug": "theory-of-karma",
        "title": "Source for Theory of Karma",
        "hindi_scripture": "श्री तत्त्वार्थ सूत्र, आठवां अध्याय",
        "english_scripture": "Shree Tatvarth Sutra, 8th Adhyay",
        "url": "https://www.ilovejinshasan.org/source/theory-of-karma",
        "short_url": "www.ilovejinshasan.org/source/theory-of-karma",
        "dir_name": "Source for Theory of Karma",
        "file_prefix": "qr-theory-of-karma"
    },
    {
        "id": "aparigraha",
        "slug": "aparigraha",
        "title": "Source for Aparigraha",
        "hindi_scripture": "श्री उत्तराध्ययन सूत्र, ९ अध्याय",
        "english_scripture": "Shree Uttaradhyayan Sutra, 9th Adhyay",
        "url": "https://www.ilovejinshasan.org/source/aparigraha",
        "short_url": "www.ilovejinshasan.org/source/aparigraha",
        "dir_name": "Source for Aparigraha",
        "file_prefix": "qr-aparigraha"
    },
    {
        "id": "anekantvad",
        "slug": "anekantvad",
        "title": "Source for Anekantvad",
        "hindi_scripture": "श्री तत्त्वार्थ सूत्र, पांचवां अध्याय",
        "english_scripture": "Shree Tatvarth Sutra, 5th Adhyay",
        "url": "https://www.ilovejinshasan.org/source/anekantvad",
        "short_url": "www.ilovejinshasan.org/source/anekantvad",
        "dir_name": "Source for Anekantvad",
        "file_prefix": "qr-anekantvad"
    },
    {
        "id": "sustainability",
        "slug": "sustainability",
        "title": "Source for Sustainability",
        "hindi_scripture": "",
        "english_scripture": "",
        "url": "https://www.ilovejinshasan.org/source/sustainability",
        "short_url": "www.ilovejinshasan.org/source/sustainability",
        "dir_name": "Source for Sustainability",
        "file_prefix": "qr-sustainability"
    },
    {
        "id": "food-science",
        "slug": "food-science",
        "title": "Source for Food Science",
        "hindi_scripture": "",
        "english_scripture": "",
        "url": "https://www.ilovejinshasan.org/source/food-science",
        "short_url": "www.ilovejinshasan.org/source/food-science",
        "dir_name": "Source for Food Science",
        "file_prefix": "qr-food-science"
    }
]

BRAND_RED = (174, 43, 43)  # #ae2b2b
BRAND_GOLD = (212, 160, 23)
DARK_TEXT = (25, 25, 25)

LOGO_PATH = "c:/Users/Asus/Desktop/ILJ/frontend/public/logo jpg.jpg.jpeg"

def create_circular_logo(logo_img, size):
    """Resizes and embeds logo in a circular badge with border."""
    logo_resized = logo_img.resize((size, size), Image.Resampling.LANCZOS).convert("RGBA")
    badge_size = int(size * 1.15)
    badge = Image.new("RGBA", (badge_size, badge_size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(badge)
    draw.ellipse([0, 0, badge_size, badge_size], fill=(255, 255, 255, 255), outline=BRAND_RED, width=5)
    mask = Image.new("L", (size, size), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.ellipse([0, 0, size, size], fill=255)
    offset = (badge_size - size) // 2
    badge.paste(logo_resized, (offset, offset), mask=mask)
    return badge

def generate_square_qr(url, logo_img, output_size=1200):
    qr = qrcode.QRCode(version=None, error_correction=qrcode.constants.ERROR_CORRECT_H, box_size=24, border=3)
    qr.add_data(url)
    qr.make(fit=True)
    qr_img = qr.make_image(fill_color="#ae2b2b", back_color="white").convert("RGBA")
    qr_img = qr_img.resize((output_size, output_size), Image.Resampling.LANCZOS)
    logo_size = int(output_size * 0.22)
    badge = create_circular_logo(logo_img, logo_size)
    pos = ((output_size - badge.width) // 2, (output_size - badge.height) // 2)
    qr_img.paste(badge, pos, mask=badge)
    return qr_img

def generate_exhibition_card(item, qr_img):
    card_w, card_h = 1200, 1680
    card = Image.new("RGBA", (card_w, card_h), (255, 255, 255, 255))
    draw = ImageDraw.Draw(card)
    # Fonts (Windows paths)
    font_hin_title = ImageFont.truetype(r"C:/Windows/Fonts/Nirmala.ttc", 44)
    font_eng_title = ImageFont.truetype(r"C:/Windows/Fonts/georgiab.ttf", 52)
    font_scripture = ImageFont.truetype(r"C:/Windows/Fonts/georgiab.ttf", 34)
    font_badge = ImageFont.truetype(r"C:/Windows/Fonts/arialbd.ttf", 22)
    font_desc = ImageFont.truetype(r"C:/Windows/Fonts/arial.ttf", 26)
    font_url = ImageFont.truetype(r"C:/Windows/Fonts/arialbd.ttf", 28)
    font_sub = ImageFont.truetype(r"C:/Windows/Fonts/arial.ttf", 22)
    # Decorative borders
    draw.rounded_rectangle([25, 25, card_w - 25, card_h - 25], radius=32, outline=BRAND_RED, width=6)
    draw.rounded_rectangle([38, 38, card_w - 38, card_h - 38], radius=24, outline=(235, 215, 215), width=2)
    # Top tag
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
    # Scripture reference box
    box_y = 235
    box_h = 160
    draw.rounded_rectangle([80, box_y, card_w - 80, box_y + box_h], radius=20, fill=(255, 249, 245), outline=(240, 215, 205), width=2)
    hin_text = item["hindi_scripture"]
    bbox = draw.textbbox((0, 0), hin_text, font=font_hin_title)
    draw.text(((card_w - (bbox[2] - bbox[0])) // 2, box_y + 22), hin_text, font=font_hin_title, fill=BRAND_RED)
    eng_text = item["english_scripture"]
    bbox = draw.textbbox((0, 0), eng_text, font=font_scripture)
    draw.text(((card_w - (bbox[2] - bbox[0])) // 2, box_y + 92), eng_text, font=font_scripture, fill=(70, 70, 70))
    # Center QR code
    qr_card_size = 820
    qr_resized = qr_img.resize((qr_card_size, qr_card_size), Image.Resampling.LANCZOS)
    qr_x = (card_w - qr_card_size) // 2
    qr_y = 440
    draw.rounded_rectangle([qr_x - 20, qr_y - 20, qr_x + qr_card_size + 20, qr_y + qr_card_size + 20], radius=24, fill=(255, 255, 255), outline=(230, 230, 230), width=2)
    card.paste(qr_resized, (qr_x, qr_y), mask=qr_resized)
    # Instruction
    inst_text = "Scan QR with smartphone camera to view original Agam verses & commentary"
    bbox = draw.textbbox((0, 0), inst_text, font=font_desc)
    draw.text(((card_w - (bbox[2] - bbox[0])) // 2, 1340), inst_text, font=font_desc, fill=(100, 100, 100))
    # Direct link pill
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
    os.makedirs("10qr", exist_ok=True)
    print("=" * 60)
    print("GENERATING 5 NEW QR CODES WITH LOGO INTO 10qr")
    print("=" * 60)
    for item in ITEMS:
        print(f"\nProcessing: {item['title']}...\nURL: {item['url']}\n")
        qr_square = generate_square_qr(item["url"], logo_img, output_size=1200)
        public_sq_path = f"public/qr/{item['file_prefix']}.png"
        dir_sq_path = f"10qr/{item['dir_name']}/{item['file_prefix']}.png"
        os.makedirs(os.path.dirname(dir_sq_path), exist_ok=True)
        qr_square.save(public_sq_path, "PNG")
        qr_square.save(dir_sq_path, "PNG")
        val, _, _ = detector.detectAndDecode(cv2.imread(public_sq_path))
        print(f"  [OK] Square QR generated: {public_sq_path} (Verified: {val == item['url']})")
        card = generate_exhibition_card(item, qr_square)
        public_card_path = f"public/qr/card-{item['id']}.png"
        dir_card_path = f"10qr/{item['dir_name']}/card-{item['id']}.png"
        os.makedirs(os.path.dirname(dir_card_path), exist_ok=True)
        card.save(public_card_path, "PNG")
        card.save(dir_card_path, "PNG")
        val_card, _, _ = detector.detectAndDecode(cv2.imread(public_card_path))
        print(f"  [OK] Exhibition Card generated: {public_card_path} (Verified: {val_card == item['url']})")
    print("\n" + "=" * 60)
    print("ALL 5 NEW QR CODES & DISPLAY CARDS SUCCESSFULLY GENERATED & VERIFIED!")
    print("=" * 60)

if __name__ == "__main__":
    main()
