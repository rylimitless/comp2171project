package main

import (
	"encoding/json"
	"net/http"
	"os"
	"path/filepath"

	"backend/database"
	"context"
	"database/sql"

	_ "github.com/go-sql-driver/mysql"
)

func main() {

	ctx := context.Background()

	db, err := sql.Open("mysql", "root:my_secret_password@/COMP2171?parseTime=true")
	if err != nil {
		// return err
	}

	queries := database.New(db)

	fileServer := http.FileServer(http.Dir("./products"))

	http.Handle("/", fileServer)

	http.HandleFunc("/hello", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello World"))
	})

	http.HandleFunc("/product", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "GET" {
			prod, err := queries.GetProduct(ctx)

			if err != nil {
				http.Error(w, "Something went wrong", http.StatusInternalServerError)
				return
			}

			encoder := json.NewEncoder(w)
			encoder.Encode(prod)

		}
	})

	http.HandleFunc("/imgpath", func(w http.ResponseWriter, r *http.Request) {

		if r.Method == "GET" {

			file := r.URL.Query().Get("imageURL")

			if file == "" {
				w.WriteHeader(404)
				w.Write([]byte("No File Send"))
				return
			}

			imgPath := filepath.Clean(file)

			if _, err := os.Stat("./products/" + imgPath); os.IsNotExist(err) {
				http.Error(w, "File not found", http.StatusNotFound)
				return
			}

			// http.ServeFile(w, r, imgPath)
			w.Write([]byte("http://localhost:9000/" + imgPath))
		}

	})

	http.ListenAndServe(":9000", nil)
}
