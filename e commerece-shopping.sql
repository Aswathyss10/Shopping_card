CREATE TABLE customer(customer_id INT PRIMARY KEY,customer_name	VARCHAR(50),gender VARCHAR(50),age INT,zip_code INT,city VARCHAR(150),state VARCHAR(200),country VARCHAR(200)
);
COPY customer FROM 'C:\Users\Aswat\Downloads\shopping\customers.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE orders(order_id INT PRIMARY KEY,customer_id INT ,payment NUMERIC(10,2),order_date date,	delivery_date date ,FOREIGN KEY (customer_id)REFERENCES customer(customer_id)
);
COPY orders FROM 'C:\Users\Aswat\Downloads\shopping\orders.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE product(product_ID INT PRIMARY KEY,product_type VARCHAR(20),product_name VARCHAR(50),size CHAR(10),colour VARCHAR(20),price NUMERIC(10,2),quantity INT
);

COPY product FROM 'C:\Users\Aswat\Downloads\shopping\products.csv' DELIMITER ','CSV HEADER;

CREATE TABLE sales(sales_id	INT PRIMARY KEY,order_id INT,product_id INT,price_per_unit NUMERIC(10,2),quantity INT,total_price NUMERIC(10,2)
);

COPY sales FROM 'C:\Users\Aswat\Downloads\shopping\sales.csv' DELIMITER ','CSV HEADER;


--Top-5-selling products

SELECT product,SUM(quantity) FROM  "public"."product" GROUP BY product ORDER BY SUM(quantity) DESC LIMIT 5;


--Highest Revenue-Generating Products

SELECT p.product_id,p.product_name,SUM(s.total_price) AS top FROM "public"."product" AS P JOIN "public"."sales" AS s ON p.product_id=s.product_id GROUP BY p.product_id,p.product_name ORDER BY top  DESC LIMIT 5;

--Products with Lowest Revenue

SELECT p.product_id,p.product_name,SUM(s.total_price) AS low FROM "public"."product" AS P JOIN "public"."sales" AS s ON p.product_id=s.product_id GROUP BY p.product_id,p.product_name ORDER BY low ASC LIMIT 5;


 --Average Price per Product Type
 
 SELECT product_type,avg(price) FROM "public"."product" GROUP BY product_type;
 
 --Inventory vs. Sales
SELECT  p.product_name, p.quantity AS in_stock, COALESCE(SUM(s.quantity), 0) AS sold
FROM product p LEFT JOIN sales s ON p.product_id = s.product_id GROUP BY p.product_name, p.quantity ORDER BY sold DESC;

--Most Popular Product Type
 SELECT product_type,sum(s.quantity) AS popular FROM "public"."product" JOIN sales AS s USING(product_id)GROUP BY product_type ORDER BY popular DESC ;
 

-- Monthly sales trend (total revenue)
SELECT TO_CHAR(o.order_date, 'YYYY-MM') AS MONTH,SUM(s.total_price) AS total_revenue FROM sales s JOIN orders o ON s.order_id = o.order_id
GROUP BY TO_CHAR(o.order_date, 'YYYY-MM') ORDER BY MONTH;

-- View for City-Wise Sales Performance (Total Revenue)
CREATE VIEW city_sales_performance AS
SELECT 
  c.city, 
  SUM(s.total_price) AS total_revenue
FROM sales s
JOIN orders o ON s.order_id = o.order_id
JOIN customer c ON o.customer_id = c.customer_id
GROUP BY c.city;

SELECT * FROM city_sales_performance;

