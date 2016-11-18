-------------------------------------------------------------------------------
-- Script       : 412_train_models_svm_unigram.sql
-- Purpose      : Train SVM classifier model for unigram tokens.
--                
-- Author(s)    : Tim Santos
-- History      : 20151203 – Tim Santos – Initial Version
--
-------------------------------------------------------------------------------   

---------------------------------------------------------------------------------
-- Model to be created by the SPARSESVMTRAINER function for unigram SVM
-- Make sure to drop the table before running the SQL-MR function
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_1gram_svm_model;

-------------------------------------------------------------------------------
-- Train SVM classifier model 
-- @input		: car_complaints.nhtsa_train_1gram_tfidf
-- @output		: car_complaints.nhtsa_1gram_svm_model	
-- @param		: MAXSTEP (1000) - increased the max iteration for convergence
-- @param		: VALUECOLUMN ('tf_idf') - use tfidf for prediction
-- @param		: LABELCOLUMN ('compdesc_category') - use compdesc_category
-- TODO         : Check output message for convergence.
-------------------------------------------------------------------------------   
SELECT *
FROM   SPARSESVMTRAINER(
                         ON (SELECT 1)
                         PARTITION BY 1
                         INPUTTABLE('car_complaints.nhtsa_train_1gram_tfidf')
                         MODELTABLE('car_complaints.nhtsa_1gram_svm_model')
                         SAMPLEIDCOLUMN('cmplid')
                         ATTRIBUTECOLUMN('token')
                         VALUECOLUMN('tf_idf')
                         LABELCOLUMN('compdesc_category')
                         COST(1)
                         MAXSTEP(1000)
                       );
                       