/*
==============================================================================================
Quality Checks
==============================================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, and 
    accuracy of the Gold layer. These checks ensure:
     - Uniqueness of surrogate keys in dimension tables.
     - Referential integrity between fact and dimension tables.
     - Validation of relationships in the data model for analytical purposes.

Usage Notes:
  - Run these checks after data loading Gold Layer.
  - Investigate and resolve any discrepancies found during the checks

================================================================================================

*/

--================================================================================================
--Checking 'gold.Dim_customer'
==================================================================================================
-- Checking the uniqueness of Customer Key in gold.Dim_customer
-- Expectation: No results

SELECT customer_key,
       COUNT(*)
FROM gold.Dim_customer
GROUP BY customer_key
HAVING COUNT(*) > 1;


--================================================================================================
--Checking 'gold.Dim_customer'
==================================================================================================
-- Checking the uniqueness of Customer Key in gold.Dim_customer
-- Expectation: No results

SELECT product_key,
       COUNT(*)
FROM gold.Dim_product
GROUP BY product_key
HAVING COUNT(*) > 1;



--================================================================================================
--Checking 'gold.fact_sales'
==================================================================================================
-------------------------------------------------------------------------------------------
---Foreign key integrity(Dimensions)
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_products c
ON f.Product_key =c.Product_key
where c.Product_key is null
