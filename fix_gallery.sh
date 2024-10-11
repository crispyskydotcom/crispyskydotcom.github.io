#!/bin/bash

# Set the paths
ARCHIVE_PATH="/home/ShellLM/Projects/websites/crispyskydotcom.github.io/gallery/archive/g01"
HTML_FILE="/home/ShellLM/Projects/websites/crispyskydotcom.github.io/gallery/gallery01/index.html"

# Create a temporary file
TEMP_FILE=$(mktemp)

# Copy the YAML front matter before the images section
sed -n '1,/images:/p' "$HTML_FILE" | head -n -1 > "$TEMP_FILE"

# Add the updated images section
echo "images:" >> "$TEMP_FILE"

# Loop through all jpg and JPG files in the archive folder
for img in "$ARCHIVE_PATH"/*.jpg "$ARCHIVE_PATH"/*.JPG; do
    if [ -f "$img" ]; then
        filename=$(basename "$img")
        echo " - image_path: /gallery/archive/g01/$filename" >> "$TEMP_FILE"
        echo "   copyright: © thomas hughes" >> "$TEMP_FILE"
    fi
done

# Add the closing --- for YAML front matter
echo "---" >> "$TEMP_FILE"

# Add the HTML content after the YAML front matter
sed -n '/---/,$ p' "$HTML_FILE" | sed '1,/---/d' >> "$TEMP_FILE"

# Replace the original file with the updated content
mv "$TEMP_FILE" "$HTML_FILE"

echo "Gallery fixed successfully!"
