CREATE OR REPLACE PACKAGE xxqgen_metadata_po_depn_dk AS
    P_REQ_TYPE              VARCHAR2(100);
    P_REQUESTER_NAME  VARCHAR2(100);
    P_LINE_NUM          VARCHAR2(100);
    P_REQ_HDR_ID      VARCHAR2(100);
    P_ORG_ID          VARCHAR2(100);
    gn_org_id         NUMBER := fnd_profile.VALUE('ORG_ID');
    gc_user_name      VARCHAR2(100) := fnd_profile.VALUE('USERNAME');
    gc_resp_name      VARCHAR2(100) := fnd_profile.VALUE('RESP_NAME');
    gn_request_id     NUMBER := fnd_profile.VALUE('CONC_REQUEST_ID');
    gn_user_id        NUMBER := fnd_profile.VALUE('USER_ID');
    gd_date           DATE := SYSDATE;

    FUNCTION afterreport RETURN BOOLEAN;
    FUNCTION beforereport RETURN BOOLEAN;
END xxqgen_metadata_po_depn_dk;
