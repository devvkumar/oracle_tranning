/* Formatted on 12/18/2024 12:07:52 PM (QP5 v5.163.1008.3004) */
SELECT *
FROM fnd_user
here;

SELECT *
  FROM fnd_user
 WHERE user_name = 'OPERATIONS';

SELECT *
  FROM fnd_user
 WHERE user_id = 1318;

--1006
SELECT * FROM PER_ALL_PEOPLE_F
WHERE PERSON_ID = 10061;

SELECT SYSDATE FROM DUAL;


SELECT * FROM operations;

SELECT *
  FROM fnd_user
 WHERE user_name = 'ADITYA'
       AND TRIM (SYSDATE) BETWEEN start_date AND end_date;

SELECT *
  FROM fnd_user
 WHERE user_name = 'OPERATIONS'
       AND TRIM (SYSDATE) BETWEEN start_date AND NVL (end_date, SYSDATE + 1);

SELECT *
  FROM PER_ALL_PEOPLE_F;
  
 --WHERE PERSON_ID = 25;

SELECT * FROM per_all_people_f;

SELECT *
  FROM PER_ALL_PEOPLE_F
 WHERE PERSON_ID = 25
       AND TRUNC (SYSDATE) BETWEEN EFFECTIVE_START_DATE
                               AND EFFECTIVE_END_DATE
       AND (CURRENT_EMPLOYEE_FLAG = 'Y' OR CURRENT_NPW_FLAG = 'Y');


/****************************************
       *    
       *****************************************/

SELECT
       fu.user_id,
       fu.user_name user_name,
       fu.start_date,
       fu.end_date,
       fu.description,
       papf.person_id,
       NVL (papf.EMPLOYEE_NUMBER, papf.NPW_NUMBER) employee_id,
       papf.full_name,
       papf.EFFECTIVE_START_DATE,
       papf.EFFECTIVE_END_DATE,
       papf.CURRENT_EMPLOYEE_FLAG,
       papf.CURRENT_NPW_FLAG,
       papf.EMAIL_ADDRESS
  FROM fnd_user fu, per_all_people_f papf
 WHERE
        fu.employee_id = papf.person_id 
       AND user_name = 'ADITYA'
       AND TRIM (SYSDATE) BETWEEN fu.start_date
                              AND NVL (fu.end_date, SYSDATE + 1)
       AND TRIM (SYSDATE) BETWEEN papf.EFFECTIVE_START_DATE
                              AND papf.EFFECTIVE_END_DATE
       AND (papf.CURRENT_EMPLOYEE_FLAG = 'Y' OR papf.CURRENT_NPW_FLAG = 'Y');



  SELECT START_DATE,
         END_DATE,
         RESPONSIBILITY_APPLICATION_ID,
         RESPONSIBILITY_ID,
         SECURITY_GROUP_ID,
         LAST_UPDATE_DATE,
         LAST_UPDATED_BY,
         CREATED_BY,
         CREATION_DATE,
         LAST_UPDATE_LOGIN,
         USER_ID
    FROM FND_USER_RESP_GROUPS_direct
  WHERE (responsibility_id, responsibility_application_id) IN
            (SELECT responsibility_id, application_id
               FROM fnd_responsibility
              WHERE USER_ID = 1014243)
ORDER BY responsibility_application_id, responsibility_id, security_group_id;


--**************************



  SELECT START_DATE,
         END_DATE,
         RESPONSIBILITY_APPLICATION_ID,
         RESPONSIBILITY_ID,
         SECURITY_GROUP_ID,
         LAST_UPDATE_DATE,
         LAST_UPDATED_BY,
         CREATED_BY,
         CREATION_DATE,
         LAST_UPDATE_LOGIN,
         USER_ID
    FROM FND_USER_RESP_GROUPS_direct
   WHERE (responsibility_id, responsibility_application_id) IN
            (SELECT responsibility_id, application_id
               FROM fnd_responsibility
              WHERE (   version = '4'
                     OR version = 'W'
                     OR version = 'M'
                     OR version = 'H'))
       --  AND (USER_ID = 1318)
ORDER BY responsibility_application_id, responsibility_id, security_group_id;

select * from dba_objects where object_type LIKE '%TABLE%';


