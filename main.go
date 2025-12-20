package main
import ( 
	"fmt"
	"io/ioutil"
	"net/http"
)
func main() {
	var input string
	fmt.Print("This is autoslmk\n" )
	fmt.Print("Enter Link to be scanned:")
	fmt.Scanf("%s", &input)

	response, err := http.Get(input)
    if err != nil {
        fmt.Println("Error fetching the URL:", err)
        return
    }
    defer response.Body.Close()

    body, err := ioutil.ReadAll(response.Body)
    if err != nil {
        fmt.Println("Error reading the response body:", err)
        return
    }

    fmt.Println(string(body))
}

