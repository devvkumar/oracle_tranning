DECLARE

        l_approval_status VARCHAR2(150) := 'INCOMPLETE';
        ln_request        NUMBER;
        ln_interval       NUMBER := 5;
        ln_max_wait       NUMBER := 60;
        lc_phase          VARCHAR2(3000);
        lc_status         VARCHAR2(3000);
        lc_dev_phase      VARCHAR2(3000);
        lc_dev_status     VARCHAR2(3000);
        lc_message        VARCHAR2(3000);
        lc_conc_status    BOOLEAN;
        LN_ERROR_MESSAGE  VARCHAR2(5000);
    BEGIN
        fnd_global.apps_initialize(1016246, 50578, 201);
        mo_global.init('PO');
        mo_global.set_policy_context('S', 204);
        ln_request := fnd_request.submit_request(application => 'PO', program => 'XXQGEN_PO_REQ_IMP_DK');

        COMMIT;
        DBMS_OUTPUT.put_line( 'REQUEST TO UPLOAD REQUISITION LEGACY DATA START1: ' || ln_request);
        IF ln_request = 0 THEN
            DBMS_OUTPUT.put_line( 'REQUEST TO UPLOAD REQUISITION LEGACY DATA NOT SUBMITTED: ' || ln_request);
        ELSIF ln_request > 0 THEN
            LOOP
                lc_conc_status := fnd_concurrent.wait_for_request(request_id => ln_request, INTERVAL => ln_interval, max_wait => ln_max_wait
                , phase => lc_phase, status => lc_status,
                                                                 dev_phase => lc_dev_phase, dev_status => lc_dev_status, message => lc_message
                                                                 );

                EXIT WHEN upper(lc_phase) = 'COMPLETED' OR upper(lc_status) IN ( 'CANCELLED', 'ERROR', 'TERMINATED' );

            END LOOP;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERROR IN REQUISITION SUBMIT PROCESS: ' || SQLCODE || ' - ' || sqlerrm);
    END ;
    /

SELECT *
FROM XXQGEN_PO_REQ_HDR_STG_DK;

SELECT *
FROM XXQGEN_PO_REQ_LINE_STG_DK;

SELECT *
FROM XXQGEN_PO_REQ_LINE_STG_DK L,
         XXQGEN_PO_REQ_HDR_STG_DK H
WHERE L.HEADER_ID = H.HEADER_ID
--    AND L.STATUS = 'V'
--    AND H.STATUS = 'V';

TRUNCATE TABLE XXQGEN_PO_REQ_HDR_STG_DK;

TRUNCATE TABLE XXQGEN_PO_REQ_LINE_STG_DK;

SELECT *
FROM FND_USER
WHERE USER_NAME = 'DKUMAR';

SELECT *
FROM PO_REQUISITIONS_INTERFACE_ALL
WHERE CREATED_BY = 1016246;

SELECT *
FROM PO_LINES_ALL
WHERE CREATED_BY = 1016246;

SELECT SYSDATE
FROM DUAL;



--WHERE CREATED_BY  = 1016246;

SELECT *
FROM PO_INTERFACE_ERRORS
WHERE CREATED_BY = 1016246
    AND TRUNC(CREATION_DATE) = TRUNC(SYSDATE);

SELECT *
FROM PO_REQUISITION_LINES_ALL
WHERE CREATED_BY = 1016246;

SELECT *
FROM po_requisition_headers_all
WHERE CREATED_BY = 1016246;

SELECT *
FROM PO_LINE_TYPES
WHERE LINE_TYPE = 'Goods';

select *
from FND_CONCURRENT_PROGRAMS_VL;

XXQGEN_REQ_STG_PKG_AK

SELECT DISTINCT LINE_TYPE_ID
FROM PO_REQUISITION_LINES_ALL;

SELECT *
FROM FND_USER;

SELECT FULL_NAME
FROM PER_ALL_PEOPLE_F
WHERE PERSON_ID = 25;


SELECT *
FROM DBA_OBJECTS
WHERE OBJECT_TYPE = 'PACKAGE';

select text 
  from all_source a 
 where a.type = 'PACKAGE BODY' 
   and a.name = 'XXQGEN_P2P_INTERFACE_STG_AK' ;
   
   
   
-- order by line asc;


SELECT *
FROM FND_CONCURRENT_PROGRAMS_VL
WHERE CONCURRENT_PROGRAM_NAME = 'Import Exceptions Report';