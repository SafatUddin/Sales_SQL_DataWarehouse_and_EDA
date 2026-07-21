-- ==========================================================================================================================
-- 09_PERFORMANCE_ANALYSIS: Current vs Target Comparisons
-- ==========================================================================================================================
-- Purpose: Compare current values to target/baseline values
-- Measures success and compares performance across periods
-- Examples: (Current Sales - Average Sales), (Current Year - Previous Year), (Current - Lowest)
-- ==========================================================================================================================

-- =================================================================
-- Yearly Product Performance vs Average & Previous Year
-- =================================================================

WITH yearly_product_sales AS (
    SELECT 
        YEAR(S.order_date) AS order_year,
        P.product_name,
        SUM(S.sales_amount) AS current_sales
    FROM gold_analytics.fact_sales S
    LEFT JOIN gold_analytics.dim_products P
        ON S.product_key = P.product_key
    WHERE order_date IS NOT NULL
    GROUP BY order_year, P.product_name
)
SELECT 
    order_year,
    product_name,
    current_sales,
    -- Previous year sales for same product
    LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC) AS previous_year_sales,
    -- Difference from previous year
    current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC) AS diff_py_sales,
    -- Change direction indicator
    CASE 
        WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change,
    -- Average sales across all years for this product
    CAST(AVG(current_sales) OVER(PARTITION BY product_name) AS SIGNED) AS average_sales,
    -- Difference from average
    current_sales - CAST(AVG(current_sales) OVER(PARTITION BY product_name) AS SIGNED) AS diff_avg,
    -- Performance vs average indicator
    CASE 
        WHEN current_sales - CAST(AVG(current_sales) OVER(PARTITION BY product_name) AS SIGNED) > 0 THEN 'Above Average'
        WHEN current_sales - CAST(AVG(current_sales) OVER(PARTITION BY product_name) AS SIGNED) < 0 THEN 'Below Average'
        ELSE 'Average'
    END AS avg_change
FROM yearly_product_sales
ORDER BY product_name, order_year;
