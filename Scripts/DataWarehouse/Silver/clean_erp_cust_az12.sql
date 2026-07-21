-- ============================================================
-- SILVER LAYER: Clean & Standardize ERP Customer AZ12
-- ============================================================
-- Data Quality Checks:
--   - Remove 'NAS' prefix from customer IDs
--   - Fix out-of-range birthdates
--   - Standardize gender (M/Male→Male, F/Female→Female)
-- ============================================================

-- Check out of range dates
SELECT DISTINCT bdate FROM bronze.erp_cust_az12 WHERE bdate < '1926-01-01' OR bdate > NOW();

-- Check gender standardization
SELECT DISTINCT gen FROM bronze.erp_cust_az12;

-- Load cleaned data
TRUNCATE TABLE silver.erp_cust_az12;
INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
SELECT 
    CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid)) ELSE cid END AS cid,
    CASE WHEN bdate > NOW() THEN NULL ELSE bdate END AS bdate,
    CASE 
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
        WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
        ELSE 'N/A'
    END AS gen
FROM bronze.erp_cust_az12;