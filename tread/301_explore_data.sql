-------------------------------------------------------------------------------
-- Script       : 301_explore_data.sql
-- Purpose      : Inspect the distribution of data
--
-- Author(s)    : Tim Santos
-- History      : 20151203 – Tim Santos – Initial Version
-- TODO			: Count car models, year model, other columns (crash,fire, date)
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Inspect the distribution of data with
-- with respect to the categories (compdesc_category)
-------------------------------------------------------------------------------
SELECT   compdesc_category
        ,COUNT(1) 
FROM     car_complaints.nhtsa_cmpl_with_category 
GROUP BY compdesc_category;

