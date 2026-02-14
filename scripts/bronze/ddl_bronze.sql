/*
=======================================================================================================
DDL SCRIPT: Create Bronze Tables
=======================================================================================================
Script Purpose:
  This script creates tables in the 'bronze' schema, dropping existing tables if they exist.
 Run this script to re-define the DDL structure of 'bronze' tables.
=======================================================================================================
*/

IF OBJECT_ID('bronze.crm_cust_info','U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info(
	cst_id int NULL,
	cst_key nvarchar(50) NULL,
	cst_firstname nvarchar(50) NULL,
	cst_lastname nvarchar(50) NULL,
	cst_marital_status nvarchar(50) NULL,
	cst_gndr nvarchar(50) NULL,
	cst_create_date date NULL
)
GO;

IF OBJECT_ID('bronze.crm_prd_info','U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info
(
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATETIME,
	prd_end_dt DATETIME
);
GO;

IF OBJECT_ID('bronze.crm_prd_info','U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info(
	prd_id int NULL,
    prd_key nvarchar(50) NULL,
	prd_nm nvarchar(50) NULL,
	prd_cost int NULL,
	prd_line nvarchar(50) NULL,
	prd_start_dt datetime NULL,
	prd_end_dt datetime NULL
);
GO;

IF OBJECT_ID('bronze.crm_sales_details','U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details(
	sls_ord_num nvarchar(50) NULL,
	sls_prd_key nvarchar(50) NULL,
	sls_cust_id int NULL,
	sls_order_dt int NULL,
	sls_ship_dt int NULL,
	sls_due_dt int NULL,
	sls_sales int NULL,
	sls_quantity int NULL,
	sls_price int NULL
); 
GO;

IF OBJECT_ID('bronze.erp_cust_az12','U') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12(
	Cid nvarchar(50) NULL,
	bdate date NULL,
	gen nvarchar(50) NULL
);
GO;

IF OBJECT_ID('bronze.erp_loc_a101','U') IS NOT NULL
	DROP TABLE bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101(
	Cid nvarchar(50) NULL,
	Cntry nvarchar(50) NULL
);
GO;

IF OBJECT_ID('bronze.erp_px_cat_g1v2','U') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2(
	id nvarchar(50) NULL,
	cat nvarchar(50) NULL,
	subcat nvarchar(50) NULL,
	maintenance nvarchar(50) NULL
);
GO;
