-------------------------------------------------------------------------------
-- Script       : 511_create_lda_topic_model_engine_unigram.sql
-- Purpose      : Perform the LDA Topic modelling fr ENGINE TREAD bucket.
--                Prepare the models for the topic-word graphs.                
-- Author(s)    : Tim Santos
-- History      : 20151203 – Tim Santos – Initial Version
--
-------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Model created by the LDATrainer function for unigram tokens
-- Make sure to drop the table before running the SQL-MR function
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_engine_1gram_lda_model;

---------------------------------------------------------------------------------
-- Output table created by the LDATrainer function for unigram tokens
-- Make sure to drop the table before running the SQL-MR function
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_engine_1gram_lda_output;

-------------------------------------------------------------------------------
-- Train the LDA model and generate the top terms 
-- The script recomputes the TFIDF based on the training data IDF.
-- @input       : car_complaints.nhtsa_engine_1gram_tfidf
-- @output      : car_complaints.nhtsa_engine_1gram_lda_output
-- @output      : car_complaints.nhtsa_engine_1gram_lda_model
-- @param       : TOPICNUMBER('N') - N topics as arbitrary starting point
--              : this number should be explored further
-- @param       : ALPHA('alpha')
-- @param       : ETA('eta')
-- @param       : maxiterate(30) - default from aster
-- @param       : convergencedelta(1e-3) - default from aster
-- @param       : SEED('50') - seed for randomizer 
--                (same seed sets the same state for randomizer
--                 hence, same output)
-- @param       : OUTPUTTOPICWORDNUMBER('all') - all possible word and weight
-- TODO         : Experiment the number of TOPICNUMBER 
--                look for interesting topic number
---------------------------------------------------------------------------------
SELECT *
FROM LDATrainer(
                 ON (SELECT 1) 
                 PARTITION BY 1
                 INPUTTABLE('car_complaints.nhtsa_engine_1gram_tfidf')
                 MODELTABLE('car_complaints.nhtsa_engine_1gram_lda9_model')
                 OUTPUTTABLE('car_complaints.nhtsa_engine_1gram_lda9_output')
                 TOPICNUMBER('9')
                 --[ALPHA('alpha')]
                 --[ETA('eta')]
                 DOCIDCOLUMN('cmplid')
                 WORDCOLUMN('token')
                 COUNTCOLUMN('tf')
                 MAXITERATE(30)
                 CONVERGENCEDELTA(1e-3)
                 SEED('50')
                 OUTPUTTOPICWORDNUMBER('all')
               );

-------------------------------------------------------------------------------
-- Print the LDA model's top terms 
-- @input       : car_complaints.nhtsa_engine_1gram_lda9_model
-- @output      : car_complaints.nhts_engine_1gram_lda9_top100_words
-- @param       : OUTPUTTOPICNUMBER(N) - print the top N words per topic
-- TODO         : Adjust OUTPUTTOPICNUMBER(N) to find meaningful topic words
---------------------------------------------------------------------------------
INSERT INTO car_complaints.nhtsa_engine_1gram_lda9_top100_words
SELECT * 
FROM LDATOPICPRINTER(
                      ON car_complaints.nhtsa_engine_1gram_lda9_model
                      PARTITION BY 1
                      OUTPUTBYWORD('true')
                      OUTPUTTOPICWORDNUMBER('100')
                      SHOWWORDWEIGHT('true')
                    )
ORDER BY topicid;	
      
---------------------------------------------------------------------------------
-- Display the top-weighted terms out of the 9 topics of the ENGINE TREAD.
-- Store this to an external file, to be loaded to visualization tool.
-- Make sure the csv file is clean before loading to d3. 
-- Disable other display messages before running this to avoid artifacts.
-- You must run this in ACT and
-- @output      : 'filename.csv' - e.g. engine_9T.csv the output file to be
--                loaded into d3.js visualization
---------------------------------------------------------------------------------
\o engine_9T.csv
SELECT * 
FROM car_complaints.nhtsa_engine_1gram_lda9_top100_words;
\o

