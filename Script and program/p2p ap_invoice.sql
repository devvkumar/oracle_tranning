-- 1st Query : AP_INVOICES_ALL
SELECT AIA.INVOICE_ID,
            AIA.VENDOR_ID,
            APS.VENDOR_NAME,
            AIA.INVOICE_NUM,
            AIA.INVOICE_CURRENCY_CODE,
            AIA.INVOICE_AMOUNT,
            AIA.VENDOR_SITE_ID,
            ASSA.VENDOR_SITE_CODE,
            AIA.AMOUNT_PAID,
            AIA.INVOICE_DATE,
            AIA.INVOICE_TYPE_LOOKUP_CODE,
            AIA.DESCRIPTION,
            AIA.TAX_AMOUNT,
            AIA.TERMS_ID,
            APT.DESCRIPTION,
            AIA.TERMS_DATE,
            AIA.GOODS_RECEIVED_DATE,
            AIA.INVOICE_RECEIVED_DATE,
            AIA.APPROVED_AMOUNT,
            AIA.DOC_CATEGORY_CODE,
            AIA.ORG_ID,
            HOU.NAME,
            AIA.LEGAL_ENTITY_ID
FROM   AP_INVOICES_ALL AIA,
           AP_SUPPLIERS APS,
           AP_SUPPLIER_SITES_ALL ASSA,
           AP_TERMS APT,
           HR_OPERATING_UNITS HOU
WHERE 1=1
    AND AIA.VENDOR_ID = APS.VENDOR_ID
    AND AIA.VENDOR_SITE_ID = ASSA.VENDOR_SITE_ID
    AND AIA.TERMS_ID = APT.TERM_ID
    AND HOU.ORGANIZATION_ID = AIA.ORG_ID
    AND AIA.INVOICE_NUM='ERS-8788-202538'
;


-- 2nd Query: AP_INVOICE_LINES
SELECT AILA.INVOICE_ID,
            AILA.LINE_NUMBER,
            AILA.DESCRIPTION,
            AILA.LINE_SOURCE,
            AILA.ORG_ID,
            AILA.LINE_GROUP_NUMBER,
            AILA.INVENTORY_ITEM_ID,
            AILA.ITEM_DESCRIPTION,
            SERIAL_NUMBERMANUFACTURERMODEL_NUMBERWARRANTY_NUMBERAMOUNTBASE_AMOUNTQUANTITY_INVOICEDUNIT_MEAS_LOOKUP_CODEUNIT_PRICEPO_HEADER_IDPO_LINE_IDPO_LINE_LOCATION_IDPO_DISTRIBUTION_IDRCV_TRANSACTION_ID
FROM AP_INVOICES_ALL AIA,
         AP_INVOICE_LINES_ALL AILA
WHERE 1=1
    AND AIA.INVOICE_ID = AILA.INVOICE_ID
    AND AIA.INVOICE_NUM='ERS-8788-202538';
    
-- 4th Query : AP_INVOICES
SELECT *
FROM AP_INVOICES_ALL AIA,
         AP_INVOICE_LINES_ALL AILA,
         AP_INVOICE_DISTRIBUTIONS_ALL AIDA
WHERE 1=1
    AND AIA.INVOICE_ID = AILA.INVOICE_ID
    AND AILA.INVOICE_ID = AIDA.INVOICE_ID
    and AILA.LINE_NUMBER= AIDA.INVOICE_LINE_NUMBER
    AND AIA.INVOICE_NUM='ERS-8788-202538';