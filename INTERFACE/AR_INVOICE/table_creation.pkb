-------------------------------------- Header Table -----------------------------------
drop table AR_INV_HEADER_DK;

CREATE TABLE AR_INV_HEADER_DK (
    trx_header_id                   NUMBER,
    trx_number                      VARCHAR2(20),
    trx_date                        DATE,
    trx_currency                    VARCHAR2(30),
    trx_curr_code                   varchar2(10),
    reference_number                VARCHAR2(30),
    trx_class                       VARCHAR2(20),
    cust_trx_type_id                NUMBER,
    gl_date                         DATE,
    bill_to_customer_id             NUMBER,
    bill_to_account_number          VARCHAR2(30),
    bill_to_customer_name           VARCHAR2(260),
    bill_to_contact_id              NUMBER,
    bill_to_contact                 varchar2(100),
    bill_to_address_id              NUMBER,
    bill_to_address1                 varchar2(100),
    bill_to_address2                 varchar2(100),
    bill_to_address3                 varchar2(100),
    bill_to_address4                 varchar2(100),
    bill_to_site_use_id             NUMBER,
    bill_to_site                        varchar2(100),
    ship_to_customer_id             NUMBER,
    ship_to_account_number          VARCHAR2(30),
    ship_to_customer_name           VARCHAR2(260),
    ship_to_contact_id              NUMBER,
    ship_to_contact                     varchar2(100),
    ship_to_address_id              NUMBER,
    ship_to_address1                 varchar2(100),
    ship_to_address2                 varchar2(100),
    ship_to_address3                 varchar2(100),
    ship_to_address4                 varchar2(100),
    ship_to_site_use_id             NUMBER,
    ship_to_site                        varchar2(50),
    sold_to_customer_id             NUMBER,
    sold_to_cust_name                   varchar2(50),
    term_id                         NUMBER,
    primary_salesrep_id             NUMBER,
    primary_salesrep_name           VARCHAR2(240),
    exchange_rate_type              VARCHAR2(60),
    exchange_date                   DATE,
    exchange_rate                   NUMBER,
    territory_id                    NUMBER,
    territory                       varchar2(50),
    remit_to_address_id             NUMBER,
    invoicing_rule_id               NUMBER,
    printing_option                 VARCHAR2(20),
    purchase_order                  VARCHAR2(50),
    purchase_order_revision         VARCHAR2(50),
    purchase_order_date             DATE,
    comments                        VARCHAR2(1760),
    internal_notes                  VARCHAR2(240),
    finance_charges                 VARCHAR2(1),
    receipt_method_id               NUMBER,
    related_customer_trx_id         NUMBER,
    agreement_id                    NUMBER,
    ship_via                        VARCHAR2(30),
    ship_date_actual                DATE,
    waybill_number                  VARCHAR2(50),
    fob_point                       VARCHAR2(30),
    customer_bank_account_id        NUMBER,
    default_ussgl_transaction_code VARCHAR2(30),
    status_trx                      VARCHAR2(30),
    paying_customer_id              NUMBER,
    paying_site_use_id              NUMBER,
    default_tax_exempt_flag         VARCHAR2(1),
    doc_sequence_value              NUMBER(15),
    attribute_category              VARCHAR2(30),
    attribute1                      VARCHAR2(150),
    attribute2                      VARCHAR2(150),
    attribute3                      VARCHAR2(150),
    attribute4                      VARCHAR2(150),
    attribute5                      VARCHAR2(150),
    attribute6                      VARCHAR2(150),
    attribute7                      VARCHAR2(150),
    attribute8                      VARCHAR2(150),
    attribute9                      VARCHAR2(150),
    attribute10                     VARCHAR2(150),
    attribute11                     VARCHAR2(150),
    attribute12                     VARCHAR2(150),
    attribute13                     VARCHAR2(150),
    attribute14                     VARCHAR2(150),
    attribute15                     VARCHAR2(150),
    global_attribute_category       VARCHAR2(30),
    global_attribute1               VARCHAR2(150),
    global_attribute2               VARCHAR2(150),
    global_attribute3               VARCHAR2(150),
    global_attribute4               VARCHAR2(150),
    global_attribute5               VARCHAR2(150),
    global_attribute6               VARCHAR2(150),
    global_attribute7               VARCHAR2(150),
    global_attribute8               VARCHAR2(150),
    global_attribute9               VARCHAR2(150),
    global_attribute10              VARCHAR2(150),
    global_attribute11              VARCHAR2(150),
    global_attribute12              VARCHAR2(150),
    global_attribute13              VARCHAR2(150),
    global_attribute14              VARCHAR2(150),
    global_attribute15              VARCHAR2(150),
    global_attribute16              VARCHAR2(150),
    global_attribute17              VARCHAR2(150),
    global_attribute18              VARCHAR2(150),
    global_attribute19              VARCHAR2(150),
    global_attribute20              VARCHAR2(150),
    global_attribute21              VARCHAR2(150),
    global_attribute22              VARCHAR2(150),
    global_attribute23              VARCHAR2(150),
    global_attribute24              VARCHAR2(150),
    global_attribute25              VARCHAR2(150),
    global_attribute26              VARCHAR2(150),
    global_attribute27              VARCHAR2(150),
    global_attribute28              VARCHAR2(150),
    global_attribute29              VARCHAR2(150),
    global_attribute30              VARCHAR2(150),
    interface_header_context        VARCHAR2(30),
    interface_header_attribute1     VARCHAR2(150),
    interface_header_attribute2     VARCHAR2(150),
    interface_header_attribute3     VARCHAR2(150),
    interface_header_attribute4     VARCHAR2(150),
    interface_header_attribute5     VARCHAR2(150),
    interface_header_attribute6     VARCHAR2(150),
    interface_header_attribute7     VARCHAR2(150),
    interface_header_attribute8     VARCHAR2(150),
    interface_header_attribute9     VARCHAR2(150),
    interface_header_attribute10    VARCHAR2(150),
    interface_header_attribute11    VARCHAR2(150),
    interface_header_attribute12    VARCHAR2(150),
    interface_header_attribute13    VARCHAR2(150),
    interface_header_attribute14    VARCHAR2(150),
    interface_header_attribute15    VARCHAR2(150),
    org_id                          NUMBER,
    legal_entity_id                 NUMBER,
    payment_trxn_extension_id       NUMBER,
    billing_date                    DATE,
    interest_header_id              NUMBER,
    late_charges_assessed           VARCHAR2(1),
    document_sub_type               VARCHAR2(240),
    default_taxation_country        VARCHAR2(2),
    mandate_last_trx_flag           VARCHAR2(1),
    rev_rec_application             VARCHAR2(30),
    document_type_id                NUMBER(18),
    document_creation_date          DATE,
    CREATION_DATE                   DATE,
    CREATED_BY                      NUMBER(15),
    LAST_UPDATE_DATE                DATE,
    LAST_UPDATED_BY                 NUMBER(15),
    LAST_UPDATE_LOGIN               NUMBER(15),
    REQUEST_ID                      NUMBER(15),
    FLAG                        VARCHAR2(1)
);


