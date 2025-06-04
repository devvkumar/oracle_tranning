--==================================================================================================================================
--PROGRAM         :XXQGEN_FS_SETUP_APPL_JT.ctl
--TYPE            :SQL*LOADER CONTROL FILE
--UNIX LOCATION   :/u01/XXQGEN/fs1/EBSapps/appl/XXQGEN/12.0.0/bin  ** This UNIX Location is for XXQGEN **
--
--
--INSERTS INTO    :XXX
--CALLED BY       :
--
--==================================================================================================================================
--DESCRIPTION:
--
--   This is the Control file used by SQL LOADER to Upload CSV File data FROM the directory into the XXX Database
--   table. It is called by the .
--
--   
--
--==================================================================================================================================
--PRE-REQUISITES:
--
--   XXX table must be Created in Custom Schema.
--
--==================================================================================================================================
--HISTORY:
--
--  WHEN      	  PROGRAMMER         SNOW REQ#    SNOW CHG#   STAT CSR  DESCRIPTION
--  --------- 	  -----------------  -----------  ----------  --------  ----------------------------------------------------------------
-- 
--==================================================================================================================================
OPTIONS ( SKIP=1, ERRORS=1000000, DIRECT=FALSE)
LOAD DATA
APPEND
INTO TABLE XXQGEN.XXX
FIELDS TERMINATED BY ","
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
IDENTIFIER1   					"XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:IDENTIFIER1)),CHR(34),NULL))",
IDENTIFIER2   					"XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:IDENTIFIER2)),CHR(34),NULL))",
IDENTIFIER3   					"XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:IDENTIFIER3)),CHR(34),NULL))",
SEGMENT1                        "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:SEGMENT1)),CHR(34),NULL))",
ATTRIBUTE1                      "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ATTRIBUTE1)),CHR(34),NULL))",
ATTRIBUTE2                      "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ATTRIBUTE2)),CHR(34),NULL))",
LINE_ID      				    "XXX_S.NEXTVAL",
RECORD_TYPE                     CONSTANT "JT",
PROCESS_FLAG                    CONSTANT "N",
CREATION_DATE                   SYSDATE,
CREATED_BY                      "FND_GLOBAL.USER_ID",
LAST_UPDATED_BY                 "FND_GLOBAL.USER_ID",
LAST_UPDATE_DATE                SYSDATE,
LAST_UPDATE_LOGIN               "FND_GLOBAL.LOGIN_ID")