// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: query.sql

package database

import (
	"context"
	"database/sql"
)

const filterProductsByCategory = `-- name: FilterProductsByCategory :many
SELECT id, name, description, price, category_id, image_url FROM Products 
WHERE category_id = ?
LIMIT ?,?
`

type FilterProductsByCategoryParams struct {
	CategoryID sql.NullInt32
	Offset     int32
	Limit      int32
}

func (q *Queries) FilterProductsByCategory(ctx context.Context, arg FilterProductsByCategoryParams) ([]Product, error) {
	rows, err := q.db.QueryContext(ctx, filterProductsByCategory, arg.CategoryID, arg.Offset, arg.Limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []Product
	for rows.Next() {
		var i Product
		if err := rows.Scan(
			&i.ID,
			&i.Name,
			&i.Description,
			&i.Price,
			&i.CategoryID,
			&i.ImageUrl,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const getCategories = `-- name: GetCategories :many
SELECT category_id, name FROM Category
`

func (q *Queries) GetCategories(ctx context.Context) ([]Category, error) {
	rows, err := q.db.QueryContext(ctx, getCategories)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []Category
	for rows.Next() {
		var i Category
		if err := rows.Scan(&i.CategoryID, &i.Name); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const getProduct = `-- name: GetProduct :one
SELECT id, name, description, price, category_id, image_url FROM Products limit 1
`

func (q *Queries) GetProduct(ctx context.Context) (Product, error) {
	row := q.db.QueryRowContext(ctx, getProduct)
	var i Product
	err := row.Scan(
		&i.ID,
		&i.Name,
		&i.Description,
		&i.Price,
		&i.CategoryID,
		&i.ImageUrl,
	)
	return i, err
}

const getProducts = `-- name: GetProducts :many
SELECT id, name, description, price, category_id, image_url FROM Products LIMIT ?,?
`

type GetProductsParams struct {
	Offset int32
	Limit  int32
}

func (q *Queries) GetProducts(ctx context.Context, arg GetProductsParams) ([]Product, error) {
	rows, err := q.db.QueryContext(ctx, getProducts, arg.Offset, arg.Limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []Product
	for rows.Next() {
		var i Product
		if err := rows.Scan(
			&i.ID,
			&i.Name,
			&i.Description,
			&i.Price,
			&i.CategoryID,
			&i.ImageUrl,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const searchProducts = `-- name: SearchProducts :many
SELECT id, name, description, price, category_id, image_url FROM Products
WHERE MATCH(description) AGAINST ("?")
`

func (q *Queries) SearchProducts(ctx context.Context) ([]Product, error) {
	rows, err := q.db.QueryContext(ctx, searchProducts)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []Product
	for rows.Next() {
		var i Product
		if err := rows.Scan(
			&i.ID,
			&i.Name,
			&i.Description,
			&i.Price,
			&i.CategoryID,
			&i.ImageUrl,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}
