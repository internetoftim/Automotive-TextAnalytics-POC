-------------------------------------------------------------------------------
-- Script       : 461_extract_features_unigram_pos.sql
-- Purpose      : Perform Feature Extraction of Unigram tokens with POS-tag. 
--
-- Author(s)    : Tim Santos
-- History      : 20151203 – Tim Santos – Initial Version
-- TODO         : Implement NFOLD
-- 					add select count after feature extraction
-------------------------------------------------------------------------------       

-------------------------------------------------------------------------------
-- Generate the POS tag for each unigram token.      
-- @input       : car_complaints.nhtsa_cmpl_with_category
-- @output      : car_complaints.nhtsa_cmpl_pos
-- @param       : TEXTCOLUMN ('cdescr') text to be tagged
---------------------------------------------------------------------------------
INSERT INTO car_complaints.nhtsa_cmpl_pos
SELECT * FROM POSTAGGER(
                         ON (
                              SELECT cmplid
                                    ,odino
                                    ,LOWER(cdescr) AS cdescr
                                    ,compdesc
                                    ,compdesc_category 
                              FROM car_complaints.nhtsa_cmpl_with_category
                            )                              
                         ACCUMULATE(
                                     'cmplid'
                                    ,'odino'
                                    ,'compdesc_category'
                                    ,'compdesc'
                                   )
                         TEXTCOLUMN('cdescr')
                       );

-------------------------------------------------------------------------------
-- Extract tfidf of unigram-POS data of the entire data set
-- This creates different word-sense based on the POS. 
-- The script also sets the baseline for the IDF based 
-- on the entire data set should the need for those values arise.      
-- @input       : car_complaints.nhtsa_cmpl_with_category
-- @output      : car_complaints.nhtsa_cmpl_pos_tfidf
---------------------------------------------------------------------------------
INSERT INTO car_complaints.nhtsa_cmpl_pos_tfidf
SELECT tf
      ,idf
      ,tf_idf
      ,tfidf.cmplid
      ,compdesc_category
      ,term 
FROM TF_IDF(
             ON TF(
                    ON (
                         SELECT cmplid
                               ,ngram||'_'||tag AS term
                               ,COUNT(*)::INT AS count
                          FROM (
                                 SELECT * 
                                 FROM NGRAM(
                                             ON(
                                                 SELECT cmplid
                                                       ,word
                                                       ,tag_short AS tag 
                                                 FROM POSTAGGER (
                                                                  ON (
                                                                       SELECT cmplid
                                                                             ,LOWER(cdescr) AS cdescr 
                                                                       FROM car_complaints.nhtsa_cmpl_with_category 
                                                                     )
                                                                  ACCUMULATE('cmplid')
                                                                  TEXTCOLUMN('cdescr')
                                                                ) c
                                                     ,car_complaints.pos_tags p 
                                                 WHERE c.pos_tag = p.tag
                                               )
                                             TEXT_COLUMN('word')
                                             GRAMS(1)
                                             ACCUMULATE('cmplid', 'tag')
                                           )
                               ) AS a
                          WHERE     TRIM(ngram) != ''
                          GROUP BY  cmplid
                                   ,ngram||'_'||tag                                                                   
                       )
                    PARTITION BY cmplid
                  ) AS tf 
             PARTITION BY term
             ON (
                  SELECT COUNT(*)
                  FROM   car_complaints.nhtsa_cmpl_with_category
                ) AS     doccount DIMENSION
          ) tfidf
INNER JOIN car_complaints.nhtsa_cmpl_with_category t
ON tfidf.cmplid = t.cmplid;

-------------------------------------------------------------------------------
-- Create POS-tagged tokens for train set
--TODO - make sure nhtsa_cmpl_pos
--and nhtsa_train_pos has the same count
-- recheck twice insert---truncate
---------------------------------------------------------------------------------
INSERT INTO car_complaints.nhtsa_train_pos
SELECT t.cmplid AS cmplid
      ,t.odino AS odino
      ,s.word AS word
      ,p.tag_short AS pos_tag
      ,p.tag AS pos_tag_comp
      ,t.compdesc_category
FROM car_complaints.nhtsa_train t
    ,car_complaints.nhtsa_cmpl_pos s
    ,car_complaints.pos_tags p
WHERE t.cmplid = s.cmplid 
AND s.pos_tag = p.tag;

---------------------------------------------------------------------------------
-- Check train_pos if the total rows have increased reasonably.
-- The train_pos should be less than cmpl_pos at around the same proportion
-- of the SAMPLE rate (e.g. 80% if 80-20 train-test split)
---------------------------------------------------------------------------------
SELECT COUNT(*) FROM car_complaints.nhtsa_train_pos;
SELECT COUNT(*) FROM car_complaints.nhtsa_cmpl_pos;

