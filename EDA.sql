-- EDA.sql: Exploratory Data Analysis on the Transactional Data

-- 1. Total number of orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- 2. Total revenue generated from orders
SELECT SUM(OrderAmount) AS total_revenue
FROM orders;

-- 3. Total number of customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- 4. Distribution of orders by country (joining customers and locations)
SELECT l.Country, COUNT(*) AS order_count
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
JOIN locations l ON c.LocationID = l.LocationID
GROUP BY l.Country
ORDER BY order_count DESC;

-- 5. Distribution of orders by product category
SELECT p.Category, COUNT(*) AS order_count
FROM orders o
JOIN products p ON o.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY order_count DESC;

-- 6. Average order value
SELECT AVG(OrderAmount) AS avg_order_value
FROM orders;

-- 7. Top 5 customers by total revenue
SELECT c.CustomerName, SUM(o.OrderAmount) AS total_revenue
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerName
ORDER BY total_revenue DESC
LIMIT 5;

-- 8. Top 5 products by revenue
SELECT p.ProductName, SUM(o.OrderAmount) AS product_revenue
FROM orders o
JOIN products p ON o.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY product_revenue DESC
LIMIT 5;

-- 9. Monthly orders trend
SELECT DATE_TRUNC('month', OrderDate) AS order_month, COUNT(*) AS orders_count
FROM orders
GROUP BY order_month
ORDER BY order_month;

-- 10. Customer segmentation by age group
SELECT 
  CASE 
    WHEN Age < 25 THEN 'Under 25'
    WHEN Age BETWEEN 25 AND 40 THEN '25-40'
    WHEN Age BETWEEN 41 AND 60 THEN '41-60'
    ELSE '60+'
  END AS age_group,
  COUNT(*) AS customer_count
FROM customers
GROUP BY age_group
ORDER BY customer_count DESC;

-- 11. Orders count by customer gender
SELECT c.Gender, COUNT(*) AS orders_count
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY c.Gender;

-- 12. Average order value per country
SELECT l.Country, AVG(o.OrderAmount) AS avg_order_value
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
JOIN locations l ON c.LocationID = l.LocationID
GROUP BY l.Country;

-- 13. Revenue by product category
SELECT p.Category, SUM(o.OrderAmount) AS total_revenue
FROM orders o
JOIN products p ON o.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY total_revenue DESC;

-- 14. Daily orders count
SELECT CAST(OrderDate AS DATE) AS order_day, COUNT(*) AS orders_count
FROM orders
GROUP BY order_day
ORDER BY order_day;

-- 15. Distribution of order quantities
SELECT Quantity, COUNT(*) AS frequency
FROM orders
GROUP BY Quantity
ORDER BY frequency DESC;
