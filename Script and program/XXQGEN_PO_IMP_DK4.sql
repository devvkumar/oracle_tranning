/* Formatted on 3/10/2025 1:11:53 PM (QP5 v5.163.1008.3004) */
CREATE OR REPLACE PACKAGE BODY XXQGEN_PO_IMP_DK
AS

    /***************************************************************************************************
    * Program Name : XXQGEN_PO_IMP_DK.pkb
    * Language     : PL/SQL
    * Description  : Specks for XXQGEN_PO_IMP_DK.pkb
    * History      :
    * WHO                                  Version #           WHEN                        WHAT
    * =================================================================================================
    * DKUMAR                       1.0                     23-FEB-2025             Initial Version
    ***************************************************************************************************/

    /*************************************************************************************************
    * Program Name : VALID_ORG
    * Language     : PL/SQL     
    * Description  : VALID_ORG process to valdiate ORGANIZATION name.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         23-FEB-2025     Initial Version
    ***************************************************************************************************/
    FUNCTION valid_org (
        p_operating_unit VARCHAR2
    ) RETURN NUMBER IS
        lV_org_id NUMBER;
    BEGIN
        IF P_OPERATING_UNIT IS NULL THEN
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'OPERATING UNIT IS NULL');
            RETURN -1;
        END IF;
        
        
        SELECT
            organization_id
        INTO lV_org_id
        FROM
            hr_operating_units
        WHERE
            name = p_operating_unit;

        RETURN lV_org_id;
    EXCEPTION
        WHEN OTHERS THEN
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN VALID ORG : ' || SQLCODE || ' - ' || SQLERRM);
            RETURN 0;
    END valid_org;
    
    
    
     /*************************************************************************************************
        * Program Name : GET_CHART_ACCOUNT_ID
        * Language     : PL/SQL     
        * Description  : GET_CHART_ACCOUNT_ID process to get chart account id.
        * History      : 
        *
        * WHO              Version #   WHEN            WHAT
        * ======================================================================
        * DKUMAR           1.0         24-FEB-2025     Initial Version
        ***************************************************************************************************/
    FUNCTION get_chart_account_id (
        charge_account VARCHAR2,
        p_org_id       NUMBER
    ) RETURN NUMBER AS
        ln_chart_account_id NUMBER := NULL;
    BEGIN
    
        IF CHARGE_ACCOUNT IS NULL THEN
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'CHARGE_ACCOUNT IN NULL');
            RETURN -1;
        END IF;
        IF CHARGE_ACCOUNT IS NULL THEN
        
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'CHARGE_ACCOUNT IN NULL');
            RETURN -1;
        END IF;
        
        SELECT
            gcc.code_combination_id
        INTO ln_chart_account_id
        FROM
            gl_sets_of_books     gsb,
            gl_code_combinations gcc
        WHERE
                gsb.set_of_books_id = fnd_profile.value('GL_SET_OF_BKS_ID')
            AND gsb.chart_of_accounts_id = gcc.chart_of_accounts_id
            AND gcc.segment1
                || '-'
                || gcc.segment2
                || '-'
                || gcc.segment3
                || '-'
                || gcc.segment4
                || '-'
                || gcc.segment5 = charge_account;

        RETURN ln_chart_account_id;
    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.log, 'error in get chart account id : '
                                            || sqlcode
                                            || ' - '
                                            || sqlerrm);

            RETURN 0;
    END get_chart_account_id;
    
    FUNCTION VALID_LINE_TYPE(P_LINE_TYPE VARCHAR2)
    RETURN NUMBER
    IS
        LV_LINE_TYPE_ID     NUMBER;
    BEGIN
        IF P_LINE_TYPE IS NULL THEN
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'P_LINE_TYPE IS NULL');
            RETURN -1;
        END IF;
        
        SELECT LINE_TYPE_ID
        INTO LV_LINE_TYPE_ID
        FROM PO_LINE_TYPES
        WHERE LINE_TYPE = P_LINE_TYPE;
        
        RETURN LV_LINE_TYPE_ID;
    
    EXCEPTION
        WHEN OTHERS THEN
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN VALID_LINE_TYPE FUNCTION : ' || SQLCODE || ' - ' || SQLERRM );
            RETURN 0;
    END VALID_LINE_TYPE;
    
    FUNCTION VALID_CURRENCY(P_CURRENCY VARCHAR2)
    RETURN VARCHAR2
    IS
        LV_CURR_CODE        VARCHAR2(20);
    BEGIN
        IF P_CURRENCY IS NULL THEN
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'CURRENCY IS NULL');
            RETURN -1;
        END IF;
        
        SELECT CURRENCY_CODE
        INTO LV_CURR_CODE
        FROM FND_CURRENCIES;
        
        RETURN LV_CURR_CODE;
    EXCEPTION
        WHEN OTHERS THEN
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN VALID CURRENCY : ' || SQLCODE || ' - ' || SQLERRM );
            RETURN 0;
    END VALID_CURRENCY;
    
    
    FUNCTION VALID_BUYER(P_BUYER_NAME VARCHAR2)
    RETURN NUMBER
    IS
        LN_AGENT_ID        NUMBER;
    BEGIN
        SELECT agent_id
        INTO LN_AGENT_ID
        FROM PO_AGENTS_V
        WHERE AGENT_NAME = P_BUYER_NAME
          AND SYSDATE BETWEEN START_DATE_ACTIVE AND END_DATE_ACTIVE;
          
        RETURN LN_AGENT_ID;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('ERROR IN VALID BUYER PROCEDURE : ' || SQLCODE || ' - ' || sqlerrm);
            RETURN 0;
    END VALID_BUYER;
    
    
    /*************************************************************************************************
    * Program Name : VALID_TYPE
    * Language     : PL/SQL     
    * Description  : VALID_TYPE process to valdiate VALIDATION TYPE name.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         23-FEB-2025     Initial Version
    ***************************************************************************************************/

    FUNCTION valid_type (
        p_type VARCHAR2,
        p_org  NUMBER
    ) RETURN VARCHAR2 IS
        lc_code VARCHAR2(50);
    BEGIN
        IF P_TYPE IS NULL THEN
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'TYPE IS NULL');
            RETURN -1;
        END IF;
        
        SELECT 
            document_subtype
        INTO lc_code
        FROM
            po_document_types_all_vl
        WHERE
                1 = 1
            AND type_name = 'Standard Purchase Order'
            AND org_id = p_org;

        RETURN lc_code;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END valid_type;
    
    
    /*************************************************************************************************
    * Program Name : VALID_REQUESTOR_ID
    * Language     : PL/SQL     
    * Description  : VALID_REQUESTOR_ID process to valdiate REQUESTER name.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         23-FEB-2025     Initial Version
    ***************************************************************************************************/

    FUNCTION valid_preparer (
        p_preparer VARCHAR2
    ) RETURN NUMBER IS
        lc_id NUMBER;
    BEGIN
        SELECT
            person_id
        INTO lc_id
        FROM
            per_all_people_f
        WHERE
                1 = 1
            AND full_name = p_preparer
            AND sysdate BETWEEN trunc(effective_start_date) AND trunc(effective_end_date)
            AND ( current_npw_flag = 'Y'
                  OR current_employee_flag = 'Y' );

        RETURN lc_id;
    EXCEPTION
        WHEN no_data_found THEN
            RETURN 0;
    END valid_preparer;

