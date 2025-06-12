CREATE OR REPLACE PACKAGE BODY XXQGEN_REQ_INT_DK AS
       
   /*************************************************************************************************
    * Program Name : VALID_ORG
    * Language     : PL/SQL     
    * Description  : VALID_ORG process to valdiate organization.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         18-FEB-2025     Initial Version
    ***************************************************************************************************/
       FUNCTION VALID_ORG(OPERATING_UNIT VARCHAR2) RETURN NUMBER IS
          LV_ORG_ID NUMBER;
       BEGIN
          SELECT ORGANIZATION_ID
          INTO LV_ORG_ID
          FROM HR_OPERATING_UNITS
          WHERE NAME = OPERATING_UNIT;
          
          DBMS_OUTPUT.PUT_LINE('VALID_ORG_DEBUG ORG_ID : ' || LV_ORG_ID);

          RETURN LV_ORG_ID;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RETURN 0;
       END VALID_ORG;
       
       

   /*************************************************************************************************
    * Program Name : VALID_REQUESTOR_ID
    * Language     : PL/SQL     
    * Description  : VALID_REQUESTOR_ID process to valdiate REQUESTER name.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         18-FEB-2025     Initial Version
    ***************************************************************************************************/
       FUNCTION VALID_REQUESTOR_ID(REQUESTOR VARCHAR2) RETURN NUMBER IS
          LV_REQ_ID NUMBER;
       BEGIN
          SELECT DISTINCT PERSON_ID
          INTO LV_REQ_ID
          FROM PER_ALL_PEOPLE_F
          WHERE 1=1
            AND SYSDATE BETWEEN TRUNC(EFFECTIVE_START_DATE) AND TRUNC(EFFECTIVE_END_DATE)
            AND (CURRENT_EMPLOYEE_FLAG = 'Y' OR CURRENT_NPW_FLAG = 'Y')
            AND FULL_NAME = REQUESTOR
          ;

          RETURN LV_REQ_ID;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             DBMS_OUTPUT.PUT_LINE('LV_REQ_ID : ' || LV_REQ_ID);
             RETURN 0;
       END VALID_REQUESTOR_ID;

   /*************************************************************************************************
    * Program Name : VALID_ITEM
    * Language     : PL/SQL     
    * Description  : VALID_ITEM process to valdiate item.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         18-FEB-2025     Initial Version
    ***************************************************************************************************/
       FUNCTION VALID_ITEM(ITEM VARCHAR2, ORG_ID NUMBER) RETURN NUMBER IS
          LV_ITEM_ID NUMBER;
       BEGIN
          SELECT INVENTORY_ITEM_ID
          INTO LV_ITEM_ID
          FROM MTL_SYSTEM_ITEMS_B
          WHERE SEGMENT1 = ITEM
            AND ORGANIZATION_ID = ORG_ID;

          RETURN LV_ITEM_ID;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RETURN 0;
       END VALID_ITEM;

   /*************************************************************************************************
    * Program Name : VALID_CATEGORY
    * Language     : PL/SQL     
    * Description  : VALID_CATEGORY process to valdiate Category.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         18-FEB-2025     Initial Version
    ***************************************************************************************************/
       FUNCTION VALID_CATEGORY(CATEGORY VARCHAR2) RETURN NUMBER IS
          LV_CAT_ID NUMBER;
       BEGIN
          SELECT CATEGORY_ID
          INTO LV_CAT_ID
          FROM MTL_CATEGORIES
          WHERE SEGMENT1  = 'MISC'
            AND ROWNUM < 2;

          RETURN LV_CAT_ID;
       EXCEPTION
          WHEN OTHERS THEN
             RETURN 0;
       END VALID_CATEGORY;
       
   /*************************************************************************************************
    * Program Name : VALID_LOCATION
    * Language     : PL/SQL     
    * Description  : VALID_LOCATION process to valdiate LOCATION.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         18-FEB-2025     Initial Version
    ***************************************************************************************************/
       FUNCTION VALID_LOCATION(LOCATION VARCHAR2) RETURN NUMBER IS
          LV_LOC_ID NUMBER;
       BEGIN
          SELECT LOCATION_ID
          INTO LV_LOC_ID
          FROM HR_LOCATIONS
          WHERE LOCATION_CODE = LOCATION;

          RETURN LV_LOC_ID;
       EXCEPTION
          WHEN OTHERS THEN
             RETURN 0;
       END VALID_LOCATION;

   /*************************************************************************************************
    * Program Name : VALID_SUPPLIER
    * Language     : PL/SQL     
    * Description  : VALID_SUPPLIER process to valdiate Supplier.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         18-FEB-2025     Initial Version
    ***************************************************************************************************/
       FUNCTION VALID_SUPPLIER(VAN_NAME VARCHAR2) RETURN NUMBER IS
          LV_VENDOR_ID NUMBER;
       BEGIN
          SELECT VENDOR_ID
          INTO LV_VENDOR_ID
          FROM AP_SUPPLIERS
          WHERE VENDOR_NAME = VAN_NAME;

          RETURN LV_VENDOR_ID;
       EXCEPTION
          WHEN OTHERS THEN
             RETURN 0;
       END VALID_SUPPLIER;

   /*************************************************************************************************
    * Program Name : VALID_SITE
    * Language     : PL/SQL     
    * Description  : VALID_SITE process to valdiate Site.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         18-FEB-2025     Initial Version
    ***************************************************************************************************/
       FUNCTION VALID_SITE(P_SITE VARCHAR2, P_VAN_NAME VARCHAR2, P_ORG_ID NUMBER) RETURN NUMBER IS
          LV_SITE_ID NUMBER;
       BEGIN
          SELECT VENDOR_SITE_ID
          INTO LV_SITE_ID
          FROM AP_SUPPLIERS APS,
                  AP_SUPPLIER_SITES_ALL ASSA
          WHERE 1=1
              AND APS.VENDOR_ID = ASSA.VENDOR_ID
              AND ASSA.VENDOR_SITE_CODE = P_SITE
              AND APS.VENDOR_NAME = P_VAN_NAME
              AND ORG_ID = P_ORG_ID;

          RETURN LV_SITE_ID;
       EXCEPTION
          WHEN OTHERS THEN
             RETURN 0;
       END VALID_SITE;

   /*************************************************************************************************
    * Program Name : process_data
    * Language     : PL/SQL     
    * Description  : Main process to import PO Requisition details .
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ===============  =========   =============   ====================================================
    * DKUMAR           1.0         08-FEB-2025     Initial Version
    ***************************************************************************************************/
    
    /*
     PROCEDURE PROCESS_DATA IS
    -- Define a table type for storing header data
    TYPE HEADER_TABLE_TYPE IS TABLE OF XXQGEN_PO_REQ_HDR_STG_DK%ROWTYPE;

    -- Define a table type for storing line data
    TYPE LINE_TABLE_TYPE IS TABLE OF XXQGEN_PO_REQ_LINE_STG_DK%ROWTYPE;

    -- Declare variables of the table types
    HEADER_TABLE HEADER_TABLE_TYPE;
    LINE_TABLE LINE_TABLE_TYPE;

    -- Cursors to fetch data
    CURSOR CUR_HEAD IS
        SELECT *
        FROM XXQGEN_PO_REQ_HDR_STG_DK;

    CURSOR CUR_LINE(HEADER_ID NUMBER) IS
        SELECT *
        FROM XXQGEN_PO_REQ_LINE_STG_DK
        WHERE HEADER_ID = CUR_LINE.HEADER_ID;  -- Filter lines based on HEADER_ID

BEGIN
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

    -- Commit the transaction
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('WORKING');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS DATA PROCEDURE: ' || SQLERRM);
        ROLLBACK;  -- Rollback in case of error
END PROCESS_DATA;
*/

    PROCEDURE submit_requisition
   AS
      l_approval_status   VARCHAR2 (150) := 'INCOMPLETE';
      ln_request          NUMBER;
      ln_interval         NUMBER := 5;
      ln_max_wait         NUMBER := 60;
      lc_phase            VARCHAR2 (3000);
      lc_status           VARCHAR2 (3000);
      lc_dev_phase        VARCHAR2 (3000);
      lc_dev_status       VARCHAR2 (3000);
      lc_message          VARCHAR2 (3000);
      lc_conc_status      BOOLEAN;
   BEGIN
      fnd_global.apps_initialize (gn_user_id, gn_resp_id, gn_resp_appl_id);
      mo_global.init ('PO');
      fnd_request.set_org_id (gn_org_id);
      ln_request :=
         fnd_request.submit_request (application   => 'PO',
                                     program       => 'REQIMPORT',
                                     argument1     => '',
                                     argument2     => gn_request_id,
                                     argument3     => 'ALL',
                                     argument4     => NULL,
                                     argument5     => 'N',
                                     argument6     => 'N');
      COMMIT;
      fnd_file.put_line (
         fnd_file.LOG,
         'REQUEST TO UPLOAD REQUISITION LEGACY DATA START1.' || gn_request_id);

      IF ln_request = 0
      THEN
         fnd_file.put_line (
            fnd_file.LOG,
            'REQUEST TO UPLOAD REQUISITION LEGACY DATA NOT SUBMITTED.'
            || gn_request_id);
      ELSIF ln_request > 0
      THEN
         --  gn_submit_request_id := ln_request;
         LOOP
            lc_conc_status :=
               fnd_concurrent.wait_for_request (request_id   => ln_request,
                                                INTERVAL     => ln_interval,
                                                max_wait     => ln_max_wait,
                                                phase        => lc_phase,
                                                status       => lc_status,
                                                dev_phase    => lc_dev_phase,
                                                dev_status   => lc_dev_status,
                                                MESSAGE      => lc_message);
            EXIT WHEN UPPER (lc_phase) = 'COMPLETED'
                      OR UPPER (lc_status) IN
                            ('CANCELLED', 'ERROR', 'TERMINATED');
         END LOOP;
      END IF;

      fnd_file.put_line (fnd_file.LOG,
                         'REQUEST TO UPLOAD REQUISITION LEGACY DATA START2.');
   EXCEPTION
      WHEN OTHERS
      THEN
         fnd_file.put_line (
            fnd_file.LOG,
               'ERROR IN  REQUISITION  SUBMIT PROCESS : '
            || SQLCODE
            || '-'
            || SQLERRM);
   END submit_requisition;

   /*************************************************************************************************
    * Program Name : PROCESS_DATA
    * Language     : PL/SQL     
    * Description  : PROCESS_DATA process to import PO_REQUISITION details.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         18-FEB-2025     Initial Version
    ***************************************************************************************************/
        PROCEDURE PROCESS_DATA(P_BATCH_ID NUMBER) IS
        
        CURSOR PO_REQ_CUR IS
        SELECT PRHA.SOURCE_CODE,
               PRHA.ORG_ID,
               PRHA.HEADER_ID,
               PRHA.REQ_NUMBER,
               PRHA.TYPE,
               PRHA.PREPARER,
               PRHA.PREPARER_ID,
               PRHA.AUTH_STATUS,
               PRHA.TOTAL,
               PRLA.LINE_ID,
               PRLA.HEADER_ID AS LINE_HEADER_ID,   -- Alias for duplicate HEADER_ID
               PRLA.LINE_NUM,
               PRLA.ITEM,
               PRLA.ITEM_ID,
               PRLA.LINE_TYPE_ID,
               PRLA.LINE_TYPE,
               PRLA.REV,
               PRLA.CATAGORY,
               PRLA.CATEGORY_ID,
               PRLA.DESCREPTION AS LINE_DESCREPTION,  -- Alias for duplicate DESCRIPTION
               PRLA.UOM,
               PRLA.QUANTITY,
               PRLA.PRICE,
               PRLA.NEED_BY_DATE,
               PRLA.AMOUNT,
               PRLA.DISTRIBUTION_ID,
               PRLA.CHARGE_ACCOUNT,
               PRLA.DESTINATION_TYPE,
               PRLA.DEST_ORG,
               PRLA.DEST_ORG_ID,
               PRLA.REQUESTER,
               PRLA.REQUESTER_ID,
               PRLA.ORGANIZATION,
               PRLA.ORG_ID AS LINE_ORG_ID,           -- Alias for duplicate ORG_ID
               PRLA.LOCATION,
               PRLA.LOCATION_ID,
               PRLA.SOURCE,
               PRLA.SUPPLIER,
               PRLA.SUPPLIER_ID,
               PRLA.SITE,
               PRLA.SITE_ID,
               PRLA.CONTACT,
               PRLA.PHONE,
               PRLA.TO_PERSON_ID
        FROM XXQGEN_PO_REQ_HDR_STG_DK PRHA,
             XXQGEN_PO_REQ_LINE_STG_DK PRLA
        WHERE 1=1
            AND PRHA.HEADER_ID = PRLA.HEADER_ID;

        
    TYPE REC_PO IS TABLE OF PO_REQ_CUR%ROWTYPE INDEX BY PLS_INTEGER;
    
    PO_REQ_TBL     REC_PO;
    
   


    CURSOR CUR_HEAD IS
        SELECT *
        FROM XXQGEN_PO_REQ_HDR_STG_DK;

    CURSOR CUR_LINE(HEADER_ID NUMBER) IS
        SELECT *
        FROM XXQGEN_PO_REQ_LINE_STG_DK
        WHERE HEADER_ID = CUR_LINE.HEADER_ID;  -- Filter lines based on HEADER_ID

        
    L_REQUEST_ID            NUMBER;
