--get a customer name based on order number


select ra.CUSTOMER_NAME,
          ra.CUSTOMER_ID,
          rcta.CT_REFERENCE,
          ooha.order_number
from ra_customer_trx_all rcta,
         ra_customers ra,
         oe_order_headers_all ooha
where rcta.CT_REFERENCE=to_char(ooha.ORDER_NUMBER)
          and ra.CUSTOMER_ID=rcta.SHIP_TO_CUSTOMER_ID
--          and order_number='66415';

--(or)

select hp.PARTY_NAME,
          hp.PARTY_ID,
          rcta.CT_REFERENCE,
          ooha.order_number
from ra_customer_trx_all rcta,
         hz_parties hp,
         oe_order_headers_all ooha
where rcta.CT_REFERENCE=to_char(ooha.ORDER_NUMBER)
    and hp.PARTY_ID=rcta.SHIP_TO_CUSTOMER_ID
--          and order_number='66415';



--To Find Duplicate Item Category Code

SELECT category_set_name, category_concat_segments, COUNT (*)
FROM mtl_category_set_valid_cats_v
WHERE 1 = 1
    AND (category_set_id = 1)
GROUP BY category_set_name, category_concat_segments
--HAVING COUNT (*) > 1
--ORDER BY category_concat_segments;



--Get Number Of canceled requisition

SELECT a.AUTHORIZATION_STATUS,(a.ORG_ID),(SELECT distinct hr.per_all_people_f.first_name|| ' '|| hr.per_all_people_f.middle_names||' '|| hr.per_all_people_f.last_name "Employee Name"
FROM hr.per_all_people_f
where hr.per_all_people_f.PERSON_ID in (select employee_id from fnd_user fu where fu.user_id = a.CREATED_BY)) CREATED_BY,count(SEGMENT1 )
                                                            FROM po_requisition_headers_all a
                                                            WHERE
                                                            a.creation_date BETWEEN TO_DATE('01/01/2007', 'DD/MM/YYYY')
                                                            and TO_DATE('30/05/2007', 'DD/MM/YYYY')
                                                            and a.AUTHORIZATION_STATUS = 'CANCELLED'
                                                            group by a.AUTHORIZATION_STATUS,a.ORG_ID,a.CREATED_BY)



--Number of line processed in Order Management

SELECT COUNT (line_id) “Order Line Processed”
FROM oe_order_lines_all
WHERE creation_date BETWEEN TO_DATE (:Fdate, ‘DD/MM/YYYY’)
AND TO_DATE (:tdate, ‘DD/MM/YYYY’)
AND flow_status_code = ‘CLOSED’;



--To Check Item Catogry For Inventory master (No Of Segments May Varry)

SELECT ood.organization_name,
segment1|| '-'|| segment2|| '-'|| segment3 catgory
FROM org_organization_definitions ood,
mtl_categories_vl mcv,
mtl_category_sets mcs
WHERE mcs.structure_id = mcv.structure_id
ORDER BY ood.organization_name



--Check Locators for inventory Inventory Org Wise(Number of segment may varry)

SELECT mil.segment1 loc_seg1, mil.segment11 loc_seg11, mil.segment2 loc_seg2,
mil.segment3 loc_seg3, mil.segment4 loc_seg4, mil.segment5 loc_seg5,
mil.segment6 loc_seg6,ood.ORGANIZATION_NAME,mil.SUBINVENTORY_CODE
FROM mtl_item_locations mil,org_organization_definitions ood
where mil.ORGANIZATION_ID = ood.ORGANIZATION_ID



--Display All Subinventories Setup

select msi.secondary_inventory_name, MSI.SECONDARY_INVENTORY_NAME “Subinventory”, MSI.DESCRIPTION “Description”,
MSI.DISABLE_DATE “Disable Date”, msi.PICKING_ORDER “Picking Order”,
gcc1.concatenated_segments “Material Account”,
gcc2.concatenated_segments “Material Overhead Account”,
gcc3.concatenated_segments “Resource Account”,
gcc4.concatenated_segments “Overhead Account”,
gcc5.concatenated_segments “Outside Processing Account”,
gcc6.concatenated_segments “Expense Account”,
gcc7.concatenated_segments “Encumbrance Account”,
msi.material_overhead_account,
msi.resource_account,
msi.overhead_account,
msi.outside_processing_account,
msi.expense_account,
msi.encumbrance_account
from mtl_secondary_inventories msi,
gl_code_combinations_kfv gcc1,
gl_code_combinations_kfv gcc2,
gl_code_combinations_kfv gcc3,
gl_code_combinations_kfv gcc4,
gl_code_combinations_kfv gcc5,
gl_code_combinations_kfv gcc6,
gl_code_combinations_kfv gcc7
where msi.material_account = gcc1.CODE_COMBINATION_ID(+)
and msi.material_overhead_account = gcc2.CODE_COMBINATION_ID(+)
and msi.resource_account = gcc3.CODE_COMBINATION_ID(+)
and msi.overhead_account = gcc4.CODE_COMBINATION_ID(+)
and msi.outside_processing_account = gcc5.CODE_COMBINATION_ID(+)
and msi.expense_account = gcc6.CODE_COMBINATION_ID(+)
and msi.encumbrance_account = gcc7.CODE_COMBINATION_ID(+)
order by msi.secondary_inventory_name
To Select Unit Of measure exist in ebusiness suite
select uom_code,unit_of_measure
from mtl_units_of_measure



