-- ==========================================================================================================================
-- 08_CUMULATIVE_ANALYSIS: Running Totals & Moving Averages
-- ==========================================================================================================================
-- Purpose: Aggregate data progressively over time
-- Helps understand if the business is growing or declining
-- ==========================================================================================================================

-- =================================================================
-- Monthly Sales with Running Total & Moving Average
-- =================================================================

SELECT 
    order_period,
    total_sales,
    -- Running total of sales over time
    SUM(total_sales) OVER(ORDER BY real_date) AS running_total,
    -- Average price per period
    average_price,
    -- Moving average of price (resets yearly)
    CAST(AVG(average_price) OVER(ORDER BY real_date) AS SIGNED) AS moving_average
FROM (
    SELECT 
        DATE_FORMAT(order_date, '%M-%Y') AS order_period,
        MIN(order_date) AS real_date, 
        SUM(sales_amount) AS total_sales,
        CAST(AVG(price) AS SIGNED) AS average_price
    FROM gold_analytics.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_FORMAT(order_date, '%M-%Y')
) t
ORDER BY real_date;

-- =================================================================
-- Alternative: Running Total Partitioned by Year
-- =================================================================

SELECT 
    order_period,
    total_sales,
    SUM(total_sales) OVER(PARTITION BY YEAR(real_date) ORDER BY real_date) AS running_total_yearly,
    average_price,
    CAST(AVG(average_price) OVER(PARTITION BY YEAR(real_date) ORDER BY real_date) AS SIGNED) AS moving_average_yearly
FROM (
    SELECT 
        DATE_FORMAT(order_date, '%M-%Y') AS order_period,
        MIN(order_date) AS real_date, 
        SUM(sales_amount) AS total_sales,
        CAST(AVG(price) AS SIGNED) AS average_price
    FROM gold_analytics.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_FORMAT(order_date, '%M-%Y')
) t
ORDER BY real_date;