BEGIN

    

    FOR REC_HEAD IN CUR_HEAD LOOP
        FOR REC_LINE IN CUR_LINE(REC_HEAD.HEADER_ID) LOOP
        BEGIN
            INSERT INTO po_requisitions_interface_all (
                                TRANSACTION_ID,
                                BATCH_ID,
                                INTERFACE_SOURCE_CODE,
                                CREATION_DATE,
                                CREATED_BY,
                                SOURCE_TYPE_CODE,
                                REQUISITION_HEADER_ID,
                                REQUISITION_LINE_ID,
                                REQ_DISTRIBUTION_ID,
                                REQUISITION_TYPE,
                                DESTINATION_TYPE_CODE,
                                ITEM_DESCRIPTION,
                                QUANTITY,
                                UNIT_PRICE,
                                AUTHORIZATION_STATUS,
                                PREPARER_ID,
                                HEADER_DESCRIPTION,
                                ITEM_ID,
                                CHARGE_ACCOUNT_ID,
                                CATEGORY_ID,
                                UNIT_OF_MEASURE,
                                LINE_TYPE_ID,
                                DESTINATION_ORGANIZATION_ID,
                                DELIVER_TO_LOCATION_ID,
                                DELIVER_TO_REQUESTOR_ID,
                                SUGGESTED_VENDOR_ID,
                                SUGGESTED_VENDOR_SITE_ID,
                                SUGGESTED_VENDOR_CONTACT,
                                NEED_BY_DATE,
                                ORG_ID,
                                REQ_DIST_SEQUENCE_ID
                            )
                            VALUES (
                                po_headers_interface_s.NEXTVAL, 
                                gc_request_id, 
                                'IMPORT_REQ', 
                                sysdate, 
                                1016248, 
                                REC_HEAD.SOURCE_CODE, 
                                REC_HEAD.HEADER_ID, 
                                REC_LINE.LINE_ID, 
                                REC_LINE.distribution_id, 
                                REC_HEAD.TYPE, 
                                REC_LINE.DESTINATION_TYPE, 
                                REC_LINE.DESCREPTION, 
                                REC_LINE.QUANTITY, 
                                REC_LINE.PRICE, 
                                REC_HEAD.AUTH_STATUS, 
                                REC_HEAD.PREPARER_ID, 
                                REC_HEAD.DESCRIPTION, 
                                REC_LINE.ITEM_ID, 
                                REC_LINE.CHARGE_ACCOUNT, 
                                REC_LINE.CATEGORY_ID, 
                                REC_LINE.UOM, 
                                REC_LINE.LINE_TYPE_ID, 
                                REC_LINE.ORG_ID, 
                                REC_LINE.LOCATION_ID, 
                                REC_LINE.to_person_id, 
                                REC_LINE.SUPPLIER_ID,
                                REC_LINE.SITE_ID, 
                                REC_LINE.CONTACT, 
                                REC_LINE.NEED_BY_DATE, 
                                REC_LINE.ORG_ID, 
                                po_req_dist_interface_s.NEXTVAL
                            );
                
            EXCEPTION
                WHEN OTHERS THEN
                    
                    ROLLBACK;
                    END;

        END LOOP;
        
    END LOOP;
    
    UPDATE XXQGEN_PO_REQ_LINE_STG_DK
    SET STATUS = 'P'
    WHERE STATUS = 'V';
    
    UPDATE XXQGEN_PO_REQ_HDR_STG_DK
    SET STATUS = 'P'
    WHERE STATUS = 'V';
    
    

    -- Commit the transaction
    COMMIT;
    
