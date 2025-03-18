CREATE OR REPLACE PACKAGE BODY xxqgen_req_int_dev AS
       /***************************************************************************************************
        * Program Name : XXQGEN_REQ_INT_DEV.pkb
        * Language     : PL/SQL
        * Description  : Specks for XXQGEN_REQ_INT_DEV.pkb
        * History      :
        * WHO                                  Version #           WHEN                        WHAT
        * ===============  =========   =============   =================================
        * DKUMAR                           1.0                     17-FEB-2025             Initial Version
        ***************************************************************************************************/
        
        FUNCTION VALID_LINE(P_HEADER_ID NUMBER)
        RETURN NUMBER
        AS
            LV_LINE_COUNT       NUMBER;
        BEGIN
            SELECT COUNT(*)
            INTO LV_LINE_COUNT
            FROM XXQGEN_PO_REQ_LINE_STG_DK
            WHERE HEADER_ID = P_HEADER_ID
            GROUP BY HEADER_ID;
            
            RETURN LV_LINE_COUNT;
        EXCEPTION
            WHEN OTHERS THEN 
                FND_FILE.PUT_LINE(FND_FILE.LOG, 'LINE : ' || SQLERRM);
                RETURN 0;
        END VALID_LINE;
        
        
        FUNCTION VALID_HEADER(P_HEADER_ID NUMBER)
        RETURN NUMBER
        AS
            LV_HEAD_COUNT       NUMBER;
        BEGIN
            SELECT COUNT(*) COUNT_HDR
            INTO LV_HEAD_COUNT
            FROM XXQGEN_PO_REQ_HDR_STG_DK
            WHERE HEADER_ID = P_HEADER_ID
            GROUP BY HEADER_ID;
            
            RETURN LV_HEAD_COUNT;
        EXCEPTION
            WHEN OTHERS THEN
                FND_FILE.PUT_LINE(FND_FILE.LOG, 'HEAD : ' || SQLERRM);
                RETURN 0;
         END VALID_HEADER;
        /*************************************************************************************************
        * Program Name : GET_LOOKUP_CODE
        * Language     : PL/SQL     
        * Description  : GET_LOOKUP_CODE process to valdiate lookup code name.
        * History      : 
        *
        * WHO              Version #   WHEN            WHAT
        * ======================================================================
        * DKUMAR           1.0         24-FEB-2025     Initial Version
        ***************************************************************************************************/
    FUNCTION get_lookup_code (
        p_type          VARCHAR2,
        p_specific_type VARCHAR2
    ) RETURN VARCHAR2 AS
        lv_lookup_code VARCHAR2(100);
    BEGIN
        BEGIN
            SELECT
                lookup_code
            INTO lv_lookup_code
            FROM
                po_lookup_codes
            WHERE
                    upper(lookup_type) = upper(p_specific_type)
                AND upper(displayed_field) = upper(p_type);

        EXCEPTION
            WHEN OTHERS THEN
                fnd_file.put_line(fnd_file.output, 'Destination type Does not exists...'
                                                   || sqlcode
                                                   || ' '
                                                   || sqlerrm);
        END;

        RETURN lv_lookup_code;
    END get_lookup_code;
    
    
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
   
   
        /*************************************************************************************************
        * Program Name : TYPE_LOOKUP_CODE
        * Language     : PL/SQL     
        * Description  : TYPE_LOOKUP_CODE process to valdiate type lookup code name.
        * History      : 
        *
        * WHO              Version #   WHEN            WHAT
        * ======================================================================
        * DKUMAR           1.0         24-FEB-2025     Initial Version
        ***************************************************************************************************/
    FUNCTION get_type_lookup_code (
        p_type VARCHAR2
    ) RETURN VARCHAR2 IS
        ln_lookup_code VARCHAR2(50) := NULL;
    BEGIN
        BEGIN
            SELECT
                lookup_code
            INTO ln_lookup_code
            FROM
                po_lookup_codes
            WHERE
                    1 = 1
                AND upper(displayed_field)
                    || ' '
                    || 'REQUISITION' = upper(p_type)
                AND lookup_type = 'REQUISITION TYPE';

        EXCEPTION
            WHEN OTHERS THEN
                fnd_file.put_line(fnd_file.output, 'Error : '
                                                   || sqlcode
                                                   || ' '
                                                   || sqlerrm);
        END;

        RETURN ln_lookup_code;
    END get_type_lookup_code;
    
        /*************************************************************************************************
        * Program Name : GET_LINE_TYPE_ID
        * Language     : PL/SQL     
        * Description  : GET_LINE_TYPE_ID process to valdiate line type.
        * History      : 
        *
        * WHO              Version #   WHEN            WHAT
        * ======================================================================
        * DKUMAR           1.0         24-FEB-2025     Initial Version
        ***************************************************************************************************/
    FUNCTION get_line_type_id (
        p_line_type VARCHAR2
    ) RETURN NUMBER AS
        ln_line_type_id NUMBER := NULL;
    BEGIN
        BEGIN
            SELECT
                line_type_id
            INTO ln_line_type_id
            FROM
                po_line_types
            WHERE
                upper(line_type) = upper(p_line_type);

        EXCEPTION
            WHEN OTHERS THEN
                ln_line_type_id := NULL;
        END;

        RETURN ln_line_type_id;
    END get_line_type_id;
        
        /*************************************************************************************************
        * Program Name : VALID_ORG
        * Language     : PL/SQL     
        * Description  : VALID_ORG process to valdiate ORGANIZATION name.
        * History      : 
        *
        * WHO              Version #   WHEN            WHAT
        * ======================================================================
        * DKUMAR           1.0         18-FEB-2025     Initial Version
        ***************************************************************************************************/
    FUNCTION valid_org (
        p_operating_unit VARCHAR2
    ) RETURN NUMBER IS
        ln_org_id NUMBER;
    BEGIN
        SELECT
            organization_id
        INTO ln_org_id
        FROM
            hr_operating_units
        WHERE
            name = p_operating_unit;

        RETURN ln_org_id;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END valid_org;
        
        
        /*************************************************************************************************
        * Program Name : VALID_LINE_TYPE
        * Language     : PL/SQL     
        * Description  : VALID_LINE_TYPE process to valdiate VALIDATION LINE TYPE name.
        * History      : 
        *
        * WHO              Version #   WHEN            WHAT
        * ======================================================================
        * DKUMAR           1.0         24-FEB-2025     Initial Version
        ***************************************************************************************************/

    FUNCTION valid_line_type (
        p_line_type VARCHAR2
    ) RETURN NUMBER IS
        ln_line_type_id NUMBER;
    BEGIN
        SELECT
            line_type_id
        INTO ln_line_type_id
        FROM
            po_line_types
        WHERE
            upper(line_type) = upper(p_line_type);

        RETURN p_line_type;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END;

         /*************************************************************************************************
        * Program Name : VALID_TYPE
        * Language     : PL/SQL     
        * Description  : VALID_TYPE process to valdiate VALIDATION TYPE name.
        * History      : 
        *
        * WHO              Version #   WHEN            WHAT
        * ======================================================================
        * DKUMAR           1.0         18-FEB-2025     Initial Version
        ***************************************************************************************************/

    FUNCTION valid_type (
        p_type VARCHAR2,
        p_org  NUMBER
    ) RETURN VARCHAR2 IS
        lc_code VARCHAR2(50);
    BEGIN
        SELECT
            document_subtype
        INTO lc_code
        FROM
            po_document_types_all_vl
        WHERE
                1 = 1
            AND type_name = 'Purchase Requisition'
            AND org_id = p_org;

        RETURN lc_code;
    EXCEPTION
        WHEN no_data_found THEN
            RETURN ' ';
        WHEN OTHERS THEN
            RETURN ' ';
    END valid_type;
        
        
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
        * DKUMAR           1.0         18-FEB-2025     Initial Version
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
        * DKUMAR           1.0         18-FEB-2025     Initial Version
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
        * DKUMAR           1.0         18-FEB-2025     Initial Version
        ***************************************************************************************************/

    FUNCTION valid_supplier (
        van_name VARCHAR2
    ) RETURN NUMBER IS
        lv_vendor_id NUMBER;
    BEGIN
        SELECT
            vendor_id
        INTO lv_vendor_id
        FROM
            ap_suppliers
        WHERE
            vendor_name = van_name;

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
        * DKUMAR           1.0         18-FEB-2025     Initial Version
        ***************************************************************************************************/

    FUNCTION valid_site (
        site VARCHAR2
    ) RETURN NUMBER IS
        lv_site_id NUMBER;
    BEGIN
        SELECT
            vendor_site_id
        INTO lv_site_id
        FROM
            ap_supplier_sites_all
        WHERE
            vendor_site_code = site;

        RETURN lv_site_id;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END valid_site;



       
        
       /*************************************************************************************************
        * Program Name : PROCESS
        * Language     : PL/SQL     
        * Description  : PROCESS process to valid data into base table.
        * History      : 
        *
        * WHO              Version #   WHEN            WHAT
        * ======================================================================
        * DKUMAR           1.0         17-FEB-2025     Initial Version
        * DKUMAR           1.1         18-FEB-2025     ADDING HEADER VALIDATION
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
            line.charge_account,
            line.price                 AS unit_price,
            line.need_by_date          AS need_by_date,
            line.destination_type,
            line.requester_id,
            line.org_id                AS destination_organization_id,
            line.ship_to_location_code AS deliver_to_location_id,
            line.supplier_id           AS vendor_id,
            line.site_id               AS vendor_site_id,
            line.line_type,
            line.source,
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
        insert_tbl              tbl_type;
        ln_header_id            NUMBER;
        gn_request_id           NUMBER := p_batch_id;
        lv_chart_of_accounts_id NUMBER;
    BEGIN
        FND_FILE.PUT_LINE(FND_FILE.LOG, 'PROCESS START');
        dbms_output.put_line('PROCESS START');
        OPEN cur_int;
        LOOP
            FETCH cur_int
            BULK COLLECT INTO insert_tbl LIMIT 5;
            EXIT WHEN insert_tbl.count = 0;
            FOR i IN 1..insert_tbl.count LOOP
                /*
                    SELECT
                        gcc.code_combination_id
                    INTO lv_chart_of_accounts_id
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
                            || gcc.segment5 = insert_tbl(i).charge_account;
                */

                BEGIN
                    ln_header_id := po_headers_interface_s.nextval;
                    dbms_output.put_line(' START');
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
                        HEADER_ATTRIBUTE2,
                        line_attribute1,
                        LINE_ATTRIBUTE2
                    ) VALUES (
                        po_headers_interface_s.NEXTVAL,
                        gn_request_id,
                        'IMPORT_REQ',
                        'PURCHASE',
                        insert_tbl(i).org_id,
                        insert_tbl(i).destination_type,
                        insert_tbl(i).auth_status,
                        insert_tbl(i).need_by_date,
                        insert_tbl(i).preparer_id,
                        lv_chart_of_accounts_id,  --fnd_profile.value('GL_SET_OF_BKS_ID'),
                        insert_tbl(i).source,
                        insert_tbl(i).uom,
                        insert_tbl(i).line_type,
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
                        GN_REQUEST_ID,
                        insert_tbl(i).line_record_id,
                        GN_REQUEST_ID
                    );

                    fnd_file.put_line(fnd_file.log, 'CREATE REQ INTERFACE SUCCESSFULLY');
                EXCEPTION
                    WHEN OTHERS THEN
                    FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN INSERT IN PO_REQUISITIONS_INTERFACE_ALL: ' || sqlerrm);
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
        * Program Name : SUBMIT_REQUEST
        * Language     : PL/SQL     
        * Description  : SUBMIT_REQUEST process to run REQIMPORT program from backend.
        * History      : 
        *
        * WHO              Version #   WHEN            WHAT
        * ======================================================================
        * DKUMAR           1.0         21-FEB-2025     Initial Version
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
        LN_ERROR_MESSAGE  VARCHAR2(5000);
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

        UPDATE xxqgen_po_req_hdr_stg_dk
        SET
            status = 'P'
        WHERE 1=1
            AND STATUS = 'V'
            AND REQUEST_ID = GN_REQUEST_ID
            AND record_id IN (
                SELECT
                    attribute1
                FROM
                    po_requisition_headers_all
                WHERE created_by = GN_USER_ID
            );

        UPDATE xxqgen_po_req_line_stg_dk
        SET
            status = 'P'
        WHERE 1=1
            AND STATUS = 'V'
            AND REQUEST_ID = GN_REQUEST_ID
            AND record_id IN (
                SELECT
                    attribute1
                FROM
                    po_requisition_headers_all
                WHERE created_by = GN_USER_ID
            );
            
            

        -- SET VALID DATA IN ERROR WHICH IS NOT INSERTED IN BASE TABLE
        UPDATE XXQGEN_PO_REQ_LINE_STG_DK
        SET STATUS = 'E'
        WHERE 1=1
            AND STATUS = 'V'
            AND ERROR_MESSAGE = ERROR_MESSAGE || 'ERROR IN DATA SHOW IN PO_INTERFACE_ERRORS'
            AND CREATED_BY = GN_USER_ID
            AND REQUEST_ID = GN_REQUEST_ID;
            
         -- SET VALID DATA IN ERROR WHICH IS NOT INSERTED IN BASE TABLE
        UPDATE XXQGEN_PO_REQ_HDR_STG_DK
        SET STATUS = 'E'
        WHERE 1=1
            AND STATUS = 'V'
            AND ERROR_MESSAGE = ERROR_MESSAGE || 'ERROR IN DATA SHOW IN PO_INTERFACE_ERRORS'
            AND CREATED_BY = GN_USER_ID
            AND REQUEST_ID = GN_REQUEST_ID;
    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.log, 'ERROR IN REQUISITION SUBMIT PROCESS: ' || SQLCODE || ' - ' || sqlerrm);
    END submit_requisition;

    PROCEDURE validate2 (
        p_batch_id NUMBER
    ) IS

        CURSOR cur_hdr IS
        SELECT
            *
        FROM
            xxqgen_po_req_hdr_stg_dk
        WHERE
                1 = 1
            AND batch_id = p_batch_id
            AND status = 'N';

        CURSOR cur_line IS
        SELECT
            *
        FROM
            xxqgen_po_req_line_stg_dk
        WHERE
                1 = 1
            AND batch_id = p_batch_id
            AND status = 'N';

        ls_err_message VARCHAR2(4000);
    BEGIN
        FOR rec_hdr IN cur_hdr LOOP
            BEGIN
                rec_hdr.status := 'V';
                rec_hdr.error_message := ' ';     
                    
                    -- VALIDATE ORG   
                rec_hdr.org_id := valid_org(rec_hdr.operating_unit);
                IF rec_hdr.org_id = 0 THEN
                    rec_hdr.status := 'E';
                    rec_hdr.error_message := rec_hdr.error_message || ' ORGANIZATION_IS INVALID';
                END IF;
                        

                    -- VALIDATE PREPARER
                rec_hdr.preparer_id := valid_preparer(rec_hdr.preparer);
                IF rec_hdr.preparer_id = 0 THEN
                    rec_hdr.status := 'E';
                    rec_hdr.error_message := rec_hdr.error_message || ' INVALID PREPARER';
                END IF;

