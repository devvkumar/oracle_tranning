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

    FUNCTION valid_total (
        p_hdr      NUMBER,
        p_batch_id NUMBER
    ) RETURN NUMBER IS
        ln_total NUMBER;
    BEGIN
        SELECT
            SUM(amount)
        INTO ln_total
        FROM
            xxqgen_po_line_stg_dk
        WHERE
                1 = 1
            AND INTERFACE_header_id = p_hdr
            AND batch_id = p_batch_id;

        RETURN ln_total;
    EXCEPTION
        WHEN no_data_found THEN
            RETURN 0;
    END valid_total;
    
    
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

        CURSOR cur_int IS
        SELECT
            hdr.operating_unit,
            hdr.auth_status,
            hdr.preparer_id,
            hdr.org_id,
            hdr.description,
            hdr.total,
            line.line_num,
            line.item_id,
            line.category_id,
            line.descreption           AS description_line,
            line.uom,
            line.quantity,
            line.price                 AS unit_price,
            line.need_by_date          AS need_by_date,
            line.destination_type,
            line.requester_id,
            line.org_id                AS destination_organization_id,
            line.ship_to_location_code AS deliver_to_location_id,
            line.supplier_id           AS vendor_id,
            line.site_id               AS vendor_site_id,
            line.charge_account,
            hdr.creation_date,
            hdr.created_by,
            hdr.last_updated_by,
            hdr.updated_by,
            hdr.record_id,
            line.record_id             line_record_id
        FROM
            xxqgen_po_req_hdr_stg_dk  hdr,
            xxqgen_po_req_line_stg_dk line
        WHERE
                hdr.header_id = line.header_id
            AND hdr.status = 'V'
            AND line.status = 'V'
            AND hdr.batch_id = p_batch_id;

        TYPE tbl_type IS
            TABLE OF cur_int%rowtype;
        insert_tbl    tbl_type;
        ln_header_id  NUMBER;
        gn_request_id NUMBER := p_batch_id;
    BEGIN
        dbms_output.put_line('PROCESS START');
        OPEN cur_int;
        LOOP
            FETCH cur_int
            BULK COLLECT INTO insert_tbl LIMIT 5;
            EXIT WHEN insert_tbl.count = 0;
            FOR i IN 1..insert_tbl.count LOOP
                BEGIN
                    ln_header_id := po_headers_interface_s.nextval;
                    INSERT INTO po_requisitions_interface_all (
                        transaction_id,
                        batch_id,
                        interface_source_code,
                        requisition_type,
                        org_id,
                        destination_type_code,
                        authorization_status,
                        need_by_date,
                        preparer_id,
                        charge_account_id,
                        source_type_code,
                        unit_of_measure,
                        line_type_id,
                        category_id,
                        unit_price,
                        quantity,
                        destination_organization_id,
                        deliver_to_location_id,
                        deliver_to_requestor_id,
                        header_description,
                        item_description,
                        suggested_vendor_id,
                        suggested_vendor_site_id,
                        item_id,
                        req_dist_sequence_id,
                        creation_date,
                        created_by,
                        last_update_date,
                        last_updated_by,
                        header_attribute1,
                        line_attribute1
                    ) VALUES (
                        po_headers_interface_s.NEXTVAL,
                        gn_request_id,
                        'Purchase Requisition',
                        'Purchase Requisition',
                        insert_tbl(i).org_id,
                        insert_tbl(i).destination_type,
                        insert_tbl(i).auth_status,
                        insert_tbl(i).need_by_date,
                        insert_tbl(i).preparer_id,
                        fnd_profile.value('GL_SET_OF_BKS_ID'),
                        NULL,
                        insert_tbl(i).uom,
                        insert_tbl(i).line_num,
                        insert_tbl(i).category_id,
                        insert_tbl(i).unit_price,
                        insert_tbl(i).quantity,
                        insert_tbl(i).destination_organization_id,
                        insert_tbl(i).deliver_to_location_id,
                        insert_tbl(i).requester_id,
                        insert_tbl(i).description,
                        insert_tbl(i).description_line,
                        insert_tbl(i).vendor_id,
                        insert_tbl(i).vendor_site_id,
                        insert_tbl(i).item_id,
                        po_req_dist_interface_s.NEXTVAL,
                        insert_tbl(i).creation_date,
                        insert_tbl(i).created_by,
                        insert_tbl(i).last_updated_by,
                        insert_tbl(i).updated_by,
                        insert_tbl(i).record_id,
                        insert_tbl(i).line_record_id
                    );

                    UPDATE xxqgen_po_req_hdr_stg_dk
                    SET
                        status = 'P'
                    WHERE
                            1 = 1
                        AND batch_id = p_batch_id
                        AND status = 'V'
                        AND record_id IN (
                            SELECT
                                header_attribute1
                            FROM
                                po_requisitions_interface_all
                        );

                    UPDATE xxqgen_po_req_hdr_stg_dk
                    SET
                        status = 'P'
                    WHERE
                            1 = 1
                        AND batch_id = p_batch_id
                        AND status = 'V'
                        AND record_id IN (
                            SELECT
                                line_attribute1
                            FROM
                                po_requisitions_interface_all
                        );

                    fnd_file.put_line(fnd_file.log, 'CREATE REQ INTERFACE SUCCESSFULLY');
                EXCEPTION
                    WHEN OTHERS THEN
                        dbms_output.put_line('ERROR IN INSERT IN PO_REQUISITIONS_INTERFACE_ALL: ' || sqlerrm);
                END;
            END LOOP;

            COMMIT;
        END LOOP;

        CLOSE cur_int;
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

    PROCEDURE validate (
        p_batch_id NUMBER
    ) IS

        CURSOR CUR_HEAD IS
        SELECT *
        FROM XXQGEN_PO_HDR_STG_DK
        WHERE 1=1
          AND BATCH_ID = P_BATCH_ID
          AND REQUEST_ID = GN_REQUEST_ID
          AND STATUS = 'N';
          
          CURSOR CUR_LINE IS
        SELECT *
        FROM xxqgen_po_line_stg_dk
        WHERE 1=1
          AND BATCH_ID = P_BATCH_ID
          AND REQUEST_ID = GN_REQUEST_ID
          AND STATUS = 'N';
        
        CURSOR CUR_DIST IS
        SELECT *
        FROM XXQGEN_PO_DIST_STG_DK
        WHERE 1=1
          AND BATCH_ID = P_BATCH_ID
          AND REQUEST_ID = GN_REQUEST_ID
          AND STATUS = 'N';
        
        CURSOR CUR_LINE_LOC is
        SELECT *
        FROM XXQGEN_PO_LINE_LOC_STG_DK
        WHERE BATCH_ID = p_batch_id
          AND REQUEST_ID = gn_request_id
          AND STATUS = 'N';
          
    BEGIN
    
        FOR REC_HEAD IN CUR_HEAD LOOP
        -- VALIDATIO IN HEADER : batch_id, process_code, action, org_id, document_type_code, currency_code, agent_id, vendor_name, vendor_site_code, ship_to_location, bill_to_location, reference_num
            REC_HEAD.ORG_ID := VALID_ORG(REC_HEAD.ORG);
            IF(REC_HEAD.ORG_ID = -1) THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'ORG ID IS NULL ';
            ELSIF REC_HEAD.ORG_ID = 0 THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'ORG ID IS NULL ';
            END IF;
            
            REC_HEAD.document_type_CODE := VALID_TYPE(REC_HEAD.document_type, REC_HEAD.ORG_ID);
            IF(REC_HEAD.ORG_ID = -1) THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'ORG ID IS NULL ';
            ELSIF REC_HEAD.ORG_ID = 0 THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'ORG ID IS NULL ';
            END IF;
            
            -- CURRENCY CODE 
            REC_HEAD.currency_CODE := VALID_CURRENCY(REC_HEAD.currency);
            IF(REC_HEAD.currency_CODE = -1) THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'currency_CODE IS NULL ';
            ELSIF REC_HEAD.currency_CODE = 0 THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'currency CODE IS NULL ';
            END IF;
            
            -- AGENT id
            REC_HEAD.agent_id  := VALID_BUYER(REC_HEAD.agent);
            IF(REC_HEAD.agent_id = -1) THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'ORG ID IS NULL ';
            ELSIF REC_HEAD.agent_id = 0 THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'ORG ID IS NULL ';
            END IF;
            
            -- VENDOR Name
            REC_HEAD.vendor_id := VALID_SUPPLIER(REC_HEAD.vendor, REC_HEAD.ORG_ID);
            IF(REC_HEAD.ORG_ID = -1) THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'VENDOR IS NULL ';
            ELSIF REC_HEAD.ORG_ID = 0 THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'VENDOR IS NULL ';
            ELSE 
                REC_HEAD.vendor_site_code := VALID_SITE(REC_HEAD.vendor_id, REC_HEAD.vendor_site, REC_HEAD.ORG_ID);
                IF(REC_HEAD.ORG_ID = -1) THEN
                    REC_HEAD.STATUS := 'E';
                    REC_HEAD.ERROR_MESSAGE := 'ORG ID IS NULL ';
                ELSIF REC_HEAD.ORG_ID = 0 THEN
                    REC_HEAD.STATUS := 'E';
                    REC_HEAD.ERROR_MESSAGE := 'ORG ID IS NULL ';
                END IF;
            END IF;
            
            REC_HEAD.ship_to_location_ID := valid_location(REC_HEAD.ship_to_location);
            IF(REC_HEAD.ship_to_location_ID = -1) THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'ORG ID IS NULL ';
            ELSIF REC_HEAD.ship_to_location_ID = 0 THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'ORG ID IS NULL ';
            END IF;
            
            REC_HEAD.bill_to_location_ID := valid_location(REC_HEAD.bill_to_location);
            IF(REC_HEAD.bill_to_location_ID = -1) THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'ORG ID IS NULL ';
            ELSIF REC_HEAD.bill_to_location_ID = 0 THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'ORG ID IS NULL ';
            END IF;
            
            UPDATE XXQGEN_po_hdr_stg_dk
            set status = rec_head.status,
                 error_message = rec_head.error_message,
                 BILL_TO_LOCATION_ID = REC_HEAD.BILL_TO_LOCATION_ID,
                 SHIP_TO_LOCATION_ID = REC_HEAD.SHIP_TO_LOCATION_ID,
                 VENDOR_SITE_CODE = REC_HEAD.VENDOR_SITE_CODE,
                 VENDOR_ID = REC_HEAD.VENDOR_ID,
                 AGENT_ID = REC_HEAD.AGENT_ID,
                 CURRENCY_CODE = REC_HEAD.CURRENCY_CODE,
                 DOCUMENT_TYPE_CODE = REC_HEAD.DOCUMENT_TYPE_CODE,
                 ORG_ID = REC_HEAD.ORG_ID
            WHERE 1=1
                AND REQUEST_ID = GN_REQUEST_ID
                AND RECORD_ID = REC_HEAD.RECORD_ID;
            
            --VALIDATION FOR LINES : interface_line_id, interface_header_id, line_num, shipment_num, line_type, item, uom_code, quantity, unit_price, ship_to_organization_code, ship_to_location)
            FOR REC_LINE IN CUR_LINE() LOOP
                -- MISSINH
