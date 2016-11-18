---------------------------------------------------------------------------------
-- Script       : 490_backup_db_objects.sql
-- Purpose      : Backup the tables for Modelling.
--                
-- Author(s)    : Tim Santos
-- History      : 20151229 – Tim Santos – Initial Version
---------------------------------------------------------------------------------    

---------------------------------------------------------------------------------    
-- @description	: Training data subset index lookup
-- @column      : cmplid - complain id
-- @column		: stratum - TREAD bucket, to be used for distribution sampling
---------------------------------------------------------------------------------    
\o car_complaints.nhtsa_train_id
COPY car_complaints.nhtsa_train_id TO STDOUT WITH DELIMITER '|';
\o

---------------------------------------------------------------------------------    
-- @description	: Training data subset
-- @column[1-39]: same as car_complaints.nhtsa_cmpl_with_category
-- @column		: compdesc_category - TREAD ground truth
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_train
COPY car_complaints.nhtsa_train TO STDOUT WITH DELIMITER '|';
\o

---------------------------------------------------------------------------------    
-- @description	: Test data subset index lookup
-- @column      : cmplid - complain id
-- @column		: stratum - TREAD bucket, to be used for distribution sampling
--------------------------------------------------------------------------------- 
\o car_complaints.nhtsa_test_id
COPY car_complaints.nhtsa_test_id TO STDOUT WITH DELIMITER '|';
\o
---------------------------------------------------------------------------------
-- @description	: Test data subset
-- @column[1-39]: same as car_complaints.nhtsa_cmpl_with_category
-- @column		: compdesc_category - TREAD ground truth
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_test
COPY car_complaints.nhtsa_test TO STDOUT WITH DELIMITER '|';
\o

---------------------------------------------------------------------------------
-- @description	: Training data subset containing tfidf features 
--                for unigram tokens
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - unigram token
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_train_1gram_tfidf
COPY car_complaints.nhtsa_train_1gram_tfidf TO STDOUT WITH DELIMITER '|';
\o

---------------------------------------------------------------------------------
-- @description	: Test data subset containing tfidf features 
--                for unigram tokens
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - unigram token
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_test_1gram_tfidf
COPY car_complaints.nhtsa_test_1gram_tfidf TO STDOUT WITH DELIMITER '|';
\o

---------------------------------------------------------------------------------
-- @description	: Training data subset containing tfidf features 
--                for unigram tokens after feature selection is performed
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - unigram token
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_train_1gram_tfidf_fs
COPY car_complaints.nhtsa_train_1gram_tfidf_fs TO STDOUT WITH DELIMITER '|';
\o

---------------------------------------------------------------------------------
-- @description	: Test data subset containing tfidf features 
--                for unigram tokens after feature selection is performed
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - unigram token
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_test_1gram_tfidf_fs
COPY car_complaints.nhtsa_test_1gram_tfidf_fs TO STDOUT WITH DELIMITER '|';
\o


---------------------------------------------------------------------------------
-- @description	: The entire data containing tfidf features 
--                for unigram tokens after feature selection is performed
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - unigram token
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_cmpl_1gram_tfidf_fs
COPY car_complaints.nhtsa_cmpl_1gram_tfidf_fs TO STDOUT WITH DELIMITER '|';
\o

---------------------------------------------------------------------------------
-- @description	: Entire data  containing tfidf features 
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - unigram token
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_cmpl_tfidf
COPY car_complaints.nhtsa_cmpl_tfidf TO STDOUT WITH DELIMITER '|';
\o

---------------------------------------------------------------------------------
-- @description	: Test Data labelled using MaxEnt Model
--              : Table is generated by TEXTCLASSIFIER SQL-MR
-- @column		: 'compdesc_category' - ground truth
-- @column		: 'predict_value' - SVM prediction
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_1gram_maxent_output
COPY car_complaints.nhtsa_1gram_maxent_output TO STDOUT WITH DELIMITER '|';
\o

---------------------------------------------------------------------------------
-- @description	: Training data subset containing tfidf features 
--                for bigram tokens
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - bigram token
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_train_2gram_tfidf
COPY car_complaints.nhtsa_train_2gram_tfidf TO STDOUT WITH DELIMITER '|';
\o
---------------------------------------------------------------------------------
-- @description	: Test data subset containing tfidf features 
--                for bigram tokens
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - bigram token
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_test_2gram_tfidf
COPY car_complaints.nhtsa_test_2gram_tfidf TO STDOUT WITH DELIMITER '|';
\o
---------------------------------------------------------------------------------
-- @description	: Training data subset containing tfidf features 
--                for bigram tokens after feature selection is performed
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - bigram token
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_train_2gram_tfidf_fs
COPY car_complaints.nhtsa_train_2gram_tfidf_fs TO STDOUT WITH DELIMITER '|';
\o