--    fnd_global.APPS_INITIALIZE (1318,50578,201);
--            MO_GLOBAL.init('PO');
--            mo_global.set_policy_context('S',204);
--
--            l_request_id :=
--            fnd_request.submit_request (application => 'PO',
--            program => 'REQ_IMPORT',
--            description => 'Requisition Import',
--            start_time => SYSDATE,
--            sub_request => FALSE,
--            argument1 => 'ORDER ENTRY',
--            argument2 => P_BATCH_ID,
--            argument3 => 'ALL',
--            argument4 => NULL,
--            argument5 => 'N',
--            argument6 => 'Y')
--            ;

     submit_requisition;

    DBMS_OUTPUT.PUT_LINE('WORKING');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS DATA PROCEDURE: ' || SQLERRM);
        ROLLBACK;  -- Rollback in case of error
END PROCESS_DATA;


/*
       PROCEDURE PROCESS_DATA IS
       
            CURSOR CUR_HEAD 
            IS
            SELECT *
            FROM XXQGEN_PO_REQ_HDR_STG_DK
            WHERE STATUS = 'V';
            
            CURSOR CUR_LINE(HDR_ID NUMBER)
            IS
            SELECT *
            FROM XXQGEN_PO_REQ_LINE_STG_DK
            WHERE 1=1
                AND STATUS = 'V'
                AND HEADER_ID = HDR_ID;
       
       BEGIN
        FOR REC_HEAD IN CUR_HEAD LOOP
            FOR REC_LINE IN CUR_LINE(REC_HEAD.HEADER_ID) LOOP
                INSERT INTO PO_REQUISITIONS_INTERFACE_ALL (
                    INTERFACE_SOURCE_CODE,
                    ORG_ID,
                    DESTINATION_TYPE_CODE,
                    AUTHORIZATION_STATUS,
                    PREPARER_ID,                --PREPARER_NAME,
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
                    --ACCRUAL_ACCOUNT_ID ,
                    --VARIANCE_ACCOUNT_ID,
                    --BUDGET_ACCOUNT_ID,
                    HEADER_ATTRIBUTE1,
                    HEADER_ATTRIBUTE2,
                    HEADER_ATTRIBUTE3,
                    HEADER_ATTRIBUTE4,
                    GL_DATE,
                    REQUISITION_HEADER_ID                         
                )
             VALUES (
                    REC_HEAD.SOURCE_CODE,        --'IMPORT_REQ',                                  --Interface Source
                    REC_HEAD.ORG_ID,            -- 4567,                                             --Operating Unit
                    REC_HEAD.TYPE,                -- 'EXPENSE',                                     --Destination Type
                    REC_HEAD.AUTH_STATUS,        --'INCOMPLETE',       -- 'APPROVED',--                                     --Status
                    REC.HEAD.PREPARER_ID,        -- 4455,--6439,                      --This comes from per_people_f.person_id
                    REC_LINE.CHARGE_ACCOUNT, -- 122333,                                      --Code Combination ID
                    REC_LINE.DESTINATION_TYPE,                -- 'VENDOR',                                           --Source Type
                    REC_LINE.UOM,                -- 'Quantity',                                                     --UOM ok??yes
                    REC_LINE.LINE_ID,            -- 1,                                           --Line Type of Goods
                    REC_LINE.CATEGORY_ID,        -- 1123,                                           --MISC.MISC Category
                    REC_LINE.PRICE,        -- 100,                                                       --Price
                    REC_LINE.QUANTITY,            -- 1,                                                    --quantitRERERERy
                    REC_LINE.DEST_ORG_ID,        -- 108,--102                      --Represents Vision Operations Inv Org.
                    REC_LINE.LOCATION_ID,                -- 142,--162,                               
                    REC_LINE.REQUESTER_ID,        -- 26876,--6439 ,                           
                    REC_HEAD.HEADER_ID,            -- L_EMPLOYEE_NUMBER,                        --One Time Header Description
                    REC_LINE.ITEM,                -- L_EMPLOYEE_NUMBER,                        --One Time Item Description
                    REC_LINE.SUPPLIER_ID,            -- 233333,
                    REC_LINE.SITE_ID,            -- 223333,
                     'Y',
                     NULL,
                    'EXTERNAL SOURCE',
                     FND_PROFILE.VALUE('USERNAME'),
                     SYSDATE,
                      PO_REQUISITION_HEADERS_S.NEXTVAL
                    );
            END LOOP;
        END LOOP;
            
           
            DBMS_OUTPUT.PUT_LINE('WORKING');
       EXCEPTION
         WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS DATA PROCEDURE');
        END PROCESS_DATA;
        
        */

   /*************************************************************************************************
    * Program Name : Validation
    * Language     : PL/SQL     
    * Description  : Validattion process to validate data.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         17-FEB-2025     Initial Version
    * DKUMAR           1.1         18-FEB-2025     ADDING HEADER VALIDATION
    ***************************************************************************************************/
    PROCEDURE VALIDATION(P_BATCH_ID NUMBER)
    IS
    

    
        
       
        BEGIN
        
            VALIDHEADER(P_BATCH_ID);
            VALIDLINE(P_BATCH_ID);
            
           
        
        END;
        
        
        PROCEDURE VALIDHEADER(P_BATCH_ID IN NUMBER)
        IS 
            CURSOR CUR_HEAD IS
            SELECT *
            FROM XXQGEN_PO_REQ_HDR_STG_DK
            WHERE 1 = 1
            AND REQUEST_ID = -1
            AND STATUS = 'N';
            
             LV_MESSAGE_ERROR VARCHAR2(5000);
        BEGIN
            DBMS_OUTPUT.PUT_LINE('P_BATCH ID IS PASSING YES! ' || P_BATCH_ID);
        
            FOR REC_HEAD IN CUR_HEAD LOOP
                BEGIN
                    REC_HEAD.STATUS := 'V';
                    REC_HEAD.ERROR_MESSAGE := NULL;

                    -- Validate Organization ID
                    REC_HEAD.ORG_ID := VALID_ORG(REC_HEAD.OPERATING_UNIT);
                    IF REC_HEAD.ORG_ID = 0 THEN
                        REC_HEAD.STATUS := 'E';
                        REC_HEAD.ERROR_MESSAGE := 'ORGANIZATION IS INVALID';
                    END IF;
                    
                    -- Validation Preparer_id
                    REC_HEAD.PREPARER_ID := VALID_REQUESTOR_ID(REC_HEAD.PREPARER);
                    IF REC_HEAD.PREPARER_ID = 0 THEN
                        REC_HEAD.STATUS := 'E';
                        REC_HEAD.ERROR_MESSAGE := 'REQUESTOR IS INVALID';
                    END IF;
                    
                    DBMS_OUTPUT.PUT_LINE('ORG_ID : ' || REC_HEAD.ORG_ID || 'PREPARER_ID : ' ||  REC_HEAD.PREPARER_ID);
                    
                    UPDATE XXQGEN_PO_REQ_HDR_STG_DK
                    SET STATUS = REC_HEAD.STATUS,
                    ERROR_MESSAGE = REC_HEAD.ERROR_MESSAGE,
                    ORG_ID = REC_HEAD.ORG_ID,
                    PREPARER_ID = REC_HEAD.PREPARER_ID
                    WHERE BATCH_ID = P_BATCH_ID
                    AND     RECORD_ID = REC_HEAD.RECORD_ID;

                END;
            END LOOP;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN VALID HEADER : ' || SQLCODE || ' - ' || SQLERRM);
        END VALIDHEADER;
    
    PROCEDURE VALIDLINE(P_BATCH_ID IN NUMBER)
    IS
    CURSOR CUR_LINE IS
        SELECT *
        FROM XXQGEN_PO_REQ_LINE_STG_DK
        WHERE 1 = 1
        AND REQUEST_ID = -1
        AND STATUS = 'N';
         LV_MESSAGE_ERROR VARCHAR2(5000);
    BEGIN
     FOR REC_LINE IN CUR_LINE LOOP
                BEGIN
                
                    REC_LINE.STATUS := 'V';
                    LV_MESSAGE_ERROR := '';
                    
                     -- Validate Organization ID
                     REC_LINE.ORG_ID := 204; --VALID_ORG(REC_LINE.ORGANIZATION);
                     IF REC_LINE.ORG_ID = 0 THEN
                        REC_LINE.STATUS := 'E';
                        REC_LINE.ERROR_MESSAGE := 'ORGANIZATION IS INVALID';
                     END IF;

                     -- Validate Requestor ID
                     REC_LINE.REQUESTER_ID := VALID_REQUESTOR_ID(REC_LINE.REQUESTER);
                     IF REC_LINE.REQUESTER_ID = 0 THEN
                        REC_LINE.STATUS := 'E';
                        REC_LINE.ERROR_MESSAGE := 'REQUESTOR IS INVALID';
                     END IF;

                     -- Validate Item
                     REC_LINE.ITEM_ID := VALID_ITEM(REC_LINE.ITEM, REC_LINE.ORG_ID);
                     IF REC_LINE.ITEM_ID = 0 THEN
                        REC_LINE.STATUS := 'E';
                        REC_LINE.ERROR_MESSAGE := 'ITEM IS INVALID';
                     END IF;

                     -- Validate Category
                     REC_LINE.CATEGORY_ID := VALID_CATEGORY(REC_LINE.CATAGORY);
                     IF REC_LINE.CATEGORY_ID = 0 THEN
                        REC_LINE.STATUS := 'E';
                        REC_LINE.ERROR_MESSAGE := 'CATEGORY IS INVALID';
                     END IF;

                     -- Validate Location
                     REC_LINE.LOCATION_ID := VALID_LOCATION(REC_LINE.LOCATION);
                     IF REC_LINE.LOCATION_ID = 0 THEN
                        REC_LINE.STATUS := 'E';
                        REC_LINE.ERROR_MESSAGE := 'LOCATION IS INVALID';
                     END IF;

                     -- Validate Supplier
                     REC_LINE.SUPPLIER_ID := VALID_SUPPLIER(REC_LINE.SUPPLIER);
                     IF REC_LINE.SUPPLIER_ID = 0 THEN
                        REC_LINE.STATUS := 'E';
                        REC_LINE.ERROR_MESSAGE := 'SUPPLIER IS INVALID';
                     END IF;

                     -- Validate Site
