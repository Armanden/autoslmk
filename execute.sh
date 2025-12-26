go run main.go | tee output.txt
go run translate.go output.txt

mv output.txt output.typ

typst compile output.typ output.pdf

