-- Business_Problems.sql: Real-World Marketing and Sales Challenges & SQL Solutions

-- 1. Find the most cost-effective marketing channel (highest ROI)
SELECT channel, SUM(revenue) / NULLIF(SUM(spend), 0) AS roi
FROM marketing_data
GROUP BY channel
ORDER BY roi DESC;

-- 2. Identify regions with the lowest return on ad spend
SELECT region, SUM(revenue) / NULLIF(SUM(spend), 0) AS roi
FROM marketing_data
GROUP BY region
ORDER BY roi ASC
LIMIT 5;

-- 3. Detect campaigns with overspending but low ROI
SELECT campaign_id, SUM(spend) AS total_spend, 
       SUM(revenue) / NULLIF(SUM(spend), 0) AS roi
FROM marketing_data
GROUP BY campaign_id
HAVING total_spend > 50000 AND roi < 1;

-- 4. Find campaigns with low conversion rates
SELECT campaign_id, (SUM(conversions) * 100.0 / NULLIF(SUM(clicks), 0)) AS conversion_rate
FROM marketing_data
GROUP BY campaign_id
HAVING conversion_rate < 3
ORDER BY conversion_rate ASC
LIMIT 10;

-- 5. Determine which campaigns have the highest customer retention
SELECT campaign_id, COUNT(DISTINCT customer_id) AS repeat_customers
FROM marketing_data
WHERE is_repeat_customer = TRUE
GROUP BY campaign_id
ORDER BY repeat_customers DESC;

-- 6. Analyze seasonal trends in revenue generation
SELECT DATE_TRUNC('month', campaign_date) AS month, SUM(revenue) AS total_revenue
FROM marketing_data
GROUP BY month
ORDER BY month;

-- 7. Evaluate the impact of discount offers on conversion rates
SELECT discount_applied, AVG(conversions * 100.0 / NULLIF(clicks, 0)) AS avg_conversion_rate
FROM marketing_data
GROUP BY discount_applied
ORDER BY avg_conversion_rate DESC;

-- 8. Compare customer acquisition cost (CPA) by region
SELECT region, SUM(spend) / NULLIF(SUM(conversions), 0) AS cpa
FROM marketing_data
GROUP BY region
ORDER BY cpa ASC;

-- 9. Identify product categories generating the highest revenue
SELECT product_category, SUM(revenue) AS total_revenue
FROM marketing_data
GROUP BY product_category
ORDER BY total_revenue DESC;

-- 10. Find high-spend campaigns that are underperforming in revenue
SELECT campaign_id, SUM(spend) AS total_spend, SUM(revenue) AS total_revenue
FROM marketing_data
GROUP BY campaign_id
HAVING total_spend > 20000 AND total_revenue < 20000
ORDER BY total_spend DESC;

-- 11. Identify customers with high lifetime value but low purchase frequency
SELECT c.CustomerID, c.CustomerName, COUNT(o.OrderID) AS order_count, SUM(o.OrderAmount) AS lifetime_value
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) = 1 AND SUM(o.OrderAmount) > 1000
ORDER BY lifetime_value DESC;

-- 12. Determine regions with the lowest average order value
SELECT l.Country, AVG(o.OrderAmount) AS avg_order_value
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
JOIN locations l ON c.LocationID = l.LocationID
GROUP BY l.Country
ORDER BY avg_order_value ASC
LIMIT 5;

-- 13. Identify customers showing a decline in purchase frequency over time
SELECT c.CustomerID, c.CustomerName, COUNT(o.OrderID) AS total_orders,
       MIN(o.OrderDate) AS first_order, MAX(o.OrderDate) AS last_order
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) = 1 OR MAX(o.OrderDate) < CURRENT_DATE - INTERVAL '1 year'
ORDER BY total_orders ASC;

-- 14. Analyze products with high average revenue per order
SELECT p.ProductID, p.ProductName, AVG(o.OrderAmount) AS avg_revenue
FROM orders o
JOIN products p ON o.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY avg_revenue DESC
LIMIT 10;

-- 15. Identify cross-selling opportunities: customers who purchased a specific product also bought another product
SELECT a.CustomerID, a.ProductID AS Product_A, b.ProductID AS Product_B, COUNT(*) AS co_purchase_count
FROM orders a
JOIN orders b ON a.CustomerID = b.CustomerID AND a.ProductID <> b.ProductID
GROUP BY a.CustomerID, a.ProductID, b.ProductID
HAVING COUNT(*) > 1
ORDER BY co_purchase_count DESC;
