#!/bin/bash

if [ -z "$1" ]; then
    echo -e "• Error: Please provide the folder name"
    exit 1
fi

FOLDER_NAME=$1

if [ ! -d "$FOLDER_NAME" ]; then
    echo -e "• Error: Folder $FOLDER_NAME does not exist"
    exit 1
fi

echo -e "• Creating release: $FOLDER_NAME"
gh release create "$FOLDER_NAME" --title "$FOLDER_NAME" --notes "$FOLDER_NAME"

echo -e "• Renaming files with spaces, hyphens, and underscores"

for file in "$FOLDER_NAME"/*; do
    if [[ -f "$file" ]]; then
        new_name=$(echo "$file" | sed -E 's/[ _-]+/./g')

        if [ "$file" != "$new_name" ]; then
            mv "$file" "$new_name"
            echo -e "• Renamed: $file -> $new_name"
        fi
    fi
done

echo -e "• Uploading files"

for file in "$FOLDER_NAME"/*; do
    if [[ -f "$file" ]]; then
        full_path=$(realpath "$file")
        echo -e "• Uploading: $full_path"
        gh release upload "$FOLDER_NAME" "$full_path"
    fi
done

echo -e "• Moving $FOLDER_NAME path to the parent directory"
mv "$FOLDER_NAME" ../

echo -e "• Done"