---------------------------------------------------------------------------------
-- Model created by the LDATrainer function for unigram tokens
-- Make sure to drop the table before running the SQL-MR function
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_brakes_1gram_lda7_model;

---------------------------------------------------------------------------------
-- Output table created by the LDATrainer function for unigram tokens
-- Make sure to drop the table before running the SQL-MR function
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_brakes_1gram_lda7_output;

-------------------------------------------------------------------------------
-- Train the LDA model and generate the top terms 
-- The script recomputes the TFIDF based on the training data IDF.
-- @input       : car_complaints.nhtsa_brakes_1gram_tfidf
-- @output      : car_complaints.nhtsa_brakes_1gram_lda_output
-- @output      : car_complaints.nhtsa_brakes_1gram_lda_model
-- @param       : TOPICNUMBER('N') - N topics as arbitrary starting point
--              : this number should be explored further
-- @param       : ALPHA('alpha')
-- @param       : ETA('eta')
-- @param       : maxiterate(30) - default from aster
-- @param       : convergencedelta(1e-3) - default from aster
-- @param       : SEED('50') - seed for randomizer 
--                (same seed sets the same state for randomizer
--                 hence, same output)
-- @param       : OUTPUTTOPICWORDNUMBER('all') - all possible word and weight
-- TODO         : Experiment the number of TOPICNUMBER 
--                look for interesting topic number
---------------------------------------------------------------------------------
SELECT *
FROM LDATrainer(
                 ON (SELECT 1) 
                 PARTITION BY 1
                 INPUTTABLE('car_complaints.nhtsa_brakes_1gram_tfidf')
                 MODELTABLE('car_complaints.nhtsa_brakes_1gram_lda7_model')
                 OUTPUTTABLE('car_complaints.nhtsa_brakes_1gram_lda7_output')
                 TOPICNUMBER('7')
                 --[ALPHA('alpha')]
                 --[ETA('eta')]
                 DOCIDCOLUMN('cmplid')
                 WORDCOLUMN('token')
                 COUNTCOLUMN('tf')
                 MAXITERATE(30)
                 CONVERGENCEDELTA(1e-3)
                 SEED('50')
                 OUTPUTTOPICWORDNUMBER('100')
               );

---------------------------------------------------------------------------------
-- Output table created by the LDATrainer function for unigram tokens
-- Make sure to drop the table before running the SQL-MR function
---------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_brakes_1gram_lda7_top50_words;

-------------------------------------------------------------------------------
-- Print the LDA model's top terms 
-- @input       : car_complaints.nhtsa_brakes_1gram_lda9_model
-- @output      : car_complaints.nhts_brakes_1gram_lda9_top50_words
-- @param       : OUTPUTTOPICNUMBER(N) - print the top N words per topic
-- TODO         : Adjust OUTPUTTOPICNUMBER(N) to find meaningful topic words
---------------------------------------------------------------------------------
INSERT INTO car_complaints.nhtsa_brakes_1gram_lda7_top50_words
SELECT * 
FROM LDATOPICPRINTER(
                      ON car_complaints.nhtsa_brakes_1gram_lda7_model
                      PARTITION BY 1
                      OUTPUTBYWORD('false')
                      OUTPUTTOPICWORDNUMBER('50')
                      SHOWWORDWEIGHT('true')
                    )
ORDER BY topicid;	
      
---------------------------------------------------------------------------------
-- Display the top-weighted terms out of the 9 topics of the BRAKES TREAD.
-- Store this to an external file, to be loaded to visualization tool.
-- Make sure the csv file is clean before loading to d3. 
-- Disable other display messages before running this to avoid artifacts.
-- You must run this in ACT and
-- @output      : 'filename.csv' - e.g. brakes_7T.csv the output file to be
--                loaded into d3.js visualization
---------------------------------------------------------------------------------
\o brakes_7T.csv
SELECT * 
FROM car_complaints.nhtsa_brakes_1gram_lda7_top50_words;
\o

