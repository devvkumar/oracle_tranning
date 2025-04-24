---------------------------------------------------------------------------------------------------------------------------------------------------
-- O2C QUERY
---------------------------------------------------------------------------------------------------------------------------------------------------

-- ALL ENTERED DATA TABLE JOIN IN O2C

select *
from oe_order_headers_all ooha,
        oe_order_lines_all oola,
        oe_price_adjustments opa,
        oe_order_price_attribs oopa
--        oe_order_holds_all oha
where 1=1
    and ooha.header_id = oola.header_id
    and ooha.header_id = opa.header_id
    and ooha.header_id = oopa.header_id
--    and ooha.header_id = oha.header_id
--    AND OOHA.HEADER_ID = 177242;
    
    
-- CHECKED BOOKED ORDER

SELECT *
FROM OE_ORDER_HEADERS_ALL OOHA,
          OE_ORDER_LINES_ALL OOLA,
          WSH_DELIVERY_DETAILS WD,
          WSH_PICKING_BATCHES WPB,
          MTL_RESERVATIONS MLR
WHERE 1=1
    AND OOLA.HEADER_ID = OOHA.HEADER_ID
    AND OOHA.HEADER_ID = WD.SOURCE_HEADER_ID
    AND OOHA.HEADER_ID = WPB.ORDER_HEADER_ID
    AND OOLA.LINE_ID = MLR.DEMAND_SOURCE_LINE_ID
--    AND OOHA.HEADER_ID = 94602;


-- FULL TRANSACTIONS

SELECT MTRH.HEADER_ID,
            MTRH.REQUEST_NUMBER,
            MTRH.ORGANIZATION_ID,
            MTRH.FROM_SUBINVENTORY_CODE,
            MTRH.TO_SUBINVENTORY_CODE,
            MTRH.TO_ACCOUNT_ID,
            MTRH.FREIGHT_CODE,
            MTRH.SHIP_TO_LOCATION_ID,
            MTRH.SHIPMENT_METHOD,
            MTRL.LINE_NUMBER,
            MTRL.ORGANIZATION_ID,
            MTRL.INVENTORY_ITEM_ID,
            MTRL.FROM_SUBINVENTORY_CODE,
            MTRL.FROM_LOCATOR_ID,
            MTRL.TO_ACCOUNT_ID,
            MTRL.UOM_CODE,
            MTRL.QUANTITY,
            MTRL.QUANTITY_DELIVERED,
            MTRL.QUANTITY_DETAILED,
            MTRL.TRANSACTION_HEADER_ID,
            MTRL.LINE_STATUS,
            MTRL.TXN_SOURCE_ID,
            MTRL.TRANSACTION_TYPE_ID,
            MTRL.TO_ORGANIZATION_ID,
            MTRL.SHIP_TO_LOCATION_ID,
            MTRL.UNIT_NUMBER
FROM MTL_TXN_REQUEST_HEADERS MTRH,
          MTL_TXN_REQUEST_LINES MTRL
WHERE 1=1
    AND MTRH.HEADER_ID = MTRL.HEADER_ID;

SELECT *
FROM MTL_TXN_REQUEST_HEADERS;

SELECT *
FROM MTL_TXN_REQUEST_LINES;

SELECT *
FROM MTL_MATERIAL_TRANSACTIONS;
    

SELECT *
FROM MTL_RESERVATIONS;

SELECT *
FROM WSH_PICKING_BATCHES;


    
SELECT *
FROM WSH_DELIVERY_DETAILS;
    
select *
from oe_price_adjustments;
    
    
select *
from oe_order_headers_all;

select *
from oe_order_price_attribs;

select *
from oe_order_holds_all;