--                REC_LINE.SHIPMENT_NUM
                IF SQL%ROWCOUNT = 0 THEN
                    REC_LINE.STATUS := 'E';
                    REC_LINE.ERROR_MESSAGE := 'NO LINE FOUND ';
                END IF;
                
                REC_LINE.LINE_tYPE_ID := VALID_LINE_TYPE(rec_line.LINE_TYPE);
                IF(rec_line.LINE_TYPE_ID = -1) THEN
                    rec_line.STATUS := 'E';
                    rec_line.ERROR_MESSAGE := 'LINE_TYPE IS NULL ';
                ELSIF rec_line.LINE_TYPE_ID = 0 THEN
                    rec_line.STATUS := 'E';
                    rec_line.ERROR_MESSAGE := 'LINE_TYPE IS INVALID ';
                END IF;
                
                rec_line.item_id := VALID_ITEM(REC_LINE.item, rec_HEAD.ORG_ID);
                IF(rec_line.ITEM_ID = -1) THEN
                    rec_line.STATUS := 'E';
                    rec_line.ERROR_MESSAGE := 'ITEM IS NULL ';
                ELSIF rec_line.ITEM_ID = 0 THEN
                    rec_line.STATUS := 'E';
                    rec_line.ERROR_MESSAGE := 'ITEM IS INVALID ';
                END IF;

