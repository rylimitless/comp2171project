package dbutils

import (
	"backend/database"
	"database/sql"
	"fmt"
	"strconv"

	_ "github.com/go-sql-driver/mysql"
)

type UtilProduct struct {
	ID          int32
	Name        string
	Description sql.NullString
	Price       float32
	CategoryID  sql.NullInt32
	ImageUrl    sql.NullString
}

func GetMatchProducts(db *sql.DB, query string) ([]database.Product, error) {
	rows, err := db.Query(`SELECT * FROM Products WHERE MATCH(description) AGAINST (? WITH QUERY EXPANSION) OR MATCH(name) AGAINST (+? IN BOOLEAN MODE)`, query, query)
	if err != nil {
		fmt.Println(err)
		return nil, err
	}

	var Products []database.Product
	Products = make([]database.Product, 0)
	for rows.Next() {

		prod := UtilProduct{}

		err := rows.Scan(&prod.ID, &prod.Name, &prod.Description, &prod.Price, &prod.CategoryID, &prod.ImageUrl)
		if err != nil {
			return nil, err
		}

		Products = append(Products, database.Product{
			ID:          prod.ID,
			Name:        prod.Name,
			Description: prod.Description,
			CategoryID:  prod.CategoryID,
			ImageUrl:    prod.ImageUrl,
			Price:       strconv.FormatFloat(float64(prod.Price), 'f', 2, 32),
		})
	}

	return Products, nil
}
