CREATE OR REPLACE PACKAGE XXQGEN_AR_INVOICE_INF_DK 
IS


    gn_request_id  fnd_concurrent_requests.request_id%TYPE :=   fnd_profile.VALUE ( 'CONC_REQUEST_ID' );
    gn_user_id      fnd_user.user_id%TYPE  := fnd_profile.VALUE ( 'USER_ID' );
    gn_resp_id      fnd_responsibility_tl.responsibility_id%TYPE  := fnd_profile.VALUE ( 'RESP_ID' );
    gn_resp_appl_id fnd_responsibility_tl.application_id%TYPE  := fnd_profile.VALUE ( 'RESP_APPL_ID' );
    gn_org_id   hr_all_organization_units.organization_id%TYPE := fnd_profile.VALUE ( 'ORG_ID' );

    PROCEDURE MAIN( ERRBUF OUT VARCHAR2 , RETCODE OUT NUMBER);

   PROCEDURE LOAD_DATA;

    PROCEDURE VALIDATE_REQUIRED;

    PROCEDURE VALIDATE ;
    
    PROCEDURE IMPORT_DATA;

END XXQGEN_AR_INVOICE_INF_DK;