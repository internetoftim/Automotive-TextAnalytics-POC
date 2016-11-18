-------------------------------------------------------------------------------
-- Script       : 300_create_db_objects.sql
-- Purpose      : Create DB Objects for Data Exploration
--                
-- Author(s)    : Tim Santos
-- History      : 20151203 - Tim Santos - Initial Version
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- @description	: Create DB Objects for Unigram
-- @column      : cmplid - complain ID
-- @column		: ngram - unigram token
-- @column		: frequency - no. of appearance in the sentence 
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_cmpl_1gram;
CREATE FACT TABLE car_complaints.nhtsa_cmpl_1gram 
(
  cmplid VARCHAR(9)
 ,ngram VARCHAR
 ,n INTEGER
 ,frequency INTEGER
)
DISTRIBUTE BY HASH (cmplid);

-------------------------------------------------------------------------------
-- @description	: Create DB Objects for Bigram
-- @column      : cmplid - complain ID
-- @column		: ngram - unigram token
-- @column		: frequency - no. of appearance in the sentence 
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_cmpl_2gram;
CREATE FACT TABLE car_complaints.nhtsa_cmpl_2gram 
(
  cmplid VARCHAR(9)
 ,ngram VARCHAR
 ,n INTEGER
 ,frequency INTEGER
)
DISTRIBUTE BY HASH (cmplid);
  