SELECT responsibility_id, application_id, version
               FROM fnd_responsibility
              WHERE (   version = '4'
                     OR version = 'W'
                     OR version = 'M'
                     OR version = 'H');


select * from dba_objects where object_type LIKE '%TABLE%';

select * from dba_objects where object_NAME LIKE '%FND%RES%VL%'; /*for  language*/

select * from dba_objects where object_NAME LIKE '%FND%RES%TL%';

select * from dba_objects where object_NAME LIKE '%FND%APP%VL%';

select * from dba_objects where object_NAME LIKE '%FND%USER%RESP%';

select * 
from FND_USER_RESP_GROUPS;

SELECT * FROM FND_RESPONSIBILITY;
SELECT * FROM FND_USER_RESP_GROUPS_direct;
--where user_id = 1014254
--order by last_update_date desc;
SELECT * FROM FND_RESPONSIBILITY_VL;
SELECT * FROM FND_APPLICATION_VL;
select *
from fnd_user
where user_name = 'DEV';

fnd_user_resp_groups_api

xxqgen_user_data_pkg_ ;

--FND_APPLICATION_VL
select * from fnd_responsibility;

SELECT 
          fu.user_id,
       fu.user_name user_name,
       fu.start_date,
       fu.end_date,
       fu.description,
       papf.person_id,
       NVL (papf.EMPLOYEE_NUMBER, papf.NPW_NUMBER) employee_id,
       papf.full_name,
       papf.EFFECTIVE_START_DATE,
       papf.EFFECTIVE_END_DATE,
       papf.CURRENT_EMPLOYEE_FLAG,
       papf.CURRENT_NPW_FLAG,
       papf.EMAIL_ADDRESS,
       frv.RESPONSIBILITY_NAME,
       fav.APPLICATION_NAME,
       frv.RESPONSIBILITY_KEY,
       frv.DESCRIPTION,
       frv.START_DATE
  FROM
       fnd_user fu, 
       per_all_people_f papf,
       FND_USER_RESP_GROUPS_direct furg,
       FND_RESPONSIBILITY_VL frv,
       FND_APPLICATION_VL fav
       where 
       furg.responsibility_id = frv.RESPONSIBILITY_ID
       and fu.user_id=furg.user_id
       and frv.APPLICATION_ID=fav.APPLICATION_ID
       and  fu.employee_id = papf.person_id 
   --    and user_name = 'DEV'
       AND TRIM (SYSDATE) BETWEEN fu.start_date
                              AND NVL (fu.end_date, SYSDATE + 1)
       AND TRIM (SYSDATE) BETWEEN papf.EFFECTIVE_START_DATE
                              AND papf.EFFECTIVE_END_DATE
       AND (papf.CURRENT_EMPLOYEE_FLAG = 'Y' OR papf.CURRENT_NPW_FLAG = 'Y');

       ;

select * from fnd_user;

select * from dba_objects where object_name like '%fnd%';

select * from all_objects where object_name like '%fnd%';

select *
from fnd_user_resp_groups;

select *
from  FND_RESPONSIBILITY_VL frv;

select * 
from fnd_concurrent_program_vl;

SELECT * 
FROM FND_APPLICATION_VL
WHERE APPLICATION_ID = 201;

SELECT * FROM FND_CONCURRENT_PROGRAMS_VL
WHERE USER_CONCURRENT_PROGRAM_NAME like 'XXQGEN%DK';

SELECT * FROM FND_EXECUTABLES_FORM_V
WHERE EXECUTABLE_ID = 16642;
 
 
SELECT * FROM FND_CONCURRENT_REQUESTS
WHERE 1=1;
-- AND REQUEST_ID =5912035 -- 5912104
--AND CONCURRENT_PROGRAM_ID = 218704;
 
 
-- PHASE 
SELECT LOOKUP_CODE, MEANING
  FROM FND_LOOKUP_VALUES
WHERE LOOKUP_TYPE = 'CP_PHASE_CODE' AND LANGUAGE = 'US'
       AND ENABLED_FLAG = 'Y';
 
--STATUS 
SELECT LOOKUP_CODE, MEANING
  FROM FND_LOOKUP_VALUES
