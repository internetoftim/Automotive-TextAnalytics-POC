---------------------------------------------------------------------------------
-- Script       : 400_create_db_objects.sql
-- Purpose      : Create the tables for Modelling.
--                
-- Author(s)    : Tim Santos
-- History      : 20151203 – Tim Santos – Initial Version
---------------------------------------------------------------------------------    

---------------------------------------------------------------------------------    
-- @description	: Training data subset index lookup
-- @column      : cmplid - complain id
-- @column		: stratum - TREAD bucket, to be used for distribution sampling
---------------------------------------------------------------------------------    
DROP TABLE IF EXISTS car_complaints.nhtsa_train_id;

CREATE DIMENSION TABLE car_complaints.nhtsa_train_id 
(
  cmplid VARCHAR
 ,stratum  VARCHAR
);

---------------------------------------------------------------------------------    
-- @description	: Training data subset
-- @column[1-39]: same as car_complaints.nhtsa_cmpl_with_category
-- @column		: compdesc_category - TREAD ground truth
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_train;

CREATE FACT TABLE car_complaints.nhtsa_train 
(
  cmplid VARCHAR(9)
 ,odino VARCHAR(9)
 ,mfr_name VARCHAR(40)
 ,maketxt VARCHAR(25)
 ,modeltxt VARCHAR(256)
 ,yeartxt VARCHAR(4)
 ,crash VARCHAR(1)
 ,faildate VARCHAR(8)
 ,fire VARCHAR(1)
 ,injured VARCHAR(2)
 ,deaths VARCHAR(2)
 ,compdesc VARCHAR(128)
 ,city VARCHAR(30)
 ,state VARCHAR(2)
 ,vin VARCHAR(11)
 ,datea VARCHAR(8)
 ,ldate VARCHAR(8)
 ,miles VARCHAR(7)
 ,occurences VARCHAR(4)
 ,cdescr VARCHAR(2048)
 ,cmpl_type VARCHAR(4)
 ,police_rpt_yn VARCHAR(1)
 ,purch_dt VARCHAR(8)
 ,orig_owner_yn VARCHAR(1)
 ,anti_brakes_yn VARCHAR(1)
 ,cruise_cont_yn VARCHAR(1)
 ,num_cyls VARCHAR(2)
 ,drive_train VARCHAR(4)
 ,fuel_sys VARCHAR(4)
 ,fuel_type VARCHAR(4)
 ,trans_type VARCHAR(4)
 ,veh_speed VARCHAR(3)
 ,dot VARCHAR(20)
 ,tire_size VARCHAR(30)
 ,loc_of_tire VARCHAR(4)
 ,tire_fail_type VARCHAR(4)
 ,orig_equip_yn VARCHAR(1)
 ,manuf_dt VARCHAR(8)
 ,seat_type VARCHAR(4)
 ,restraint_type VARCHAR(4)
 ,dealer_name VARCHAR(40)
 ,dealer_tel VARCHAR(20)
 ,dealer_city VARCHAR(30)
 ,dealer_state VARCHAR(2)
 ,dealer_zip VARCHAR(10)
 ,prod_type VARCHAR(4)
 ,repaired_yn VARCHAR(1)
 ,medical_attn VARCHAR(1)
 ,vehicles_towed_yn VARCHAR(1)
 ,compdesc_category VARCHAR(128)
) 
DISTRIBUTE BY HASH (cmplid);

---------------------------------------------------------------------------------    
-- @description	: Test data subset index lookup
-- @column      : cmplid - complain id
-- @column		: stratum - TREAD bucket, to be used for distribution sampling
--------------------------------------------------------------------------------- 
DROP TABLE IF EXISTS car_complaints.nhtsa_test_id;

CREATE DIMENSION TABLE car_complaints.nhtsa_test_id 
(
  cmplid VARCHAR
 ,stratum  VARCHAR
);

---------------------------------------------------------------------------------
-- @description	: Test data subset
-- @column[1-39]: same as car_complaints.nhtsa_cmpl_with_category
-- @column		: compdesc_category - TREAD ground truth
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_test;

