CREATE TABLE sales_orders (
    id SERIAL PRIMARY KEY,
    order_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(10),
    region VARCHAR(50),
    product_id VARCHAR(20),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales NUMERIC(10,2),
    quantity INTEGER,
    discount NUMERIC(4,2),
    profit NUMERIC(10,4)
);

SELECT *
FROM sales_orders;

--Total Sales:
SELECT SUM(sales) AS total_sales FROM sales_orders;

--No. of Orders:
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM sales_orders;

--No. of Customers:
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM sales_orders;

--Sales by Category:
SELECT category, SUM(sales) AS sales
FROM sales_orders
GROUP BY category
ORDER BY sales DESC;

--Sales by Category and Region:
SELECT region, category, SUM(sales) AS total_sales
FROM sales_orders
GROUP BY region, category
ORDER BY region, category;

--Average Profit per order:
SELECT AVG(profit) AS avg_profit
FROM (
  SELECT order_id, SUM(profit) AS profit
  FROM sales_orders
  GROUP BY order_id
) AS order_profits;

--Customer Segmentation Distribution:
SELECT segment, COUNT(DISTINCT customer_id) AS customers
FROM sales_orders
GROUP BY segment;

--Monthly Sales Trend:
SELECT DATE_TRUNC('month', order_date) AS month, SUM(sales) AS total_sales
FROM sales_orders
GROUP BY month
ORDER BY month;

--Top 10 customers by Revenue:
SELECT customer_id, customer_name, SUM(sales) AS total_revenue
FROM sales_orders
GROUP BY customer_id, customer_name
ORDER BY total_revenue DESC
LIMIT 10;

--Customer Retention Rate:
WITH customer_orders AS (
  SELECT customer_id, COUNT(DISTINCT order_id) AS orders_count
  FROM sales_orders
  GROUP BY customer_id
)
SELECT 
  (SUM(CASE WHEN orders_count > 1 THEN 1 ELSE 0 END)::float / COUNT(*)) AS retention_rate
FROM customer_orders;

--Profit Margin by Category and Region:
SELECT category, region,
       SUM(profit) * 100.0 / NULLIF(SUM(sales), 0) AS profit_margin
FROM sales_orders
GROUP BY category, region
ORDER BY profit_margin DESC;

--Shipping Performance by Mode:
SELECT ship_mode,
       AVG(ship_date - order_date) AS avg_shipping_time
FROM sales_orders
GROUP BY ship_mode
ORDER BY avg_shipping_time;