--                     REC_LINE.SITE_ID := VALID_SITE(REC_LINE.SITE, REC_LINE.SUPPLIER, REC_LINE.ORG_ID);
--                     IF REC_LINE.SITE_ID = 0 THEN
--                        REC_LINE.STATUS := 'E';
--                        REC_LINE.ERROR_MESSAGE := 'SITE IS INVALID';
--                     END IF;
--                     DBMS_OUTPUT.PUT_LINE('STATUS : ' || REC_LINE.STATUS || ' ' || 'ERROR : ' || REC_LINE.ERROR_MESSAGE || 'ORG_ID : ' || REC_LINE.ORG_ID ||
--                     REC_LINE.LOCATION_ID || 'SUPPLIER_ID' || REC_LINE.SUPPLIER_ID || 'SITE_ID' ||REC_LINE.SITE_ID
-- || 'REQUESTOR_ID : ' || REC_LINE.REQUESTER_ID || 'ITEM_ID : ' || REC_LINE.ITEM_ID || 'CATEGORY_ID : ' || REC_LINE.CATEGORY_ID);
 
                        UPDATE XXQGEN_PO_REQ_LINE_STG_DK
                        SET STATUS = REC_LINE.STATUS,
                        ERROR_MESSAGE = REC_LINE.ERROR_MESSAGE,
                        ORG_ID = REC_LINE.ORG_ID,
                        LOCATION_ID = REC_LINE.LOCATION_ID,
                        SUPPLIER_ID = REC_LINE.SUPPLIER_ID,
                        SITE_ID = REC_LINE.SITE_ID,
                        REQUESTER_ID = REC_LINE.REQUESTER_ID ,
                        ITEM_ID = REC_LINE.ITEM_ID,
                        CATEGORY_ID = REC_LINE.CATEGORY_ID
                        WHERE BATCH_ID = P_BATCH_ID
                        AND     RECORD_ID = REC_LINE.RECORD_ID;
--                     UPDATE XXQGEN_PO_REQ_LINE_STG_DK
--                        SET  STATUS = REC_LINE.STATUS,
--                               ERROR_MESSAGE = REC_LINE.ERROR_MESSAGE,
--                               ORG_ID = REC_LINE.ORG_ID,
--                               REQUESTER_ID = REC_LINE.REQUESTER_ID,
--                               ITEM_ID = REC_LINE.ITEM_ID,
--                               CATEGORY_ID = REC_LINE.CATEGORY_ID,
--                               LOCATION_ID = REC_LINE.LOCATION_ID,
--                               SUPPLIER_ID = REC_LINE.SUPPLIER_ID,
--                               SITE_ID = REC_LINE.SITE_ID
--                        WHERE 1=1
--                            AND REQUEST_ID = GC_REQUEST_ID
--                            AND RECORD_ID = REC_LINE.RECORD_ID;
                
                END;
          END LOOP;
          EXCEPTION
            WHEN OTHERS THEN 
                DBMS_OUTPUT.PUT_LINE('ERROR IN VALID LINE - ' || SQLCODE || ' - ' || SQLERRM);
    END VALIDLINE;
    
      PROCEDURE VALIDATION2(P_BATCH_ID NUMBER) IS
    CURSOR CUR_HEAD IS
        SELECT *
        FROM XXQGEN_PO_REQ_HDR_STG_DK
        WHERE 1 = 1
        AND REQUEST_ID = -1
        AND STATUS = 'N';

    CURSOR CUR_LINE IS
        SELECT *
        FROM XXQGEN_PO_REQ_LINE_STG_DK
        WHERE 1 = 1
        AND REQUEST_ID = -1
        AND STATUS = 'N';
        
    LV_MESSAGE_ERROR VARCHAR2(3000);