--              
--                REC_LINE.uom_code := VALID_UOM(rec_line.UOM);
--                IF(rec_line.UOM = -1) THEN
--                    rec_line.STATUS := 'E';
--                    rec_line.ERROR_MESSAGE := 'UOM IS NULL ';
--                ELSIF rec_line.UOM_CODE = 0 THEN
--                    rec_line.STATUS := 'E'; 
--                    rec_line.ERROR_MESSAGE := 'UOM IS INVALID ';
--                END IF;
                
                -- MISISNG
--                REC_LINE.quantity
                
                REC_LINE.ship_to_organization_ID := valid_org(rec_line.ship_to_organization);
                IF(rec_line.SHIP_TO_ORGANIZATION_ID = -1) THEN
                    rec_line.STATUS := 'E';
                    rec_line.ERROR_MESSAGE := 'SHIP_TO_ORG_ID IS NULL ';
                ELSIF rec_line.SHIP_TO_ORGANIZATION_ID = 0 THEN
                    rec_line.STATUS := 'E';
                    rec_line.ERROR_MESSAGE := 'SHIP TO ORGANIZATION ID IS INVALID ';
                END IF;
                
                REC_LINE.ship_to_location_ID := valid_location(rec_line.ship_to_location);
                IF(rec_line.SHIP_to_location_ID = -1) THEN
                    rec_line.STATUS := 'E';
                    rec_line.ERROR_MESSAGE := 'SHIP_TO_ORGANIZATION_ID IS NULL ';
                ELSIF rec_line.SHIP_to_location_ID = 0 THEN
                    rec_line.STATUS := 'E';
                    rec_line.ERROR_MESSAGE := 'SHIP_TO_ORGANIZATION_ID IS INVALID ';
                END IF;
                
                FOR rec_line_loc in cur_line_loc LOOP
                
                IF SQL%ROWCOUNT = 0 THEN
                    REC_LINE_LOC.STATUS := 'E';
                    REC_LINE_LOC.ERROR_MESSAGE := 'NO LINE LOCATION FOUND ';
                END IF;
                    
                -- interface_header_id, interface_line_id, interface_line_location_id, shipment_num, created_by, creation_date, last_updated_by,  
                -- last_update_date, last_update_login, qty_rcv_exception_code,
                -- days_early_receipt_allowed, allow_substitute_receipts_flag, days_late_receipt_allowed, receipt_days_exception_code, 
                -- enforce_ship_to_location_code, need_by_date, promised_date
                    rec_line_loc.enforce_ship_to_LOCATION_CODE := VALID_LOCATION(REC_LINE_LOC.enforce_ship_to_location);
                    IF(rec_line_loc.enforce_ship_to_LOCATION_CODE = -1) THEN
                        rec_line_loc.STATUS := 'E';
                        rec_line_loc.ERROR_MESSAGE := 'ORG ID IS NULL ';
                    ELSIF rec_line_loc.ENFORCE_SHIP_to_location_CODE = 0 THEN
                        rec_line_loc.STATUS := 'E';
                        rec_line_loc.ERROR_MESSAGE := 'ORG ID IS NULL ';
                    END IF;
                    
                    IF(rec_line_loc.need_by_date <= SYSDATE+1) THEN
                        rec_line_loc.STATUS := 'E';
                        rec_line_loc.error_message := 'ERROR IN NEED BY DATE';
                    END IF;
                    
                    IF(rec_line_loc.promised_date <= SYSDATE+1) THEN
                        rec_line_loc.STATUS := 'E';
                        rec_line_loc.error_message := 'ERROR IN NEED BY DATE';
                    END IF;
                    
                    UPDATE XXQGEN_PO_LINE_LOC_STG_DK
                    SET STATUS = REC_LINE_LOC.STATUS,
                           ERROR_MESSAGE = REC_LINE_LOC.ERROR_MESSAGE,
                           ENFORCE_SHIP_TO_LOCATION_CODE = REC_LINE_LOC.ENFORCE_SHIP_TO_LOCATION_CODE
                    WHERE 1=1
                        AND REQUEST_ID = GN_REQUEST_ID
                        AND RECORD_ID = REC_LINE_LOC.RECORD_ID;
                           
                end loop;
                
                FOR REC_DIST IN CUR_DIST loop
                    REC_DIST.STATUS := 'V';
                    REC_DIST.ERROR_MESSAGE := '';
                    
                    IF SQL%ROWCOUNT = 0 THEN
                        REC_DIST.STATUS := 'E';
                        REC_DIST.ERROR_MESSAGE := 'NO LINE LOCATION FOUND ';
                    END IF;
                    
                    -- interface_header_id, interface_line_id, interface_distribution_id, distribution_num, quantity_ordered, charge_account_id,
                    REC_DIST.CHARGE_ACCOUNT_ID := get_chart_account_id(REC_DIST.charge_account, REC_HEAD.ORG_ID);
                    IF REC_DIST.CHARGE_ACCOUNT_ID = -1 THEN
                        REC_DIST.STATUS := 'E';
                        REC_DIST.ERROR_MESSAGE := 'CHARGE ACOUNT IS NULL';
                    ELSIF REC_DIST.CHARGE_ACCOUNT = 0 THEN
                        REC_DIST.STATUS := 'E';
                        REC_DIST.ERROR_MESSAGE := 'CHARGE ACCOUNT IS INVALID';
                    END IF;
                    
                    UPDATE XXQGEN_PO_DIST_STG_DK
                    SET STATUS = REC_DIST.STATUS,
                          ERROR_MESSAGE = REC_DIST.ERROR_MESSAGE,
                          CHARGE_ACCOUNT_ID = REC_DIST.CHARGE_ACCOUNT_ID
                    WHERE 1=1
                        AND REQUEST_ID = GN_REQUEST_ID
                        AND RECORD_ID = REC_DIST.RECORD_ID;
                
                END LOOP;
                
            END LOOP;
            
        END LOOP;
        
    EXCEPTION
        WHEN OTHERS THEN
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN VALIDATION PROCEDURE : ' || SQLCODE || ' - ' || SQLERRM );

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

    PROCEDURE validate_require (
        p_batch_id NUMBER
    ) IS
    BEGIN
    
        
        FND_FILE.PUT_LINE(FND_FILE.LOG, 'WORKING VALIDATION REQUIED');
        DBMS_OUTPUT.PUT_LINE('WORKING');
        
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('ERROR IN LOADING DATA INTO STAGING TABLE: ' || sqlerrm);
    END validate_require;
    

    PROCEDURE LOAD_DATA(BATCH_ID NUMBER)
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
        
        -- header data
