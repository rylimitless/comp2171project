-- name: GetProduct :one
SELECT * FROM Products limit 1;

-- name: GetProducts :many
SELECT * FROM Products LIMIT ?,?;

-- name: FilterProductsByCategory :many
SELECT * FROM Products 
WHERE category_id = ?
LIMIT ?,?;

-- name: GetCategories :many
SELECT * FROM Category;

-- name: SearchProducts :many
SELECT * FROM Products
WHERE MATCH(description) AGAINST ("?")