-- Advanced_Analysis.sql: In-Depth Insights and Trend Analysis

-- 1. Month-over-month revenue trend
SELECT DATE_TRUNC('month', OrderDate) AS month, SUM(OrderAmount) AS total_revenue
FROM orders
GROUP BY month
ORDER BY month;

-- 2. Quarterly revenue analysis
SELECT DATE_TRUNC('quarter', OrderDate) AS quarter, SUM(OrderAmount) AS total_revenue
FROM orders
GROUP BY quarter
ORDER BY quarter;

-- 3. Correlation between customer age and average order amount
SELECT 
  c.Age,
  AVG(o.OrderAmount) AS avg_order_amount
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY c.Age
ORDER BY c.Age;

-- 4. Customer lifetime value (total revenue per customer)
SELECT c.CustomerID, c.CustomerName, SUM(o.OrderAmount) AS lifetime_value
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY lifetime_value DESC;

-- 5. Repeat purchase behavior: Number of customers with multiple orders
SELECT COUNT(*) AS repeat_customers
FROM (
  SELECT CustomerID, COUNT(*) AS order_count
  FROM orders
  GROUP BY CustomerID
  HAVING COUNT(*) > 1
) AS repeat_orders;

-- 6. Product category revenue growth over time
SELECT DATE_TRUNC('quarter', o.OrderDate) AS quarter, p.Category, SUM(o.OrderAmount) AS revenue
FROM orders o
JOIN products p ON o.ProductID = p.ProductID
GROUP BY quarter, p.Category
ORDER BY quarter, revenue DESC;

-- 7. Order trends by day of the week
SELECT EXTRACT(DOW FROM OrderDate) AS day_of_week, COUNT(*) AS orders_count
FROM orders
GROUP BY day_of_week
ORDER BY day_of_week;

-- 8. Identify churn customers: Customers with no orders in the last 6 months
SELECT c.CustomerID, c.CustomerName
FROM customers c
WHERE c.CustomerID NOT IN (
  SELECT DISTINCT CustomerID
  FROM orders
  WHERE OrderDate >= CURRENT_DATE - INTERVAL '6 months'
);

-- 9. Distribution of orders per customer (order frequency distribution)
SELECT order_count, COUNT(*) AS frequency
FROM (
  SELECT CustomerID, COUNT(*) AS order_count
  FROM orders
  GROUP BY CustomerID
) AS orders_per_customer
GROUP BY order_count
ORDER BY order_count;

-- 10. Relationship between order quantity and order amount
SELECT Quantity, AVG(OrderAmount) AS avg_order_amount
FROM orders
GROUP BY Quantity
ORDER BY Quantity;

-- 11. Advanced segmentation: Revenue by product category and region
SELECT l.Country, p.Category, SUM(o.OrderAmount) AS total_revenue
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
JOIN locations l ON c.LocationID = l.LocationID
JOIN products p ON o.ProductID = p.ProductID
GROUP BY l.Country, p.Category
ORDER BY total_revenue DESC;

-- 12. Daily revenue trend analysis
SELECT CAST(OrderDate AS DATE) AS order_day, SUM(OrderAmount) AS daily_revenue
FROM orders
GROUP BY order_day
ORDER BY order_day;

-- 13. Forecasting next month’s revenue using historical averages
SELECT AVG(monthly_revenue) AS forecast_next_month
FROM (
  SELECT DATE_TRUNC('month', OrderDate) AS month, SUM(OrderAmount) AS monthly_revenue
  FROM orders
  GROUP BY month
) AS monthly_data;

-- 14. Customer segmentation: Average order amount by age group
SELECT 
  CASE 
    WHEN Age < 25 THEN 'Under 25'
    WHEN Age BETWEEN 25 AND 40 THEN '25-40'
    WHEN Age BETWEEN 41 AND 60 THEN '41-60'
    ELSE '60+'
  END AS age_group,
  AVG(o.OrderAmount) AS avg_order_amount
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY age_group;

-- 15. Top 5 customers with highest lifetime value by region
SELECT l.Country, c.CustomerID, c.CustomerName, SUM(o.OrderAmount) AS lifetime_value
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
JOIN locations l ON c.LocationID = l.LocationID
GROUP BY l.Country, c.CustomerID, c.CustomerName
ORDER BY lifetime_value DESC
LIMIT 5;
