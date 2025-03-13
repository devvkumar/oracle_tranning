CREATE OR REPLACE PACKAGE BODY xxqgen_user_data_pkg_dk AS
    PROCEDURE main(
        x_errbuff OUT NOCOPY VARCHAR2,
        x_retcode OUT NOCOPY VARCHAR2
    ) IS

        CURSOR cur_resp_dtl IS
            SELECT 
                frv.application_id, 
                frv.responsibility_id, 
                frv.responsibility_name, 
                frv.description, 
                frv.responsibility_key, 
                fa.application_short_name
            FROM 
                fnd_responsibility_vl frv, fnd_application fa 
           WHERE
                frv.application_id = fa.application_id;
                
                

    BEGIN
       FOR rec_resp_dtl IN cur_resp_dtl LOOP
            DECLARE
                p_msg VARCHAR2(2000);
            BEGIN
            
                P_HEADING := '| ' ||  RPAD('RESPONSIBILITY ')
                p_msg := 'Responsibility Name: ' || rec_resp_dtl.responsibility_name
                        || ', Application: ' || rec_resp_dtl.application_short_name
                        || ', Description: ' || rec_resp_dtl.description;

                FND_FILE.PUT_LINE(FND_FILE.LOG, p_msg);

                FND_FILE.PUT_LINE(
                    FND_FILE.OUTPUT,
                    RPAD('Responsibility Details', 45, ' ') || ': ' || p_msg
                );
            END;
        END LOOP;

        -- Example completion message
        x_errbuff := 'Procedure completed successfully.';
        x_retcode := '0';
    END main;
END xxqgen_user_data_pkg_dk;
/
XXQGEN_EMP_load_stg_PKG

xxqgen_user_data_pkg_dk

xxqgen_emp_load_stg_pkg