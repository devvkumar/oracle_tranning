CREATE OR REPLACE PACKAGE BODY XXQGEN_UTL_OUTBOND_DK
AS
    PROCEDURE BOC_UTL_DATA
    IS
        CURSOR CUR_BOC_DATA 
        IS
        SELECT aca.check_number
                   ,aca.currency_code
                   ,aca.amount
                   ,ce.bank_account_name payer_account_name
                   ,ce.bank_account_num payer_account_number
                   ,ieba.bank_account_num payee_bank_account_number
                   ,ieba.bank_account_name payee_bank_account_name
                   ,ieba.bank_name payee_bank_name
                   ,ieba.branch_number payee_branch_number
        FROM ap_checks_all aca
            ,iby_payments_all ipa
            ,ce_bank_accounts ce
            ,iby_payee_all_bankacct_v ieba
        WHERE     1 = 1
              AND aca.external_bank_account_id = ieba.ext_bank_account_id
              AND ipa.internal_bank_account_id = ce.bank_account_id
              AND aca.payment_id = ipa.payment_id
--              AND aca.check_id > 13213897
        ;
        
        L_FILE_NAME             VARCHAR2(100);
        L_FILE                       UTL_FILE.FILE_TYPE;
        L_HEADER                 VARCHAR2(500)          := RPAD('CHECK_NUMBER',25) || 
                                                                             '| ' || RPAD('CURRENCY_CODE',25) || 
                                                                             '| ' || RPAD('AMOUNT',25) || 
                                                                             '| ' || RPAD('PAYER_ACCOUNT_NAME',35) || 
                                                                             '| ' || RPAD('PAYER_ACCOUNT_NUMBER', 35) ||
                                                                             '| ' || RPAD('PAYEE_BANK_ACCOUNT_NUMBER', 35) ||
                                                                             '| ' || RPAD('PAYEE_BANK_ACCOUNT_NAME',35) ||
                                                                             '| ' || RPAD('PAYEE_BANK_NAME', 25) || 
                                                                             '| ' || RPAD('PAYEE_BRANCH_NUMBER', 25);
        
    BEGIN
    
        FND_FILE.PUT_LINE(FND_FILE.LOG, GC_CONC_ID);
        
        L_FILE_NAME := 'XXQGEN_BOC_TEXT_' || TO_CHAR(SYSDATE,'DD_MM_RRRR') || '_' || GC_CONC_ID;
        L_FILE := UTL_FILE.FOPEN(GC_LOCATION, L_FILE_NAME, 'W');
       
                                     
        
--        FND_FILE.PUT_LINE(FND_FILE.LOG, 'L_FILE : ' || L_FILE);
        
        UTL_FILE.PUT_LINE(L_FILE, L_HEADER );
        
        FOR REC_BOC_DATA IN CUR_BOC_DATA 
        LOOP
            UTL_FILE.PUT_LINE(L_FILE, RPAD(REC_BOC_DATA.CHECK_NUMBER,25) || 
                                                             '| ' || RPAD(REC_BOC_DATA.CURRENCY_CODE,25) || 
                                                             '| ' || RPAD(REC_BOC_DATA.AMOUNT,25) || 
                                                             '| ' || RPAD(REC_BOC_DATA.PAYER_ACCOUNT_NAME,35) || 
                                                             '| ' || RPAD(REC_BOC_DATA.PAYER_ACCOUNT_NUMBER, 35) ||
                                                             '| ' || RPAD(REC_BOC_DATA.PAYEE_BANK_ACCOUNT_NUMBER, 35) ||
                                                             '| ' || RPAD(REC_BOC_DATA.PAYEE_BANK_ACCOUNT_NAME,35) ||
                                                             '| ' || RPAD(REC_BOC_DATA.PAYEE_BANK_NAME, 25) || 
                                                             '| ' || RPAD(REC_BOC_DATA.PAYEE_BRANCH_NUMBER, 25));
        END LOOP;
        
--        UTL_FILE.FCLOSE;
        
--        UTL_FILE.PUT_LINE()
        FND_FILE.PUT_LINE(FND_FILE.LOG, 'WORKING');
    EXCEPTION
        WHEN OTHERS THEN 
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN BOC_UTL_DATA : ' || SQLCODE || ' - ' || SQLERRM);
    END BOC_UTL_DATA;
    
    PROCEDURE MAIN(ERRBUF OUT VARCHAR, RETCODE OUT VARCHAR)
    IS
    BEGIN
        BOC_UTL_DATA;
    EXCEPTION
        WHEN OTHERS THEN
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN MAIN : ' || SQLCODE || ' - ' || SQLERRM );
    END MAIN;
END XXQGEN_UTL_OUTBOND_DK;