--Query to find out Customer Master Information. Customer Name, Account Number, Adress etc.

select p.PARTY_NAME,ca.ACCOUNT_NUMBER,loc.address1,loc.address2,loc.address3,loc.city,loc.postal_code,
loc.country,ca.CUST_ACCOUNT_ID
from apps.ra_customer_trx_all I,
apps.hz_cust_accounts CA,
apps.hz_parties P,
apps.hz_locations Loc,
apps.hz_cust_site_uses_all CSU,
apps.hz_cust_acct_sites_all CAS,
apps.hz_party_sites PS
where I.COMPLETE_FLAG =’Y’
and I.bill_TO_CUSTOMER_ID= CA.CUST_ACCOUNT_ID
and ca.PARTY_ID=p.PARTY_ID
and I.bill_to_site_use_id=csu.site_use_id
and csu.CUST_ACCT_SITE_ID=cas.CUST_ACCT_SITE_ID
and cas.PARTY_SITE_ID=ps.party_site_id
and ps.location_id=loc.LOCATION_ID



--Query to find on Hand Quantity

select sum(transaction_quantity) from MTL_ONHAND_QUANTITIES
where inventory_item_id=9
and organization_id=188
Qunatity on order, Expected Deliver
select sum(ordered_quantity),a.SCHEDULE_SHIP_DATE
from oe_order_lines_all a
where inventory_item_id=10
and ship_from_org_id=188
group by a.SCHEDULE_SHIP_DATE



--Query to find Item Code, Item Description Oracle Item Master Query

select item, description from mtl_system_items_b
where inventory_item_id=&your_item
and organization_id=&organization_id) item



--Query to Find out On Hand Quantity of specific Item Oracle inventory

select sum(transaction_quantity) from mtl_onhand_quantity_details
where inventory_item_id=&your_item
and organization_id=&organization_id
Qty On Order,
Expected deivery date(select sum(ordered_quantity),
scheduled_ship_date from oe_order_lines_all
where inventory_item_id=&your_item
and ship_from_org_id=&organization_id
group by scheduled_ship_date) order_info


--–Total Received Qty

select sum(transaction_quantity) from mtl_material_transactions
inventory_item_id=&your_item
and organization_id=&organization_id
and transaction_quantity>0)
Total received Qty in 9 months
select sum(transaction_quantity) from mtl_material_transactions
inventory_item_id=&your_item
and organization_id=&organization_id
and transaction_quantity>0
and transaction_date between trunc(sysdate) and trunc(sysdate-270))



--Total issued quantity in 9 months

select sum(transaction_quantity) from mtl_material_transactions
inventory_item_id=&your_item
and organization_id=&organization_id
and transaction_quantity<0 and transaction_date between trunc(sysdate) and trunc(sysdate-270)) tot_iss_qty_9mths, –Average monthly consumption
(select sum(transaction_quantity)/30 from mtl_material_transactions
inventory_item_id=&your_item
and organization_id=&organization_id
and transaction_quantity<0) ;



--Display all categories that the Item Belongs

SELECTunique micv.CATEGORY_SET_NAME “Category Set”,
micv.CATEGORY_SET_ID “Category Set ID”,
decode( micv.CONTROL_LEVEL,
1, ‘Master’,
2, ‘Org’,
‘Other’) “Control Level”,
micv.CATEGORY_ID “Category ID”,
micv.CATEGORY_CONCAT_SEGS “Category”
FROM


MTL_ITEM_CATEGORIES_V micv



--Another Query to Get Onhand Qty With Oranization ID, Item Code, Quantity