CREATE FACT TABLE car_complaints.nhtsa_test 
(
  cmplid VARCHAR(9)
 ,odino VARCHAR(9)
 ,mfr_name VARCHAR(40)
 ,maketxt VARCHAR(25)
 ,modeltxt VARCHAR(256)
 ,yeartxt VARCHAR(4)
 ,crash VARCHAR(1)
 ,faildate VARCHAR(8)
 ,fire VARCHAR(1)
 ,injured VARCHAR(2)
 ,deaths VARCHAR(2)
 ,compdesc VARCHAR(128)
 ,city VARCHAR(30)
 ,state VARCHAR(2)
 ,vin VARCHAR(11)
 ,datea VARCHAR(8)
 ,ldate VARCHAR(8)
 ,miles VARCHAR(7)
 ,occurences VARCHAR(4)
 ,cdescr VARCHAR(2048)
 ,cmpl_type VARCHAR(4)
 ,police_rpt_yn VARCHAR(1)
 ,purch_dt VARCHAR(8)
 ,orig_owner_yn VARCHAR(1)
 ,anti_brakes_yn VARCHAR(1)
 ,cruise_cont_yn VARCHAR(1)
 ,num_cyls VARCHAR(2)
 ,drive_train VARCHAR(4)
 ,fuel_sys VARCHAR(4)
 ,fuel_type VARCHAR(4)
 ,trans_type VARCHAR(4)
 ,veh_speed VARCHAR(3)
 ,dot VARCHAR(20)
 ,tire_size VARCHAR(30)
 ,loc_of_tire VARCHAR(4)
 ,tire_fail_type VARCHAR(4)
 ,orig_equip_yn VARCHAR(1)
 ,manuf_dt VARCHAR(8)
 ,seat_type VARCHAR(4)
 ,restraint_type VARCHAR(4)
 ,dealer_name VARCHAR(40)
 ,dealer_tel VARCHAR(20)
 ,dealer_city VARCHAR(30)
 ,dealer_state VARCHAR(2)
 ,dealer_zip VARCHAR(10)
 ,prod_type VARCHAR(4)
 ,repaired_yn VARCHAR(1)
 ,medical_attn VARCHAR(1)
 ,vehicles_towed_yn VARCHAR(1)
 ,compdesc_category VARCHAR(128)
) 
DISTRIBUTE BY HASH (cmplid);

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
DROP TABLE IF EXISTS car_complaints.nhtsa_train_1gram_tfidf;

CREATE FACT TABLE car_complaints.nhtsa_train_1gram_tfidf 
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
-- @description	: Test data subset containing tfidf features 
--                for unigram tokens
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - unigram token
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_test_1gram_tfidf;

CREATE FACT TABLE car_complaints.nhtsa_test_1gram_tfidf 
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
-- @description	: Training data subset containing tfidf features 
--                for unigram tokens after feature selection is performed
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - unigram token
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_train_1gram_tfidf_fs;  

CREATE FACT TABLE car_complaints.nhtsa_train_1gram_tfidf_fs 
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
-- @description	: Test data subset containing tfidf features 
--                for unigram tokens after feature selection is performed
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - unigram token
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_test_1gram_tfidf_fs;            

CREATE FACT TABLE car_complaints.nhtsa_test_1gram_tfidf_fs 
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
-- @description	: The entire data containing tfidf features 
--                for unigram tokens after feature selection is performed
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - unigram token
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_cmpl_1gram_tfidf_fs;  

CREATE FACT TABLE car_complaints.nhtsa_cmpl_1gram_tfidf_fs 
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
-- @description	: Entire data  containing tfidf features 
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - unigram token
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_cmpl_tfidf;            

