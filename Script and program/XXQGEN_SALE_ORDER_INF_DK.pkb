/*

    Item Validation: The item that is being used on the Sales order need to be validated. The item has to exist in the Item Master as well should be assigned to the inventory org from where the Item is being shipped from.
SELECT *
  FROM mtl_system_items_b
 WHERE segment1 = 'TEST_ITEM_1234';
Customer Validation: The Customer for which the order is being created for, should exist in the system already.
SELECT *
  FROM hz_cust_accounts
 WHERE account_number = '12345678'; -- p_customer_number
Get BILL_TO Validation: For the Customer that exists, check to see if a valid BILL_TO Site exists.
  SELECT hcsua.org_id, hcsua.site_use_id, hps.party_site_id
            FROM hz_cust_accounts        hca
                ,hz_cust_acct_sites_all  hcasa
                ,hz_cust_site_uses_all   hcsua
                ,hz_party_sites          hps
            WHERE     hca.cust_account_id = hcasa.cust_account_id
                  AND hcasa.cust_acct_site_id = hcsua.cust_acct_site_id
                  AND hcasa.status = 'A'
                  AND hcsua.status = 'A'
                  AND hcasa.org_id = hcsua.org_id
                  AND hcsua.site_use_code = 'BILL_TO'
                  AND hps.identifying_address_flag = 'Y'
                  AND hps.party_site_id = hcasa.party_site_id
                  AND hca.cust_account_id = '&Cust_account_id'
                  AND hcsua.org_id = '&Operating_unit_id'
                  AND ROWNUM < 2;
GL_Period Validation: Validate whether the Order data has Open GL period or not.
SELECT gps.period_name,
       gps.set_of_books_id,
       gps.end_date,
       gps.closing_status
  FROM gl_periods          gp,
       gl_period_statuses  gps,
       gl_sets_of_books    gsob,
       hr_operating_units  hou
 WHERE     gp.period_name = gps.period_name
       AND gp.period_set_name = gsob.period_set_name
       AND gsob.set_of_books_id = hou.set_of_books_id
       AND gps.application_id = 222
       AND gps.set_of_books_id = gsob.set_of_books_id
       AND '&Order Date' BETWEEN gp.start_date AND gp.end_date
       AND hou.organization_id = '&Organization_id';
UOM Code Validation: Validate Unit of Measure validation.
SELECT uom_code FROM mtl_units_of_measure_vl;
Operating Unit Validation: Validate the Operating Unit for which the order is being created in.
SELECT organization_id
  FROM hr_operating_units
 WHERE name = ''
Get Price List: Derive the Price List.
SELECT list_header_id, name
  FROM qp_list_headers qlh
 WHERE     qlh.orig_org_id = '&Organization_id'
       AND currency_code = '&Currency_code'
       AND TRUNC (SYSDATE) BETWEEN NVL (TRUNC (qlh.start_date_active),
                                        TRUNC (SYSDATE) - 1)
                               AND NVL (TRUNC (qlh.end_date_active),
                                        TRUNC (SYSDATE) + 1)
       AND qlh.active_flag = 'Y';
Derive Tax Rate Code: Derive the tax rate code based on the tax code passed by the source system.
SELECT zrab.tax_regime_code,
       zrgb.tax_regime_id,
       zrab.tax,
       zrab.tax_status_code,
       zrab.tax_rate_code,
       zrab.tax_rate_id
  FROM zx_rates_b zrab, zx_regimes_b zrgb
 WHERE     zrab.tax_regime_code = zrgb.tax_regime_code
       AND TRUNC (SYSDATE) BETWEEN NVL (zrab.effective_from,
                                        TRUNC (SYSDATE) - 1)
                               AND NVL (zrab.effective_to,
                                        TRUNC (SYSDATE) + 1)
       AND zrab.active_flag = 'Y'                     -- Added for Defect#7614
       AND zrab.tax_rate_code = '&tax_rate_code';
Inserting Data into Interface Table: Upon Validation, Data is inserted into the following Order Interface Tables:
Headers Interface: OE_HEADERS_IFACE_ALL.
This is the Headers Interface table that captures all the data that goes into the Order Header data (later into OE_ORDER_HEADERS_ALL table). Some of the important columns to be populated are: Operation_code, order_number, orig_sys_document_ref, org_id, Ordered_date, order_type_id, sold_to_org_id, ship_from_org_id, invoice_to_org_id, booked_flag, change_sequence etc.
Lines Interface: OE_LINES_IFACE_ALL
This is the Lines Interface table that captures all the data that goes onto the Line Level on the Sales order (later onto the OE_ORDER_LINES_ALL table). Some of the important columns are: Org_id, orig_sys_document_ref, inventory_item_id (item), ordered_quantity, order_quantity_uom, unit_list_price, unit_selling_price, fulfillment_set_id etc.
Payments Interface: OE_PAYMENTS_IFACE_ALL
The Payments Interface table captures data that is shown later on the payments screen on the order. This table has the data that is later populated into OE_PAYMENTS table. Some important columns are: Payment_number, orig_sys_document_ref, orig_sys_payment_ref, payment_type_code, payment_amount, check_number, credit_card_number, credit_card_expiration_date etc.
Actions Interface: OE_ACTIONS_IFACE_ALL
The Actions interface table is used to load data that will perform any Action to be taken on the order once the order is created. Some uses include Cancelling a line, Applying Hold etc.. Some important columns are: Org_id, Hold_id, Hold_type_code, Operation_Code.
Adjustment Interface: OE_PRICE_ADJS_IFACE_ALL
The Adjustment interface table holds the data that later goes to the OE_Price_Adjustments table. This table is used to store price adjustments that have been applied to an order or a line.

*/