SELECT organization_id,
(SELECT ( msib.segment1|| ‘-’|| msib.segment2|| ‘-’|| msib.segment3|| ‘-’|| msib.segment4)
FROM mtl_system_items_b msib
WHERE msib.inventory_item_id = moq.inventory_item_id
AND msib.organization_id = moq.organization_id) “Item Code”,
(SELECT description
FROM mtl_system_items_b msib
WHERE msib.inventory_item_id =
moq.inventory_item_id
AND msib.organization_id = moq.organization_id)
“item Description”,
SUM (moq.transaction_quantity) onhandqty
FROM mtl_onhand_quantities moq
GROUP BY moq.organization_id, (moq.inventory_item_id)


-- ITEMS IN INVENTORY
SELECT MSIB.INVENTORY_ITEM_ID, 
            MP.ORGANIZATION_ID, 
            MP.ORGANIZATION_CODE, 
            MSIB.DESCRIPTION,
            MSIB.SEGMENT1 || ' ' || SEGMENT2 || ' ' || SEGMENT3 || ' ' || SEGMENT4 || ' ' || SEGMENT5 ITEM_NAME
FROM MTL_SYSTEM_ITEMS_B MSIB,
          MTL_PARAMETERS MP
WHERE MSIB.ORGANIZATION_ID = MP.ORGANIZATION_ID
    AND MP.ORGANIZATION_CODE = 'M1'
 
    
    
    
SELECT *
FROM MTL_PARAMETERS;


select *
from oe_order_headers_all ooha,
        oe_order_lines_all oola
where 1=1
    and ooha.header_id = oola.header_id;
    
XDOXT

SELECT *
FROM OE_ORDER_HEADERS_ALL;

SELECT ORDER_QUANTITY_UOM, PRICING_QUANTITY_UOM
FROM OE_ORDER_LINES_ALL



OE_ORDER_HEADERS_V

select *
from OE_PAYMENTS;

select *
from oe_actions;

select *
from OE_Price_Adjustments ;

select*
from OE_ACTIONS_IFACE_ALL;

Header Data: OE_ORDER_HEADERS_ALL
Lines Data: OE_ORDER_LINES_ALL
Payments Data: OE_PAYMENTS
Adjustments Data: OE_PRICE_ADJUSTMENTS
Holds Data: OE_ORDER_HOLDS_ALL
Order Sources: OE_ORDER_SOURCES
Sets data – Arrival Set, Ship Set, Fulfillment Set: OE_SETS
Transaction Types: OE_TRANSACTION_TYPES_TL.



select *
from XXQGEN_TEST_DK;


create table XXQGEN_TEST_DK
(id number,
name varchar2(2000),
phone number,
email varchar2(3000)
);

COMMON_UTILS_PKG_DK


SELECT *
FROM HZ_CUST_ACCOUNTS;

SELECT *
FROM DBA_OBJECTS
WHERE 1=1
    AND OBJECT_TYPE = 'PACKAGE'
    AND OBJECT_NAME LIKE 'OE_%HEADER%';
    
    
OE_VALIDATE_HEADER


SELECT  (LAST_DAY(SYSDATE) + 1, 'MONDAY') 
FROM DUAL;


CREATE OR REPLACE DIRECTORY ext_table_dir AS '/u01/data/external';


create or replace directory dir_test as '/dir_test/';

drop table EMPLOYEES_EXT_DK;

select *
from employees_ext_dk;


CREATE TABLE employees_ext_dk
   (   employee_id    NUMBER,
    employee_name  VARCHAR2(100),
    designation    VARCHAR2(50)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY DIR_AD
      ACCESS PARAMETERS
      ( FIELDS TERMINATED BY ',')
      LOCATION
       ( 'employees_data.csv'
       )
    )
   REJECT LIMIT unlimited ;
   
select *
from DBA_DIRECTORIES;

select *
from dba_objects
where object_name like 'DBA%DIR%S';
   
SELECT *
FROM all_directories
WHERE directory_name = 'DIR_TEST';

drop table xxqgen_load_ad3;

select *
from xxqgen_load_ad3;




SELECT *
FROM XXQGEN_TEST_DK;

TRUNCATE TABLE XXQGEN_TEST_DK;


SELECT * FROM HZ_PARTIES;

SELECT *
FROM DBA_OBJECTS
WHERE OBJECT_NAME LIKE '%INV%'
    AND OBJECT_TYPE LIKE '%TABLE%';
    
    
SELECT * FROM MSC_ITEM_INVENTORY_VL;

OE_ORDER_HEADERS_V 


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
                          
                          
-- INVENTORY DATA

