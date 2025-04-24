SELECT 
    --  ORGANIZATION UNIT
    OOHA.ORG_ID,
    HOU.NAME,
    OOHA.ORDER_TYPE_ID,
    OTTA.ORDER_CATEGORY_CODE,                   -- ORDER TYPE NAME 
    ORDER_NUMBER,               -- ORDER NUMBER
    HP.PARTY_NAME,
    HCSU.LOCATION,
    OOHA.SOLD_FROM_ORG_ID,              --  CUSTOMER NAME --  BILL TO LOCATION --  SHIP_TO_LOCATION --  CUSTOMER CONTACT
    OOHA.SOLD_TO_ORG_ID,
    -- WAREHOUSE NAME
    OOHA.SHIP_FROM_ORG_ID,
    MP.ORGANIZATION_CODE,
    --
    OOHA.SHIP_TO_ORG_ID,
    OOHA.INVOICE_TO_ORG_ID,
    OOHA.DELIVER_TO_ORG_ID,
    OOHA.SOLD_TO_CONTACT_ID,
    OOHA.SHIP_TO_CONTACT_ID,
    OOHA.INVOICE_TO_CONTACT_ID,
    OOHA.DELIVER_TO_CONTACT_ID,
    OOHA.PRICE_LIST_ID,
    QLHA.NAME PRICE_LIST,
    --  SALEPERSON
    OOHA.SALESREP_ID,
    JRS.NAME SALESREP,
    --  ORDER_TYPE
    --  PRICE_LIST
    --  STATUS'
    OOHA.CANCELLED_FLAG,
--    OOHA.OPEN_FLAGBOOKED_FLAG,
    --  CURRENCY
    QLHA.CURRENCY_CODE,
    --  SUBTOTAL,
    --  TAX
    --  CHARGE
    --  TOTAL
    --  PAYMENT_TERM
    --  WAREHOUSE
    --  FRIGHT_TERM
    OOHA.FREIGHT_TERMS_CODE,
    --  LINE_SET
    --  FOB
    OOHA.CUST_PO_NUMBER,
    OOHA.PAYMENT_TERM_ID,
    OOHA.SHIPPING_METHOD_CODE,
    OOHA.FREIGHT_CARRIER_CODE,
    OOHA.FOB_POINT_CODE,
    --  TAX HANDLING
    OOHA.TAX_EXEMPT_FLAG,
    OOHA.TAX_EXEMPT_NUMBER,
    OOHA.TAX_EXEMPT_REASON_CODE,
    OOHA.CONVERSION_RATE,
    OOHA.CONVERSION_TYPE_CODE,
    OOHA.CONVERSION_RATE_DATE,
    OOHA.PAYMENT_TYPE_CODE,
    OOHA.PAYMENT_AMOUNT,
    OOHA.CREDIT_CARD_NUMBER,
    OOHA.CREDIT_CARD_HOLDER_NAME,
    OOHA.CREDIT_CARD_CODE,
    OOHA.CREDIT_CARD_CODE,
    OOHA.CHECK_NUMBER,
    OOHA.FLOW_STATUS_CODE,
    OOHA.ORIG_SYS_DOCUMENT_REF,
    OOHA.SOURCE_DOCUMENT_TYPE_ID,
    OOHA.ORDER_SOURCE_ID
FROM OE_ORDER_HEADERS_ALL OOHA,
          HR_OPERATING_UNITS HOU,
          OE_TRANSACTION_TYPES_ALL OTTA,
          HZ_CUST_ACCOUNTS HCA,
          HZ_PARTIES HP,
          HZ_CUST_SITE_USES_ALL HCSU,
          -- SHIP_TO_LOCATION
          HZ_CUST_ACCT_SITES_ALL HCAS,
          HZ_PARTY_SITES HPS,
          HZ_LOCATIONS HL,
          -- SALESREP_ID
          JTF_RS_SALESREPS JRS,
          -- WAREHOUSE NAME
          MTL_PARAMETERS MP,
          -- PRICE LIST NAME
          QP_LIST_HEADERS_ALL QLHA
