CREATE OR REPLACE PACKAGE XXQGEN_INVOICE_AP_STATUS AS
    P_END_CREATION_DATE   DATE;
    P_START_CREATION_DATE DATE;
    P_TRADING_PARTNER     VARCHAR2(100);
    gn_org_id             NUMBER := fnd_profile.VALUE('ORG_ID');
    gc_user_name          VARCHAR2(100) := fnd_profile.VALUE('USERNAME');
    gc_resp_name          VARCHAR2(100) := fnd_profile.VALUE('RESP_NAME');
    gn_request_id         NUMBER := fnd_profile.VALUE('CONC_REQUEST_ID');
    gn_user_id            NUMBER := fnd_profile.VALUE('USER_ID');
    gd_date               DATE := SYSDATE;

    FUNCTION afterreport(p_orgid IN NUMBER) RETURN BOOLEAN;
    FUNCTION beforereport(
        P_END_CREATION_DATE IN DATE,
        P_START_CREATION_DATE IN DATE,
        P_TRADING_PARTNER IN VARCHAR2
    ) RETURN BOOLEAN;
END XXQGEN_INVOICE_AP_STATUS;