CREATE OR REPLACE PACKAGE BODY XXQGEN_SALE_ORDER_INF_DK
AS

    PROCEDURE VALIDATION_REQUIRED
    IS
    
        cursor cur_head
        is
        select *
        from oe_order_header_dk
        where request_id = gc_request_id;
        
        
        cursor cur_line
        is
        select *
        from oe_order_line_dk
        where request_id = gc_request_id;
    
    BEGIN
        
        /*
        SELECT ORIG_SYS_DOCUMENT_REF,ORDER_SOURCE,CONVERSION_RATE,ORG_ID,ORDER_TYPE_ID,PRICE_LIST,SOLD_FROM_ORG_ID,SOLD_TO_ORG_ID,SHIP_TO_ORG_ID,
                    SHIP_FROM_ORG_ID,CUSTOMER_NAME,INVOICE_TO_ORG_ID,OPERATION_CODE
        FROM OE_HEADERS_IFACE_ALL
        where orig_sys_document_ref = '%%';
       */
       
--        ORG_ID  
           UPDATE OE_ORDER_HEADER_DK
           SET STATUS = 'E',
                  ERROR_MESSAGE = ERROR_MESSAGE || 'ORG_ID IS NULL'
            WHERE ORG_ID IS NULL;
            
--         ORDER TYPE
            UPDATE OE_ORDER_HEADER_DK
            SET STATUS = 'E',
                   ERROR_MESSAGE = ERROR_MESSAGE || ' ORDER IS NULL'
            WHERE ORDER_TYPE IS NULL;
            
--          SALESREP
            UPDATE 
       
--        ORDER_SOURCE_ID

--        ORIG_SYS_DOCUMENT_REF
--        ORIG_SYS_LINE_REF,ORIG_SYS_SHIPMENT_REF,

--        INVENTORY_ITEM_ID

--        LINK_TO_LINE_REF

--        REQUEST_DATE,
                    DELIVERY_LEAD_TIME,DELIVERY_ID,ORDERED_QUANTITY,ORDER_QUANTITY_UOM,SHIPPING_QUANTITY,PRICING_QUANTITY,PRICING_QUANTITY_UOM,
                    SOLD_FROM_ORG_ID,SOLD_TO_ORG_ID,INVOICE_TO_ORG_ID,SHIP_TO_ORG_ID,PRICE_LIST_ID,PAYMENT_TERM_ID
        FROM OE_LINES_IFACE_ALL
        WHERE orig_sys_document_ref = '%%';
      
        
        UPDATE OE_ORDER_LINE_DK
        SET STATUS = 'E',
               ERROR_MESSAGE = ERROR_MESSAGE || ' ORG_ID IS NULL'
        WHERE ORG_ID IS NULL;
    
        FND_FILE.PUT_LINE(FND_FILE.LOG, 'VALIDATION_REQUIRED WORKING');
    EXCEPTION
        WHEN OTHERS THEN
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN VALIDATION REQUIRED BLOCK : ' || SQLCODE || ' - ' || SQLERRM );
    END VALIDATION_REQUIRED;

    PROCEDURE INSERT_DATA
    IS
    BEGIN
        FND_FILE.PUT_LINE(FND_FILE.LOG, 'WORKING');
    EXCEPTION
        WHEN OTHERS THEN
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN INSERT DATA : ' || SQLCODE || ' - ' || SQLERRM );
    END INSERT_DATA;
    
    
    PROCEDURE MAIN (errbuf   out varchar2, retcode  out number)
    IS
    BEGIN
        INSERT_DATA;
    EXCEPTION
        WHEN OTHERS THEN
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN MAIN ' || SQLERRM || ' - ' || SQLCODE );
    END MAIN;
END XXQGEN_SALE_ORDER_INF_DK;