CREATE OR REPLACE PACKAGE xxqgen_req_int_dev AS
    /***************************************************************************************************
     * Program Name : XXQGEN_REQ_INT_DEV.pks
     * Language     : PL/SQL
     * Description  : Specks for XXQGEN_REQ_INT_AD.pks
     * History      :
     * WHO              Version #   WHEN            WHAT
     * ===============  =========   =============   =================================
     * DKUMAR       1.0         17-FEB-2025     Initial Version
     ***************************************************************************************************/

    /************************************************
     * Initialize the Global Variable and Type.
     ************************************************/
    gn_request_id fnd_concurrent_requests.request_id%TYPE := fnd_profile.value('CONC_REQUEST_ID');
    gn_user_id fnd_user.user_id%TYPE := fnd_profile.value('USER_ID');
    gn_resp_id fnd_responsibility_tl.responsibility_id%TYPE := fnd_profile.value('RESP_ID');
    gn_resp_appl_id fnd_responsibility_tl.application_id%TYPE := fnd_profile.value('RESP_APPL_ID');
    gn_org_id hr_all_organization_units.organization_id%TYPE := fnd_profile.value('ORG_ID');


--PROCEDURE PROCESS_DATA(P_BATCH_ID NUMBER);

    PROCEDURE validate (
        p_batch_id NUMBER
    );

    PROCEDURE validate_require (
        p_batch_id NUMBER
    );

    PROCEDURE load_data (
        batch_id NUMBER
    );

    PROCEDURE main (
        errbuf  OUT VARCHAR2,
        retcode OUT NUMBER
    );

END xxqgen_req_int_dev;