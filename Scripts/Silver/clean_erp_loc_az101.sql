-- ============================================================
-- SILVER LAYER: Clean & Standardize ERP Location AZ101
-- ============================================================
-- Data Quality Checks:
--   - Remove hyphens from customer IDs
--   - Standardize country names (US/USA→United States, DE→Germany)
--   - Handle empty/null countries
-- ============================================================

-- Check unmatched customer IDs
SELECT REPLACE(cid, '-', '') AS cid, cntry 
FROM bronze.erp_loc_az101 
WHERE REPLACE(cid, '-', '') NOT IN (SELECT cst_key FROM silver.crm_cust_info);

-- Check country standardization
SELECT DISTINCT cntry FROM bronze.erp_loc_az101;

-- Load cleaned data
TRUNCATE TABLE silver.erp_loc_az101;
INSERT INTO silver.erp_loc_az101 (cid, cntry)
SELECT 
    REPLACE(cid, '-', '') AS cid,
    CASE 
        WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
        WHEN TRIM(cntry) = 'DE' THEN 'Germany'
        WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'N/A'
        ELSE TRIM(cntry)
    END AS cntry
FROM bronze.erp_loc_az101;