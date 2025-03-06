-- Summary_Stats.sql: Statistical Insights on Key Metrics

-- 1. Basic statistics for order amounts (min, max, average)
SELECT 
  MIN(OrderAmount) AS min_order_amount,
  MAX(OrderAmount) AS max_order_amount,
  AVG(OrderAmount) AS avg_order_amount
FROM orders;

-- 2. Standard deviation of order amounts
SELECT STDDEV(OrderAmount) AS stddev_order_amount
FROM orders;

-- 3. Median order amount using percentile_cont
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY OrderAmount) AS median_order_amount
FROM orders;

-- 4. Summary statistics for product prices
SELECT 
  MIN(Price) AS min_price,
  MAX(Price) AS max_price,
  AVG(Price) AS avg_price,
  STDDEV(Price) AS stddev_price
FROM products;

-- 5. Number of orders per customer (order frequency)
SELECT CustomerID, COUNT(*) AS orders_count
FROM orders
GROUP BY CustomerID
ORDER BY orders_count DESC;

-- 6. Average revenue per customer
SELECT c.CustomerID, c.CustomerName, AVG(o.OrderAmount) AS avg_revenue_per_order
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY avg_revenue_per_order DESC;

-- 7. Order amount statistics by product category
SELECT p.Category, 
       MIN(o.OrderAmount) AS min_order,
       MAX(o.OrderAmount) AS max_order,
       AVG(o.OrderAmount) AS avg_order,
       STDDEV(o.OrderAmount) AS stddev_order
FROM orders o
JOIN products p ON o.ProductID = p.ProductID
GROUP BY p.Category;

-- 8. Summary statistics for order quantities
SELECT 
  MIN(Quantity) AS min_quantity,
  MAX(Quantity) AS max_quantity,
  AVG(Quantity) AS avg_quantity,
  STDDEV(Quantity) AS stddev_quantity
FROM orders;

-- 9. Summary of customer ages
SELECT 
  MIN(Age) AS min_age,
  MAX(Age) AS max_age,
  AVG(Age) AS avg_age,
  STDDEV(Age) AS stddev_age
FROM customers;

-- 10. Revenue statistics by month
SELECT DATE_TRUNC('month', OrderDate) AS order_month,
       SUM(OrderAmount) AS total_revenue,
       AVG(OrderAmount) AS avg_order_amount
FROM orders
GROUP BY order_month
ORDER BY order_month;

-- 11. Average order frequency per customer (using subquery)
SELECT AVG(order_count) AS avg_orders_per_customer
FROM (
  SELECT CustomerID, COUNT(*) AS order_count
  FROM orders
  GROUP BY CustomerID
) AS customer_orders;

-- 12. Summary statistics for orders by region
SELECT l.Country,
       MIN(o.OrderAmount) AS min_order,
       MAX(o.OrderAmount) AS max_order,
       AVG(o.OrderAmount) AS avg_order,
       STDDEV(o.OrderAmount) AS stddev_order
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
JOIN locations l ON c.LocationID = l.LocationID
GROUP BY l.Country;

-- 13. Order amount summary by customer gender
SELECT c.Gender,
       MIN(o.OrderAmount) AS min_order,
       MAX(o.OrderAmount) AS max_order,
       AVG(o.OrderAmount) AS avg_order
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY c.Gender;

-- 14. Average order value per product
SELECT p.ProductID, p.ProductName, AVG(o.OrderAmount) AS avg_order_value
FROM orders o
JOIN products p ON o.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY avg_order_value DESC;

-- 15. Total revenue and order count per customer
SELECT c.CustomerID, c.CustomerName, COUNT(*) AS orders_count, SUM(o.OrderAmount) AS total_revenue
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY total_revenue DESC;
