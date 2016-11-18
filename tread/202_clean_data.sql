-------------------------------------------------------------------------------
-- Script       : 202_clean_data.sql
-- Purpose      : Clean the description (cdescr) data: 
--				  Remove encoder initials and unwanted characters 
--				  after inspecting the data.
--                
-- Author(s)    : Tim Santos
-- History      : 20151203 – Tim Santos – Initial Version

-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Remove 2-letter encoder initials and remove leading and trailing spaces.
--	e.g. 'TT' is removed from the following description:
--  "VEHICLES BRAKING SYSTEM FADES WHILE DRIVING.  TT"
-------------------------------------------------------------------------------
UPDATE car_complaints.nhtsa_cmpl_with_category
SET    cdescr = SUBSTR(cdescr, 0, LENGTH(cdescr)-2)
WHERE  SUBSTR(cdescr, LENGTH(cdescr)-2) ILIKE '*%' 
AND    SUBSTR(cdescr, LENGTH(cdescr)-2) NOT ILIKE '**%';

UPDATE car_complaints.nhtsa_cmpl_with_category
SET    cdescr = TRIM(cdescr);

-------------------------------------------------------------------------------
-- Remove 3-letter encoder initials and remove leading and trailing spaces.
--	e.g. '*KB' is removed from the following description:
-- "A/C COMPRESSOR FAILED AND CHECK ENGINE LIGHT ILLUMINATED. *KB"
-------------------------------------------------------------------------------
UPDATE car_complaints.nhtsa_cmpl_with_category
SET    cdescr = SUBSTR(cdescr, 0, LENGTH(cdescr)-3)
WHERE  SUBSTR(cdescr, LENGTH(cdescr)-3) ILIKE '*%' 
AND    SUBSTR(cdescr, LENGTH(cdescr)-3) NOT ILIKE '**%';

UPDATE car_complaints.nhtsa_cmpl_with_category
SET    cdescr = TRIM(cdescr);
