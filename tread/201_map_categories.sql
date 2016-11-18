-------------------------------------------------------------------------------
-- Script       : 201_map_categories.sql
-- Purpose      : Create mapping of categories in NHTSA complaints, to 
--				  final subset of categories for analysis.
--				  This needs to be discussed with client.
--                
-- Author(s)    : Tim Santos
-- History      : 20151203 – Tim Santos – Initial Version
--
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Create lookup table to map detailed Component Description with the 
-- simplified Description or TREAD bucket
-- @output		: car_complaints.nhtsa_category
-- @input		: car_complaints.nhtsa_category_mapping
-- TODO			: Ensure TREAD buckets are reviewed with customer
-------------------------------------------------------------------------------
INSERT INTO car_complaints.nhtsa_category 
SELECT compdesc_orig
      ,compdesc_parsed 
      ,compdesc_to as compdesc_category 
FROM (
       SELECT compdesc_orig ,
              SPLIT_PART(REPLACE(compdesc_a,':','!#!'),'!#!',1) compdesc_parsed 
       FROM ( 
              WITH x AS 
                      ( 
                        SELECT DISTINCT compdesc compdesc_orig 
                        FROM   car_complaints.nhtsa_cmpl 
                        WHERE  LENGTH(compdesc) != 0
                      )
              SELECT compdesc_orig 
                    ,REPLACE(compdesc_orig,',','!#!') compdesc_a 
              FROM   x 
            ) y
     ) a
INNER JOIN car_complaints.nhtsa_category_mapping b
ON a.compdesc_parsed=b.compdesc_from; 


-------------------------------------------------------------------------------
-- Re-label each complaint according to the mapping
-- @verify		: SELECT * FROM car_complaints.nhtsa_cmpl_with_category limit 5;
-------------------------------------------------------------------------------
INSERT INTO car_complaints.nhtsa_cmpl_with_category
SELECT a.*
      ,b.compdesc_category 
FROM   car_complaints.nhtsa_cmpl a
      ,car_complaints.nhtsa_category b 
WHERE  a.compdesc = b.compdesc_orig; 

