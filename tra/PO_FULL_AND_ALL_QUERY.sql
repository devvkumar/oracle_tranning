-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FULL QUERY OF P2P
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT PRHA.*,
            RSH.SHIPMENT_HEADER_ID,
            RSH.VENDOR_ID,
--            APS.VENDOR_NAME,
            RSH.VENDOR_SITE_ID,
--            ASSA.VENDOR_SITE_CODE,
--            ASSA.ADDRESS_LINE1 || ', ' || ASSA.CITY || ', ' || ASSA.STATE || ', ' || ASSA.ZIP || ', ' || ASSA.PROVINCE || ', ' || ASSA.COUNTY ADDRESS,
            RSH.ORGANIZATION_ID,
            RSH.SHIPMENT_NUM,
            RSH.RECEIPT_NUM,
            RSH.SHIP_TO_LOCATION_ID,
            RSH.BILL_OF_LADING,
            RSH.SHIP_TO_ORG_ID,
            RSH.PACKING_SLIP,
            RSH.SHIPPED_DATE,
            RSH.FREIGHT_CARRIER_CODE,
            RSH.EMPLOYEE_ID,
            RSH.NUM_OF_CONTAINERS,
            RSH.COMMENTS,
            RSH.GROSS_WEIGHT,
            RSH.GROSS_WEIGHT_UOM_CODE,
            RSH.NET_WEIGHT,
            RSH.TAR_WEIGHT,
            RSH.CARRIER_METHOD,
            RSH.FREIGHT_TERMS,
            RSH.INVOICE_NUM,
            RSH.INVOICE_AMOUNT,
            RSL.LINE_NUM,
            RSL.SHIPMENT_LINE_ID,
            RSL.CATEGORY_ID,
            RSL.QUANTITY_SHIPPED,
            RSL.QUANTITY_RECEIVED,
            RSL.ITEM_DESCRIPTION,
            RSL.ITEM_ID,
            RSL.AMOUNT,
            RSL.AMOUNT_RECEIVED,
--            RT.TRANSACTION_TYPE,
            aia.invoice_id,
         aia.invoice_num,
         aia.invoice_currency_code,
         aia.invoice_amount,
         aia.vendor_id,
         aia.vendor_site_id,
         aia.amount_paid,
         aia.invoice_date,
         aia.source,
--         aia.standard,
         aia.description,
         aia.terms_id,
         aia.payment_status_flag,
         aia.party_id,
         aia.party_site_id,
         aila.line_number,
         aila.line_type_lookup_Code,
         aila.description,
         aila.org_id,
         aila.amount,
         aida.accounting_date,
         aida.tax_code_id,
         apsa.due_date,
         apsa.payment_status_flag,
         apsa.remit_to_supplier_name,
--         apsa.remit_supplier_id,
         apsa.remit_to_supplier_site,
         apsa.remit_to_supplier_site_id,
         aipa.invoice_id,
         aipa.invoice_payment_id,
         aipa.bank_account_num,
         aca.amount,
         aca.bank_account_name,
         aca.check_date,
         aca.check_number,
--         aca.check_currency_code,
         aca.vendor_name,
         aca.bank_account_num,
         aca.address_line1 || ', ' || aca.city || ', ' || aca.country || ', ' || aca.zip address,
         XAH.AE_HEADER_ID,
            XAH.LEDGER_ID,
            XAH.EVENT_ID,
            XAH.EVENT_TYPE_CODE,
--            XAH.CATEGORY_NAME,
            XAH.ACCOUNTING_ENTRY_TYPE_CODE,
            XAH.DESCRIPTION,
            XAH.PERIOD_NAME,
            XAL.AE_LINE_NUM,
            XAL.GL_SL_LINK_ID,
            XAL.PARTY_SITE_ID,
            XAL.CURRENCY_CODE,
            GIR.REFERENCE_1,
            GIR.REFERENCE_5,
            GIR.REFERENCE_6,
            GIR.REFERENCE_10,
            GIR.JE_BATCH_ID,
            GIR.JE_HEADER_ID,
            GIR.JE_LINE_NUM,
            GJH.JE_CATEGORY,
            GJH.JE_SOURCE,
            GJH.PERIOD_NAME,
            GJH.NAME,
            GJH.STATUS,
            GJH.RUNNING_TOTAL_DR,
            GJH.RUNNING_TOTAL_CR,
            GJH.RUNNING_TOTAL_ACCOUNTED_CR
