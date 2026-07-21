-- ============================================================
-- SILVER LAYER: Clean & Standardize ERP Product Category
-- ============================================================
-- Data Quality Checks:
--   - Trim unwanted spaces
--   - Validate distinct values
-- ============================================================

-- Check spaces
SELECT * FROM bronze.erp_px_cat_g1v2 
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);

-- Check distinct values
SELECT DISTINCT cat FROM bronze.erp_px_cat_g1v2;
SELECT DISTINCT subcat FROM bronze.erp_px_cat_g1v2;
SELECT DISTINCT maintenance FROM bronze.erp_px_cat_g1v2;

-- Load cleaned data (direct pass-through, data is clean)
TRUNCATE TABLE silver.erp_px_cat_g1v2;
INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
SELECT id, cat, subcat, maintenance FROM bronze.erp_px_cat_g1v2;