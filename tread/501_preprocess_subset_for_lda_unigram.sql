-------------------------------------------------------------------------------
-- Script       : 501_preprocess_subset_for_lda_unigram.sql
-- Purpose      : Pre-process subset of data depending on TREAD buckets.              
-- Author(s)    : Tim Santos
-- History      : 20151203 – Tim Santos – Initial Version
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Prepares the data for topic modelling using LDA within a TREAD bucket.
-- This example uses the ENGINE TREAD bucket.
---------------------------------------------------------------------------------
INSERT INTO car_complaints.nhtsa_engine_1gram_tfidf
SELECT * 
FROM   car_complaints.nhtsa_cmpl_tfidf
WHERE  compdesc_category='ENGINE';

-------------------------------------------------------------------------------
-- Prepares the data for topic modelling using LDA within a TREAD bucket.
-- This example uses the BRAKES TREAD bucket.
---------------------------------------------------------------------------------
INSERT INTO car_complaints.nhtsa_brakes_1gram_tfidf
SELECT * 
FROM   car_complaints.nhtsa_cmpl_tfidf
WHERE  compdesc_category='BRAKES';
