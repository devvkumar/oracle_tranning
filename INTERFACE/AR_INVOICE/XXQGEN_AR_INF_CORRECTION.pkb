/* Formatted on 5/27/2025 11:22:18 AM (QP5 v5.163.1008.3004) */

CREATE OR REPLACE PACKAGE BODY XXQGEN_AR_INF_CORRECTION
IS
    /***************************************************************************************************
    * Program Name : XXQGEN_AR_INVOICE_INF_DK.pkb
    * Language     : PL/SQL
    * Description  : Specks for XXQGEN_AR_INVOICE_INF_DK.pkb
    * History      :
    * WHO                                  Version #           WHEN                        WHAT
    * =======================================================================
    * DKUMAR                            1.0                     28-MAY-2025             Initial Version
    * DKUMAR                           1.1                     28-MAY-2025             ADDING VALIDATION REQUIRED
    * DKUMAR                          1.2                     28-MAY-2025              ADDING FUNCTION FOR VALIDATION
    * DKUMAR                          1.3                     29-MAY-2025              ADDING IMPORT PROCEDURE
    ***************************************************************************************************/

    /*************************************************************************************************
    * Program Name : CHK_CUSTOMER
    * Language     : PL/SQL     
    * Description  : CHK_CUSTOMER process to valdiate CUSTOMER name.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         28-MAY-2025     Initial Version
    ***************************************************************************************************/

   FUNCTION CHK_CUSTOMER (P_CUSTOMER_NAME VARCHAR2)
      RETURN NUMBER
   IS
      v_cust_account_id   NUMBER;
   BEGIN
      SELECT customer_id
        INTO v_cust_account_id
        FROM ra_customers
       WHERE customer_name = p_customer_name;

      RETURN v_cust_account_id;
   EXCEPTION
      WHEN OTHERS
      THEN
         FND_FILE.PUT_LINE (
            FND_FILE.LOG,
            'ERROR IN CHK_CUSTOMER BLOCK : ' || SQLCODE || ' - ' || SQLERRM);
         RETURN 0;
   END CHK_CUSTOMER;

    /*************************************************************************************************
    * Program Name : CHK_ITEM
    * Language     : PL/SQL     
    * Description  : CHK_ITEM process to valdiate ITEM name.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         28-MAY-2025     Initial Version
    ***************************************************************************************************/
   PROCEDURE CHK_ITEM (P_ITEM          IN     VARCHAR2,
                       P_ORG           IN     NUMBER,
                       V_DESCRIPTION      OUT VARCHAR2,
                       V_ITEM_ID          OUT NUMBER)
   IS
   BEGIN
      SELECT INVENTORY_ITEM_ID, DESCRIPTION
        INTO V_ITEM_ID, V_DESCRIPTION
        FROM MTL_SYSTEM_ITEMS_B
       WHERE     UPPER (SEGMENT1) = UPPER (P_ITEM)
             AND ORGANIZATION_ID = P_ORG
             AND ENABLED_FLAG = 'Y';
   EXCEPTION
      WHEN OTHERS
      THEN
         FND_FILE.PUT_LINE (
            FND_FILE.LOG,
            'ERROR IN CHK_ITEM BLOCK : ' || SQLCODE || ' - ' || SQLERRM);
         V_ITEM_ID := 0;
         V_DESCRIPTION := 0;
   END CHK_ITEM;

    
   /*************************************************************************************************
    * Program Name : CHK_ORDER_TYPE
    * Language     : PL/SQL     
    * Description  : CHK_ORDER_TYPE process to valdiate ORDER_TYPE name.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         28-MAY-2025     Initial Version
    ***************************************************************************************************/

   FUNCTION CHK_ORDER_TYPE (P_NAME VARCHAR2)
      RETURN NUMBER
   IS
      V_TYPE_ID   NUMBER;
   BEGIN
      SELECT TRANSACTION_TYPE_ID
        INTO V_TYPE_ID
        FROM OE_TRANSACTION_TYPES_TL
       WHERE UPPER (NAME) = UPPER (P_NAME);

      RETURN V_TYPE_ID;
   EXCEPTION
      WHEN OTHERS
      THEN
         FND_FILE.PUT_LINE (
            FND_FILE.LOG,
            'ERROR IN ORDER_TYPE : ' || SQLCODE || ' - ' || SQLERRM);
         RETURN 0;
   END CHK_ORDER_TYPE;

    /*************************************************************************************************
    * Program Name : CHK_CUST_TYPE
    * Language     : PL/SQL     
    * Description  : CHK_CUST_TYPE process to valdiate customer type.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         28-MAY-2025     Initial Version
    ***************************************************************************************************/

   FUNCTION CHK_TYPE (P_TYPE_NAME VARCHAR2)
      RETURN NUMBER
   IS
      V_TYPE_ID   NUMBER;
   BEGIN
      SELECT CUST_TRX_TYPE_ID
        INTO V_TYPE_ID
        FROM RA_CUST_TRX_TYPES_ALL
       WHERE UPPER (NAME) = UPPER (P_TYPE_NAME)
            AND ORG_ID = 204;

      RETURN V_TYPE_ID;
   EXCEPTION
      WHEN OTHERS
      THEN
         FND_FILE.PUT_LINE (
            FND_FILE.LOG,
            'ERROR IN CHK_TYPE BLOCK : ' || SQLCODE || ' - ' || SQLERRM);
         RETURN 0;
   END CHK_TYPE;
   
   
   /*************************************************************************************************
    * Program Name : CHK_LEGAL_ENTITY
    * Language     : PL/SQL     
    * Description  : CHK_LEGAL_ENTITY process to valdiate legal entity name.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         28-MAY-2025     Initial Version
    ***************************************************************************************************/

   FUNCTION CHK_LEGAL_ENTITY (P_ENTITY_NAME VARCHAR2)
      RETURN NUMBER
   IS
      V_ENTITY_ID   NUMBER;
   BEGIN
      SELECT LEGAL_ENTITY_ID
        INTO V_ENTITY_ID
        FROM XLE_ENTITY_PROFILES
       WHERE UPPER (NAME) = UPPER (P_ENTITY_NAME);

      RETURN V_ENTITY_ID;
   EXCEPTION
      WHEN OTHERS
      THEN
         FND_FILE.PUT_LINE (
            FND_FILE.LOG,
               'ERROR IN CHK_LEGAL_ENTITY BLOCK : '
            || SQLCODE
            || ' - '
            || SQLERRM);
         RETURN 0;
   END CHK_LEGAL_ENTITY;
   
   
   /*************************************************************************************************
    * Program Name : CHK_PAYMENT_TERM
    * Language     : PL/SQL     
    * Description  : CHK_PAYMENT_TERM process to valdiate payment term.
    * History      : 
    *
    * WHO                   Version #   WHEN                  WHAT
    * ======================================================================
    * DKUMAR             1.0            28-MAY-2025         Initial Version
    ***************************************************************************************************/

   FUNCTION CHK_PAYMENT_TERM (P_TERM VARCHAR2)
      RETURN NUMBER
   IS
      V_TERM_ID   NUMBER;
   BEGIN
      SELECT TERM_ID
        INTO V_TERM_ID
        FROM RA_TERMS
       WHERE UPPER (NAME) = UPPER (P_TERM);


      FND_FILE.PUT_LINE (FND_FILE.LOG, 'ENTER IN CHK_PAYMENT_TERM');


      RETURN V_TERM_ID;
   EXCEPTION
      WHEN OTHERS
      THEN
         FND_FILE.PUT_LINE (
            FND_FILE.LOG,
               'ERROR IN CHK_PAYMENT_TERM BLOCK : '
            || SQLCODE
            || ' - '
            || SQLERRM);
         RETURN 0;
   END CHK_PAYMENT_TERM;
   
   
   /*************************************************************************************************
    * Program Name : CHK_SALESPER_NAME
    * Language     : PL/SQL     
    * Description  : CHK_SALESPER_NAME process to valdiate sales person name.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         28-MAY-2025     Initial Version
    ***************************************************************************************************/

   PROCEDURE CHK_SALESPER_NAME (P_SALESREP_NAME   IN     VARCHAR2,
                                V_PERSON_ID          OUT NUMBER,
                                V_PERSON_NUMBER      OUT NUMBER)
   IS
   BEGIN
      SELECT SALESREP_ID, SALESREP_NUMBER
        INTO V_PERSON_ID, V_PERSON_NUMBER
        FROM jtf_rs_salesreps
       WHERE UPPER (NAME) = UPPER (P_SALESREP_NAME);
   EXCEPTION
      WHEN OTHERS
      THEN
         FND_FILE.PUT_LINE (
            FND_FILE.LOG,
               'ERROR IN CHK_SALESPER_NAME BLOCK : '
            || SQLCODE
            || ' - '
            || SQLERRM);
         V_PERSON_ID := 0;
         V_PERSON_NUMBER := 0;
   END CHK_SALESPER_NAME;
   
   
   /*************************************************************************************************
    * Program Name : CHK_CODE_COMBINATION
    * Language     : PL/SQL     
    * Description  : CHK_CODE_COMBINATION process to valdiate code combination.
    * History      : 
    *
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR           1.0         28-MAY-2025     Initial Version
    ***************************************************************************************************/

   FUNCTION CHK_CODE_COMBINATION (P_SEGMENT1    VARCHAR2,
                                  P_SEGMENT2    VARCHAR2,
                                  P_SEGMENT3    VARCHAR2,
                                  P_SEGMENT4    VARCHAR2,
                                  P_SEGMENT5    VARCHAR2)
      RETURN NUMBER
   IS
      V_CODE_COMBINATION   NUMBER;
   BEGIN
      SELECT CODE_COMBINATION_ID
        INTO V_CODE_COMBINATION
        FROM GL_CODE_COMBINATIONS
       WHERE     SEGMENT1 = P_SEGMENT1
             AND SEGMENT2 = P_SEGMENT2
             AND SEGMENT3 = P_SEGMENT3
             AND SEGMENT4 = P_SEGMENT4
             AND SEGMENT5 = P_SEGMENT5;

      RETURN V_CODE_COMBINATION;
   EXCEPTION
      WHEN OTHERS
      THEN
         FND_FILE.PUT_LINE (
            FND_FILE.LOG,
               'ERROR IN CHK_CODE_COMBINATION BLOCK : '
            || SQLCODE
            || ' - '
            || SQLERRM);
         RETURN 0;
   END CHK_CODE_COMBINATION;
   
   
   /*************************************************************************************************
    * Program Name : CHK_TERM
    * Language     : PL/SQL     
    * Description  : CHK_TERM process to valdiate term name.
    * History      : 
    *
    * WHO              Version #   WHEN              WHAT
    * ======================================================================
    * DKUMAR           1.0         28-MAY-2025     Initial Version
    ***************************************************************************************************/

   FUNCTION CHK_TERM (P_NAME VARCHAR2)
      RETURN NUMBER
   IS
      V_TERM_ID   NUMBER;
   BEGIN
      SELECT TERM_ID
        INTO V_TERM_ID
        FROM RA_TERMS
       WHERE UPPER (NAME) = UPPER (P_NAME);

      RETURN V_TERM_ID;
   EXCEPTION
      WHEN OTHERS
      THEN
         FND_FILE.PUT_LINE (
            FND_FILE.LOG,
            'ERROR IN CHK_TERM : ' || SQLCODE || ' - ' || SQLERRM);
         RETURN 0;
   END CHK_TERM;
   
   
   /*************************************************************************************************
    * Program Name : IMPORT_DATA
    * Language     : PL/SQL     
    * Description  : IMPORT_DATA process to import validate record using api.
    * History      : 
    *
    * WHO                Version #   WHEN              WHAT
    * ======================================================================
    * DKUMAR           1.0           29-MAY-2025     Initial Version
    ***************************************************************************************************/

   PROCEDURE IMPORT_DATA
   IS
   
   /************************************************
    * Initialize the Local Variable and Type.
    ************************************************/
            
      L_HDR_ERR_CNT            NUMBER;
      L_LINES_ERR_CNT          NUMBER;
      l_return_status          VARCHAR2 (1);
      l_msg_count              NUMBER;
      l_msg_data               VARCHAR2 (2000);
      l_batch_source_rec       ar_invoice_api_pub.batch_source_rec_type;
      l_trx_header_tbl         ar_invoice_api_pub.trx_header_tbl_type;
      l_trx_lines_tbl          ar_invoice_api_pub.trx_line_tbl_type;
      l_trx_dist_tbl           ar_invoice_api_pub.trx_dist_tbl_type;
      l_trx_salescredits_tbl   ar_invoice_api_pub.trx_salescredits_tbl_type;
      l_cust_trx_id            NUMBER;
      l_customer_trx_id        NUMBER;
      l_cnt                    NUMBER;
      l_err_msg                VARCHAR2 (1000);
      l_inv_number             VARCHAR2 (50);
      l_line_cnt               NUMBER;
      LV_LINE_ID            NUMBER;
      LV_HDR_ID             NUMBER;
      l_org_id                 NUMBER;

    -- cursor for header
      CURSOR cur_header
      IS
         SELECT *
           FROM ar_inv_header_dk
          WHERE status = 'V';

    -- cursor for line
      CURSOR cur_line (
         P_TRX_NUMBER NUMBER)
      IS
         SELECT *
           FROM ar_inv_line_dk
          WHERE     1 = 1
                AND status = 'V'
                AND TRX_HEADER_ID = P_TRX_NUMBER;

    -- cursor for distribution
      CURSOR cur_dist (
         P_TRX_HEAD NUMBER)
      IS
         SELECT *
           FROM ar_inv_DIST_dk
          WHERE     1 = 1
                AND status = 'V'
                AND TRX_NUMBER = P_TRX_HEAD;
                
   BEGIN
      
      l_cnt := 1;

        -- initalize apps
       fnd_global.apps_initialize (1016441, 50559, 222);
       
    --Populate Table Type Values
    --header data
      FOR rec IN cur_header
      LOOP
         BEGIN
            FND_FILE.PUT_LINE (FND_FILE.LOG, RPAD ('-', 50, '-'));

            SELECT xxqgen_ar_inv_hdr_id.NEXTVAL
            INTO LV_HDR_ID
            FROM DUAL;
        
            l_batch_source_rec.batch_source_id := -1;
            l_trx_header_tbl (1).trx_header_id := LV_HDR_ID;
            l_trx_header_tbl (1).trx_date := REC.TRX_DATE;
            l_trx_header_tbl (1).trx_currency := rec.TRX_CURR_CODE;
            l_trx_header_tbl (1).cust_trx_type_id := 1;
            l_trx_header_tbl (1).bill_to_customer_id :=
               rec.bill_to_customer_id;
            l_trx_header_tbl (1).term_id := rec.term;
            l_trx_header_tbl (1).finance_charges := 'N'; --rec.finance_charges;
            l_trx_header_tbl (1).status_trx := 'OP'; --rec.status_trx;
            l_trx_header_tbl (1).printing_option := 'NOT'; --rec.printing_option;

            l_cnt := l_cnt + 1;

            -- printing data
            fnd_file.put_line (
               fnd_file.LOG,
               'header_id : ' || l_trx_header_tbl (1).trx_header_id);
            fnd_file.put_line (
               fnd_file.LOG,
               'TRX_DATE : ' || l_trx_header_tbl (1).trx_date);
            fnd_file.put_line (
               fnd_file.LOG,
               'CURRENCY CODE : ' || l_trx_header_tbl (1).trx_currency);
            fnd_file.put_line (
               fnd_file.LOG,
               'CUST TYPE ID : ' || l_trx_header_tbl (1).cust_trx_type_id);
            fnd_file.put_line (
               fnd_file.LOG,
               'BILL TO CUST ID : '
               || l_trx_header_tbl (1).bill_to_customer_id);
            fnd_file.put_line (fnd_file.LOG,
                               'TERM ID : ' || l_trx_header_tbl (1).term_id);
            fnd_file.put_line (
               fnd_file.LOG,
               'FINANCE : ' || l_trx_header_tbl (1).finance_charges);
            fnd_file.put_line (
               fnd_file.LOG,
               'STATUS : ' || l_trx_header_tbl (1).status_trx);

            --lines data
            l_line_cnt := 1;

            FOR rec_lines IN cur_line (REC.TRX_NUMBER)
            LOOP
               BEGIN
               
               -- STORE SEQUENCE VALUE OF TRX_LINE_ID
                  SELECT xxqgen_ar_inv_line_id.NEXTVAL
                  INTO LV_LINE_ID
                  FROM DUAL;
               
                  l_trx_lines_tbl (l_line_cnt).trx_header_id := LV_HDR_ID;
                  l_trx_lines_tbl (l_line_cnt).trx_line_id := LV_LINE_ID;
                  l_trx_lines_tbl (l_line_cnt).line_number :=
                     rec_lines.line_number;
                  l_trx_lines_tbl (l_line_cnt).inventory_item_id :=
                     REC_LINES.INVENTORY_ITEM_ID;
                  l_trx_lines_tbl (l_line_cnt).description :=
                     rec_lines.description;
                  l_trx_lines_tbl (l_line_cnt).quantity_invoiced :=
                     rec_lines.quantity_invoiced;
                  l_trx_lines_tbl (l_line_cnt).unit_selling_price :=
                     rec_lines.UNIT_STANDARD_PRICE;
                  l_trx_lines_tbl (l_line_cnt).uom_code := NULL;
                  l_trx_lines_tbl (l_line_cnt).line_type := 'LINE';


                -- dis
                  --                     for rec_dist in cur_dist
                  --                     loop
                  --                     begin
                  --                    l_trx_dist_tbl (l_line_cnt).trx_header_id :=
                  --                     xxqgen_ar_inv_hdr_id.CURRVAL;
                  --                  l_trx_dist_tbl (l_line_cnt).trx_line_id :=
                  --                     xxqgen_ar_inv_line_id.currval;
                  --                     l_trx_dist_tbl(l_line_cnt).CODE_COMBINATION_ID := rec_dist.CODE_COMBINATION_ID;
                  --                    exception
                  --                        when others then
                  --                            fnd_file.put_line()
                  --                    end;
                  
                  
                  -- printing line details
                  FND_FILE.PUT_LINE(FND_fILE.LOG, 'HEADER_ID, LINE_ID, LINE_NUMBER, INVENTORY_ITEM_ID, DESC, QUANTITY_INV, SELLING PRICE, UOM, LINE_TYPE' );
                  fnd_file.put_line (
                     fnd_file.LOG, l_trx_lines_tbl (l_line_cnt).trx_header_id
                     || ', '
                     || l_trx_lines_tbl (l_line_cnt).trx_line_id
                     || ', '
                     || l_trx_lines_tbl (l_line_cnt).line_number
                     || ', '
                     || l_trx_lines_tbl (l_line_cnt).inventory_item_id
                     || ', '
                     || l_trx_lines_tbl (l_line_cnt).description
                     || ', '
                     || l_trx_lines_tbl (l_line_cnt).quantity_invoiced
                     || ', '
                     || l_trx_lines_tbl (l_line_cnt).unit_selling_price
                     || ', '
                     || l_trx_lines_tbl (l_line_cnt).uom_code
                     || ', '
                     || l_trx_lines_tbl (l_line_cnt).line_type);

                  l_line_cnt := l_line_cnt + 1;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     FND_FILE.PUT_LINE (
                        FND_FILE.LOG,
                           'ERROR IN CUR_LINE LOOP : '
                        || SQLCODE
                        || ' - '
                        || SQLERRM);
               END;
            END LOOP;



            --Invoking Public API

            --Here we call the API to create Invoice with the stored values
            --
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'STARTING API ');
            
            AR_INVOICE_API_PUB.CREATE_SINGLE_invoice (
                                    p_api_version            => 1.0,
                                    p_init_msg_list          => NULL,
                                    p_commit                 => NULL,
                                    p_batch_source_rec       => l_batch_source_rec,
                                    p_trx_header_tbl         => l_trx_header_tbl,
                                    p_trx_lines_tbl          => l_trx_lines_tbl,
                                    p_trx_dist_tbl           => l_trx_dist_tbl,
                                    p_trx_salescredits_tbl   => l_trx_salescredits_tbl,
                                    x_customer_trx_id        => l_customer_trx_id,
                                    x_return_status          => l_return_status,
                                    x_msg_count              => l_msg_count,
                                    x_msg_data               => l_msg_data);
                                    
            COMMIT;
            
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'ENDING API');
            
            
            -- printing out variables
            fnd_file.put_line (fnd_file.LOG,
                               'Customer TRX ID : ' || l_customer_trx_id);
            fnd_file.put_line (fnd_file.LOG,
                               'Return status : ' || l_return_status);
            fnd_File.put_line (fnd_file.LOG,
                               'Message Count : ' || l_msg_count);
            fnd_file.put_line (fnd_file.LOG, 'Message Data : ' || l_msg_data);
            
            
            if upper(l_return_status) = 'S' then
                update ar_inv_header_dk
                set status = 'P',
                    ATTRIBUTE1 = l_customer_trx_id
                where trx_number = rec.trx_number;
                
                update ar_inv_line_dk
                set status = 'P',
                    ATTRIBUTE1 = l_customer_trx_id
                where trx_header_id = rec.trx_number;
                
                update ar_inv_dist_dk
                set status = 'P',
                    ATTRIBUTE1 = l_customer_trx_id
                where trx_number = rec.trx_number;
            else 
                update ar_inv_header_dk
                set status = 'E',
                     error_message = l_msg_data
                where trx_number = rec.trx_number;
                
                update ar_inv_line_dk
                set status = 'E',
                     error_message = l_msg_data
                where trx_header_id = rec.trx_number;
                
                update ar_inv_dist_dk
                set status = 'E',
                      error_message = l_msg_data
                where trx_number = rec.trx_number;
            end if;

            SELECT COUNT (*) INTO l_cnt FROM ar_trx_errors_gt;

            IF l_cnt = 0
            THEN
               BEGIN
                  SELECT trx_number
                    INTO l_inv_number
                    FROM ra_customer_trx_all
                   WHERE customer_trx_id = l_customer_trx_id;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     fnd_file.put_line (
                        fnd_file.LOG,
                           'error in if where l_inv_number get : '
                        || SQLCODE
                        || ' - '
                        || SQLERRM);
               END;
            END IF;


            fnd_file.put_line (
               fnd_file.LOG,
                  'Customer Trx Number '
               || l_inv_number
               || 'Customer TRX ID : '
               || l_customer_trx_id);

            IF l_return_status = fnd_api.g_ret_sts_error
               OR l_return_status = fnd_api.g_ret_sts_unexp_error
            THEN
               fnd_file.put_line (fnd_file.LOG,
                                  ':' || l_return_status || ':' || SQLERRM);
            ELSE
               fnd_file.put_line (fnd_file.LOG,
                                  '' || l_return_status || ':' || SQLERRM);

               IF (ar_invoice_api_pub.g_api_outputs.batch_id IS NOT NULL)
               THEN
                  fnd_file.put_line (fnd_file.LOG,
                                     'Invoice(s) suceessfully created!');
                  fnd_file.put_line (
                     fnd_file.LOG,
                     'Batch ID: '
                     || ar_invoice_api_pub.g_api_outputs.batch_id);
                  fnd_file.put_line (fnd_file.LOG,
                                     'customer_trx_id: ' || l_cust_trx_id);
               ELSE
                  fnd_file.put_line (fnd_file.LOG, '' || SQLERRM);
               END IF;

              
            END IF;

            --Clear the data fom record
            l_trx_lines_tbl.delete;

            FND_FILE.PUT_LINE (FND_FILE.LOG, RPAD ('-', 50, '-'));
         EXCEPTION
            WHEN OTHERS
            THEN
               FND_FILE.PUT_LINE (
                  FND_FILE.LOG,
                  'ERROR IN CUR_HEAD LOOP : ' || SQLCODE || ' - ' || SQLERRM);
         END;
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         FND_fILE.PUT_LINE (
            FND_FILE.LOG,
            'ERROR IN IMPORT DATA : ' || SQLCODE || ' - ' || SQLERRM);
   END IMPORT_DATA;


    /*************************************************************************************************
    * Program Name : VALIDATE
    * Language     : PL/SQL     
    * Description  : VALIDATE process to validate record.
    * History      : 
    *
    * WHO                Version #   WHEN              WHAT
    * ======================================================================
    * DKUMAR           1.0           28-MAY-2025     Initial Version
    ***************************************************************************************************/

   PROCEDURE VALIDATE
   IS
      CURSOR CUR_HEADER
      IS
         SELECT *
           FROM AR_INV_HEADER_DK
          WHERE 1 = 1 AND STATUS = 'N';

      CURSOR CUR_LINE
      IS
         SELECT *
           FROM AR_INV_LINE_DK
          WHERE 1 = 1 AND STATUS = 'N';

      CURSOR CUR_DIST
      IS
         SELECT *
           FROM AR_INV_DIST_DK
          WHERE 1 = 1 AND STATUS = 'N';
   BEGIN

      FOR REC_HEAD IN CUR_HEADER
      LOOP
         BEGIN


            --  SET STATUS V UNTIL NO ERROR FOUND
            REC_HEAD.STATUS := 'V';

            -- BILL TO CUSTOMER ID
            REC_HEAD.BILL_TO_CUSTOMER_ID :=
               CHK_CUSTOMER (REC_HEAD.BILL_TO_CUSTOMER_NAME);
            IF (REC_HEAD.BILL_TO_CUSTOMER_ID) = 0
            THEN
               REC_HEAD.STATUS := 'E';
               REC_HEAD.ERROR_MESSAGE := 'CUSTOMER NAME-ADDRESS, ';
            END IF;
            
            -- CUST_TYPE
            REC_HEAD.CUST_TRX_TYPE_ID := CHK_TYPE(REC_HEAD.CUST_TYPE);
            IF REC_HEAD.CUST_TRX_TYPE_ID = 0 
            THEN
                REC_HEAD.STATUS := 'E';
                REC_HEAD.ERROR_MESSAGE := 'CUST_TYPE, ';
            END IF;

            -- SHIP TO CUSTOMER ID
            REC_HEAD.SHIP_TO_CUSTOMER_ID :=
               CHK_CUSTOMER (REC_HEAD.SHIP_TO_CUSTOMER_NAME);
            IF (REC_HEAD.SHIP_TO_CUSTOMER_ID) = 0
            THEN
               REC_HEAD.STATUS := 'E';
               REC_HEAD.ERROR_MESSAGE := 'CUSTOMER NAME-ADDRESS, ';
            END IF;

            -- CUST TYPE
            REC_HEAD.CUST_TRX_TYPE_ID := CHK_ORDER_TYPE (REC_HEAD.ORDER_TYPE);
            IF REC_HEAD.CUST_TRX_TYPE_ID = 0
            THEN
               REC_HEAD.STATUS := 'E';
               REC_HEAD.ERROR_MESSAGE := 'ORDER_TYPE, ';
            END IF;

            -- PRIMARY SALESREP
            CHK_SALESPER_NAME (REC_HEAD.PRIMARY_SALESREP_NAME,
                               REC_HEAD.PRIMARY_SALESREP_ID,
                               REC_HEAD.PRIMARY_SALESREP_NUM);
            IF REC_HEAD.PRIMARY_SALESREP_ID = 0
            THEN
               REC_HEAD.STATUS := 'E';
               REC_HEAD.ERROR_MESSAGE := 'SALESREP_NAME, ';
            END IF;

            -- LEGAL ENTITY
            REC_HEAD.LEGAL_ENTITY_ID :=
               CHK_LEGAL_ENTITY (REC_HEAD.TRX_LEGAL_ENTITY);
            IF REC_HEAD.LEGAL_ENTITY_ID = 0
            THEN
               REC_HEAD.STATUS := 'E';
               REC_HEAD.ERROR_MESSAGE := 'LEGAL_ENTITY, ';
            END IF;


            -- TERM ID
            REC_HEAD.TERM := CHK_TERM (REC_HEAD.TERM_ID);

            IF REC_HEAD.TERM = 0
            THEN
               REC_HEAD.STATUS := 'E';
               REC_HEAD.ERROR_MESSAGE := 'TERM ID ';
            END IF;