WHERE 1=1
    AND OOHA.ORG_ID = HOU.ORGANIZATION_ID
    AND OOHA.ORDER_TYPE_ID = OTTA.TRANSACTION_TYPE_ID
    AND OOHA.SOLD_TO_ORG_ID = HCA.CUST_ACCOUNT_ID
    AND HCA.PARTY_ID = HP.PARTY_ID
    AND OOHA.SHIP_TO_ORG_ID = HCSU.SITE_USE_ID
    AND HCSU.CUST_ACCT_SITE_ID = HCAS.CUST_ACCT_SITE_ID
    AND HCAS.PARTY_SITE_ID = HPS.PARTY_SITE_ID
    AND HL.LOCATION_ID = HPS.LOCATION_ID
    -- SALESREP_ID NAME
    AND OOHA.SALESREP_ID = JRS.SALESREP_ID
    -- TO GET WEREHOUSE NAME 
    AND OOHA.SHIP_FROM_ORG_ID = MP.ORGANIZATION_ID
    -- GET PRICE
    AND OOHA.PRICE_LIST_ID = QLHA.LIST_HEADER_ID
    AND OOHA.ORDER_NUMBER = 61534;
    
SELECT *
FROM HZ_CUST_SITE_USES_ALL;

SELECT *
FROM MTL_PARAMETERS
WHERE ORGANIZATION_ID = 204;

SELECT *
FROM DBA_OBJECTS
WHERE OBJECT_NAME LIKE '%OE%AGENT%';

SELECT *
FROM jtf_rs_salesreps;

SELECT *
FROM jtf_rs_resource_extns_vl;

SELECT *
FROM HZ_CUST_ACCT_SITES_ALL;

SELECT *
FROM HZ_CUST_SITE_USES_ALL HCSU,
         HZ_CUST_ACCT_SITES_ALL HCAS,
         HZ_PARTY_SITES HPS,
         HZ_LOCATIONS HL
WHERE 1 = 1
    AND HCSU.CUST_ACCT_SITE_ID = HCAS.CUST_ACCT_SITE_ID
    AND HCAS.PARTY_SITE_ID = HPS.PARTY_SITE_ID
    AND HPS.LOCATION_ID = HL.LOCATION_ID;
    
SELECT *
FROM HZ_PARTIES;

SELECT *
FROM QP_LIST_HEADERS_ALL
WHERE LIST_HEADER_ID = 1000;

SELECT *
FROM HZ_CUST_ACCOUNTS;

SELECT *
FROM HZ_PARTY_SITES;
    
SELECT *
FROM HZ_LOCATIONS;


SELECT *
FROM HZ_LOCATIONS HL,
         HZ_PARTY_SITES HPS,
         HZ_CUST_SITE_USES_ALL HCUA
WHERE 1 = 1
    AND HCUA.CUST_ACCT_SITE_ID = HPS.CUST_ACCT_SITE_ID
    AND HL.LOCATION_ID = HPS.LOCATION_ID;
    
SELECT *
FROM DBA_OBJECTS
WHERE OBJECT_NAME LIKE 'OE%TRANSACTION%TYPE%'
    AND OBJECT_TYPE = 'TABLE';
    
SELECT *
FROM OE_TRANSACTION_TYPES_ALL;


SELECT *
FROM OE_ORDER_HEADERS_ALL;


OE_HEADERS_IFACE_ALL


SELECT *
FROM OE_LINES_IFACE_ALL;


OE_ORDER_LINES_ALL


-- SALES ORDER ENTER QUERRY

