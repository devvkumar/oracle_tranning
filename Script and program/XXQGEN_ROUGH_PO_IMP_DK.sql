SELECT *
FROM xxqgen_po_hdr_stg_dk;

select *
from xxqgen_po_line_stg_dk;

select *
from xxqgen_po_line_loc_stg_dk;

select *
from xxqgen_po_dist_stg_dk;

SELECT *
FROM FND_EXECUTABLES;

truncate table xxqgen_po_hdr_stg_dk;

truncate table xxqgen_po_line_stg_dk;

truncate table xxqgen_po_line_loc_stg_dk;

truncate table xxqgen_po_dist_stg_dk;

select*
from dba_objects
where object_name like '%XXQGEN%';

  
select text
from   dba_source
where  1=1
and    NAME = 'XXQGEN_REQ_HDR_LINE_TBL_PKG_AK'
and    TYPE = 'PACKAGE BODY'
order  by LINE
;
  
  set long 1000000
select dbms_metadata.get_ddl('PACKAGE_BODY','XXQGEN_REQ_STG_TBL_AK') from dual

SELECT PO_HEADER_ID
FROM PO_LINES_ALL
GROUP BY PO_HEADER_ID
HAVING COUNT(*) < 2;

SELECT SEGMENT1
FROM PO_HEADERS_ALL
WHERE PO_HEADER_ID = 21;

select *
from po_headers_all;