--            ERROR_MESSAGE
            IF (REC_HEAD.ERROR_MESSAGE IS NOT NULL)
            THEN
               REC_HEAD.ERROR_MESSAGE :=
                  REC_HEAD.ERROR_MESSAGE || ' IS INVALID';
            END IF;


            -- UDPATE ALL DATA
            UPDATE AR_INV_HEADER_DK
               SET ORDER_TYPE_ID = REC_HEAD.ORDER_TYPE_ID,
                   BILL_TO_CUSTOMER_ID = REC_HEAD.BILL_TO_CUSTOMER_ID,
                   BILL_TO_ACCOUNT_NUMBER = REC_HEAD.BILL_TO_ACCOUNT_NUMBER,
                   BILL_TO_ADDRESS_ID = REC_HEAD.BILL_TO_ADDRESS_ID,
                   BILL_TO_CONTACT_ID = REC_HEAD.BILL_TO_CONTACT_ID,
                   SHIP_TO_ACCOUNT_NUMBER = REC_HEAD.SHIP_TO_ACCOUNT_NUMBER,
                   SHIP_TO_ADDRESS_ID = REC_HEAD.SHIP_TO_ADDRESS_ID,
                   SHIP_TO_CUSTOMER_ID = REC_HEAD.SHIP_TO_CUSTOMER_ID,
                   SHIP_TO_CONTACT_ID = REC_HEAD.SHIP_TO_CONTACT_ID,
                   PRIMARY_SALESREP_ID = REC_HEAD.PRIMARY_SALESREP_ID,
                   PRIMARY_SALESREP_NUM = REC_HEAD.PRIMARY_SALESREP_NUM,
                   LEGAL_ENTITY_ID = REC_HEAD.LEGAL_ENTITY_ID,
                   TERM = REC_HEAD.TERM,
                   STATUS = REC_HEAD.STATUS,
                   ERROR_MESSAGE = REC_HEAD.ERROR_MESSAGE
             WHERE RECORD_ID = REC_HEAD.RECORD_ID;
         EXCEPTION
            WHEN OTHERS
            THEN
               FND_FILE.PUT_LINE (
                  FND_FILE.LOG,
                  'ERROR IN CUR_HEAD : ' || SQLCODE || ' - ' || SQLERRM);
         END;
      END LOOP;

      FOR REC_LINE IN CUR_LINE
      LOOP
         BEGIN
            REC_LINE.STATUS := 'V';

            -- ITEM NAME
            CHK_ITEM (REC_LINE.ITEM,
                      GN_ORG_ID,
                      REC_LINE.DESCRIPTION,
                      REC_LINE.INVENTORY_ITEM_ID);

            IF REC_LINE.INVENTORY_ITEM_ID = 0
            THEN
               REC_LINE.STATUS := 'E';
               REC_LINE.ERROR_MESSAGE := 'ITEM, ';
            END IF;

            --            FND_FILE.PUT_LINE (
            --               FND_fILE.LOG,
            --               'ENTER IN REC_LINE : ' || SQLCODE || ' - ' || SQLERRM);

            UPDATE AR_INV_LINE_DK
               SET INVENTORY_ITEM_ID = REC_LINE.INVENTORY_ITEM_ID,
                   STATUS = REC_LINE.STATUS,
                   ERROR_MESSAGE = REC_LINE.ERROR_MESSAGE
             WHERE RECORD_ID = REC_LINE.RECORD_ID;
         EXCEPTION
            WHEN OTHERS
            THEN
               FND_FILE.PUT_LINE (
                  FND_FILE.LOG,
                  'ERROR IN CUR_LINE : ' || SQLCODE || ' - ' || SQLERRM);
         END;
      END LOOP;


      FOR REC_DIST IN CUR_DIST
      LOOP
         REC_DIST.STATUS := 'V';

         IF REC_DIST.CODE_COMBINATION_ID = 0
         THEN
            REC_DIST.STATUS := 'E';
            REC_DIST.ERROR_MESSAGE := 'SEGMENT MISMATCH ERROR';
         END IF;

         UPDATE AR_INV_DIST_DK
            SET CODE_COMBINATION_ID = REC_DIST.CODE_COMBINATION_ID,
                STATUS = REC_DIST.STATUS,
                ERROR_MESSAGE = REC_DIST.ERROR_MESSAGE
          WHERE RECORD_ID = REC_DIST.RECORD_ID;
      END LOOP;
      
      -- EXTRA VALIDATION
      -- CHECK LINE IF LINE: 0 THEN RECORD SEND TO ERROR
      UPDATE AR_INV_HEADER_DK
      SET STATUS = 'E',
            ERROR_MESSAGE = 'NO LINE '
      WHERE TRX_NUMBER = (SELECT TRX_NUMBER
                                        FROM AR_INV_HEADER_DK
                                        WHERE TRX_NUMBER NOT IN (SELECT TRX_HEADER_ID FROM AR_INV_LINE_DK
                                                                                      WHERE STATUS = 'V'));
                                        
        -- CHECK IF ANY LINE IS IN ERROR THEN ALL LINE IS IN ERROR
        UPDATE AR_INV_LINE_DK
        SET STATUS = 'E',
              ERROR_MESSAGE = 'ERROR IN LINE'
        WHERE TRX_HEADER_ID IN  (SELECT TRX_HEADER_ID FROM AR_INV_LINE_DK WHERE STATUS = 'E');
        
        -- CHECK IF 
        UPDATE AR_INV_HEADER_DK
        SET STATUS = 'E',
              ERROR_MESSAGE = 'NO LINE'
        WHERE 1=1
            AND STATUS = 'V'
            AND TRX_NUMBER NOT IN (SELECT TRX_HEADER_ID FROM AR_INV_LINE_DK);
      COMMIT;
   EXCEPTION
      -- EXCEPTION HANDLING FOR VALIDATION PROCEDURE BLOCK
      WHEN OTHERS
      THEN
         FND_FILE.PUT_LINE (
            FND_FILE.LOG,
            'ERROR IN VALIDATE : ' || SQLCODE || ' - ' || SQLERRM);
   END VALIDATE;


    /*************************************************************************************************
    * Program Name : VALIDATE_REQUIRED
    * Language     : PL/SQL     
    * Description  : VALIDATE_REQUIRED process to validate and remove all record having null values.
    * History      : 
    *
    * WHO                Version #   WHEN              WHAT
    * ======================================================================
    * DKUMAR           1.0           28-MAY-2025     Initial Version
    ***************************************************************************************************/

   PROCEDURE VALIDATE_REQUIRED
   IS
   BEGIN
      -- REQUIRED FIELD FOR HEADER
      -- SOURCE    (DOUGHT)
      --        UPDATE AR_INV_HEADER_DK
      --        SET STATUS = 'E'
      --        WHERE
      
      -- DATE
      UPDATE AR_INV_HEADER_DK
         SET STATUS = 'E', ERROR_MESSAGE = ERROR_MESSAGE || ' DATE IS NULL'
       WHERE TRX_DATE IS NULL AND REQUEST_ID = GN_REQUEST_ID and status = 'N';

      -- GL_DATE
      UPDATE AR_INV_HEADER_DK
         SET STATUS = 'E',
             ERROR_MESSAGE = ERROR_MESSAGE || ' GL DATE IS NULL'
       WHERE GL_DATE IS NULL AND REQUEST_ID = GN_REQUEST_ID and status = 'N';

      -- CLASS
      UPDATE AR_INV_HEADER_DK
         SET STATUS = 'E', ERROR_MESSAGE = ERROR_MESSAGE || ' CLASS IS NULL'
       WHERE CUST_TYPE IS NULL AND REQUEST_ID = GN_REQUEST_ID and status = 'N';

      -- TYPE
      UPDATE AR_INV_HEADER_DK
         SET STATUS = 'E', ERROR_MESSAGE = ERROR_MESSAGE || ' TYPE IS NULL'
       WHERE ORDER_TYPE IS NULL AND REQUEST_ID = GN_REQUEST_ID and status = 'N';

      -- CURRENCY
      UPDATE AR_INV_HEADER_DK
         SET STATUS = 'E',
             ERROR_MESSAGE = ERROR_MESSAGE || ' CURRENCY IS NULL'
       WHERE TRX_CURR_CODE IS NULL AND REQUEST_ID = GN_REQUEST_ID and status = 'N';

      -- LEGAL_ENTITY
      UPDATE AR_INV_HEADER_DK
         SET STATUS = 'E',
             ERROR_MESSAGE = ERROR_MESSAGE || ' LEGAL_ENTITY IS NULL'
       WHERE TRX_LEGAL_ENTITY IS NULL AND REQUEST_ID = GN_REQUEST_ID and status = 'N';

      -- BILL_TO
      UPDATE AR_INV_HEADER_DK
         SET STATUS = 'E',
             ERROR_MESSAGE = ERROR_MESSAGE || ' BILL_TO_CUSTOMER_NAME IS NULL'
       WHERE bill_to_customer_name IS NULL AND REQUEST_ID = GN_REQUEST_ID and status = 'N';

      UPDATE AR_INV_HEADER_DK
         SET STATUS = 'E',
             ERROR_MESSAGE = ERROR_MESSAGE || ' BILL_TO_CONTACT IS NULL'
       WHERE bill_to_contact IS NULL AND REQUEST_ID = GN_REQUEST_ID and status = 'N';

      UPDATE AR_INV_HEADER_DK
         SET STATUS = 'E',
             ERROR_MESSAGE = ERROR_MESSAGE || ' BILL_TO_ADDRESS IS NULL'
       WHERE bill_to_address1 IS NULL AND REQUEST_ID = GN_REQUEST_ID and status = 'N';

      -- PAYMENT_TERMS
      UPDATE AR_INV_HEADER_DK
         SET STATUS = 'E',
             ERROR_MESSAGE = ERROR_MESSAGE || ' TERM_ID IS NULL'
       WHERE TERM_ID IS NULL AND REQUEST_ID = GN_REQUEST_ID and status = 'N';

      -- REMITE_TO (ADDRESS)
      --            UPDATE AR_INV_HEADER_DK
      --            SET STATUS = 'E',
      --                  ERROR_MESSAGE = ERROR_MESSAGE || ' REMIT_TO_ADDRESS IS NULL'
      --            WHERE REMIT_TO_ADDRESS IS NULL;

      -- MEMO
      --            UPDATE AR_INV_HEADER_DK
      --            SET STATUS = 'E',
      --                  ERROR_MESSAGE = ERROR_MESSAGE || ' MEMO IS NULL'
      --            WHERE MEMO IS NULL;

      -- REQUIED FIELD FOR LINES
      -- LINE_NUM
      UPDATE AR_INV_LINE_DK
         SET STATUS = 'E',
             ERROR_MESSAGE = ERROR_MESSAGE || ' LINE_NUM IS NULL'
       WHERE LINE_NUMBER IS NULL AND REQUEST_ID = GN_REQUEST_ID and status = 'N';

      -- DESCRIPTION
      UPDATE AR_INV_LINE_DK
         SET STATUS = 'E', ERROR_MESSAGE = ERROR_MESSAGE || ' DATE IS NULL'
       WHERE description IS NULL AND REQUEST_ID = GN_REQUEST_ID and status = 'N';

      -- ITEM
      UPDATE AR_INV_LINE_DK
         SET STATUS = 'E', ERROR_MESSAGE = ERROR_MESSAGE || ' DATE IS NULL'
       WHERE item IS NULL AND REQUEST_ID = GN_REQUEST_ID and status = 'N';

      -- QUANTITY
      UPDATE AR_INV_LINE_DK
         SET STATUS = 'E', ERROR_MESSAGE = ERROR_MESSAGE || ' DATE IS NULL'
       WHERE quantity_ordered IS NULL AND REQUEST_ID = GN_REQUEST_ID and status = 'N';

      -- UNIT_PRICE
      UPDATE AR_INV_LINE_DK
         SET STATUS = 'E', ERROR_MESSAGE = ERROR_MESSAGE || ' DATE IS NULL'
       WHERE unit_standard_price IS NULL AND REQUEST_ID = GN_REQUEST_ID and status = 'N';

      -- AMOUNT   (DEPENDS ON SOURCE)
      --            UPDATE AR_INV_LINE_DK
      --            SET STATUS = 'E',
      --                  ERROR_MESSAGE = ERROR_MESSAGE || ' DATE IS NULL'
      --            WHERE LINE_NUMBER IS NULL;

      -- REQUIRED FIELD IN SALES CREDITS
      -- SALESPERSON NAME
      UPDATE AR_INV_HEADER_DK
         SET STATUS = 'E', ERROR_MESSAGE = ERROR_MESSAGE || ' DATE IS NULL'
       WHERE primary_salesrep_name IS NULL AND REQUEST_ID = GN_REQUEST_ID and status = 'N';
       
       -- when there's no line FOR HEADER
      UPDATE AR_INV_HEADER_DK hdr
        SET STATUS = 'E',
            ERROR_MESSAGE = ERROR_MESSAGE || ' THERE IS NO LINE'
        WHERE NOT EXISTS (
            SELECT 1
            FROM AR_INV_LINE_DK line
            WHERE line.TRX_HEADER_ID = hdr.TRX_NUMBER
        );
        
        -- when there's no header for line
        update ar_inv_line_dk LINE
        set status = 'E',
             ERROR_MESSAGE = ERROR_MESSAGE || 'THERE IS NOT HEADER FOR THIS LINE'
        WHERE NOT EXISTS (
            SELECT 1
            FROM AR_INV_HEADER_DK HDR
            WHERE HDR.TRX_NUMBER = LINE.TRX_HEADER_ID
        );
        
        -- trx_number
      update ar_inv_header_dk
      set status = 'Z', error_message = error_message || 'null record!'
      where trx_number is null and trx_currency is null and bill_to_customer_name is null and ship_to_customer_name is null and term_id is null and primary_salesrep_name is null;  
      
       commit;

   EXCEPTION
      -- PROCEDURE BLOCK EXCEPTION HANDLING
      WHEN OTHERS
      THEN
         FND_FILE.PUT_LINE (
            FND_FILE.LOG,
            'ERROR IN VALIDATE REQUIRED : ' || SQLCODE || ' - ' || SQLERRM);
   END VALIDATE_REQUIRED;
   
   
   /*************************************************************************************************
    * Program Name : MAIN
    * Language     : PL/SQL     
    * Description  : MAIN process to run all procedure.
    * History      : 
    *
    * WHO                Version #   WHEN              WHAT
    * ======================================================================
    * DKUMAR           1.0           28-MAY-2025     Initial Version
    ***************************************************************************************************/

   PROCEDURE MAIN (ERRBUF OUT VARCHAR2, RETCODE OUT NUMBER)
   IS
   BEGIN
   
--       fnd_global.apps_initialize (1016441, 50559, 222);
   
      fnd_file.put_line (fnd_File.LOG, 'validation required');
      VALIDATE_REQUIRED;
      fnd_file.put_line (fnd_File.LOG, 'validation ');
      VALIDATE;
      fnd_file.put_line (fnd_File.LOG, 'import data');
      IMPORT_DATA;
      fnd_file.put_line (fnd_File.LOG, 'program done');
   EXCEPTION
      WHEN OTHERS
      THEN
         fnd_file.put_line (
            fnd_file.LOG,
            'error in main : ' || SQLCODE || ' - ' || SQLERRM);
   END MAIN;
END XXQGEN_AR_INF_CORRECTION;

SELECT *
FROM AR_INV_LINE_DK