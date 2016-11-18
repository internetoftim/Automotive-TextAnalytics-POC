-------------------------------------------------------------------------------
-- Script       : 421_extract_features_bigram_idf.sql
-- Purpose      : Perform Feature Extraction of Bigram TFIDF. 
-- Author(s)    : Tim Santos
-- History      : 20151203 – Tim Santos – Initial Version
-- TODO			: Implement NFOLD
-------------------------------------------------------------------------------       

-------------------------------------------------------------------------------
-- Extract bigram tfidf for training data 
-- IDF is computed from the training subset 
-- @input		: car_complaints.nhtsa_train
-- @output		: car_complaints.nhtsa_train_tfidf_2gram
-- @param		: ON ( ... car_complaints.nhtsa_train) AS doccount DIMENSION  
--				  IDF is computed from the training subset 
---------------------------------------------------------------------------------       
INSERT INTO car_complaints.nhtsa_train_2gram_tfidf 
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
                                          GRAMS(2)
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
-- @input		: car_complaints.nhtsa_train_tfidf_2gram AS IDF 
--				  TFIDF is computed based on the training SET idf as a priori
-- @output		: car_complaints.nhtsa_test_tfidf_2gram
---------------------------------------------------------------------------------  
INSERT INTO car_complaints.nhtsa_test_2gram_tfidf 
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
                                          GRAMS(2)
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
                    FROM car_complaints.nhtsa_train_2gram_tfidf
                  ) 
               AS idf PARTITION BY term
             ) tfidf
INNER JOIN car_complaints.nhtsa_test t
ON tfidf.cmplid = t.cmplid;
 
  
 