-------------------------------------------------------------------------------
-- Create POS-tagged tokens for test set
---------------------------------------------------------------------------------
INSERT INTO car_complaints.nhtsa_test_pos
SELECT t.cmplid AS cmplid
      ,t.odino AS odino
      ,s.word AS word
      ,p.tag_short AS pos_tag
      ,p.tag AS pos_tag_comp
      ,t.compdesc_category
FROM car_complaints.nhtsa_test t
    ,car_complaints.nhtsa_cmpl_pos s
    ,car_complaints.pos_tags p
WHERE t.cmplid = s.cmplid 
AND s.pos_tag = p.tag;

---------------------------------------------------------------------------------
-- Check test_pos if the total rows have increased reasonably.
-- The test_pos should be less than cmpl_pos at around the same proportion
-- of the SAMPLE rate (e.g. 20% if 80-20 train-test split)
---------------------------------------------------------------------------------
SELECT COUNT(*) FROM car_complaints.nhtsa_test_pos;
SELECT COUNT(*) FROM car_complaints.nhtsa_cmpl_pos;

-------------------------------------------------------------------------------
-- Extract tfidf of unigram-POS data of the training data set
-- The script also sets the baseline for the IDF based on the training data IDF.
-- @input       : car_complaints.nhtsa_cmpl_with_category
-- @output      : car_complaints.nhtsa_cmpl_pos_tfidf
--------------------------------------------------------------------------------- 
INSERT INTO car_complaints.nhtsa_train_pos_tfidf
SELECT DISTINCT
       tf
      ,idf
      ,tfidf.tf_idf
      ,tfidf.cmplid
      ,t.compdesc_category
      ,token    
FROM   TF_IDF(
               ON TF(
                      ON ( 
                           SELECT cmplid
                                 ,word||'_'||pos_tag AS token 
                                 ,COUNT(*)::INT AS count
                           FROM  car_complaints.nhtsa_train_pos 
                           WHERE TRIM(word)!= ''
                           GROUP BY cmplid
                                   ,word||'_'||pos_tag 
                         )
                      PARTITION BY cmplid
                    ) AS tf 
               PARTITION BY token
               ON (
                    SELECT COUNT(*)
                    FROM   car_complaints.nhtsa_train
                  ) AS     doccount DIMENSION
             ) tfidf
INNER JOIN car_complaints.nhtsa_train_pos t
ON tfidf.cmplid = t.cmplid;

---------------------------------------------------------------------------------
-- Compare train_pos_tfidf with train_1gram_tfidf 
-- Total train_pos_tfidf  < train_1gram_tfidf * 36
-- There are 36 POS-tags, so that acts as the upper bound
---------------------------------------------------------------------------------
SELECT COUNT(*) FROM car_complaints.nhtsa_train_pos_tfidf;
SELECT COUNT(*) FROM car_complaints.nhtsa_train_1gram_tfidf;

SELECT * FROM car_complaints.nhtsa_train_pos_tfidf limit 100;

-------------------------------------------------------------------------------
-- Extract tfidf of unigram-POS data of the test data set
-- The script recomputes the TFIDF based on the training data IDF.
-- @input       : car_complaints.nhtsa_complaints_test_pos
-- @input       : car_complaints.nhtsa_train_pos_tfidf - used as IDF a priori
-- @output      : car_complaints.nhtsa_test_pos_tfidf
---------------------------------------------------------------------------------
INSERT INTO car_complaints.nhtsa_test_pos_tfidf
SELECT DISTINCT
       tf
      ,idf
      ,tfidf.tf_idf
      ,tfidf.cmplid
      ,t.compdesc_category
      ,token    
FROM   TF_IDF(
               ON TF(
                      ON ( 
                           SELECT cmplid
                                 ,word||'_'||pos_tag AS token 
                                 ,COUNT(*)::INT AS count
                           FROM  car_complaints.nhtsa_test_pos 
                           WHERE TRIM(word)!= ''
                           GROUP BY cmplid
                                   ,word||'_'||pos_tag 
                         )
                      PARTITION BY cmplid
                    ) AS tf 
               PARTITION BY token
               ON ( 
                    SELECT DISTINCT(token) AS term, idf 
                    FROM car_complaints.nhtsa_train_pos_tfidf
                  ) 
               AS idf 
               PARTITION BY term
             ) tfidf
INNER JOIN car_complaints.nhtsa_test_pos t
ON tfidf.cmplid = t.cmplid;

---------------------------------------------------------------------------------
-- Compare test_pos_tfidf with test_1gram_tfidf 
-- Total test_pos_tfidf  < test_1gram_tfidf * 36
-- There are 36 POS-tags, so that acts as the upper bound
---------------------------------------------------------------------------------
SELECT COUNT(*) FROM car_complaints.nhtsa_test_pos_tfidf;
SELECT COUNT(*) FROM car_complaints.nhtsa_test_1gram_tfidf;
SELECT * FROM car_complaints.nhtsa_test_pos_tfidf limit 100;


                        