-- VALID TOTAL MISSING
--    FUNCTION valid_total (
--        p_hdr      NUMBER,
--        p_batch_id NUMBER
--    ) RETURN NUMBER IS
--        ln_total NUMBER;
--    BEGIN
--        SELECT
--            SUM(amount)
--        INTO ln_total
--        FROM
--            xxqgen_po_line_stg_dk
--        WHERE
--                1 = 1
--            AND header_id = p_hdr
--            AND batch_id = p_batch_id;
--
--        RETURN ln_total;
--    EXCEPTION
--        WHEN no_data_found THEN
--            RETURN 0;
--    END valid_total;
    
    
    /*************************************************************************************************
    * Program Name : VALID_ITEM
    * Language     : PL/SQL     
    * Description  : VALID_ITEM process to valdiate item.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         23-FEB-2025     Initial Version
    ***************************************************************************************************/

    FUNCTION valid_item (
        item   VARCHAR2,
        org_id NUMBER
    ) RETURN NUMBER IS
        lv_item_id NUMBER;
    BEGIN
        SELECT
            inventory_item_id
        INTO lv_item_id
        FROM
            mtl_system_items_b
        WHERE
                segment1 = item
            AND organization_id = org_id;

        RETURN lv_item_id;
    EXCEPTION
        WHEN no_data_found THEN
            RETURN 0;
    END valid_item;
    
    
    /*************************************************************************************************
    * Program Name : VALID_CATEGORY
    * Language     : PL/SQL     
    * Description  : VALID_CATEGORY process to valdiate Category.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         23-FEB-2025     Initial Version
    ***************************************************************************************************/

    FUNCTION valid_category (
        category VARCHAR2
    ) RETURN NUMBER IS
        lv_cat_id NUMBER;
    BEGIN
        SELECT
            category_id
        INTO lv_cat_id
        FROM
            mtl_categories
        WHERE
            segment1
            || '.'
            || segment2 = category;

        RETURN lv_cat_id;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END valid_category;
    
    
     /*************************************************************************************************
    * Program Name : VALID_LOCATION
    * Language     : PL/SQL     
    * Description  : VALID_LOCATION process to valdiate LOCATION.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         23-FEB-2025     Initial Version
    ***************************************************************************************************/

    FUNCTION valid_location (
        location VARCHAR2
    ) RETURN NUMBER IS
        lv_loc_id NUMBER;
    BEGIN
        SELECT
            location_id
        INTO lv_loc_id
        FROM
            hr_locations
        WHERE
            location_code = location;

        RETURN lv_loc_id;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END valid_location;
    
    /*************************************************************************************************
    * Program Name : VALID_SUPPLIER
    * Language     : PL/SQL     
    * Description  : VALID_SUPPLIER process to valdiate Supplier.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         23-FEB-2025     Initial Version
    ***************************************************************************************************/

    FUNCTION valid_supplier (
        P_van_name VARCHAR2,
        P_ORG_ID    NUMBER
    ) RETURN NUMBER IS
        lv_vendor_id NUMBER;
    BEGIN
        SELECT 
            vendor_id
        INTO lv_vendor_id
        FROM
            ap_suppliers
        WHERE
            vendor_name = P_van_name;

        RETURN lv_vendor_id;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END valid_supplier;
    
    
   /*************************************************************************************************
    * Program Name : VALID_SITE
    * Language     : PL/SQL     
    * Description  : VALID_SITE process to valdiate Site.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         23-FEB-2025     Initial Version
    ***************************************************************************************************/

    FUNCTION valid_site (
        P_site VARCHAR2,
        P_VENDOR_ID NUMBER,
        P_ORG_ID    NUMBER
    ) RETURN NUMBER IS
        lv_site_id NUMBER;
    BEGIN
        SELECT VENDOR_SITE_ID
        INTO lv_site_id
        FROM
            ap_supplier_sites_all
        WHERE
            vendor_site_code = P_site
        AND 
            VENDOR_ID = P_VENDOR_ID
        AND 
            ORG_ID = P_ORG_ID;

        RETURN lv_site_id;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END valid_site;

-- INCOMPLETE
--    FUNCTION VALID_UOM(UOM VARCHAR2)
--    RETURN VARCHAR2
--    IS
--        LV_UOM_CODE VARCHAR2;
--    BEGIN
--    
--        SELECT *
--        FROM MTL_UNITS_OF_MEASURE;
----        WHERE ;
--        
--    EXCEPTION
--        WHEN OTHERS THEN
--            FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN VALID UOM : ' || SQLCODE || ' - ' || SQLERRM);
--    END VALID_UOM;    
   
    
   /*************************************************************************************************
    * Program Name : Validation
    * Language     : PL/SQL     
    * Description  : Validattion process to validate data.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         23-FEB-2025     Initial Version
    ***************************************************************************************************/

    PROCEDURE process (
        p_batch_id NUMBER
    ) IS

