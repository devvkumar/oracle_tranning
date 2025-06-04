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
    
    -- Define a table type for storing header data
    TYPE HEADER_TABLE_TYPE IS TABLE OF OE_ORDER_HEADER_DK%ROWTYPE;

    -- Define a table type for storing line data
    TYPE LINE_TABLE_TYPE IS TABLE OF OE_ORDER_LINE_DK%ROWTYPE;

    -- Declare variables of the table types
    HEADER_TABLE        HEADER_TABLE_TYPE;
    LINE_TABLE             LINE_TABLE_TYPE;

    -- Cursors to fetch data
    CURSOR CUR_HEAD IS
        SELECT *
        FROM XXQGEN_PO_REQ_HDR_STG_DK;

    CURSOR CUR_LINE(HEADER_ID NUMBER) IS
        SELECT *
        FROM XXQGEN_PO_REQ_LINE_STG_DK
        WHERE HEADER_ID = CUR_LINE.HEADER_ID;  -- Filter lines based on HEADER_ID

    -- Fetch all header data into the header table type
    OPEN CUR_HEAD;
    FETCH CUR_HEAD BULK COLLECT INTO HEADER_TABLE;
    CLOSE CUR_HEAD;

    -- Process each header record
    FOR I IN 1 .. HEADER_TABLE.COUNT LOOP
        -- Fetch line data for the current header into the line table type
        OPEN CUR_LINE(HEADER_TABLE(I).HEADER_ID);
        FETCH CUR_LINE BULK COLLECT INTO LINE_TABLE;
        CLOSE CUR_LINE;

        -- Process each line record for the current header
        FOR J IN 1 .. LINE_TABLE.COUNT LOOP
            INSERT INTO PO_REQUISITIONS_INTERFACE_ALL (
                INTERFACE_SOURCE_CODE,
                ORG_ID,
                DESTINATION_TYPE_CODE,
                AUTHORIZATION_STATUS,
                PREPARER_ID,
                CHARGE_ACCOUNT_ID,
                SOURCE_TYPE_CODE,
                UNIT_OF_MEASURE,
                LINE_TYPE_ID,
                CATEGORY_ID,
                UNIT_PRICE,
                QUANTITY,
                DESTINATION_ORGANIZATION_ID,
                DELIVER_TO_LOCATION_ID,
                DELIVER_TO_REQUESTOR_ID,
                HEADER_DESCRIPTION,
                ITEM_DESCRIPTION,
                SUGGESTED_VENDOR_ID,
                SUGGESTED_VENDOR_SITE_ID,
                HEADER_ATTRIBUTE1,
                HEADER_ATTRIBUTE2,
                HEADER_ATTRIBUTE3,
                HEADER_ATTRIBUTE4,
                GL_DATE,
                REQUISITION_HEADER_ID
            ) VALUES (
                HEADER_TABLE(I).SOURCE_CODE,
                HEADER_TABLE(I).ORG_ID,
                HEADER_TABLE(I).TYPE,
                HEADER_TABLE(I).AUTH_STATUS,
                HEADER_TABLE(I).PREPARER_ID,
                LINE_TABLE(J).CHARGE_ACCOUNT,
                LINE_TABLE(J).TYPE,
                LINE_TABLE(J).UOM,
                LINE_TABLE(J).LINE_ID,
                LINE_TABLE(J).CATEGORY_ID,
                LINE_TABLE(J).UNIT_PRICE,
                LINE_TABLE(J).QUANTITY,
                LINE_TABLE(J).DEST_ORG_ID,
                LINE_TABLE(J).LOC_ID,
                LINE_TABLE(J).REQUESTER_ID,
                HEADER_TABLE(I).HEADER_ID,
                LINE_TABLE(J).ITEM,
                LINE_TABLE(J).VENDOR_ID,
                LINE_TABLE(J).SITE_ID,
                'Y',
                NULL,
                'EXTERNAL SOURCE',
                FND_PROFILE.VALUE('USERNAME'),
                SYSDATE,
                PO_REQUISITION_HEADERS_S.NEXTVAL
            );
        END LOOP;
    END LOOP;

    

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