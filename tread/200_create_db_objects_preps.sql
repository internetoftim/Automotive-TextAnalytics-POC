-------------------------------------------------------------------------------
-- Script       : 200_create_db_objects_preps.sql
-- Purpose      : Create the tables for Data Preparation
--                
-- Author(s)    : Tim Santos
-- History      : 20151203 - Tim Santos - Initial Version
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- @description	: lookup table to map detailed Component Description with the 
--              : simplified Description or TREAD bucket
-- @column		: compdesc_orig - original component description
-- @column		: compdesc_parsed - parsed sub-category from parent-category
-- @column		: compdesc_orig - mapped to final TREAD bucket
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS complaints.nhtsa_category;

CREATE DIMENSION TABLE car_complaints.nhtsa_category 
(
  compdesc_orig VARCHAR  
 ,compdesc_parsed VARCHAR
 ,compdesc_category VARCHAR
);


-------------------------------------------------------------------------------
-- @description	: Re-labelled complaint according to the mapping
-- @column[1-39]: same as car_complaints.nhtsa_cmpl
-- @column		: compdesc_category - additional TREAD bucket mapping
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_cmpl_with_category;

CREATE FACT TABLE car_complaints.nhtsa_cmpl_with_category 
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
DISTRIBUTE BY HASH(cmplid);