FROM PO_REQUISITION_HEADERS_ALL PRHA,
          PO_REQUISITION_LINES_ALL PRLA,
          PO_REQ_DISTRIBUTIONS_ALL PRDA,
          PO_DISTRIBUTIONS_ALL PDA,
          PO_HEADERS_ALL PHA,
          PO_LINES_ALL PLA,
          PO_LINE_LOCATIONS_ALL PLLA,
          RCV_SHIPMENT_LINES RSL,
          RCV_SHIPMENT_HEADERS RSH,
          RCV_TRANSACTIONS RCT,
          AP_INVOICE_DISTRIBUTIONS_ALL AIDA,
          AP_INVOICES_ALL AIA,
          AP_INVOICE_LINES_ALL AILA,
          AP_PAYMENT_SCHEDULES_ALL APSA,
          AP_INVOICE_PAYMENTS_ALL AIPA,
          AP_CHECKS_ALL ACA,
          XLA_AE_HEADERS XAH,
         XLA_AE_LINES XAL,
         XLA_TRANSACTION_ENTITIES XTE,
         XLA_EVENTS XE,
         GL_IMPORT_REFERENCES GIR,
         GL_JE_BATCHES GJB,
         GL_JE_HEADERS GJH,
         GL_JE_LINES GJL
WHERE 1=1
    --------------------- JOIN OF PO_REQUISITION ---------------------------
    AND PRHA.REQUISITION_HEADER_ID = PRLA.REQUISITION_HEADER_ID
    AND PRLA.REQUISITION_LINE_ID = PRDA.REQUISITION_LINE_ID
    ------------------- JOIN OF PO_REQUISITION AND PO --------------------
    AND PRDA.DISTRIBUTION_ID = PDA.REQ_DISTRIBUTION_ID(+)
    --------------------- JOIN OF PO ---------------------------------------------
    AND PDA.PO_HEADER_ID = PHA.PO_HEADER_ID
    AND PDA.PO_LINE_ID = PLA.PO_LINE_ID
    AND PHA.PO_HEADER_ID = PLA.PO_LINE_ID
    AND PHA.PO_HEADER_ID = PLLA.PO_HEADER_ID
    AND PLA.PO_LINE_ID = PLLA.PO_LINE_ID
    AND PDA.LINE_LOCATION_ID = PLLA.LINE_LOCATION_ID
    ------------------ RCV_LINE TO PO_LINE ---------------------------------
    AND PHA.PO_HEADER_ID = RSL.PO_HEADER_ID
    AND PLA.PO_LINE_ID = RSL.PO_LINE_ID
    AND PHA.PO_HEADER_ID = RCT.PO_HEADER_ID
    AND PLA.PO_LINE_ID = RCT.PO_LINE_ID
    ---------------- JOIN OF RCV_SHIPMENT -----------------------------------
    AND RSL.SHIPMENT_HEADER_ID = RSH.SHIPMENT_HEADER_ID
    AND RSH.SHIPMENT_HEADER_ID = RCT.SHIPMENT_HEADER_ID
    AND RSL.SHIPMENT_LINE_ID = RCT.SHIPMENT_LINE_ID
    --------------- JOIN PO TO AP ----------------------------------------------
    AND PDA.PO_DISTRIBUTION_ID = AIDA.PO_DISTRIBUTION_ID
    --------------- JOIN OF AP_INVOICE ----------------------------------------
    AND AIA.INVOICE_ID = AILA.INVOICE_ID
    AND AIA.INVOICE_ID = AIDA.INVOICE_ID
    AND AIA.INVOICE_ID = APSA.INVOICE_ID
    AND AIA.INVOICE_ID = AIPA.INVOICE_ID
    AND AIPA.CHECK_ID = ACA.CHECK_ID
    ----------------------------- JOIN AP TO SLA -----------------------------------------
    AND AIA.INVOICE_ID = XTE.SOURCE_ID_INT_1
    -------------------- JOIN XLA HEADER TO XLA LINES -----------------------------
    AND XAH.AE_HEADER_ID = XAL.AE_HEADER_ID
    AND XAH.ENTITY_ID = XTE.ENTITY_ID
    AND XAH.ENTITY_ID = XE.ENTITY_ID                -- GIVES DUPLICATE
    AND XAH.EVENT_ID = XE.EVENT_ID                  -- GIVE DUPLICATE AGAIN NO CHANGE
