-- ==========================================================================================================================
-- 05_MAGNITUDE_ANALYSIS: Compare Measures by Categories
-- ==========================================================================================================================
-- Purpose: Understand the importance of different categories
-- Concept: Break down measures by dimension to see which categories drive the business
-- Examples: Total sales by country, Total quantity by category, Average price by product
-- ==========================================================================================================================

-- =================================================================
-- Customer Magnitude Analysis
-- =================================================================

-- Total customers by country
SELECT 
    country, 
    COUNT(DISTINCT customer_id) AS total_customers 
FROM gold_analytics.dim_customers 
GROUP BY country 
ORDER BY total_customers DESC;

-- Total customers by gender
SELECT 
    gender, 
    COUNT(DISTINCT customer_id) AS total_customers 
FROM gold_analytics.dim_customers 
GROUP BY gender;

-- =================================================================
-- Product Magnitude Analysis
-- =================================================================

-- Total products by category
SELECT 
    category, 
    COUNT(DISTINCT product_id) AS total_products 
FROM gold_analytics.dim_products 
GROUP BY category 
ORDER BY total_products DESC;

-- Average cost by category
SELECT 
    category, 
    AVG(cost) AS average_cost 
FROM gold_analytics.dim_products 
GROUP BY category 
ORDER BY average_cost DESC;

-- =================================================================
-- Sales Magnitude Analysis
-- =================================================================

-- Total revenue by product category
SELECT 
    P.category, 
    SUM(S.sales_amount) AS total_revenue
FROM gold_analytics.fact_sales S
LEFT JOIN gold_analytics.dim_products P
    ON S.product_key = P.product_key 
GROUP BY P.category
ORDER BY total_revenue DESC;

-- Total revenue by customer
SELECT 
    C.customer_id, 
    C.first_name, 
    C.last_name, 
    SUM(S.sales_amount) AS total_revenue
FROM gold_analytics.fact_sales S
LEFT JOIN gold_analytics.dim_customers C
    ON S.customer_key = C.customer_key
GROUP BY C.customer_id, C.first_name, C.last_name
ORDER BY total_revenue DESC;

-- Distribution of sold items across countries
SELECT 
    C.country, 
    SUM(S.quantity) AS total_sold
FROM gold_analytics.fact_sales S
LEFT JOIN gold_analytics.dim_customers C
    ON S.customer_key = C.customer_key
GROUP BY C.country
ORDER BY total_sold DESC;
