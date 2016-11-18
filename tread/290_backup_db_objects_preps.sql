-------------------------------------------------------------------------------
-- Script       : 290_backup_db_objects_preps.sql
-- Purpose      : Backup the tables for Data Preparation
--                
-- Author(s)    : Tim Santos
-- History      : 20151229 - Tim Santos - Initial Version
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- @description	: lookup table to map detailed Component Description with the 
--              : simplified Description or TREAD bucket
-- @column		: compdesc_orig - original component description
-- @column		: compdesc_parsed - parsed sub-category from parent-category
-- @column		: compdesc_orig - mapped to final TREAD bucket
-------------------------------------------------------------------------------
\o car_complaints.nhtsa_category
COPY car_complaints.nhtsa_category TO STDOUT WITH DELIMITER '|';
\o

-------------------------------------------------------------------------------
-- @description	: Re-labelled complaint according to the mapping
-- @column[1-39]: same as car_complaints.nhtsa_cmpl
-- @column		: compdesc_category - additional TREAD bucket mapping
-------------------------------------------------------------------------------
\o car_complaints.nhtsa_cmpl_with_category
COPY car_complaints.nhtsa_cmpl_with_category TO STDOUT WITH DELIMITER '|';
\o
