-----------------------------------------------------------------------
--      Program Name    :       II_VI_SAPCHINA_SPO_STG_TABLE.ctl
--
--      Comments        :       The SQL*Loader control scripts to loads the SPO data
--								into II_VI_SAPCHINA_SPO_STG_TABLE table from 
--								extract file
--
--      Creation Date   :       04-SEP-2023
--
--      Last Updated By :       Rajesh D
--                              
--
--
--      Revision History :     	
-----------------------------------------------------------------------
OPTIONS (SKIP = 1,ERRORS=1000000)
LOAD DATA 
INFILE Open_Purchase_Order.csv
REPLACE 
INTO TABLE II_VI_SAPCHINA_SPO_STG_TABLE
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(LEGACY_PO_NUMBER  							    "TRIM(:LEGACY_PO_NUMBER)",	
PO_DESCRIPTION				                    "TRIM(:PO_DESCRIPTION)",
AGENT_NAME                                      "TRIM(:AGENT_NAME)",
VENDOR_NAME  									"TRIM(:VENDOR_NAME)",
VENDOR_CODE	  									"TRIM(:VENDOR_CODE)",
SHIP_TO_LOCATION                                "TRIM(:SHIP_TO_LOCATION)",
BILL_TO_LOCATION                                "TRIM(:BILL_TO_LOCATION)",
CURRENCY_CODE							 		"TRIM(:CURRENCY_CODE)",
PO_PAYMENT_TERMS							 	"TRIM(:PO_PAYMENT_TERMS)",
INCOTERMS							 			"TRIM(:INCOTERMS)",
CARRIER							 				"TRIM(:CARRIER)",
DESTINATION							 			"TRIM(:DESTINATION)",
NOTE_TO_RECEIVER							 	"TRIM(:NOTE_TO_RECEIVER)",
NOTE_TO_SUPPLIER							 	"LTRIM(RTRIM(replace(:NOTE_TO_SUPPLIER,chr(13),'')))",
LINE_NUMBER										"TRIM(:LINE_NUMBER)",
LINE_TYPE 										"TRIM(:LINE_TYPE)",
ITEM  											"TRIM(:ITEM)",
ITEM_REVISION									"TRIM(:ITEM_REVISION)",
CATEGORY                                        "TRIM(:CATEGORY)",
DESCRIPTION										"TRIM(:DESCRIPTION)",
UOM  											"TRIM(:UOM)",
UNIT_PRICE  							    	"TRIM(:UNIT_PRICE)",
SUPPLIER_ITEM									"TRIM(:SUPPLIER_ITEM)",
SHIPMENT_NUM									"TRIM(:SHIPMENT_NUM)",
LINE_QUANTITY  									"TRIM(:LINE_QUANTITY)",
NEED_BY_DATE									"TRIM(TO_DATE(:NEED_BY_DATE,'DD-MM-RRRR'))",
PROMISED_DATE									"TRIM(TO_DATE(:PROMISED_DATE,'DD-MM-RRRR'))",
RECEIPT_REQUIRED								"TRIM(:RECEIPT_REQUIRED)",
TAX_CODE										"TRIM(:TAX_CODE)",
CHARGE_ACCOUNT									"TRIM(:CHARGE_ACCOUNT)",
VENDOR_SITE_ID									"TRIM(:VENDOR_SITE_ID)",
CONSIGNED_FLAG									"TRIM(:CONSIGNED_FLAG)",
PLANT_CODE									"TRIM(:PLANT_CODE)",
PR_NUMBER									"TRIM(:PR_NUMBER)",
PR_ITEM									"TRIM(:PR_ITEM)",
REQUESTER									"TRIM(:REQUESTER)",
PR_TEXT									"TRIM(:PR_TEXT)",
COST_CENTER_CODE									"TRIM(:COST_CENTER_CODE)",
COST_CENTER									"TRIM(:COST_CENTER)",
ASSET_NO									"TRIM(:ASSET_NO)",
APL_STATUS									"TRIM(:APL_STATUS)",
VENDOR_ID									"TRIM(:VENDOR_ID)",
INTERNAL_ORDER_NUMBER									"TRIM(:INTERNAL_ORDER_NUMBER)",              
RECORD_NUM       								SEQUENCE(MAX,1) 
)