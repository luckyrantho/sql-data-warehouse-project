/*
====================================================================================================================
Quality Checks
====================================================================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, and standardization across the
    the 'silver' schema. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run all data quality and integrity checks before loading data into the Silver Layer.
    - Investigate, analyse, and resolve any discrepancies, anomalies, or validation failures
      identified during these checks before proceeding with the load.
====================================================================================================================

*/

-- Check for Nulls or duplicates in Primary keys
-- Expectation: No Result

WITH dups AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY prd_key 
               ORDER BY prd_key DESC
           ) AS rn
    FROM [bronze].[crm_prd_info]
)
SELECT *
FROM dups
WHERE rn > 1 OR prd_key IS NULL;

--Check for unwanted spaces
-- Expectations: No Resut

SELECT [prd_nm]
 
  FROM [DataWarehouse].[bronze].[crm_prd_info]
  where [prd_nm] != TRIM([prd_nm])

-- Check for NULLs and Negative Numbers
-- Expectation: No Results
SELECT prd_cost
  FROM [DataWarehouse].[bronze].[crm_prd_info]
  where prd_cost < 0 OR prd_cost IS NULL

-- Data Standardization & COnsistency
SELECT distinct prd_line 
from [DataWarehouse].[bronze].[crm_prd_info]

--Check for invalid Date Orders
SELECT 
prd_id,
prd_key,
prd_nm,
prd_start_dt,
LEAD(prd_start_dt) OVER (PARTITION BY prd_key Order By prd_start_dt)-1 as prd_end_date
from [DataWarehouse].[bronze].[crm_prd_info]
where prd_key in ('AC-HE-HL-U509-R','AC-HE-HL-U509')  

-------------------------------------------------------------------------------------------------------------
select
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE 
     WHEN sls_order_dt <=0 OR LEN(sls_order_dt) !=8 THEN NULL
	 ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
END AS  sls_order_dt,
CASE WHEN sls_ship_dt<=0 OR LEN(sls_ship_dt) !=8 THEN NULL
     ELSE CAST(CAST(sls_ship_dt AS VARCHAR) as DATE)
END AS sls_ship_dt,
CASE WHEN sls_due_dt <= 0 OR LEN(sls_due_dt) !=8 THEN NULL
     ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) 
END AS sls_due_dt,
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != ABS(sls_price) * sls_quantity
     THEN ABS(sls_price) * sls_quantity
	 ELSE sls_sales
END AS sls_sales,
sls_quantity,
CASE WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales/NULLIF(sls_quantity,0)
     ELSE sls_price
END AS sls_price

from [bronze].[crm_sales_details]
---------------------------------------------------------------------------------------------------------------------------
select 
CASE WHEN Cid like 'NAS%' THEN SUBSTRING(Cid,4,len(Cid))
     ELSE Cid
END AS Cid,
CASE WHEN bdate > GETDATE() THEN NULL
	 ELSE bdate
END AS bdate,
CASE 
     WHEN UPPER(TRIM(gen)) IN ('Male','M') THEN 'Male'
	 WHEN UPPER(TRIM(gen)) IN ('Female','F') THEN 'Female'
	 ELSE 'n/a'
END AS gen
from [bronze].[erp_cust_az12]
---------------------------------------------------------------------------------------------
select REPLACE(Cid,'-','') as Cid,
CASE WHEN TRIM(Cntry)  = 'DE' THEN 'Germany'
     WHEN TRIM(Cntry) IN ('US','USA') THEN 'United States'
	 WHEN TRIM(Cntry) ='' OR Cntry IS NULL THEN 'n/a'
	 ELSE TRIM(Cntry)
END AS Cntry
from [bronze].[erp_loc_a101]
