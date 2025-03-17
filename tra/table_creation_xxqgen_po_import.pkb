CREATE TABLE xxqgen_po_hdr_stg (
    interface_header_id NUMBER PRIMARY KEY, -- Matching the sequence in your INSERT statement (apps.po_headers_interface_s.NEXTVAL)
    batch_id NUMBER, -- Batch ID for grouping related records
    process_code VARCHAR2(20), -- Process status of the PO
    action VARCHAR2(20), -- Action taken (e.g., 'ORIGINAL')
    org_id NUMBER, -- Organization ID for operating unit
    document_type_code VARCHAR2(20), -- Type of document (e.g., 'STANDARD')
    currency_code VARCHAR2(3), -- Currency (e.g., 'USD')
    agent_id NUMBER, -- Buyer ID (57 in your case)
    vendor_name VARCHAR2(255), -- Supplier name (e.g., 'Office Supplies, Inc.')
    vendor_site_code VARCHAR2(255), -- Supplier Site code (e.g., 'OFFICESUPPLIES')
    ship_to_location VARCHAR2(255), -- Shipping location name
    bill_to_location VARCHAR2(255), -- Billing location name
    reference_num VARCHAR2(50) -- Reference number (e.g., 'TestPO')
);


CREATE TABLE xxqgen_po_lines_stg (
    interface_line_id NUMBER PRIMARY KEY, -- Matching the sequence in your INSERT statement (po_lines_interface_s.nextval)
    interface_header_id NUMBER, -- Reference to the PO header (foreign key to po_headers_interface)
    line_num NUMBER, -- Line number in the purchase order
    shipment_num NUMBER, -- Shipment number
    line_type VARCHAR2(20), -- Type of the line item (e.g., 'Goods')
    item VARCHAR2(50), -- Item being ordered (e.g., 'CM96713')
    uom_code VARCHAR2(20), -- Unit of measure (e.g., 'Ea')
    quantity NUMBER, -- Quantity of the item
    unit_price NUMBER, -- Unit price of the item
    ship_to_organization_code VARCHAR2(20), -- Organization receiving the shipment (e.g., 'V1')
    ship_to_location VARCHAR2(255) -- Location to ship the item to (e.g., 'V1- New York City')
);


CREATE SEQUENCE XXQGEN_PO_BATCH_ID
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE XXQGEN_REC_ID_DK
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE XXQGEN_PO_REQ_HEADER_ID
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE XXQGEN_PO_REQ_LINE_ID
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE xxqgen_po_dist_id
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE xxqgen_po_line_loc_id
START WITH 1
INCREMENT BY 1;

SELECT *
FROM xxqgen_po_hdr_stg_dk;

ALTER TABLE XXQGEN_PO_HDR_STG_DK 
RENAME COLUMN ATTRIBUTE1 TO CURRENCY;

--CREATE TABLE XXQGEN_PO_HDR_STG_DK AS

SE

(SELECT *
FROM PO_HEADERS_INTERFACE);

ALTER TABLE XXQGEN_PO_HDR_STG_DK
ADD ORG VARCHAR2(2);

ALTER TABLE XXQGEN_PO_DIST_STG_DK
ADD ERROR_MESSAGE VARCHAR2(4000);

ALTER TABLE XXQGEN_PO_LINE_LOC_STG_DK
ADD CREATED_BY NUMBER;

ALTER TABLE XXQGEN_PO_HDR_STG_DK
ADD CREATION_DATE DATE;

ALTER TABLE XXQGEN_PO_HDR_STG_DK
ADD LAST_UPDATED_BY NUMBER;

ALTER TABLE XXQGEN_PO_HDR_STG_DK
ADD LAST_UPDATE_DATE DATE;

ALTER TABLE XXQGEN_PO_HDR_STG_DK
ADD REQUEST_ID NUMBER;

ALTER TABLE XXQGEN_PO_DIST_STG_DK
ADD BATCH_ID NUMBER;

ALTER TABLE XXQGEN_PO_DIST_STG_DK
ADD RECORD_ID NUMBER;

SELECT *
FROM PO_HEADERS_INTERFACE;

CREATE TABLE XXQGEN_PO_LINE_STG_DK AS
SELECT *
FROM PO_LINES_INTERFACE;

CREATE TABLE XXQGEN_PO_LINE_LOC_STG_DK AS
SELECT *
FROM PO_LINE_LOCATIONS_INTERFACE;

CREATE TABLE XXQGEN_PO_DIST_STG_DK AS
SELECT *
FROM PO_DISTRIBUTIONS_INTERFACE;

SELECT *
FROM FND_CONCURRENT_REQUESTS;

SELECT *
FROM FND_CONCURRENT_PROGRAMS_VL;

SELECT A.REQUEST_ID, B.CONCURRENT_PROGRAM_NAME, B.CREATION_DATE
FROM FND_CONCURRENT_REQUESTS A, FND_CONCURRENT_PROGRAMS_VL B
WHERE A.CONCURRENT_PROGRAM_ID = B.CONCURRENT_PROGRAM_ID;

Select PROGRAM from FND_CONC_REQ_SUMMARY_V
WHERE REQUEST_ID = 7527429;

SELECT *
FROM XXQGEN_PO_HDR_STG_DK;

SELECT SHIP_TO_ORGANIZATION_ID
FROM XXQGEN_PO_LINE_STG_DK;