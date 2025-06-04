--==================================================================================================================================
--PROGRAM         :XX_SETUP_CUSTOMER.ctl
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
--   This is the Control file used by SQL LOADER to Upload CSV File data FROM the directory into the xqgen Database
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
INTO TABLE XXMTZ.XXMTZ_FS_SETUP_INTF
FIELDS TERMINATED BY ","
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
IDENTIFIER2   					"COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:IDENTIFIER2)),CHR(34),NULL))",
IDENTIFIER1   					"COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:IDENTIFIER1)),CHR(34),NULL))",
IDENTIFIER3   					"COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:IDENTIFIER3)),CHR(34),NULL))",
ATTRIBUTE9                      "COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ATTRIBUTE9)),CHR(34),NULL))",
ATTRIBUTE13                     "COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ATTRIBUTE13)),CHR(34),NULL))",
LINE_ID      				    "FS_SETUP_INTF_S.NEXTVAL",
RECORD_TYPE                     CONSTANT "CUST",      
CREATION_DATE                   SYSDATE,
CREATED_BY                      "FND_GLOBAL.USER_ID",
LAST_UPDATED_BY                 "FND_GLOBAL.USER_ID",
LAST_UPDATED_DATE               SYSDATE,
LAST_UPDATED_LOGIN              "FND_GLOBAL.LOGIN_ID")