WHERE LOOKUP_TYPE = 'CP_STATUS_CODE' AND LANGUAGE = 'US'
       AND ENABLED_FLAG = 'Y';
       
       SELECT DISTINCT 
       UPCVL.CONCURRENT_PROGRAM_ID, 
       UPCVL.CONCURRENT_PROGRAM_NAME, 
       UPCVL.EXECUTABLE_APPLICATION_ID, 
       UPCVL.EXECUTABLE_ID,
       FEFV.EXECUTION_FILE_NAME,
       FEFV.DESCRIPTION,
       UPCVL.APPLICATION_ID,
       FAVL.APPLICATION_NAME,
       FAVL.APPLICATION_SHORT_NAME,
       FCR.REQUEST_ID,
       SC.MEANING AS STATUS_CODE, 
       PC.MEANING AS PHASE_CODE,
       FCR.ACTUAL_COMPLETION_DATE - FCR.ACTUAL_START_DATE AS EXECUTION_DURATION
FROM   FND_CONCURRENT_PROGRAMS_VL UPCVL
JOIN   FND_APPLICATION_VL FAVL
       ON UPCVL.APPLICATION_ID = FAVL.APPLICATION_ID
JOIN   FND_EXECUTABLES_FORM_V FEFV
       ON UPCVL.EXECUTABLE_ID = FEFV.EXECUTABLE_ID
JOIN   FND_CONCURRENT_REQUESTS FCR
       ON UPCVL.CONCURRENT_PROGRAM_ID = FCR.CONCURRENT_PROGRAM_ID
JOIN   (SELECT LOOKUP_CODE, MEANING
        FROM FND_LOOKUP_VALUES
        WHERE LOOKUP_TYPE = 'CP_STATUS_CODE' 
          AND LANGUAGE = 'US'
          AND ENABLED_FLAG = 'Y') SC
       ON SC.LOOKUP_CODE = FCR.STATUS_CODE
JOIN   (SELECT LOOKUP_CODE, MEANING
        FROM FND_LOOKUP_VALUES
        WHERE LOOKUP_TYPE = 'CP_PHASE_CODE' 
          AND LANGUAGE = 'US'
          AND ENABLED_FLAG = 'Y') PC
       ON PC.LOOKUP_CODE = FCR.PHASE_CODE
WHERE  UPCVL.CONCURRENT_PROGRAM_NAME = 'XXQGEN_USER_DATA_PGK_DK';


SELECT DISTINCT UPCVL.CONCURRENT_PROGRAM_ID, 
            UPCVL.CONCURRENT_PROGRAM_NAME, 
            UPCVL.EXECUTABLE_APPLICATION_ID, 
            UPCVL.EXECUTABLE_ID,
            FEFV.EXECUTION_FILE_NAME,
            FEFV.DESCRIPTION,
            UPCVL.APPLICATION_ID,
            FAVL.APPLICATION_NAME,
            FAVL.APPLICATION_SHORT_NAME ,
            FCR.REQUEST_ID,
            SC.MEANING STATUS_CODE, 
            PC.MEANING PHASE_CODE,
            FCR.ACTUAL_COMPLETION_DATE - FCR.ACTUAL_START_DATE
FROM    FND_CONCURRENT_PROGRAMS_VL UPCVL, 
             FND_APPLICATION_VL FAVL, 
             FND_EXECUTABLES_FORM_V FEFV,
             FND_CONCURRENT_REQUESTS FCR,
            (SELECT LOOKUP_CODE, MEANING
             FROM FND_LOOKUP_VALUES
             WHERE LOOKUP_TYPE = 'CP_STATUS_CODE' AND LANGUAGE = 'US'
             AND ENABLED_FLAG = 'Y') SC,
             (SELECT LOOKUP_CODE, MEANING
              FROM FND_LOOKUP_VALUES
              WHERE LOOKUP_TYPE = 'CP_PHASE_CODE' AND LANGUAGE = 'US'
              AND ENABLED_FLAG = 'Y') PC
WHERE 1=1
AND     UPCVL.CONCURRENT_PROGRAM_NAME = 'XXQGEN%'
AND     UPCVL.CONCURRENT_PROGRAM_ID  = FCR.CONCURRENT_PROGRAM_ID
AND     UPCVL.APPLICATION_ID = FAVL.APPLICATION_ID
AND     UPCVL.EXECUTABLE_ID = FEFV.EXECUTABLE_ID
AND     SC.LOOKUP_CODE = FCR.STATUS_CODE
AND     PC.LOOKUP_CODE = FCR.PHASE_CODE;



