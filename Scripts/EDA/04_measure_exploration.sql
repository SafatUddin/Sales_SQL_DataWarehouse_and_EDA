-- ==========================================================================================================================
-- 04_MEASURE_EXPLORATION: Key Business Metrics & KPIs
-- ==========================================================================================================================
-- Purpose: Calculate core business measures
-- Note: If a data field is numeric and makes sense to aggregate, it's a Measure.
--       Examples: Sales, Quantity, Price, Cost
-- ==========================================================================================================================

-- Total Sales Revenue
SELECT SUM(sales_amount) AS total_sales 
FROM gold_analytics.fact_sales;

-- Total Items Sold
SELECT SUM(quantity) AS no_of_items_sold 
FROM gold_analytics.fact_sales;

-- Average Selling Price
SELECT AVG(price) AS average_selling_price 
FROM gold_analytics.fact_sales;

-- Total Number of Orders
SELECT COUNT(DISTINCT order_number) AS total_number_of_orders 
FROM gold_analytics.fact_sales;

-- Total Number of Products
SELECT COUNT(DISTINCT product_name) AS total_number_of_products 
FROM gold_analytics.dim_products;

-- Total Number of Customers
SELECT COUNT(DISTINCT customer_id) AS total_number_of_customers 
FROM gold_analytics.dim_customers;

-- Total Number of Customers Who Placed an Order
SELECT COUNT(DISTINCT customer_key) AS no_of_customers_that_placed_order 
FROM gold_analytics.fact_sales;

-- =================================================================
-- Unified KPI Dashboard
-- =================================================================

SELECT 'Total Sales' AS measure_name, 
       CAST(SUM(sales_amount) AS SIGNED) AS measure_value 
FROM gold_analytics.fact_sales 
UNION ALL 
SELECT 'No of Items Sold', 
       CAST(SUM(quantity) AS SIGNED) 
FROM gold_analytics.fact_sales 
UNION ALL 
SELECT 'Average Selling Price', 
       CAST(AVG(price) AS SIGNED) 
FROM gold_analytics.fact_sales 
UNION ALL 
SELECT 'Total Number of Orders', 
       CAST(COUNT(DISTINCT order_number) AS SIGNED) 
FROM gold_analytics.fact_sales 
UNION ALL 
SELECT 'Total Number of Products', 
       CAST(COUNT(DISTINCT product_name) AS SIGNED) 
FROM gold_analytics.dim_products 
UNION ALL 
SELECT 'Total Number of Customers', 
       CAST(COUNT(DISTINCT customer_id) AS SIGNED) 
FROM gold_analytics.dim_customers 
UNION ALL 
SELECT 'Total Number of Customers that placed an Order', 
       CAST(COUNT(DISTINCT customer_key) AS SIGNED) 
FROM gold_analytics.fact_sales;
