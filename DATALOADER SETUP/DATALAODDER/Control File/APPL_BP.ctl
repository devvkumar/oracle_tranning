--==================================================================================================================================
--PROGRAM         : APPL_BP.ctl
--TYPE            :SQL*LOADER CONTROL FILE
--UNIX LOCATION   :$XXQGEN_TOP/bin
--
--
--INSERTS INTO    : XX
--CALLED BY       :" Data Load Process" Concurrent Program
--
--==================================================================================================================================
--DESCRIPTION:
--
--   This is the Control file used by SQL LOADER to Upload CSV File data FROM the directory into the  XX Database
--   table. It is called by the "XXQGEN Data Load Process" Concurrent Program.
--
--   The "XXQGEN Upload Process"  will then be run to Load Setup Customer,Job Type,City-State,Market values 
--
--==================================================================================================================================
--PRE-REQUISITES:
--
--    XX table must be Created in Custom Schema.
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
INTO TABLE XXQGEN. XX
FIELDS TERMINATED BY ","
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
IDENTIFIER1   					"XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:IDENTIFIER1)),CHR(34),NULL))",
IDENTIFIER2   					"XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:IDENTIFIER2)),CHR(34),NULL))",
ATTRIBUTE9                      "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ATTRIBUTE9)),CHR(34),NULL))",
LINE_ID      				    " XX_S.NEXTVAL",
CREATION_DATE                   SYSDATE,
RECORD_TYPE                     CONSTANT "BP",
PROCESS_FLAG                    CONSTANT "N",
CREATED_BY                      "FND_GLOBAL.USER_ID",
LAST_UPDATED_BY                 "FND_GLOBAL.USER_ID",
LAST_UPDATE_DATE                SYSDATE,
LAST_UPDATE_LOGIN               "FND_GLOBAL.LOGIN_ID")