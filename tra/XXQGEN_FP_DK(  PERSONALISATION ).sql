create sequence xxqgen_test_batch_id_dk
start with 1
increment by 1
;
/

select xxqgen_test_batch_id_dk.nextval
from dual;

create or replace package xxqgen_FP_DK
as
    gl_batch_id     number:= xxqgen_test_batch_id_dk.nextval;
    procedure main(ERRBUF OUT VARCHAR2, RETCODE OUT NUMBER);
end xxqgen_fp_dk;
/
/* Formatted on 3/10/2025 1:11:53 PM (QP5 v5.163.1008.3004) */



CREATE OR REPLACE PACKAGE BODY XXQGEN_FP_DK
AS
  PROCEDURE MAIN(ERRBUF OUT VARCHAR2, RETCODE OUT NUMBER)
    IS
    BEGIN
    /*
        fnd_global.apps_initialize(1016246, 50578, 201);
        mo_global.init('PO');
        mo_global.set_policy_context('S', 204);
    */
        gl_batch_id := xxqgen_test_batch_id_dk.nextval;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('ERROR IN MAIN: ' || sqlerrm);
    END main;
END XXQGEN_FP_DK;
/

SELECT :GLOBAL.BATCH_ID_DK
FROM DUAL;