-------------------------------------------------------------------------------------------

------------------------------------ Line Table -----------------------------------------

drop table ar_inv_line_dk;

CREATE TABLE AR_INV_LINE_DK (
  trx_header_id                   NUMBER,
  trx_line_id                     NUMBER,
  link_to_trx_line_id             NUMBER,
  line_number                     NUMBER,
  reason_code                     VARCHAR2(30),
  inventory_item_id               NUMBER,
  item                                  varchar2(100),
  description                     VARCHAR2(240),
  quantity_ordered                NUMBER,
  quantity_invoiced               NUMBER,
  unit_standard_price             NUMBER,
  unit_selling_price              NUMBER,
  sales_order                     VARCHAR2(50),
  sales_order_line                VARCHAR2(30),
  sales_order_date                DATE,
  accounting_rule_id              NUMBER,
  accounting_rule_duration        NUMBER,
  line_type                       VARCHAR2(20),
  attribute3                      VARCHAR2(150),
  attribute_category              VARCHAR2(30),
  attribute1                      VARCHAR2(150),
  attribute2                      VARCHAR2(150),
  attribute4                      VARCHAR2(150),
  attribute5                      VARCHAR2(150),
  attribute6                      VARCHAR2(150),
  attribute7                      VARCHAR2(150),
  attribute8                      VARCHAR2(150),
  attribute9                      VARCHAR2(150),
  attribute10                     VARCHAR2(150),
  attribute11                     VARCHAR2(150),
  attribute12                     VARCHAR2(150),
  attribute13                     VARCHAR2(150),
  attribute14                     VARCHAR2(150),
  attribute15                     VARCHAR2(150),
  rule_start_date                 DATE,
  interface_line_context          VARCHAR2(30),
  interface_line_attribute1       VARCHAR2(150),
  interface_line_attribute2       VARCHAR2(150),
  interface_line_attribute3       VARCHAR2(150),
  interface_line_attribute4       VARCHAR2(150),
  interface_line_attribute5       VARCHAR2(150),
  interface_line_attribute6       VARCHAR2(150),
  interface_line_attribute7       VARCHAR2(150),
  interface_line_attribute8       VARCHAR2(150),
  interface_line_attribute9       VARCHAR2(150),
  interface_line_attribute10      VARCHAR2(150),
  interface_line_attribute11      VARCHAR2(150),
  interface_line_attribute12      VARCHAR2(150),
  interface_line_attribute13      VARCHAR2(150),
  interface_line_attribute14      VARCHAR2(150),
  interface_line_attribute15      VARCHAR2(150),
  sales_order_source              VARCHAR2(50),
  amount                          NUMBER,
  tax_precedence                  NUMBER,
  tax_rate                        NUMBER,
  tax_exemption_id                NUMBER,
  memo_line_id                    NUMBER,
  uom_code                        VARCHAR2(3),
  default_ussgl_transaction_code  VARCHAR2(30),
  default_ussgl_trx_code_context  VARCHAR2(30),
  vat_tax_id                      NUMBER(15,0),
  tax_exempt_flag                 VARCHAR2(1),
  tax_exempt_number               VARCHAR2(80),
  tax_exempt_reason_code          VARCHAR2(30),
  tax_vendor_return_code          VARCHAR2(30),
  movement_id                     NUMBER,
  global_attribute1               VARCHAR2(150),
  global_attribute2               VARCHAR2(150),
  global_attribute3               VARCHAR2(150),
  global_attribute4               VARCHAR2(150),
  global_attribute5               VARCHAR2(150),
  global_attribute6               VARCHAR2(150),
  global_attribute7               VARCHAR2(150),
  global_attribute8               VARCHAR2(150),
  global_attribute9               VARCHAR2(150),
  global_attribute10              VARCHAR2(150),
  global_attribute11              VARCHAR2(150),
  global_attribute12              VARCHAR2(150),
  global_attribute13              VARCHAR2(150),
  global_attribute14              VARCHAR2(150),
  global_attribute15              VARCHAR2(150),
  global_attribute16              VARCHAR2(150),
  global_attribute17              VARCHAR2(150),
  global_attribute18              VARCHAR2(150),
  global_attribute19              VARCHAR2(150),
  global_attribute20              VARCHAR2(150),
  global_attribute_category       VARCHAR2(30),
  amount_includes_tax_flag        VARCHAR2(1),
  warehouse_id                    NUMBER,
  contract_line_id                NUMBER,
  source_data_key1                VARCHAR2(150),
  source_data_key2                VARCHAR2(150),
  source_data_key3                VARCHAR2(150),
  source_data_key4                VARCHAR2(150),
  source_data_key5                VARCHAR2(150),
  invoiced_line_acctg_level       VARCHAR2(15),
  deferral_exclusion_flag         VARCHAR2(1),
  ship_date_actual                DATE,
  override_auto_accounting_flag   VARCHAR2(1),
  rule_end_date                   DATE,
  source_application_id           NUMBER,
  source_event_class_code         VARCHAR2(30),
  source_entity_code              VARCHAR2(30),
  source_trx_id                   NUMBER,
  source_trx_line_id              NUMBER,
  source_trx_line_type            VARCHAR2(30),
  source_trx_detail_tax_line_id   NUMBER,
  historical_flag                 VARCHAR2(1),
  taxable_flag                    VARCHAR2(1),
  tax_regime_code                 VARCHAR2(30),
  tax                             VARCHAR2(30),
  tax_status_code                 VARCHAR2(30),
  tax_rate_code                   VARCHAR2(50),
  tax_jurisdiction_code           VARCHAR2(30),
  tax_classification_code         VARCHAR2(50),
  interest_line_id                NUMBER,
  trx_business_category           VARCHAR2(240),
  product_fisc_classification     VARCHAR2(240),
  product_category                VARCHAR2(240),
  product_type                    VARCHAR2(240),
  line_intended_use               VARCHAR2(30),
  assessable_value                NUMBER,
  doc_line_id_int_1               NUMBER,
  doc_line_id_int_2               NUMBER,
  doc_line_id_int_3               NUMBER,
  doc_line_id_int_4               NUMBER,
  doc_line_id_int_5               NUMBER,
  doc_line_id_char_1              VARCHAR2(30),
  doc_line_id_char_2              VARCHAR2(30),
  doc_line_id_char_3              VARCHAR2(30),
  doc_line_id_char_4              VARCHAR2(30),
  doc_line_id_char_5              VARCHAR2(30),
   CREATION_DATE                   DATE,
    CREATED_BY                      NUMBER(15),
    LAST_UPDATE_DATE                DATE,
    LAST_UPDATED_BY                 NUMBER(15),
    LAST_UPDATE_LOGIN               NUMBER(15),
    REQUEST_ID                      NUMBER(15),
    FLAG                        VARCHAR2(1)
);

