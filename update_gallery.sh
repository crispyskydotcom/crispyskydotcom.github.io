#!/bin/bash

# Set the paths
ARCHIVE_PATH="/home/ShellLM/Projects/websites/crispyskydotcom.github.io/gallery/archive/g01"
HTML_FILE="/home/ShellLM/Projects/websites/crispyskydotcom.github.io/gallery/gallery01/index.html"

# Create a temporary file
TEMP_FILE=$(mktemp)

# Copy the content before the images section
sed -n '1,/images:/p' "$HTML_FILE" > "$TEMP_FILE"

# Add the updated images section
echo "images:" >> "$TEMP_FILE"

# Loop through all jpg and JPG files in the archive folder
for img in "$ARCHIVE_PATH"/*.jpg "$ARCHIVE_PATH"/*.JPG; do
    if [ -f "$img" ]; then
        filename=$(basename "$img")
        echo " - image_path: /gallery/archive/g01/$filename" >> "$TEMP_FILE"
        echo "" >> "$TEMP_FILE"
        
        # Check if the image already has a copyright in the original file
        if grep -q "$filename" "$HTML_FILE" && grep -q "copyright: © thomas hughes" "$HTML_FILE"; then
            echo "   copyright: © thomas hughes" >> "$TEMP_FILE"
        else
            echo "   copyright: © thomas hughes" >> "$TEMP_FILE"
        fi
    fi
done

# Add the content after the images section
sed -n '/---/,$p' "$HTML_FILE" | tail -n +2 >> "$TEMP_FILE"

# Replace the original file with the updated content
mv "$TEMP_FILE" "$HTML_FILE"

echo "Gallery updated successfully!"
