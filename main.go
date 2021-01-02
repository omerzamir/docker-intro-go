package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello User, you've requested: '%s'\n", r.URL.Path)
	})

	http.ListenAndServe(":4444", nil)
}
