"""Generate a 1024x1024 app icon for the 478 Breathing app."""

from PIL import Image, ImageDraw, ImageFont, ImageFilter
import math

SIZE = 1024
CENTER = SIZE // 2

img = Image.new("RGB", (SIZE, SIZE), (15, 15, 40))
draw = ImageDraw.Draw(img)

# --- Radial gradient background (dark center fading to slightly lighter edges) ---
for y in range(SIZE):
    for x in range(SIZE):
        dist = math.sqrt((x - CENTER) ** 2 + (y - CENTER) ** 2)
        norm = min(dist / (SIZE * 0.7), 1.0)
        r = int(15 + norm * 10)
        g = int(15 + norm * 5)
        b = int(40 + norm * 20)
        img.putpixel((x, y), (r, g, b))

# --- Helper: draw a soft glowing ring ---
def draw_glow_ring(image, cx, cy, radius, color, width=3, blur=15, opacity=0.4):
    """Draw a ring with glow effect by compositing a blurred ring layer."""
    layer = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    ld = ImageDraw.Draw(layer)
    ld.ellipse(
        [cx - radius, cy - radius, cx + radius, cy + radius],
        outline=(*color, int(255 * opacity)),
        width=width,
    )
    blurred = layer.filter(ImageFilter.GaussianBlur(blur))
    # Also draw a sharper version on top
    ld2 = ImageDraw.Draw(blurred)
    ld2.ellipse(
        [cx - radius, cy - radius, cx + radius, cy + radius],
        outline=(*color, int(255 * opacity * 0.7)),
        width=max(1, width // 2),
    )
    image.paste(Image.alpha_composite(Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0)), blurred), (0, 0), blurred)
    return image

# Convert to RGBA for compositing
img = img.convert("RGBA")

# --- Concentric outer rings (subtle) ---
ring_colors_and_params = [
    (380, (80, 60, 180), 2, 20, 0.25),   # outermost - indigo
    (340, (60, 80, 200), 2, 18, 0.28),   # indigo-blue
    (300, (50, 140, 200), 2, 15, 0.3),   # blue-cyan
]

for radius, color, width, blur, opacity in ring_colors_and_params:
    draw_glow_ring(img, CENTER, CENTER, radius, color, width, blur, opacity)

# --- Main breathing circle with strong cyan glow ---
main_radius = 240

# Multiple glow layers for the main circle (outer to inner, increasing intensity)
glow_layers = [
    (main_radius + 40, (0, 200, 220), 4, 40, 0.15),
    (main_radius + 20, (0, 210, 230), 3, 30, 0.2),
    (main_radius + 5,  (0, 220, 240), 3, 20, 0.3),
    (main_radius,      (0, 230, 250), 4, 12, 0.5),
]

for radius, color, width, blur, opacity in glow_layers:
    draw_glow_ring(img, CENTER, CENTER, radius, color, width, blur, opacity)

# Filled circle with very subtle gradient fill
circle_layer = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
cd = ImageDraw.Draw(circle_layer)
# Subtle filled circle
cd.ellipse(
    [CENTER - main_radius, CENTER - main_radius, CENTER + main_radius, CENTER + main_radius],
    fill=(0, 180, 200, 25),
)
img = Image.alpha_composite(img, circle_layer)

# Crisp circle outline
outline_layer = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
od = ImageDraw.Draw(outline_layer)
od.ellipse(
    [CENTER - main_radius, CENTER - main_radius, CENTER + main_radius, CENTER + main_radius],
    outline=(0, 220, 240, 180),
    width=3,
)
img = Image.alpha_composite(img, outline_layer)

# --- Text "4-7-8" ---
text_layer = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
td = ImageDraw.Draw(text_layer)

# Try to use a nice font, fall back to default
text = "4-7-8"
font_size = 100
try:
    font = ImageFont.truetype("/System/Library/Fonts/HelveticaNeue.ttc", font_size)
except (OSError, IOError):
    try:
        font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", font_size)
    except (OSError, IOError):
        font = ImageFont.load_default()

bbox = td.textbbox((0, 0), text, font=font)
tw = bbox[2] - bbox[0]
th = bbox[3] - bbox[1]
tx = CENTER - tw // 2
ty = CENTER - th // 2 - bbox[1]  # adjust for top bearing

# Subtle glow behind text
glow_text = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
gtd = ImageDraw.Draw(glow_text)
gtd.text((tx, ty), text, font=font, fill=(0, 200, 220, 80))
glow_text = glow_text.filter(ImageFilter.GaussianBlur(10))
img = Image.alpha_composite(img, glow_text)

# Main text
td.text((tx, ty), text, font=font, fill=(230, 245, 255, 210))
img = Image.alpha_composite(img, text_layer)

# --- Save ---
output_path = "/Users/himadri/github/apps/478breathing/Breathing478/Assets.xcassets/AppIcon.appiconset/AppIcon.png"
img = img.convert("RGB")
img.save(output_path, "PNG")
print(f"Icon saved to {output_path}")
print(f"Size: {img.size}")
