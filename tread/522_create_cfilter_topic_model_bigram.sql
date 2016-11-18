-------------------------------------------------------------------------------
-- Script       : 522_create_cfilter_topic_model_bigram.sql
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
DROP TABLE IF EXISTS car_complaints.nhtsa_engine_2gram_cfilter;


-------------------------------------------------------------------------------
-- Performs collaborative filtering within a TREAD bucket.
-- Find terms that are frequently paired with other terms within a TREAD bucket.
-- @input       : car_complaints.nhtsa_engine_2gram
-- @output      : car_complaints.nhtsa_engine_2gram_cfilter
---------------------------------------------------------------------------------

SELECT *
FROM   CFILTER(
	            ON (SELECT 1)
	            PARTITION BY 1
	            INPUTTABLE('car_complaints.nhtsa_engine_2gram')
                OUTPUTTABLE('car_complaints.nhtsa_engine_2gram_cfilter')
                INPUTCOLUMNS('ngram')
                JOINCOLUMNS('cmplid')
              );

---------------------------------------------------------------------------------
-- Inspect output of cfilter
---------------------------------------------------------------------------------
SELECT * FROM car_complaints.nhtsa_engine_2gram_cfilter LIMIT 5;
 
