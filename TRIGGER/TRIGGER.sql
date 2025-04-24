--Trigger in plsql

-- Table Creation for Trigger in PLSQL


CREATE TABLE employees_dk (
    employee_id NUMBER PRIMARY KEY,
    employee_name VARCHAR2(100),
    salary NUMBER(10, 2),
    promotion_date DATE
);

-- insert two data in employees_dk table

INSERT INTO employees_dk (employee_id, employee_name, salary, promotion_date)
VALUES (1, 'John Doe', 50000, NULL);

INSERT INTO employees_dk (employee_id, employee_name, salary, promotion_date)
VALUES (2, 'Jane Smith', 60000, NULL);

-----------------------------------------------------------------------------------------------------------


------------------------------- Create Trigger on EMPLOYEES_DK -----------------------------------
CREATE OR REPLACE TRIGGER xxqgen_update_sal_on_promot_dk
BEFORE UPDATE OF promotion_date ON employees_dk
FOR EACH ROW
BEGIN
    IF :NEW.promotion_date IS NOT NULL THEN
        :NEW.salary := :OLD.salary * 1.1;
    END IF;
END;
/

------------------------------------------------------------------------------------------------------------


-- check old data
select * from employees_dk;

-- use update command to execute trigger
update employees_dk
set promotion_date = sysdate
where employee_id = 1;

-- to verify the updated data
select *
from employees_dk;

----------------------------- Adding New Column of Creation Date ------------------------------
alter table employees_dk
add creation_date date;

alter table employees_dk
add last_updated_date date;
----------------------------------------------------------------------------------------------------------

-------------------------------- UDPATE LAST_UPDATED_DATE -----------------------------------

CREATE OR REPLACE TRIGGER xxqgen_update_date_promot_dk
AFTER INSERT ON EMPLOYEES_DK
FOR EACH ROW
BEGIN
   UPDATE EMPLOYEES_DK
   SET LAST_UPDATED_DATE = SYSDATE + 1
   WHERE EMPLOYEE_ID = :NEW.EMPLOYEE_ID;
END;
/

---------------------------------------------------------------------------------



-------------------------- Types of Triggers -----------------------------
-- 1. Row-Level Triggers
--      a. Before Row Trigger

create or replace trigger xxqgen_set_creation_date_dk
before insert on employees_dk
for each row 
begin
    :new.creation_date := sysdate;
end;
/
            -- example 
            
            select *
            from employees_dk;
            
            INSERT INTO employees_dk (employee_id, employee_name, salary, promotion_date)
            VALUES (7, 'After Row Trigger again 2', 60000, NULL);
            
            select *
            from employees_dk;

--      b. After Row Trigger

create or replace trigger xxqgen_after_row_trigger_dk
after insert on employees_dk
for each row
begin  
    dbms_output.put_line(:new.last_updated_date || 'working!!');            -- not working don't know why
end;
/



