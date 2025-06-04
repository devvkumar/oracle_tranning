--==================================================================================================================================
-- CONTROL FILE NAME : LOAD_DATA.ctl
-- TYPE              : SQL*LOADER CONTROL FILE
-- LOCATION (UNIX)   : /u01/install/VISION/fs1/EBSapps/appl/ar/12.0.0/bin (DEV2 environment)
--
-- COMPANY           : QGEN
-- MODULE            : AR Invoice Data Loader
-- CALLED BY         : Concurrent Program - XXQGEN AR Invoice Data Loader
-- PURPOSE           : Load invoice header, line, and distribution data from a CSV file into custom AR interface tables
--
--==================================================================================================================================
-- DESCRIPTION:
--   This control file is used to load data into the following custom interface tables:
--     1. AR_INV_HEADER_DK
--     2. AR_INV_LINE_DK
--     3. AR_INV_DIST_DK
--   using a CSV source file. This process is invoked via a concurrent program and supports bulk data loading via SQL*Loader.
--
--==================================================================================================================================
-- PRE-REQUISITES:
--   - Custom tables AR_INV_HEADER_DK, AR_INV_LINE_DK, and AR_INV_DIST_DK must exist.
--   - Source file must be in CSV format, with column headers on the first row (which will be skipped).
--
--==================================================================================================================================
-- CHANGE HISTORY:
--  DATE        		AUTHOR         	REMARKS
--  ----------------------------------------------------------------------------------------------------
--  19-May-2025 		DKUMAR    		Initial version for bulk loading AR invoices data.
--  20-May-2025			DKUMAR			Adding data load for AR_INV_LINE_DK and AR_INV_DIST_DK
--==================================================================================================================================

OPTIONS (
    SKIP=1,             -- Skip CSV header row
    ERRORS=1000000,     -- Allow up to 1 million errors
    DIRECT=FALSE        -- Use conventional path loading
)

LOAD DATA
APPEND
-- ===========================
-- Load into AR_INV_HEADER_DK
-- ===========================
INTO TABLE AR_INV_HEADER_DK
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"' TRAILING NULLCOLS
(
    trx_number                     ,
    trx_date                SYSDATE,
    trx_currency                   ,
    trx_curr_code                  ,
    reference_number               ,
    trx_class                      ,
    order_type		               ,
    gl_date                 SYSDATE,
    bill_to_account_number         ,
    bill_to_customer_name          ,
    bill_to_contact_id             ,
    bill_to_contact                ,
    bill_to_address_id             ,
    bill_to_address1               ,
    bill_to_address2               ,
    bill_to_address3               ,
    bill_to_address4               ,
    bill_to_site_use_id            ,
    bill_to_site                   ,
    ship_to_customer_id            ,
    ship_to_account_number         ,
    ship_to_customer_name          ,
    ship_to_contact_id             ,
    ship_to_contact                ,
    ship_to_address_id             ,
    ship_to_address1               ,
    ship_to_address2               ,
    ship_to_address3               ,
    ship_to_address4               ,
    ship_to_site_use_id            ,
    ship_to_site                   ,
    sold_to_customer_id            ,
    sold_to_cust_name              ,
    term_id                        ,
    primary_salesrep_id            ,
    primary_salesrep_name          ,
    exchange_rate_type             ,
    exchange_date                  ,
    exchange_rate                  ,
    territory_id                   ,
    territory                      ,
    remit_to_address_id            ,
    invoicing_rule_id              ,
    printing_option                ,
    purchase_order                 ,
    purchase_order_revision        ,
    purchase_order_date            ,
    comments                       ,
    internal_notes                 ,
    finance_charges                ,
    receipt_method_id              ,
    related_customer_trx_id        ,
    agreement_id                   ,
    ship_via                       ,
    ship_date_actual               ,
    waybill_number                 ,
    fob_point                      ,
    customer_bank_account_id       ,
    default_ussgl_transaction_code ,
    status_trx                     ,
    org_id                     CONSTANT 204,
	TRX_LEGAL_ENTITY				,
    STATUS                        constant 'N',
	batch_id				constant 100977,
	record_id				SEQUENCE(MAX,1)
)

-- ===========================
-- Load into AR_INV_LINE_DK
-- ===========================
INTO TABLE AR_INV_LINE_DK
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"' TRAILING NULLCOLS
(
  trx_header_id                 ,
  trx_line_id                    ,
  line_number                    ,
  reason_code                    ,
  item                           ,
  description                    ,
  quantity_ordered               ,
  quantity_invoiced              ,
  unit_standard_price            ,
  unit_selling_price             ,
  accounting_rule_duration       ,
  amount                         ,
  tax_rate                       ,
    STATUS                        constant 'N',
	batch_id					constant 100977,
	record_id					SEQUENCE(MAX,1)
)

-- ===========================
-- Load into AR_INV_DIST_DK
-- ===========================
INTO TABLE AR_INV_DIST_DK
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"' TRAILING NULLCOLS
(
    trx_number             ,
    trx_line_number        ,
    account_class          ,
    amount                 ,
    acctd_amount           ,
    percent                ,
    code_combination_id    ,
    segment1               ,
    segment2               ,
    segment3               ,
    segment4               ,
    segment5               ,
    CREATION_DATE         SYSDATE ,
    CREATED_BY            FILLER,
    LAST_UPDATE_DATE      FILLER,
    LAST_UPDATED_BY       FILLER,
    LAST_UPDATE_LOGIN     FILLER,
    REQUEST_ID            FILLER,
    STATUS                   constant 'N',
	batch_id				constant 100977,
	record_id				SEQUENCE(MAX,1)
)
