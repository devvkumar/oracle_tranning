-- 1st Query
SELECT 
    RQHA.SEGMENT1,
    PAPF.PERSON_ID PREPARER_ID,
    FU.USER_ID LAST_UPDATED_BY,
    FU.USER_NAME CREATED_BY,
    RQHA.DESCRIPTION,
    RQHA.TYPE_LOOKUP_CODE TYPEE,
    PLC.LOOKUP_CODE,
    HOU.ORGANIZATION_ID ORG_ID
FROM
    PO_REQUISITION_HEADERS_ALL RQHA,
    PER_ALL_PEOPLE_F PAPF,
    FND_USER FU,
    PO_DOCUMENT_TYPES_ALL_VL PDT,
    PO_LOOKUP_CODES PLC,
    HR_OPERATING_UNITS HOU
WHERE
    RQHA.PREPARER_ID=PAPF.PERSON_ID
   AND RQHA.LAST_UPDATED_BY = FU.USER_ID
   AND RQHA.AUTHORIZATION_STATUS =PLC. LOOKUP_CODE
   AND PLC. LOOKUP_TYPE ='AUTHORIZATION STATUS'
   AND RQHA.TYPE_LOOKUP_CODE=PDT.DOCUMENT_SUBTYPE
   AND RQHA.ORG_ID=PDT.ORG_ID
   AND PDT.DOCUMENT_TYPE_CODE = 'REQUISITION'
   AND RQHA.ORG_ID=HOU.ORGANIZATION_ID
   AND RQHA.SEGMENT1='14438'
;

-- 2nd query
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
and prha.segment1 = '14438';

-- 3rd query
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
    AND PRH.SEGMENT1='14438'  
    ;

-- 4th Query
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