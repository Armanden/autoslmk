package main

import (
	"fmt"
	"golang.org/x/net/html"
	"os"
	"strings"
)

// ConvertHTMLToTypst converts HTML to Typst format
func ConvertHTMLToTypst(n *html.Node) string {
	switch n.Type {
	case html.ElementNode:
		switch n.Data {
		case "h1":
			return fmt.Sprintf("# %s\n", getInnerText(n))
		case "h2":
			return fmt.Sprintf("## %s\n", getInnerText(n))
		case "p":
			return fmt.Sprintf("%s\n", getInnerText(n))
		case "strong":
			return fmt.Sprintf("**%s**", getInnerText(n))
		// Add more cases for lists, links, etc.
		}
	case html.TextNode:
		return n.Data
	}
	return ""
}

// getInnerText retrieves inner text from HTML node
func getInnerText(n *html.Node) string {
	var sb strings.Builder
	for c := n.FirstChild; c != nil; c = c.NextSibling {
		sb.WriteString(ConvertHTMLToTypst(c))
	}
	return sb.String()
}

// convert reads HTML from a file and converts it to Typst
func convert(filePath string) {
	f, err := os.Open(filePath)
	if err != nil {
		fmt.Println("Error reading file:", err)
		return
	}
	defer f.Close()

	doc, err := html.Parse(f)
	if err != nil {
		fmt.Println("Error parsing HTML:", err)
		return
	}

	typstContent := ConvertHTMLToTypst(doc)
	fmt.Println(typstContent)
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: go run main.go <html_file>")
		return
	}

	convert(os.Args[1])
}
