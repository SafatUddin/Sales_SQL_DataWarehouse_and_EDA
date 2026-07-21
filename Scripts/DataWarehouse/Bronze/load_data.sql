-- ============================================================
-- BRONZE LAYER: Load Raw Data from CSV Files
-- ============================================================
-- NOTE: Copy CSV files to MySQL secure files folder first:
-- sudo cp /path/to/*.csv /var/lib/mysql-files/
-- ============================================================

SHOW VARIABLES LIKE 'secure_file_priv';

-- Load CRM Customer Info
TRUNCATE TABLE bronze.crm_cust_info;
LOAD DATA INFILE '/var/lib/mysql-files/cust_info.csv'
INTO TABLE bronze.crm_cust_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@cst_id, @cst_key, @cst_firstname, @cst_lastname, @cst_marital_status, @cst_gndr, @cst_create_date)
SET 
    cst_id             = NULLIF(@cst_id, ''),
    cst_key            = @cst_key,
    cst_firstname      = @cst_firstname,
    cst_lastname       = @cst_lastname,
    cst_marital_status = @cst_marital_status,
    cst_gndr           = @cst_gndr,
    cst_create_date    = IF(TRIM(@cst_create_date) = '', NULL, STR_TO_DATE(TRIM(@cst_create_date), '%Y-%m-%d'));

-- Load CRM Product Info
TRUNCATE TABLE bronze.crm_prd_info;
LOAD DATA INFILE '/var/lib/mysql-files/prd_info.csv'
INTO TABLE bronze.crm_prd_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@prd_id, @prd_key, @prd_nm, @prd_cost, @prd_line, @prd_start_date, @prd_end_date)
SET 
    prd_id         = NULLIF(@prd_id, ''),
    prd_key        = @prd_key,
    prd_nm         = @prd_nm,
    prd_cost       = NULLIF(@prd_cost, ''),
    prd_line       = @prd_line,
    prd_start_date = IF(TRIM(@prd_start_date) = '', NULL, STR_TO_DATE(TRIM(@prd_start_date), '%Y-%m-%d')),
    prd_end_date   = IF(TRIM(@prd_end_date) = '', NULL, STR_TO_DATE(TRIM(@prd_end_date), '%Y-%m-%d'));

-- Load CRM Sales Details
TRUNCATE TABLE bronze.crm_sales_details;
LOAD DATA INFILE '/var/lib/mysql-files/sales_details.csv'
INTO TABLE bronze.crm_sales_details
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@sls_ord_num, @sls_prd_key, @sls_cust_id, @sls_order_dt, @sls_ship_dt, @sls_due_dt, @sls_sales, @sls_quantity, @sls_price)
SET 
    sls_ord_num   = @sls_ord_num,
    sls_prd_key   = @sls_prd_key,
    sls_cust_id   = NULLIF(@sls_cust_id, ''),
    sls_order_dt  = IF(TRIM(@sls_order_dt) REGEXP '^[0-9]{8}$', STR_TO_DATE(TRIM(@sls_order_dt), '%Y%m%d'), NULL),
    sls_ship_dt   = IF(TRIM(@sls_ship_dt) REGEXP '^[0-9]{8}$', STR_TO_DATE(TRIM(@sls_ship_dt), '%Y%m%d'), NULL),
    sls_due_dt    = IF(TRIM(@sls_due_dt)  REGEXP '^[0-9]{8}$', STR_TO_DATE(TRIM(@sls_due_dt), '%Y%m%d'), NULL),
    sls_sales     = NULLIF(@sls_sales, ''),
    sls_quantity  = NULLIF(@sls_quantity, ''),
    sls_price     = NULLIF(@sls_price, '');

-- Load ERP Customer AZ12
TRUNCATE TABLE bronze.erp_cust_az12;
LOAD DATA INFILE '/var/lib/mysql-files/CUST_AZ12.csv'
INTO TABLE bronze.erp_cust_az12
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@cid, @bdate, @gen)
SET 
    cid   = @cid,
    bdate = IF(TRIM(@bdate) = '', NULL, STR_TO_DATE(TRIM(@bdate), '%Y-%m-%d')),
    gen   = @gen;

-- Load ERP Location AZ101
TRUNCATE TABLE bronze.erp_loc_az101;
LOAD DATA INFILE '/var/lib/mysql-files/LOC_A101.csv'
INTO TABLE bronze.erp_loc_az101
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@cid, @cntry)
SET 
    cid   = @cid,
    cntry = @cntry;

-- Load ERP Product Category G1V2
TRUNCATE TABLE bronze.erp_px_cat_g1v2;
LOAD DATA INFILE '/var/lib/mysql-files/PX_CAT_G1V2.csv'
INTO TABLE bronze.erp_px_cat_g1v2
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@id, @cat, @subcat, @maintenance)
SET 
    id          = @id,
    cat         = @cat,
    subcat      = @subcat,
    maintenance = @maintenance;