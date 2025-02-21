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

echo -e "• Uploading files from $FOLDER_NAME"
gh release upload "$FOLDER_NAME" "$FOLDER_NAME"/*

echo -e "• Moving $FOLDER_NAME path to the parent directory"
mv "$FOLDER_NAME" ../

echo -e "• Done"
