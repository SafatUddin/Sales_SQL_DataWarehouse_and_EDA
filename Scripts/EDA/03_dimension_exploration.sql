-- ==========================================================================================================================
-- 03_DIMENSION_EXPLORATION: Exploring Descriptive Data
-- ==========================================================================================================================
-- Purpose: Understand the dimension tables and their value distributions
-- Note: If a data field is numeric but doesn't make sense to aggregate, it's a Dimension.
--       Examples: ID, Category, Product, Birthdate
-- ==========================================================================================================================

-- =================================================================
-- Customer Dimensions
-- =================================================================

-- Preview customer data
SELECT * FROM gold_analytics.dim_customers;

-- Explore all countries our customers come from
SELECT DISTINCT country FROM gold_analytics.dim_customers;

-- =================================================================
-- Product Dimensions
-- =================================================================

-- Preview product data
SELECT * FROM gold_analytics.dim_products;

-- Explore all categories and subcategories
SELECT DISTINCT 
    category, 
    subcategory, 
    product_name 
FROM gold_analytics.dim_products 
ORDER BY 1, 2, 3;

-- =================================================================
-- Date Dimensions (from Fact Table)
-- =================================================================

-- Preview sales data
SELECT * FROM gold_analytics.fact_sales;

-- Find the first and last order dates
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    TIMESTAMPDIFF(YEAR,  MIN(order_date), MAX(order_date)) AS order_range_years,
    TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold_analytics.fact_sales;

-- Find the first and last shipping dates
SELECT 
    MIN(shipping_date) AS first_shipping_date,
    MAX(shipping_date) AS last_shipping_date,
    TIMESTAMPDIFF(YEAR,  MIN(shipping_date), MAX(shipping_date)) AS shipping_range_years,
    TIMESTAMPDIFF(MONTH, MIN(shipping_date), MAX(shipping_date)) AS shipping_range_months
FROM gold_analytics.fact_sales;

-- Find the first and last due dates
SELECT 
    MIN(due_date) AS first_due_date,
    MAX(due_date) AS last_due_date,
    TIMESTAMPDIFF(YEAR,  MIN(due_date), MAX(due_date)) AS due_range_years,
    TIMESTAMPDIFF(MONTH, MIN(due_date), MAX(due_date)) AS due_range_months
FROM gold_analytics.fact_sales;

-- =================================================================
-- Customer Age Analysis
-- =================================================================

-- Find the oldest and youngest customers
SELECT 
    MIN(birthdate) AS oldest_birthdate,
    MAX(birthdate) AS youngest_birthdate,
    TIMESTAMPDIFF(YEAR, MIN(birthdate), NOW()) AS oldest_customer_age,
    TIMESTAMPDIFF(YEAR, MAX(birthdate), NOW()) AS youngest_customer_age
FROM gold_analytics.dim_customers;
