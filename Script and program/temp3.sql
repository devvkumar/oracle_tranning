SELECT USER_ID, USER_NAME, START_DATE, END_DATE
FROM FND_USER
WHERE 1=1
AND     USER_NAME = 'DKUMAR'
AND      END_DATE IS NULL;

SELECT USER_ID, USER_NAME, START_DATE, END_DATE
FROM FND_USER
WHERE USER_NAME = 'DKUMAR'
AND     TRUNC(SYSDATE) BETWEEN START_DATE AND NVL(END_DATE, TRUNC(SYSDATE));


select person_id
from per_all_people_f
group by person_id

po_requisition_headers_all=> preparteid = person_id papf,
line_all

14338

;

select *
from po_requisition_headers_all
where segment1 = '14438';

select *
from all_objects
where lower(object_name) like '%document%id';


select *
from po_requisition_header_all;


select *
from  po_requisition_headers_all ;


select prha.segment1 "NUMBER", 
         prha.REQUISITION_HEADER_ID,
         prha.preparer_id, 
         papf.full_name "Preparer Name",
         fu.last_updated_by, 
         fu.created_by, 
         prha.description,
         prha.type_lookup_code Type,
         plc.LOOKUP_CODE,
         plc.LOOKUP_TYPE,
         prha.AUTHORIZATION_STATUS Status,
         HOU.NAME "Operating Unit",
         pdtav.DOCUMENT_SUBTYPE,
         pdtav.DOCUMENT_TYPE_CODE,
         pdtav.ORG_ID,
         START_DATE_ACTIVE,
END_DATE_ACTIVE,
INTERFACE_SOURCE_LINE_ID,
PREPARER_FINISHED_DATE,
CLOSED_CODE,
INTERFACE_SOURCE_CODE,
CANCEL_FLAG,
ENABLED_FLAG,
SUMMARY_FLAG,
REVISION_NUM,
AGENT_RETURN_NOTE
         
         
from 
        fnd_user fu,
        per_all_people_f papf,
        po_requisition_headers_all prha,
        po_document_types_all_vl pdtav,
        po_lookup_codes plc,
        hr_operating_units hou
        
where 1=1
--and  prha.SEGMENT1 = '14438'
AND PRHA.LAST_UPDATED_BY = FU.USER_ID
AND PRHA.CREATED_BY = FU.USER_ID
and prha.PREPARER_ID = papf.person_id
and pdtav.document_subtype = prha.type_lookup_code
and lower(pdtav.DOCUMENT_TYPE_CODE) = 'requisition'
and pdtav.org_id = prha.org_id
and plc.lookup_code = prha.AUTHORIZATION_STATUS
AND PLC. LOOKUP_TYPE ='AUTHORIZATION STATUS'
and hou.organization_id = prha.org_id
AND PRHA.SEGMENT1='14438'
;

select *
from hr_operating_units

fnd_profile = values('org_id');
/
select *
from  po_lookup_codes 
where lookup_code = 'APPROVED'
and    LOOKUP_type like 'a%thorization status';

select 
    START_DATE_ACTIVE,
END_DATE_ACTIVE,
INTERFACE_SOURCE_LINE_ID,
PREPARER_FINISHED_DATE,
CLOSED_CODE,
INTERFACE_SOURCE_CODE,
CANCEL_FLAG,
ENABLED_FLAG,
SUMMARY_FLAG,
REVISION_NUM,
AGENT_RETURN_NOTE
from po_requisition_headers_all;


po_requisition_lines_all
req_header_id --------------> po_req_header_Id
req_line_Id
line_number
categoryid ---------------> mtl_categories--------------------------segmemt1,2
uom unit_mes_lookupcode
unit price
quantity
amount
to_person_id
item_id ------------------------> mtl_systems_item_b(inventery_item_id) 
destination_org_od -------------> || org id
reqestor(yo_person_id)
delever to location_id ---------------------------------> hr_location

line_type_id ---------------------------------------> po_line_type-------------------->line type

need_by_date


po_req_distributon_all
req_line id --------------------> po_requisition_lines_all
distribution no
org_id ---------------------------> hr_op
code_combination_id ----------------------------->  gl_code_combination ----------------------------> charge acc