--        CURSOR cur_int IS
--        SELECT
--            hdr.operating_unit,
--            hdr.auth_status,
--            hdr.preparer_id,
--            hdr.org_id,
--            hdr.description,
--            hdr.total,
--            line.line_num,
--            line.item_id,
--            line.category_id,
--            line.descreption           AS description_line,
--            line.uom,
--            line.quantity,
--            line.price                 AS unit_price,
--            line.need_by_date          AS need_by_date,
--            line.destination_type,
--            line.requester_id,
--            line.org_id                AS destination_organization_id,
--            line.ship_to_location_code AS deliver_to_location_id,
--            line.supplier_id           AS vendor_id,
--            line.site_id               AS vendor_site_id,
--            line.charge_account,
--            hdr.creation_date,
--            hdr.created_by,
--            hdr.last_updated_by,
--            hdr.LAST_updated_by,
--            hdr.record_id,
--            line.record_id             line_record_id
--        FROM
--            xxqgen_po_hdr_stg_dk  hdr,
--            xxqgen_po_line_stg_dk line
--        WHERE
--                hdr.INTERFACE_header_id = line.INTERFACE_header_id
--            AND hdr.status = 'V'
--            AND line.status = 'V'
--            AND hdr.batch_id = p_batch_id;
--
--        TYPE tbl_type IS
--            TABLE OF cur_int%rowtype;
--        insert_tbl    tbl_type;
--        ln_header_id  NUMBER;
--        gn_request_id NUMBER := p_batch_id;
        
        CURSOR CUR_HEAD IS
        SELECT *
        FROM XXQGEN_PO_HDR_STG_DK
        WHERE 1=1
            AND STATUS = 'V'
            AND REQUEST_ID = GN_REQUEST_ID;
            
        CURSOR CUR_LINE(HEADER_ID NUMBER) IS
        SELECT *
        FROM XXQGEN_PO_LINE_STG_DK
        WHERE 1=1
            AND STATUS = 'V'
            AND REQUEST_ID = GN_REQUEST_ID
            AND INTERFACE_HEADER_ID = HEADER_ID;
            
        CURSOR CUR_LINE_LOC(LINE_ID NUMBER, HEADER_ID NUMBER, BATCH_ID NUMBER) IS
        SELECT *
        FROM XXQGEN_PO_LINE_LOC_STG_DK
        WHERE 1=1
            AND STATUS = 'V'
            AND REQUEST_ID = GN_REQUEST_ID
            AND INTERFACE_LINE_ID = LINE_ID
            AND INTERFACE_HEADER_ID = HEADER_ID;
            
        CURSOR CUR_DIST(LINE_ID NUMBER, HEADER_ID NUMBER, BATCH_ID  NUMBER) IS
        SELECT *
        FROM XXQGEN_PO_DIST_STG_DK
        WHERE 1=1
            AND STATUS = 'V'
            AND REQUEST_ID = GN_REQUEST_ID
            AND INTERFACE_HEADER_ID = HEADER_ID
            AND INTERFACE_LINE_ID = LINE_ID;

    BEGIN
        dbms_output.put_line('PROCESS START');

        
        FOR REC_HEAD IN CUR_HEAD LOOP
            BEGIN
                FOR REC_LINE IN CUR_LINE(REC_HEAD.INTERFACE_HEADER_ID) LOOP
                    BEGIN
                        FOR REC_DIST IN CUR_DIST (REC_HEAD.INTERFACE_HEADER_ID , REC_LINE.INTERFACE_LINE_ID, REC_HEAD.BATCH_ID) LOOP
                            BEGIN
                                 INSERT INTO po_distributions_interface (interface_header_id,
                                      interface_line_id,
                                      interface_distribution_id,
                                      distribution_num,
                                      quantity_ordered,
                                      charge_account_id,
                                      created_by,
                                      creation_date,
                                      last_updated_by,
                                      last_update_date,
                                      last_update_login)
                                    VALUES (po_headers_interface_s.CURRVAL, -- interface_header_id
                                      po_lines_interface_s.CURRVAL, -- interface_line_id
                                      po_distributions_interface_s.NEXTVAL, -- interface_distribution_id
                                      REC_DIST.distribution_num,
                                      REC_DIST.quantity_ordered,
                                      REC_DIST.charge_account_id,
                                      REC_DIST.created_by,
                                      REC_DIST.creation_date,
                                      REC_DIST.last_updated_by,
                                      REC_DIST.last_update_date,
                                      REC_DIST.last_update_login);

                            
                            EXCEPTION
                                WHEN OTHERS THEN
                                    FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN REC_DIST' || SQLCODE || ' - ' || SQLERRM);
                            END;
                        END LOOP;
                    
                        FOR REC_LINE_LOC IN CUR_LINE_LOC (REC_HEAD.INTERFACE_HEADER_ID, REC_LINE.INTERFACE_LINE_ID, REC_HEAD.BATCH_ID) LOOP
                            BEGIN
                                INSERT INTO po_line_locations_interface(
                                      interface_header_id,
                                      interface_line_id,
                                      interface_line_location_id,
                                      shipment_num,
                                      created_by, creation_date,
                                      last_updated_by, 
                                      last_update_date,
                                      last_update_login,
                                      qty_rcv_exception_code,
                                      days_early_receipt_allowed,
                                      allow_substitute_receipts_flag,
                                      days_late_receipt_allowed,
                                      receipt_days_exception_code,
                                      enforce_ship_to_location_code,
                                      need_by_date,
                                      promised_date)
                              VALUES (po_headers_interface_s.CURRVAL, -- interface_header_id
                                      po_lines_interface_s.CURRVAL, -- interface_line_id
                                      po_line_locations_interface_s.NEXTVAL, -- interface_line_location_id
                                      REC_LINE_LOC.shipment_num,
                                      REC_LINE_LOC.created_by, 
                                      REC_LINE_LOC.creation_date,
                                      REC_LINE_LOC.last_updated_by, 
                                      REC_LINE_LOC.last_update_date,
                                      REC_LINE_LOC.last_update_login,
                                      REC_LINE_LOC.qty_rcv_exception_code,
                                      REC_LINE_LOC.days_early_receipt_allowed,
                                      REC_LINE_LOC.allow_substitute_receipts_flag,
                                      REC_LINE_LOC.days_late_receipt_allowed,
                                      REC_LINE_LOC.receipt_days_exception_code,
                                      REC_LINE_LOC.enforce_ship_to_location_code,
                                      REC_LINE_LOC.need_by_date,
                                      REC_LINE_LOC.promised_date);
                            EXCEPTION
                                WHEN OTHERS THEN
                                    FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN REC_LINE_LOC LOOP : ' || SQLCODE || ' - ' || SQLERRM);
                            END;
                        END LOOP;
                         INSERT INTO po_lines_interface (interface_header_id,
                              interface_line_id,
                              po_header_id,
                              po_line_id,
                              action,
                              document_num,
                              line_type_id,
                              item,
                              uom_code,
                              quantity,
                              unit_price,
                              need_by_date,
                              promised_date,
                              ship_to_organization_code,
                              enforce_ship_to_location_code,
                              receiving_routing_id,
                              line_attribute15,
                              line_num,
                              created_by,
                              creation_date,
                              last_updated_by,
                              last_update_date,
                              last_update_login,
                              vendor_product_num,
                              CATEGORY,
                              item_description,
                              note_to_vendor,
                              invoice_close_tolerance,
                              receive_close_tolerance,
                              qty_rcv_tolerance,
                              item_revision,
                              list_price_per_unit,
                              line_loc_populated_flag)
                        VALUES (po_headers_interface_s.CURRVAL, -- interface_header_id
                              po_lines_interface_s.NEXTVAL,  -- interface_line_id
                              po_headers_s.CURRVAL,         -- po_header_id
                              po_lines_s.NEXTVAL,             -- po_line_id
                              'ADD',                              -- action
                              REC_LINE.document_num,           -- document_num
                              REC_line.LINE_type_id,              -- line_type_id
                              REC_line.item,                -- item
                              REC_line.uom_code,           -- uom_code
                              REC_line.quantity,                -- quantity
                              REC_line.unit_price,           -- unit_price
                              REC_line.need_by_date,       -- need_by_date
                              REC_line.promised_date,     -- promised_date
                              REC_LINE.ship_to_organization_code, -- ship_to_organization_code
                              'WARNING',   -- enforce_ship_to_location_code
                              NULL,                 -- receiving_routing_id
                              REC_line.line_num,    -- line_attribute15
                              REC_line.line_num,            -- line_num
                              REC_LINE.CREATED_BY,                     -- created_by
                              SYSDATE,                     -- creation_date
                              REC_LINE.LAST_UPDATED_BY,                -- last_updated_by
                              SYSDATE,                  -- last_update_date
                              REC_LINE.LAST_UPDATE_LOGIN,              -- last_update_login
                              REC_line.vendor_product_num, -- vendor_product_num
                              REC_line.CATEGORY,               -- category
                              REC_line.item_description, -- item_description
                              REC_line.note_to_vendor,   -- note_to_vendor
                              REC_line.invoice_close_tolerance, -- invoice_close_tolerance
                              REC_line.receive_close_tolerance, -- receive_close_tolerance
                              REC_line.qty_rcv_tolerance,     -- qty_rcv_tolerance
                              REC_line.item_revision,     --item_revision
                              REC_line.list_price_per_unit,  --list_price_per_unit
                              'Y'
                              );
                    
                    EXCEPTION 
                        WHEN OTHERS THEN
                            FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN REC_LINE LOOP : ' || SQLCODE || ' - ' || SQLERRM);
                    END;
                END LOOP;
                
                 INSERT INTO po_headers_interface
                (interface_header_id,
                 interface_source_code,
                 action,
                 po_header_id,
                 document_type_code,
                 document_subtype,
                 agent_id,
                 document_num,
                 vendor_id,
                 vendor_site_id,
                 vendor_site_code,
                 ship_to_location,
                 bill_to_location,
                 attribute_category,
                 vendor_contact_id,
                 created_by,
                 creation_date,
                 last_updated_by,
                 last_update_date,
                 last_update_login,
--                 supply_agreement_flag,
                 expiration_date,
                 org_id, rate,
                 currency_code,
                 rate_type,
                 rate_date,
                 comments, 
                 freight_carrier,
                 effective_date
                )
                VALUES (po_headers_interface_s.NEXTVAL, -- interface_header_id
                 'XX007', -- interface_source_code
                 'ORIGINAL', -- action
                 po_headers_s.NEXTVAL, -- po_header_id
                 REC_HEAD.document_type_code, -- document_type_code
                 REC_HEAD.document_subtype, -- document_subtype
                 REC_HEAD.AGENT_ID,         -- agent_id
                 REC_HEAD.document_num,  -- document_num
                 REC_HEAD.vendor_id,        -- vendor_id
                 REC_HEAD.vendor_site_id,   -- vendor_site_id
                 NULL,                -- vendor_site_code
                 REC_HEAD.ship_to_location, -- ship_to_location
                 REC_HEAD.bill_to_location, -- bill_to_location
                 REC_HEAD.ATTRIBUTE_CATEGORY,        -- PROBLEM                 REC_HEAD.TYPE,        -- attribute_category
                 REC_HEAD.vendor_contact_id, -- vendor_contact_id
                 REC_HEAD.created_by,           -- created_by
                 REC_HEAD.creation_date, -- creation_date
                 REC_HEAD.last_updated_by, -- last_updated_by
                 SYSDATE,    -- last_update_date
                 REC_HEAD.LAST_UPDATE_LOGIN, -- last_update_login
--                 NULL,       -- supply_agreement_flag
                 NULL,       -- expiration_date
                 REC_HEAD.org_id, -- org_id
                 REC_HEAD.rate, -- rate
                 REC_HEAD.currency_code, -- currency_code
                 REC_HEAD.rate_type, -- rate_type
                 REC_HEAD.rate_date, -- rate_date
                 REC_HEAD.comments, -- comments
                 REC_HEAD.freight_carrier, -- freight_carrier
                 REC_HEAD.effective_date -- effective_date
                );

                
            EXCEPTION
                WHEN OTHERS THEN
                    FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN PROCESS REC_HEAD LOOP FOR HEADER_ID : ' || REC_HEAD.INTERFACE_HEADER_ID || '\N ERROR : ' || 
                                                  SQLCODE || ' - ' || SQLERRM);
            END;
        END LOOP;
        
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            fnd_file.put_line(fnd_file.log, 'ERROR CREATE REQ INTERFACE DTLS: ' || sqlerrm);
    END process;
  

    /*************************************************************************************************
    * Program Name : PROCESS_DATA
    * Language     : PL/SQL     
    * Description  : PROCESS_DATA process to import PO_REQUISITION details.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         23-FEB-2025     Initial Version
    ***************************************************************************************************/

    PROCEDURE submit_requisition AS

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
    BEGIN
        fnd_global.apps_initialize(gn_user_id, gn_resp_id, gn_resp_appl_id);
        mo_global.init('PO');
        fnd_request.set_org_id(gn_org_id);
        ln_request := fnd_request.submit_request(application => 'PO', program => 'REQIMPORT', argument1 => '', argument2 => gn_request_id
        , argument3 => 'ALL',
                                                argument4 => NULL, argument5 => 'N', argument6 => 'N');
 
        COMMIT;
        fnd_file.put_line(fnd_file.log, 'REQUEST TO UPLOAD REQUISITION LEGACY DATA START1: ' || gn_request_id);
        IF ln_request = 0 THEN
            fnd_file.put_line(fnd_file.log, 'REQUEST TO UPLOAD REQUISITION LEGACY DATA NOT SUBMITTED: ' || gn_request_id);
        ELSIF ln_request > 0 THEN
            LOOP
                lc_conc_status := fnd_concurrent.wait_for_request(request_id => ln_request, INTERVAL => ln_interval, max_wait => ln_max_wait
                , phase => lc_phase, status => lc_status,
                                                                 dev_phase => lc_dev_phase, dev_status => lc_dev_status, message => lc_message
                                                                 );

                EXIT WHEN upper(lc_phase) = 'COMPLETED' OR upper(lc_status) IN ( 'CANCELLED', 'ERROR', 'TERMINATED' );

            END LOOP;
        END IF;

        fnd_file.put_line(fnd_file.log, 'REQUEST TO UPLOAD REQUISITION LEGACY DATA START2.');
--        fnd_file.put_line (fnd_file.LOG,
--
--                         'Submitting XXQGEN_REQ_STG_PKG_RPT_AK..');
--
--      mo_global.init ('PO');
--
--      gn_cp_request_id := 0;
--
--      ln_exit_point := 0;
--
--      l_layout :=
--
--         fnd_request.add_layout (
--
--            template_appl_name   => 'PO',
--
--            template_code        => 'XXQGEN_REQ_STG_PKG_RPT_AK',
--
--            template_language    => 'en',
--
--            template_territory   => null,
--
--            output_format        => 'RTF'   -- Ensure this is a valid format
--
--                                           );

    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.log, 'ERROR IN REQUISITION SUBMIT PROCESS: ' || sqlerrm);
    END submit_requisition;