BEGIN
    -- Loop through header records
    FOR REC_HEAD IN CUR_HEAD LOOP
        BEGIN
            -- DEBUG_MESSAGE
            DBMS_OUTPUT.PUT_LINE('DEBUG 1');
            -- Reset Status and Error Message
            REC_HEAD.STATUS := 'V';
            REC_HEAD.ERROR_MESSAGE := NULL;

            -- Validate Organization ID
            REC_HEAD.ORG_ID := VALID_ORG(REC_HEAD.OPERATING_UNIT);
            
            -- DEBUG_MESSAGE
            DBMS_OUTPUT.PUT_LINE(REC_HEAD.ORG_ID || '-' || REC_HEAD.BATCH_ID);
            IF REC_HEAD.ORG_ID = 0 THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'ORGANIZATION IS INVALID';
            END IF;
            
            -- Validation Preparer_id
            REC_HEAD.PREPARER_ID := VALID_REQUESTOR_ID(REC_HEAD.PREPARER);
            IF REC_HEAD.PREPARER_ID = 0 THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'REQUESTOR IS INVALID';
            END IF;

            -- DEBUG_MESSAGE
            DBMS_OUTPUT.PUT_LINE('DEBUG ' || REC_HEAD.PREPARER_ID || ' - ' || REC_HEAD.ORG_ID || ' - '  || REC_HEAD.STATUS);
            
            UPDATE XXQGEN_PO_REQ_HDR_STG_DK
            SET STATUS = REC_HEAD.STATUS,
                   ORG_ID = REC_HEAD.ORG_ID,
                   PREPARER_ID = REC_HEAD.PREPARER_ID,
                   ERROR_MESSAGE = REC_HEAD.ERROR_MESSAGE
            WHERE BATCH_ID = REC_HEAD.BATCH_ID;
            
--            BEGIN
--            -- Update Header Table
--            UPDATE XXQGEN_PO_REQ_HDR_STG_DK
--            SET STATUS = REC_HEAD.STATUS,
--                PREPARER_ID = REC_HEAD.PREPARER_ID,
--                ORG_ID = REC_HEAD.ORG_ID,
--                ERROR_MESSAGE = REC_HEAD.ERROR_MESSAGE;
----            WHERE 1=1;
----                AND REQUEST_ID = GN_REQUEST_ID
----                AND BATCH_ID = REC_HEAD.BATCH_ID;
--            EXCEPTION
--                WHEN OTHERS THEN 
--                    DBMS_OUTPUT.PUT_LINE('ERROR IN HEADER UPDATE LINE : PATA NHI KYA DIAKT HAI! : ' || SQLCODE || ' - ' || SQLERRM);
--            END;
            -- DEBUG_MESSAGE
            DBMS_OUTPUT.PUT_LINE('DEBUG 3');
        EXCEPTION
            WHEN OTHERS THEN
                LV_MESSAGE_ERROR := 'ERROR IN HEADER VALIDATION: ' || SQLCODE || ' - ' || SQLERRM;
                UPDATE XXQGEN_PO_REQ_HDR_STG_DK
                SET STATUS = 'E',
                    ERROR_MESSAGE = REC_HEAD.ERROR_MESSAGE || ' ' || LV_MESSAGE_ERROR
                WHERE REQUEST_ID = GC_REQUEST_ID
                    AND RECORD_ID = REC_HEAD.RECORD_ID;
        END;
    END LOOP;
        
        
          FOR REC_LINE IN CUR_LINE LOOP
                BEGIN
                
                    REC_LINE.STATUS := 'V';
                    LV_MESSAGE_ERROR := '';
                    
                     -- Validate Organization ID
                     REC_LINE.ORG_ID := 204; --VALID_ORG(REC_LINE.ORGANIZATION);
                     IF REC_LINE.ORG_ID = 0 THEN
                        REC_LINE.STATUS := 'E';
                        REC_LINE.ERROR_MESSAGE := 'ORGANIZATION IS INVALID';
                     END IF;

                     -- Validate Requestor ID
                     REC_LINE.REQUESTER_ID := VALID_REQUESTOR_ID(REC_LINE.REQUESTER);
                     IF REC_LINE.REQUESTER_ID = 0 THEN
                        REC_LINE.STATUS := 'E';
                        REC_LINE.ERROR_MESSAGE := 'REQUESTOR IS INVALID';
                     END IF;

                     -- Validate Item
                     REC_LINE.ITEM_ID := VALID_ITEM(REC_LINE.ITEM, REC_LINE.ORG_ID);
                     IF REC_LINE.ITEM_ID = 0 THEN
                        REC_LINE.STATUS := 'E';
                        REC_LINE.ERROR_MESSAGE := 'ITEM IS INVALID';
                     END IF;

                     -- Validate Category
                     REC_LINE.CATEGORY_ID := VALID_CATEGORY(REC_LINE.CATAGORY);
                     IF REC_LINE.CATEGORY_ID = 0 THEN
                        REC_LINE.STATUS := 'E';
                        REC_LINE.ERROR_MESSAGE := 'CATEGORY IS INVALID';
                     END IF;

                     -- Validate Location
                     REC_LINE.LOCATION_ID := VALID_LOCATION(REC_LINE.LOCATION);
                     IF REC_LINE.LOCATION_ID = 0 THEN
                        REC_LINE.STATUS := 'E';
                        REC_LINE.ERROR_MESSAGE := 'LOCATION IS INVALID';
                     END IF;

                     -- Validate Supplier
                     REC_LINE.SUPPLIER_ID := VALID_SUPPLIER(REC_LINE.SUPPLIER);
                     IF REC_LINE.SUPPLIER_ID = 0 THEN
                        REC_LINE.STATUS := 'E';
                        REC_LINE.ERROR_MESSAGE := 'SUPPLIER IS INVALID';
                     END IF;

                     -- Validate Site
