-- HEADER TABLE
CREATE TABLE xxqgen_po_hdr_stg_dk (
    HEADER_ID   NUMBER,
    interface_source_code VARCHAR2(50),
    action VARCHAR2(20),
    document_type VARCHAR2(50),
    document_type_CODE VARCHAR2(50),
    document_subtype VARCHAR2(50),
    DOCUMENT_SUBTYPE_CODE   VARCHAR2(50),
    agent VARCHAR2(100),
    AGENT_ID    NUMBER,
    document_num VARCHAR2(50) NOT NULL,
    vendor VARCHAR2(100),
    VENDOR_ID   NUMBER,
    vendor_site VARCHAR2(100),
    vendor_site_code VARCHAR2(50),
    ship_to_location VARCHAR2(100),
    SHIP_TO_LOCATION_ID NUMBER,
    bill_to_location VARCHAR2(100),
    BILL_TO_LOCATION_ID NUMBER,
    attribute_category VARCHAR2(50),
    ATTRIBUTE_CATEGORY2 VARCHAR2(50),
    vendor_contact VARCHAR2(100),
    VENDOR_CONTACT_ID   NUMBER,
    supply_agreement_flag VARCHAR2(2),
    expiration_date DATE,
    org VARCHAR2(50),
    ORG_ID  NUMBER,
    rate NUMBER(10,2),
    currencY VARCHAR2(10),
    CURRENCY_CODE VARCHAR2(10),
    rate_type VARCHAR2(50),
    rate_date DATE,
    comments VARCHAR2(500),
    freight_carrier VARCHAR2(100),
    effective_date DATE ,
    -- WHO COLUMNS
    STATUS VARCHAR2(1),
    ERROR_MESSAGE VARCHAR2(3000),
    created_by NUMBER(10) ,
    creation_date DATE ,
    last_updated_by NUMBER(10) ,
    last_update_date DATE,
    login_ID VARCHAR2(50),
    REQUEST_ID NUMBER(10),
    batch_id NUMBER(10),
    RECORD_ID NUMBER(10)
);

DROP TABLE XXQGEN_PO_HDR_STG_DK;


-- LINE TABLE
CREATE TABLE xxqgen_po_line_stg_dk (
    HEADER_ID   NUMBER,
    LINE_ID     NUMBER,
    LINE_LOC_ID NUMBER,
    action VARCHAR2(20),
    document_num VARCHAR2(50),
    LINE_TYPE   VARCHAR2(50),
    line_type_id NUMBER(10),
    item VARCHAR2(100),
    ITEM_ID NUMBER,
    UOM VARCHAR2(50),
    uom_code VARCHAR2(20),
    quantity NUMBER(15,2) NOT NULL,
    unit_price NUMBER(15,2),
    need_by_date DATE,
    promised_date DATE,
    ship_to_organization VARCHAR2(50),
    ship_to_organization_ID NUMBER,
    SHIP_TO_LOCATION VARCHAR2(50),
    SHIP_TO_LOCATION_ID NUMBER,
    enforce_ship_to_location VARCHAR2(50),
    enforce_ship_to_location_ID NUMBER,
    receiving_routing_id NUMBER(10),
    line_attribute15 VARCHAR2(100),
    line_num NUMBER(10) NOT NULL,
    vendor_product_num VARCHAR2(100),
    CATEGORY VARCHAR2(100),
    CATEGORY_ID NUMBER,
    item_description VARCHAR2(500),
    note_to_vendor VARCHAR2(500),
    invoice_close_tolerance NUMBER(5,2),
    receive_close_tolerance NUMBER(5,2),
    qty_rcv_tolerance NUMBER(5,2),
    item_revision VARCHAR2(50),
    list_price_per_unit NUMBER(15,2),
    line_loc_populated_flag CHAR(1),
    -- WHO COLUMNS
     STATUS VARCHAR2(1),
     ERROR_MESSAGE  VARCHAR2(3000),
    created_by NUMBER(10),
    creation_date DATE,
    last_updated_by NUMBER(10) ,
    last_update_date DATE,
    login_ID VARCHAR2(50),
    REQUEST_ID NUMBER(10),
    batch_id NUMBER(10),
    RECORD_ID NUMBER(10)
);

DROP TABLE xxqgen_po_line_stg_dk;

-- LINE LOCATION TABLE
CREATE TABLE xxqgen_po_line_loc_stg_dk (
    HEADER_ID   NUMBER,
    LINE_ID     NUMBER,
    LINE_LOC_ID     NUMBER,
    shipment_num VARCHAR2(50),
    qty_rcv_exception_code VARCHAR2(50),
    days_early_receipt_allowed NUMBER(5),
    allow_substitute_receipts_flag CHAR(1) ,
    days_late_receipt_allowed NUMBER(5),
    receipt_days_exception VARCHAR2(50),
    receipt_days_exception_code VARCHAR2(50),
    enforce_ship_to_location VARCHAR2(50),
    enforce_ship_to_location_code VARCHAR2(50),
    need_by_date DATE,
    promised_date DATE,
    -- WHO COLUMNS
    STATUS VARCHAR2(1),
    ERROR_MESSAGE VARCHAR2(3000),
    created_by NUMBER(10),
    creation_date DATE,
    last_updated_by NUMBER(10) ,
    last_update_date DATE,
    login_ID VARCHAR2(50),
    REQUEST_ID NUMBER(10),
    batch_id NUMBER(10),
    RECORD_ID NUMBER(10)
);

DROP TABLE xxqgen_po_line_loc_stg_dk;

-- DISTRBIBUTION TABLE 
CREATE TABLE xxqgen_po_dist_stg_dk (
    HEADER_ID   NUMBER,
    LINE_ID NUMBER,
    DISTRIBUTION_ID NUMBER,
    distribution_num VARCHAR2(50) ,
    quantity_ordered NUMBER(15,2),
    charge_account_id NUMBER(10),
    charge_account VARCHAR2(100),
    -- WHO COLUMNS
    STATUS VARCHAR2(1),
    ERROR_MESSAGE VARCHAR2(3000),
    created_by NUMBER(10),
    creation_date DATE,
    last_updated_by NUMBER(10) ,
    last_update_date DATE,
    login_ID VARCHAR2(50),
    REQUEST_ID NUMBER(10),
    batch_id NUMBER(10),
    RECORD_ID NUMBER(10)
);

DROP TABLE xxqgen_po_dist_stg_dk;


CREATE SEQUENCE XXQGEN_PO_BATCH_ID
START WITH 1
INCREMENT BY 1;

create sequence xxqgen_po_header_id
start with 1
increment by 1;

create sequence xxqgen_po_line_loc_id
start with 1
increment by 1;

create sequence xxqgen_po_dist_id
start with 1
increment by 1;