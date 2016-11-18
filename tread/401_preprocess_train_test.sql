-------------------------------------------------------------------------------
-- Script       : 401_preprocess_train_test.sql
-- Purpose      : Split the data between TRAIN and TEST set, and N-FOLDS.
--                
-- Author(s)    : Tim Santos
-- History      : 20151203 – Tim Santos – Initial Version
-- TODO			: Implement NFOLD
-------------------------------------------------------------------------------       


-------------------------------------------------------------------------------
-- Create training data subset index lookup with TREAD distribution 
-- Make sure the TREAD category distribution of the training 
-- and test data is similar to the entire data set
-- @input		: car_complaints.nhtsa_cmpl_with_category
-- @output		: car_complaints.nhtsa_train_id
-- @param		: stratum - frequency count summary for the TREAD buckets
-- @param		: ApproximateSampleSize('400000') --500000*0.8= 400000
--				  80% of the total rows
-- @param		: SEED ('50') - randomizer starts with this key 
-------------------------------------------------------------------------------       
INSERT INTO car_complaints.nhtsa_train_id 
WITH data AS 
(
  SELECT cmplid
        ,compdesc_category AS stratum 
  FROM   car_complaints.nhtsa_cmpl_with_category
)
SELECT * 
FROM SAMPLE(
             ON data PARTITION BY ANY
             ON (
                  SELECT   stratum
                          ,COUNT(*) AS stratum_count 
                  FROM     data 
                  GROUP BY stratum
                ) AS summary DIMENSION
             CONDITIONONCOLUMN('stratum')
             CONDITIONON(
                          'BRAKES'
                         ,'LIGHTING'
                         ,'EQUIPMENT'
                         ,'TRAILER'
                         ,'OTHER'
                         ,'ENGINE'
                         ,'VISIBILITY'
                         ,'FUEL'
                         ,'AIR BAG'
                        )
             APPROXIMATESAMPLESIZE('400000') --500000*0.8= ~400000
             SEED('50')
           );

-------------------------------------------------------------------------------
-- Create the training data set with the actual data FROM index 
-------------------------------------------------------------------------------       
INSERT INTO car_complaints.nhtsa_train
SELECT * 
FROM  car_complaints.nhtsa_cmpl_with_category 
WHERE cmplid 
IN (
     SELECT cmplid 
     FROM   car_complaints.nhtsa_train_id
   );


-------------------------------------------------------------------------------
-- Create test data subset index lookup with TREAD distribution 
-- Make sure the TREAD category distribution of the training 
-- and test data is similar to the entire data set
-- This basically groups the remaining rows not SELECTed in the 
-- training subset.
-------------------------------------------------------------------------------       
INSERT INTO car_complaints.nhtsa_test_id 
SELECT cmplid
      ,compdesc_category AS stratum 
FROM   car_complaints.nhtsa_cmpl_with_category 
WHERE  cmplid 
NOT IN (
	     SELECT cmplid 
	     FROM car_complaints.nhtsa_train_id
       ); 

-------------------------------------------------------------------------------
-- Create the test data set with the actual data FROM index 
-------------------------------------------------------------------------------       
INSERT INTO car_complaints.nhtsa_test
SELECT * 
FROM   car_complaints.nhtsa_cmpl_with_category 
WHERE  cmplid 
IN (
     SELECT cmplid 
     FROM car_complaints.nhtsa_test_id
   );

-------------------------------------------------------------------------------
-- Check data distribution of each TREAD category
-- for Train and Test subsets
-------------------------------------------------------------------------------       
SELECT compdesc_category
      ,COUNT(1) 
FROM car_complaints.nhtsa_cmpl_with_category 
GROUP BY compdesc_category;

SELECT stratum AS compdesc_category
      ,COUNT(1) 
FROM car_complaints.nhtsa_train_id 
GROUP BY stratum 
ORDER BY stratum;

SELECT stratum AS compdesc_category
      ,COUNT(1) 
FROM car_complaints.nhtsa_test_id 
GROUP BY stratum 
ORDER BY stratum;

