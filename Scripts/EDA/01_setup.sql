-- ==========================================================================================================================
-- 01_SETUP: Schema, Tables, and Data Loading
-- ==========================================================================================================================
-- Purpose: Create the gold_analytics schema and populate it with data from the Gold Layer
-- ==========================================================================================================================

-- Create Schema
CREATE SCHEMA IF NOT EXISTS gold_analytics;

-- Drop and Create Dimension: Customers
DROP TABLE IF EXISTS gold_analytics.dim_customers;
CREATE TABLE gold_analytics.dim_customers (
    customer_key    INT,
    customer_id     INT,
    customer_number VARCHAR(50),
    first_name      VARCHAR(50),
    last_name       VARCHAR(50),
    country         VARCHAR(50),
    marital_status  VARCHAR(50),
    gender          VARCHAR(50),
    birthdate       DATE NULL,
    create_date     DATE NULL
);

-- Drop and Create Dimension: Products
DROP TABLE IF EXISTS gold_analytics.dim_products;
CREATE TABLE gold_analytics.dim_products (
    product_key     INT,
    product_id      INT,
    product_number  VARCHAR(50),
    product_name    VARCHAR(50),
    category_id     VARCHAR(50),
    category        VARCHAR(50),
    subcategory     VARCHAR(50),
    maintenance     VARCHAR(50),
    cost            INT,
    product_line    VARCHAR(50),
    start_date      DATE NULL
);

-- Drop and Create Fact: Sales
DROP TABLE IF EXISTS gold_analytics.fact_sales;
CREATE TABLE gold_analytics.fact_sales (
    order_number    VARCHAR(50),
    product_key     INT,
    customer_key    INT,
    order_date      DATE NULL,
    shipping_date   DATE NULL,
    due_date        DATE NULL,
    sales_amount    INT,
    quantity        INT,
    price           INT
);

-- ==========================================================================================================================
-- Load Data from Gold Layer
-- ==========================================================================================================================

TRUNCATE TABLE gold_analytics.dim_customers;
INSERT INTO gold_analytics.dim_customers
SELECT * FROM gold.dim_customers;

TRUNCATE TABLE gold_analytics.dim_products;
INSERT INTO gold_analytics.dim_products
SELECT * FROM gold.dim_products;

TRUNCATE TABLE gold_analytics.fact_sales;
INSERT INTO gold_analytics.fact_sales
SELECT * FROM gold.fact_sales;

-- ==========================================================================================================================
-- Verify Data Load
-- ==========================================================================================================================

SELECT 'dim_customers' AS table_name, COUNT(*) AS row_count FROM gold_analytics.dim_customers
UNION ALL
SELECT 'dim_products', COUNT(*) FROM gold_analytics.dim_products
UNION ALL
SELECT 'fact_sales', COUNT(*) FROM gold_analytics.fact_sales;
