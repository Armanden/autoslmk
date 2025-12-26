#!/bin/bash

# Generate HTML from Go program
if go run main.go | tee output.html; then
    echo "HTML generated successfully."
else
    echo "Failed to generate HTML."
    exit 1
fi

# Translate HTML
if go run translate.go output.html; then
    echo "Translation successful."
else
    echo "Translation failed."
    exit 1
fi

# Clean up HTML
sed -i 's/<title>/=/g' output.html
sed -i 's/<h1>/== /g' output.html
sed -i 's/<\/h1>//g' output.html
sed -i 's/<h2>/=== /g' output.html
sed -i 's/<\/h2>//g' output.html
sed -i 's/<h3>/==== /g' output.html
sed -i 's/<\/h3>//g' output.html
sed -i 's/<p>/\n/g' output.html
sed -i 's/<\/p>/\n/g' output.html
sed -i 's/<strong>/**/g' output.html
sed -i 's/<\/strong>/**/g' output.html
sed -i 's/<em>/_/g' output.html
sed -i 's/<\/em>/_/g' output.html
sed -i 's/<img//g' output.html
sed -i 's/<a href="\(.*\)">/\[\1]/g' output.html
sed -i 's/<\/a>/\[\]/g' output.html
sed -i 's/<[^>]*>//g' output.html
sed -i 's/#//g' output.html
sed -i 's/_//g' output.html
sed -i 's/<.//g' output.html

# Create Typst file with header
touch output.typ
{
echo '#import "@preview/diatypst:0.8.0": *
#show: slides.with(
  title: "Diatypst",
  subtitle: "easy slides in typst",
  date: "'$(date +%d.%m.%Y)'",
  authors: ("Author Name"),
  ratio: 16/9,
  layout: "medium",
  title-color: blue.darken(60%),
  toc: true,
)'
} >> output.typ

# Append cleaned HTML to Typst file
cat output.html >> output.typ

sed -i '1s/./#&/' output.html
sed -i '2s/./#&/' output.html
# Compile to PDF
if typst compile output.typ output.pdf; then
    echo "Compiled to PDF successfully."
else
    echo "Compilation failed."
    exit 1
fi
