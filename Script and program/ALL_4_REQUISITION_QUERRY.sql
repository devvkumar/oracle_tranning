select prha.requisition_header_id,
PRLA.LINE_NUM,
PRLA.PURCHASE_BASIS,
         prha.preparer_id,
         PAPFPRE.FULL_NAME,
         lub.user_name LAST_UPDATED_BY,
         cb.user_name CREATED_BY,
         PRHA.ORG_ID,
         HOU.NAME ORGANIZATION_NAME,
         PRHA.TYPE_LOOKUP_CODE,
         PRHA.AUTHORIZATION_STATUS,
         PLC1.DESCRIPTION,
         PLC1.DISPLAYED_FIELD,
         PRHA.DESCRIPTION,
         PRHA.ENABLED_FLAG,
         PRHA.SUMMARY_FLAG,
         PRHA.SEGMENT1,
         PRLA.REQUISITION_LINE_ID,
         PRLA.CATEGORY_ID,
         MC.SEGMENT1 || ' ' || MC.SEGMENT2 CATEGORY_NAME,
         PRLA.QUANTITY,
         PRLA.UNIT_PRICE,
         PRLA.QUANTITY * PRLA.UNIT_PRICE AMOUNT,
         PRLA.TO_PERSON_ID,
         PAPF.FULL_NAME,
         MSIB.SEGMENT1 || ' ' || MSIB.DESCRIPTION ITEM_ID,
         PRLA.ITEM_DESCRIPTION,
         PRLA.NEED_BY_DATE,
         PRLA.DELIVER_TO_LOCATION_ID,
         HLA.ADDRESS_LINE_1,
         HLA.DESCRIPTION,
         HLA.POSTAL_CODE,
         PRLA.LINE_NUM,
         PRDA.DISTRIBUTION_ID,
         PRDA.REQUISITION_LINE_ID,
         PRDA.SET_OF_BOOKS_ID,
         PRDA.DISTRIBUTION_NUM,
         PRLA.REQUEST_ID,
         gcc.ACCOUNT_TYPE,
         gcc.ENABLED_FLAG,
         gcc.SUMMARY_FLAG,
         gcc.COMPANY_COST_CENTER_ORG_ID
from 
        po_requisition_headers_all prha,
        po_requisition_lines_all prla,
        po_req_distributions_all prda,
        PER_ALL_PEOPLE_F PAPFPRE,
        fnd_user lub,
        fnd_user cb,
        HR_LOCATIONS_ALL HLA,
        PER_ALL_PEOPLE_F PAPF,
        HR_ORGANIZATION_UNITS HOU,
        MTL_CATEGORIES MC,
        MTL_SYSTEM_ITEMS_B MSIB,
        ORG_ORGANIZATION_DEFINITIONS OOD,
        GL_CODE_COMBINATIONS gcc,
        PO_LOOKUP_CODES PLC1
 --       PER_ALL_PEOPLE_F PAPFREQ
where
        1=1
and   prha.requisition_header_id = prla.requisition_header_id
and   prha.segment1 = '14438'
AND  PAPFPRE.PERSON_ID = PRHA.PREPARER_ID
and   prla.last_updated_by = lub.USER_id
and   prla.created_by = cb.USER_id
and   prda.requisition_line_id = prla.requisition_line_id
AND  PRLA.TO_PERSON_ID = PAPF.PERSON_ID
AND  HLA.LOCATION_ID = PRLA.DELIVER_TO_LOCATION_ID
AND  HOU.ORGANIZATION_ID = PRHA.ORG_ID
AND  PRHA.AUTHORIZATION_STATUS = PLC1.LOOKUP_CODE
AND  PLC1.LOOKUP_TYPE ='AUTHORIZATION STATUS'
AND  PRLA.CATEGORY_ID = MC.CATEGORY_ID
--AND  HLA.PERSON_ID = PRLA.DELIVER_TO_LOCATION_ID
AND  MSIB.INVENTORY_ITEM_ID = PRLA.ITEM_ID
AND  MSIB.ORGANIZATION_ID = OOD.ORGANIZATION_ID
AND  OOD.ORGANIZATION_ID = PRLA.ORG_ID
and   prda.code_combination_id = gcc.code_combination_id;
;



SELECT *
FROM PO_LOOKUP_CODES
WHERE LOOKUP_CODE = 'INCOMPLETE'
AND LOOKUP_TYPE ='AUTHORIZATION STATUS'
;

select *
from dba_objects
where object_name like 'HR%LOC%';

SELECT *
FROM HR_LOCATIONS_ALL
WHERE LOCATION_ID = 204;

select *
from  po_req_distributions_all;

select *
from gl_code_combinations;

select *
from  po_req_distributions_all prda,
        gl_code_combinations gcc
where prda.CODE_COMBINATION_ID = gcc.code_combination_id;