--    PROCEDURE validate (
--        p_batch_id NUMBER
--    ) IS
--
--        CURSOR CUR_HEAD IS
--        SELECT *
--        FROM XXQGEN_PO_HDR_STG_DK
--        WHERE 1=1
--          AND BATCH_ID = P_BATCH_ID
--          AND REQUEST_ID = GN_REQUEST_ID
--          AND STATUS = 'N';
--          
--          CURSOR CUR_LINE(HDR_ID NUMBER) IS
--        SELECT *
--        FROM xxqgen_po_line_stg_dk
--        WHERE 1=1
--          AND BATCH_ID = P_BATCH_ID
--          AND REQUEST_ID = GN_REQUEST_ID
--          AND INTERFACE_HEADER_ID = HDR_ID
--          AND STATUS = 'N';
--        
--        CURSOR CUR_DIST(HDR_ID NUMBER) IS
--        SELECT *
--        FROM XXQGEN_PO_DIST_STG_DK
--        WHERE 1=1
--          AND BATCH_ID = P_BATCH_ID
--          AND REQUEST_ID = GN_REQUEST_ID
--          AND INTERFACE_HEADER_ID = HDR_ID
--          AND STATUS = 'N';
--        
--        CURSOR CUR_LINE_LOC(LINE NUMBER, HDR_ID NUMBER) is
--        SELECT *
--        FROM XXQGEN_PO_LINE_LOC_STG_DK
--        WHERE BATCH_ID = p_batch_id
--          AND REQUEST_ID = gn_request_id
--          AND INTERFACE_LINE_ID = LINE
--          AND INTERFACE_HEADER_ID = HDR_ID
--          AND STATUS = 'N';
--          
--    BEGIN
--    
--        FND_FILE.PUT_LINE(FND_FILE.LOG, 'WORKING VALIDATION');
--    
--        FOR REC_HEAD IN CUR_HEAD LOOP
--            BEGIN
--            
--            FND_FILE.PUT_LINE(FND_FILE.LOG, 'WORKING HEADER CURSOR');
--        
--            REC_HEAD.STATUS := 'V';
--            REC_HEAD.ERROR_MESSAGE := '';
--        
--        -- VALIDATION IN HEADER : batch_id, process_code, action, org_id, document_type_code, currency_code, agent_id, vendor_name, vendor_site_code, ship_to_location, bill_to_location, reference_num
--            REC_HEAD.ORG_ID := NVL(VALID_ORG(REC_HEAD.ORG),-1);
--            IF(REC_HEAD.ORG_ID = -1) THEN
--                REC_HEAD.STATUS := 'E';
--                REC_HEAD.ERROR_MESSAGE := 'ORG ID IS NULL ';
--            ELSIF REC_HEAD.ORG_ID = 0 THEN
--                REC_HEAD.STATUS := 'E';
--                REC_HEAD.ERROR_MESSAGE := 'ORG ID IS INVALID ';
--            END IF;
--            
--            FND_FILE.PUT_LINE(FND_FILE.LOG, 'WORKING ORG FUNCTON \N ORG_ID : ' || REC_HEAD.ORG_ID);
--            
--            REC_HEAD.document_type_CODE := NVL(VALID_TYPE(REC_HEAD.document_SUBtype, REC_HEAD.ORG_ID),'-1');
--            IF(REC_HEAD.ORG_ID = '-1') THEN
--                REC_HEAD.STATUS := 'E';
--                REC_HEAD.ERROR_MESSAGE := 'DOCUMENT TYPE IS NULL ';
--            ELSIF REC_HEAD.ORG_ID = '0' THEN
--                REC_HEAD.STATUS := 'E';
--                REC_HEAD.ERROR_MESSAGE := 'DOCUMENT IS INVALID ';
--            END IF;
--            
--            -- CURRENCY CODE 
--            REC_HEAD.currency_CODE := NVL(VALID_CURRENCY(REC_HEAD.currency),'-1');
--            IF(REC_HEAD.currency_CODE = '-1') THEN
--                REC_HEAD.STATUS := 'E';
--                REC_HEAD.ERROR_MESSAGE := 'currency_CODE IS NULL ';
--            ELSIF REC_HEAD.currency_CODE = '0' THEN
--                REC_HEAD.STATUS := 'E';
--                REC_HEAD.ERROR_MESSAGE := 'currency CODE IS NULL ';
--            END IF;
--            
--            -- AGENT id
--            REC_HEAD.agent_id  := VALID_BUYER(REC_HEAD.agent_NAME);
--            IF(REC_HEAD.agent_id = -1) THEN
--                REC_HEAD.STATUS := 'E';
--                REC_HEAD.ERROR_MESSAGE := 'ORG ID IS NULL ';
--            ELSIF REC_HEAD.agent_id = 0 THEN
--                REC_HEAD.STATUS := 'E';
--                REC_HEAD.ERROR_MESSAGE := 'ORG ID IS NULL ';
--            END IF;
--            
--            -- VENDOR Name
--            REC_HEAD.vendor_id := VALID_SUPPLIER(REC_HEAD.vendor_NAME, REC_HEAD.ORG_ID);
--            IF(REC_HEAD.ORG_ID = -1) THEN
--                REC_HEAD.STATUS := 'E';
--                REC_HEAD.ERROR_MESSAGE := 'VENDOR IS NULL ';
--            ELSIF REC_HEAD.ORG_ID = 0 THEN
--                REC_HEAD.STATUS := 'E';
--                REC_HEAD.ERROR_MESSAGE := 'VENDOR IS NULL ';
--            ELSE 
--                REC_HEAD.vendor_site_ID := VALID_SITE(REC_HEAD.vendor_id, REC_HEAD.vendor_site_CODE, REC_HEAD.ORG_ID);
--                IF(REC_HEAD.ORG_ID = -1) THEN
--                    REC_HEAD.STATUS := 'E';
--                    REC_HEAD.ERROR_MESSAGE := 'ORG ID IS NULL ';
--                ELSIF REC_HEAD.ORG_ID = 0 THEN
--                    REC_HEAD.STATUS := 'E';
--                    REC_HEAD.ERROR_MESSAGE := 'ORG ID IS NULL ';
--                END IF;
--            END IF;
--            
--            REC_HEAD.ship_to_location_ID := valid_location(REC_HEAD.ship_to_location);
--            IF(REC_HEAD.ship_to_location_ID = -1) THEN
--                REC_HEAD.STATUS := 'E';
--                REC_HEAD.ERROR_MESSAGE := 'ORG ID IS NULL ';
--            ELSIF REC_HEAD.ship_to_location_ID = 0 THEN
--                REC_HEAD.STATUS := 'E';
--                REC_HEAD.ERROR_MESSAGE := 'ORG ID IS NULL ';
--            END IF;
--            
--            REC_HEAD.bill_to_location_ID := valid_location(REC_HEAD.bill_to_location);
--            IF(REC_HEAD.bill_to_location_ID = -1) THEN
--                REC_HEAD.STATUS := 'E';
--                REC_HEAD.ERROR_MESSAGE := 'ORG ID IS NULL ';
--            ELSIF REC_HEAD.bill_to_location_ID = 0 THEN
--                REC_HEAD.STATUS := 'E';
--                REC_HEAD.ERROR_MESSAGE := 'ORG ID IS NULL ';
--            END IF;
--            
--            UPDATE XXQGEN_po_hdr_stg_dk
--            set status = rec_head.status,
--                 error_message = rec_head.error_message,
--                 BILL_TO_LOCATION_ID = REC_HEAD.BILL_TO_LOCATION_ID,
--                 SHIP_TO_LOCATION_ID = REC_HEAD.SHIP_TO_LOCATION_ID,
--                 VENDOR_SITE_CODE = REC_HEAD.VENDOR_SITE_CODE,
--                 VENDOR_ID = REC_HEAD.VENDOR_ID,
--                 AGENT_ID = REC_HEAD.AGENT_ID,
--                 CURRENCY_CODE = REC_HEAD.CURRENCY_CODE,
--                 DOCUMENT_TYPE_CODE = REC_HEAD.DOCUMENT_TYPE_CODE,
--                 ORG_ID = REC_HEAD.ORG_ID
--            WHERE 1=1
--                AND REQUEST_ID = GN_REQUEST_ID
--                AND RECORD_ID = REC_HEAD.RECORD_ID;
--            
--            --VALIDATION FOR LINES : interface_line_id, interface_header_id, line_num, shipment_num, line_type, item, uom_code, quantity, unit_price, ship_to_organization_code, ship_to_location)
--            FOR REC_LINE IN CUR_LINE(REC_HEAD.INTERFACE_HEADER_ID) LOOP
--                BEGIN
--                -- MISSINH
----                REC_LINE.SHIPMENT_NUM
--                IF SQL%ROWCOUNT = 0 THEN
--                    REC_LINE.STATUS := 'E';
--                    REC_LINE.ERROR_MESSAGE := 'NO LINE FOUND ';
--                END IF;
--                
--                REC_LINE.LINE_tYPE_ID := VALID_LINE_TYPE(rec_line.LINE_TYPE);
--                IF(rec_line.LINE_TYPE_ID = -1) THEN
--                    rec_line.STATUS := 'E';
--                    rec_line.ERROR_MESSAGE := 'LINE_TYPE IS NULL ';
--                ELSIF rec_line.LINE_TYPE_ID = 0 THEN
--                    rec_line.STATUS := 'E';
--                    rec_line.ERROR_MESSAGE := 'LINE_TYPE IS INVALID ';
--                END IF;
--                
--                rec_line.item_id := VALID_ITEM(REC_LINE.item, rec_HEAD.ORG_ID);
--                IF(rec_line.ITEM_ID = -1) THEN
--                    rec_line.STATUS := 'E';
--                    rec_line.ERROR_MESSAGE := 'ITEM IS NULL ';
--                ELSIF rec_line.ITEM_ID = 0 THEN
--                    rec_line.STATUS := 'E';
--                    rec_line.ERROR_MESSAGE := 'ITEM IS INVALID ';
--                END IF;
--
----              
----                REC_LINE.uom_code := VALID_UOM(rec_line.UOM);
----                IF(rec_line.UOM = -1) THEN
----                    rec_line.STATUS := 'E';
----                    rec_line.ERROR_MESSAGE := 'UOM IS NULL ';
----                ELSIF rec_line.UOM_CODE = 0 THEN
----                    rec_line.STATUS := 'E'; 
----                    rec_line.ERROR_MESSAGE := 'UOM IS INVALID ';
----                END IF;
--                
--                -- MISISNG
----                REC_LINE.quantity
--                
--                REC_LINE.ship_to_organization_ID := valid_org(rec_line.ship_to_organization_CODE);
--                IF(rec_line.SHIP_TO_ORGANIZATION_ID = -1) THEN
--                    rec_line.STATUS := 'E';
--                    rec_line.ERROR_MESSAGE := 'SHIP_TO_ORG_ID IS NULL ';
--                ELSIF rec_line.SHIP_TO_ORGANIZATION_ID = 0 THEN
--                    rec_line.STATUS := 'E';
--                    rec_line.ERROR_MESSAGE := 'SHIP TO ORGANIZATION ID IS INVALID ';
--                END IF;
--                
--                REC_LINE.ship_to_location_ID := valid_location(rec_line.ship_to_location);
--                IF(rec_line.SHIP_to_location_ID = -1) THEN
--                    rec_line.STATUS := 'E';
--                    rec_line.ERROR_MESSAGE := 'SHIP_TO_ORGANIZATION_ID IS NULL ';
--                ELSIF rec_line.SHIP_to_location_ID = 0 THEN
--                    rec_line.STATUS := 'E';
--                    rec_line.ERROR_MESSAGE := 'SHIP_TO_ORGANIZATION_ID IS INVALID ';
--                END IF;
--                
--                FOR rec_line_loc in cur_line_loc(REC_HEAD.INTERFACE_HEADER_ID, REC_LINE.INTERFACE_LINE_ID) LOOP
--                    BEGIN
--                
--                    IF SQL%ROWCOUNT = 0 THEN
--                        REC_LINE_LOC.STATUS := 'E';
--                        REC_LINE_LOC.ERROR_MESSAGE := 'NO LINE LOCATION FOUND ';
--                    END IF;
--                    
--                -- interface_header_id, interface_line_id, interface_line_location_id, shipment_num, created_by, creation_date, last_updated_by,  
--                -- last_update_date, last_update_login, qty_rcv_exception_code,
--                -- days_early_receipt_allowed, allow_substitute_receipts_flag, days_late_receipt_allowed, receipt_days_exception_code, 
--                -- enforce_ship_to_location_code, need_by_date, promised_date
--                    rec_line_loc.ship_to_LOCATION_ID := VALID_LOCATION(REC_LINE_LOC.ship_to_location);
--                    IF(rec_line_loc.enforce_ship_to_LOCATION_CODE = -1) THEN
--                        rec_line_loc.STATUS := 'E';
--                        rec_line_loc.ERROR_MESSAGE := 'ORG ID IS NULL ';
--                    ELSIF rec_line_loc.ENFORCE_SHIP_to_location_CODE = 0 THEN
--                        rec_line_loc.STATUS := 'E';
--                        rec_line_loc.ERROR_MESSAGE := 'ORG ID IS NULL ';
--                    END IF;
--                    
--                    IF(rec_line_loc.need_by_date <= SYSDATE+1) THEN
--                        rec_line_loc.STATUS := 'E';
--                        rec_line_loc.error_message := 'ERROR IN NEED BY DATE';
--                    END IF;
--                    
--                    IF(rec_line_loc.promised_date <= SYSDATE+1) THEN
--                        rec_line_loc.STATUS := 'E';
--                        rec_line_loc.error_message := 'ERROR IN NEED BY DATE';
--                    END IF;
--                    
--                    UPDATE XXQGEN_PO_LINE_LOC_STG_DK
--                    SET STATUS = REC_LINE_LOC.STATUS,
--                           ERROR_MESSAGE = REC_LINE_LOC.ERROR_MESSAGE,
--                           ENFORCE_SHIP_TO_LOCATION_CODE = REC_LINE_LOC.ENFORCE_SHIP_TO_LOCATION_CODE
--                    WHERE 1=1
--                        AND REQUEST_ID = GN_REQUEST_ID
--                        AND RECORD_ID = REC_LINE_LOC.RECORD_ID;
--                           
--                        
--                    FND_FILE.PUT_LINE(FND_FILE.LOG, ' VALIDATION LINE LOC END ');
--                    
--                    EXCEPTION
--                        WHEN OTHERS THEN
--                            FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN HEADER_CURSOR : ' || SQLCODE || ' - ' || SQLERRM);
--                    
--                end loop;
--                
----                FOR REC_DIST IN CUR_DIST loop
----                    REC_DIST.STATUS := 'V';
----                    REC_DIST.ERROR_MESSAGE := '';
----                    
----                    IF SQL%ROWCOUNT = 0 THEN
----                        REC_DIST.STATUS := 'E';
----                        REC_DIST.ERROR_MESSAGE := 'NO LINE LOCATION FOUND ';
----                    END IF;
----                    
----                    -- interface_header_id, interface_line_id, interface_distribution_id, distribution_num, quantity_ordered, charge_account_id,
----                    REC_DIST.CHARGE_ACCOUNT_ID := get_chart_account_id(REC_DIST.charge_account, REC_HEAD.ORG_ID);
----                    IF REC_DIST.CHARGE_ACCOUNT_ID = -1 THEN
----                        REC_DIST.STATUS := 'E';
----                        REC_DIST.ERROR_MESSAGE := 'CHARGE ACOUNT IS NULL';
----                    ELSIF REC_DIST.CHARGE_ACCOUNT = 0 THEN
----                        REC_DIST.STATUS := 'E';
----                        REC_DIST.ERROR_MESSAGE := 'CHARGE ACCOUNT IS INVALID';
----                    END IF;
----                    
----                    UPDATE XXQGEN_PO_DIST_STG_DK
----                    SET STATUS = REC_DIST.STATUS,
----                          ERROR_MESSAGE = REC_DIST.ERROR_MESSAGE,
----                          CHARGE_ACCOUNT_ID = REC_DIST.CHARGE_ACCOUNT_ID
----                    WHERE 1=1
----                        AND REQUEST_ID = GN_REQUEST_ID
----                        AND RECORD_ID = REC_DIST.RECORD_ID;
----                
----                END LOOP;
--                
--                FND_FILE.PUT_LINE(FND_FILE.LOG, ' VALIDATION LINE END ');
--                
--                EXCEPTION
--                    WHEN OTHERS THEN
--                        FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN LINE LOC CURSOR : ' || SQLCODE || ' - ' || SQLERRM);
--
--            END LOOP;
--            
--            FND_FILE.PUT_LINE(FND_FILE.LOG, ' VALIDATION LIN END ');
--            
--            EXCEPTION
--                WHEN OTHERS THEN
--                    FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN HEADER : ' || SQLCODE || ' - ' || SQLERRM);
--            
--        END LOOP;
--        
--        FND_FILE.PUT_LINE(FND_FILE.LOG, ' VALIDATION WORKING END ');
--        
--    EXCEPTION
--        WHEN OTHERS THEN
--            FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN VALIDATION PROCEDURE : ' || SQLCODE || ' - ' || SQLERRM );
--
--    END validate;
--  

  PROCEDURE validate (
    p_batch_id NUMBER
) IS

    CURSOR CUR_HEAD IS
        SELECT *
        FROM XXQGEN_PO_HDR_STG_DK
        WHERE 1=1
