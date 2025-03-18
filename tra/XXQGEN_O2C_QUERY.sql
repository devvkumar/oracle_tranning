--o2c order to cash querry

--1. Enter the Sales Order

-- OE_HEADERS_ALL FOR HEADER QUERRY

SELECT OOHA.ORDER_TYPE_ID,
            OOHA.ORDER_CATEGORY_CODE, 
            OOHA.ORDER_NUMBER,
            OOHA.VERSION_NUMBER,
            OOHA.EXPIRATION_DATE,
            OOHA.ORDER_SOURCE_ID,
            OOHA.ORDERED_DATE,
            OOHA.PRICING_DATE,
            OOHA.PRICE_LIST_ID,
            OOHA.TRANSACTIONAL_CURR_CODE,
            OOHA.ACCOUNTING_RULE_ID,
            OOHA.PAYMENT_TERM_ID,
            OOHA.SHIPPING_METHOD_cODE,
            OOHA.FREIGHT_CARRIER_CODE,
            OOHA.FREIGHT_TERMS_CODE,
            OOHA.SOLD_FROM_ORG_ID,
            OOHA.SOLD_TO_ORG_ID,
            HP.PARTY_NAME,
            OOHA.SHIP_TO_ORG_ID,
            OOHA.INVOICE_TO_ORG_ID,
            OOHA.SHIP_TO_CONTACT_ID,
--            OOHA.SOURCE_DOCUMENT_TYPE,
            ooha.FLOW_STATUS_CODE,
            HOU.NAME
FROM OE_ORDER_HEADERS_ALL OOHA,
          HR_OPERATING_UNITS HOU,
          oe_transaction_types_all  OTTA,
          FND_CURRENCIES FC,
          hz_cust_accounts HCA,
          HZ_PARTIES HP,
          ra_terms_b rtb
WHERE 1=1
    AND OOHA.ORDER_TYPE_ID = OTTA.TRANSACTION_TYPE_ID
    AND OTTA.ORG_ID = HOU.ORGANIZATION_ID
    AND OOHA.TRANSACTIONAL_CURR_CODE = FC.CURRENCY_CODE
    AND OOHA.SOLD_TO_ORG_ID = HCA.CUST_ACCOUNT_ID
    AND HCA.PARTY_ID = HP.PARTY_ID
    AND RTB.TERM_ID = OOHA.PAYMENT_TERM_ID
    AND OOHA.ORG_ID = HOU.ORGANIZATION_ID
    and hp.party_id = 1000;
    
select *
from ra_terms_b;
    
SELECT *
FROM DBA_OBJECTS
WHERE OBJECT_NAME  LIKE 'OE%ORDER%TYPE%'
    AND OBJECT_TYPE = 'VIEW';
    
SELECT *
FROM hz_cust_site_uses_all;
    
SELECT *
FROM HZ_PARTIES;
    
SELECT *
FROM hz_cust_accounts;

SELECT *
FROM FND_CURRENCIES;

SELECT *
FROM SO_ORDER_TYPES_115_ALL;

SELECT *
FROM oe_transaction_types_ALL;

SELECT *
FROM OE_ORDER_HEADERS_V;
-- order creation

select 
         ooha.org_id,
         ooha.order_number,
         otta.order_category_code,
         ooha.ordered_date,
         ooha.payment_term_id,
         hp.party_name,
         ooha.freight_carrier_code,
         ooha.sold_to_org_id,
         ooha.sold_from_org_id,
         ooha.ship_from_org_id,
         ooha.ship_to_org_id,
         ooha.invoice_to_org_id,
         ooha.flow_status_code,
         oola.org_id,
         oola.line_type_id,
         oola.line_number,
         oola.ordered_item,
         oola.ship_from_org_id,
         oola.ship_to_org_id,
         oola.invoice_to_org_id,
         oola.sold_from_org_id,
         oola.sold_to_org_id,
         oola.ordered_item_id,
         oola.inventory_item_id,
         oola.unit_cost,
         oola.ordered_quantity,
         wdd.customer_id,
         wdd.inventory_item_id,
         wdd.item_description,
         wdd.released_status,
         wda.delivery_id,
         wnd.status_code,
         wnd.net_weight || ' ' || wnd.weight_uom_code net_weight
from 
--  order creation
        oe_order_headers_all ooha,
        oe_order_lines_all oola,
         oe_transaction_types_all  OTTA,
         hz_cust_accounts HCA,
         HZ_PARTIES HP,
         ra_terms_b rtb,
--  order booking 
        wsh_delivery_details wdd,
--  pick release
        wsh_delivery_assignments wda,
--  ship confirm
        WSH_NEW_DELIVERIEs wnd
where ooha.header_id = oola.header_id
    and wdd.source_line_id = oola.line_id
    and OOHA.ORDER_TYPE_ID = OTTA.TRANSACTION_TYPE_ID
    and wdd.delivery_detail_id = wda.delivery_detail_id
    and wda.delivery_id = wnd.delivery_id
    AND OOHA.SOLD_TO_ORG_ID = HCA.CUST_ACCOUNT_ID
    AND HCA.PARTY_ID = HP.PARTY_ID
    AND RTB.TERM_ID = OOHA.PAYMENT_TERM_ID
    and ooha.order_number = 61534;

-- order booking
select *
from wsh_delivery_details wdd,
        wsh_delivery_assignments wda
where wdd.delivery_detail_id = wda.delivery_detail_id;

-- pick release
select *
from wsh_new_deliveries;

select *
from wsh_delivery_assignments;

-- ship confirm
select *
from wsh_delivery_details
where released_status = 'C';

select *
from ra_interface_lines_all
where interface_line_attribute5 = 215360;

215360
215359
215404

-- ar invoice
select *
from ra_customer_trx rct,
        ra_customer_trx_lines rctl
where rct.customer_trx_id = rctl.customer_trx_id;


select *
from ar_payment_schedules;

select *
from ra_customer_trx;

select *
from ra_customer_trx_lines;

begin
    mo_global.set_policy_context('S',204);
end;
/

-------------------------------------------------------------------------------------------------------------------------------------------------------------

select *
from oe_price_adjustments opaa;

select *
from wsh_delivery_details;

select *
from oe_order_lines_all oola;

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


--2. Book the Sales Order
--3. Launch Pick Release
--4. Ship Confirm
--5. Create Invoice
--6. Create the Receipts either manually or using Auto Lockbox ( In this article we will concentrate on Manual creation)
--7. Transfer to General Ledger
--8. Journal Import
--9. Posting





-- all tables in o2c 

--order creation
select * from oe_order_headers_all;               -- 