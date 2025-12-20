go run main.go | tee output.txt
sh lib.sh 

mv output.txt output.typ

typst-compile output.typ output.pdf

