begin
    
    fnd_user_pkg.createuser(
         x_user_name                            => 'DEV',
         x_owner                                   => null,
         x_unencrypted_password           => 'Apps@123',
        x_session_number                      => null,
        x_start_date                               => null,
        x_end_date                                => null,
        x_last_logon_date                       => null,
        x_description                              => null,
        x_password_date                        => null,
         x_password_accesses_left          => null,
  x_password_lifespan_accesses          => null,
  x_password_lifespan_days                 => null,
  x_employee_id                                 => null,
  x_email_address                               => null,
  x_fax                                               => null,
  x_customer_id                                 => null,
  x_supplier_id                                   => null
    );
    
    -- Debug message
    dbms_output.put_line('working fine');
    
exception
    when others then
        dbms_output.put_line('error in block : ' || sqlcode || ' - ' || sqlerrm);
end;
/



-- delete program
begin

    apps.fnd_program.delete_program( 'XXQGEN_TEST_DK', 'PO');
   DBMS_OUTPUT.PUT_LINE('Program successfully deleted.');
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error deleting program: ' || SQLERRM);

end;
/

begin

    fnd_program.delete_executable(
        executable_short_name           => 'XXQGEN_TEST_DK',
        application                             => 'PO'
    );

end;
/

begin

    apps.fnd_program.remove_from_group(
        program_short_name             => 'XXQGEN_TEST_DK',
        program_application              => 'PO',
        request_group                      => 'All Reports',
        group_application                 => 'Purchasing'
    );
    dbms_output.put_line('remove from group successfull');
exception
    when others then
        dbms_output.put_line('error in remove the group : ' || sqlcode || ' - ' || sqlerrm);

end;
/


BEGIN
   -- Output the result of the program_exists function
   DBMS_OUTPUT.PUT_LINE(
      'Program Exists: ' || 
      CASE 
         WHEN apps.fnd_program.program_exists(
                  program     => 'XXQGEN_TEST_DK',
                  application => 'PO' -- 'Purchasing' maps to 'PO' in short name
              ) THEN 'Yes'
         ELSE 'No'
      END
   );
END;
/



BEGIN
   -- Output the result of the program_exists function
   DBMS_OUTPUT.PUT_LINE(
      'Executable Exists: ' || 
      CASE 
         WHEN apps.fnd_program.executable_exists(
                  executable_short_name     => 'XXQGEN_TEST_DK',
                  application => 'PO' -- 'Purchasing' maps to 'PO' in short name
              ) THEN 'Yes'
         ELSE 'No'
      END
   );
END;
/



begin
    apps.fnd_program.add_to_group (program_short_name  =>'XXQGEN_TST_PRO_DK',
    -- 'XXQGEN_TEST_DATA_AD',
                                  program_application => 'PO',
                                  request_group       => 'All Reports',
                                  group_application   => 'Purchasing'                            
                                 );
             dbms_output.put_line('all dun');
                                 commit;
      exception
        when others then
        dbms_output.put_line(sqlcode||' '||sqlerrm);
end;
/

SELECT 
    FU.USER_ID,
    FU.USER_NAME , 
    PAPF.EMPLOYEE_NUMBER EMP_NUMBER , 
    PAPF.FULL_NAME ,
    PAPF.START_DATE
FROM 
    FND_USER FU , 
    PER_ALL_PEOPLE_F PAPF 
WHERE 
    FU.EMPLOYEE_ID = PAPF.PERSON_ID
AND 
    FU.USER_NAME ='OPERATIONS';

hr_operating_units;


begin

    apps.fnd_global.apps_initialize (ln_user_id,ln_responsibility_id,ln_application_id);
    
    fnd_program
    fnd_request
    fnd_submit
    fnd_concurrent

end;
/