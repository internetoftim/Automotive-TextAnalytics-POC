-------------------------------------------------------------------------------
-- Script       : 411_extract_features_unigram_tfidf.sql
-- Purpose      : Perform Feature Extraction of Unigram TFIDF. 
-- Author(s)    : Tim Santos
-- History      : 20151203 – Tim Santos – Initial Version
-- TODO			: Implement NFOLD
-------------------------------------------------------------------------------       

-------------------------------------------------------------------------------
-- Extract unigram tfidf for training data 
-- IDF is computed from the training subset 
-- @input		: car_complaints.nhtsa_train
-- @output		: car_complaints.nhtsa_train_tfidf_1gram
-- @param		: ON ( ... car_complaints.nhtsa_train) AS doccount DIMENSION  
--				  IDF is computed from the training subset 
-- todo; investigate typecasting
---------------------------------------------------------------------------------       
INSERT INTO car_complaints.nhtsa_train_1gram_tfidf 
SELECT tf
      ,idf
      ,tf_idf
      ,tfidf.cmplid
      ,compdesc_category
      ,ngram AS token
FROM   TF_IDF(
                ON TF(
                       ON (
                            SELECT cmplid
                                  ,ngram
                                  ,frequency
                            FROM   NGRAM(
                                           ON car_complaints.nhtsa_train
                                           TEXT_COLUMN('cdescr')
                                           GRAMS(1)
                                           CASE_INSENSITIVE('true')
                                           ACCUMULATE('cmplid')
                                        )
                            WHERE TRIM(ngram) != '' 
                          )
                       PARTITION BY cmplid
                     ) 
                AS tf 
                PARTITION BY ngram
                ON (
                     SELECT COUNT(*)
                     FROM   car_complaints.nhtsa_train
                   ) 
               AS doccount DIMENSION
             ) tfidf
INNER JOIN car_complaints.nhtsa_train t
ON tfidf.cmplid = t.cmplid;

-------------------------------------------------------------------------------
-- IDF used is from the training subset 
-- @input		: car_complaints.nhtsa_test
-- @input		: car_complaints.nhtsa_train_tfidf_1gram AS IDF 
--				  TFIDF is computed based on the training SET idf as a priori
-- @output		: car_complaints.nhtsa_test_tfidf_1gram
---------------------------------------------------------------------------------  
INSERT INTO car_complaints.nhtsa_test_1gram_tfidf 
SELECT tf
      ,idf
      ,tf_idf
      ,tfidf.cmplid
      ,compdesc_category
      ,ngram AS token
FROM   TF_IDF(
               ON TF(
                      ON (
                           SELECT cmplid
                                 ,ngram
                                 ,frequency
                           FROM   NGRAM(
                                         ON car_complaints.nhtsa_test
                                         TEXT_COLUMN('cdescr')
                                         GRAMS(1)
                                         CASE_INSENSITIVE('true')
                                         ACCUMULATE('cmplid')
                                       )
                           WHERE TRIM(ngram) != '' 
                         )
                      PARTITION BY cmplid
                    ) 
               AS tf 
               PARTITION BY ngram
               ON ( 
                    SELECT DISTINCT(token) AS term, idf 
                    FROM car_complaints.nhtsa_train_1gram_tfidf
                  ) 
               AS idf 
               PARTITION BY term
             ) tfidf
INNER JOIN car_complaints.nhtsa_test t
ON tfidf.cmplid = t.cmplid;
 
  
 
-------------------------------------------------------------------------------
-- Extract unigram tfidf for entire data 
-- @input		: car_complaints.nhtsa_train
-- @output		: car_complaints.nhtsa_train_tfidf_1gram
---------------------------------------------------------------------------------       
INSERT INTO car_complaints.nhtsa_cmpl_tfidf 
SELECT tf
      ,idf
      ,tf_idf
      ,tfidf.cmplid
      ,compdesc_category
      ,ngram AS token
FROM   TF_IDF(
                ON TF(
                       ON (
                            SELECT cmplid
                                  ,ngram
                                  ,frequency
                            FROM   NGRAM(
                                           ON car_complaints.nhtsa_cmpl_with_category
                                           TEXT_COLUMN('cdescr')
                                           GRAMS(1)
                                           CASE_INSENSITIVE('true')
                                           ACCUMULATE('cmplid')
                                        )
                            WHERE TRIM(ngram) != '' 
                          )
                       PARTITION BY cmplid
                     ) 
                AS tf 
                PARTITION BY ngram
                ON (
                     SELECT COUNT(*)
                     FROM   car_complaints.nhtsa_cmpl_with_category
                   ) 
               AS doccount DIMENSION
             ) tfidf
INNER JOIN car_complaints.nhtsa_cmpl_with_category t
ON tfidf.cmplid = t.cmplid;

---------------------------------------------------------------------------------
-- Check the nhtsa_cmpl_tfidf distinct tokens and total rows
---------------------------------------------------------------------------------
SELECT COUNT(*) FROM car_complaints.nhtsa_cmpl_tfidf;
SELECT COUNT(DISTINCT token) FROM car_complaints.nhtsa_cmpl_tfidf;
SELECT * FROM car_complaints.nhtsa_cmpl_tfidf limit 100;