SELECT DISTINCT UPCVL.CONCURRENT_PROGRAM_ID, 
            UPCVL.CONCURRENT_PROGRAM_NAME, 
            UPCVL.EXECUTABLE_APPLICATION_ID, 
            UPCVL.EXECUTABLE_ID,
            FEFV.EXECUTION_FILE_NAME,
            FEFV.DESCRIPTION,
            UPCVL.APPLICATION_ID,
            FAVL.APPLICATION_NAME,
            FAVL.APPLICATION_SHORT_NAME ,
            FCR.REQUEST_ID
FROM    FND_CONCURRENT_PROGRAMS_VL UPCVL, 
             FND_APPLICATION_VL FAVL, 
             FND_EXECUTABLES_FORM_V FEFV,
             FND_CONCURRENT_REQUESTS FCR
WHERE 1=1
AND     UPCVL.CONCURRENT_PROGRAM_NAME = 'XXQGEN_USER_DATA_PGK_DK'
AND     UPCVL.CONCURRENT_PROGRAM_ID  = FCR.CONCURRENT_PROGRAM_ID
AND     UPCVL.APPLICATION_ID = FAVL.APPLICATION_ID
AND     UPCVL.EXECUTABLE_ID = FEFV.EXECUTABLE_ID;


SELECT *
FROM FND_CONCURRENT_REQUESTS
WHERE CONCURRENT_PROGRAM_ID = 218711;

--  FND_CONCURRENT_PROGRAMS_TL T, FND_CONCURRENT_PROGRAMS B
  SELECT *
  FROM FND_CONCURRENT_PROGRAMS;
  
  SELECT *
  FROM FND_CONCURRENT_PROGRAMS_TL;
  
  SELECT *
  FROM V$INSTANCE;
  
  SELECT *
  FROM ICX_PARAMETERS;
  
  
  
  
SELECT fcpv.application_id, 
            fcpv.concurrent_program_name, 
            fcpv.last_update_date, 
            fcpv.executable_application_id, 
            fcpv.executable_id,
            FCPV.USER_CONCURRENT_PROGRAM_NAME,
            fefv.EXECUTION_FILE_NAME,
            fefv.description,
            fefv.application_name,
            FCPV.EXECUTABLE_APPLICATION_ID,
            fcr.request_id,
            fcr.last_updated_by,
            fcr.STATUS_CODE,
            fcr.PHASE_CODE,
            fcr.PP_END_DATE,
            fcr.PP_START_DATE,
            fcr.EXP_DATE,
            fcr.CRM_TSTMP,
            fcr.ACTUAL_COMPLETION_DATE,
            fcr.ACTUAL_START_DATE,
            fcr.NUMBER_OF_ARGUMENTS,
            fcr.RESPONSIBILITY_ID,
            fcr.RESPONSIBILITY_APPLICATION_ID,
            fcr.HOLD_FLAG
FROM    FND_CONCURRENT_PROGRAMS_VL fcpv,
            FND_EXECUTABLES_FORM_V FEFV,
            FND_CONCURRENT_REQUESTS FCR
WHERE USER_CONCURRENT_PROGRAM_NAME like 'XXQGEN%DK'
and       fcpv.executable_id = fefv.executable_id
and       FCpv.CONCURRENT_PROGRAM_ID  = FCR.CONCURRENT_PROGRAM_ID;

select *
from fnd_executables_form_v;

select *
from FND_CONCURRENT_REQUESTS;

select *
from fnd_concurrent_programs_vl
where user_concurrent_program_name like'XXQGEN%DK';


select *
from XDO_DS_DEFINITIONS_B
where data_source_code like '%dk';

select *
from XDO_DS_DEFINITIONS_TL
where data_source_code like '%dk'
order by creation_date desc;

SELECT 
FROM FND_USER FU , PER_ALL_PEOPLE_F PAPF
WHERE FU.EMPLOYEE_ID = PAPF.PERSON_ID
AND FU.USER_NAME ='OPERATIONS';



select fu.user_name, fu.creation_date, papf.full_name, papf.sex, papf.nationality, papf.start_date, fu.end_date
from fnd_user fu, per_all_people_f papf
where fu.employee_id = papf.person_id
and    fu.user_name = 'OPERATIONS' ;