-------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------
----------------------------------- Distribution Table ---------------------------------

CREATE TABLE AR_INV_DIST_DK (
    trx_dist_id                NUMBER(15),
    trx_header_id              NUMBER(15),
    trx_line_id                NUMBER(15),
    account_class              VARCHAR2(20),
    amount                     NUMBER,
    acctd_amount               NUMBER,
    percent                    NUMBER,
    code_combination_id        NUMBER(15),
    segment1                    varchar2(50),
    segment2                    varchar2(50),
    segment3                    varchar2(50),
    segment4                    varchar2(50),
    segment5                    varchar2(50),
    attribute_category         VARCHAR2(30),
    attribute1                 VARCHAR2(150),
    attribute2                 VARCHAR2(150),
    attribute3                 VARCHAR2(150),
    attribute4                 VARCHAR2(150),
    attribute8                 VARCHAR2(150),
    attribute5                 VARCHAR2(150),
    attribute6                 VARCHAR2(150),
    attribute7                 VARCHAR2(150),
    attribute9                 VARCHAR2(150),
    attribute10                VARCHAR2(150),
    attribute11                VARCHAR2(150),
    attribute12                VARCHAR2(150),
    attribute13                VARCHAR2(150),
    attribute14                VARCHAR2(150),
    attribute15                VARCHAR2(150),
    global_attribute_category  VARCHAR2(30),
    global_attribute1          VARCHAR2(150),
    global_attribute2          VARCHAR2(150),
    global_attribute3          VARCHAR2(150),
    global_attribute4          VARCHAR2(150),
    global_attribute5          VARCHAR2(150),
    global_attribute6          VARCHAR2(150),
    global_attribute7          VARCHAR2(150),
    global_attribute8          VARCHAR2(150),
    global_attribute9          VARCHAR2(150),
    global_attribute10         VARCHAR2(150),
    global_attribute11         VARCHAR2(150),
    global_attribute12         VARCHAR2(150),
    global_attribute13         VARCHAR2(150),
    global_attribute14         VARCHAR2(150),
    global_attribute15         VARCHAR2(150),
    global_attribute16         VARCHAR2(150),
    global_attribute17         VARCHAR2(150),
    global_attribute18         VARCHAR2(150),
    global_attribute19         VARCHAR2(150),
    global_attribute20         VARCHAR2(150),
    global_attribute21         VARCHAR2(150),
    global_attribute22         VARCHAR2(150),
    global_attribute23         VARCHAR2(150),
    global_attribute24         VARCHAR2(150),
    global_attribute25         VARCHAR2(150),
    global_attribute26         VARCHAR2(150),
    global_attribute27         VARCHAR2(150),
    global_attribute28         VARCHAR2(150),
    global_attribute29         VARCHAR2(150),
    global_attribute30         VARCHAR2(150),
    comments                   VARCHAR2(240),
    CREATION_DATE                   DATE,
    CREATED_BY                      NUMBER(15),
    LAST_UPDATE_DATE                DATE,
    LAST_UPDATED_BY                 NUMBER(15),
    LAST_UPDATE_LOGIN               NUMBER(15),
    REQUEST_ID                      NUMBER(15),
    FLAG                        VARCHAR2(1)
);


