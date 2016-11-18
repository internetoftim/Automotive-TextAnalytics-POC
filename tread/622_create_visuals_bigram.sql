-------------------------------------------------------------------------------
-- Script       : 622_create_visuals_bigram.sql
-- Purpose      : Create the tables for data ingestion.
--                
-- Author(s)    : Tim Santos
-- History      : 20151203 – Tim Santos – Initial Version
--
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- LDA visualization is done using d3.js
-- Separate script may have to be referred to.
-------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Script to be loaded to APPCenter
-- Create sigma graph for CFilter output of ENGINE TREAD bucket
-- Take note of the memory limitation of appcenter. You may have to reduce
-- the data size by performing feature selection
-- @param       : ORDER BY support DESC - Rank them based on the 'support',
--                'lift', 'confidence' (in this case, we used 'support')
-- @param       : LIMIT N - Select the max rows that the visualization can handle.
--                This is a workaround for the CFilter graph limitation.
--                Only around 100K rows are possible for CFilter visualization.
---------------------------------------------------------------------------------
BEGIN;
INSERT INTO app_center_visualizations  (json) 
SELECT json 
FROM VISUALIZER(
                 ON (
                      SELECT *
                      FROM car_complaints.nhtsa_engine_2gram_cfilter 
                      ORDER BY support DESC
                      LIMIT 100000  
                    )
                 PARTITION BY 1 
                 ASTERFUNCTION('cfilter') 
                 TITLE('Engine TREAD') 
                 VIZTYPE('sigma')
               );
END;
