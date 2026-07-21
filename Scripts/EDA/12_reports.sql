-- ==========================================================================================================================
-- 12_REPORTS: Consolidated Business Reports
-- ==========================================================================================================================
-- Purpose: Create comprehensive views for business stakeholders
-- ==========================================================================================================================

-- =================================================================
-- CUSTOMER REPORT
-- =================================================================
-- Purpose: Consolidates key customer metrics and behaviors
-- Highlights:
--   1. Essential fields: names, ages, transaction details
--   2. Segments customers into VIP, Regular, New categories
--   3. Aggregates: total orders, sales, quantity, products, lifespan
--   4. KPIs: recency, average order value, average monthly spend

DROP VIEW IF EXISTS gold_analytics.customer_report;
CREATE VIEW gold_analytics.customer_report AS (
    WITH customer_metrics AS (
        SELECT 
            C.customer_key,
            C.customer_number,
            CONCAT(COALESCE(C.first_name, ''), ' ', COALESCE(C.last_name, '')) AS customer_name,
            C.birthdate,
            TIMESTAMPDIFF(YEAR, C.birthdate, NOW()) AS age,
            COUNT(DISTINCT S.order_number) AS total_orders,
            SUM(S.sales_amount) AS total_sales,
            SUM(S.quantity) AS total_quantity_purchased,
            COUNT(DISTINCT S.product_key) AS total_products,
            TIMESTAMPDIFF(MONTH, MIN(S.order_date), MAX(S.order_date)) AS lifespan,
            TIMESTAMPDIFF(MONTH, MAX(S.order_date), NOW()) AS recency
        FROM gold_analytics.dim_customers C
        LEFT JOIN gold_analytics.fact_sales S
            ON C.customer_key = S.customer_key
        WHERE S.order_date IS NOT NULL
        GROUP BY C.customer_key, C.customer_number, C.first_name, C.last_name, C.birthdate
    )
    SELECT 
        customer_key,
        customer_number,
        customer_name,
        age,
        -- Age grouping
        CASE 
            WHEN age < 25 THEN 'Below 25'
            WHEN age BETWEEN 25 AND 39 THEN '25-39'
            WHEN age BETWEEN 40 AND 59 THEN '40-59'
            ELSE 'Above 60'
        END AS age_group,
        -- Customer ranking based on value
        CASE 
            WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_rank,
        total_orders,
        total_sales,
        total_quantity_purchased,
        total_products,
        CONCAT(lifespan, ' months') AS lifespan,
        CONCAT(recency, ' months') AS recency,
        -- Average Order Value (AOV)
        CASE 
            WHEN total_orders = 0 THEN 0
            ELSE ROUND((total_sales / total_orders), 2) 
        END AS average_order_value,
        -- Average Monthly Spend
        CASE 
            WHEN lifespan = 0 THEN total_sales
            ELSE ROUND((total_sales / lifespan), 2) 
        END AS average_monthly_spend
    FROM customer_metrics
    ORDER BY customer_key
);

-- Preview Customer Report
SELECT * FROM gold_analytics.customer_report;

-- =================================================================
-- PRODUCT REPORT
-- =================================================================
-- Purpose: Consolidates key product metrics and behaviors
-- Highlights:
--   1. Essential fields: product name, category, subcategory, cost
--   2. Segments products by revenue: High-Performer, Mid-Range, Low-Performer
--   3. Aggregates: total orders, sales, quantity sold, unique customers, lifespan
--   4. KPIs: recency, average order revenue (AOR), average monthly revenue

DROP VIEW IF EXISTS gold_analytics.product_report;
CREATE VIEW gold_analytics.product_report AS (
    WITH product_metrics AS (
        SELECT 
            P.product_key,
            P.product_number,
            P.product_name,
            P.category,
            P.subcategory,
            P.cost,
            COUNT(DISTINCT S.order_number) AS total_orders,
            SUM(S.sales_amount) AS total_sales,
            SUM(S.quantity) AS total_quantity_sold,
            COUNT(DISTINCT S.customer_key) AS total_customers,
            TIMESTAMPDIFF(MONTH, MIN(S.order_date), MAX(S.order_date)) AS lifespan,
            TIMESTAMPDIFF(MONTH, MAX(S.order_date), NOW()) AS recency
        FROM gold_analytics.fact_sales S 
        LEFT JOIN gold_analytics.dim_products P
            ON S.product_key = P.product_key
        GROUP BY P.product_key, P.product_number, P.product_name, P.category, P.subcategory, P.cost
    )
    SELECT 
        product_key,
        product_number,
        product_name,
        category,
        subcategory,
        cost,
        -- Sales performance tier
        CASE 
            WHEN total_sales > 50000 THEN 'High Performer'
            WHEN total_sales >= 10000 THEN 'Mid Range'
            ELSE 'Low Performer'
        END AS sales_performance,
        total_orders,
        total_sales,
        total_quantity_sold,
        total_customers,
        lifespan,
        recency,
        -- Average Order Revenue (AOR)
        CASE 
            WHEN total_orders = 0 THEN 0
            ELSE ROUND((total_sales / total_orders), 2)
        END AS average_order_revenue,
        -- Average Monthly Revenue
        CASE 
            WHEN lifespan = 0 THEN total_sales
            ELSE ROUND((total_sales / lifespan), 2)
        END AS average_monthly_revenue
    FROM product_metrics
    ORDER BY product_key
);

-- Preview Product Report
SELECT * FROM gold_analytics.product_report;
