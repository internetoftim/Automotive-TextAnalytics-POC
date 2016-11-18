-------------------------------------------------------------------------------
-- Script       : 100_create_db_objects.sql
-- @description : Create the tables for data ingestion.
--                
-- Author(s)    : Tim Santos
-- History      : 20151203 - Tim Santos - Initial Version
-------------------------------------------------------------------------------

CREATE SCHEMA car_complaints;

-------------------------------------------------------------------------------
-- Create table for loading the complaints data
-- Refer to CMPL.txt for the complaints data description
-- @source: http://www-odi.nhtsa.dot.gov/downloads/
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_cmpl;

CREATE FACT TABLE car_complaints.nhtsa_cmpl 
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
) 
DISTRIBUTE BY HASH (cmplid);

------------------------------------------------------------------------------
-- Create table for POS tag lookup
-- POS tags were developed on the Penn Treebank Project
-- @source		: Available in Table 6 - 392 of Aster Analytics Foundation 
--				  User Guide 6.10
-- 				  pos_tags.csv
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.pos_tags;

CREATE DIMENSION TABLE car_complaints.pos_tags 
(
  tag VARCHAR
 ,tag_short VARCHAR
 ,pos VARCHAR
 ,description VARCHAR
);

------------------------------------------------------------------------------
-- Create table for Compdesc mapping to selected TREAD buckets
-- compdesc - component description found in the NHTSA data 
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS car_complaints.nhtsa_category_mapping;

CREATE DIMENSION TABLE car_complaints.nhtsa_category_mapping 
(
  compdesc_from VARCHAR
 ,compdesc_to VARCHAR
);		
  