--    ------------------- JOIN XLA LINE TO GL IMPORT REFERNCES ------------------
    AND XAL.GL_SL_LINK_ID = GIR.GL_SL_LINK_ID(+)
    AND XAL.GL_SL_LINK_TABLE = GIR.GL_SL_LINK_TABLE(+)
    AND GIR.JE_BATCH_ID = GJB.JE_BATCH_ID(+)
    AND GIR.JE_BATCH_ID = GJH.JE_BATCH_ID(+)
    AND GJH.JE_HEADER_ID = GJL.JE_HEADER_ID(+);
    
    
--    AND PRHA.REQUISITION_HEADER_ID = 121; 
--GROUP BY PRHA.REQUISITION_HEADER_ID;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- RVC SHIPMENT FULL QUERY
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


SELECT RSH.SHIPMENT_HEADER_ID,
            RSH.VENDOR_ID,
            APS.VENDOR_NAME,
            RSH.VENDOR_SITE_ID,
            ASSA.VENDOR_SITE_CODE,
            ASSA.ADDRESS_LINE1 || ', ' || ASSA.CITY || ', ' || ASSA.STATE || ', ' || ASSA.ZIP || ', ' || ASSA.PROVINCE || ', ' || ASSA.COUNTY ADDRESS,
            RSH.ORGANIZATION_ID,
            HOU.NAME,
            RSH.SHIPMENT_NUM,
            RSH.RECEIPT_NUM,
            RSH.SHIP_TO_LOCATION_ID,
            RSH.BILL_OF_LADING,
            RSH.SHIP_TO_ORG_ID,
            RSH.PACKING_SLIP,
            RSH.SHIPPED_DATE,
            RSH.FREIGHT_CARRIER_CODE,
            RSH.EMPLOYEE_ID,
            RSH.NUM_OF_CONTAINERS,
            RSH.COMMENTS,
            RSH.GROSS_WEIGHT,
            RSH.GROSS_WEIGHT_UOM_CODE,
            RSH.NET_WEIGHT,
            RSH.TAR_WEIGHT,
            RSH.CARRIER_METHOD,
            RSH.FREIGHT_TERMS,
            RSH.INVOICE_NUM,
            RSH.INVOICE_AMOUNT,
            RSL.LINE_NUM,
            RSL.SHIPMENT_LINE_ID,
            RSL.CATEGORY_ID,
            RSL.QUANTITY_SHIPPED,
            RSL.QUANTITY_RECEIVED,
            RSL.ITEM_DESCRIPTION,
            RSL.ITEM_ID,
            RSL.AMOUNT,
            RSL.AMOUNT_RECEIVED
--            RT.TRANSACTION_TYPE
FROM  RCV_SHIPMENT_HEADERS RSH,
          AP_SUPPLIERS APS,
          AP_SUPPLIER_SITES_ALL ASSA,
          HR_OPERATING_UNITS HOU,
          PER_ALL_PEOPLE_F PAPF,
          RCV_SHIPMENT_LINES RSL,
          RCV_TRANSACTIONS RT,
          MTL_CATEGORIES MC,
          MTL_SYSTEM_ITEMS_B MSIB,
          ORG_ORGANIZATION_DEFINITIONS OOD
