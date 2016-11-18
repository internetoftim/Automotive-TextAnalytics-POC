-------------------------------------------------------------------------------
-- Script       : 590_backup_db_objects_topic_model.sql
-- Purpose      : Backup the tables for topic modelling
--                
-- Author(s)    : Tim Santos
-- History      : 20151229 – Tim Santos – Initial Version
--
-------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- @description	: The subset of ENGINE-labeled data containing tfidf features 
--                for unigram tokens. 
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - unigram token
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_engine_1gram_tfidf
COPY car_complaints.nhtsa_engine_1gram_tfidf TO STDOUT WITH DELIMITER '|';
\o

---------------------------------------------------------------------------------
-- @description	: The subset of BRAKES-labeled data containing tfidf features 
--                for unigram tokens. 
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - unigram token
---------------------------------------------------------------------------------
\o car_complaints.nhtsa_brakes_1gram_tfidf
COPY car_complaints.nhtsa_brakes_1gram_tfidf TO STDOUT WITH DELIMITER '|';
\o

-------------------------------------------------------------------------------
-- @description	: Backup table for LDA model's top terms.
-- @column      : cmplid - complain ID
-- @column		: ngram - bigram token
-- @column		: frequency - no. of appearance in the sentence 
-------------------------------------------------------------------------------
\o car_complaints.nhtsa_engine_1gram_lda9_top100_words
COPY car_complaints.nhtsa_engine_1gram_lda9_top100_words TO STDOUT WITH DELIMITER '|';
\o

-------------------------------------------------------------------------------
-- @description	: Backup table for LDA model's top terms.
-- @column      : cmplid - complain ID
-- @column		: ngram - bigram token
-- @column		: frequency - no. of appearance in the sentence 
-------------------------------------------------------------------------------
\o car_complaints.nhtsa_engine_1gram_lda9_top100_words
COPY car_complaints.nhtsa_engine_1gram_lda9_top100_words TO STDOUT WITH DELIMITER '|';
\o


-------------------------------------------------------------------------------
-- @description	: Backup unigram table for ENGINE subset.
-- @column      : cmplid - complain ID
-- @column		: ngram - unigram token
-- @column		: frequency - no. of appearance in the sentence 
-------------------------------------------------------------------------------
\o car_complaints.nhtsa_engine_1gram
COPY car_complaints.nhtsa_engine_1gram TO STDOUT WITH DELIMITER '|';
\o
-------------------------------------------------------------------------------
-- @description	: Backup unigram table for ENGINE subset with feature selection
-- @column      : cmplid - complain ID
-- @column		: ngram - unigram token
-- @column		: frequency - no. of appearance in the sentence 
-------------------------------------------------------------------------------
\o car_complaints.nhtsa_engine_1gram_fs
COPY car_complaints.nhtsa_engine_1gram_fs TO STDOUT WITH DELIMITER '|';
\o
-------------------------------------------------------------------------------
-- @description	: Backup unigram table for BRAKES subset.
-- @column      : cmplid - complain ID
-- @column		: ngram - unigram token
-- @column		: frequency - no. of appearance in the sentence 
-------------------------------------------------------------------------------
\o car_complaints.nhtsa_brakes_1gram
COPY car_complaints.nhtsa_brakes_1gram TO STDOUT WITH DELIMITER '|';
\o
-------------------------------------------------------------------------------
-- @description	: Backup bigram table for ENGINE subset.
-- @column      : cmplid - complain ID
-- @column		: ngram - bigram token
-- @column		: frequency - no. of appearance in the sentence 
-------------------------------------------------------------------------------
\o car_complaints.nhtsa_engine_2gram
COPY car_complaints.nhtsa_engine_2gram TO STDOUT WITH DELIMITER '|';
\o

\o car_complaints.nhtsa_brakes_1gram_lda7_model
COPY car_complaints.nhtsa_brakes_1gram_lda7_model TO STDOUT WITH DELIMITER '|';
\o

---------------------------------------------------------------------------------
-- Output table Backupd by the LDATrainer function for unigram tokens
-- Make sure to drop the table before running the SQL-MR function
---------------------------------------------------------------------------------

\o car_complaints.nhtsa_brakes_1gram_lda7_output
COPY car_complaints.nhtsa_brakes_1gram_lda7_output TO STDOUT WITH DELIMITER '|';
\o

---------------------------------------------------------------------------------
-- Output table Backupd by the CFilter function for bigram tokens
-- Make sure to drop the table before running the SQL-MR function
---------------------------------------------------------------------------------

\o car_complaints.nhtsa_engine_2gram_cfilter
COPY car_complaints.nhtsa_engine_2gram_cfilter TO STDOUT WITH DELIMITER '|';
\o