-------------------------------------------------------------------------------
-- Script       : 500_create_db_objects_topic_model.sql
-- Purpose      : Create the tables for topic modelling
--                
-- Author(s)    : Tim Santos
-- History      : 20151203 – Tim Santos – Initial Version
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
DROP TABLE IF EXISTS car_complaints.nhtsa_engine_1gram_tfidf;  

CREATE FACT TABLE car_complaints.nhtsa_engine_1gram_tfidf 
(
  tf DOUBLE
 ,idf DOUBLE
 ,tf_idf DOUBLE
 ,cmplid VARCHAR
 ,compdesc_category VARCHAR
 ,token VARCHAR
) 
DISTRIBUTE BY HASH(cmplid);

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
DROP TABLE IF EXISTS car_complaints.nhtsa_brakes_1gram_tfidf;  

CREATE FACT TABLE car_complaints.nhtsa_brakes_1gram_tfidf 
(
  tf DOUBLE
 ,idf DOUBLE
 ,tf_idf DOUBLE
 ,cmplid VARCHAR
 ,compdesc_category VARCHAR
 ,token VARCHAR
) 
DISTRIBUTE BY HASH(cmplid);

-------------------------------------------------------------------------------
-- @description	: Create table for LDA model's top terms.
-- @column      : cmplid - complain ID
-- @column		: ngram - bigram token
-- @column		: frequency - no. of appearance in the sentence 
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_engine_1gram_lda9_top100_words;
CREATE DIMENSION TABLE car_complaints.nhtsa_engine_1gram_lda9_top100_words 
(
  topicid VARCHAR
 ,word VARCHAR
 ,wordweight DOUBLE
);

-------------------------------------------------------------------------------
-- @description	: Create table for LDA model's top terms.
-- @column      : cmplid - complain ID
-- @column		: ngram - bigram token
-- @column		: frequency - no. of appearance in the sentence 
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_brakes_1gram_lda9_top100_words;
CREATE DIMENSION TABLE car_complaints.nhtsa_brakes_1gram_lda9_top100_words 
(
  topicid VARCHAR
 ,wordsequence VARCHAR
);


-------------------------------------------------------------------------------
-- @description	: Create unigram table for ENGINE subset.
-- @column      : cmplid - complain ID
-- @column		: ngram - unigram token
-- @column		: frequency - no. of appearance in the sentence 
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_engine_1gram;
CREATE FACT TABLE car_complaints.nhtsa_engine_1gram 
(
  cmplid VARCHAR(9)
 ,ngram VARCHAR
 ,n INTEGER
 ,frequency INTEGER
)
DISTRIBUTE BY HASH (cmplid);

-------------------------------------------------------------------------------
-- @description	: Create unigram table for ENGINE subset with feature selection
-- @column      : cmplid - complain ID
-- @column		: ngram - unigram token
-- @column		: frequency - no. of appearance in the sentence 
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_engine_1gram_fs;
CREATE FACT TABLE car_complaints.nhtsa_engine_1gram_fs 
(
  cmplid VARCHAR(9)
 ,ngram VARCHAR
 ,n INTEGER
 ,frequency INTEGER
)
DISTRIBUTE BY HASH (cmplid);

-------------------------------------------------------------------------------
-- @description	: Create unigram table for BRAKES subset.
-- @column      : cmplid - complain ID
-- @column		: ngram - unigram token
-- @column		: frequency - no. of appearance in the sentence 
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_brakes_1gram;
CREATE FACT TABLE car_complaints.nhtsa_brakes_1gram 
(
  cmplid VARCHAR(9)
 ,ngram VARCHAR
 ,n INTEGER
 ,frequency INTEGER
)
DISTRIBUTE BY HASH (cmplid);

-------------------------------------------------------------------------------
-- @description	: Create bigram table for ENGINE subset.
-- @column      : cmplid - complain ID
-- @column		: ngram - bigram token
-- @column		: frequency - no. of appearance in the sentence 
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_engine_2gram;
CREATE FACT TABLE car_complaints.nhtsa_engine_2gram 
(
  cmplid VARCHAR(9)
 ,ngram VARCHAR
 ,n INTEGER
 ,frequency INTEGER
)
DISTRIBUTE BY HASH (cmplid);
