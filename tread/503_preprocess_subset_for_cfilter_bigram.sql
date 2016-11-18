-------------------------------------------------------------------------------
-- Script       : 503_preprocess_subset_for_cfilter_bigram.sql
-- Purpose      : Pre-process subset of data depending on TREAD buckets.              
-- Author(s)    : Tim Santos
-- History      : 20151203 – Tim Santos – Initial Version
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Prepares the data for collaborative filtering within a TREAD bucket.
-- This creates the bigram table.
-- This example uses the ENGINE TREAD bucket.
---------------------------------------------------------------------------------
INSERT INTO car_complaints.nhtsa_engine_2gram
SELECT 
       cmplid
      ,ngram 
      ,n 
      ,frequency      
FROM   NGRAM(
              ON (
                   SELECT tokens 
                         ,cmplid
                   FROM TEXT_PARSER(
                                     ON ( SELECT n.cdescr
                                                ,n.cmplid 
                                          FROM car_complaints.nhtsa_cmpl_with_category n 
                                          WHERE n.compdesc_category = 'ENGINE' 
                                        )
                                     TEXT_COLUMN('cdescr')
                                     CASE_INSENSITIVE('true')
                                     PUNCTUATION('[()-.,!?'']')
                                     REMOVE_STOP_WORDS('true')
                                     -- Option to use pre-defined stop word list, check with client for list
                                      STOP_WORDS('stopwords_common_mysql_google.txt')
                                     OUTPUT_BY_WORD('false')
                                     ACCUMULATE('cmplid')
                                   )
                 )
              GRAMS(2) 
              TEXT_COLUMN('tokens')
              ACCUMULATE('cmplid')
            );

-------------------------------------------------------------------------------            
-- Inspect extracted data.
-------------------------------------------------------------------------------            
SELECT * FROM car_complaints.nhtsa_engine_2gram LIMIT 5;