-------------------------------------------------------------------------------------------

DROP TABLE AR_INV_DIST_DK;


CREATE SEQUENCE XXQGEN_AR_INV_RECORD_ID
START WITH 1
INCREMENT BY 1
;

CREATE SEQUENCE XXQGEN_AR_INV_BATCH_ID
START WITH 1
INCREMENT BY 1
;

CREATE SEQUENCE XXQGEN_AR_INV_NUM
START WITH 741852966
INCREMENT BY 1
;

CREATE SEQUENCE XXQGEN_AR_INV_LINE_NUM
START WITH 741852966
INCREMENT BY 1
;

SELECT XXQGEN_AR_INV_NUM.NEXTVAL
FROM DUAL;

create sequence xxqgen_ar_inv_hdr_id
start with 1
increment by 1
;
 
create sequence  xxqgen_ar_inv_line_id
start with 1
increment by 1
;

 
SELECT XXQGEN_AR_INV_NUM.NEXTVAL
FROM DUAL;
 
SELECT xxqgen_ar_inv_line_id.NEXTVAL
FROM DUAL;

select XXQGEN_AR_INV_BATCH_ID.nextval
from dual;


SELECT XXQGEN_AR_INV_BATCH_ID.NEXTVAL
FROM DUAL;

SELECT XXQGEN_AR_INV_BATCH_ID.CURRVAL
FROM DUAL;

ALTER TABLE AR_INV_DIST_DK
ADD FLAG    VARCHAR2(1);


ALTER TABLE AR_INV_LINE_DK
ADD FLAG    VARCHAR2(1);


ALTER TABLE AR_INV_HEADER_DK
ADD FLAG    VARCHAR2(1);
