package main

import (
	"encoding/json"
	"net/http"
	"os"
	"path/filepath"

	"backend/database"
	"context"
	"database/sql"
	"strconv"

	_ "github.com/go-sql-driver/mysql"
)

type ResProduct struct {
	ID          int32
	Name        string
	Description string
	Price       string
	CategoryID  int32
	ImageUrl    string
}

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

			val := ResProduct{
				ID:          prod.ID,
				Name:        prod.Name,
				Description: prod.Description.String,
				Price:       prod.Price,
				CategoryID:  prod.CategoryID.Int32,
				ImageUrl:    prod.ImageUrl.String,
			}

			w.Header().Set("content-type", "application/json")
			encoder := json.NewEncoder(w)
			encoder.Encode(val)

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

	http.HandleFunc("/products", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "GET" {

			var s []database.Product
			var err error
			var category sql.NullInt32
			var categoryErr error

			offset, offsetErr := strconv.Atoi(r.URL.Query().Get("offset"))
			limit, limitErr := strconv.Atoi(r.URL.Query().Get("limit"))
			categoryFromQuery, categoryErr := strconv.Atoi(r.URL.Query().Get("category"))
			search := r.URL.Query().Get("query")

			if offsetErr != nil {
				offset = 0
			}

			if limitErr != nil {
				limit = 10
			}

			if categoryErr == nil {
				category = sql.NullInt32{
					Int32: int32(categoryFromQuery),
					Valid: true,
				}

				s, err = queries.FilterProductsByCategory(ctx, database.FilterProductsByCategoryParams{
					CategoryID: category,
					Offset:     int32(offset),
					Limit:      int32(limit),
				})

			} else {

				if search == "" {

				}
				s, err = queries.GetProducts(ctx, database.GetProductsParams{
					Offset: int32(offset),
					Limit:  int32(limit),
				})
			}

			if err != nil {
				http.Error(w, "Oops Something Went Wrong", http.StatusInternalServerError)
				return
			}

			w.Header().Add("content-type", "application/json")
			encoder := json.NewEncoder(w)

			type Response struct {
				Amount   int
				Products []ResProduct
			}

			var Products []ResProduct

			Products = make([]ResProduct, 0)

			for _, product := range s {

				prod := ResProduct{
					ID:          product.ID,
					Name:        product.Name,
					Description: product.Description.String,
					Price:       product.Price,
					CategoryID:  product.CategoryID.Int32,
					ImageUrl:    product.ImageUrl.String,
				}

				Products = append(Products, prod)
			}

			res := Response{
				Amount:   len(Products),
				Products: Products,
			}
			encoder.Encode(res)
		} else {
			http.Error(w, "Method Not Allowed", http.StatusMethodNotAllowed)
		}
	})

	http.HandleFunc("/categories", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "GET" {
			type Response struct {
				TotalCategories int
				Category        []database.Category
			}

			category, err := queries.GetCategories(ctx)
			if err == nil {
				w.Header().Add("content-type", "application/json")
				encoder := json.NewEncoder(w)
				encoder.Encode(Response{
					TotalCategories: len(category),
					Category:        category,
				})
			} else {
				http.Error(w, "Internal Status Error", http.StatusInternalServerError)
				return
			}

		} else {
			http.Error(w, "Method Not Allowed", http.StatusMethodNotAllowed)
		}
	})

	http.ListenAndServe(":9000", nil)
}