--          AND BATCH_ID = P_BATCH_ID
          AND REQUEST_ID = GN_REQUEST_ID
          AND STATUS = 'N';
    
    CURSOR CUR_LINE(HDR_ID NUMBER) IS
        SELECT *
        FROM xxqgen_po_line_stg_dk
        WHERE 1=1
--          AND BATCH_ID = P_BATCH_ID
          AND REQUEST_ID = GN_REQUEST_ID
          AND INTERFACE_HEADER_ID = HDR_ID
          AND STATUS = 'N';
    
    CURSOR CUR_DIST(HDR_ID NUMBER) IS
        SELECT *
        FROM XXQGEN_PO_DIST_STG_DK
        WHERE 1=1
--          AND BATCH_ID = P_BATCH_ID
          AND REQUEST_ID = GN_REQUEST_ID
          AND INTERFACE_HEADER_ID = HDR_ID
          AND STATUS = 'N';
    
    CURSOR CUR_LINE_LOC(LINE NUMBER, HDR_ID NUMBER) IS
        SELECT *
        FROM XXQGEN_PO_LINE_LOC_STG_DK
        WHERE 1=1
--            AND BATCH_ID = P_BATCH_ID
            AND REQUEST_ID = GN_REQUEST_ID
            AND INTERFACE_LINE_ID = LINE
            AND INTERFACE_HEADER_ID = HDR_ID
            AND STATUS = 'N';

    -- Utility function to handle null checks
    FUNCTION NVL_DEFAULT(val IN VARCHAR2, default_val IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        IF val IS NULL THEN
            RETURN default_val;
        ELSE
            RETURN val;
        END IF;
    END;
 
BEGIN
    FND_FILE.PUT_LINE(FND_FILE.LOG, 'WORKING VALIDATION' );
    
    

    FOR REC_HEAD IN CUR_HEAD LOOP
        BEGIN
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'WORKING HEADER CURSOR');
            REC_HEAD.STATUS := 'V';
            REC_HEAD.ERROR_MESSAGE := '';

            -- Validate Org ID
            
            
            REC_HEAD.ORG_ID := NVL(VALID_ORG(REC_HEAD.ORG), -1);
            IF REC_HEAD.ORG_ID = -1 THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'ORG ID IS NULL ';
            ELSIF REC_HEAD.ORG_ID = 0 THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'ORG ID IS INVALID ';
            END IF;

            FND_FILE.PUT_LINE(FND_FILE.LOG, 'WORKING ORG FUNCTION ORG_ID: ' || REC_HEAD.ORG_ID);

            -- Validate Document Type
            REC_HEAD.document_type_CODE := NVL_DEFAULT(VALID_TYPE(REC_HEAD.document_SUBtype, REC_HEAD.ORG_ID), '-1');
            IF REC_HEAD.document_type_CODE = '-1' THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'DOCUMENT TYPE IS NULL ';
            ELSIF REC_HEAD.document_type_CODE = '0' THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'DOCUMENT IS INVALID ';
            END IF;

            -- Validate Currency Code
            REC_HEAD.currency_CODE := NVL_DEFAULT(VALID_CURRENCY(REC_HEAD.currency), '-1');
            IF REC_HEAD.currency_CODE = '-1' THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'currency_CODE IS NULL ';
            ELSIF REC_HEAD.currency_CODE = '0' THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'currency CODE IS INVALID ';
            END IF;

            -- Validate Agent ID
            REC_HEAD.agent_id := NVL(VALID_BUYER(REC_HEAD.agent_NAME), -1);
            IF REC_HEAD.agent_id = -1 THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'AGENT ID IS NULL ';
            ELSIF REC_HEAD.agent_id = 0 THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'AGENT ID IS INVALID ';
            END IF;

            -- Validate Vendor Name
            REC_HEAD.vendor_id := NVL(VALID_SUPPLIER(REC_HEAD.vendor_NAME, REC_HEAD.ORG_ID), -1);
            IF REC_HEAD.vendor_id = -1 THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'VENDOR IS NULL ';
            ELSIF REC_HEAD.vendor_id = 0 THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'VENDOR IS INVALID ';
            ELSE
                REC_HEAD.vendor_site_ID := NVL(VALID_SITE(REC_HEAD.vendor_id, REC_HEAD.vendor_site_CODE, REC_HEAD.ORG_ID), -1);
                IF REC_HEAD.vendor_site_ID = -1 THEN
                    REC_HEAD.STATUS := 'E';
                    REC_HEAD.ERROR_MESSAGE := 'VENDOR SITE IS INVALID ';
                END IF;
            END IF;

            -- Validate Locations (Ship and Bill)
            REC_HEAD.ship_to_location_ID := NVL(valid_location(REC_HEAD.ship_to_location), -1);
            IF REC_HEAD.ship_to_location_ID = -1 THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'SHIP TO LOCATION IS INVALID ';
            END IF;

            REC_HEAD.bill_to_location_ID := NVL(valid_location(REC_HEAD.bill_to_location), -1);
            IF REC_HEAD.bill_to_location_ID = -1 THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'BILL TO LOCATION IS INVALID ';
            END IF;

            -- Update Header Record
            UPDATE XXQGEN_PO_HDR_STG_DK
            SET status = REC_HEAD.STATUS,
                error_message = REC_HEAD.ERROR_MESSAGE,
                BILL_TO_LOCATION_ID = REC_HEAD.BILL_TO_LOCATION_ID,
                SHIP_TO_LOCATION_ID = REC_HEAD.SHIP_TO_LOCATION_ID,
                VENDOR_SITE_CODE = REC_HEAD.VENDOR_SITE_CODE,
                VENDOR_ID = REC_HEAD.VENDOR_ID,
                AGENT_ID = REC_HEAD.AGENT_ID,
                CURRENCY_CODE = REC_HEAD.CURRENCY_CODE,
                DOCUMENT_TYPE_CODE = REC_HEAD.DOCUMENT_TYPE_CODE,
                ORG_ID = REC_HEAD.ORG_ID
            WHERE REQUEST_ID = GN_REQUEST_ID
              AND RECORD_ID = REC_HEAD.RECORD_ID;

            -- Validation for Lines
            FOR REC_LINE IN CUR_LINE(REC_HEAD.INTERFACE_HEADER_ID) LOOP
                BEGIN
                    -- Check if no lines found
                    IF SQL%ROWCOUNT = 0 THEN
                        REC_LINE.STATUS := 'E';
                        REC_LINE.ERROR_MESSAGE := 'NO LINE FOUND ';
                    END IF;

                    -- Validate Line Type
                    REC_LINE.LINE_tYPE_ID := NVL(VALID_LINE_TYPE(REC_LINE.LINE_TYPE), -1);
                    IF REC_LINE.LINE_tYPE_ID = -1 THEN
                        REC_LINE.STATUS := 'E';
                        REC_LINE.ERROR_MESSAGE := 'LINE_TYPE IS NULL ';
                    ELSIF REC_LINE.LINE_tYPE_ID = 0 THEN
                        REC_LINE.STATUS := 'E';
                        REC_LINE.ERROR_MESSAGE := 'LINE_TYPE IS INVALID ';
                    END IF;

                    -- Validate Item
                    REC_LINE.item_id := NVL(VALID_ITEM(REC_LINE.item, REC_HEAD.ORG_ID), -1);
                    IF REC_LINE.item_id = -1 THEN
                        REC_LINE.STATUS := 'E';
                        REC_LINE.ERROR_MESSAGE := 'ITEM IS NULL ';
                    ELSIF REC_LINE.item_id = 0 THEN
                        REC_LINE.STATUS := 'E';
                        REC_LINE.ERROR_MESSAGE := 'ITEM IS INVALID ';
                    END IF;

                    -- Validate Ship To Organization
                    REC_LINE.ship_to_organization_ID := NVL(valid_org(REC_LINE.ship_to_organization_CODE), -1);
                    IF REC_LINE.ship_to_organization_ID = -1 THEN
                        REC_LINE.STATUS := 'E';
                        REC_LINE.ERROR_MESSAGE := 'SHIP_TO_ORG_ID IS NULL ';
                    ELSIF REC_LINE.ship_to_organization_ID = 0 THEN
                        REC_LINE.STATUS := 'E';
                        REC_LINE.ERROR_MESSAGE := 'SHIP TO ORGANIZATION ID IS INVALID ';
                    END IF;

                    -- Validate Ship To Location
                    REC_LINE.ship_to_location_ID := NVL(valid_location(REC_LINE.ship_to_location), -1);
                    IF REC_LINE.ship_to_location_ID = -1 THEN
                        REC_LINE.STATUS := 'E';
                        REC_LINE.ERROR_MESSAGE := 'SHIP_TO_LOCATION IS NULL ';
                    ELSIF REC_LINE.ship_to_location_ID = 0 THEN
                        REC_LINE.STATUS := 'E';
                        REC_LINE.ERROR_MESSAGE := 'SHIP_TO_LOCATION IS INVALID ';
                    END IF;

                    -- Line Location Validation
                    FOR REC_LINE_LOC IN CUR_LINE_LOC(REC_HEAD.INTERFACE_HEADER_ID, REC_LINE.INTERFACE_LINE_ID) LOOP
                        BEGIN
                            IF SQL%ROWCOUNT = 0 THEN
                                REC_LINE_LOC.STATUS := 'E';
                                REC_LINE_LOC.ERROR_MESSAGE := 'NO LINE LOCATION FOUND ';
                            END IF;

                            -- Validate Ship To Location in Line Location
                            REC_LINE_LOC.ship_to_LOCATION_ID := NVL(valid_location(REC_LINE_LOC.ship_to_location), -1);
                            IF REC_LINE_LOC.ship_to_LOCATION_ID = -1 THEN
                                REC_LINE_LOC.STATUS := 'E';
                                REC_LINE_LOC.ERROR_MESSAGE := 'SHIP TO LOCATION IS INVALID ';
                            END IF;

                            -- Validate Need By Date and Promised Date
                            IF REC_LINE_LOC.need_by_date <= SYSDATE + 1 THEN
                                REC_LINE_LOC.STATUS := 'E';
                                REC_LINE_LOC.ERROR_MESSAGE := 'ERROR IN NEED BY DATE';
                            END IF;

                            IF REC_LINE_LOC.promised_date <= SYSDATE + 1 THEN
                                REC_LINE_LOC.STATUS := 'E';
                                REC_LINE_LOC.ERROR_MESSAGE := 'ERROR IN PROMISED DATE';
                            END IF;

                            -- Update Line Location
                            UPDATE XXQGEN_PO_LINE_LOC_STG_DK
                            SET STATUS = REC_LINE_LOC.STATUS,
                                ERROR_MESSAGE = REC_LINE_LOC.ERROR_MESSAGE,
                                ENFORCE_SHIP_TO_LOCATION_CODE = REC_LINE_LOC.ENFORCE_SHIP_TO_LOCATION_CODE
                            WHERE REQUEST_ID = GN_REQUEST_ID
                              AND RECORD_ID = REC_LINE_LOC.RECORD_ID;

                        EXCEPTION
                            WHEN OTHERS THEN
                                FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN LINE LOC CURSOR : ' || SQLCODE || ' - ' || SQLERRM);
                        END;
                    END LOOP;

                    FND_FILE.PUT_LINE(FND_FILE.LOG, 'VALIDATION LINE END');

                EXCEPTION
                    WHEN OTHERS THEN
                        FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN LINE CURSOR : ' || SQLCODE || ' - ' || SQLERRM);
                END;
            END LOOP;

            FND_FILE.PUT_LINE(FND_FILE.LOG, 'VALIDATION HEADER END');
        
        EXCEPTION
            WHEN OTHERS THEN
                FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN HEADER CURSOR : ' || SQLCODE || ' - ' || SQLERRM);
        END;
    END LOOP;

    FND_FILE.PUT_LINE(FND_FILE.LOG, 'VALIDATION WORKING END');

