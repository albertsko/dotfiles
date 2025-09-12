#!/bin/bash

set -e

INPUT_DIR="$HOME/Desktop/SFMonoUnpatched"
OUTPUT_DIR="$HOME/Library/Fonts"
FONT_PATH="/Library/Fonts/SF-Mono*.otf"

mkdir -p "$INPUT_DIR"

for file in $FONT_PATH; do
    echo "Copying $file..."
    cp "$file" "$INPUT_DIR/"
done

docker run --rm \
    --user "$(id -u):$(id -g)" \
    -v "$INPUT_DIR":/in \
    -v "$OUTPUT_DIR":/out \
    nerdfonts/patcher \
    --removeligs \
    --complete

rm -rf "$INPUT_DIR"