--                     REC_LINE.SITE_ID := VALID_SITE(REC_LINE.SITE, REC_LINE.SUPPLIER, REC_LINE.ORG_ID);
--                     IF REC_LINE.SITE_ID = 0 THEN
--                        REC_LINE.STATUS := 'E';
--                        REC_LINE.ERROR_MESSAGE := 'SITE IS INVALID';
--                     END IF;
                     
                     UPDATE XXQGEN_PO_REQ_LINE_STG_DK
                        SET  STATUS = REC_LINE.STATUS,
                               ERROR_MESSAGE = REC_LINE.ERROR_MESSAGE,
                               ORG_ID = REC_LINE.ORG_ID,
                               REQUESTER_ID = REC_LINE.REQUESTER_ID,
                               ITEM_ID = REC_LINE.ITEM_ID,
                               CATEGORY_ID = REC_LINE.CATEGORY_ID,
                               LOCATION_ID = REC_LINE.LOCATION_ID,
                               SUPPLIER_ID = REC_LINE.SUPPLIER_ID,
                               SITE_ID = REC_LINE.SITE_ID
                        WHERE 1=1
                            AND REQUEST_ID = GC_REQUEST_ID
                            AND RECORD_ID = REC_LINE.RECORD_ID;
                EXCEPTION
                    WHEN OTHERS THEN 
                        LV_MESSAGE_ERROR := 'ERROR IN LINE LEVEL VALIDATION LOOP ' || SQLCODE || ' - ' || SQLERRM;
                        UPDATE XXQGEN_PO_REQ_LINE_STG_DK
                        SET  STATUS = 'E',
                               ERROR_MESSAGE = REC_LINE.ERROR_MESSAGE || ' ' || LV_MESSAGE_ERROR
                        WHERE 1=1
                            AND RECORD_ID = REC_LINE.RECORD_ID
                            AND REQUEST_ID = GC_REQUEST_ID;
                            --AND BATCH_ID = REC_LINE.BATCH_ID;
                END;
          END LOOP;
          -- DEBUG 
            DBMS_OUTPUT.PUT_LINE('DEBUG_MESSAGE 5');
          
          -- VALIDATION FOR HEADER
       

          DBMS_OUTPUT.PUT_LINE('VALIDATION COMPLETED');
       EXCEPTION
          WHEN OTHERS THEN
             FND_FILE.PUT_LINE(FND_FILE.LOG, SQLCODE || '-' || SQLERRM);
       END VALIDATION2;

   /*************************************************************************************************
    * Program Name : VALIDATE_REQUIRE
    * Language     : PL/SQL     
    * Description  : VALIDATE_REQUIRE process to valdiate null values.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         17-FEB-2025     Initial Version
    ***************************************************************************************************/
       PROCEDURE VALIDATE_REQUIRE(P_BATCH_ID NUMBER) IS
       BEGIN
            -- VALIDATION FOR REQUISITION_HEADER
         
          -- OPERATING UNIT VALID REQ
          BEGIN
             UPDATE XXQGEN_PO_REQ_HDR_STG_DK
                SET STATUS = 'E',
                    ERROR_MESSAGE = ERROR_MESSAGE || 'OPERATING UNIT IS NULL'
              WHERE OPERATING_UNIT IS NULL;
          EXCEPTION
             WHEN OTHERS
             THEN
                FND_FILE.PUT_LINE (
                   FND_FILE.LOG,
                      'ERROR IN OPERATING UNIT VALID REQ'
                   || SQLERRM
                   || '-'
                   || SQLCODE);
          END;

          -- TYPE VALID REQ
          BEGIN
             UPDATE XXQGEN_PO_REQ_HDR_STG_DK
                SET STATUS = 'E',
                    ERROR_MESSAGE = ERROR_MESSAGE || 'TYPE CAN NOT BE NULL'
              WHERE TYPE IS NULL;
          END;

          BEGIN
             UPDATE XXQGEN_PO_REQ_HDR_STG_DK
                SET STATUS = 'E',
                    ERROR_MESSAGE = ERROR_MESSAGE || 'OPERATING UNIT IS NULL'
              WHERE OPERATING_UNIT IS NULL;
          EXCEPTION
             WHEN OTHERS
             THEN
                FND_FILE.PUT_LINE (
                   FND_FILE.LOG,
                      'ERROR IN OPERATING UNIT VALID REQ'
                   || SQLERRM
                   || '-'
                   || SQLCODE);
          END;

          -- PREPARER
          BEGIN
             UPDATE XXQGEN_PO_REQ_HDR_STG_DK
                SET STATUS = 'E',
                    ERROR_MESSAGE = ERROR_MESSAGE || 'PREPARER IS NULL'
              WHERE PREPARER IS NULL;
          EXCEPTION
             WHEN OTHERS
             THEN
                FND_FILE.PUT_LINE (
                   FND_FILE.LOG,
                   'ERROR IN PREPARRER VALID REQ' || SQLERRM || '-' || SQLCODE);
          END;

          -- DESCRIPTION
          BEGIN
             UPDATE XXQGEN_PO_REQ_HDR_STG_DK
                SET STATUS = 'E',
                    ERROR_MESSAGE = ERROR_MESSAGE || 'DESCRIPTION IS NULL'
              WHERE DESCRIPTION IS NULL;
              
              
          COMMIT;
          
          EXCEPTION
             WHEN OTHERS
             THEN
                FND_FILE.PUT_LINE (
                   FND_FILE.LOG,
                   'ERROR IN DESCRIPTION VALID REQ' || SQLERRM || '-' || SQLCODE);
          END;

          -- TOTAL
