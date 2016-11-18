-------------------------------------------------------------------------------
-- Script       : 390_backup_db_objects.sql
-- Purpose      : Backup DB Objects for Data Exploration
--                
-- Author(s)    : Tim Santos
-- History      : 20151229 - Tim Santos - Initial Version
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- @description	: Backup DB Objects for Unigram
-- @column      : cmplid - complain ID
-- @column		: ngram - unigram token
-- @column		: frequency - no. of appearance in the sentence 
-------------------------------------------------------------------------------
\o car_complaints.nhtsa_cmpl_1gram
COPY car_complaints.nhtsa_cmpl_1gram TO STDOUT WITH DELIMITER '|';
\o


-------------------------------------------------------------------------------
-- @description	: Backup DB Objects for Bigram
-- @column      : cmplid - complain ID
-- @column		: ngram - unigram token
-- @column		: frequency - no. of appearance in the sentence 
-------------------------------------------------------------------------------
\o car_complaints.nhtsa_cmpl_2gram
COPY car_complaints.nhtsa_cmpl_2gram TO STDOUT WITH DELIMITER '|';
\o
