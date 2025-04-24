
CREATE or replace VIEW emp_source AS
SELECT employee_id,sal FROM employees
WHERE first_name LIKE 'E%';



CREATE OR REPLACE VIEW emp_target AS
SELECT employee_id , sal FROM employees
WHERE first_name LIKE 'I%';

SELECT *
FROM employees;


MERGE INTO emp_target et
USING emp_source es
ON (es.employee_id = et.employee_id)
WHEN MATCHED THEN
  UPDATE SET et.sal = es.sal
WHEN NOT MATCHED THEN
  INSERT  (employee_id, sal)
  VALUES (et.employee_id, et.sal);

MERGE INTO emp_target et
USING emp_source es
ON (es.employee_id = et.employee_id)
WHEN MATCHED THEN
  UPDATE SET et.sal = es.sal
WHEN NOT MATCHED THEN
  INSERT (employee_id, sal)
  VALUES (es.employee_id, es.sal);


DROP VIEW emp_target;
DROP VIEW emp_source;

select * from emp_target;

select * from emp_source