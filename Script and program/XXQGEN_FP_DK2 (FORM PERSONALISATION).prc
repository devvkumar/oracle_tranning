SELECT mil.concatenated_segments storage_location,
                   rsh.receipt_num,
                   assa.country,
                   assa.fob_lookup_code incoterms,
                   mmt.currency_code,
                   (SELECT ieb.bank_account_num
                      FROM IBY_EXTERNAL_PAYEES_ALL iep,
                           IBY_PMT_INSTR_USES_ALL ipi,
                           IBY_EXT_BANK_ACCOUNTS ieb
                     WHERE 1=1
                       AND iep.ext_payee_id = ipi.ext_pmt_party_id(+)
                       AND ipi.instrument_id = ieb.ext_bank_account_id
                       AND ipi.instrument_type = 'BANKACCOUNT'
                       AND TRUNC(SYSDATE) < TRUNC(NVL(ipi.end_date, SYSDATE + 1))
                       AND iep.payment_function = 'PAYABLES_DISB'
                       AND iep.supplier_site_id = assa.vendor_site_id
                       AND rownum <= 1) account_number,
                   msib.segment1 item,
                   mmt.TRANSACTION_QUANTITY qty,
                   mmt.TRANSACTION_UOM uom,
                   NULL comodity_code,
                   msib.description,
                   assa.country,
                   msib.unit_weight,
                   (mmt.Transaction_quantity * mmt.transaction_cost) net_value,
                   rt.quantity,
                   pha.segment1 po_number,
                   pha.creation_date gl_date
            -- ,rt.*
            FROM rcv_shipment_headers rsh,
                 rcv_shipment_lines rsl,
                 rcv_transactions rt,
                 po_headers_all pha,
                 mtl_material_transactions mmt,
                 mtl_item_locations_kfv mil,
                 ap_supplier_sites_all assa,
                 mtl_system_items_b msib  
            WHERE rsh.shipment_header_id = rsl.shipment_header_id
              AND rsl.shipment_header_id = rt.shipment_header_id
              AND rsl.SHIPMENT_LINE_ID = rt.SHIPMENT_LINE_ID
              AND rt.po_header_id = pha.po_header_id
              AND rt.transaction_id = mmt.RCV_TRANSACTION_ID
              AND mmt.locator_id = mil.inventory_location_id
              AND mmt.inventory_item_id = msib.inventory_item_id
              AND mmt.organization_id = msib.organization_id
              AND rt.vendor_site_id = assa.vendor_site_id
            -- AND transaction_source_id = 103
            -- AND transaction_type_id = 18
            AND rt.transaction_type = 'DELIVER'
            AND rsh.receipt_num = :P_RECEIPT_NUM
            

='DECLARE
BEGIN
XXQGEN_PO_SUBMIT_REQUISITION('||"${ITEM.OPERATING_UNITS.ORG_ID.VALUE}"||','||"${ITEM.ORDER.SOLD_TO.VALUE}"||');
END'

BEGIN 
  XXQGEN_PO_SUBMIT_REQUISITION(
    ' || $(ITEM.OPERATING_UNITS.ORG_ID.VALUE) || ',
    ' || $(ITEM.ORDER.SOLD_TO.VALUE) || ' 
  );
END;

='declare
begin
XXQGEN_PO_SUBMIT_REQUISITION('''||${ps.per_security_profile_id.value}||''', '''||${ps.per_security_profile_id.value}||''')
end'

='BEGIN 
  XXQGEN_PO_SUBMIT_REQUISITION(
    '" || $(ITEM.OPERATING_UNITS.ORG_ID.VALUE) || "',
    '" || $(ITEM.ORDER.SOLD_TO.VALUE) || "' 
  );
END'

='declare
begin
XXQGEN_PO_SUBMIT_REQUISITION("'||${OPERATING_UNITS.ORG_ID.value}||"','"||${ORDER.SOLD_TO.value}||"');
end'


='BEGIN 
xxqgen_po_submit_requisition ( 
                '"||${OPERATING_UNITS.ORG_ID.value}||"'
              , '"||${ORDER.SOLD_TO.value}||"');
END '




='BEGIN
  xxqgen_po_submit_requisition(
    :OPERATING_UNITS.ORG_ID.value, 
    :ORDER.SOLD_TO.value
  );
END''"
CREATE OR REPLACE procedure APPS.XX_I_JOIN_DATE_I_REQUEST(P_PER_SEC_PRO_ID number,P_PER_SEC_PRO_ID2 number)
IS
vRequest_id varchar2(20);
BEGIN
vRequest_id:= APPS.FND_REQUEST.SUBMIT_REQUEST(
                'PER',
                'DUTY_RESUME',--This is the short_name of Concurrent Program
                '',
                '',
                NULL,
                P_PER_SEC_PRO_ID);
                COMMIT;
END;