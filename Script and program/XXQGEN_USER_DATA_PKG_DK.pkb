CREATE OR REPLACE PACKAGE BODY XXQGEN_USER_DATA_PGK_DK AS
    PROCEDURE main(
        x_errbuff OUT NOCOPY VARCHAR2,
        x_retcode OUT NOCOPY VARCHAR2
    ) IS
        /*
        Relevant tables and their purpose:
        - FND_USER: User information.
        - PER_ALL_PEOPLE_F: Connected user information.
        - FND_USER_RESP_GROUPS_DIRECT: Contains responsibility details.
        - FND_RESPONSIBILITY: Contains responsibility ID and key (table).
        - FND_RESPONSIBILITY_VL: Contains application ID, responsibility ID, key, and name (view).
        - FND_APPLICATION_VL: Contains application ID, short name, name, and product code (view).
        FND CON PRO VL
        FND LOOKIP VALUE
        */
        
        P_DATA                      VARCHAR2 (500)  := NULL;
        P_HEADER                   VARCHAR2  (500):= NULL;

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
         /*       
        CURSOR cur_all_resp_dtl IS
            SELECT 
                fu.user_id,
                fu.user_name user_name,
                fu.start_date,
                fu.end_date,
                fu.description,
                papf.person_id,
                NVL (papf.EMPLOYEE_NUMBER, papf.NPW_NUMBER) employee_id,
                papf.full_name,
                papf.EFFECTIVE_START_DATE,
                papf.EFFECTIVE_END_DATE,
                papf.CURRENT_EMPLOYEE_FLAG,
                papf.CURRENT_NPW_FLAG,
                papf.EMAIL_ADDRESS,
                frv.RESPONSIBILITY_NAME,
                fav.APPLICATION_NAME,
                frv.RESPONSIBILITY_KEY,
                frv.DESCRIPTION,
                frv.START_DATE
            FROM
                fnd_user fu, 
                per_all_people_f papf,
                FND_USER_RESP_GROUPS_direct furg,
                FND_RESPONSIBILITY_VL frv,
                FND_APPLICATION_VL fav
            WHERE 
                furg.responsibility_id = frv.RESPONSIBILITY_ID
                AND fu.user_id = furg.user_id
                AND frv.APPLICATION_ID = fav.APPLICATION_ID
                AND fu.employee_id = papf.person_id 
                AND TRIM(SYSDATE) BETWEEN fu.start_date
                                       AND NVL(fu.end_date, SYSDATE + 1)
                AND TRIM(SYSDATE) BETWEEN papf.EFFECTIVE_START_DATE
                                       AND papf.EFFECTIVE_END_DATE
                AND (papf.CURRENT_EMPLOYEE_FLAG = 'Y' OR papf.CURRENT_NPW_FLAG = 'Y');
    */
    
    CURSOR cur_all_resp_dtl IS
    SELECT 
        fu.user_id,
        fu.user_name user_name,
        fu.start_date AS user_start_date,
        fu.end_date AS user_end_date,
        fu.description AS user_description,
        papf.person_id,
        NVL(papf.EMPLOYEE_NUMBER, papf.NPW_NUMBER) AS employee_id,
        papf.full_name,
        papf.EFFECTIVE_START_DATE AS person_effective_start_date,
        papf.EFFECTIVE_END_DATE AS person_effective_end_date,
        papf.CURRENT_EMPLOYEE_FLAG,
        papf.CURRENT_NPW_FLAG,
        papf.EMAIL_ADDRESS,
        frv.RESPONSIBILITY_NAME,
        fav.APPLICATION_NAME,
        frv.RESPONSIBILITY_KEY,
        frv.DESCRIPTION AS responsibility_description,
        frv.START_DATE AS responsibility_start_date
    FROM
        fnd_user fu, per_all_people_f papf 
        , FND_USER_RESP_GROUPS_direct furg 
        , FND_RESPONSIBILITY_VL frv 
        , FND_APPLICATION_VL fav 
    WHERE  fu.employee_id = papf.person_id
    AND    fu.user_id = furg.user_id
    AND     furg.responsibility_id = frv.RESPONSIBILITY_ID
    AND    frv.APPLICATION_ID = fav.APPLICATION_ID
    AND
        TRIM(SYSDATE) BETWEEN fu.start_date AND NVL(fu.end_date, SYSDATE + 1)
        AND TRIM(SYSDATE) BETWEEN papf.EFFECTIVE_START_DATE AND papf.EFFECTIVE_END_DATE
        AND (papf.CURRENT_EMPLOYEE_FLAG = 'Y' OR papf.CURRENT_NPW_FLAG = 'Y');
    BEGIN
    
     P_HEADER    :=  '| ' ||  RPAD('USER ID', 10) || '| ' || RPAD('USER NAME', 25) || '| ' || RPAD('START DATE', 10) || '| ' || RPAD('END DATE', 10) || '| ' || RPAD('DESCRIPTION', 40) ||
                              '| ' || RPAD('USER EMPLOYEE ID', 10) || '| ' || RPAD('FULL NAME', 50) || '| ' || RPAD('RESPONSIBILITY NAME', 35) || '| ' || RPAD('APPLICATION NAME', 25) || 
                              '| ' || RPAD('RESPONSIBILITY KEY', 15) || '|';
     FND_FILE.PUT_LINE(FND_FILE.LOG, P_HEADER);
     FND_FILE.PUT_LINE(FND_FILE.output, P_HEADER);
     
        -- Loop through CUR_ALL_RESP_DTL and print all data
        FOR rec_all_resp_dtl IN cur_all_resp_dtl LOOP
        
            P_DATA :=  '| ' ||  RPAD( rec_all_resp_dtl.user_id, 10) || '| ' || RPAD(rec_all_resp_dtl.user_name, 25) || '| ' || RPAD(rec_all_resp_dtl.user_start_date, 10) || '| ' || RPAD(rec_all_resp_dtl.user_end_date, 10) || '| ' || RPAD(rec_all_resp_dtl.user_description, 40) ||
                              '| ' || RPAD(rec_all_resp_dtl.employee_id, 10) || '| ' || RPAD(rec_all_resp_dtl.full_name, 50) || '| ' || RPAD(rec_all_resp_dtl.responsibility_name, 35) || '| ' || RPAD(rec_all_resp_dtl.application_name, 25) || 
                              '| ' || RPAD(rec_all_resp_dtl.responsibility_key, 15) || '|';
                              
            FND_FILE.PUT_LINE(FND_FILE.LOG, P_DATA);
            FND_FILE.PUT_LINE(FND_FILE.output, P_DATA);
            
                              
        /*
            -- Construct a message for logging
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'User ID: ' || rec_all_resp_dtl.user_id);
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'User Name: ' || rec_all_resp_dtl.user_name);
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'Start Date: ' || TO_CHAR(rec_all_resp_dtl.start_date, 'DD-MON-YYYY'));
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'End Date: ' || TO_CHAR(rec_all_resp_dtl.end_date, 'DD-MON-YYYY'));
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'Description: ' || rec_all_resp_dtl.description);
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'Employee ID: ' || rec_all_resp_dtl.employee_id);
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'Full Name: ' || rec_all_resp_dtl.full_name);
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'Effective Start Date: ' || TO_CHAR(rec_all_resp_dtl.effective_start_date, 'DD-MON-YYYY'));
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'Effective End Date: ' || TO_CHAR(rec_all_resp_dtl.effective_end_date, 'DD-MON-YYYY'));
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'Email Address: ' || rec_all_resp_dtl.email_address);
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'Responsibility Name: ' || rec_all_resp_dtl.responsibility_name);
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'Application Name: ' || rec_all_resp_dtl.application_name);
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'Responsibility Key: ' || rec_all_resp_dtl.responsibility_key);
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'Responsibility Description: ' || rec_all_resp_dtl.description);
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'Responsibility Start Date: ' || TO_CHAR(rec_all_resp_dtl.start_date, 'DD-MON-YYYY'));
            FND_FILE.PUT_LINE(FND_FILE.LOG, '-------------------------------------------------------');
            */
        END LOOP;

        x_errbuff := 'Procedure completed successfully.';
        x_retcode := '0';

    EXCEPTION
        WHEN OTHERS THEN
            x_errbuff := 'ERROR IN MAIN BLOCK : ' || SQLCODE || ' - ' || SQLERRM;
            x_retcode := '0';
    END main;
END XXQGEN_USER_DATA_PGK_DK;
/





--XXQGEN_USER_DETAIL_NB
--XXQGEN_USER_DATA_PGK_DK