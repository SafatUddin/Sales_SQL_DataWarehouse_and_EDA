-- ============================================================
-- GOLD LAYER: The Business-Ready Zone
-- ============================================================
-- Definition:       Business-Ready data
-- Objective:        Provide data for reporting & Analytics
-- Object Type:      Views
-- Load Method:      None
-- Transformation:   Data Integration, Aggregation, Business Logic
-- Data Modeling:    Star Schema (Dimensions + Facts)
-- Target Audience:  Data Analysts, Business Users
-- ============================================================
-- Star Schema: One Fact table with multiple Dimension tables
-- Dimensions: Descriptive context (What? Who? Where?)
-- Facts: Quantitative events (How much? How many?)
-- ============================================================

DROP SCHEMA IF EXISTS gold;
CREATE SCHEMA IF NOT EXISTS gold;