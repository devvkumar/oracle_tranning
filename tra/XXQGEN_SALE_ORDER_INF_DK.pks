CREATE OR REPLACE PACKAGE XXQGEN_SALE_ORDER_INF_DK
AS
    gn_org_id                               hr_all_organization_units.organization_id%TYPE := fnd_profile.VALUE ( 'ORG_ID' );
    gc_user_name                            fnd_user.user_name%TYPE := fnd_profile.VALUE ( 'USERNAME' );
    gc_resp_name                            fnd_responsibility_tl.responsibility_name%TYPE := fnd_profile.VALUE ( 'RESP_NAME' );
    gn_request_id                           fnd_concurrent_requests.request_id%TYPE := fnd_profile.VALUE ( 'CONC_REQUEST_ID' );
    gn_user_id                               fnd_user.user_id%TYPE := fnd_profile.VALUE ( 'USER_ID' );
    gn_resp_id                               fnd_responsibility_tl.responsibility_id%TYPE := fnd_profile.VALUE ( 'RESP_ID' );
    gn_resp_appl_id                           fnd_responsibility_tl.application_id%TYPE := fnd_profile.VALUE ( 'RESP_APPL_ID' );
    gn_login_id                               fnd_logins.login_id%TYPE := fnd_profile.VALUE ( 'LOGIN_ID' );
 
    gd_date                                   DATE := SYSDATE;
    
    
    

--    GC_BATCH_ID           NUMBER      := XXQGEN_PO_REQ_BATCH_ID_DK.NEXTVAL;
--    GC_REQUEST_ID       NUMBER      := 1001; --FND_PROFILE.VALUE('CONC_REQUEST_ID');
    
   /***************************************************************************************************
    * Program Name : XXQGEN_SALE_ORDER_INF_DK.pks
    * Language     : PL/SQL
    * Description  : Specks for XXQGEN_SALE_ORDER_INF_DK.pks
    * History      :
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR          1.0         16-FEB-2025     Initial Version
    *******************************S********************************************************************/
--     PROCEDURE PROCESS_DATA(P_BATCH_ID NUMBER);
--     PROCEDURE VALIDATION(P_BATCH_ID NUMBER);
--     PROCEDURE VALIDATE_REQUIRE(P_BATCH_ID NUMBER);
--     PROCEDURE LOAD_DATA(P_BATCH_ID NUMBER);
     PROCEDURE MAIN(errbuf   out varchar2, retcode  out number);
END XXQGEN_SALE_ORDER_INF_DK;