SELECT 
   
    --prda.deliver_to_location_id,
    --prda.quantity,
    --prda.amount,
    --prda.gl_encumbrance_id,
    --prda.charge_account_id,
    prda.budget_account_id,
    --prda.status_code,
    gcc.code_combination_id,
    gcc.segment1 AS company_code,
    gcc.segment2 AS cost_center,
    gcc.segment3 AS account,
    gcc.segment4 AS sub_account,
    gcc.segment5 AS product_code,
    gcc.description AS gl_account_description
FROM 
    po_req_distributions_all prda,
    gl_code_combinations gcc
WHERE 
    prda.code_combination_id = gcc.code_combination_id;

SELECT *
FROM ORG_ORGANIZATION_DEFINITIONS;
ORG_ORGANISATION_DEFINATIONS


ORG_ORGANIZATION_DEFINATIONS
ORG_ORGANIZATION_DEFINITIONS

SELECT *
FROM TABS
WHERE TABLE_NAME LIKE '%ORG_%_OR%_D';

SELECT *
FROM MTL_SYSTEM_ITEMS_B;
select *
from 
        po_requisition_headers_all prha,
        po_requisition_lines_all prla,
        po_req_distributions_all prda
where
        1=1
and   prha.requisition_header_id = prla.requisition_header_id
and   prha.segment1 = '14438'
and   prda.requisition_line_id = prla.requisition_line_id;

select *
from po_requisition_headers_all;

SELECT *
FROM MTL_CATEGORIES
WHERE CATEGORY_ID = 1;

select *
from po_requisition_lines_all;

select *
from po_req_distributions_all;

select *
from fnd_user
where user_id = 1318;

select *
from ap_suppliers
where vendor_id = 30163;

select org_id, hou.name
from ap_supplier_sites_all assa,
        hr_operating_units hou
where vendor_id = 30163
and    HOU.ORGANIZATION_ID = assa.org_id;

SELECT *
FROM MTL_SYSTEM_ITEMS_B;

GL_CODE_COMBINATIONS

hr_operating_units

select *
from ap_supplier_sites_all;



select assa.vendor_id, assa.vendor_site_code, ass.vendor_name ,count(assa.vendor_id)
from ap_supplier_sites_all assa, ap_suppliers ass
where
            assa.vendor_id = ass.vendor_id
group by assa.vendor_id, assa.vendor_site_code, ass.vendor_name
having count(assa.vendor_id) >1;

select * from po_requisition_lines_all;

--question : vendor all data from ap_supplier_sites_all, ap_supplier without using group by
-- HOW MANY PARAMETER CAN BE ENTER IN CONCURRENT PROGRAM
-- FETCH PARAMETER WHICH IS CONNECTED WITH CONCURRENT PROGRAM FROM THE SQL QUERRY
-- PRINT PATAMETER WHICH IS USED IN CONCUREENT PROGRAM

SELECT REQUISITION_HEADER_IDLINE_NUMLINE_TYPE_IDCATEGORY_IDITEM_DESCRIPTIONUNIT_MEAS_LOOKUP_CODEUNIT_PRICEQUANTITYDELIVER_TO_LOCATION_IDTO_PERSON_IDLAST_UPDATED_BYCREATED_BYORG_IDREQUISITION_HEADER_IDREQUISITION_LINE_ID
FROM po_requisition_lines_all;


select prha.requisition_header_id
,prla.line_num
,prla.requisition_line_id
,mc.category_id
,papf.full_name
,mc.segment2
,prla.unit_meas_lookup_code
,prla.unit_price
,prla.quantity
,prla.unit_price*prla.quantity Amount
,prla.need_by_date
,msib.segment1
,msib.description
,ood.organization_code
,ood.organization_name
,prla.to_person_id
,hl.location_code
,plt.line_type
from po_requisition_lines_all prla
,po_requisition_headers_all prha
,mtl_categories mc
,per_all_people_f papf
,mtl_system_items_b msib
,org_organization_definitions ood
,hr_locations hl
,po_line_types plt
where prla.requisition_header_id=prha.requisition_header_id
and mc.category_id=prla.category_id
and msib.inventory_item_id=prla.item_id
and prla.to_person_id=papf.person_id
and ood.organization_id=msib.organization_id
and ood.organization_id = prla.org_id
and prla.deliver_to_location_id=hl.location_id
and prla.line_type_id=plt.line_type_id
and prha.segment1 = '14438'
and PRLA. -- ADD EXIST CODE
;

DESC FND_USER;
PER_ALL_PEOPLE_F
FND_FLEX_VALUE_SET

SELECT *
FROM MTL_SYSTEM_ITEMS_B
WHERE segment1 = 'P2P Cycle';

SELECT *
FROM PO_REQUISITION_LINES_ALL
WHERE ITEM_ID = 210959;



SELECT 
    PRD.REQ_LINE_QUANTITY
    ,GCC.CHART_OF_ACCOUNTS_ID
    ,GCC.SEGMENT1||'-'||GCC.SEGMENT2||'-'||GCC.SEGMENT3||'-'||GCC.SEGMENT4||'-'||GCC.SEGMENT5 ACCOUNT_DETAIL
