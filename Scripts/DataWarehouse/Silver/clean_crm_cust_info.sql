-- ============================================================
-- SILVER LAYER: Clean & Standardize CRM Customer Info
-- ============================================================
-- Data Quality Checks:
--   - Remove duplicates (keep latest by create_date)
--   - Trim unwanted spaces
--   - Standardize marital status (M→Married, S→Single)
--   - Standardize gender (F→Female, M→Male)
--   - Remove null customer IDs
-- ============================================================

-- Checking for duplicates
SELECT cst_id, COUNT(*) AS count 
FROM bronze.crm_cust_info 
GROUP BY cst_id 
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted spaces
SELECT cst_firstname FROM bronze.crm_cust_info WHERE cst_firstname != TRIM(cst_firstname);
SELECT cst_lastname FROM bronze.crm_cust_info WHERE cst_lastname != TRIM(cst_lastname);

-- Data Standardization
SELECT DISTINCT cst_gndr FROM bronze.crm_cust_info;
SELECT DISTINCT cst_marital_status FROM bronze.crm_cust_info;

-- Load cleaned data
TRUNCATE TABLE silver.crm_cust_info;
INSERT INTO silver.crm_cust_info (cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date)
SELECT 
    cst_id,
    cst_key,
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname) AS cst_lastname,
    CASE 
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        ELSE 'N/A'
    END AS cst_marital_status,
    CASE 
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        ELSE 'N/A'
    END AS cst_gndr,
    cst_create_date
FROM (
    SELECT *,
        ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
    FROM bronze.crm_cust_info 
    WHERE cst_id IS NOT NULL
) t 
WHERE flag_last = 1;

-- Validation
SELECT cst_id, COUNT(*) AS count 
FROM silver.crm_cust_info 
GROUP BY cst_id 
HAVING COUNT(*) > 1 OR cst_id IS NULL;