SELECT *
FROM MTL_PARAMETERS;



-- CUSTOMER PREFRENCE SET CODE

SELECT *
FROM OE_LOOKUPS;


-- SHIPING MEHTOD 

oe_order_headers_all.shipping_method_code
wsh_trips.ship_method_code
wsh_new_deliveries.ship_method_code
wsh_delivery_details.ship_method_code
wsh_carrier_ship_methods
wsh_carrier_services


OE_ORDER_LINES_V

OE_LINE_PAYMENTS_V


SELECT *
FROM OE_ORDER_HEADERS_V
WHERE CREATED_BY = 1318;

SELECT *
FROM OE_ORDER_HEADERS_ALL
WHERE ORDER_NUMBER = 69382;    

SELECT  OOHA.HEADER_ID,
            OOHA.ORG_ID,
            HOU.NAME,
            OOHA.ORIG_SYS_DOCUMENT_REF,
            OOHA.ORDERED_DATE,
            OOHA.DEMAND_CLASS_CODE,
            OOHA.TRANSACTIONAL_CURR_CODE,
            OOHA.PAYMENT_TERM_ID,
            OOHA.SHIPPING_METHOD_CODE, 
            OOHA.FREIGHT_CARRIER_CODE,
            OOHA.FOB_POINT_CODE,
            OOHA.FREIGHT_TERMS_CODE,
            OOHA.SOLD_FROM_ORG_ID,
            OOHA.SOLD_TO_ORG_ID,
            OOHA.SHIP_FROM_ORG_ID,
            OOHA.SHIP_TO_ORG_ID,
            OOHA.INVOICE_TO_ORG_ID,
            OOHA.DELIVER_TO_ORG_ID,
            OOHA.SOLD_TO_CONTACT_ID,
            OOHA.SHIP_TO_CONTACT_ID,
            OOHA.INVOICE_TO_CONTACT_ID,
            OOHA.DELIVER_TO_CONTACT_ID,
            OOHA.SALESREP_ID,
            OOHA.ORDER_CATEGORY_CODE,
            OOHA.FLOW_STATUS_CODE,
            OOHA.BOOKED_DATE,
            OOHA.LOCK_CONTROL
--            OOHA.BUSINESS_GROUP_ID
--            OOHA.SET_OF_BOOKS_ID
FROM    OE_ORDER_HEADERS_ALL OOHA,
            HR_OPERATING_UNITS HOU,
            RA_CUSTOMER_TRX_ALL RCTA,
            HZ_CUST_ACCOUNTS HCA,
            HZ_PARTIES HP
WHERE 1=1
    AND OOHA.ORG_ID = HOU.ORGANIZATION_ID
    AND RCTA.CT_REFERENCE = TO_CHAR(OOHA.ORDER_NUMBER)
    AND HP.PARTY_ID = RCTA.SHIP_TO_CUSTOMER_ID
    AND HP.PARTY_ID = HCA.PARTY_ID
    AND OOHA.ORDER_NUMBER = 69382;                        

  -- 69381;
  
  
SELECT 
    hca.account_number,
    hp.party_name,
    rcta.trx_number,
    acra.receipt_number,
    rcta.trx_date,
    acra.creation_date,
    acra.amount
FROM 
    hz_parties hp,
    hz_cust_accounts hca,
    RA_CUSTOMER_TRX_ALL rcta,
    ar_cash_receipts_all acra,
    ar_receivable_applications_all araa
WHERE 
    hp.party_id = hca.party_id
    AND rcta.sold_to_customer_id = hca.cust_account_id
    AND araa.cash_receipt_id = acra.cash_receipt_id
    AND araa.applied_customer_trx_id = rcta.customer_trx_id
    AND account_number = '&account_number';




SELECT *
FROM FND_USER
WHERE USER_NAME LIKE 'OPER%';



SELECT *
FROM OE_ORDER_HEADERS_ALL;

SELECT *
FROM OE_ORDER_TYPES_ALL;


SELECT * 
FROM oe_processing_msgs opm, 
     oe_processing_msgs_tl opmt
WHERE opm.transaction_id = opmt.transaction_id
AND opm.original_sys_document_ref = '123456';  
--- where 123456 is the Order Number in the interface table.

--- Interface table information. 

SELECT * 
FROM oe_headers_iface_all;




--WHERE order_number = '123456';

SELECT * 
FROM oe_lines_iface_all 
WHERE orig_sys_document_ref = (SELECT orig_sys_document_ref 
                               FROM oe_headers_iface_all 
                               WHERE order_number = '123456');