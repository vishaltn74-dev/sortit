import os
import re

directory = "lib"

replacements = {
    "AppTheme.royalBlue": "AppTheme.primaryRed",
    "AppTheme.accentYellow": "AppTheme.accentOrange",
    "AppTheme.lightBlueBg": "AppTheme.primaryRed",
    "AppTheme.lightGrey": "AppTheme.bgLightGrey",
    "Colors.black.withOpacity(0.05)": "Colors.black.withValues(alpha: 0.08)",
    "borderRadius: BorderRadius.circular(20)": "borderRadius: BorderRadius.circular(24)",
    "borderRadius: BorderRadius.circular(16)": "borderRadius: BorderRadius.circular(20)",
    "borderRadius: BorderRadius.circular(12)": "borderRadius: BorderRadius.circular(16)",
}

for root, dirs, files in os.walk(directory):
    for file in files:
        if file.endswith(".dart"):
            path = os.path.join(root, file)
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            modified = content
            for old, new in replacements.items():
                modified = modified.replace(old, new)
                
            if modified != content:
                with open(path, 'w', encoding='utf-8') as f:
                    f.write(modified)
                print(f"Updated {path}")
