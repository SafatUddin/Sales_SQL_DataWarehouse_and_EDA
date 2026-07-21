-- ============================================================
-- SILVER LAYER: Clean & Standardize CRM Sales Details
-- ============================================================
-- Data Quality Checks:
--   - Validate foreign keys (prd_key, cust_id)
--   - Fix invalid dates (0 values, wrong formats)
--   - Fix date ordering (order ≤ ship ≤ due)
--   - Fix sales/quantity/price consistency
--   - Remove negatives and nulls
-- ============================================================

-- Validate foreign keys
SELECT * FROM bronze.crm_sales_details WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info);
SELECT * FROM bronze.crm_sales_details WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info);

-- Check invalid dates
SELECT * FROM bronze.crm_sales_details 
WHERE sls_order_dt = 0 OR LENGTH(sls_order_dt) != 8 OR sls_order_dt > 20500101 OR sls_order_dt < 19000101;

-- Check date ordering
SELECT * FROM bronze.crm_sales_details WHERE sls_order_dt > sls_ship_dt;
SELECT * FROM bronze.crm_sales_details WHERE sls_order_dt > sls_due_dt;
SELECT * FROM bronze.crm_sales_details WHERE sls_ship_dt > sls_due_dt;

-- Load cleaned data
TRUNCATE TABLE silver.crm_sales_details;
INSERT INTO silver.crm_sales_details (sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price)
WITH step1 AS (
    SELECT 
        sls_ord_num, sls_prd_key, sls_cust_id,
        CASE WHEN sls_order_dt = 0 THEN NULL ELSE CAST(CAST(sls_order_dt AS CHAR) AS DATE) END AS sls_order_dt,
        CASE WHEN sls_ship_dt = 0 THEN NULL ELSE CAST(CAST(sls_ship_dt AS CHAR) AS DATE) END AS sls_ship_dt,
        CASE WHEN sls_due_dt = 0 THEN NULL ELSE CAST(CAST(sls_due_dt AS CHAR) AS DATE) END AS sls_due_dt,
        CASE 
            WHEN sls_sales IS NULL OR sls_sales <= 0 THEN ABS(sls_price) * ABS(sls_quantity)
            WHEN sls_price IS NOT NULL AND sls_quantity IS NOT NULL AND sls_sales != ABS(sls_price) * ABS(sls_quantity) 
            THEN ABS(sls_price) * ABS(sls_quantity)
            ELSE ABS(sls_sales)
        END AS new_sales,
        sls_quantity,
        sls_price
    FROM bronze.crm_sales_details
),
step2 AS (
    SELECT *,
        CASE 
            WHEN sls_price IS NULL OR sls_price <= 0 THEN new_sales / NULLIF(ABS(sls_quantity), 0)
            ELSE ABS(sls_price)
        END AS new_price
    FROM step1
)
SELECT 
    sls_ord_num, sls_prd_key, sls_cust_id,
    sls_order_dt, sls_ship_dt, sls_due_dt,
    new_sales AS sls_sales, sls_quantity, new_price AS sls_price
FROM step2;