SELECT OEHDR.HEADER_ID
, OEHDR.ORG_ID
, HOU.NAME ORG_NAME
, OEHDR.ORDER_TYPE_ID
, OETT.NAME TRANSACTION_TYPE
, OEHDR.ORDER_NUMBER
--, OEHDR.ORDER_SOURCE_ID
--, OEHDR.AGREEMENT_ID
, OEHDR.PAYMENT_TERM_ID
, TERM.NAME TERMS
--, OEHDR.SOLD_FROM_ORG_ID
, OEHDR.SOLD_TO_ORG_ID
, CUST_ACCT.ACCOUNT_NUMBER CUSTOMER_NUMBER
, OEHDR.SHIP_FROM_ORG_ID
, SHIP_FROM_ORG.ORGANIZATION_CODE SHIP_FROM
, OEHDR.SHIP_TO_ORG_ID
, SHIP_SU.LOCATION SHIP_TO_LOCATION
, OEHDR.INVOICE_TO_ORG_ID
, BILL_SU.LOCATION INVOICE_TO_LOCATION
--, OEHDR.DELIVER_TO_ORG_ID
--, OEHDR.SOLD_TO_CONTACT_ID
--, OEHDR.SHIP_TO_CONTACT_ID
--, OEHDR.INVOICE_TO_CONTACT_ID
--, OEHDR.DELIVER_TO_CONTACT_ID
, OEHDR.FLOW_STATUS_CODE
, OEHDR.ORDER_CATEGORY_CODE
, OEHDR.BOOKED_FLAG
, OEHDR.ORG_ID
--, OELINE.HEADER_ID LINE_HDR_ID
--, OELINE.LINE_TYPE_ID
--, OELINE.FLOW_STATUS_CODE LINE_FLW_STAT
--, OELINE.LINE_NUMBER
--, OELINE.ORDERED_ITEM
--, OELINE.ORDERED_QUANTITY
--, OELINE.UNIT_LIST_PRICE_PER_PQTY
FROM OE_ORDER_HEADERS_ALL OEHDR
        , HR_OPERATING_UNITS HOU
        , OE_TRANSACTION_TYPES_TL OETT
        , RA_TERMS_TL TERM
        , HZ_CUST_ACCOUNTS CUST_ACCT
        , MTL_PARAMETERS SHIP_FROM_ORG
        , HZ_CUST_SITE_USES_ALL SHIP_SU
        , HZ_CUST_SITE_USES_ALL BILL_SU
        , HZ_CUST_ACCOUNT_ROLES SOLED_ROLES
--        , OE_ORDER_LINES_ALL OELINE        
--        , MTL_SYSTEM_ITEMS_B MSIB
WHERE 1=1
AND OEHDR.ORDER_NUMBER=61534
--AND OEHDR.HEADER_ID = OELINE.HEADER_ID
--AND OEHDR.FLOW_STATUS_CODE = 'ENTERED' 
--AND OEHDR.HEADER_ID=202210
AND OEHDR.ORG_ID=HOU.ORGANIZATION_ID
AND OEHDR.ORDER_TYPE_ID= OETT.TRANSACTION_TYPE_ID
AND OEHDR.PAYMENT_TERM_ID = TERM.TERM_ID
AND OEHDR.SOLD_TO_ORG_ID = CUST_ACCT.CUST_ACCOUNT_ID(+)
AND OEHDR.SHIP_FROM_ORG_ID = SHIP_FROM_ORG.ORGANIZATION_ID(+)
AND OEHDR.SHIP_TO_ORG_ID = SHIP_SU.SITE_USE_ID(+)
AND OEHDR.INVOICE_TO_ORG_ID = BILL_SU.SITE_USE_ID(+)
AND OEHDR.SOLD_TO_CONTACT_ID = SOLED_ROLES.CUST_ACCOUNT_ROLE_ID(+)
  
--AND OELINE.ORDERED_ITEM=MSIB.SEGMENT1              


;



SELECT *
FROM OE_ORDER_HEADERS_V;