--          BEGIN
--             UPDATE XXQGEN_PO_REQ_HDR_STG_DK
--                SET STATUS = 'E',
--                    ERROR_MESSAGE = ERROR_MESSAGE || 'TOTAL IS NULL'
--              WHERE TOTAL IS NULL;
--          EXCEPTION
--             WHEN OTHERS
--             THEN
--                FND_FILE.PUT_LINE (
--                   FND_FILE.LOG,
--                   'ERROR IN TOTAL VALID REQ' || SQLERRM || '-' || SQLCODE);
--          END;

          -- VALIDATION FOR REQUISITION_LINE

          -- LINE NUM
          BEGIN
             UPDATE XXQGEN_PO_REQ_LINE_STG_DK
                SET STATUS = 'E',
                    ERROR_MESSAGE = ERROR_MESSAGE || 'TOTAL IS NULL'
              WHERE LINE_NUM IS NULL;
          EXCEPTION
             WHEN OTHERS
             THEN
                FND_FILE.PUT_LINE (
                   FND_FILE.LOG,
                   'ERROR IN TOTAL VALID REQ' || SQLERRM || '-' || SQLCODE);
          END;

          -- CATEGORY
          BEGIN
             UPDATE XXQGEN_PO_REQ_LINE_STG_DK
                SET STATUS = 'E',
                    ERROR_MESSAGE = ERROR_MESSAGE || 'CATEGORY IS NULL'
              WHERE CATAGORY IS NULL;
          EXCEPTION
             WHEN OTHERS
             THEN
                FND_FILE.PUT_LINE (
                   FND_FILE.LOG,
                   'ERROR IN TOTAL VALID REQ' || SQLERRM || '-' || SQLCODE);
          END;

          -- DESCREPTION
          BEGIN
             UPDATE XXQGEN_PO_REQ_LINE_STG_DK
                SET STATUS = 'E',
                    ERROR_MESSAGE = ERROR_MESSAGE || 'DESCREPTION IS NULL'
              WHERE DESCREPTION IS NULL;
          EXCEPTION
             WHEN OTHERS
             THEN
                FND_FILE.PUT_LINE (
                   FND_FILE.LOG,
                   'ERROR IN TOTAL VALID REQ' || SQLERRM || '-' || SQLCODE);
          END;

          -- UOM
          BEGIN
             UPDATE XXQGEN_PO_REQ_LINE_STG_DK
                SET STATUS = 'E',
                    ERROR_MESSAGE = ERROR_MESSAGE || 'UOM IS NULL'
              WHERE UOM IS NULL;
          EXCEPTION
             WHEN OTHERS
             THEN
                FND_FILE.PUT_LINE (
                   FND_FILE.LOG,
                   'ERROR IN TOTAL VALID REQ' || SQLERRM || '-' || SQLCODE);
          END;

          -- QUANTITY
          BEGIN
             UPDATE XXQGEN_PO_REQ_LINE_STG_DK
                SET STATUS = 'E',
                    ERROR_MESSAGE = ERROR_MESSAGE || 'QUANTITY IS NULL'
              WHERE QUANTITY IS NULL;
          EXCEPTION
             WHEN OTHERS
             THEN
                FND_FILE.PUT_LINE (
                   FND_FILE.LOG,
                   'ERROR IN TOTAL VALID REQ' || SQLERRM || '-' || SQLCODE);
          END;

          -- PRICE
          BEGIN
             UPDATE XXQGEN_PO_REQ_LINE_STG_DK
                SET STATUS = 'E',
                    ERROR_MESSAGE = ERROR_MESSAGE || 'PRICE IS NULL'
              WHERE PRICE IS NULL;
          EXCEPTION
             WHEN OTHERS
             THEN
                FND_FILE.PUT_LINE (
                   FND_FILE.LOG,
                   'ERROR IN TOTAL VALID REQ' || SQLERRM || '-' || SQLCODE);
          END;

          -- DESTINATION_TYPE
          BEGIN
             UPDATE XXQGEN_PO_REQ_LINE_STG_DK
                SET STATUS = 'E',
                    ERROR_MESSAGE = ERROR_MESSAGE || 'DESTINATION_TYPE IS NULL'
              WHERE DESTINATION_TYPE IS NULL;
          EXCEPTION
             WHEN OTHERS
             THEN
                FND_FILE.PUT_LINE (
                   FND_FILE.LOG,
                   'ERROR IN TOTAL VALID REQ' || SQLERRM || '-' || SQLCODE);
          END;

          -- REQUESTOR
          BEGIN
             UPDATE XXQGEN_PO_REQ_LINE_STG_DK
                SET STATUS = 'E',
                    ERROR_MESSAGE = ERROR_MESSAGE || 'REQUESTOR IS NULL'
              WHERE REQUESTER IS NULL;
          EXCEPTION
             WHEN OTHERS THEN
                FND_FILE.PUT_LINE ( FND_FILE.LOG, 'ERROR IN TOTAL VALID REQ' || SQLERRM || '-' || SQLCODE);
          END;

          -- ORGANISATION
          BEGIN
             UPDATE XXQGEN_PO_REQ_LINE_STG_DK
                SET STATUS = 'E',
                    ERROR_MESSAGE = ERROR_MESSAGE || 'ORGANIZARION IS NULL'
              WHERE ORGANIZATION IS NULL;
          EXCEPTION
             WHEN OTHERS
             THEN
                FND_FILE.PUT_LINE ( FND_FILE.LOG, 'ERROR IN TOTAL VALID REQ' || SQLERRM || '-' || SQLCODE);
          END;

          -- LOCATION
          BEGIN
             UPDATE XXQGEN_PO_REQ_LINE_STG_DK
                SET STATUS = 'E',
                    ERROR_MESSAGE = ERROR_MESSAGE || 'LOCATION IS NULL'
              WHERE LOCATION IS NULL;
          EXCEPTION
             WHEN OTHERS
             THEN
                FND_FILE.PUT_LINE (
                   FND_FILE.LOG,
                   'ERROR IN TOTAL VALID REQ' || SQLERRM || '-' || SQLCODE);
          END;

          -- SOURCE
          BEGIN
             UPDATE XXQGEN_PO_REQ_LINE_STG_DK
                SET STATUS = 'E',
                    ERROR_MESSAGE = ERROR_MESSAGE || 'SOURCE IS NULL'
              WHERE SOURCE IS NULL;
            EXCEPTION
             WHEN OTHERS
             THEN
                FND_FILE.PUT_LINE (
                   FND_FILE.LOG,
                   'ERROR IN TOTAL VALID REQ' || SQLERRM || '-' || SQLCODE);
          END;
          DBMS_OUTPUT.PUT_LINE('VALIDATE_REQUIRE COMPLETED');
       EXCEPTION
          WHEN OTHERS THEN
             FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN VALIDATE_REQUIRE: ' || SQLERRM);
       END VALIDATE_REQUIRE;

   /*************************************************************************************************
    * Program Name : LOAD_DATA
    * Language     : PL/SQL     
    * Description  : LOAD_DATA process to insert PO_REQUISITION details in Staging Table.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         17-FEB-2025     Initial Version
    ***************************************************************************************************/
       PROCEDURE LOAD_DATA(P_BATCH_ID NUMBER) IS
       BEGIN
       
        INSERT INTO XXQGEN_PO_REQ_HDR_STG_DK(
                            OPERATING_UNIT, HEADER_ID, REQ_NUMBER, TYPE, PREPARER, DESCRIPTION,
             AUTH_STATUS, TOTAL, STATUS, ERROR_MESSAGE, CREATION_DATE, CREATED_BY,
             LAST_UPDATED_BY, UPDATED_BY, REQUEST_ID, BATCH_ID,RECORD_ID
            )
           VALUES ('Vision Operations', -- ORG_ID
                         XXQGEN_PO_REQ_HEADER_ID.CURRVAL,
                         10000023,
                         'PURCHASE',                                           -- REQUISITION TYPE
                         'Stock, Ms. Pat',                                      -- PREPARER 
                         'TEST20',                                               -- DESCRIPTION
                         'INCOMPLETE',                                       -- AUTH STATUS,
                         NULL,                                                   -- TOTAL
                   'N',
                   NULL,
                   SYSDATE,
                   GN_USER_ID,
                   SYSDATE, 
                   GN_USER_ID,
                   GN_REQUEST_ID,
                   P_BATCH_ID,
                   XXQGEN_REC_ID_DK.NEXTVAL );
           
--                   INSERT INTO XXQGEN_PO_REQ_LINE_STG_DK(
--                                        LINE_ID, HEADER_ID, LINE_NUM, ITEM, ITEM_ID, REV, CATAGORY, CATEGORY_ID,
--             DESCREPTION, UOM, QUANTITY, PRICE, NEED_BY_DATE, AMOUNT, CHARGE_ACCOUNT,
--             DESTINATION_TYPE, REQUESTER, REQUESTER_ID, ORGANIZATION, ORG_ID,
--             LOCATION, LOCATION_ID, SOURCE, SUPPLIER, SITE, CONTACT, PHONE, TO_PERSON_ID, STATUS,
--             ERROR_MESSAGE, CREATION_DATE, CREATED_BY, LAST_UPDATED_BY, UPDATED_BY,
--             REQUEST_ID, BATCH_ID
--                   )
--           VALUES (
--                       XXQGEN_PO_REQ_LINE_ID.CURRVAL,
--                       XXQGEN_PO_REQ_HEADER_ID.CURRVAL,
--                       1,
--                       NULL,
--                       
--                    REQ_LOAD_REC_ID_SEQ_AR.NEXTVAL ,
--                  gn_request_id,
--                  gn_user_id,
--                   gd_date,
--                  gn_user_id,
--                   gd_date,
--                   'N',
--                   NULL,
--                   NULL,
--                   REQ_NUM_SEQ_AR.NEXTVAL,
--                   NULL,
--                   'Stock, Ms. Pat',
--                   'Vision Operation',
--                   NULL,
--                   'INCOMPLETE',
--                   'TEST20',
--                   'PURCHASE');
                   
                   
--SELECT *
--FROM XXQGEN_PO_REQ_LINES_STG_AR;

      INSERT INTO XXQGEN_PO_REQ_LINE_STG_DK(
                         LINE_ID, HEADER_ID, LINE_NUM, ITEM, ITEM_ID, REV, CATAGORY, CATEGORY_ID,
             DESCREPTION, UOM, QUANTITY, PRICE, 
             NEED_BY_DATE, AMOUNT, CHARGE_ACCOUNT,
             DESTINATION_TYPE, 
             REQUESTER, REQUESTER_ID, ORGANIZATION, ORG_ID,
             LOCATION, LOCATION_ID, SOURCE, SUPPLIER, SITE, CONTACT, PHONE, TO_PERSON_ID, STATUS,
             ERROR_MESSAGE, CREATION_DATE, CREATED_BY, LAST_UPDATED_BY, UPDATED_BY,
             REQUEST_ID, BATCH_ID, RECORD_ID
      )
           VALUES (
                    XXQGEN_PO_REQ_LINE_ID.CURRVAL,
                    XXQGEN_PO_REQ_HEADER_ID.CURRVAL,
                    1,
                        'f20000',
                        NULL,
                        NULL,
                         'SUPPLIES.OFFICE',
                         NULL,
                           'Paper - requires 2-way match office supply item',
                         'Each',
                         1,
                         50,
                         SYSDATE+5,
                         NULL,
                         '01-510-7530-0000-000',
                         'EXPENSE',
                         'Stock, Ms. Pat',
                         NULL,
                         'Vision Operations',
                         NULL,
                         'V1- New York City',
                         NULL,
                         'VENDOR',
                         '3M Health Care',
                         'CORP HQ',
                         NULL,
                         NULL,
                         25,
                          'N',
                   NULL,
                   SYSDATE,
                   GN_USER_ID,
                   SYSDATE, 
                   GN_USER_ID,
                   GN_REQUEST_ID,
                   P_BATCH_ID,
                   XXQGEN_REC_ID_DK.NEXTVAL );
                         
                        
          -- Insert into Header Staging Table
          
          INSERT INTO XXQGEN_PO_REQ_HDR_STG_DK (
             OPERATING_UNIT, HEADER_ID, REQ_NUMBER, TYPE, PREPARER, DESCRIPTION,
             AUTH_STATUS, TOTAL, STATUS, ERROR_MESSAGE, CREATION_DATE, CREATED_BY,
             LAST_UPDATED_BY, UPDATED_BY, REQUEST_ID, BATCH_ID, RECORD_ID
          ) VALUES (
             'Vision Operations', XXQGEN_PO_REQ_HEADER_ID.CURRVAL, 15567, 'Purchase Requisition', 'Smith, Mr. Winston Harvey',
             'REQ TEST', 'APPROVED', 554, 'N', NULL, SYSDATE, GN_USER_ID, SYSDATE, GN_USER_ID, GN_REQUEST_ID, P_BATCH_ID, XXQGEN_REC_ID_DK.NEXTVAL
          );
          