--                rec_hdr.total := total(rec_hdr.header_id, p_batch_id);
--                IF rec_hdr.total = 0 THEN
--                    rec_hdr.status := 'E';
--                    rec_hdr.error_message := rec_hdr.error_message || ' INVALID TOTAL';
--                END IF;

                BEGIN
                    UPDATE xxqgen_po_req_hdr_stg_dk
                    SET
                        status = rec_hdr.status,
                        org_id = rec_hdr.org_id,
    --                        TYPE_LOOKUP_CODE = REC_HDR.TYPE_LOOKUP_CODE,
                        preparer_id = rec_hdr.preparer_id,
                        total = rec_hdr.total,
                        error_message = rec_hdr.error_message
                    WHERE
                            1 = 1
                        AND batch_id = p_batch_id;

                    rec_hdr.error_message := '';
                EXCEPTION
                    WHEN OTHERS THEN
                        fnd_file.put_line(fnd_file.log, 'ERROR IN UPDATING HEADER VALIDATIONS: ' || SQLCODE || ' - ' || sqlerrm);
                        dbms_output.put_line('ERROR IN UPDATING HEADER VALIDATIONS: ' || sqlerrm);
                END;

            END;
        END LOOP;

            -- VALIDATE LINES    
        FND_FILE.PUT_LINE(FND_FILE.LOG, 'LINE LOOP START : ');
        FOR rec_line IN cur_line LOOP
            BEGIN
                rec_line.status := 'V';
                rec_line.error_message := ' ';
                
                    rec_line.org_id := valid_org(rec_line.organization);
                    IF rec_line.org_id = 0 THEN
                        rec_line.status := 'E';
                        rec_line.error_message := rec_line.error_message || ' ORGANIZATION_IS INVALID';
                    END IF;

                

                -- Validate Item
                    rec_line.item_id := valid_item(rec_line.item, rec_line.org_id);
                    IF rec_line.item_id = 0 THEN
                        rec_line.status := 'E';
                        rec_line.error_message := rec_line.error_message || ' ITEM IS INVALID';
                    END IF;

                

                 -- Validate Category
                    rec_line.category_id := valid_category(rec_line.catagory);
                    IF rec_line.category_id = 0 THEN
                        rec_line.status := 'E';
                        rec_line.error_message := rec_line.error_message || ' CATEGORY IS INVALID';
                    END IF;

                

                 -- Validate Location
                    rec_line.ship_to_location_code := valid_location(rec_line.location);
                    IF rec_line.ship_to_location_code = 0 THEN
                        rec_line.status := 'E';
                        rec_line.error_message := rec_line.error_message || ' LOCATION IS INVALID';
                    END IF;

                

                 -- Validate Supplier
                    IF rec_line.supplier IS NOT NULL THEN
                        rec_line.supplier_id := valid_supplier(rec_line.supplier);
                        IF rec_line.supplier_id = 0 THEN
                            rec_line.status := 'E';
                            rec_line.error_message := rec_line.error_message || ' SUPPLIER IS INVALID';
                        END IF;

                    END IF;
                

                
                    rec_line.requester_id := valid_preparer(rec_line.requester);
                    IF rec_line.requester_id = 0 THEN
                        rec_line.status := 'E';
                        rec_line.error_message := rec_line.error_message || ' INVALID P';
                    END IF;

                

                 -- Validate Site
                    IF rec_line.site IS NOT NULL THEN
                        rec_line.site_id := valid_site(rec_line.site);
                        IF rec_line.site_id = 0 THEN
                            rec_line.status := 'E';
                            rec_line.error_message := rec_line.error_message || ' SITE IS INVALID';
                        END IF;

                    END IF;
                
                    
    --                BEGIN
    --                    IF REC_LINE.LINE_TYPE IS NOT NULL THEN
    --                        REC_LINE.LINE_TYPE_ID := VALID_LINE_TYPE(REC_LINE.LINE_TYPE);
    --                        IF REC_LINE.LINE_TYPE_ID = 0 THEN
    --                            REC_LINE.STATUS := 'E';
    --                            REC_LINE.ERROR_MESSAGE := REC_LINE.ERROR_MESSAGE || 'LINE_TYPE IS INVALID ';
    --                        END IF;
    --                    END IF;
    --                END;

                BEGIN
                    UPDATE xxqgen_po_req_line_stg_dk
                    SET
                        status = rec_line.status,
                        item_id = rec_line.item_id,
                        category_id = rec_line.category_id,
                        ship_to_location_code = rec_line.ship_to_location_code,
                        supplier_id = rec_line.supplier_id,
                        site_id = rec_line.site_id,
                        requester_id = rec_line.requester_id,
                        line_type_id = rec_line.line_type_id,
                        org_id = rec_line.org_id,
                        error_message = error_message
                                        || ' '
                                        || rec_line.error_message
                    WHERE
                            1 = 1
                        AND batch_id = p_batch_id
                        AND line_id = rec_line.line_id;

                    rec_line.error_message := '';
                EXCEPTION
                    WHEN OTHERS THEN
                        fnd_file.put_line(fnd_file.log, 'ERROR IN UPDATING HEADER VALIDATIONS: ' || SQLCODE || ' - ' || sqlerrm);
                        dbms_output.put_line('ERROR IN UPDATION OF LINE VALIDATIONS: ' || sqlerrm);
                END;

            END;
        END LOOP;
            
            -- THIS VALIDATION FOR WHEN THE HEADER IS IN VALID AND LINE IN ERROR
        UPDATE xxqgen_po_req_hdr_stg_dk
        SET
            status = 'E'
        WHERE
            header_id = (
                SELECT
                    header_id
                FROM
                    xxqgen_po_req_line_stg_dk
                WHERE
                        status = 'E'
                    AND request_id = gn_request_id
            );
         
            -- THIS VALIDATION FOR WHEN THE HEADER IS IN ERROR AND LINE IS IN VALID 
        UPDATE xxqgen_po_req_line_stg_dk
        SET
            status = 'E'
        WHERE
            header_id = (
                SELECT
                    header_id
                FROM
                    xxqgen_po_req_hdr_stg_dk
                WHERE
                        status = 'E'
                    AND request_id = gn_request_id
            );

    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.log, 'ERROR IN VALIDATIONS: ' || SQLCODE || ' - ' || sqlerrm);
    END validate2;

    PROCEDURE validate (
        p_batch_id NUMBER
    ) IS

        CURSOR cur_hdr IS
        SELECT
            *
        FROM
            xxqgen_po_req_hdr_stg_dk
        WHERE
                batch_id = p_batch_id
            AND status = 'N';

        CURSOR cur_line (
            p_header_id VARCHAR2,
            p_org_id    NUMBER
        ) IS
        SELECT
            *
        FROM
            xxqgen_po_req_line_stg_dk
        WHERE
                batch_id = p_batch_id
            AND status = 'N'
            AND header_id = p_header_id
            AND org_id = p_org_id;

        ls_err_message   VARCHAR2(4000);

    -- Variables for tracking line and header status
        ln_flag          NUMBER := 0;
        ln_flag_dist     NUMBER := 0;
        ln_flag_hdr_dist NUMBER := 0;
    BEGIN
    -- Loop through each header record
        FOR rec_hdr IN cur_hdr LOOP
            BEGIN
            -- Reset error messages and status for the header
                rec_hdr.status := 'V';
                rec_hdr.error_message := NULL;

            -- Validate operating unit (organization)
                rec_hdr.org_id := valid_org(rec_hdr.operating_unit);
                IF rec_hdr.org_id IS NULL THEN
                    rec_hdr.status := 'E';
                    rec_hdr.error_message := rec_hdr.error_message || ' - Invalid Organization.';
                    ln_flag := 1;
                END IF;

            -- Validate type lookup code
                rec_hdr.type_code := get_type_lookup_code(rec_hdr.type);
                IF rec_hdr.type_code IS NULL THEN
                    rec_hdr.status := 'E';
                    rec_hdr.error_message := rec_hdr.error_message || ' - Invalid LOOKUP Type.';
                    ln_flag := 1;
                END IF;

            -- Validate authorization status
                rec_hdr.auth_status_code := get_lookup_code(rec_hdr.AUTH_STATUS, 'AUTHORIZATION STATUS');
                IF rec_hdr.auth_status_code IS NULL THEN
                    rec_hdr.status := 'E';
                    rec_hdr.error_message := rec_hdr.error_message || ' - Invalid Status.';
                    ln_flag := 1;
                END IF;

            -- Validate preparer
                rec_hdr.preparer_id := valid_preparer(rec_hdr.preparer);
                IF rec_hdr.preparer_id IS NULL THEN
                    rec_hdr.status := 'E';
                    rec_hdr.error_message := rec_hdr.error_message || ' - Invalid Preparer.';
                    ln_flag := 1;
                END IF;

            -- Loop through each line related to the header
                FOR rec_line IN cur_line(rec_hdr.header_id, rec_hdr.org_id) LOOP
                    IF rec_line.header_id = rec_hdr.record_id THEN
                        BEGIN
                        -- Reset error message and status for the line
                            rec_line.status := 'V';
                            rec_line.error_message := NULL;

                        -- Validate line fields
                            rec_line.org_id := valid_org(rec_line.ORGANIZATION);
                            IF rec_line.org_id IS NULL THEN
                                rec_line.status := 'E';
                                rec_line.error_message := rec_line.error_message || ' - Invalid Operating Unit.';
                                ln_flag := 1;
                            END IF;

