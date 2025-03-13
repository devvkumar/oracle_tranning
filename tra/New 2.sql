declare

    gc_error_flag varchar2(1) := 'E';
    gn_cp_request_id number;
    gc_error_message varchar2(300);
    gc_data_validation varchar2(20);
    LV_SESSION_ID NUMBER;

begin

    LV_SESSION_ID := apps.fnd_global.apps_initialize (1014384 ,50578,201);
    
    gn_cp_request_id :=
                fnd_request.submit_request (
                    application   => 'PO',
                    program       => 'XXQGEN_USER_DATA_PGK_DK'
                    );

    IF gn_cp_request_id = 0
            THEN
                gc_data_validation := gc_error_flag;
                gc_error_message := fnd_message.get;
           dbms_output.put_line(gn_cp_request_id);   
           
           dbms_output.put_line(LV_SESSION_ID);  
                
    ELSE
           dbms_output.put_line(gn_cp_request_id);   
           
           dbms_output.put_line(LV_SESSION_ID);    
    END IF;

end;
/

SELECT *
FROM FND_USER
WHERE USER_NAME = 'DKUMAR';

SELECT *
FROM FND_RESPONSIBILITY_VL
;


DECLARE
    gc_error_flag      VARCHAR2(1) := 'E';
    gn_cp_request_id   NUMBER;
    gc_error_message   VARCHAR2(300);
    gc_data_validation VARCHAR2(20);
    lv_session_id      NUMBER;

BEGIN
    -- Initialize session using FND_GLOBAL.APPS_INITIALIZE
    BEGIN
         apps.fnd_global.apps_initialize (user_id => 1014384, resp_id => 50578, resp_appl_id => 201);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
    END;
    -- Submit a concurrent request
    gn_cp_request_id :=
        fnd_request.submit_request(
            application => 'PO',
            program     => 'XXQGEN_USER_DATA_PGK_DK'
        );

    -- Check the request submission result
    IF gn_cp_request_id = 0 THEN
        gc_data_validation := gc_error_flag;
        gc_error_message := fnd_message.get;
        DBMS_OUTPUT.PUT_LINE('Concurrent Request Failed. Error Message: ' || gc_error_message);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Concurrent Request ID: ' || gn_cp_request_id);
    END IF;

    -- Print the session ID for verification
    DBMS_OUTPUT.PUT_LINE('Session ID: ' || lv_session_id);
END;
/


SELECT* -- application_id, application_short_name, application_name
FROM fnd_application
WHERE application_short_name = 'PO';


gn_cp_request_id :=
                fnd_request.submit_request (
                    application   => gc_application,
                    program       => gc_data_load_program,
                    argument1     => 1,
                    argument2     => 2
                    );

            COMMIT;

            fnd_file.put_line (
                fnd_file.LOG,
                   RPAD ('Loader Request ID.', 45, ' ')
                || ': '
                || gn_cp_request_id);
    IF gn_cp_request_id = 0
            THEN
                gc_data_validation := gc_error_flag;
                gc_error_message := fnd_message.get;
            ELSE
                /************************************************
                 * Checking request Status  for Completion.
                 ************************************************/

                IF gn_cp_request_id > 0
                THEN
                    LOOP
                        gc_conc_status :=
                            fnd_concurrent.wait_for_request (
                                request_id   => gn_cp_request_id,
                                interval     => gn_interval,
                                max_wait     => gn_max_wait,
                                phase        => gc_phase,
                                status       => gc_status,
                                dev_phase    => gc_dev_phase,
                                dev_status   => gc_dev_status,
                                MESSAGE      => gc_message);

                        EXIT WHEN    UPPER (gc_phase) = 'COMPLETED'
                                  OR UPPER (gc_status) IN
                                         ('CANCELLED', 'ERROR', 'TERMINATED');
                    END LOOP;

                    fnd_file.put_line (
                        fnd_file.LOG,
                           RPAD ('Loader Request Phase/Status.', 45, ' ')
                        || ': '
                        || gc_phase
                        || '-'
                        || gc_status);

                    IF (    UPPER (gc_phase) = 'COMPLETED'
                        AND UPPER (gc_status) = 'NORMAL')
                    THEN
                        gc_data_validation := gc_process_flag;
                        gc_error_message := NULL;
                    ELSE
                        gc_data_validation := gc_error_flag;
                        gc_error_message := SQLERRM;
                    END IF;
                END IF;
            END IF;
            
            
SELECT 
    fu.user_id,
    fu.user_name,
    TO_CHAR(FU.START_DATE, 'DD MON RRRR'),
    TO_CHAR(FU.END_DATE, 'DD MON RRRR'),
    papf.person_id,
    papf.full_name,
    PAPF.EMAIL_ADDRESS,
    PAPF.EMPLOYEE_NUMBER,
    TO_CHAR(PAPF.EFFECTIVE_START_DATE, 'DD MON RRRR'),
    TO_CHAR(PAPF.EFFECTIVE_END_DATE, 'DD MON RRRR')
FROM 
    fnd_user fu,
    per_all_people_f papf
WHERE
     fu.EMPLOYEE_id = papf.person_id
and rownum < 21;


SELECT *
FROM PER_ALL_PEOPLE_F;



SELECT 
    fu.employee_id,
   count(fu.employee_id)
FROM 
    fnd_user fu,
    per_all_people_f papf
WHERE
     fu.EMPLOYEE_id = papf.person_id
 group by fu.employee_id
 having  count(fu.employee_id) > 1;


select person_id
from per_all_people_f
;

select employee_id, count(user_id)
from fnd_user
group by employee_id
having  count(user_id) > 1;


SELECT 
    fu.user_id,
    fu.user_name,
    TO_CHAR(FU.START_DATE, 'DD MON RRRR')USER_START_DATE,
    TO_CHAR(FU.END_DATE, 'DD MON RRRR') USER_END_DATE,
    papf.person_id,
    papf.full_name,
    PAPF.EMAIL_ADDRESS,
    PAPF.EMPLOYEE_NUMBER,
    TO_CHAR(PAPF.EFFECTIVE_START_DATE, 'DD MON RRRR')EMP_START_DATE,
    TO_CHAR(PAPF.EFFECTIVE_END_DATE, 'DD MON RRRR') EMP_END_DATE
FROM 
    fnd_user fu,
    per_all_people_f papf
WHERE
     fu.EMPLOYEE_id = papf.person_id
GROUP BY FU.EMPLOYEE_ID
HAVING COUNT(FU.USER_ID) > 1

;/
SELECT USER_ID, START_DATE, END_DATE
FROM FND_USER
WHERE USER_NAME = 'DKUMAR'
AND      END_DATE IS NULL;