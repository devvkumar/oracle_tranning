CREATE OR REPLACE PACKAGE BODY XXQGEN_PO_REQ_IMP_DK
AS
   FUNCTION beforereport 
   RETURN BOOLEAN
   IS
        l_approval_status VARCHAR2(150) := 'INCOMPLETE';
        ln_request        NUMBER;
        ln_interval       NUMBER := 5;
        ln_max_wait       NUMBER := 60;
        lc_phase          VARCHAR2(3000);
        lc_status         VARCHAR2(3000);
        lc_dev_phase      VARCHAR2(3000);
        lc_dev_status     VARCHAR2(3000);
        lc_message        VARCHAR2(3000);
        lc_conc_status    BOOLEAN;
        LN_ERROR_MESSAGE  VARCHAR2(5000);
    BEGIN
        fnd_global.apps_initialize(gn_user_id, gn_resp_id, gn_resp_appl_id);
        mo_global.init('PO');
        fnd_request.set_org_id(gn_org_id);
        
        -- Use gc_request_id directly here (no redeclaration)
        GC_REQUEST_ID := fnd_request.submit_request(application => 'PO', program => 'XXQGEN_PO_REQ_IMP_DK');

        COMMIT;
        DBMS_OUTPUT.put_line( 'REQUEST TO UPLOAD REQUISITION LEGACY DATA START1: ' || GC_REQUEST_ID);
        IF GC_REQUEST_ID = 0 THEN
            DBMS_OUTPUT.put_line( 'REQUEST TO UPLOAD REQUISITION LEGACY DATA NOT SUBMITTED: ' || GC_REQUEST_ID);
        ELSIF GC_REQUEST_ID > 0 THEN
            LOOP
                lc_conc_status := fnd_concurrent.wait_for_request(request_id => GC_REQUEST_ID, INTERVAL => ln_interval, max_wait => ln_max_wait
                , phase => lc_phase, status => lc_status,
                                                                 dev_phase => lc_dev_phase, dev_status => lc_dev_status, message => lc_message
                                                                 );

                EXIT WHEN upper(lc_phase) = 'COMPLETED' OR upper(lc_status) IN ( 'CANCELLED', 'ERROR', 'TERMINATED' );

            END LOOP;
        END IF;
        FND_FILE.PUT_LINE(FND_FILE.LOG, 'COMPLETED');
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            FND_FILE.PUT_LINE( FND_FILE.LOG, 'ERROR IN BEFOREREPORT ' || SQLCODE || ' - ' || sqlerrm);
            RETURN FALSE;
    END beforereport;

   FUNCTION AFTERREPORT
   RETURN BOOLEAN
   IS
   BEGIN
      -- Placeholder for any post-processing logic if required
      dbms_output.put_line ('After report execution completed.');
      RETURN TRUE;
   END AFTERREPORT;
END XXQGEN_PO_REQ_IMP_DK;