EXCEPTION
    WHEN OTHERS THEN
        FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN VALIDATION PROCEDURE : ' || SQLCODE || ' - ' || SQLERRM);
END validate;

    
    
    
   /*************************************************************************************************
    * Program Name : VALIDATE_REQUIRE
    * Language     : PL/SQL     
    * Description  : VALIDATE_REQUIRE process to valdiate null values.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         23-FEB-2025     Initial Version
    ***************************************************************************************************/

    PROCEDURE validate_require(
        P_BATCH_ID  NUMBER
    )
    IS
    BEGIN
    
        
        FND_FILE.PUT_LINE(FND_FILE.LOG, 'WORKING VALIDATION REQUIED');
        
        -----------------------------------------------------------------------------------------------------
        ------------------------------------------- Header Validation -----------------------------------
        -----------------------------------------------------------------------------------------------------
        
        -- validation for interface_source_code
--        update xxqgen_po_hdr_stg_dk
--        set status = 'E',
--             error_message = 'Interface Source Code in null '
--        where 1=1
--            and request_id = gn_request_id
--            and interface_source_code is null;
             
        -- validation for action
--        update xxqgen_po_hdr_stg_dk
--        set status = 'E',
--             error_message = 'Action in Header is null'
--        where 1=1
--            and action is null
--            and request_id = gn_request_id;

        UPDATE  XXQGEN_PO_HDR_STG_AD SET  
            REC_STATUS = 'E',
            ERROR_MESSAGE ='OPERATING UNIT IS NULL'
        WHERE OPERATING_UNIT IS NULL 
            AND BATCH_ID= P_BATCH_ID ;
            
        UPDATE XXQGEN_PO_HDR_STG_AD SET
            REC_STATUS = 'E',
            ERROR_MESSAGE = ERROR_MESSAGE||' '||'PO,REV(SEGMENT1) CAN NOT BE NULL'
        WHERE SEGMENT1 IS NULL
            AND BATCH_ID= P_BATCH_ID ;
            
        UPDATE XXQGEN_PO_HDR_STG_AD SET
            REC_STATUS = 'E',
            ERROR_MESSAGE = ERROR_MESSAGE||' '||'BUYER CAN NOT BE NULL'
        WHERE RIVISION_NUM IS NULL 
            AND BATCH_ID=P_BATCH_ID;
            
            SELECT *
            FROM XXQGEN_PO_HDR_STG_DK;
            
        UPDATE XXQGEN_PO_HDR_STG_AD SET
            REC_STATUS = 'E',
            ERROR_MESSAGE = ERROR_MESSAGE||' '||'PO TYPE CAN NOT BE NULL'
        WHERE TYPE IS NULL 
            AND BATCH_ID=P_BATCH_ID;

        
        -----------------------------------------------------------------------------------------------------
        ------------------------------------------- Line Validation ---------------------------------------
        -----------------------------------------------------------------------------------------------------
        
        UPDATE XXQGEN_PO_LINE_STG_AD SET
            REC_STATUS='E',
            ERROR_MESSAGE = ERROR_MESSAGE||' '||'LINE NUM MANDATORY'
        WHERE  LINE_NUM IS NULL
            AND BATCH_ID=P_BATCH_ID;
            
        UPDATE XXQGEN_PO_LINE_STG_AD SET
            REC_STATUS='E',
            ERROR_MESSAGE = ERROR_MESSAGE||' '||'LINE TYPE CAN NOT BE NULL'
        WHERE LINE_TYPE IS NULL 
            AND BATCH_ID=P_BATCH_ID;
        
        UPDATE XXQGEN_PO_LINE_STG_AD SET
            REC_STATUS = 'E',
            ERROR_MESSAGE = ERROR_MESSAGE||' '||'QUANTITY CAN NOT BE NULL'
        WHERE QUANTITY IS NULL 
            AND BATCH_ID=P_BATCH_ID ;

        UPDATE XXQGEN_PO_LINE_STG_AD SET
            REC_STATUS = 'E',
            ERROR_MESSAGE = ERROR_MESSAGE||' '||'PRICE CAN NOT BE NULL'
        WHERE UNIT_PRICE IS NULL 
            AND BATCH_ID=P_BATCH_ID ; 
        
        -----------------------------------------------------------------------------------------------------
        -------------------------------------- Line Location Validation ---------------------------------
        -----------------------------------------------------------------------------------------------------
        
        UPDATE XXQGEN_PO_LINE_LOC_STG_AD SET
            REC_STATUS = 'E',
            ERROR_MESSAGE = ERROR_MESSAGE||' '||'SHIPMENT  NUM NEEDED'
        WHERE SHIPMENT_NUM IS NULL
            AND BATCH_ID=P_BATCH_ID; 

        UPDATE XXQGEN_PO_LINE_LOC_STG_AD SET
            REC_STATUS = 'E',
            ERROR_MESSAGE = ERROR_MESSAGE||' '||'SHIPMENT  LOCATION CODE  NEEDED'
        WHERE SHIP_TO_LOCATION IS NULL
            AND BATCH_ID=P_BATCH_ID;    

        UPDATE XXQGEN_PO_LINE_LOC_STG_AD SET
            REC_STATUS = 'E',
            ERROR_MESSAGE = ERROR_MESSAGE||' '||'QUANTITY CAN NOT BE NULL'
        WHERE QUANTITY IS NULL 
            AND BATCH_ID=P_BATCH_ID ;
        
        -----------------------------------------------------------------------------------------------------
        ------------------------------------- Distributition Validation -----------------------------------
        -----------------------------------------------------------------------------------------------------
        
        UPDATE XXQGEN_PO_DIST_STG_AD SET
            REC_STATUS = 'E',
            ERROR_MESSAGE = ERROR_MESSAGE||' '||'LINE NUM REQUIRED'
        WHERE   DISTRIBUTION_NUM IS NULL 
            AND BATCH_ID = P_BATCH_ID;

        UPDATE XXQGEN_PO_DIST_STG_AD SET
            REC_STATUS = 'E',
            ERROR_MESSAGE = ERROR_MESSAGE||' '||'QUANTITY CAN NOT BE NULL'
        WHERE QUANTITY IS NULL 
            AND BATCH_ID=P_BATCH_ID ;
        
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('ERROR IN LOADING DATA INTO STAGING TABLE: ' || sqlerrm);
    END validate_require;
    

    PROCEDURE LOAD_DATA(
        P_BATCH_ID  NUMBER
    )
    IS
    BEGIN
        --************* INSERT DATA***************
        
         fnd_global.apps_initialize(gn_user_id, gn_resp_id, gn_resp_appl_id);
        mo_global.init('PO');
        fnd_request.set_org_id(gn_org_id);
        ln_request := fnd_request.submit_request(
                                application => 'PO', 
                                program => 'XXQGEN_PO_DTL_LOAD_DK', 
                                argument1 => '/u01/install/VISION/fs1/EBSapps/appl/po/12.0.0/bin/PO_DETAIL_DK.csv');
 
        COMMIT;
        fnd_file.put_line(fnd_file.log, 'REQUEST TO UPLOAD PO DATA IN STAGING START1: ' || gn_request_id);
        IF ln_request = 0 THEN
            fnd_file.put_line(fnd_file.log, 'REQUEST TO UPLOAD PO STAGING DATA NOT SUBMITTED: ' || gn_request_id);
        ELSIF ln_request > 0 THEN
            LOOP
                lc_conc_status := fnd_concurrent.wait_for_request(request_id => ln_request, INTERVAL => ln_interval, max_wait => ln_max_wait
                , phase => lc_phase, status => lc_status,
                                                                 dev_phase => lc_dev_phase, dev_status => lc_dev_status, message => lc_message
                                                                 );

                EXIT WHEN upper(lc_phase) = 'COMPLETED' OR upper(lc_status) IN ( 'CANCELLED', 'ERROR', 'TERMINATED' );

            END LOOP;
        END IF;

        fnd_file.put_line(fnd_file.log, 'REQUEST TO UPLOAD PO STAGING DATA.');
        
        -- header data
