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

echo -e "• Renaming files with spaces and uploading"

for file in "$FOLDER_NAME"/*; do
    if [[ -f "$file" ]]; then
        new_name=$(echo "$file" | sed 's/ /./g')

        if [ "$file" != "$new_name" ]; then
            mv "$file" "$new_name"
            echo -e "• Renamed: $file -> $new_name"
        fi
    fi
done

for file in "$FOLDER_NAME"/*; do
    if [[ -f "$file" ]]; then
        echo -e "• Uploading: $file"
        gh release upload "$FOLDER_NAME" "$file"
    fi
done

echo -e "• Moving $FOLDER_NAME path to the parent directory"
mv "$FOLDER_NAME" ../

echo -e "• Done"