WHERE 1=1
    AND RSH.SHIPMENT_HEADER_ID = RSL.SHIPMENT_HEADER_ID
    AND RSL.SHIPMENT_LINE_ID = RT.SHIPMENT_LINE_ID
    -------------------- JOIN AP_SUPPLIER --------------------------
    AND RSH.VENDOR_ID = APS.VENDOR_ID
    -------------------- JOIN AP_SUPPLIER_SITE ------------------
    AND RSH.VENDOR_SITE_ID = ASSA.VENDOR_SITE_ID
    -------------------- RCV OPERATING_UNIT --------------------
    AND RSH.ORGANIZATION_ID = HOU.ORGANIZATION_ID
    -------------------- RCV EMPLOYEE NAME ---------------------
    AND RSH.EMPLOYEE_ID = PAPF.PERSON_ID
    AND SYSDATE BETWEEN EFFECTIVE_START_dATE AND EFFECTIVE_END_DATE
    AND (CURRENT_EMPLOYEE_FLAG = 'Y' OR CURRENT_NPW_FLAG = 'Y')
    ------------------- RCV LINE CATEGORY NAME ----------------
    AND RSL.CATEGORY_ID = MC.CATEGORY_ID
    ------------------- RCV ITEM NAME ------------------------------
    AND RSL.ITEM_ID = MSIB.INVENTORY_ITEM_ID
    ------------------- TRANSACTION TYPE = RECIVE
    AND RT.TRANSACTION_TYPE = 'RECEIVE'
    ------------------- JOIN ORGANIZATION UNIT -----------------
    AND MSIB.ORGANIZATION_ID = OOD.ORGANIZATION_ID;
--    AND RSH.SHIPMENT_HEADER_ID = 583869;
;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- AP INVOICES FULL QUERY
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

select aia.invoice_id,
         aia.invoice_num,
         aia.invoice_currency_code,
         aia.invoice_amount,
         aia.vendor_id,
         asp.vendor_name,
         aia.vendor_site_id,
         aia.amount_paid,
         aia.invoice_date,
         aia.source,
--         aia.standard,
         aia.description,
         aia.terms_id,
         aia.payment_status_flag,
         aia.party_id,
         aia.party_site_id,
         aila.line_number,
         aila.line_type_lookup_Code,
         aila.description,
         aila.org_id,
         aila.amount,
         aida.accounting_date,
         aida.tax_code_id,
         aisa.due_date,
         aisa.payment_status_flag,
         aisa.remit_to_supplier_name,
--         aisa.remit_supplier_id,
         aisa.remit_to_supplier_site,
         aisa.remit_to_supplier_site_id,
         aipa.invoice_id,
         aipa.invoice_payment_id,
         aipa.bank_account_num,
         aca.amount,
         aca.bank_account_name,
         aca.check_date,
         aca.check_number,
--         aca.check_currency_code,
         aca.vendor_name,
         aca.bank_account_num,
         aca.address_line1 || ', ' || aca.city || ', ' || aca.country || ', ' || aca.zip address,
         pha.po_header_id,
         pha.segment1,
         pda.po_distribution_id
from  po_headers_all pha,
        po_distributions_all pda,
        ap_invoices_all aia,
        ap_invoice_lines_all aila,
        ap_invoice_distributions_all aida,
        ap_payment_schedules_all aisa,
        AP_INVOICE_PAYMENTS_ALL AIPA,
        ap_checks_all aca,
        ap_suppliers asp,
        ap_supplier_sites_all assa
where 1=1
    ------------------------------------ JOIN PO_HEADER TO PO_DISTRIBUTIONS ----------------------------------------------
    and pha.po_header_id(+) = pda.po_header_id
    ----------------------------------- JOIN PO_DISTRIBUTIONS TO AP_DISTRIBUTIONS -------------------------------------
    and pda.po_distribution_id(+) = aida.po_distribution_id
    ------------------------------- JOIN AP_INVOICE TO AP_INVOICE_LINES ----------------------------------------------------
    and aia.invoice_id = aila.invoice_id
    ------------------------------- JOIN AP_INVOICE TO AP_DISTRIBUTIONS ---------------------------------------------------
    and aia.invoice_id = aida.invoice_id
    ------ JOIN AP_INVOICE_LINE => LINE_NUMBER TO AP_DISTRIBUTIONS => DISRIBUTION_LINE_NUMBER ----
    and aila.line_number(+) = aida.distribution_line_number
    ------------------------------- JOIN AP_INVOICE TO AP_SCHEDULES ---------------------------------------------------------
    and aia.invoice_id = aisa.invoice_id
    ------------------------------- JOIN AP_INVOICE TO AP_INVOICE_PAYMENTS -----------------------------------------------
    and aia.invoice_id = aipa.invoice_id
    ------------------------------- JOIN AP_INVOICE_PAYMENTS TO AP_CHECKS -----------------------------------------------
    and aipa.check_id = aca.check_id
    ------------------------------- GET VENDOR NAME IN AP_INVOICE -----------------------------------------------------------
    and aia.vendor_id = asp.vendor_id
    ------------------------------- GET VENDOR SITE IN AP_INVOICE -------------------------------------------------------------
    and aia.vendor_site_id = assa.vendor_site_id
    and aia.invoice_num = 'ERS-8062-120800';
    
    
