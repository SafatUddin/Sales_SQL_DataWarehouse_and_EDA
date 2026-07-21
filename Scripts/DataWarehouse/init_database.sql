-- ============================================================
-- DATABASE INITIALIZATION
-- Data Warehouse Project
-- ============================================================

-- Data Warehouse is a system used to store large amounts of 
-- structured data from different sources in one place,
-- so it can be easily analyzed and used for decision-making.

-- ============================================================
-- ETL (EXTRACT, TRANSFORM, LOAD) ARCHITECTURE OVERVIEW
-- ============================================================
-- 1. EXTRACTION 
--    - Pull Extraction, Push Extraction
--    - Full Extraction, Incremental Extraction
--    - Techniques: Database Querying, File Parsing, API Calls, 
--      CDC, Web Scraping, Event Based Streaming, Manual
-- 2. TRANSFORMATION 
--    - Normalization, Integration, Enrichment, Aggregation
--    - Derived Columns, Business Rules, Data Cleansing
-- 3. LOAD 
--    - Batch Processing, Stream Processing
--    - Full Load (Truncate & Insert, Upsert, Drop/Create/Insert)
--    - Incremental Load (Upsert, Append, Merge)
--    - SCD Types: 0 (Fixed), 1 (Overwrite), 2 (Historization)
-- ============================================================

-- Naming Conventions:
-- Bronze Layer: <sourcesystem>_<entity>     e.g., crm_customer_info
-- Silver Layer: <sourcesystem>_<entity>     e.g., crm_customer_info
-- Gold Layer:   <category>_<entity>         e.g., dim_customers, fact_sales
-- Surrogate Key: <table_name>_key           e.g., customer_key
-- Technical Col: dwh_<column_name>          e.g., dwh_load_date
-- Stored Proc:   load_<layer>              e.g., load_bronze

-- Drop existing database
DROP DATABASE IF EXISTS DataWarehouse;

-- Create database
CREATE DATABASE DataWarehouse;