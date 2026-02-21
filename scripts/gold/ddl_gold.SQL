/*
=================================================================================================
DDL Script: Create Gold Views
=================================================================================================

Script Purpose: 
    This script creates views for the Gold Layer in the data Warehouse.
    The Gold Layer represents the final dimension and fact tables (Star Schema)


    Each view performs transformations and combines data from the Silver layer to produce a 
    clean, enriched, and business-ready dataset.

    usage:
          - These views can be queried directly for analytics and reporting.
================================================================================================
*/
/*==========================================================================================================
Create Dimension: gold.Dim_customers
============================================================================================================
*/

IF OBJECT_ID('gold.Dim_customer','V') IS NOT NULL
	DROP gold.Dim_customer;
GO;

CREATE VIEW gold.Dim_Customer AS
SELECT 
    ROW_NUMBER() over (order by ci.cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	cb.Cntry AS country,
	ci.cst_marital_status AS marital_status,
	Case WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the master table for the column gender
	      ELSE COALESCE(ca.gen,'n/a')
	END as gender,
	ca.bdate AS birthdate,
	ci.cst_create_date AS create_date
	
	
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key =ca.Cid
LEFT JOIN silver.erp_loc_a101 cb
ON ci.cst_key=cb.Cid

-----------------------------------------------Product Information----------------------------------------------------------------
/*==========================================================================================================
Create Dimension: gold.Dim_procduct
============================================================================================================
*/

IF OBJECT_ID('gold.Dim_Product','V') IS NOT NULL
	DROP gold.Dim_Product;
GO;

CREATE VIEW gold.Dim_Product AS
SELECT
    ROW_NUMBER() over( Order By bi.prd_start_dt,bi.prd_id) as Product_key,
	bi.prd_id AS product_id,
	bi.prd_key AS product_number,
    bi.prd_nm AS product_name,
	bi.cat_id AS category_id,
	coalesce(da.cat,'n/a') AS category,
    coalesce(da.subcat,'n/a') AS subcategory,
    coalesce(da.maintenance,'n/a') AS maintenance,
    bi.prd_cost AS product_cost,
    bi.prd_line AS product_line,
    bi.prd_start_dt AS product_start_date
FROM silver.crm_prd_info bi
left JOIN silver.erp_px_cat_g1v2 da
ON bi.cat_id =da.id
WHERE prd_end_dt IS NULL -- Filter out all historical data

---------------------------------------------Sales View-----------------------------------------------------------
/*==========================================================================================================
Create Dimension: gold.fact_sales
============================================================================================================
*/

IF OBJECT_ID('gold.fact_sales','V') IS NOT NULL
	DROP gold.fact_sales;
GO;
CREATE VIEW gold.fact_sales AS
SELECT
sd.sls_ord_num AS order_number,
pr.Product_key,
cp.customer_key,
sd.sls_order_dt AS order_date,
sd.sls_ship_dt AS shipping_date,
sd.sls_due_dt AS due_date,
sd.sls_sales AS sales_amount,
sd.sls_quantity AS quantity,
sd.sls_price AS price
FROM [silver].[crm_sales_details] sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.[product_number]
LEFT JOIN gold.dim_customers cp
ON sd.sls_cust_id =cp.[customer_id]
