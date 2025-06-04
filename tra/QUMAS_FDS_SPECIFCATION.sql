create table specification_dk(
    specification_name  varchar2(100),
    description     varchar2(3000),
    manual_lot_expire   varchar2(1),
    shelf_days      number,
    Date_of_Manufacture   varchar2(1),
    Date_of_Irradiation   varchar2(1),
    date_of_Shipping   varchar2(1),
    date_of_reciept   varchar2(1),
    vendor_expiry_date   varchar2(1),
    override_expiry_date   varchar2(1),
    disable   varchar2(1)
);

SELECT COUNT(*), SPECIFICATION_NAME FROM specification_dk
GROUP BY SPECIFICATION_NAME;

    SELECT COUNT(*)
  FROM SPECIFICATION_DK
  WHERE upper(SPECIFICATION_NAME) = upper(:SPECIFICATION_NAME)
    AND END_DATE is null;
       

SELECT *
FROM EMP_DK;

SELECT * 
FROM SPECIFICATION_DK;

delete from specification_dk
where specification_name is null
    or lower(specification_name) = 'test';

ALTER TABLE SPECIFICATION_DK
ADD CREATED_BY NUMBER;

ALTER TABLE SPECIFICATION_DK
ADD CREATION_DATE DATE;

ALTER TABLE SPECIFICATION_DK
ADD LAST_UPDATED_BY NUMBER;

ALTER TABLE SPECIFICATION_DK
ADD LAST_UPDATE_DATE DATE;

ALTER TABLE SPECIFICATION_DK
ADD LAST_UPDATE_LOGIN NUMBER;


      SELECT 
      LT.Specification_Name,
          LT.Description
            , LT.manual_lot_expire
            , LT.Shelf_Days
            , LT.Date_of_Manufacture
            , LT.Date_of_Irradiation
            , LT.Date_of_Shipping
            , LT.date_of_reciept
            , LT.Vendor_Expiry_Date
        FROM 
            SPECIFICATION_DK LT ,
            MTL_SYSTEM_ITEMS_B MSIB
        WHERE 
                MSIB.SEGMENT1 = 'CM11222'
                --LT.Specification_Description = GC_ITM_SEG
                AND MSIB.ATTRIBUTE9 = LT.Specification_Name;

SELECT *
FROM SPECIFICATION_DK;

SELECT *
FROM MTL_SYSTEM_ITEMS_B 
WHERE SEGMENT1 = 'CM11222';

create table lot_exp_Date_dk(
    specification_name  varchar2(100),
    Date_of_Manufacture   date,
    Date_of_Irradiation   date,
    date_of_Shipping   date,
    date_of_reciept   date,
    vendor_expiry_date   date,
    generated_expire_date   date,
    manually_expiry_date    date,
    CREATION_DATE date,
    CREATED_BY number,
    LAST_UPDATE_DATE date,
    LAST_UPDATED_BY number,
    LAST_UPDATE_LOGIN   number
);

select *
from XXQGEN_LOT_EXPIRY_SPECS_NB;

ALTER TABLE lot_exp_Date_dk 
MODIFY specification_name VARCHAR2( 2000 );

desc lot_exp_date_dk;

select * from specification_dk;

SELECT *
FROM lot_exp_date_dk;

truncate table lot_exp_date_dk;

SELECT *
FROM fnd_descriptive_flexs_vl;

alter table specification_dk
add  start_date date;

alter table specification_dk
add end_date date;


select *
from mtl_system_items_b
where segment1 = 'CM11222';


=SELECT TO_CHAR(NVL(GENERATE_EXPIRY_DATE,MANUALLY_ENTER_EXPIRY) ) 
    FROM XXQGEN_LOT_EXPIRY_DATE_AR,MTL_SYSTEM_ITEMS_B
    WHERE XXQGEN_LOT_EXPIRY_DATE_AR.EXPIRY_DATE_SPECIFICATION=MTL_SYSTEM_ITEMS_B.ATTRIBUTE4
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    select *
    from specification_dk;
    
    select NVL(LED.GENERATED_EXPIRE_DATE, LED.MANUALLY_EXPIRY_DATE)
    from mtl_system_items_b MSIB,
            SPECIFICATION_DK SD,
            LOT_EXP_DATE_DK LED
    where 1=1
        AND MSIB.ATTRIBUTE9 = SD.SPECIFICATION_NAME
        AND LED.SPECIFICATION_NAME = SD.DESCRIPTION
        AND MSIB.segment1 = 'CM11222';
    
    select *
    from lot_exp_date_ad led; 
    
    
    
SELECT *
FROM FND_USER
WHERE USER_NAME = 'ACHOUDHARY';

1016339

SELECT *
FROM FND_CONCURRENT_PROGRAMS_VL
WHERE CREATED_BY = 1016353;


SELECT * 
FROM MTL_LOT_NUMBERS;


SELECT TEXT
  FROM all_source
 WHERE 1=1
   AND name  = 'FND_MESSAGE'
   AND TYPE = 'PACKAGE';
   
-- ORDER BY line;


SELECT ATTRIBUTE17
FROM OE_ORDER_LINES_ALL
WHERE ATTRIBUTE17 = 'BONDED';