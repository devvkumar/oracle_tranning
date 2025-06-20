SELECT *
FROM PER_ALL_PEOPLE_F
WHERE 1=1
    AND SYSDATE BETWEEN TRUNC(EFFECTIVE_START_DATE) AND TRUNC(EFFECTIVE_END_DATE)
    AND (CURRENT_EMPLOYEE_FLAG = 'Y'
            OR
            CURRENT_NPW_FLAG = 'Y')
   ---- AND PERSON_ID = 377;
    
    
SELECT ASSIGNMENT_ID,
            EFFECTIVE_START_DATE,
            EFFECTIVE_END_DATE,
            BUSINESS_GROUP_ID,
            RECRUITER_ID,
            GRADE_ID,
            POSITION_ID,
            JOB_ID,
            PAYROLL_ID,
            LOCATION_ID,
            SUPERVISOR_ID,
            ORGANIZATION_ID,
           -- DEFAULT_CODE_COMBINATION_ID,
            PERSON_ID,
            PEOPLE_GROUP_ID,
            ASSIGNMENT_TYPE,
            APPLICATION_ID,
            ASSIGNMENT_NUMBER,
            EMPLOYMENT_CATEGORY,
            PROBATION_PERIOD,
            PERIOD_OF_SERVICE_ID,
            CONTRACT_ID,
            COLLECTIVE_AGREEMENT_ID,
            NOTICE_PERIOD,
            EMPLOYEE_CATEGORY,
            WORK_AT_HOME,
            APPLICANT_RANK,
            VENDOR_ID,
            VENDOR_EMPLOYEE_NUMBER,
            VENDOR_ASSIGNMENT_NUMBER,
            ASSIGNMENT_CATEGORY,
            PROJECT_TITLE,
            SUPERVISOR_ASSIGNMENT_ID,
            VENDOR_SITE_ID,
            PO_HEADER_ID,
            PO_LINE_ID
FROM PER_ALL_ASSIGNMENTS_F
WHERE 1=1
AND SYSDATE BETWEEN TRUNC(EFFECTIVE_START_DATE) AND TRUNC(EFFECTIVE_END_DATE)
--    AND PERSON_ID = 377;
    
SELECT *
FROM PER_PERSON_TYPE_USAGES_F
WHERE PERSON_ID = 377
    AND PERSON_TYPE_ID = 95;
    
SELECT *
FROM GL_CODE_COMBINATIONS;
    
SELECT *
FROM PER_PERSON_TYPES
WHERE PERSON_TYPE_ID = 95;
    
SELECT *
FROM PO_LOOKUP_CODES
WHERE LOOKUP_CODE = 'FR';

SELECT *
FROM HR_ALL_ORGANIZATION_UNITS
WHERE ORGANIZATION_ID = 653;



SELECT *
FROM PER_BUSINESS_GROUPS
WHERE BUSINESS_GROUP_ID = 626;

SELECT *
FROM PER_ALL_ASSIGNMENTS_F
WHERE NOTICE_PERIOD IS NOT NULL;

SELECT *
FROM PER_ADDRESSES
WHERE PERSON_ID = 377;

SELECT *
FROM DBA_OBJECTS
WHERE OBJECT_TYPE = 'TABLE'
AND OBJECT_NAME LIKE '%LOOKUP_CODES%'

SELECT *
FROM FWK_TBX_LOOKUP_CODES_B
WHERE LOOKUP_CODE = 'H'
AND LOOKUP_TYPE LIKE '%%';

SELECT *
FROM PER_ALL_PEOPLE_F
WHERE 1=1
    AND SYSDATE BETWEEN TRUNC(EFFECTIVE_START_DATE) AND TRUNC(EFFECTIVE_END_DATE)
    AND (CURRENT_EMPLOYEE_FLAG = 'Y'
            OR
            CURRENT_NPW_FLAG = 'Y')
    AND PERSON_ID = 433;

SELECT *
FROM PER_JOBS
WHERE JOB_ID = 204;

SELECT DISTINCT SOURCE_LANG
FROM PER_JOBS_TL;

SELECT USERENV('LANGUAGE')
FROM DUAL;

SELECT *
FROM PER_GRADES
WHERE GRADE_ID = 62;

SELECT *
FROM HR_LOCATIONS
WHERE LOCATION_ID = 431;

SELECT *
FROM PER_ALL_POSITIONS
WHERE POSITION_ID = 511;