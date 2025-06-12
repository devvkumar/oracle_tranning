<?xml version="1.0" encoding="UTF-8"?>
<dataTemplate name="XXQGEN_RECEAVABLE_NK" version="1.0">
  <properties>
    <property name="xml_tag_case" value="upper"/>
    <property name="debug_mode" value="on"/>
  </properties>

  <parameters>
    <parameter name="P_trx_num" dataType="characters"/>
  </parameters>

  <dataQuery>
    <sqlStatement name="Q_header">
      <![CDATA[
        SELECT  rcta.CUSTOMER_TRX_ID,
  rcta.TRX_NUMBER,
    rcta.TRX_DATE,
    rcta.PURCHASE_ORDER,
    rcta.SHIP_DATE_ACTUAL ship_date,
    oeh.order_number AS SALES_ORDER_NUMBER,
    hca.ACCOUNT_NUMBER AS CUSTOMER_NUMBER,
    NVL(hp.known_as, hp.party_name) customer_name,
    hca.account_number,
    hou.short_code OU_SHORT_CODE,
    hl.location_code OU_CODE,
    hl.address_line_1 OU_ADD,

    -- BILL TO
    hcsua.location BILL_TO,
    hlA.address1 BILL_TO_ADDSES,
    hlA.address_key BILL_TO_ADDRESS,

    -- SHIP TO
    hcsua1.location SHIP_TO,
    hl1.address1 SHIP_TO1,
    hl1.address_key SHIP_TO2,

    rt.name AS payment_terms,
    apsa.due_date,
    rsr.name AS salesperson_name,

    -- CUSTOMER CONTACT SUBQUERY
    (
        SELECT 
            NVL(hp_cust.known_as, hp_cust.party_name) || ' ' || hp_contact.party_name || ' ' || 
            hcp.phone_number || ' ' || hcp.email_address
        FROM 
            hz_cust_accounts hca2,
            hz_parties hp_cust,
            hz_relationships rel,
            hz_parties hp_contact,
            hz_contact_points hcp
        WHERE  
            rcta.bill_to_customer_id = hca2.cust_account_id
            AND hca2.party_id = hp_cust.party_id
            AND hp_cust.party_id = rel.subject_id
            AND rel.object_id = hp_contact.party_id
            AND hp_contact.party_id = hcp.owner_table_id
            AND rel.relationship_code = 'CONTACT'
            AND hp_contact.party_type = 'PERSON'
            AND hcp.contact_point_type IN ('PHONE', 'EMAIL')
            AND ROWNUM = 1
    ) AS CUSTOMER_CONTACT,

    -- SHIPMENT INFO
    (SELECT wnd.ship_method_code
     FROM wsh_delivery_details wdd,
          wsh_delivery_assignments wda,
          wsh_new_deliveries wnd
     WHERE wdd.delivery_detail_id = wda.delivery_detail_id
       AND wda.delivery_id = wnd.delivery_id
       AND wdd.source_header_id = oeh.header_id
       AND ROWNUM = 1) AS SHIP_VIA,

    (SELECT wnd.name
     FROM wsh_delivery_details wdd,
          wsh_delivery_assignments wda,
          wsh_new_deliveries wnd
     WHERE wdd.delivery_detail_id = wda.delivery_detail_id
       AND wda.delivery_id = wnd.delivery_id
       AND wdd.source_header_id = oeh.header_id
       AND ROWNUM = 1) AS SHIPPING_REFERENCE,

    -- REMIT TO
    RAA_REMIT_LOC.ADDRESS1 remit_to,
    RAA_REMIT_LOC.ADDRESS2 remit_to2,
    RAA_REMIT_LOC.ADDRESS3 remit_to3,
    RAA_REMIT_LOC.CITY remit_city,
    
    
    RAA_REMIT_LOC.COUNTY remit_country,
    RAA_REMIT_LOC.STATE remit_state,
    RAA_REMIT_LOC.POSTAL_CODE remit_postal

FROM
    RA_CUSTOMER_TRX_ALL rcta,
    OE_ORDER_HEADERS_ALL oeh,
    HZ_CUST_ACCOUNTS hca,
    hz_cust_accounts ha,
    hz_parties hp,
    hr_operating_units hou,
    hr_organization_units hou2,
    hr_locations hl,
    hz_cust_site_uses_all hcsua,
    hz_cust_acct_sites_all hcasa,
    hz_party_sites hps,
    hz_locations hlA,
    hz_cust_site_uses_all hcsua1,
    hz_cust_acct_sites_all hcasa1,
    hz_party_sites hps1,
    hz_locations hl1,
    ra_terms rt,
    ar_payment_schedules_all apsa,
    ra_salesreps_all rsr,
    HZ_CUST_ACCT_SITES_ALL RAA_REMIT,
    HZ_PARTY_SITES RAA_REMIT_PS,
    HZ_LOCATIONS RAA_REMIT_LOC

WHERE 
    rcta.interface_header_attribute1 = TO_CHAR(oeh.order_number)
    AND rcta.org_id = oeh.org_id
    AND rcta.BILL_TO_CUSTOMER_ID = hca.CUST_ACCOUNT_ID
    AND ha.party_id = hp.party_id
    AND ha.cust_account_id = rcta.bill_to_customer_id
    AND hou2.location_id = hl.location_id
    AND hou2.organization_id = hou.organization_id
    AND rcta.org_id = hou.organization_id
    AND hps.location_id = hlA.location_id
    AND hps.party_site_id = hcasa.party_site_id
    AND hcsua.cust_acct_site_id = hcasa.cust_acct_site_id
    AND hcsua.site_use_code = 'BILL_TO'
    AND hcsua.site_use_id = rcta.bill_to_site_use_id
    AND hps1.location_id = hl1.location_id
    AND hps1.party_site_id = hcasa1.party_site_id
    AND hcsua1.cust_acct_site_id = hcasa1.cust_acct_site_id
    AND hcsua1.site_use_code = 'SHIP_TO'
    AND hcsua1.site_use_id = rcta.ship_to_site_use_id
    AND rcta.term_id = rt.term_id
    AND rcta.customer_trx_id = apsa.customer_trx_id
    AND rcta.PRIMARY_SALESREP_ID = rsr.SALESREP_ID
    AND rcta.remit_to_address_id = RAA_REMIT.cust_acct_site_id(+)
    AND RAA_REMIT.party_site_id = RAA_REMIT_PS.party_site_id(+)
    AND RAA_REMIT_LOC.location_id = RAA_REMIT_PS.location_id;

       SELECT 
    rcta.trx_number,
    rctla.line_number,
    msib.segment1 AS item_number,
    rctla.description,
     rctla.quantity_invoiced AS ship_qt,
    oela.ordered_quantity AS order_qt,
    rctla.unit_selling_price AS unit_price,
    rctla.extended_amount,
     zls.tax_currency_code AS currency,
    rcta.exchange_rate,
    zls.tax,
    zls.tax_rate tax_perce,
    zls.TAX_AMT gst,
    SUM(rctla.unit_selling_price * rctla.quantity_invoiced) Amoun_before_gst,
    sUM((rctla.unit_selling_price * rctla.quantity_invoiced )+ zls.tax_amt) AS total_amt,
    sum(rctla.extended_amount*rcta.exchange_rate) amount_gst,
      zls.TAX_AMT gst2,
       sum((rctla.extended_amount*rcta.exchange_rate)+zls.TAX_AMt)  total_amt_2
FROM
    ra_customer_trx_all rcta,
    ra_customer_trx_lines_all rctla,
     oe_order_lines_all oela,
    mtl_system_items_b msib,
    zx_lines zls
WHERE
    rcta.customer_trx_id = rctla.customer_trx_id
    AND rctla.inventory_item_id = msib.inventory_item_id
    AND rctla.org_id = msib.organization_id
    AND rctla.interface_line_attribute1 = to_char(oela.line_id)
    and zls.trx_id(+)= rcta.customer_trx_id
    and zls.TrX_LINE_NUMBER=rctla.line_number
   group by rcta.trx_number,
    rctla.line_number,
    msib.segment1,
    rctla.description,
     rctla.quantity_invoiced,
    oela.ordered_quantity,
    rctla.unit_selling_price ,
    rctla.extended_amount,
    zls.tax_currency_code,
    rcta.exchange_rate,
     zls.tax_rate,
      zls.tax_amt,
      zls.tax,
    zls.tax_rate
    order by line_number



select *
from RA_CUST_TRX_LINE_GL_DIST_ALL;

SELECT *
FROM GL_CODE_COMBINATIONS
WHERE SEGMENT2 IS NULL;

select *
from dba_objects
where object_name like 'RA_CUSTOMER%'
    and object_type = 'TABLE';
    
    
    select *
    from fnd_responsibility_vl frv,
            fnd_concurrent_programs_vl fcpv
    where frv.application_id = fcpv.application_id
       and fcpv.CONCURRENT_PROGRAM_NAME = 'XXQGEN_ITEM_CREATION_AR'
    
    select *
    from fnd_concurrent_requests_vl
    

select *
from AR_INV_HEADER_DK;

SELECT *
FROM oe_transaction_types_all  ;

SELECT *
FROM AR_INV_LINE_DK;

select *
from ar_inv_dist_dk;

--truncate table ar_inv_header_dk;
--
--truncate table ar_inv_line_dk;
--
--truncate table ar_inv_dist_dk;

SELECT *
FROM DBA_OBJECTS
WHERE OBJECT_NAME LIKE '%TRA%TYPES%'
--    AND OWNER = 'AR'; 

SELECT *
FROM OE_TRANSACTION_TYPES_TL
WHERE UPPER(NAME) = 'ORDER';

SELECT XXQGEN_AR_INV_BATCH_ID.CURRVAL
FROM DUAL;

SELECT  HCAA.CUST_ACCOUNT_ID, HCAA.ACCOUNT_NUMBER, CUST_ACCT_SITE_ID, HCP.CONTACT_POINT_ID,hp.*
        FROM HZ_CUST_ACCOUNTS_ALL HCAA,
                 HZ_CUST_ACCT_SITES_ALL HCASA,
                 HZ_PARTIES HP,
                 HZ_CONTACT_POINTS HCP
        WHERE 1=1
            AND HCAA.PARTY_ID = HP.PARTY_ID
            AND HCAA.CUST_ACCOUNT_ID = HCASA.CUST_ACCOUNT_ID
            AND HCP.OWNER_TABLE_ID = HP.PARTY_ID
            AND UPPER(HP.PARTY_NAME) = UPPER(TRIM('World of Business'))
            AND ROWNUM < 2;

------------------ TRX TYPE ---------------
SELECT *
FROM RA_CUST_TRX_TYPES_ALL;


--------------- LEGAL ENTITY ------------
SELECT *
FROM XLE_ENTITY_PROFILES;

-------------- SALESPERSON ---------------
SELECT *
FROM jtf_rs_salesreps
WHERE NAME = 'Abbott, Ms. Rachel (Rachel)';

------------- CLASS NAME -----------------
SELECT *
FROM HZ_CUST_PROFILE_CLASSES
WHERE NAME = 'Invoice';

SELECT *
FROM RA_REMIT_TOS_ALL;

------------- SALESPERSON WITH ASSOCIATED SALES ORDER --------------
SELECT oha.order_number,
       jrre.resource_name SALES_PERSON,
       jrre.source_email,
       jrs.name
FROM   oe_order_headers_all OHA,
       jtf_rs_salesreps jrs,
       jtf_rs_resource_extns_vl JRRE
WHERE  1 = 1
       AND oha.salesrep_id = jrs.salesrep_id
       AND JRS.resource_id = JRRE.resource_id
       AND oha.order_number = :order_number; 


---------------- LEGAL ENTITY, COMPANY AND ORGANIZATION ---------------
SELECT
       xep.legal_entity_id        "Legal Entity ID",
       xep.name                   "Legal Entity",
       hr_outl.name               "Organization Name",
       hr_outl.organization_id    "Organization ID",
       hr_loc.location_id         "Location ID",
       hr_loc.country             "Country Code",
       hr_loc.location_code       "Location Code",
       glev.flex_segment_value    "Company Code"
  FROM
       xle_entity_profiles            xep,
       xle_registrations              reg,
       --
       hr_operating_units             hou,
       -- hr_all_organization_units      hr_ou,
       hr_all_organization_units_tl   hr_outl,
       hr_locations_all               hr_loc,
       --
       gl_legal_entities_bsvs         glev
 WHERE
       1=1
   AND xep.transacting_entity_flag   =  'Y'
   AND xep.legal_entity_id           =  reg.source_id
   AND reg.source_table              =  'XLE_ENTITY_PROFILES'
   AND reg.identifying_flag          =  'Y'
   AND xep.legal_entity_id           =  hou.default_legal_context_id
   AND reg.location_id               =  hr_loc.location_id
   AND xep.legal_entity_id           =  glev.legal_entity_id
   --
   -- AND hr_ou.organization_id         =  hou.business_group_id
   AND hr_outl.organization_id       =  hou.organization_id
 ORDER BY hr_outl.name;
 
 
SELECT *
FROM DBA_OBJECTS
WHERE OBJECT_TYPE = 'PACKAGE';

XXQGEN_ITEM_CREATION_AR.MAIN

SELECT *
FROM RA_CUST_LINES_DIST_TRX_ALL;