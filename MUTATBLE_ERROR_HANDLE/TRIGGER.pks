SELECT *
FROM EMPLOYEES_DK;

INSERT INTO EMPLOYEES_DK VALUES (7, '7TH PERSON', NULL, NULL, NULL, NULL);

Select *
FROM USER_TRIGGERS
WHERE TABLE_NAME = 'EMPLOYEES_DK';


select text from user_source where name='&trig_name' and type='TRIGGER';

select dbms_metadata.get_ddl('TRIGGER','XXQGEN_AFTER_ROW_TRIGGER_DK') from dual


CREATE OR REPLACE trigger xxqgen_after_row_trigger_dk
after insert on employees_dk
for each row
begin
    UPDATE EMPLOYEES_DK
    SET LAST_UPDATED_DATE = SYSDATE
    WHERE EMPLOYEE_ID = :NEW.EMPLOYEE_ID;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR IN XXQGEN_AFTER_ROW_TRIGGER_DK : ' || SQLCODE || ' - ' || SQLERRM );
end xxqgen_after_row_trigger_dk;


CREATE OR REPLACE TRIGGER xxqgen_after_row_trigger_dk
AFTER INSERT ON employees_dk
FOR EACH ROW
BEGIN
    -- Directly set the LAST_UPDATED_DATE during the INSERT, rather than an additional UPDATE.
    -- If that's not possible, continue with your logic.

    -- Example: Assuming the INSERT is being handled elsewhere but you want to update after insert
    -- UPDATE EMPLOYEES_DK
    -- SET LAST_UPDATED_DATE = SYSDATE
    -- WHERE EMPLOYEE_ID = :NEW.EMPLOYEE_ID;
    
    -- If you still want to keep the update, use the following logic:
    UPDATE EMPLOYEES_DK
    SET LAST_UPDATED_DATE = SYSDATE
    WHERE EMPLOYEE_ID = :NEW.EMPLOYEE_ID;

EXCEPTION
    WHEN OTHERS THEN
        -- Consider using a logging table instead of DBMS_OUTPUT
        
        VALUES (SQLCODE, SQLERRM, 'xxqgen_after_row_trigger_dk', SYSDATE);
        -- Optionally, re-raise the exception if needed
        RAISE;
END xxqgen_after_row_trigger_dk;