FROM 
    PO_REQ_DISTRIBUTIONS_ALL PRD
    ,GL_CODE_COMBINATIONS GCC
    ,PO_REQUISITION_LINES_ALL PRL
    ,PO_REQUISITION_HEADERS_ALL PRH
WHERE
    PRD.CODE_COMBINATION_ID=GCC.CODE_COMBINATION_ID
    AND PRL.REQUISITION_LINE_ID=PRD.REQUISITION_LINE_ID
    AND PRL.REQUISITION_HEADER_ID=PRH.REQUISITION_HEADER_ID
    AND PRH.SEGMENT1='14438';
    
    select prha.requisition_header_id,
         prha.preparer_id,
         PAPFPRE.FULL_NAME PREPARER_FULL_NAME,
         lub.user_name LAST_UPDATED_BY,
         cb.user_name CREATED_BY,
         PRHA.ORG_ID,
         HOU.NAME ORGANIZATION_NAME,
         PRHA.TYPE_LOOKUP_CODE,
         PRHA.AUTHORIZATION_STATUS AUTH_STATUS,
         PLC1.DESCRIPTION,
         PLC1.DISPLAYED_FIELD,
         PRHA.DESCRIPTION HEADER_DESC,
         PRHA.ENABLED_FLAG,
         PRHA.SUMMARY_FLAG,
         PRHA.SEGMENT1,
         PRLA.REQUISITION_LINE_ID,
         PRLA.CATEGORY_ID,
         PRLA.PURCHASE_BASIS,
         MC.SEGMENT1 || ' ' || MC.SEGMENT2 CATEGORY_NAME,
         PRLA.QUANTITY,
         PRLA.UNIT_PRICE,
         PRLA.QUANTITY * PRLA.UNIT_PRICE AMOUNT,
         PRLA.TO_PERSON_ID,
         PAPF.FULL_NAME REQ_PERSON,
         MSIB.SEGMENT1 || ' ' || MSIB.DESCRIPTION ITEM_ID,
         PRLA.ITEM_DESCRIPTION,
         PRLA.DESTINATION_TYPE_CODE,
         PRLA.NEED_BY_DATE,
         PRLA.DELIVER_TO_LOCATION_ID,
         HLA.ADDRESS_LINE_1,
         HLA.DESCRIPTION LOC_DESC,
         HLA.POSTAL_CODE,
         PRLA.LINE_NUM,
         PRDA.DISTRIBUTION_ID,
         PRDA.REQUISITION_LINE_ID,
         PRDA.SET_OF_BOOKS_ID,
         PRDA.DISTRIBUTION_NUM,
         PRLA.REQUEST_ID,
         gcc.ACCOUNT_TYPE,
         gcc.ENABLED_FLAG,
         gcc.SUMMARY_FLAG,
         gcc.COMPANY_COST_CENTER_ORG_ID,
         GCC.SEGMENT1||'-'||GCC.SEGMENT2||'-'||GCC.SEGMENT3||'-'||GCC.SEGMENT4||'-'||GCC.SEGMENT5 ACCOUNT_DETAIL
from 
        po_requisition_headers_all prha,
        po_requisition_lines_all prla,
        po_req_distributions_all prda,
        PER_ALL_PEOPLE_F PAPFPRE,
        fnd_user lub,
        fnd_user cb,
        HR_LOCATIONS_ALL HLA,
        PER_ALL_PEOPLE_F PAPF,
        HR_ORGANIZATION_UNITS HOU,
        MTL_CATEGORIES MC,
        MTL_SYSTEM_ITEMS_B MSIB,
        ORG_ORGANIZATION_DEFINITIONS OOD,
        GL_CODE_COMBINATIONS gcc,
        PO_LOOKUP_CODES PLC1
 --       PER_ALL_PEOPLE_F PAPFREQ
where
        1=1
and   prha.requisition_header_id = prla.requisition_header_id
and   prha.segment1 = '14438'
AND  PAPFPRE.PERSON_ID = PRHA.PREPARER_ID
and   prla.last_updated_by = lub.USER_id
and   prla.created_by = cb.USER_id
and   prda.requisition_line_id = prla.requisition_line_id
AND  PRLA.TO_PERSON_ID = PAPF.PERSON_ID
AND  HLA.LOCATION_ID = PRLA.DELIVER_TO_LOCATION_ID
AND  HOU.ORGANIZATION_ID = PRHA.ORG_ID
AND  PRHA.AUTHORIZATION_STATUS = PLC1.LOOKUP_CODE
AND  PLC1.LOOKUP_TYPE ='AUTHORIZATION STATUS'
AND  PRLA.CATEGORY_ID = MC.CATEGORY_ID
--AND  HLA.PERSON_ID = PRLA.DELIVER_TO_LOCATION_ID
AND  MSIB.INVENTORY_ITEM_ID = PRLA.ITEM_ID
AND  MSIB.ORGANIZATION_ID = OOD.ORGANIZATION_ID
AND  OOD.ORGANIZATION_ID = PRLA.ORG_ID
and   prda.code_combination_id = gcc.code_combination_id;