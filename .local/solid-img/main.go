package main

import (
	"flag"
	"image"
	"image/color"
	"image/png"
	"log"
	"os"
	"strconv"
	"strings"
)

func hexToRGBA(hex string) (color.RGBA, error) {
	hex = strings.TrimPrefix(hex, "#")
	if len(hex) != 6 {
		return color.RGBA{}, &strconv.NumError{Func: "hexToRGBA", Num: hex, Err: strconv.ErrSyntax}
	}
	r, _ := strconv.ParseUint(hex[0:2], 16, 8)
	g, _ := strconv.ParseUint(hex[2:4], 16, 8)
	b, _ := strconv.ParseUint(hex[4:6], 16, 8)

	return color.RGBA{uint8(r), uint8(g), uint8(b), 255}, nil
}

func main() {
	width := flag.Int("w", 3024, "img width (px)")
	height := flag.Int("h", 1964, "img height (px)")
	colorHex := flag.String("c", "#2a273f", "color (hex)")
	output := flag.String("o", "output.png", "output filename (png)")

	flag.Parse()

	rgbaColor, err := hexToRGBA(*colorHex)
	if err != nil {
		log.Fatalf("Invalid hex color: %v", err)
	}

	img := image.NewRGBA(image.Rect(0, 0, *width, *height))
	for x := 0; x < *width; x++ {
		for y := 0; y < *height; y++ {
			img.Set(x, y, rgbaColor)
		}
	}

	outFile, err := os.Create(*output)
	if err != nil {
		log.Fatalf("Failed to create file: %v", err)
	}
	defer outFile.Close()

	err = png.Encode(outFile, img)
	if err != nil {
		log.Fatalf("Failed to encode PNG: %v", err)
	}

	log.Printf("✅ Image generated: %s (%dx%d, color: %s)", *output, *width, *height, *colorHex)
}
