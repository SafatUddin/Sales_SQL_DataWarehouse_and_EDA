---
### 02_METADATA_EXPLORATION: Database Object Discovery
---
Purpose: Explore all database objects using INFORMATION_SCHEMA

---

### Q) List tables in the gold_analytics schema only
#### Answer:
```SQL
SELECT 
    TABLE_CATALOG, 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'gold_analytics';
```

**Output:**
| TABLE_CATALOG | TABLE_SCHEMA | TABLE_NAME | TABLE_TYPE |
|---------------|--------------|------------|------------|
| def | gold_analytics | customer_report | VIEW |
| def | gold_analytics | dim_customers | BASE TABLE |
| def | gold_analytics | dim_products | BASE TABLE |
| def | gold_analytics | fact_sales | BASE TABLE |
| def | gold_analytics | product_report | VIEW |

### Q) List columns in the gold_analytics schema only
#### Answer:
```SQL
SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'gold_analytics'
ORDER BY TABLE_NAME, ORDINAL_POSITION;
```

**Output:**
| TABLE_CATALOG | TABLE_SCHEMA | TABLE_NAME | COLUMN_NAME | ORDINAL_POSITION | COLUMN_DEFAULT | IS_NULLABLE | DATA_TYPE | CHARACTER_MAXIMUM_LENGTH | CHARACTER_OCTET_LENGTH | NUMERIC_PRECISION | NUMERIC_SCALE | DATETIME_PRECISION | CHARACTER_SET_NAME | COLLATION_NAME | COLUMN_TYPE | COLUMN_KEY | EXTRA | PRIVILEGES | COLUMN_COMMENT | GENERATION_EXPRESSION | SRS_ID |
|---------------|--------------|------------|-------------|------------------|----------------|-------------|-----------|--------------------------|------------------------|-------------------|---------------|--------------------|--------------------|----------------|-------------|------------|-------|------------|----------------|----------------------|--------|
| def | gold_analytics | customer_report | customer_key | 1 | NULL | YES | int | NULL | NULL | 10 | 0 | NULL | NULL | NULL | int | | | select,insert,update,references | | | NULL |
| def | gold_analytics | customer_report | customer_number | 2 | NULL | YES | varchar | 50 | 200 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(50) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | customer_report | customer_name | 3 | NULL | YES | varchar | 101 | 404 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(101) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | customer_report | age | 4 | NULL | YES | bigint | NULL | NULL | 19 | 0 | NULL | NULL | NULL | bigint | | | select,insert,update,references | | | NULL |
| def | gold_analytics | customer_report | age_group | 5 | | NO | varchar | 8 | 32 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(8) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | customer_report | customer_rank | 6 | | NO | varchar | 7 | 28 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(7) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | customer_report | total_orders | 7 | 0 | NO | bigint | NULL | NULL | 19 | 0 | NULL | NULL | NULL | bigint | | | select,insert,update,references | | | NULL |
| def | gold_analytics | customer_report | total_sales | 8 | NULL | YES | decimal | NULL | NULL | 32 | 0 | NULL | NULL | NULL | decimal(32,0) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | customer_report | total_quantity_purchased | 9 | NULL | YES | decimal | NULL | NULL | 32 | 0 | NULL | NULL | NULL | decimal(32,0) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | customer_report | total_products | 10 | 0 | NO | bigint | NULL | NULL | 19 | 0 | NULL | NULL | NULL | bigint | | | select,insert,update,references | | | NULL |
| def | gold_analytics | customer_report | lifespan | 11 | NULL | YES | varchar | 28 | 112 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(28) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | customer_report | recency | 12 | NULL | YES | varchar | 27 | 108 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(27) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | customer_report | average_order_value | 13 | NULL | YES | decimal | NULL | NULL | 35 | 2 | NULL | NULL | NULL | decimal(35,2) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | customer_report | average_monthly_spend | 14 | NULL | YES | decimal | NULL | NULL | 35 | 2 | NULL | NULL | NULL | decimal(35,2) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | dim_customers | customer_key | 1 | NULL | YES | int | NULL | NULL | 10 | 0 | NULL | NULL | NULL | int | | | select,insert,update,references | | | NULL |
| def | gold_analytics | dim_customers | customer_id | 2 | NULL | YES | int | NULL | NULL | 10 | 0 | NULL | NULL | NULL | int | | | select,insert,update,references | | | NULL |
| def | gold_analytics | dim_customers | customer_number | 3 | NULL | YES | varchar | 50 | 200 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(50) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | dim_customers | first_name | 4 | NULL | YES | varchar | 50 | 200 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(50) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | dim_customers | last_name | 5 | NULL | YES | varchar | 50 | 200 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(50) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | dim_customers | country | 6 | NULL | YES | varchar | 50 | 200 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(50) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | dim_customers | marital_status | 7 | NULL | YES | varchar | 50 | 200 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(50) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | dim_customers | gender | 8 | NULL | YES | varchar | 50 | 200 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(50) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | dim_customers | birthdate | 9 | NULL | YES | date | NULL | NULL | NULL | NULL | NULL | NULL | NULL | date | | | select,insert,update,references | | | NULL |
| def | gold_analytics | dim_customers | create_date | 10 | NULL | YES | date | NULL | NULL | NULL | NULL | NULL | NULL | NULL | date | | | select,insert,update,references | | | NULL |
| def | gold_analytics | dim_products | product_key | 1 | NULL | YES | int | NULL | NULL | 10 | 0 | NULL | NULL | NULL | int | | | select,insert,update,references | | | NULL |
| def | gold_analytics | dim_products | product_id | 2 | NULL | YES | int | NULL | NULL | 10 | 0 | NULL | NULL | NULL | int | | | select,insert,update,references | | | NULL |
| def | gold_analytics | dim_products | product_number | 3 | NULL | YES | varchar | 50 | 200 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(50) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | dim_products | product_name | 4 | NULL | YES | varchar | 50 | 200 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(50) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | dim_products | category_id | 5 | NULL | YES | varchar | 50 | 200 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(50) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | dim_products | category | 6 | NULL | YES | varchar | 50 | 200 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(50) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | dim_products | subcategory | 7 | NULL | YES | varchar | 50 | 200 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(50) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | dim_products | maintenance | 8 | NULL | YES | varchar | 50 | 200 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(50) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | dim_products | cost | 9 | NULL | YES | int | NULL | NULL | 10 | 0 | NULL | NULL | NULL | int | | | select,insert,update,references | | | NULL |
| def | gold_analytics | dim_products | product_line | 10 | NULL | YES | varchar | 50 | 200 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(50) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | dim_products | start_date | 11 | NULL | YES | date | NULL | NULL | NULL | NULL | NULL | NULL | NULL | date | | | select,insert,update,references | | | NULL |
| def | gold_analytics | fact_sales | order_number | 1 | NULL | YES | varchar | 50 | 200 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(50) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | fact_sales | product_key | 2 | NULL | YES | int | NULL | NULL | 10 | 0 | NULL | NULL | NULL | int | | | select,insert,update,references | | | NULL |
| def | gold_analytics | fact_sales | customer_key | 3 | NULL | YES | int | NULL | NULL | 10 | 0 | NULL | NULL | NULL | int | | | select,insert,update,references | | | NULL |
| def | gold_analytics | fact_sales | order_date | 4 | NULL | YES | date | NULL | NULL | NULL | NULL | NULL | NULL | NULL | date | | | select,insert,update,references | | | NULL |
| def | gold_analytics | fact_sales | shipping_date | 5 | NULL | YES | date | NULL | NULL | NULL | NULL | NULL | NULL | NULL | date | | | select,insert,update,references | | | NULL |
| def | gold_analytics | fact_sales | due_date | 6 | NULL | YES | date | NULL | NULL | NULL | NULL | NULL | NULL | NULL | date | | | select,insert,update,references | | | NULL |
| def | gold_analytics | fact_sales | sales_amount | 7 | NULL | YES | int | NULL | NULL | 10 | 0 | NULL | NULL | NULL | int | | | select,insert,update,references | | | NULL |
| def | gold_analytics | fact_sales | quantity | 8 | NULL | YES | int | NULL | NULL | 10 | 0 | NULL | NULL | NULL | int | | | select,insert,update,references | | | NULL |
| def | gold_analytics | fact_sales | price | 9 | NULL | YES | int | NULL | NULL | 10 | 0 | NULL | NULL | NULL | int | | | select,insert,update,references | | | NULL |
| def | gold_analytics | product_report | product_key | 1 | NULL | YES | int | NULL | NULL | 10 | 0 | NULL | NULL | NULL | int | | | select,insert,update,references | | | NULL |
| def | gold_analytics | product_report | product_number | 2 | NULL | YES | varchar | 50 | 200 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(50) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | product_report | product_name | 3 | NULL | YES | varchar | 50 | 200 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(50) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | product_report | category | 4 | NULL | YES | varchar | 50 | 200 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(50) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | product_report | subcategory | 5 | NULL | YES | varchar | 50 | 200 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(50) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | product_report | cost | 6 | NULL | YES | int | NULL | NULL | 10 | 0 | NULL | NULL | NULL | int | | | select,insert,update,references | | | NULL |
| def | gold_analytics | product_report | sales_performance | 7 | | NO | varchar | 14 | 56 | NULL | NULL | NULL | utf8mb4 | utf8mb4_0900_ai_ci | varchar(14) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | product_report | total_orders | 8 | 0 | NO | bigint | NULL | NULL | 19 | 0 | NULL | NULL | NULL | bigint | | | select,insert,update,references | | | NULL |
| def | gold_analytics | product_report | total_sales | 9 | NULL | YES | decimal | NULL | NULL | 32 | 0 | NULL | NULL | NULL | decimal(32,0) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | product_report | total_quantity_sold | 10 | NULL | YES | decimal | NULL | NULL | 32 | 0 | NULL | NULL | NULL | decimal(32,0) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | product_report | total_customers | 11 | 0 | NO | bigint | NULL | NULL | 19 | 0 | NULL | NULL | NULL | bigint | | | select,insert,update,references | | | NULL |
| def | gold_analytics | product_report | lifespan | 12 | NULL | YES | bigint | NULL | NULL | 19 | 0 | NULL | NULL | NULL | bigint | | | select,insert,update,references | | | NULL |
| def | gold_analytics | product_report | recency | 13 | NULL | YES | bigint | NULL | NULL | 19 | 0 | NULL | NULL | NULL | bigint | | | select,insert,update,references | | | NULL |
| def | gold_analytics | product_report | average_order_revenue | 14 | NULL | YES | decimal | NULL | NULL | 35 | 2 | NULL | NULL | NULL | decimal(35,2) | | | select,insert,update,references | | | NULL |
| def | gold_analytics | product_report | average_monthly_revenue | 15 | NULL | YES | decimal | NULL | NULL | 35 | 2 | NULL | NULL | NULL | decimal(35,2) | | | select,insert,update,references | | | NULL |
