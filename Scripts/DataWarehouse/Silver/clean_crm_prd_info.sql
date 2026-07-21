-- ============================================================
-- SILVER LAYER: Clean & Standardize CRM Product Info
-- ============================================================
-- Data Quality Checks:
--   - Remove duplicates
--   - Trim spaces
--   - Standardize product line (R→Road, M→Mountain, etc.)
--   - Fix negative/null costs
--   - Fix invalid date ranges (start > end)
--   - Extract cat_id from prd_key
-- ============================================================

-- Check duplicates
SELECT prd_id, COUNT(*) FROM bronze.crm_prd_info GROUP BY prd_id HAVING COUNT(*) > 1 OR prd_id IS NULL;
SELECT prd_key, COUNT(*) FROM bronze.crm_prd_info GROUP BY prd_key HAVING COUNT(*) > 1 OR prd_key IS NULL;

-- Check spaces
SELECT prd_nm FROM bronze.crm_prd_info WHERE prd_nm != TRIM(prd_nm);
SELECT prd_line FROM bronze.crm_prd_info WHERE prd_line != TRIM(prd_line);

-- Check invalid costs
SELECT prd_cost FROM bronze.crm_prd_info WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Check invalid dates
SELECT * FROM bronze.crm_prd_info WHERE prd_start_date > prd_end_date;

-- Load cleaned data
TRUNCATE TABLE silver.crm_prd_info;
INSERT INTO silver.crm_prd_info (prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_date, prd_end_date)
SELECT 
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
    prd_nm,
    IFNULL(prd_cost, 0) AS prd_cost,
    CASE 
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        ELSE 'N/A'
    END AS prd_line,
    prd_start_date,
    DATE_SUB(
        LEAD(STR_TO_DATE(prd_start_date, '%Y-%m-%d')) OVER (PARTITION BY prd_key ORDER BY prd_start_date), 
        INTERVAL 1 DAY
    ) AS prd_end_date
FROM bronze.crm_prd_info;