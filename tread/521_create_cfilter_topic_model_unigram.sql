-------------------------------------------------------------------------------
-- Script       : 521_create_cfilter_topic_model.sql
-- Purpose      : Perform CFILTER topic modelling. This prepares the models
--                for the sigma-graphs.
--                
-- Author(s)    : Tim Santos
-- History      : 20151203 – Tim Santos – Initial Version
--
-------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Output from the CFilter function for unigram 
-- Make sure to drop the table before running the SQL-MR function
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_engine_1gram_cfilter;

-------------------------------------------------------------------------------
-- Performs collaborative filtering within a TREAD bucket.
-- Find terms that are frequently paired with other terms within a TREAD bucket.
-- @input       : car_complaints.nhtsa_engine_1gram
-- @output      : car_complaints.nhtsa_engine_1gram_cfilter
---------------------------------------------------------------------------------
SELECT *
FROM   CFILTER(
	            ON (SELECT 1)
	            PARTITION BY 1
	            INPUTTABLE('car_complaints.nhtsa_engine_1gram')
                OUTPUTTABLE('car_complaints.nhtsa_engine_1gram_cfilter')
                INPUTCOLUMNS('ngram')
                JOINCOLUMNS('cmplid')
              );

---------------------------------------------------------------------------------
-- Inspect output of cfilter
---------------------------------------------------------------------------------
SELECT * FROM car_complaints.nhtsa_engine_1gram_cfilter LIMIT 5;
 
SELECT COUNT(*) FROM car_complaints.nhtsa_engine_1gram_cfilter;

---------------------------------------------------------------------------------
-- Output from the CFilter function for unigram with tokens from 
-- reduced feature space are only selected.
-- Make sure to drop the table before running the SQL-MR function
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_engine_1gram_cfilter_fs;

-------------------------------------------------------------------------------
-- Performs collaborative filtering within a TREAD bucket.
-- Find terms that are frequently paired with other terms within a TREAD bucket.
-- @input       : car_complaints.nhtsa_engine_1gram
-- @output      : car_complaints.nhtsa_engine_1gram_cfilter
---------------------------------------------------------------------------------

SELECT *
FROM   CFILTER(
	            ON (SELECT 1)
	            PARTITION BY 1
	            INPUTTABLE('car_complaints.nhtsa_engine_1gram_fs')
                OUTPUTTABLE('car_complaints.nhtsa_engine_1gram_cfilter_fs')
                INPUTCOLUMNS('ngram')
                JOINCOLUMNS('cmplid')
              );

---------------------------------------------------------------------------------
-- Output from the CFilter function for unigram 
-- Make sure to drop the table before running the SQL-MR function
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_brakes_1gram_cfilter;

-------------------------------------------------------------------------------
-- Performs collaborative filtering within a TREAD bucket.
-- Find terms that are frequently paired with other terms within a TREAD bucket.
-- @input       : car_complaints.nhtsa_brakes_1gram
-- @output      : car_complaints.nhtsa_brakes_1gram_cfilter
---------------------------------------------------------------------------------
SELECT *
FROM   CFILTER(
	            ON (SELECT 1)
	            PARTITION BY 1
	            INPUTTABLE('car_complaints.nhtsa_brakes_1gram')
                OUTPUTTABLE('car_complaints.nhtsa_brakes_1gram_cfilter')
                INPUTCOLUMNS('ngram')
                JOINCOLUMNS('cmplid')
              );

---------------------------------------------------------------------------------
-- Inspect output of cfilter
---------------------------------------------------------------------------------
SELECT * FROM car_complaints.nhtsa_brakes_1gram_cfilter LIMIT 5;
 
SELECT COUNT(*) FROM car_complaints.nhtsa_brakes_1gram_cfilter;              
