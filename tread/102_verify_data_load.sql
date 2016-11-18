-------------------------------------------------------------------------------
-- Script       : 102_verify_data_load.sql
-- Purpose      : Verify loaded data.
--                Inspect Error Log table and malformed entries.
-- Author(s)    : Tim Santos
-- History      : 20151203 – Tim Santos – Initial Version
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- 'nhtsa_err' is the tag specified in ncluster_loader
-- Change the tag for every run, in order to identify the errors in each session
-- Error tables: nc_system.nc_errortable_part and nc_system.nc_errortable_repl
-------------------------------------------------------------------------------
SELECT COUNT(*) FROM car_complaints.nhtsa_cmpl;
SELECT COUNT(*) FROM nc_system.nc_errortable_part WHERE label ILIKE '%nhtsa_err%';
SELECT COUNT(*) FROM nc_system.nc_errortable_repl WHERE label ILIKE '%nhtsa_err%';

-------------------------------------------------------------------------------
--        Total Tuples:    1243680
--        Loaded Tuples:   1235899
--        Malformed Tuples:7781
-------------------------------------------------------------------------------

SELECT * FROM nc_system.nc_errortable_part WHERE label ILIKE '%nhtsa_err%' limit 5;
-------------------------------------------------------------------------------
-- (LABEL) nhtsa_err 
-- (TARGET TABLE) car_complaints.nhtsa_cmpl    
-- (ERROR MESSAGE) invalid byte sequence for encoding "UTF8": 0xbf      
-- (LINENUMBER) 180015 NULL
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Inspect the malformed lines indicated in the error table from the raw data
-- sed -n -e 180015 FLAT_CMPL_PIPED.txt
-- sed -n -e (LINENUMBER)p FLAT_CMPL_PIPED.txt
-- (MALFORMED DATA) ...TRUTH THOSE ▒!@#$%MAKE BETTER CARS 
--  THAN FORDS FORD MUSTANGS SUCK THEY ARE A CHES... 
-------------------------------------------------------------------------------

SELECT COUNT(*) FROM car_complaints.pos_tags;

SELECT COUNT(*) FROM car_complaints.nhtsa_category_mapping;

