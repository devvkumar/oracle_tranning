fnd_program.delete_program
fnd_program.delete_executable
fnd_program.program_exists 
fnd_program.executable_exists
apps.fnd_program.remove_from_group
;

-- delete program
begin

    apps.fnd_program.delete_program( 'XXQGEN_TEST_DK', 'PO');
   DBMS_OUTPUT.PUT_LINE('Program successfully deleted.');
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error deleting program: ' || SQLERRM);

end;
/

--done

begin

    fnd_program.delete_executable(
        executable_short_name           => 'XXQGEN_TEST_DK',
        application                             => 'PO'
    );

end;
/

-- done

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

-- done

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

-- done


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



SELECT DISTINCT UPCVL.CONCURRENT_PROGRAM_ID, 
            UPCVL.CONCURRENT_PROGRAM_NAME, 
            UPCVL.EXECUTABLE_APPLICATION_ID, 
            UPCVL.EXECUTABLE_ID,
            FEFV.EXECUTION_FILE_NAME,
            FEFV.DESCRIPTION,
            UPCVL.APPLICATION_ID,
            FAVL.APPLICATION_NAME,
            FAVL.APPLICATION_SHORT_NAME ,
            FCR.REQUEST_ID,
            SC.MEANING STATUS_CODE, 
            PC.MEANING PHASE_CODE,
            FCR.ACTUAL_COMPLETION_DATE - FCR.ACTUAL_START_DATE
FROM    FND_CONCURRENT_PROGRAMS_VL UPCVL, 
             FND_APPLICATION_VL FAVL, 
             FND_EXECUTABLES_FORM_V FEFV,
             FND_CONCURRENT_REQUESTS FCR,
            (SELECT LOOKUP_CODE, MEANING
             FROM FND_LOOKUP_VALUES
             WHERE LOOKUP_TYPE = 'CP_STATUS_CODE' AND LANGUAGE = 'US'
             AND ENABLED_FLAG = 'Y') SC,
             (SELECT LOOKUP_CODE, MEANING
              FROM FND_LOOKUP_VALUES
              WHERE LOOKUP_TYPE = 'CP_PHASE_CODE' AND LANGUAGE = 'US'
              AND ENABLED_FLAG = 'Y') PC
WHERE 1=1
AND     UPCVL.CONCURRENT_PROGRAM_NAME = 'XXQGEN_USER_DATA_PGK_DK'
AND     UPCVL.CONCURRENT_PROGRAM_ID  = FCR.CONCURRENT_PROGRAM_ID
AND     UPCVL.APPLICATION_ID = FAVL.APPLICATION_ID
AND     UPCVL.EXECUTABLE_ID = FEFV.EXECUTABLE_ID
AND     SC.LOOKUP_CODE = FCR.STATUS_CODE
AND     PC.LOOKUP_CODE = FCR.PHASE_CODE;