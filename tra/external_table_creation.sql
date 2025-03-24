create or replace directory dir_test as '/dir_test/';

drop table EMPLOYEES_EXT_DK;

select *
from employees_ext_dk;


CREATE TABLE employees_ext_dk
   (   employee_id    NUMBER,
    employee_name  VARCHAR2(100),
    designation    VARCHAR2(50)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY DIR_AD
      ACCESS PARAMETERS
      ( FIELDS TERMINATED BY ',')
      LOCATION
       ( 'employees_data.csv'
       )
    )
   REJECT LIMIT unlimited ;
   
select *
from DBA_DIRECTORIES;

select *
from dba_objects
where object_name like 'DBA%DIR%S';
   
SELECT *
FROM all_directories
WHERE directory_name = 'DIR_TEST';