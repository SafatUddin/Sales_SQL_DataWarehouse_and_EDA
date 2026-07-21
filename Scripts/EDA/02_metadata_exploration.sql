-- ==========================================================================================================================
-- 02_METADATA_EXPLORATION: Database Object Discovery
-- ==========================================================================================================================
-- Purpose: Explore all database objects using INFORMATION_SCHEMA
-- ==========================================================================================================================

-- List all tables in the database
SELECT * FROM INFORMATION_SCHEMA.TABLES;

-- List tables in the gold_analytics schema only
SELECT 
    TABLE_CATALOG, 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'gold_analytics';

-- List all columns in the database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS;

-- List columns in the gold_analytics schema only
SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'gold_analytics'
ORDER BY TABLE_NAME, ORDINAL_POSITION;
