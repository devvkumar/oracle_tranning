--==================================================================================================================================
--PROGRAM         :XXQGEN_O_to_M_dk.ctl
--TYPE            :SQL*LOADER CONTROL FILE
--UNIX LOCATION   :/u01/XXGEBdev2/fs1/EBSapps/appl/xxmtz/12.0.0/bin  ** This UNIX Location is for DEV2 **
--
--COMPANY         :
--MODULE          :
--
--SNOW PROJECT    :
--SNOW REQ ITEM   :
--SNOW CHANGE REQ :
--
--INSERTS INTO    :XXQGEN
--CALLED BY       :Data Load Process" Concurrent Program
--
--==================================================================================================================================
--DESCRIPTION:
--
--   This is the Control file used by SQL LOADER to Upload CSV File data FROM the directory into the XXQGEN_TBL1_DK AND XXQGEN_TBL2_DK Database
--   table.  It is called by the "Update Program" Concurrent Program.
--
--
--==================================================================================================================================
--PRE-REQUISITES:
--
--   xxqgen table must be Created in Custom Schema.
--
--==================================================================================================================================
--HISTORY:
--
--  WHEN      	  PROGRAMMER         
--  --------- 	  -----------------  -----------  ----------  --------  ----------------------------------------------------------------
--  05-Jun-2020   
--==================================================================================================================================
OPTIONS ( SKIP=1, ERRORS=1000000, DIRECT=FALSE)
LOAD DATA
APPEND
INTO TABLE xxqgen_tbl1_dk
FIELDS TERMINATED BY ","
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
name,
id
)


INTO TABLE xxqgen_tbl2_dk
FIELDS TERMINATED BY ","
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
phone,
email
)