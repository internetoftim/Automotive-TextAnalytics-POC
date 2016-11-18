-------------------------------------------------------------------------------
-- Script       : 427_train_models_svm_bigram_tfidf_fs.sql
-- Purpose      : Train SVM classifier model for unigram tokens with 
--				  Feature Selection
--                
-- Author(s)    : Tim Santos
-- History      : 20151203 – Tim Santos – Initial Version
--
-------------------------------------------------------------------------------   

---------------------------------------------------------------------------------
-- Model created by the SPARSESVMTRAINER function for bigram SVM 
-- with Feature Selection
-- Make sure to drop the table before running the SQL-MR function
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_2gram_fs_svm_model;

-------------------------------------------------------------------------------
-- Train SVM classifier model with Feature Selection
-- @input		: car_complaints.nhtsa_train_2gram_tfidf_fs
-- @output		: car_complaints.nhtsa_2gram_fs_svm_model
-- @param		: MAXSTEP (1000) - increased the max iteration for convergence
-- @param		: VALUECOLUMN ('tf_idf') - use tfidf for prediction
-- @param		: LABELCOLUMN ('compdesc_category') - use compdesc_category
--				  as the ground truth
------------------------------------------------------------------------------- 
SELECT *
FROM   SPARSESVMTRAINER(
                         ON (SELECT 1)
                         PARTITION BY 1
                         INPUTTABLE('car_complaints.nhtsa_train_2gram_tfidf_fs')
                         MODELTABLE('car_complaints.nhtsa_2gram_fs_svm_model')
                         SAMPLEIDCOLUMN('cmplid')
                         ATTRIBUTECOLUMN('token')
                         VALUECOLUMN('tf_idf')
                         LABELCOLUMN('compdesc_category')
                         COST(1)
                         MAXSTEP(1000)
                       );