SELECT h.ROWID ROW_ID,
          h.header_id,
          h.org_id,
          h.order_type_id,
          h.order_number,
          h.version_number,
          h.order_source_id,
          h.source_document_type_id,
          h.orig_sys_document_ref,
          h.source_document_id,
          h.ordered_date,
          h.request_date,
          h.pricing_date,
          h.shipment_priority_code,
          h.demand_class_code,
          h.price_list_id,
          h.tax_exempt_flag,
          h.tax_exempt_number,
          h.tax_exempt_reason_code,
          h.conversion_rate,
          h.conversion_rate_date,
          h.conversion_type_code,
          h.partial_shipments_allowed,
          h.ship_tolerance_above,
          h.ship_tolerance_below,
          h.transactional_curr_code,
          h.agreement_id,
          h.tax_point_code,
          h.cust_po_number,
          h.invoicing_rule_id,
          h.accounting_rule_id,
          h.accounting_rule_duration,
          h.payment_term_id,
          h.shipping_method_code,
          h.fob_point_code,
          h.freight_terms_code,
          h.sold_to_org_id,
          h.sold_to_phone_id,
          h.ship_from_org_id,
          h.ship_to_org_id,
          h.invoice_to_org_id,
          h.deliver_to_org_id,
          h.sold_to_contact_id,
          h.ship_to_contact_id,
          h.invoice_to_contact_id,
          h.deliver_to_contact_id,
          h.creation_date,
          h.created_by,
          h.last_update_date,
          h.last_updated_by,
          h.last_update_login,
          h.expiration_date,
          h.request_id,
          h.program_application_id,
          h.program_id,
          h.program_update_date,
          h.context,
          h.attribute1,
          h.attribute2,
          h.attribute3,
          h.attribute4,
          h.attribute5,
          h.attribute6,
          h.attribute7,
          h.attribute8,
          h.attribute9,
          h.attribute10,
          h.attribute11,
          h.attribute12,
          h.attribute13,
          h.attribute14,
          h.attribute15,
          h.attribute16,
          h.attribute17,
          h.attribute18,
          h.attribute19,
          h.attribute20,
          h.global_attribute_category,
          h.global_attribute1,
          h.global_attribute2,
          h.global_attribute3,
          h.global_attribute4,
          h.global_attribute5,
          h.global_attribute6,
          h.global_attribute7,
          h.global_attribute8,
          h.global_attribute9,
          h.global_attribute10,
          h.global_attribute11,
          h.global_attribute12,
          h.global_attribute13,
          h.global_attribute14,
          h.global_attribute15,
          h.global_attribute16,
          h.global_attribute17,
          h.global_attribute18,
          h.global_attribute19,
          h.global_attribute20,
          h.TP_CONTEXT,
          h.TP_ATTRIBUTE1,
          h.TP_ATTRIBUTE2,
          h.TP_ATTRIBUTE3,
          h.TP_ATTRIBUTE4,
          h.TP_ATTRIBUTE5,
          h.TP_ATTRIBUTE6,
          h.TP_ATTRIBUTE7,
          h.TP_ATTRIBUTE8,
          h.TP_ATTRIBUTE9,
          h.TP_ATTRIBUTE10,
          h.TP_ATTRIBUTE11,
          h.TP_ATTRIBUTE12,
          h.TP_ATTRIBUTE13,
          h.TP_ATTRIBUTE14,
          h.TP_ATTRIBUTE15,
          h.freight_carrier_code,
          CUST_ACCT.ACCOUNT_NUMBER CUSTOMER_NUMBER,
          fndcur.precision CURRENCY_PRECISION,
          NULL ORDER_SOURCE,
          ot.name ORDER_TYPE,
          NULL SOURCE_DOCUMENT_TYPE,
          NULL AGREEMENT,
          pl.name PRICE_LIST,
          NULL CONVERSION_TYPE,
          accrule.name ACCOUNTING_RULE,
          invrule.name INVOICING_RULE,
          term.name TERMS,
          PARTY.PARTY_NAME SOLD_TO,
          ship_from_org.organization_code SHIP_FROM,
          NULL SHIP_FROM_LOCATION,
          NULL SHIP_FROM_ADDRESS1,
          NULL SHIP_FROM_ADDRESS2,
          NULL SHIP_FROM_ADDRESS3,
          NULL SHIP_FROM_ADDRESS4,
          ship_su.location SHIP_TO,
          ship_su.location SHIP_TO_LOCATION,
          ship_loc.address1 SHIP_TO_ADDRESS1,
          ship_loc.address2 SHIP_TO_ADDRESS2,
          ship_loc.address3 SHIP_TO_ADDRESS3,
          ship_loc.address4 SHIP_TO_ADDRESS4,
          DECODE (ship_loc.city, NULL, NULL, ship_loc.city || ', ')
          || DECODE (ship_loc.state,
                     NULL, ship_loc.province || ', ',
                     ship_loc.state || ', ')
          || DECODE (ship_loc.postal_code,
                     NULL, NULL,
                     ship_loc.postal_code || ', ')
          || DECODE (ship_loc.country, NULL, NULL, ship_loc.country)
             SHIP_TO_ADDRESS5,
          NULL DELIVER_TO,
          NULL DELIVER_TO_LOCATION,
          NULL DELIVER_TO_ADDRESS1,
          NULL DELIVER_TO_ADDRESS2,
          NULL DELIVER_TO_ADDRESS3,
          NULL DELIVER_TO_ADDRESS4,
          bill_su.location INVOICE_TO,
          bill_su.location INVOICE_TO_LOCATION,
          bill_loc.address1 INVOICE_TO_ADDRESS1,
          bill_loc.address2 INVOICE_TO_ADDRESS2,
          bill_loc.address3 INVOICE_TO_ADDRESS3,
          bill_loc.address4 INVOICE_TO_ADDRESS4,
          DECODE (bill_loc.city, NULL, NULL, bill_loc.city || ', ')
          || DECODE (bill_loc.state,
                     NULL, bill_loc.province || ', ',
                     bill_loc.state || ', ')
          || DECODE (bill_loc.postal_code,
                     NULL, NULL,
                     bill_loc.postal_code || ', ')
          || DECODE (bill_loc.country, NULL, NULL, bill_loc.country)
             INVOICE_TO_ADDRESS5,
          sold_party.PERSON_LAST_NAME
          || DECODE (sold_party.PERSON_FIRST_NAME,
                     NULL, NULL,
                     ', ' || sold_party.PERSON_FIRST_NAME)
             SOLD_TO_CONTACT,
          ship_party.PERSON_LAST_NAME
          || DECODE (ship_party.PERSON_FIRST_NAME,
                     NULL, NULL,
                     ', ' || ship_party.PERSON_FIRST_NAME)
             SHIP_TO_CONTACT,
          invoice_party.PERSON_LAST_NAME
          || DECODE (invoice_party.PERSON_FIRST_NAME,
                     NULL, NULL,
                     ', ' || invoice_party.PERSON_FIRST_NAME)
             INVOICE_TO_CONTACT,
          NULL DELIVER_TO_CONTACT,
          h.salesrep_id,
          h.return_reason_code,
          NULL return_reason,
          h.order_date_type_code,
          h.earliest_schedule_limit,
          h.latest_schedule_limit,
          h.PAYMENT_TYPE_CODE,
          h.PAYMENT_AMOUNT,
          h.CHECK_NUMBER,
          h.CREDIT_CARD_CODE,
          h.CREDIT_CARD_HOLDER_NAME,
          h.CREDIT_CARD_NUMBER,
          h.CREDIT_CARD_EXPIRATION_DATE,
          h.CREDIT_CARD_APPROVAL_CODE,
          h.CREDIT_CARD_APPROVAL_DATE,
          h.FIRST_ACK_CODE,
          h.FIRST_ACK_DATE,
          h.LAST_ACK_CODE,
          h.LAST_ACK_DATE,
          h.booked_flag,
          h.booked_date,
          h.cancelled_flag,
          h.open_flag,
          h.sold_from_org_id,
          h.shipping_instructions,
          h.packing_instructions,
          h.order_category_code,
          h.flow_status_code,
          NULL FREIGHT_CARRIER,
          olu.meaning CUSTOMER_PREFERENCE_SET_CODE,
          h.sales_channel_code,
          h.upgraded_flag,
          h.lock_control,
          party.email_address,
          NVL (party.gsa_indicator_flag, 'N') gsa_indicator,
          h.blanket_number,
          h.default_fulfillment_set,
          h.line_set_name,
          h.fulfillment_set_name,
          h.quote_date,
          h.quote_number,
          h.sales_document_name,
          h.transaction_phase_code,
          h.user_status_code,
          h.draft_submitted_flag,
          h.source_document_version_number,
          h.sold_to_site_use_id,
          h.SUPPLIER_SIGNATURE,
          h.SUPPLIER_SIGNATURE_DATE,
          h.CUSTOMER_SIGNATURE,
          h.CUSTOMER_SIGNATURE_DATE,
          h.minisite_id,
          h.end_customer_id,
          h.end_customer_contact_id,
          h.end_customer_site_use_id,
          NULL end_customer_name,
          NULL end_customer_number,
          NULL end_customer_contact,
          NULL end_customer_location,
          NULL end_customer_address1,
          NULL end_customer_address2,
          NULL end_customer_address3,
          NULL end_customer_address4,
          NULL end_customer_address5,
          h.ib_owner,
          h.ib_current_location,
          h.ib_installed_at_location,
          h.ORDER_FIRMED_DATE
     FROM mtl_parameters ship_from_org,
          hz_cust_site_uses_all ship_su,
          hz_party_sites ship_ps,
          hz_locations ship_loc,
          hz_cust_acct_sites_all ship_cas,
          hz_cust_site_uses_all bill_su,
          hz_party_sites bill_ps,
          hz_locations bill_loc,
          hz_cust_acct_sites_all bill_cas,
          hz_parties party,
          hz_cust_accounts cust_acct,
          ra_terms_tl term,
          oe_order_headers h,
          hz_cust_account_roles sold_roles,
          hz_parties sold_party,
          hz_cust_accounts sold_acct,
          hz_relationships sold_rel,
          hz_cust_account_roles ship_roles,
          hz_parties ship_party,
          hz_relationships ship_rel,
          hz_cust_accounts ship_acct,
          hz_cust_account_roles invoice_roles,
          hz_parties invoice_party,
          hz_relationships invoice_rel,
          hz_cust_accounts invoice_acct,
          fnd_currencies fndcur,
          oe_transaction_types_tl ot,
          qp_list_headers_tl pl,
          ra_rules invrule,
          ra_rules accrule,
          oe_lookups olu
    WHERE     h.order_type_id = ot.transaction_type_id
          AND ot.language = USERENV ('LANG')
          AND h.price_list_id = pl.list_header_id(+)
          AND pl.language(+) = USERENV ('LANG')
          AND h.invoicing_rule_id = invrule.rule_id(+)
          AND h.accounting_rule_id = accrule.rule_id(+)
          AND h.payment_term_id = term.term_id(+)
          AND TERM.Language(+) = USERENV ('LANG')
          AND h.transactional_curr_code = fndcur.currency_code
          AND h.sold_to_org_id = cust_acct.cust_account_id(+)
          AND CUST_ACCT.PARTY_ID = PARTY.PARTY_ID(+)
          AND h.ship_from_org_id = ship_from_org.organization_id(+)
          AND h.ship_to_org_id = ship_su.site_use_id(+)
          AND ship_su.cust_acct_site_id = ship_cas.cust_acct_site_id(+)
          AND ship_cas.party_site_id = ship_ps.party_site_id(+)
          AND ship_loc.location_id(+) = ship_ps.location_id
          AND h.invoice_to_org_id = bill_su.site_use_id(+)
          AND bill_su.cust_acct_site_id = bill_cas.cust_acct_site_id(+)
          AND bill_cas.party_site_id = bill_ps.party_site_id(+)
          AND bill_loc.location_id(+) = bill_ps.location_id
          AND h.sold_to_contact_id = sold_roles.cust_account_role_id(+)
          AND sold_roles.party_id = sold_rel.party_id(+)
          AND sold_roles.role_type(+) = 'CONTACT'
          AND sold_roles.cust_account_id = sold_acct.cust_account_id(+)
          AND NVL (sold_rel.object_id, -1) = NVL (sold_acct.party_id, -1)
          AND sold_rel.subject_id = sold_party.party_id(+)
          AND h.ship_to_contact_id = ship_roles.cust_account_role_id(+)
          AND ship_roles.party_id = ship_rel.party_id(+)
          AND ship_roles.role_type(+) = 'CONTACT'
          AND ship_roles.cust_account_id = ship_acct.cust_account_id(+)
          AND NVL (ship_rel.object_id, -1) = NVL (ship_acct.party_id, -1)
          AND ship_rel.subject_id = ship_party.party_id(+)
          AND h.invoice_to_contact_id = invoice_roles.cust_account_role_id(+)
          AND invoice_roles.party_id = invoice_rel.party_id(+)
          AND invoice_roles.role_type(+) = 'CONTACT'
          AND invoice_roles.cust_account_id = invoice_acct.cust_account_id(+)
          AND NVL (invoice_rel.object_id, -1) =
                 NVL (invoice_acct.party_id, -1)
          AND invoice_rel.subject_id = invoice_party.party_id(+)
          AND olu.lookup_type(+) = 'OE_LINE_SET_POPLIST'
          AND OLU.LOOKUP_code(+) = h.CUSTOMER_PREFERENCE_SET_CODE
          AND olu.enabled_flag(+) = 'Y'
          AND SYSDATE BETWEEN NVL (olu.start_date_active, SYSDATE - 1)
                          AND NVL (olu.end_date_active, SYSDATE + 1);