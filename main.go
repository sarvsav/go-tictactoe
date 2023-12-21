/*
Copyright © 2022 sarvsav codingtherightway@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
package main

import (
	_ "embed"
	"fmt"
	"log"
	"net/http"
	"runtime"
	"strings"

	"github.com/sarvsav/go-tictactoe/cmd"
	"go.uber.org/automaxprocs/maxprocs"
)

//go:generate bash scripts/get_version.bash
//go:embed "version.txt"
var version string

func main() {

	// found the number of cpu at host level
	g := runtime.GOMAXPROCS(0)

	// updating based on available quota
	if _, err := maxprocs.Set(); err != nil {
		log.Printf("error")
	}
	c := runtime.GOMAXPROCS(0)

	// to print the build version of app
	log.Printf("CPU Host: [%d] and Container: [%d], build version: [%s]\n", g, c, strings.Trim(version, "\n"))

	// TODO: Add a cleanup function here
	defer log.Println("Program completed successfully and doing cleanup")

	cmd.Execute()
	handler := func(w http.ResponseWriter, r *http.Request) {
		_, err := fmt.Fprintf(w, "Hello, World!")
		if err != nil {
			log.Printf("Error writing response: %v", err)
		}
	}

	port := 8080

	// Register the handler function with the default ServeMux (multiplexer)
	http.HandleFunc("/", handler)

	// Start the server and listen on the specified port
	fmt.Printf("Server listening on port: %d...\n", port)
	err := http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
	if err != nil {
		log.Fatalf("Error starting the server: %v", err)
	}

	log.Println("Ending program")
}
