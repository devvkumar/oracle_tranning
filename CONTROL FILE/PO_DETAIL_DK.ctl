LOAD DATA
INFILE 'purchase_orders.csv'
BADFILE 'bad/purchase_orders.bad'
DISCARDFILE 'bad/purchase_orders.dsc'
LOGFILE 'logs/purchase_orders.log'
APPEND
INTO TABLE XXQGEN_PO_HDR_DK
WHEN RECORD_TYPE = 'HEADER'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  
TRAILING NULLCOLS
(
    RECORD_TYPE FILLER,
    po_header_id,
    po_number,
    po_date DATE "YYYY-MM-DD",
    vendor_id
)

INTO TABLE XXQGEN_PO_LINE_DK
WHEN RECORD_TYPE = 'LINE'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  
TRAILING NULLCOLS
(
    RECORD_TYPE FILLER,
    po_header_id,
    FILLER,
    FILLER,
    po_line_id,
    item_id,
    quantity,
    unit_price
)

INTO TABLE XXQGEN_PO_LINE_LOC_DK
WHEN RECORD_TYPE = 'LINE'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  
TRAILING NULLCOLS
(
    RECORD_TYPE FILLER,
    po_header_id,
    FILLER,
    FILLER,
    po_line_id,
    item_id,
    quantity,
    unit_price
)

INTO TABLE XXQGEN_PO_DIST_DK
WHEN RECORD_TYPE = 'DISTRIBUTION'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  
TRAILING NULLCOLS
(
    RECORD_TYPE FILLER,
    FILLER,
    FILLER,
    FILLER,
    FILLER,
    po_line_id,
    FILLER,
    FILLER,
    po_distribution_id,
    gl_account,
    amount
)
