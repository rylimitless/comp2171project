-- Active: 1739830206872@@127.0.0.1@3306@COMP2171
USE COMP2171;

CREATE TABLE IF NOT EXISTS Products(
    id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(8,2) NOT NULL,
    category_id int,
    image_URL VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Category(
    category_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

ALTER TABLE Products
ADD CONSTRAINT fk_category_product 
FOREIGN KEY (category_id) REFERENCES Category (category_id) 
ON UPDATE CASCADE;


INSERT INTO Category (name) VALUES("Appliances");


INSERT INTO `Products` (name ,price , image_URL , description , category_id)
VALUES ("Mini Fridge" , 120.92, "http//localhost:9000/mini_fridge.webp","This a black mini fridge",1);