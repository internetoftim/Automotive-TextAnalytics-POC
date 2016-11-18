-------------------------------------------------------------------------------
-- Script       : 190_backup_db_objects.sql
-- @description : Backup the tables for data ingestion.
--                
-- Author(s)    : Tim Santos
-- History      : 20151229 - Tim Santos - Initial Version
-------------------------------------------------------------------------------

\o car_complaints.nhtsa_cmpl
COPY car_complaints.nhtsa_cmpl TO STDOUT WITH DELIMITER '|';
\o

------------------------------------------------------------------------------
-- Create table for POS tag lookup
-- POS tags were developed on the Penn Treebank Project
-- @source		: Available in Table 6 - 392 of Aster Analytics Foundation 
--				  User Guide 6.10
-- 				  pos_tags.csv
-------------------------------------------------------------------------------
\o car_complaints.pos_tags
COPY car_complaints.pos_tags TO STDOUT WITH DELIMITER '|';
\o

------------------------------------------------------------------------------
-- Create table for Compdesc mapping to selected TREAD buckets
-- compdesc - component description found in the NHTSA data 
-------------------------------------------------------------------------------
\o car_complaints.nhtsa_category_mapping
COPY car_complaints.nhtsa_category_mapping TO STDOUT WITH DELIMITER '|';
\o
