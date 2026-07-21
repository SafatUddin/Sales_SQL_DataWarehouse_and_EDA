-- ==========================================================================================================================
-- 10_PART_TO_WHOLE_ANALYSIS: Contribution Percentages
-- ==========================================================================================================================
-- Purpose: Analyze how an individual part performs compared to the overall total
-- Formula: (Measure / Total(Measure)) * 100 BY Dimension
-- Helps understand which category has the greatest impact on the business
-- ==========================================================================================================================

-- =================================================================
-- Category Contribution to Overall Sales
-- =================================================================

WITH category_sales AS (
    SELECT 
        P.category,
        SUM(sales_amount) AS total_sales
    FROM gold_analytics.fact_sales S
    LEFT JOIN gold_analytics.dim_products P
        ON S.product_key = P.product_key
    GROUP BY P.category
)
SELECT 
    category,
    total_sales,
    SUM(total_sales) OVER() AS overall_sales,
    -- Percentage contribution to total sales
    CONCAT(ROUND(((total_sales / SUM(total_sales) OVER()) * 100), 2), '%') AS percentage_of_overall_sales
FROM category_sales
ORDER BY total_sales DESC;

-- =================================================================
-- Country Contribution to Overall Quantity
-- =================================================================

WITH country_quantity AS (
    SELECT 
        C.country,
        SUM(S.quantity) AS total_quantity
    FROM gold_analytics.fact_sales S
    LEFT JOIN gold_analytics.dim_customers C
        ON S.customer_key = C.customer_key
    GROUP BY C.country
)
SELECT 
    country,
    total_quantity,
    SUM(total_quantity) OVER() AS overall_quantity,
    CONCAT(ROUND(((total_quantity / SUM(total_quantity) OVER()) * 100), 2), '%') AS percentage_of_overall_quantity
FROM country_quantity
ORDER BY total_quantity DESC;