--          SELECT *
--          FROM PER_ALL_PEOPLE_F
--          WHERE SYSDATE BETWEEN TRUNC(EFFECTIVE_START_DATE) AND TRUNC(EFFECTIVE_END_DATE)
--              AND (CURRENT_EMPLOYEE_FLAG = 'Y' OR CURRENT_NPW_FLAG = 'Y');
--          
--          -- DEBUG
--            DBMS_OUTPUT.PUT_LINE('WORKING AFTER HEADER1');
          -- Insert into Line Staging Table
          INSERT INTO XXQGEN_PO_REQ_LINE_STG_DK (
             LINE_ID, HEADER_ID, LINE_NUM, ITEM, ITEM_ID, REV, CATAGORY, CATEGORY_ID,
             DESCREPTION, UOM, QUANTITY, PRICE, NEED_BY_DATE, AMOUNT, CHARGE_ACCOUNT,
             DESTINATION_TYPE, REQUESTER, REQUESTER_ID, ORGANIZATION, ORG_ID,
             LOCATION, LOCATION_ID, SOURCE, SUPPLIER, SITE, CONTACT, PHONE, TO_PERSON_ID, STATUS,
             ERROR_MESSAGE, CREATION_DATE, CREATED_BY, LAST_UPDATED_BY, UPDATED_BY,
             REQUEST_ID, BATCH_ID, RECORD_ID
          ) VALUES (
             XXQGEN_PO_REQ_LINE_ID.NEXTVAL, -- LINE ID
             XXQGEN_PO_REQ_HEADER_ID.CURRVAL, -- HEADER_ID
             1, -- LINE NUM
             'IR0011', -- ITEM
             NULL, -- ITEM_ID
             NULL, -- REV
             'MISCMISC', -- CATAGORY
             NULL, --CATEGORY ID
             'OK', -- DESCREPTION
             'Each', -- UOM
             5, -- QUANTITY
             100, -- PRICE
             NULL, -- NEEDBY
             NULL, -- AMOUNT
             NULL, -- CHARGE_ACCOUNT
             'EXPENSE', --DESTINATION_TYPE
             'Stock, Ms. Pat', --REQUESTOR
             NULL, -- REQUESTOR_ID
              'Vision Operations', --ORGANIZATION
              NULL, -- ORG_ID
             'V1- New York City', -- LOCATION
             NULL, --LOCATION_ID
             'Supplier',-- SOURCE
              'Kingston, Max', -- SUPPLIER
              'OFFICE', -- SITE
              '', -- CONTACT
              NULL, --PHONE
              NULL,
              'N', -- STATUS
              NULL, -- ERROR MESSAGE
               SYSDATE, FND_PROFILE.VALUE('USER_ID'),
             SYSDATE, FND_PROFILE.VALUE('USER_ID'), 
             GN_REQUEST_ID, 
             P_BATCH_ID,
              XXQGEN_REC_ID_DK.NEXTVAL
          );
          
          COMMIT;

          DBMS_OUTPUT.PUT_LINE('LOAD_DATA COMPLETED');
       EXCEPTION
          WHEN OTHERS THEN
             DBMS_OUTPUT.PUT_LINE('ERROR IN LOAD_DATA: ' || SQLCODE || ' ' || SQLERRM);
       END LOAD_DATA;

   /*************************************************************************************************
    * Program Name : MAIN
    * Language     : PL/SQL     
    * Description  : Main process to Load, Validate and Process Data.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         17-FEB-2025     Initial Version
    *DKUMAR           1.1         18-FEB-2025     ADDING HEADER VALIDATION
    ***************************************************************************************************/
       PROCEDURE MAIN(errbuf   out varchar2, retcode  out number)
       IS
         LV_BATCH_ID           NUMBER      := XXQGEN_PO_REQ_BATCH_ID_DK.NEXTVAL;
         LV_HEADER_ID   NUMBER;
       BEGIN
       
          SELECT XXQGEN_PO_REQ_HEADER_ID.NEXTVAL
          INTO LV_HEADER_ID
          FROM DUAL;
       
          LOAD_DATA(LV_BATCH_ID);
          VALIDATE_REQUIRE(LV_BATCH_ID);
          VALIDATION(LV_BATCH_ID);
          PROCESS_DATA(LV_BATCH_ID);
       EXCEPTION
          WHEN OTHERS THEN
             DBMS_OUTPUT.PUT_LINE('ERROR IN MAIN: ' || SQLCODE || ' ' || SQLERRM);
       END MAIN;
       
       PROCEDURE BEFOREREPORT
       IS
         LV_BATCH_ID           NUMBER;
         LV_HEADER_ID   NUMBER;
       BEGIN
          SELECT XXQGEN_PO_REQ_BATCH_ID_DK.NEXTVAL
          INTO LV_BATCH_ID
          FROM DUAL;
          
          
          SELECT XXQGEN_PO_REQ_HEADER_ID.NEXTVAL
          INTO LV_HEADER_ID
          FROM DUAL;
       
          LOAD_DATA(LV_BATCH_ID);
          VALIDATE_REQUIRE(LV_BATCH_ID);
          VALIDATION(LV_BATCH_ID);
          PROCESS_DATA(LV_BATCH_ID);
       EXCEPTION
          WHEN OTHERS THEN
             DBMS_OUTPUT.PUT_LINE('ERROR IN MAIN: ' || SQLCODE || ' ' || SQLERRM);
       END BEFOREREPORT;
    END XXQGEN_REQ_INT_DK;
    /
