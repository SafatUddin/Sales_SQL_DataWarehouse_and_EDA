-- ============================================================
-- SILVER LAYER: The Intermediate/Cleaned Zone
-- ============================================================
-- Definition:       Clean & standardized data
-- Objective:        Prepare Data for Analysis
-- Object Type:      Tables
-- Load Method:      Full Load (Truncate & Insert)
-- Transformation:   Data Cleaning, Standardization, Normalization,
--                   Derived Columns, Data Enrichment
-- Data Modeling:    None (as-is)
-- Target Audience:  Data Analysts, Data Engineers
-- ============================================================

DROP SCHEMA IF EXISTS silver;
CREATE SCHEMA IF NOT EXISTS silver;