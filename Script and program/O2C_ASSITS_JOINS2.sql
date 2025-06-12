--Sales order and lines details query

  SELECT ooha.order_number,
         ott.name order_type,
         ooha.cust_po_number,
         ooha.fob_point_code     fob,
         ooha.flow_status_code   "Order Status",
         ooha.ordered_date,
         ooha.booked_date,
         ooha.org_id,
         hcasa.cust_acct_site_id,
         hp.party_name           "Customer Name",
         hps.party_site_number   "Ship to site number",
         hl.city                 "Customer City",
         hl.state                "Customer State",
         hl.country              "Customer Country",
         ft.nls_territory        "Region",
         hpb.party_name          "Bill Customer Name",
         hpsb.party_site_number  "Bill to site number",
         hlb.city                "Bill Customer City",
         hlb.state               "Bill Customer State",
         hlb.country             "Bill Customer Country",
         ftb.nls_territory       "Bill Region",
         organization_code       "Inventory Org",
         oola.line_number,
         oola.actual_shipment_date "Actual Ship Date",
         oola.ordered_item       "Item#/Part#",
         oola.flow_status_code   "Line Status",
         msib.description        "Item Description",
         oola.source_type_code   "Source Type",
         oola.schedule_ship_date,
         oola.pricing_quantity   "Quantity",
         oola.pricing_quantity_uom "UOM"
    FROM apps.oe_order_headers_all       ooha,
         apps.oe_order_lines_all         oola,
         apps.mtl_system_items_b         msib,
         -----
         apps.org_organization_definitions ood,
         apps.hz_cust_site_uses_all      hcsua,
         apps.hz_cust_acct_sites_all     hcasa,
         apps.hz_party_sites             hps,
         apps.hz_locations               hl,
         apps.hz_parties                 hp,
         apps.fnd_territories            ft,
         ------
         apps.hz_cust_site_uses_all      hcsuab,
         apps.hz_cust_acct_sites_all     hcasab,
         apps.hz_party_sites             hpsb,
         apps.hz_locations               hlb,
         apps.hz_parties                 hpb,
         apps.fnd_territories            ftb,
         apps.oe_transaction_types_tl    ott
   WHERE     1 = 1
         AND ooha.header_id = oola.header_id
         AND ooha.org_id = oola.org_id
         AND oola.ordered_item = msib.segment1
         AND ooha.ship_from_org_id = msib.organization_id
         --
         AND ooha.ship_from_org_id = ood.organization_id(+)
         AND ooha.ship_to_org_id = hcsua.site_use_id(+)
         AND hcsua.cust_acct_site_id = hcasa.cust_acct_site_id(+)
         AND hcasa.party_site_id = hps.party_site_id(+)
         AND hps.location_id = hl.location_id(+)
         AND hps.party_id = hp.party_id(+)
         AND hl.country = ft.territory_code(+)
         --
         AND ooha.invoice_to_org_id = hcsuab.site_use_id
         AND hcsuab.cust_acct_site_id = hcasab.cust_acct_site_id
         AND hcasab.party_site_id = hpsb.party_site_id
         AND hpsb.location_id = hlb.location_id
         AND hpsb.party_id = hpb.party_id
         AND hlb.country = ftb.territory_code
         --
         AND ott.language = 'US'
         AND ott.transaction_type_id = ooha.order_type_id
         AND ooha.order_number = '1235513'
ORDER BY ooha.order_number, oola.line_number;



SELECT HP.PARTY_NAME, OOHA.*
FROM OE_ORDER_HEADERS_ALL OOHA,
         HZ_CUST_ACCOUNTS HCA,
         RA_CUSTOMER_TRX_ALL RCTA,
         HZ_PARTIES HP
WHERE 1=1
    AND OOHA.SHIP_TO_CONTACT_ID = HCA.CUST_ACCOUNT_ID
    AND HP.PARTY_ID = HCA.PARTY_ID
    AND OOHA.ORDER_NUMBER = 57166;
    
    
    SELECT SHIP_TO_CONTACT_ID
    FROM OE_ORDER_HEADERS_ALL
    WHERE ORDER_NUMBER = 69382;
    
SELECT *
FROM HZ_CUST_ACCOUNTS
WHERE CUST_ACCOUNT_ID = 1108;


-- to get the customer name 
select hp.party_name, ooha.*
from oe_order_headers_all ooha,
        ra_customer_trx_all rcta,
        hz_cust_accounts hca,
        hz_parties hp
where 1=1
    and rcta.ct_reference = to_char(ooha.order_number)
    and hca.cust_account_id = rcta.sold_to_customer_id
    and hca.party_id = hp.party_id
    and ooha.order_number = 57166;
    
    
    
Introduction:
-- SQL Query
--This query is used to fetch the data of customer name and also the details like the account number, addresses, city, country, postal code and customer account id. In this CUST_NAME is used as a parameter so that fetching of data will be done based on the parameter value we pass to the query.


SELECT p.PARTY_NAME,
ca.ACCOUNT_NUMBER,
loc.address1,
loc.address2,
loc.address3,
loc.city,
loc.postal_code,
loc.country,
ca.CUST_ACCOUNT_ID
FROM apps.ra_customer_trx_all I,
apps.hz_cust_accounts CA,
apps.hz_parties P,
apps.hz_locations Loc,
apps.hz_cust_site_uses_all CSU,
apps.hz_cust_acct_sites_all CAS,
apps.hz_party_sites PS
WHERE I.COMPLETE_FLAG    ='Y'
AND I.bill_TO_CUSTOMER_ID= CA.CUST_ACCOUNT_ID
AND ca.PARTY_ID          =p.PARTY_ID
AND I.bill_to_site_use_id=csu.site_use_id
AND csu.CUST_ACCT_SITE_ID=cas.CUST_ACCT_SITE_ID
AND cas.PARTY_SITE_ID    =ps.party_site_id
AND ps.location_id       =loc.LOCATION_ID
AND p.PARTY_NAME         = <CUST_NAME> ;

 

select *
from per_all_people_f;


select emp.*, avg(sal) over(partition by employee_id)
from employees emp;



declare

    dyn_querry              varchar2(3000);
    dyn_querry2              varchar2(3000);
    drop_query              varchar2(3000);
     
begin

    dyn_querry := 'create table test1_dynamic_query_dk (a1  number, a2  number)';
    dyn_querry2 := 'create table test1_dynamic_query_dk2 (a1  number, a2  number)';  
    drop_query := 'drop table test1_dynamic_query_dk2';  
    execute immediate dyn_querry;
    
    execute immediate 'drop table test1_dynamic_query_dk';
    
    execute immediate dyn_querry2;
    
--    execute immediate drop_query;

    
    
exception
    when others then
        dbms_output.put_line('error : ' || sqlerrm || sqlcode);

end;
/


select *
from test1_dynamic_query_dk;

select *
from test1_dynamic_query_dk2;

drop table test1_dynamic_query_dk2;