CREATE FACT TABLE car_complaints.nhtsa_cmpl_tfidf 
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
-- @description	: Test Data labelled using MaxEnt Model
--              : Table is generated by TEXTCLASSIFIER SQL-MR
-- @column		: 'compdesc_category' - ground truth
-- @column		: 'predict_value' - SVM prediction
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_1gram_maxent_output;
CREATE FACT TABLE car_complaints.nhtsa_1gram_maxent_output 
(
  cmplid VARCHAR
 ,cdescr VARCHAR
 ,compdesc_category VARCHAR
 ,out_category VARCHAR
) 
DISTRIBUTE BY HASH(cmplid);

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
DROP TABLE IF EXISTS car_complaints.nhtsa_train_2gram_tfidf;

CREATE FACT TABLE car_complaints.nhtsa_train_2gram_tfidf 
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
-- @description	: Test data subset containing tfidf features 
--                for bigram tokens
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - bigram token
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_test_2gram_tfidf;

CREATE FACT TABLE car_complaints.nhtsa_test_2gram_tfidf 
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
-- @description	: Training data subset containing tfidf features 
--                for bigram tokens after feature selection is performed
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - bigram token
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_train_2gram_tfidf_fs;  

CREATE FACT TABLE car_complaints.nhtsa_train_2gram_tfidf_fs 
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
-- @description	: Test data subset containing tfidf features 
--                for bigram tokens after feature selection is performed
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - bigram token
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_test_2gram_tfidf_fs;            

CREATE FACT TABLE car_complaints.nhtsa_test_2gram_tfidf_fs 
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
DROP TABLE IF EXISTS car_complaints.nhtsa_cmpl_pos;            

CREATE DIMENSION TABLE car_complaints.nhtsa_cmpl_pos 
(

 cmplid VARCHAR
 ,odino VARCHAR
 ,compdesc_category VARCHAR
 ,compdesc VARCHAR
 ,word_sn VARCHAR
 ,word VARCHAR
 ,pos_tag VARCHAR
);

---------------------------------------------------------------------------------
-- @description	: Entire data with tfidf features for unigram with POS tag.
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - Unigram token and the POS tag concatenation. 
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_cmpl_pos_tfidf;

CREATE FACT TABLE car_complaints.nhtsa_cmpl_pos_tfidf 
(
  tf DOUBLE
 ,idf DOUBLE
 ,tf_idf DOUBLE
 ,cmplid VARCHAR
 ,compdesc_category VARCHAR
 ,term VARCHAR
) 
DISTRIBUTE BY HASH(cmplid);


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
DROP TABLE IF EXISTS car_complaints.nhtsa_train_pos;            

CREATE DIMENSION TABLE car_complaints.nhtsa_train_pos 
(
  cmplid VARCHAR
 ,odino VARCHAR
 ,word VARCHAR
 ,pos_tag VARCHAR
 ,pos_tag_comp VARCHAR
 ,compdesc_category VARCHAR
);

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
DROP TABLE IF EXISTS car_complaints.nhtsa_test_pos;            

CREATE DIMENSION TABLE car_complaints.nhtsa_test_pos 
(
  cmplid VARCHAR
 ,odino VARCHAR
 ,word VARCHAR
 ,pos_tag VARCHAR
 ,pos_tag_comp VARCHAR
 ,compdesc_category VARCHAR
);

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
DROP TABLE IF EXISTS car_complaints.nhtsa_train_pos_tfidf;

CREATE FACT TABLE car_complaints.nhtsa_train_pos_tfidf 
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
-- @description	: Test data subset containing tfidf features 
--                for unigram with POS tag.
-- @column      : tf - term frequency
-- @column      : idf - inverse document frequency
-- @column      : tf_idf - intended feature we use for classification/prediction
-- @column      : cmplid - complain id
-- @column		: compdesc_category - TREAD ground truth
-- @column		: token - Unigram token and the POS tag concatenation. 
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_test_pos_tfidf;

CREATE FACT TABLE car_complaints.nhtsa_test_pos_tfidf 
(
  tf DOUBLE
 ,idf DOUBLE
 ,tf_idf DOUBLE
 ,cmplid VARCHAR
 ,compdesc_category VARCHAR
 ,token VARCHAR
) 
DISTRIBUTE BY HASH(cmplid);