--              INSERT INTO xxqgen_po_hdr_stg_dk
--                (INTERFACE_header_id,
--                 interface_source_code,
--                 action,
--                 document_SUBtype,
--                 document_type_CODE,
--                 agent_id,
--                 document_num,
--                 vendor_id,
--                 vendor_site_CODE,
--                 vendor_site_ID,
--                 ship_to_location,
--                 bill_to_location,
--                 attribute_category,
--                 vendor_contact_id,
----                 supply_agreement_flag,
--                 expiration_date,
--                 org_id,
--                 rate,
--                 currency_code,
--                 rate_type,
--                 rate_date,
--                 comments,
--                 freight_carrier,
--                 effective_date,
--                 STATUS,
--                 -- WHO COLUMN
--                 created_by, 
--                 creation_date,
--                 last_updated_by, 
--                 last_update_date,
----                 login_ID,
--                 REQUEST_ID,
--                 batch_id,
--                 RECORD_ID)
--            VALUES (
--                 XXQGEN_PO_REQ_HEADER_ID.nextval,
--                 'XX007', -- interface_source_code
--                 null,
----                 'ORIGINAL', -- action
--                 NULL, -- document_type_code
--                 NULL, -- document_subtype
--                 NULL, -- agent_NAME
--                 NULL,  -- document_num
--                 NULL, -- vendor_id
--                 NULL, -- vendor_site_id
--                 NULL, -- vendor_site_code
--                 NULL, -- ship_to_location
--                 NULL, -- bill_to_location
--                 NULL, -- attribute_category
--                 NULL, -- vendor_contact_id
----                 NULL, -- supply_agreement_flag
--                 NULL, -- expiration_date
--                 NULL, -- org_id
--                 NULL, -- rate
--                 NULL, -- currency_code
--                 NULL, -- rate_type
--                 NULL, -- rate_date
--                 NULL, -- comments
--                 NULL, -- freight_carrier
--                 NULL, -- effective_date
--                 'N', -- STATUS remains unchanged
--                 -- WHO COLUMN
--                 Gn_user_id, -- created_by
--                 SYSDATE,   -- creation_date
--                 Gn_user_id, -- last_updated_by
--                 SYSDATE, -- last_update_date
----                 Gn_user_id, -- last_update_login
--                 gn_request_id,
--                 P_BATCH_ID,
--                 XXQGEN_REC_ID_DK.NEXTVAL
--            );
--
--              
--        -- line data
--        INSERT INTO xxqgen_po_line_stg_dk (
--              INTERFACE_header_id,
--              INTERFACE_line_id,
--              action,
--              document_num,
--              line_type_id,
--              item,
--              uom_code,
--              quantity,
--              unit_price,
--              need_by_date,
--              promised_date,
--              ship_to_organization_CODE,
--              SHIP_TO_LOCATION,
--              receiving_routing_id,
--              line_attribute15,
--              line_num,
--              vendor_product_num,
--              CATEGORY,
--              item_description,
--              note_to_vendor,
--              invoice_close_tolerance,
--              receive_close_tolerance,
--              qty_rcv_tolerance,
--              item_revision,
--              list_price_per_unit,
--              line_loc_populated_flag,
--              STATUS,
--              -- WHO COLUMN
--              created_by, 
--              creation_date,
--              last_updated_by, 
--              last_update_date,
----              login_ID,
--              REQUEST_ID,
--              batch_id,
--              RECORD_ID)
--        VALUES (
--              XXQGEN_PO_REQ_HEADER_ID.CURRVAL,         -- po_header_id
--              XXQGEN_PO_REQ_LINE_ID.NEXTVAL,             -- po_line_id
--              'ADD',                              -- action
--              null,           -- document_num
--              null,          -- line_type_id
--              null,                -- item
--              null,           -- uom_code
--              null,                -- quantity
--              null,           -- unit_price
--              null,       -- need_by_date
--              null,     -- promised_date
--              null, -- ship_to_organization_code
--              null, -- ship_to_location_code
----              'WARNING',   -- enforce_ship_to_location_code
--              NULL,                 -- receiving_routing_id
--              null,    -- line_attribute15
--              null,            -- line_num
--              null, -- vendor_product_num
--              null,               -- category
--              null, -- item_description
--              null,   -- note_to_vendor
--              null, -- invoice_close_tolerance
--              null, -- receive_close_tolerance
--              null,     -- qty_rcv_tolerance
--              null,     --item_revision
--              null,  --list_price_per_unit
--              'Y',
--              'N',
--              -- WHO COLUMN
--              Gn_user_id, -- created_by
--              SYSDATE,   -- creation_date
--              Gn_user_id, -- last_updated_by
--              SYSDATE, -- last_update_date
----              Gn_user_id, -- last_update_login
--              gn_request_id,
--              P_BATCH_ID,
--              XXQGEN_REC_ID_DK.NEXTVAL);
--              
--              
--        -- line location 
--        INSERT INTO xxqgen_po_line_loc_stg_dk(
--              INTERFACE_header_id,
--              INTERFACE_line_id,
--              INTERFACE_line_locATION_id,
--              shipment_num,
--              qty_rcv_exception_code,
--              days_early_receipt_allowed,
--              allow_substitute_receipts_flag,
--              days_late_receipt_allowed,
--              receipt_days_exception_code,
--              enforce_ship_to_location_code,
--              need_by_date,
--              promised_date,
--              STATUS,
--              created_by, 
--              creation_date,
--              last_updated_by, 
--              last_update_date,
----              login_ID,
--              REQUEST_ID,
--              batch_id,
--              RECORD_ID)
--        VALUES (
--              XXQGEN_PO_REQ_HEADER_ID.CURRVAL,         -- po_header_id
--              XXQGEN_PO_REQ_LINE_ID.currval,             -- po_line_id
--              xxqgen_po_line_loc_id.nextval,
--              null, -- shipment_num
--              null, --qty_rcv_exception_code
--              null, -- days_early_receipt_allowed
--              null, -- allow_substitute_receipts_flag
--              null, -- days_late_receipt_allowed
--              null, -- receipt_days_exception_code
--              null, -- enforce_ship_to_location_code
--              null, -- need by date
--              null, -- promise date
--              'N',
--              Gn_user_id, -- created_by
--              SYSDATE,   -- creation_date
--              Gn_user_id, -- last_updated_by
--              SYSDATE, -- last_update_date
----              Gn_user_id, -- last_update_login
--              gn_request_id,
--              P_BATCH_ID,
--              XXQGEN_REC_ID_DK.NEXTVAL);
--              
--              
--        -- distribution data
--        INSERT INTO xxqgen_po_dist_stg_dk (
--              INTERFACE_header_id,
--              INTERFACE_line_id,
--              INTERFACE_distribution_id,
--              distribution_num,
--              quantity_ordered,
--              charge_account_id,
--              charge_account,
--              STATUS,
--              created_by,
--              creation_date,
--              last_updated_by,
--              last_update_date,
----              login_ID,
--              REQUEST_ID,
--              BATCH_ID,
--              RECORD_ID)
--        VALUES (
--              XXQGEN_PO_REQ_HEADER_ID.currval,
--              XXQGEN_PO_REQ_line_ID.currval,
--              xxqgen_po_dist_id.nextval,
--              null, -- distribution_num
--              null, -- quantity_ordered
--              null, -- charge_account_id
--              NULL,    --CHARGE ACCOUNT
--              'N',
--              Gn_user_id, -- created_by
--              SYSDATE, -- creation_date
--              Gn_user_id, -- last_updated_by
--              SYSDATE, -- last_update_date
----              Gn_user_id, -- last_update_login
--              gn_request_id,
--              P_BATCH_ID,
--              XXQGEN_REC_ID_DK.NEXTVAL);
    EXCEPTION 
        WHEN OTHERS THEN
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN LOAD DATA : ' || SQLCODE || ' - ' || SQLERRM );
    END LOAD_DATA;

    PROCEDURE MAIN(ERRBUF OUT VARCHAR2, RETCODE OUT NUMBER)
    IS
        LN_BATCH_ID NUMBER := XXQGEN_INTR_BATCH_ID.NEXTVAL;
        LN_CUR_BATCH_ID
    number := xxqgen_intr_batch_id.currval;
    BEGIN
    /*
        fnd_global.apps_initialize(1016246, 50578, 201);
        mo_global.init('PO');
        mo_global.set_policy_context('S', 204);
    */
    
        load_data(XXQGEN_PO_BATCH_ID.NEXTVAL);
        validate_require(XXQGEN_PO_BATCH_ID.CURRVAL);
        validate(XXQGEN_PO_BATCH_ID.CURRVAL);
--        process(ln_cur_batch_id);
--        submit_requisition;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('ERROR IN MAIN: ' || sqlerrm);
    END main;
END XXQGEN_PO_IMP_DK;
/