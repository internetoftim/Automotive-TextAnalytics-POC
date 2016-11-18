-------------------------------------------------------------------------------
-- Script       : 502_preprocess_subset_for_cfilter_unigram.sql
-- Purpose      : Pre-process subset of data depending on TREAD buckets.              
-- Author(s)    : Tim Santos
-- History      : 20151203 – Tim Santos – Initial Version
--
-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
set session search_path = car_complaints,public;
\install stopwords_common_mysql_google.txt

-------------------------------------------------------------------------------
-- Prepares the data for collaborative filtering within a TREAD bucket.
-- This creates the unigram table.
-- This example uses the ENGINE TREAD bucket.
---------------------------------------------------------------------------------
INSERT INTO car_complaints.nhtsa_engine_1gram
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
              GRAMS(1) 
              TEXT_COLUMN('tokens')
              ACCUMULATE('cmplid')
            );
            
-------------------------------------------------------------------------------
-- Inspect extracted data.
-------------------------------------------------------------------------------
SELECT * FROM car_complaints.nhtsa_engine_1gram LIMIT 5;

-------------------------------------------------------------------------------
-- Prepares the data for collaborative filtering within a TREAD bucket.
-- This creates the unigram table.
-- This example uses the BRAKES TREAD bucket.
---------------------------------------------------------------------------------
INSERT INTO car_complaints.nhtsa_brakes_1gram
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
                                          WHERE n.compdesc_category = 'BRAKES' 
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
              GRAMS(1) 
              TEXT_COLUMN('tokens')
              ACCUMULATE('cmplid')
            );

-------------------------------------------------------------------------------
-- Inspect extracted data.
-------------------------------------------------------------------------------
SELECT * FROM car_complaints.nhtsa_brakes_1gram LIMIT 5;

-------------------------------------------------------------------------------
-- Prepares the data for collaborative filtering within a TREAD bucket.
-- This creates the unigram table with tokens only present
-- in the reduced feature space from the feature selection section.
-- This example uses the BRAKES TREAD bucket.
---------------------------------------------------------------------------------
INSERT INTO car_complaints.nhtsa_engine_1gram_fs
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
              GRAMS(1) 
              TEXT_COLUMN('tokens')
              ACCUMULATE('cmplid')
            )
WHERE ngram
IN (
     SELECT token 
     FROM car_complaints.nhtsa_train_1gram_tfidf_fs
     WHERE compdesc_category='ENGINE'
   );            

-------------------------------------------------------------------------------
-- Inspect extracted data.
-------------------------------------------------------------------------------   
SELECT COUNT(*) FROM car_complaints.nhtsa_engine_1gram_fs;
SELECT COUNT(*) FROM car_complaints.nhtsa_engine_1gram;

