create or replace package body xxqgen_autonomus_test_dk
as

    PROCEDURE ERR_LOG(ERR VARCHAR2)
    IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR LOG IS STARTING');
        INSERT INTO XXQGEN_PRAGMA_AUTO_TEST_LOG_DK VALUES (ERR, SYSDATE);
        COMMIT;
    EXCEPTION 
        WHEN OTHERS THEN
            ERR_LOG(SQLERRM);
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN ERR_LOG PROCEDURE');
    END ERR_LOG;

    procedure main(
                            errbuf  OUT VARCHAR2,
                            retcode OUT NUMBER
    ) is
    begin
        fnd_file.put_line(fnd_file.log, 'working');
        INSERT INTO XXQGEN_PRAGMA_AUTO_TEST_DK VALUES(1,'DEV');
        INSERT INTO XXQGEN_PRAGMA_AUTO_TEST_DK VALUES ('DEV', 2);
        
    exception
        when others then
            ERR_LOG(SQLERRM);
            ROLLBACK;
            fnd_file.put_line(fnd_file.log, 'error in this insert');
    end main;

end xxqgen_autonomus_test_dk;