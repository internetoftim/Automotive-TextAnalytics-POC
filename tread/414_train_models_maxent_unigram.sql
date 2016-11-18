-------------------------------------------------------------------------------
-- Script       : 414_train_models_maxent_unigram.sql
-- Purpose      : Train MaxEnt Classifier
--                
-- Author(s)    : Tim Santos
-- History      : 20151203 – Tim Santos – Initial Version
--
---------------------------------------------------------------------------------


---------------------------------------------------------------------------------
-- Model created by the TEXTCLASSIFIER function for MaxEnt
-- Make sure to drop the table before running the SQL-MR function
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_me_model;


---------------------------------------------------------------------------------
-- Train MaxEnt Classifier
-- @input		: car_complaints.nhtsa_train
-- @output		: car_complaints/nhtsa_1gram_maxent_model_fs.bin
-- @param		: TEXTCOLUMN('cdescr') - cdescr as the text input
-- @param		: compdesc_category ('compdesc_category') - use compdesc_category
--				  as the ground truth
---------------------------------------------------------------------------------
SELECT *
FROM TextClassifierTrainer(
                            ON (SELECT 1) PARTITION BY 1
                            INPUTTABLE('car_complaints.nhtsa_train')
                            TEXTCOLUMN('cdescr')
                            CATEGORYCOLUMN('compdesc_category')
                            MODELFILE('car_complaints.nhtsa_me_model')
                            CLASSIFIERTYPE('MaxEnt')
);
