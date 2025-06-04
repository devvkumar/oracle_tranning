--==================================================================================================================================
--PROGRAM         :XXQGEN.ctl
--TYPE            :SQL*LOADER CONTROL FILE
--UNIX LOCATION   :/u01/XXQGEN/fs1/EBSapps/appl/XXQGEN/12.0.0/bin  ** This UNIX Location is for XXQGEN **
--
--
--INSERTS INTO    :XX
--CALLED BY       :
--
--==================================================================================================================================
--DESCRIPTION:
--
--   This is the Control file used by SQL LOADER to Upload CSV File data FROM the directory into the XX Database
--   table. It is called by the .
--
--   The  will then be run to Load FS Setup Customer,Job Type,City-State,Market values 
--
--==================================================================================================================================
--PRE-REQUISITES:
--
--   XX table must be Created in Custom Schema.
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
INTO TABLE XXQGEN.XX
FIELDS TERMINATED BY ","
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
IDENTIFIER1   					"XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:IDENTIFIER1)),CHR(34),NULL))",
IDENTIFIER2   					"XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:IDENTIFIER2)),CHR(34),NULL))",
IDENTIFIER3   					"XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:IDENTIFIER3)),CHR(34),NULL))",
SEGMENT1                        "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:SEGMENT1)),CHR(34),NULL))",
SEGMENT2                        "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:SEGMENT2)),CHR(34),NULL))",
ATTRIBUTE1                      "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ATTRIBUTE1)),CHR(34),NULL))",
ATTRIBUTE2                      "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ATTRIBUTE2)),CHR(34),NULL))",
ATTRIBUTE3                      "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ATTRIBUTE3)),CHR(34),NULL))",
ATTRIBUTE4                      "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ATTRIBUTE4)),CHR(34),NULL))",
ATTRIBUTE5                      "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ATTRIBUTE5)),CHR(34),NULL))",
ATTRIBUTE6                      "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ATTRIBUTE6)),CHR(34),NULL))",
ATTRIBUTE8                      "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ATTRIBUTE8)),CHR(34),NULL))",
ATTRIBUTE9                      "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ATTRIBUTE9)),CHR(34),NULL))",
ATTRIBUTE10                     "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ATTRIBUTE10)),CHR(34),NULL))",
ATTRIBUTE11                     "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ATTRIBUTE11)),CHR(34),NULL))",
ATTRIBUTE12                     "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ATTRIBUTE12)),CHR(34),NULL))",
ATTRIBUTE13                     "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ATTRIBUTE13)),CHR(34),NULL))",
ATTRIBUTE14                     "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ATTRIBUTE14)),CHR(34),NULL))",
ATTRIBUTE17                     "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ATTRIBUTE17)),CHR(34),NULL))",
ATTRIBUTE18                     "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ATTRIBUTE18)),CHR(34),NULL))",
ATTRIBUTE20                     "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ATTRIBUTE20)),CHR(34),NULL))",
ATTRIBUTE21                     "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ATTRIBUTE21)),CHR(34),NULL))",
ATTRIBUTE22                     "XXQGEN_COMMON_UTILS_PKG.REMOVE_SPL_CHAR(REPLACE(LTRIM(RTRIM(:ATTRIBUTE22)),CHR(34),NULL))",
LINE_ID      				    "XX_S.NEXTVAL",
RECORD_TYPE                     CONSTANT "INV",
PROCESS_FLAG                    CONSTANT "N",
CREATION_DATE                   SYSDATE,
CREATED_BY                      "FND_GLOBAL.USER_ID",
LAST_UPDATED_BY                 "FND_GLOBAL.USER_ID",
LAST_UPDATE_DATE                SYSDATE,
LAST_UPDATE_LOGIN               "FND_GLOBAL.LOGIN_ID")