--              INSERT INTO xxqgen_po_hdr_stg_dk
--                (header_id,
--                 interface_source_code,
--                 action,
--                 document_type,
--                 document_subtype,
--                 agent_id,
--                 document_num,
--                 vendor_id,
--                 vendor_site,
--                 vendor_site_code,
--                 ship_to_location,
--                 bill_to_location,
--                 attribute_category,
--                 vendor_contact_id,
--                 supply_agreement_flag,
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
--                 login_ID,
--                 REQUEST_ID,
--                 batch_id,
--                 RECORD_ID)
--            VALUES (
--                 XXQGEN_PO_REQ_HEADER_ID.nextval,
--                 'XX007', -- interface_source_code
--                 'ORIGINAL', -- action
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
--                 NULL, -- supply_agreement_flag
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
--                 Gn_user_id, -- last_update_login
--                 gn_request_id,
--                 XXQGEN_PO_BATCH_ID.NEXTVAL,
--                 XXQGEN_REC_ID_DK.NEXTVAL
--            );
--
--              
--        -- line data
--        INSERT INTO xxqgen_po_line_stg_dk (
--              header_id,
--              line_id,
--              action,
--              document_num,
--              line_type_id,
--              item,
--              uom_code,
--              quantity,
--              unit_price,
--              need_by_date,
--              promised_date,
--              ship_to_organization,
--              enforce_ship_to_location,
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
--              login_ID,
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
--              'WARNING',   -- enforce_ship_to_location_code
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
--              Gn_user_id, -- last_update_login
--              gn_request_id,
--              XXQGEN_PO_BATCH_ID.CURRVAL,
--              XXQGEN_REC_ID_DK.NEXTVAL);
--              
--              
--        -- line location 
--        INSERT INTO xxqgen_po_line_loc_stg_dk(
--              header_id,
--              line_id,
--              line_loc_id,
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
--              login_ID,
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
--              Gn_user_id, -- last_update_login
--              gn_request_id,
--              XXQGEN_PO_BATCH_ID.CURRVAL,
--              XXQGEN_REC_ID_DK.NEXTVAL);
--              
--              
--        -- distribution data
--        INSERT INTO xxqgen_po_dist_stg_dk (
--              header_id,
--              line_id,
--              distribution_id,
--              distribution_num,
--              quantity_ordered,
--              charge_account_id,
--              charge_account,
--              STATUS,
--              created_by,
--              creation_date,
--              last_updated_by,
--              last_update_date,
--              login_ID,
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
--              Gn_user_id, -- last_update_login
--              gn_request_id,
--              XXQGEN_PO_BATCH_ID.CURRVAL,
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
    /*
        load_data(ln_batch_id);
        validate_require(ln_cur_batch_id);
    */
        validate(ln_cur_batch_id);
        process(ln_cur_batch_id);
        submit_requisition;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('ERROR IN MAIN: ' || sqlerrm);
    END main;
END XXQGEN_PO_IMP_DK;
/