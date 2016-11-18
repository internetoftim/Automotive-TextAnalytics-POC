-------------------------------------------------------------------------------
-- Script       : 302_extract_ngram.sql
-- Purpose      : Extract Ngram and check top tokens.
--                
-- Author(s)    : Tim Santos
-- History      : 20151203 – Tim Santos – Initial Version
---------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Extract unigram for the complaints data
-- Make sure that tokens are case insensitive 
-- and empty entries are removed.
-- @input		: car_complaints.nhtsa_cmpl_with_category
-- @output		: car_complaints.nhtsa_cmpl_1gram
-- @param		: CASE_INSENSITIVE('true') 
-- @param		: GRAMS (1)
---------------------------------------------------------------------------------
INSERT INTO car_complaints.nhtsa_cmpl_1gram 
SELECT *
FROM   NGRAM(
              ON car_complaints.nhtsa_cmpl_with_category
              TEXT_COLUMN('cdescr')
              GRAMS(1)
              CASE_INSENSITIVE('true')
              PUNCTUATION('[()-.,!?'']')  
              ACCUMULATE('cmplid')
            )
WHERE TRIM(ngram) != '' ;

-------------------------------------------------------------------------------
-- Extract bigram for the complaints data
-- Make sure that tokens are case insensitive 
-- and empty entries are removed.
-- @input		: car_complaints.nhtsa_cmpl_with_category
-- @output		: car_complaints.nhtsa_cmpl_2gram
-- @param		: CASE_INSENSITIVE('true') 
-- @param		: GRAMS (2)
---------------------------------------------------------------------------------       
INSERT INTO car_complaints.nhtsa_cmpl_2gram 
SELECT *
FROM   NGRAM(
              ON car_complaints.nhtsa_cmpl_with_category
              TEXT_COLUMN('cdescr')
              GRAMS(2)
              CASE_INSENSITIVE('true')
              PUNCTUATION('[()-.,!?'']')  
              ACCUMULATE('cmplid')
            )
WHERE TRIM(ngram) != '' ;