-------------------------------------------------------------------------------------------------------------------------------------------
-- XLA(SLA)(SUBLEDGER), GL FULL QUERY
-------------------------------------------------------------------------------------------------------------------------------------------

SELECT XAH.AE_HEADER_ID,
            XAH.LEDGER_ID,
            XAH.EVENT_ID,
            XAH.EVENT_TYPE_CODE,
--            XAH.CATEGORY_NAME,
            XAH.ACCOUNTING_ENTRY_TYPE_CODE,
            XAH.DESCRIPTION,
            XAH.PERIOD_NAME,
            XAL.AE_LINE_NUM,
            XAL.GL_SL_LINK_ID,
            XAL.PARTY_SITE_ID,
            XAL.CURRENCY_CODE,
            GIR.REFERENCE_1,
            GIR.REFERENCE_5,
            GIR.REFERENCE_6,
            GIR.REFERENCE_10,
            GIR.JE_BATCH_ID,
            GIR.JE_HEADER_ID,
            GIR.JE_LINE_NUM,
            GJH.JE_CATEGORY,
            GJH.JE_SOURCE,
            GJH.PERIOD_NAME,
            GJH.NAME,
            GJH.STATUS,
            GJH.RUNNING_TOTAL_DR,
            GJH.RUNNING_TOTAL_CR,
            GJH.RUNNING_TOTAL_ACCOUNTED_CR
FROM AP_INVOICES_ALL AIA,
         XLA_AE_HEADERS XAH,
         XLA_AE_LINES XAL,
         XLA_TRANSACTION_ENTITIES XTE,
         XLA_EVENTS XE,
         GL_IMPORT_REFERENCES GIR,
         GL_JE_BATCHES GJB,
         GL_JE_HEADERS GJH,
         GL_JE_LINES GJL
WHERE 1 = 1
    ----------------------------- JOIN AP TO SLA -----------------------------------------
    AND AIA.INVOICE_ID = XTE.SOURCE_ID_INT_1
    -------------------------------------------------------------------------------------------
    --                          SUBLEDGER JOIN
    -------------------------------------------------------------------------------------------
    -------------------- JOIN XLA HEADER TO XLA LINES -----------------------------
    AND XAH.AE_HEADER_ID = XAL.AE_HEADER_ID
    -------------------- JOIN XLA HEADER TO XLA TRANSACTION ENTITY ---------
    AND XAH.ENTITY_ID = XTE.ENTITY_ID
    -------------------- JOIN XLA HEADER TO XLA EVENTS ---------------------------
    AND XAH.ENTITY_ID = XE.ENTITY_ID
    -------------------------------------------------------------------------------------------
    --                      GENRAL LEDGER JOIN
    -------------------------------------------------------------------------------------------
    ------------------- JOIN XLA LINE TO GL IMPORT REFERNCES ------------------
    AND XAL.GL_SL_LINK_ID = GIR.GL_SL_LINK_ID
    ------------------- JOIN GL IMPORT REFERNCES TO GL JE BATCH --------------
    AND GIR.JE_BATCH_ID = GJB.JE_BATCH_ID
    ------------------ JOIN GL JE BATCHES TO GL HEADER ---------------------------
    AND GIR.JE_BATCH_ID = GJH.JE_BATCH_ID
    ----------------- JOIN GL HEADER TO GL LINES -----------------------------------
    AND GJH.JE_HEADER_ID = GJL.JE_HEADER_ID
    AND XAH.AE_HEADER_ID = 6818214;