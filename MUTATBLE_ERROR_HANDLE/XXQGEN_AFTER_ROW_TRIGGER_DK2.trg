CREATE TABLE APPS.EMPLOYEES_DK2
(
  EMPLOYEE_ID        NUMBER,
  EMPLOYEE_NAME      VARCHAR2(100 BYTE),
  SALARY             NUMBER(10,2),
  PROMOTION_DATE     DATE,
  CREATION_DATE      DATE,
  LAST_UPDATED_DATE  DATE
);


SELECT *
FROM EMPLOYEES_DK2;


CREATE OR REPLACE TRIGGER xxqgen_after_row_trigger_dk2
AFTER INSERT OR UPDATE ON employees_dk2
FOR EACH ROW
DECLARE 
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    

    UPDATE EMPLOYEES_DK2
    SET SALARY = 100
    WHERE EMPLOYEE_ID = :NEW.EMPLOYEE_ID;
    
--    END IF;

COMMIT;
END xxqgen_after_row_trigger_dk2;


DROP TRIGGER XXQGEN_AFTER_ROW_TRIGGER_DK2;

INSERT INTO EMPLOYEES_DK2 (EMPLOYEE_ID, EMPLOYEE_NAME) VALUES (119, '6A');

SELECT *
FROM employees_dk2_update_log;


CREATE TABLE employees_dk2_update_log (
    employee_id NUMBER,
    log_timestamp DATE
);


CREATE OR REPLACE TRIGGER xxqgen_after_row_trigger_dk2
AFTER INSERT ON employees_dk2
FOR EACH ROW
DECLARE 
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO employees_dk2_update_log (employee_id, log_timestamp)
    VALUES (:NEW.EMPLOYEE_ID, SYSDATE);

    COMMIT;
END xxqgen_after_row_trigger_dk2;



MERGE INTO employees_dk2 e
USING (
    SELECT employee_id, MAX(log_timestamp) AS new_update_date
    FROM employees_dk2_update_log
    GROUP BY employee_id
) log
ON (e.employee_id = log.employee_id)
WHEN MATCHED THEN
    UPDATE SET e.last_updated_date = log.new_update_date;




CREATE OR REPLACE TRIGGER xxqgen_after_row_trigger_dk2
AFTER INSERT ON employees_dk2
FOR EACH ROW
DECLARE 
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    UPDATE employees_dk2
    SET last_updated_date = SYSDATE
    WHERE employee_id = :NEW.employee_id;

    COMMIT;
END xxqgen_after_row_trigger_dk2;
