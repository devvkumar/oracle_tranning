select * from dba_objects
where object_name like 'PO_HEADERS%'
AND (OBJECT_TYPE  LIKE 'T%' OR OBJECT_TYPE LIKE 'SY%')
AND OWNER IN ('APPS', 'PO')
AND OBJECT_ID IN (41472,1945578);

 apps.fnd_program.add_to_group (program_short_name  => l_program_short_name,
                                                  program_application => l_program_application,                                  
                                                  request_group       => l_request_group,                                  
                                                  group_application   => l_group_application                            
                                 );  

  TRUNC((rq.actual_completion_date – rq.actual_start_date) * 24)
       || ‘ Hour ‘
       || MOD(
             TRUNC(
                (rq.actual_completion_date – rq.actual_start_date) * 1440),
             60)
       || ‘ Min ‘
       || MOD(
             TRUNC(
                (rq.actual_completion_date – rq.actual_start_date) * 86400),
             60)
       || ‘ Sec’
          “Time Taken”
SELECT SYS_CONTEXT ('USERENV', 'DB_NAME')


SELECT SYS_CONTEXT ('USERENV', 'DB_NAME') 
            db_name INTO gc_database FROM DUAL


/*
fnd_user                     ------> user information
PER_ALL_PEOPLE_F            ------> connected user infromation
FND_USER_RESP_GROUPS_direct ------> contains responsiblity details
FND_RESPONSIBILITY            ------> contains responsiblity id, key (table)
FND_RESPONSIBILITY_VL        ------> contains aplications id, responsiblity id, key and name (view)
FND_APPLICATION_VL            ------> contains aplications id, short name, name and product code (view)
fnd_user_pkg.createuser

*/

;

select *
from per_all_people_f;

select user_name, user_id
from fnd_user;

select user_name, user_id, start_date, end_date, employee_id
    from fnd_user
    where lower(user_name) = 'operations';
    
select employee_number, npw_number, current_employee_flag, current_npw_flag, person_id, effective_start_date, effective_end_date, start_date, BUSINESS_GROUP_ID, first_name, last_name, full_name
from per_all_people_f;

select  fu.user_name, 
          fu.user_id, 
          fu.start_date, 
          fu.end_date, 
          fu.employee_id,  
          papf.employee_number, 
          papf.npw_number, 
          papf.current_employee_flag, 
          papf.current_npw_flag, 
          papf.person_id, 
          papf.effective_start_date, 
          papf.effective_end_date, 
          papf.start_date, 
          papf.BUSINESS_GROUP_ID, 
          papf.first_name, 
          papf.last_name, 
          papf.full_name
from per_all_people_f papf, 
        fnd_user fu
where 1=1
    and fu.employee_id = &id
    and fu.employee_id = PAPF.person_id;
    
    
    
select *
from fnd_users;