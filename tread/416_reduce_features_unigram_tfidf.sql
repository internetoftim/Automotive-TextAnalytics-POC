-------------------------------------------------------------------------------
-- Script       : 416_reduce_features_unigram_tfidf.sql
-- Purpose      : Perform Feature Selection of Unigram TFIDF based on IDF 
--				  values. 
--
-- Author(s)    : Tim Santos
-- History      : 20151203 – Tim Santos – Initial Version
--
-------------------------------------------------------------------------------      

-------------------------------------------------------------------------------
-- Extract unigram tfidf for training set with feature selection.
-- Depending on the data, perform multiple experiments with Feature Selection. 
-- Choose the  size of retained feature space based on the following tradeoff:
--  *accuracy -- smaller feature space penalizes accuracy
--  *training/prediction runtime - smaller feature space improves runtime
--  *feature selection may have to be done to overcome aster's memory constraints
-- @param		: idf < n - where n is the experimental upper bound
--              : idf > m - where m is the experimental lower bound
-- TODO			: Confirm and Optimize TFIDF recomputation
--------------------------------------------------------------------------------- 
INSERT INTO car_complaints.nhtsa_train_1gram_tfidf_fs
SELECT * 
FROM car_complaints.nhtsa_train_1gram_tfidf  
--experiment on the upper and lower bounds by checking acceptable model performance
WHERE idf < 7 AND idf > LN(1/.2);

-------------------------------------------------------------------------------
-- Inspect TFIDF with FS
-------------------------------------------------------------------------------
SELECT * FROM car_complaints.nhtsa_train_1gram_tfidf_fs LIMIT 10;

-------------------------------------------------------------------------------
-- Extract unigram tfidf for testing set with feature selection.
-- TFIDF is recomputed since removing tokens would cause TFIDF
-- to change values
-- @input		: 
-- @output		: 
-- @param		: IDF FROM car_complaints.nhtsa_1gram_tfidf_fs - TFIDF is recomputed 
--				  with IDF coming from the recomputed Training 
--				  Data with Feature Selection
-- TODO			: Confirm and Optimize TFIDF recomputation
---------------------------------------------------------------------------------  
INSERT INTO car_complaints.nhtsa_test_1gram_tfidf_fs
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
                    SELECT DISTINCT(TOKEN) AS term, idf 
                    FROM car_complaints.nhtsa_train_1gram_tfidf_fs
                  ) 
               AS idf PARTITION BY term
             ) tfidf
INNER JOIN car_complaints.nhtsa_test t
ON tfidf.cmplid = t.cmplid;


-------------------------------------------------------------------------------
-- Extract unigram tfidf for entire data set with feature selection.
-- Depending on the data, perform multiple experiments with Feature Selection. 
-- Choose the  size of retained feature space based on the following tradeoff:
--  *accuracy -- smaller feature space penalizes accuracy
--  *training/prediction runtime - smaller feature space improves runtime
--  *feature selection may have to be done to overcome aster's memory constraints
-- @param		: idf < n - where n is the experimental upper bound
--              : idf > m - where m is the experimental lower bound
-- TODO			: Confirm and Optimize TFIDF recomputation
--------------------------------------------------------------------------------- 
INSERT INTO car_complaints.nhtsa_cmpl_1gram_tfidf_fs
SELECT * 
FROM car_complaints.nhtsa_cmpl_tfidf  
--experiment on the upper and lower bounds by checking acceptable model performance
WHERE idf < 9 AND idf > LN(1/.2);

-------------------------------------------------------------------------------
-- Compare the reduced feature space with the original
-------------------------------------------------------------------------------
SELECT COUNT(DISTINCT token) FROM car_complaints.nhtsa_cmpl_1gram_tfidf_fs;
SELECT COUNT(DISTINCT token) FROM car_complaints.nhtsa_cmpl_tfidf;