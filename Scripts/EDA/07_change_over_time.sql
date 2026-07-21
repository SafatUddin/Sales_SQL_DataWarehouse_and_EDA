-- ==========================================================================================================================
-- 07_CHANGE_OVER_TIME: Trend & Seasonality Analysis
-- ==========================================================================================================================
-- Purpose: Analyze how measures evolve over time
-- Helps track trends and identify seasonality in the data
-- ==========================================================================================================================

-- =================================================================
-- Yearly Performance
-- =================================================================

SELECT 
    YEAR(order_date) AS order_year, 
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold_analytics.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_year
ORDER BY order_year;

-- =================================================================
-- Monthly Performance
-- =================================================================

SELECT 
    YEAR(order_date) AS order_year,
    MONTHNAME(order_date) AS order_month, 
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold_analytics.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_year, order_month
ORDER BY order_year, order_month;

-- =================================================================
-- Monthly-Yearly Formatted Performance
-- =================================================================

SELECT 
    DATE_FORMAT(order_date, '%M-%Y') AS order_period, 
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold_analytics.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%M-%Y')
ORDER BY DATE_FORMAT(order_date, '%M-%Y');