---------------------------------------------------------------------------------
-- @description	: Test data subset containing tfidf features 
--                for bigram tokens after feature selection is performed
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - bigram token
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_test_2gram_tfidf_fs
COPY car_complaints.nhtsa_test_2gram_tfidf_fs TO STDOUT WITH DELIMITER '|';
\o

---------------------------------------------------------------------------------
-- @description	: POS tag for each unigram token.  
-- @column      : word_sn - The serial number of the word. Denotes the order of
--                          the word in the input text
-- @column      : word - The extracted word.
-- @column      : pos_tag - The PoS tag of the word.
-- @column      : cmplid - complain id
-- @column      : odino - Unique complain ID
-- @column		: compdesc_category - TREAD ground truth
-- @column		: compdesc - long-form complain category
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_cmpl_pos
COPY car_complaints.nhtsa_cmpl_pos TO STDOUT WITH DELIMITER '|';
\o

---------------------------------------------------------------------------------
-- @description	: Entire data with tfidf features for unigram with POS tag.
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - Unigram token and the POS tag concatenation. 
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_cmpl_pos_tfidf
COPY car_complaints.nhtsa_cmpl_pos_tfidf TO STDOUT WITH DELIMITER '|';
\o


---------------------------------------------------------------------------------
-- @description	: POS tagged tokens for training subset.  
-- @column      : word_sn - The serial number of the word. Denotes the order of
--                          the word in the input text
-- @column      : word - The extracted word.
-- @column      : pos_tag - The PoS tag of the word.
-- @column      : cmplid - complain id
-- @column      : odino - Unique complain ID
-- @column		: compdesc_category - TREAD ground truth
-- @column		: compdesc - long-form complain category
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_train_pos
COPY car_complaints.nhtsa_train_pos TO STDOUT WITH DELIMITER '|';
\o


---------------------------------------------------------------------------------
-- @description	: POS tagged token for test subset.  
-- @column      : word_sn - The serial number of the word. Denotes the order of
--                          the word in the input text
-- @column      : word - The extracted word.
-- @column      : pos_tag - The PoS tag of the word.
-- @column      : cmplid - complain id
-- @column      : odino - Unique complain ID
-- @column		: compdesc_category - TREAD ground truth
-- @column		: compdesc - long-form complain category
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_test_pos
COPY car_complaints.nhtsa_test_pos TO STDOUT WITH DELIMITER '|';
\o

---------------------------------------------------------------------------------
-- @description	: Training data subset containing tfidf features 
--                for unigram with POS tag.
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - Unigram token and the POS tag concatenation. 
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_train_pos_tfidf
COPY car_complaints.nhtsa_train_pos_tfidf TO STDOUT WITH DELIMITER '|';
\o

---------------------------------------------------------------------------------
-- @description	: Test data subset containing tfidf features 
--                for unigram with POS tag.
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - Unigram token and the POS tag concatenation. 
---------------------------------------------------------------------------------
DISTRIBUTE BY HASH(cmplid);
\o car_complaints.nhtsa_test_pos_tfidf
COPY car_complaints.nhtsa_test_pos_tfidf TO STDOUT WITH DELIMITER '|';
\o

---------------------------------------------------------------------------------
-- Model to be created by the SPARSESVMTRAINER function for unigram SVM
-- Make sure to drop the table before running the SQL-MR function
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_1gram_svm_model
COPY car_complaints.nhtsa_1gram_svm_model TO STDOUT WITH DELIMITER '|';
\o

---------------------------------------------------------------------------------
-- Model created by the TEXTCLASSIFIER function for MaxEnt
-- Make sure to drop the table before running the SQL-MR function
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_me_model
COPY car_complaints.nhtsa_me_model TO STDOUT WITH DELIMITER '|';
\o


---------------------------------------------------------------------------------
-- Model created by the SPARSESVMTRAINER function for unigram SVM
-- with Feature Selection
-- Make sure to drop the table before running the SQL-MR function
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_1gram_fs_svm_model
COPY car_complaints.nhtsa_1gram_fs_svm_model TO STDOUT WITH DELIMITER '|';
\o


---------------------------------------------------------------------------------
-- Model created by the SPARSESVMTRAINER function for bigram SVM
-- Make sure to drop the table before running the SQL-MR function
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_2gram_svm_model
COPY car_complaints.nhtsa_2gram_svm_model TO STDOUT WITH DELIMITER '|';
\o

---------------------------------------------------------------------------------
-- Model created by the SPARSESVMTRAINER function for bigram SVM 
-- with Feature Selection
-- Make sure to drop the table before running the SQL-MR function
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_2gram_fs_svm_model
COPY car_complaints.nhtsa_2gram_fs_svm_model TO STDOUT WITH DELIMITER '|';
\o

---------------------------------------------------------------------------------
-- Model created by the SPARSESVMTRAINER function for unigram-POSR SVM
-- Make sure to drop the table before running the SQL-MR function
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_pos_svm_model
COPY car_complaints.nhtsa_pos_svm_model TO STDOUT WITH DELIMITER '|';
\o

