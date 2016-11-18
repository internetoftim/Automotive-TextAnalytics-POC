-------------------------------------------------------------------------------
-- Script       : 428_evaluate_models_bigram_svm_fs.sql
-- Purpose      : Predict the TREAD category of test data using the SVM model
--				  with Feature Selection
--                
-- Author(s)    : Tim Santos
-- History      : 20151203 – Tim Santos – Initial Version
-------------------------------------------------------------------------------   

---------------------------------------------------------------------------------
-- Test Data labeled using Bigram SVM Model with Feature Selection
-- Table is generated by SPARSESVMPREDICTOR SQL-MR
-- Make sure to drop the table before running the SQL-MR function
-- @column		: 'compdesc_category' - ground truth
-- @column		: 'predict_value' - SVM prediction
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_2gram_fs_svm_output;

-------------------------------------------------------------------------------
-- Train SVM classifier model 
--  *accuracy -- smaller feature space penalizes accuracy
--  *training/prediction runtime - smaller feature space improves runtime
-- @input		: complaints.nhtsa_test_2gram_tfidf_fs
-- @input		: complaints.nhtsa_2gram_fs_svm_model
-- @output		: complaints.nhtsa_2gram_fs_svm_output
-- @param		: VALUECOLUMN ('tf_idf') - use tfidf for prediction
-- @param		: ACCUMULATELABEL ('compdesc_category') - include the 
--				  ground truth in the output, for evaluation purposes
-------------------------------------------------------------------------------   
SELECT *
FROM   SPARSESVMPREDICTOR(
                           ON (SELECT 1)
                           PARTITION BY 1
                           INPUTTABLE('car_complaints.nhtsa_test_2gram_tfidf_fs')
                           MODELTABLE('car_complaints.nhtsa_2gram_fs_svm_model')
                           OUTPUTTABLE('car_complaints.nhtsa_2gram_fs_svm_output')
                           SAMPLEIDCOLUMN('cmplid')
                           ATTRIBUTECOLUMN('token')
                           VALUECOLUMN('tf_idf')
                           ACCUMULATELABEL('compdesc_category')
                         );  

---------------------------------------------------------------------------------
-- Confusion matrix evaluation of Bigram SVM Model with Feature Selection
-- Table is generated by CONFUSIONMATRIXPLOT SQL-MR function
-- Make sure to drop the table before running the SQL-MR function
-- @column[2-10]: TREAD categories
-- @column      : miss
-- @column 		: recall
-- @row 		: false_alarm
-- @row 		: precision
-- @row 		: f-measure 1.0
-- @row 		: accuracy
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_2gram_fs_svm_metrics;

-------------------------------------------------------------------------------
-- Create confusion matrix to evaluate SVM prediction
-- @input		: complaints.nhtsa_test
-- @input		: complaints.nhtsa_2gram_fs_svm_output
-- @output		: complaints.nhtsa_2gram_fs_svm_metrics
-- @param		: EXPECTCOLUMN ('compdesc_category') - ground truth
-- @param		: PREDICTCOLUMN ('predict_value') - SVM prediction
-------------------------------------------------------------------------------   
SELECT *
FROM   CONFUSIONMATRIXPLOT(
                            ON (
                                 SELECT *
                                 FROM CONFUSIONMATRIX(
                                                       ON (
                                                            SELECT     tw.cmplid
                                                                      ,tw.cdescr
                                                                      ,tw.compdesc_category
                                                                      ,predict_value
                                                            FROM       car_complaints.nhtsa_test  tw
                                                            INNER JOIN car_complaints.nhtsa_2gram_fs_svm_output 
                                                                       classify 
                                                            ON         classify.cmplid = tw.cmplid
                                                          )
                                                       PARTITION BY compdesc_category
                                                       EXPECTCOLUMN('compdesc_category')
                                                       PREDICTCOLUMN('predict_value')
                                                     )
                               )
                            PARTITION BY 1
                            OUTPUTTABLE('car_complaints.nhtsa_2gram_fs_svm_metrics')
                            BETA(1.0)
                          );
                          
-------------------------------------------------------------------------------
-- Display the evaluation criteria for this model
-- @input		: car_complaints.nhtsa_2gram_fs_svm_metrics
-- @output		: accuracy
-- @output		: precision
-- @output		: recall
-- @output 		: f-measure
-------------------------------------------------------------------------------                           
SELECT * FROM car_complaints.nhtsa_2gram_fs_svm_metrics;       
