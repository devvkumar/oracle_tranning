CREATE OR REPLACE PACKAGE BODY XXQGEN_TEST_DK AS

    PROCEDURE main (
        x_errbuff OUT NOCOPY VARCHAR2,  -- Error buffer
        x_retcode OUT NOCOPY VARCHAR2,  -- Return code
        P_REQUEST_ID IN NUMBER,        -- Request ID (Input)
        P_STRING IN VARCHAR2           -- String (Input)
    ) IS
    BEGIN
        -- Logging the Request ID and String to FND File
        FND_FILE.PUT_LINE(FND_FILE.LOG, 'REQUEST ID: ' || P_REQUEST_ID);
        FND_FILE.PUT_LINE(FND_FILE.LOG, 'STRING: ' || P_STRING);
        
        -- Additional functionality can be placed here if required.

    EXCEPTION
        WHEN OTHERS THEN
            -- Handling any unexpected errors and populating the error buffer
            x_errbuff := 'ERROR IN MAIN BLOCK : ' || SQLCODE || ' - ' || SQLERRM;
            x_retcode := '0';  -- Indicating failure through return code

            -- You can also log the error to the file for debugging
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR: ' || SQLERRM);
            -- Optionally raise the error again if necessary:
            -- RAISE;

    END main;

END XXQGEN_TEST_DK;
/


CREATE OR REPLACE PACKAGE  XXQGEN_TEST_DK AS
    PROCEDURE main(
        x_errbuff OUT NOCOPY VARCHAR2,
        x_retcode OUT NOCOPY VARCHAR2,
        p_request_id    in number,
        p_string            in varchar2
    );
END XXQGEN_TEST_DK;
/


begin
    apps.fnd_program.add_to_group (program_short_name  =>'XXQGEN_TEST_DK',
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

--XXQGEN_USER_DETAIL_NB
--XXQGEN_USER_DATA_PGK_DK