--                        rec_line.dest_org_id := get_org_id(rec_line.destination_organization);
--                        IF rec_line.destination_organization_id IS NULL THEN
--                            rec_line.status := 'E';
--                            rec_line.error_message := rec_line.error_message || ' - Invalid Destination Organization.';
--                                 LN_FLAG := 1;
--                        END IF;

                        -- Validate item ID
                            rec_line.item_id := valid_item(rec_line.item, rec_line.dest_org_id);
                            IF rec_line.item_id IS NULL THEN
                                rec_line.status := 'E';
                                rec_line.error_message := rec_line.error_message || ' - Invalid Item.';
                                ln_flag := 1;
                            END IF;

                        -- Validate category
                            rec_line.category_id := valid_category(rec_line.CATAGORY);
                            IF rec_line.category_id IS NULL THEN
                                rec_line.status := 'E';
                                rec_line.error_message := rec_line.error_message || ' - Invalid Category.';
                                ln_flag := 1;
                            END IF;

                        -- Validate vendor and vendor site
                            rec_line.supplier_id := valid_supplier(rec_line.supplier);
                            IF rec_line.supplier_id IS NULL THEN
                                rec_line.status := 'E';
                                rec_line.error_message := rec_line.error_message || ' - Invalid Vendor.';
                                ln_flag := 1;
                            END IF;

                            rec_line.site_id := valid_supplier(rec_line.site);
                            IF rec_line.site_id IS NULL THEN
                                rec_line.status := 'E';
                                rec_line.error_message := rec_line.error_message || ' - Invalid Vendor Site.';
                                ln_flag := 1;
                            END IF;
                            
                            --LOCATION_ID
                            rec_line.location_id := VALID_LOCATION(rec_line.location);
                            IF rec_line.location_id IS NULL THEN
                                rec_line.status := 'E';
                                rec_line.error_message := rec_line.error_message
                                                          || ' | '
                                                          || 'Location is not Valid';
                            END IF;
                            
                            -- DESTINATIOIN CODE
                            rec_line.destination_type_code := get_lookup_code(rec_line.destination_type, 'DESTINATION TYPE');
                            IF rec_line.destination_type_code IS NULL THEN
                                rec_line.error_message := rec_line.error_message
                                                          || ' | '
                                                          || 'Datination is not Valid';
                            END IF;

                            -- SOURCE TYPE CODE
                            rec_line.source_type_code := get_lookup_code(rec_line.source, 'VENDOR TYPE');
                            IF rec_line.source_type_code IS NULL THEN
                                rec_line.status := 'E';
                                rec_line.error_message := rec_line.error_message
                                                          || ' | '
                                                          || 'Error occurs due to Source at line level. ';
                                rec_line.status := 'E';
                                rec_line.error_message := rec_line.error_message
                                                          || ' | '
                                                          || 'Source is not Valid';
                            END IF;
                     
                            
                            -- CHARGE ACCOUNT 
                            rec_line.charge_account_id := get_chart_account_id(rec_line.charge_account, rec_line.org_id);
                            IF rec_LINE.charge_account_id IS NULL THEN
                                rec_LINE.status := 'E';
                                rec_LINE.error_message := rec_LINE.error_message
                                                          || ' '
                                                          || 'Charge Account is not Valid for this organization';
                            END IF;

                            -- UPDATE HEADER WITH LINE STATUS AND ERROR
                            IF rec_line.status = 'E' THEN
                                rec_hdr.status := 'E';
                                rec_hdr.error_message := rec_hdr.error_message
                                                         || ', ERROR IN LINE : '
                                                         || rec_line.error_message;
                            END IF;
                            
                        -- Update the line with new validated values
                            UPDATE xxqgen_po_req_line_stg_dk
                            SET
                                org_id = rec_line.org_id,
                                dest_org_id = rec_line.DEST_ORG_ID,
                                item_id = rec_line.item_id,
                                category_id = rec_line.category_id,
                                SUPPLIER_ID = rec_line.SUPPLIER_id,
                                site_id = rec_line.site_id,
                                status = rec_line.status,
                                error_message = rec_line.error_message
                            WHERE
                                record_id = rec_line.record_id;

                        EXCEPTION
                            WHEN OTHERS THEN
                                rec_line.status := 'E';
                                rec_line.error_message := 'Error IN VALIDATION : '
                                                          || sqlcode
                                                          || ' - '
                                                          || sqlerrm;
                                UPDATE xxqgen_po_req_line_stg_dk
                                SET
                                    status = rec_line.status,
                                    error_message = rec_line.error_message
                                WHERE
                                    record_id = rec_line.record_id;

                        END;

                    END IF;
                END LOOP;
                
                
                

            -- Update header after line validation
                UPDATE xxqgen_po_req_hdr_stg_dk
                SET
                    status = rec_hdr.status,
                    error_message = rec_hdr.error_message
                WHERE
                    record_id = rec_hdr.record_id;

            -- Commit after processing each header
                COMMIT;
            EXCEPTION
                WHEN OTHERS THEN
                    rec_hdr.status := 'E';
                    rec_hdr.error_message := 'SQL Error: '
                                             || sqlcode
                                             || ' - '
                                             || sqlerrm;
                    UPDATE xxqgen_po_req_hdr_stg_dk
                    SET
                        status = rec_hdr.status,
                        error_message = rec_hdr.error_message
                    WHERE
                        record_id = rec_hdr.record_id;

                    COMMIT;
            END;
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            ls_err_message := 'SQL Error: '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
        -- Handle any exceptions outside the loop
            COMMIT;
    END validate;

        
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

    PROCEDURE validate_require (
        p_batch_id NUMBER
    ) IS
        
        CURSOR CUR_HEAD IS
        SELECT *
        FROM XXQGEN_PO_REQ_HDR_STG_DK
        WHERE STATUS = 'E'
            AND BATCH_ID = P_BATCH_ID
            AND REQUEST_ID = GN_REQUEST_ID;
            
        CURSOR CUR_LINE IS
        SELECT *
        FROM XXQGEN_PO_REQ_LINE_STG_DK
        WHERE STATUS = 'E'
            AND BATCH_ID = P_BATCH_ID
            AND REQUEST_ID = GN_REQUEST_ID;
    
    BEGIN
        FOR REC_HEAD IN CUR_HEAD LOOP
        
            IF VALID_LINE(REC_HEAD.HEADER_ID ) = 0 THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'NO LINE FOUND ';
            END IF;
            
            UPDATE XXQGEN_PO_REQ_HDR_STG_DK
            SET STATUS = REC_HEAD.STATUS,
                   ERROR_MESSAGE = REC_HEAD.ERROR_MESSAGE
            WHERE 1=1
                AND REC_HEAD.STATUS = 'E'
                AND RECORD_ID = REC_HEAD.RECORD_ID;
        END LOOP;
        
        FOR REC_LINE IN CUR_LINE LOOP
            IF VALID_HEADER (REC_LINE.HEADER_ID) = 0 THEN
                REC_LINE.STATUS := 'E';
                REC_LINE.ERROR_MESSAGE := 'NO HEADER FOUND ';
            END IF;
            
            UPDATE XXQGEN_PO_REQ_LINE_STG_DK
            SET STATUS = REC_LINE.STATUS,
                  ERROR_MESSAGE = REC_LINE.ERROR_MESSAGE
             WHERE REC_LINE.STATUS = 'E'
                  AND RECORD_ID = REC_LINE.RECORD_ID;
        END LOOP;
            -- VALIDATE REQUIRED FOR HEADER
        BEGIN
            UPDATE xxqgen_po_req_hdr_stg_dk
            SET
                status = 'E',
                error_message = error_message || ' OPERATING UNIT CAN NOT BE NULL'
            WHERE
                operating_unit IS NULL
                AND batch_id = p_batch_id;

        EXCEPTION
            WHEN OTHERS THEN
                FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN HEADER OPERATING UNIT VALIDATE: ' || SQLCODE || ' - ' || sqlerrm);
        END;

        BEGIN
            UPDATE xxqgen_po_req_hdr_stg_dk
            SET
                status = 'E',
                error_message = error_message || ' TYPE CAN NOT BE NULL'
            WHERE
                type IS NULL
                AND batch_id = p_batch_id;

        END;

            -- VALIDATE REQUIRED FOR LINE LINE_NUM
        BEGIN
            UPDATE xxqgen_po_req_line_stg_dk
            SET
                status = 'E',
                error_message = error_message || ' LINE_NUM CAN NOT BE NULL'
            WHERE
                line_num IS NULL
                AND batch_id = p_batch_id;

        END;
            
        
       -- NEED BY DATE
       UPDATE XXQGEN_PO_REQ_LINE_STG_DK
       SET STATUS = 'E',
       ERROR_MESSAGE = ERROR_MESSAGE || ' NEED BY DATE IS INVALID OR NULL'
       WHERE NEED_BY_DATE IS NULL
           OR   SYSDATE + 1 > NEED_BY_DATE
           AND BATCH_ID = P_BATCH_ID;
    --        BEGIN
    --            UPDATE XXQGEN_PO_REQ_LINE_STG_DK
    --            SET STATUS = 'E',
    --                ERROR_MESSAGE = ERROR_MESSAGE || ' TYPE CAN NOT BE NULL'
    --            WHERE TYPE IS NULL 
    --            AND BATCH_ID = P_BATCH_ID;
    --        END;

        BEGIN
            UPDATE xxqgen_po_req_line_stg_dk
            SET
                status = 'E',
                error_message = error_message || ' DESCREPTION CAN NOT BE NULL'
            WHERE
                descreption IS NULL
                AND batch_id = p_batch_id;

        END;

        BEGIN
            UPDATE xxqgen_po_req_line_stg_dk
            SET
                status = 'E',
                error_message = error_message || ' UOM CAN NOT BE NULL'
            WHERE
                uom IS NULL
                AND batch_id = p_batch_id;

        END;

        BEGIN
            UPDATE xxqgen_po_req_line_stg_dk
            SET
                status = 'E',
                error_message = error_message || ' QUANTITY CAN NOT BE NULL'
            WHERE
                quantity IS NULL
                AND batch_id = p_batch_id;

        END;

        BEGIN
            UPDATE xxqgen_po_req_line_stg_dk
            SET
                status = 'E',
                error_message = error_message || ' PRICE CAN NOT BE NULL'
            WHERE
                price IS NULL
                AND batch_id = p_batch_id;

        END;

        BEGIN
            UPDATE xxqgen_po_req_line_stg_dk
            SET
                status = 'E',
                error_message = error_message || ' NEED_BY CAN NOT BE NULL'
            WHERE
                need_by_date IS NULL
                AND batch_id = p_batch_id;

        END;
            
            -- DESTRIBUTION
        BEGIN
            UPDATE xxqgen_po_req_line_stg_dk
            SET
                status = 'E',
                error_message = error_message || ' DESTINATION_TYPE CAN NOT BE NULL'
            WHERE
                destination_type IS NULL
                AND batch_id = p_batch_id;

        END;

        BEGIN
            UPDATE xxqgen_po_req_line_stg_dk
            SET
                status = 'E',
                error_message = error_message || ' REQUESTER CAN NOT BE NULL'
            WHERE
                requester IS NULL
                AND batch_id = p_batch_id;

        END;

        BEGIN
            UPDATE xxqgen_po_req_line_stg_dk
            SET
                status = 'E',
                error_message = error_message || ' ORGANIZATION CAN NOT BE NULL'
            WHERE
                organization IS NULL
                AND batch_id = p_batch_id;

        END;

        BEGIN
            UPDATE xxqgen_po_req_line_stg_dk
            SET
                status = 'E',
                error_message = error_message || ' LOCATION CAN NOT BE NULL'
            WHERE
                location IS NULL
                AND batch_id = p_batch_id;

        END;
        
        
        -- CONTINUE
