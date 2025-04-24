DECLARE
    TYPE t_id_list IS TABLE OF employees.employee_id%TYPE;
    l_ids t_id_list;

    e_invalid_id EXCEPTION;
BEGIN
    SELECT employee_id
    BULK COLLECT INTO l_ids
    FROM employees;

    FOR i IN 1 .. l_ids.COUNT LOOP
        IF l_ids(i) IS NULL THEN
            RAISE e_invalid_id;
        END IF;
    END LOOP;

EXCEPTION
    WHEN e_invalid_id THEN
        DBMS_OUTPUT.PUT_LINE('Invalid employee ID found!');
END;


-------------------------------------------------------------------------------------------------------

DECLARE
    TYPE t_id_list IS TABLE OF employees.employee_id%TYPE;
    l_ids t_id_list;

    e_bulk_errors EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_bulk_errors, -24381); -- For catching bulk exceptions

BEGIN
    SELECT employee_id
    BULK COLLECT INTO l_ids
    FROM employees;

    FORALL i IN l_ids.FIRST .. l_ids.LAST SAVE EXCEPTIONS
        UPDATE employees
        SET salary = salary + 1000
        WHERE employee_id = l_ids(i);

EXCEPTION
    WHEN e_bulk_errors THEN
        FOR i IN 1 .. SQL%BULK_EXCEPTIONS.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('Error on record ' || SQL%BULK_EXCEPTIONS(i).ERROR_INDEX || 
                                 ': ' || SQLERRM(SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
        END LOOP;
END;


------------------------------------------------------------------------------------------------------------------


DECLARE
    TYPE t_emp_list IS TABLE OF employees%ROWTYPE;
    l_emps t_emp_list;

    e_no_data_found EXCEPTION;
BEGIN
    SELECT * BULK COLLECT INTO l_emps
    FROM employees
    WHERE department_id = 9999;

    IF l_emps.COUNT = 0 THEN
        RAISE e_no_data_found;
    END IF;

EXCEPTION
    WHEN e_no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('No employees found for the given department!');
END;


--------------------------------------------------------

BEGIN
            FORALL indx IN 1 .. pd_tbl.COUNT SAVE EXCEPTIONS
               UPDATE apps.xxmtz_fs_to_otl_tc_intf
                  SET status                                = pd_tbl ( indx ).status
                    , error_message                         = pd_tbl ( indx ).error_message
                WHERE debrief_line_id = pd_tbl ( indx ).debrief_line_id
                      AND request_id = p_request_id
                      AND business_process_id = p_process_id
                      AND org_id = gn_org_id
                      AND file_type = 'PD';
         EXCEPTION
            WHEN ge_bulk_errors
            THEN
               gn_error_count                        := SQL%BULK_EXCEPTIONS.COUNT;

               FOR indx IN 1 .. gn_error_count
               LOOP
                  fnd_file.put_line ( fnd_file.LOG
                                    ,     'Error: '
                                      || indx
                                      || ' Array Index: '
                                      || SQL%BULK_EXCEPTIONS ( indx ).ERROR_INDEX
                                      || ' Message: '
                                      || SQLERRM ( -SQL%BULK_EXCEPTIONS ( indx ).ERROR_CODE ) );
               END LOOP;
         END;
         
         
         
DECLARE
    CURSOR CUR_HEAD IS
        SELECT * FROM PO_HEADERS_ALL
        WHERE ROWNUM < 100
        AND PO_HEADER_ID = 0;
    
    TYPE CUR_HEAD_TYPE IS TABLE OF PO_HEADERS_ALL%ROWTYPE INDEX BY PLS_INTEGER;
    PO_TBL CUR_HEAD_TYPE;
    
    GN_ERROR_COUNT NUMBER;
    
BEGIN
    OPEN CUR_HEAD;
    
    LOOP
        FETCH CUR_HEAD BULK COLLECT INTO PO_TBL LIMIT 100;
        
        EXIT WHEN PO_TBL.COUNT = 0;
        
        -- Loop for processing each record
        FOR I IN 1 .. PO_TBL.COUNT LOOP
            BEGIN
                DBMS_OUTPUT.PUT_LINE('HEADER_ID : ' || PO_TBL(I).PO_HEADER_ID);
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('ERROR IN FOR LOOP : ' || SQLERRM || ' - ' || SQLCODE );
            END;
        END LOOP;
        
        -- FORALL insert with exception capture
        BEGIN
            FORALL I IN 1 .. PO_TBL.COUNT SAVE EXCEPTIONS
                INSERT INTO DUMMY_PO_HEADER_DK (HEADER_ID) VALUES (PO_TBL(I).SEGMENT1);  
            
        EXCEPTION
            WHEN OTHERS THEN
                GN_ERROR_COUNT := SQL%BULK_EXCEPTIONS.COUNT;
                
                FOR I IN 1 .. GN_ERROR_COUNT LOOP
                    DBMS_OUTPUT.PUT_LINE(I || 
                                         ' : ARRAY INDEX | ' || SQL%BULK_EXCEPTIONS(I).ERROR_INDEX || 
                                         ' : ERROR MESSAGE | ' || SQLERRM(-SQL%BULK_EXCEPTIONS(I).ERROR_CODE));
                END LOOP;
        END;
        
    END LOOP;
    
    CLOSE CUR_HEAD;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR IN ANOMONOUS BLOCK : ' || SQLCODE || ' - ' || SQLERRM );
    
END;



SET SERVEROUTPUT ON;

CREATE TABLE DUMMY_PO_HEADER_DK (
    HEADER_ID           NUMBER
);

SELECT *
FROM DUMMY_PO_HEADER_DK;

DROP TABLE DUMMY_PO_HEADER_DK;

TRUNCATE TABLE DUMMY_PO_HEADER_DK;