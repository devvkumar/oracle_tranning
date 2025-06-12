SELECT PHA.PO_HEADER_ID,
        PHA.SEGMENT1,
       PHA.CREATED_BY,
       PHA.REVISION_NUM,
       PHA.CLOSED_DATE,
       PLA.LINE_NUM,
       PLA.PO_LINE_ID,
       PLA.ITEM_ID,
       PLA.ITEM_REVISION,
       MSIB.SEGMENT1,
       MSIB.DESCRIPTION,
       PLTV.LINE_TYPE,
       PLTV.PURCHASE_BASIS,
       PLLA.SHIPMENT_TYPE,
       PLLA.CLOSED_CODE,
       PLLA.NEED_BY_DATE,
       MC.SEGMENT1 || MC.SEGMENT2,
       OOD.ORGANIZATION_NAME
  FROM po_headers_all PHA,
       FND_USER FU,
       FND_USER FU2,
       PER_ALL_PEOPLE_F PAPF,
       PO_LOOKUP_CODES PLC,
       HR_OPERATING_UNITS HOU,
       AP_SUPPLIERS ASS,
       AP_SUPPLIER_SITES_ALL ASSA,
       AP_SUPPLIER_CONTACTS ASCC,
       hr_locations_all_TL HLAT,
       HR_LOCATIONS_ALL_TL HLAT1,
       PO_DOCUMENT_TYPES_ALL_VL PDTAV,
       PO_LINES_ALL PLA,
       PO_LINE_TYPES_VL PLTV,
       MTL_SYSTEM_ITEMS_B MSIB,
       ORG_ORGANIZATION_DEFINITIONS OOD,
       PO_LINE_LOCATIONS_ALL PLLA,
       MTL_CATEGORIES MC,
       PO_DISTRIBUTIONS_ALL PDA
 WHERE     1 = 1
       AND PHA.CREATED_BY = FU.USER_ID(+)
       AND PHA.LAST_UPDATED_BY = FU2.USER_ID
       AND PHA.AGENT_ID = PAPF.PERSON_ID
       AND SYSDATE BETWEEN EFFECTIVE_START_DATE
                       AND NVL (EFFECTIVE_END_DATE, SYSDATE + 1)
       AND PHA.AUTHORIZATION_STATUS = PLC.LOOKUP_CODE
       AND LOOKUP_TYPE = 'AUTHORIZATION STATUS'
       AND HOU.ORGANIZATION_ID = PHA.ORG_ID
       AND PHA.VENDOR_ID = ASS.VENDOR_ID
       AND ASS.VENDOR_ID = ASSA.VENDOR_ID
       AND PHA.VENDOR_SITE_ID = ASSA.VENDOR_SITE_ID
       AND PHA.ORG_ID = ASSA.ORG_ID
       AND PHA.VENDOR_CONTACT_ID = ASCC.VENDOR_CONTACT_ID(+)
       AND PHA.SHIP_TO_LOCATION_ID = HLAT.LOCATION_ID
       AND PHA.BILL_TO_LOCATION_ID = HLAT1.LOCATION_ID
       AND PHA.TYPE_LOOKUP_CODE = PDTAV.DOCUMENT_SUBTYPE
       AND PLA.PO_HEADER_ID = PHA.PO_HEADER_ID
       AND PLA.LINE_TYPE_ID = PLTV.LINE_TYPE_ID
       AND PLA.ITEM_ID = MSIB.INVENTORY_ITEM_ID
       AND MSIB.ORGANIZATION_ID = OOD.ORGANIZATION_ID
       AND PLLA.SHIP_TO_ORGANIZATION_ID = MSIB.ORGANIZATION_ID
       AND PLA.PO_LINE_ID = PLLA.PO_LINE_ID
       AND PLA.CATEGORY_ID = MC.CATEGORY_ID
       AND PDA.LINE_LOCATION_ID = PLLA.LINE_LOCATION_ID
       AND PDTAV.DOCUMENT_TYPE_CODE IN ('PO')
       AND PHA.ORG_ID = PDTAV.ORG_ID;
       
--       AND PHA.PO_HEADER_ID = 3606;

--po with no requisition
 select 
    poh.segment1 as  po_number,
    poh.po_header_id,
    poh.agent_id,
    poh.vendor_id,
    poh.authorization_status,
    poh.creation_date
from 
    po_headers_all poh,
     po_lines_all pla, 
     po_distributions_all pda,
     po_req_distributions_all prd
 where   1=1
--    AND poh.type_lookup_code = 'STANDARD'  
--    and prd.distribution_id IS NULL
    and  poh.po_header_id = pla.po_header_id
    and pla.po_line_id = pda.po_line_id
    and  pda.req_distribution_id = prd.distribution_id
    
    