--        BEGIN
--            SELECT COUNT(*)
--            FROM XXQGEN_PO_REQ_LINES_STG_DK
--            WHERE REQUEST_ID = GN_REQUEST_ID
--                AND HEADER_I
--        END;
            
    --        BEGIN
    --            UPDATE XXQGEN_PO_REQ_LINE_STG_DK
    --            SET STATUS = 'E',
    --                ERROR_MESSAGE = ERROR_MESSAGE || ' SOURCE_TYPE_DISP CAN NOT BE NULL'
    --            WHERE SOURCE_TYPE_DISP IS NULL 
    --            AND BATCH_ID = P_BATCH_ID;
    --        END;    

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            fnd_file.put_line(fnd_file.log, 'ERROR IN LOADING DATA INTO STAGING TABLE:  '
                                            || sqlcode
                                            || ' - '
                                            || sqlerrm);

            dbms_output.put_line('ERROR IN LOADING DATA INTO STAGING TABLE: '
                                 || sqlcode
                                 || ' - '
                                 || sqlerrm);
    END validate_require;
        
        
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

    PROCEDURE load_data (
        batch_id NUMBER
    ) IS
    BEGIN
            --************* INSERT DATA***************
            --*******R1*********
        INSERT INTO xxqgen_po_req_hdr_stg_dk (
            operating_unit,
            org_id,
            header_id,
            type,
                --TYPE_LOOKUP_CODE,
            preparer,
            preparer_id,
            description,
            auth_status,
            total,
            status,
            error_message,
            creation_date,
            created_by,
            last_updated_by,
            updated_by,
            request_id,
            batch_id,
            record_id
        ) VALUES (
            'Vision Operations',
            NULL,
            xxqgen_intr_header_id.NEXTVAL,
            'Purchase Requisition',
    --            NULL,
            'Stock, Ms. Pat',
            NULL,
            NULL,
            'INCOMPLETE',
            NULL,
            'N',
            NULL,
            sysdate,
            fnd_profile.value('USER_ID'),
            sysdate,
            fnd_profile.value('USER_ID'),
            fnd_profile.value('CONC_REQUEST_ID'),
            xxqgen_intr_batch_id.CURRVAL,
            xxqgen_rec_id_dk.NEXTVAL
        );

        INSERT INTO xxqgen_po_req_line_stg_dk (
            line_num,
            line_id,
            header_id,
            line_type,
            item,
            rev,
            catagory,
            category_id,
            descreption,
            uom,
            quantity,
            price,
            need_by_date,
            amount,
            charge_account,
            destination_type,
            requester,
            requester_id,
            organization,
            org_id,
            location,
            ship_to_location_code,
            source,
            supplier,
            site,
            contact,
            phone,
            status,
            error_message,
            creation_date,
            created_by,
            last_updated_by,
            updated_by,
            request_id,
            batch_id,
            RECORD_ID
        ) VALUES (
            1,
            xxqgen_intr_line_id.NEXTVAL,
            xxqgen_intr_header_id.CURRVAL,
            1,
            'IR0011',
            NULL,
            'SUPPLIES.OFFICE',
            NULL,
            'Light Bulbs',
            'Each',
            100000,
            2.5,
            sysdate + 50,
            250000.00,
            '01-000-1410-0000-000',
            'EXPENSE',
            'Stock, Ms. Pat',
            NULL,
            'Vision Operations',
            NULL,
            'V1 Ship Site A',
            NULL,
    --            'Supplier',
            'VENDOR',
            NULL,
            NULL,
            NULL,
            NULL,
            'N',
            NULL,
            sysdate,
            fnd_profile.value('USER_ID'),
            sysdate,
            fnd_profile.value('USER_ID'),
            fnd_profile.value('CONC_REQUEST_ID'),
            xxqgen_intr_batch_id.CURRVAL,
            xxqgen_rec_id_dk.CURRVAL
        );

            --******R2**********
        INSERT INTO xxqgen_po_req_hdr_stg_dk (
            operating_unit,
            org_id,
            header_id,
    --            SEGMENT1,
            type,
    --            TYPE_LOOKUP_CODE,
            preparer,
            preparer_id,
            description,
            auth_status,
            total,
            status,
            error_message,
            creation_date,
            created_by,
            last_updated_by,
            updated_by,
            request_id,
            batch_id,
            record_id
        ) VALUES (
            'Vision Operations',
            NULL,
            xxqgen_intr_header_id.NEXTVAL,
    --            XXQGEN_INTR_SEGMENT1.CURRVAL,
            'Purchase Requisition',
    --            NULL,
            'Stock, Ms. Pat',
            NULL,
            NULL,
            'APPROVED',
            NULL,
            'N',
            NULL,
            sysdate,
            fnd_profile.value('USER_ID'),
            sysdate,
            fnd_profile.value('USER_ID'),
            fnd_profile.value('CONC_REQUEST_ID'),
            xxqgen_intr_batch_id.CURRVAL,
            xxqgen_rec_id_dk.CURRVAL
        );

        INSERT INTO xxqgen_po_req_line_stg_dk (
            line_num,
            line_id,
            header_id,
            line_type,
            item,
            rev,
            catagory,
            category_id,
            descreption,
            uom,
            quantity,
            price,
            need_by_date,
            amount,
            charge_account,
    --            SECOND_UOM,
    --            SECONDRY_QUANTITY,
            destination_type,
            requester,
            requester_id,
            organization,
            org_id,
            location,
            ship_to_location_code,
            source,
    --            SUBINVENTORY,
            supplier,
            site,
            contact,
            phone,
            status,
            error_message,
            creation_date,
            created_by,
            last_updated_by,
            updated_by,
            request_id,
            batch_id,
            record_id
        ) VALUES (
            2,
            xxqgen_intr_line_id.NEXTVAL,
            xxqgen_intr_header_id.CURRVAL,
            1,
            'IR0011',
            NULL,
            'SUPPLIES.OFFICE',
            NULL,
            'Light Bulbs',
            'Each',
            30,
            2.5,
            sysdate + 50,
            750000.00,
            '01-000-1410-0000-000',
    --            NULL,
    --            NULL,
            'EXPENSE',
            'Stock, Ms. Pat',
            NULL,
            'Vision Operations',
            NULL,
            'V1 Ship Site A',
            NULL,
    --            'Supplier',
            'VENDOR',
            NULL,
            NULL,
            NULL,
            NULL,
            'N',
            NULL,
            sysdate,
            fnd_profile.value('USER_ID'),
            sysdate,
            fnd_profile.value('USER_ID'),
            fnd_profile.value('CONC_REQUEST_ID'),
            xxqgen_intr_batch_id.CURRVAL,
            xxqgen_rec_id_dk.CURRVAL
        );

            --*******R3*******
        INSERT INTO xxqgen_po_req_hdr_stg_dk (
            operating_unit,
            org_id,
            header_id,
    --            SEGMENT1,
            type,
    --            TYPE_LOOKUP_CODE,
            preparer,
            preparer_id,
            description,
            auth_status,
            total,
            status,
            error_message,
            creation_date,
            created_by,
            last_updated_by,
            updated_by,
            request_id,
            batch_id,
            record_id
        ) VALUES (
            'Vision Operations',
            NULL,
            xxqgen_intr_header_id.NEXTVAL,
    --            XXQGEN_INTR_SEGMENT1.CURRVAL,
            'Purchase Requisition',
    --            NULL,
            'Stock, Ms. Pat',
            NULL,
            NULL,
            'INCOMPLETE',
            NULL,
            'N',
            NULL,
            sysdate,
            fnd_profile.value('USER_ID'),
            sysdate,
            fnd_profile.value('USER_ID'),
            fnd_profile.value('CONC_REQUEST_ID'),
            xxqgen_intr_batch_id.CURRVAL,
            xxqgen_rec_id_dk.NEXTVAL
        );

        INSERT INTO xxqgen_po_req_line_stg_dk (
            line_num,
            line_id,
            header_id,
            line_type,
            item,
            rev,
            catagory,
            category_id,
            descreption,
            uom,
            quantity,
            price,
            need_by_date,
            amount,
            charge_account,
    --            SECOND_UOM,
    --            SECONDRY_QUANTITY,
            destination_type,
            requester,
            requester_id,
            organization,
            org_id,
            location,
            ship_to_location_code,
            source,
    --            SUBINVENTORY,
            supplier,
            site,
            contact,
            phone,
            status,
            error_message,
            creation_date,
            created_by,
            last_updated_by,
            updated_by,
            request_id,
            batch_id,
            record_id
        ) VALUES (
            3,
            xxqgen_intr_line_id.NEXTVAL,
            xxqgen_intr_header_id.CURRVAL,
            1,
            'IR0011',
            NULL,
            'SUPPLIES.OFFICE',
            NULL,
            'Light Bulbs',
            'Each',
            20,
            2.5,
            sysdate + 50,
            500000.00,
            '01-000-1410-0000-000',
    --            NULL,
    --            NULL,
            'EXPENSE',
            'Stock, Ms. Pat',
            NULL,
            'Vision Operations',
            NULL,
            'V1 Ship Site A',
            NULL,
            'Supplier',
    --            NULL,
            'VENDOR',
            NULL,
            NULL,
            NULL,
            'N',
            NULL,
            sysdate,
            fnd_profile.value('USER_ID'),
            sysdate,
            fnd_profile.value('USER_ID'),
            fnd_profile.value('CONC_REQUEST_ID'),
            xxqgen_intr_batch_id.CURRVAL,
            xxqgen_rec_id_dk.CURRVAL
        );

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('ERROR IN LOAD DATA: ' || sqlerrm);
    END load_data;

    PROCEDURE main (
        errbuf  OUT VARCHAR2,
        retcode OUT NUMBER
    ) IS
        ln_batch_id     NUMBER := xxqgen_intr_batch_id.nextval;
        ln_cur_batch_id NUMBER := xxqgen_intr_batch_id.currval;
    BEGIN
    --        fnd_global.apps_initialize(1016246, 50578, 201);
    --        mo_global.init('PO');
    --        mo_global.set_policy_context('S', 204);
        load_data(ln_batch_id);
        validate_require(ln_cur_batch_id);
        validate2(ln_cur_batch_id);
        process(ln_cur_batch_id);
        submit_requisition;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('ERROR IN MAIN: ' || sqlerrm);
    END main;

END xxqgen_req_int_dev;
/