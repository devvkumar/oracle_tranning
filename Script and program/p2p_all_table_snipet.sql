--Business Group
 
select * from per_business_groups;
 
select * from hr_organization_units_v
where type = 'BG';
 
-- LEGAL ENTITY 
SELECT
       xep.legal_entity_id        "Legal Entity ID",
       xep.name                   "Legal Entity",
FROM
       xle_entity_profiles            xep,
       xle_registrations              reg
       WHERE
       1=1
   AND xep.transacting_entity_flag   =  'Y'
   AND xep.legal_entity_id           =  reg.source_id
   AND reg.source_table              =  'XLE_ENTITY_PROFILES'
   AND reg.identifying_flag          =  'Y';

-- LEDGERS
GL_LEDGERS ;

select *
from gl_ledgers
WHERE LEDGER_ID = 1;


--Opearting Unit
 
HR_OPERATING_UNITS
 
-- Inventory org
 
ORG_ORGANIZATION_DEFINITIONS;
MTL_PARAMETERS;

SELECT *
FROM MTL_PARA


 
-- SUB INVENTORY ORG
MTL_SECONDARY_INVENTORIES

select *
from mtl_secondary_inventories;

select name , organization_id , type
from hr_organization_units
where organization_id = 1785

SELECT *
FROM MTL_CATEGORIES;


SELECT *
FROM PO_LINE_TYPES_VL;

SELECT *
FROM PO_LINE_LOCATIONS_ALL;

SELECT * 
FROM MTL_SYSTEM_ITEMS_B;