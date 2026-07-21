-- ============================================================
-- BRONZE LAYER: The Raw Landing Zone
-- ============================================================
-- Definition:       Raw, unprocessed data as-is from sources
-- Objective:        Traceability & Debugging
-- Object Type:      Tables
-- Load Method:      Full Load (Truncate & Insert)
-- Transformation:   None (as-is)
-- Data Modeling:    None (as-is)
-- Target Audience:  Data Engineers
-- ============================================================

DROP SCHEMA IF EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS bronze;