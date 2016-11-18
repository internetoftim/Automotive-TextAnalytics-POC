-------------------------------------------------------------------------------
-- Script       : 426_perform_feature_selection_bigram_idf.sql
-- Purpose      : Perform Feature Selection of Unigram TFIDF based on IDF 
--				  values. 
--
-- Author(s)    : Tim Santos
-- History      : 20151203 – Tim Santos – Initial Version
--
-------------------------------------------------------------------------------      

-------------------------------------------------------------------------------
-- Extract bigram tfidf for training set with feature selection.
-- Depending on the data, perform multiple experiments with Feature Selection. 
-- Choose the size of retained feature space based on the following tradeoff:
--  *accuracy -- smaller feature space penalizes accuracy
--  *training/prediction runtime - smaller feature space improves runtime
--  *feature selection may have to be done to overcome aster's memory constraints
-- @param		: idf < n - where n is the experimental upper bound
--              : idf > m - where m is the experimental lower bound
-- TODO			: Confirm and Optimize TFIDF recomputation
--------------------------------------------------------------------------------- 
INSERT INTO car_complaints.nhtsa_train_2gram_tfidf_fs
SELECT * 
FROM car_complaints.nhtsa_train_2gram_tfidf  
--experiment on the upper and lower bounds by checking acceptable model performance
WHERE idf < 7 AND idf > LN(1/.2);

-------------------------------------------------------------------------------
-- Extract bigram tfidf for testing set with feature selection.
-- TFIDF is recomputed since removing tokens would cause TFIDF
-- to change values
-- @input		: nhtsa_train_2gram_tfidf_fs
-- @input		: nhtsa_test
-- @output		: nhtsa_test_2gram_tfidf_fs
-- @param		: IDF FROM car_complaints.nhtsa_2gram_tfidf_fs - TFIDF is recomputed 
--				  with IDF coming from the recomputed Training 
--				  Data with Feature Selection
---------------------------------------------------------------------------------  
INSERT INTO car_complaints.nhtsa_test_2gram_tfidf_fs
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
                    FROM car_complaints.nhtsa_train_2gram_tfidf_fs
                  ) 
               AS idf PARTITION BY term
             ) tfidf
INNER JOIN car_complaints.nhtsa_test t
ON tfidf.cmplid = t.cmplid;