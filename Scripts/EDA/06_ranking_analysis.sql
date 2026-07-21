-- ==========================================================================================================================
-- 06_RANKING_ANALYSIS: Top N | Bottom N Analysis
-- ==========================================================================================================================
-- Purpose: Order dimensions by measure values to identify best and worst performers
-- ==========================================================================================================================

-- =================================================================
-- Product Ranking
-- =================================================================

-- Top 5 products by revenue
SELECT 
    P.product_name, 
    SUM(S.sales_amount) AS total_revenue 
FROM gold_analytics.fact_sales S
LEFT JOIN gold_analytics.dim_products P
    ON S.product_key = P.product_key
GROUP BY P.product_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Top 5 products by revenue (using window function)
SELECT 
    ROW_NUMBER() OVER(ORDER BY SUM(S.sales_amount) DESC) AS rank_no,
    P.product_name, 
    SUM(S.sales_amount) AS total_revenue
FROM gold_analytics.fact_sales S
LEFT JOIN gold_analytics.dim_products P
    ON S.product_key = P.product_key
GROUP BY P.product_name
LIMIT 5;

-- Bottom 5 worst performing products by sales
SELECT 
    P.product_name, 
    SUM(S.sales_amount) AS total_revenue 
FROM gold_analytics.fact_sales S
LEFT JOIN gold_analytics.dim_products P
    ON S.product_key = P.product_key
GROUP BY P.product_name
ORDER BY total_revenue ASC
LIMIT 5;

-- =================================================================
-- Subcategory Ranking
-- =================================================================

-- Top 5 subcategories by revenue
SELECT 
    P.subcategory, 
    SUM(S.sales_amount) AS total_revenue 
FROM gold_analytics.fact_sales S
LEFT JOIN gold_analytics.dim_products P
    ON S.product_key = P.product_key
GROUP BY P.subcategory
ORDER BY total_revenue DESC
LIMIT 5;

-- Bottom 5 subcategories by revenue
SELECT 
    P.subcategory, 
    SUM(S.sales_amount) AS total_revenue 
FROM gold_analytics.fact_sales S
LEFT JOIN gold_analytics.dim_products P
    ON S.product_key = P.product_key
GROUP BY P.subcategory
ORDER BY total_revenue ASC
LIMIT 5;

-- =================================================================
-- Customer Ranking
-- =================================================================

-- Top 10 customers by revenue
SELECT 
    ROW_NUMBER() OVER(ORDER BY SUM(S.sales_amount) DESC) AS rank_no,
    C.customer_id, 
    C.first_name, 
    C.last_name,
    SUM(S.sales_amount) AS total_revenue
FROM gold_analytics.fact_sales S
LEFT JOIN gold_analytics.dim_customers C
    ON S.customer_key = C.customer_key
GROUP BY C.customer_id, C.first_name, C.last_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Top 3 customers with fewest orders placed
SELECT 
    ROW_NUMBER() OVER(ORDER BY COUNT(DISTINCT order_number) ASC) AS rank_no,
    C.customer_id, 
    C.first_name, 
    C.last_name,
    COUNT(DISTINCT order_number) AS no_of_orders_placed
FROM gold_analytics.fact_sales S
LEFT JOIN gold_analytics.dim_customers C
    ON S.customer_key = C.customer_key
GROUP BY C.customer_id, C.first_name, C.last_name
ORDER BY no_of_orders_placed ASC
LIMIT 3;
