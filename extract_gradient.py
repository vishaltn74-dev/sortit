import sys
try:
    from PIL import Image, ImageFilter
except ImportError:
    import os
    os.system('pip install Pillow')
    from PIL import Image, ImageFilter

image_path = r"C:\Users\Vishal T N\.gemini\antigravity-ide\brain\3f54b8a7-d347-404e-a80d-de94be436e6b\.user_uploaded\media_1790703093918.png"
output_path = r"assets\images\bg_gradient.jpg"

try:
    img = Image.open(image_path)
    # The image is a mockup with multiple phones. The top left phone has a big gradient.
    # Let's crop a section of that gradient.
    width, height = img.size
    
    # Crop top-left region (assuming the leftmost phone is there)
    crop_box = (int(width * 0.05), int(height * 0.05), int(width * 0.35), int(height * 0.4))
    cropped = img.crop(crop_box)
    
    # Apply a heavy Gaussian blur to remove any UI text/elements and create a smooth mesh
    blurred = cropped.filter(ImageFilter.GaussianBlur(radius=50))
    
    # Save it
    blurred.convert('RGB').save(output_path, quality=90)
    print(f"Gradient extracted and saved to {output_path}")
except Exception as e:
    print(f"Error: {e}")
