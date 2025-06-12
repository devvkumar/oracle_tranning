SELECT prh.segment1 req_number,
       prd.distribution_id,
       poh.segment1 po_num,
       poh.org_id,
       rsh.receipt_num,
       api.invoice_num,
       apl.line_number,
       aps.vendor_name
FROM  -- Purchase Requisition --
     po_requisition_headers_all prh,
     po_requisition_lines_all prl,
     po_req_distributions_all prd,
     -- Purchase Order --
     po_distributions_all pod,
     po_headers_all poh,
     po_lines_all pol,
     -- Receipt --
     rcv_transactions rct,
     rcv_shipment_lines rsl,
     rcv_shipment_headers rsh,
     -- AP Invoice --
     ap_invoice_distributions_all apd,
     ap_invoice_lines_all apl,
     ap_invoices_all api,
     -- Subledger Accounting--
     xla_distribution_links xldl,
     apps.xla_ae_lines al,
     xla_ae_headers ah,
     apps.xla_events e,
     apps.xla_transaction_entities te,
     -- GL --
     gl_import_references gir,
     apps.gl_je_lines jl,
     gl_je_headers glh,
     apps.gl_code_combinations glcc,
    -- Supplier Detail --
     ap_suppliers aps
WHERE  1 = 1
       -- Purchase Requisition --
      AND prh.requisition_header_id = prl.requisition_header_id
      AND prl.requisition_line_id = prd.requisition_line_id
      -- Purchase Requisition TO  Purchase Order --
      AND prd.distribution_id = pod.req_distribution_id
      -- Purchase Order --
      AND pol.po_line_id = pod.po_line_id
      AND poh.po_header_id = pol.po_header_id
      -- Purchase Order  TO Receipt --
      AND pod.po_distribution_id = rct.po_distribution_id
      -- Receipt --
      AND rct.shipment_line_id = rsl.shipment_line_id
      AND rsh.shipment_header_id = rsl.shipment_header_id
      -- Receipt TO Invoice --
      AND apd.po_distribution_id = rct.po_distribution_id
      -- AP Invoice --
      AND api.invoice_id = apd.invoice_id
      AND api.invoice_id = apl.invoice_id
      -- AP Invoice TO Sub ledger Accounting --
      AND xldl.applied_to_source_id_num_1 = api.invoice_id
      AND xldl.source_distribution_id_num_1 = apd.invoice_distribution_id
      -- Sub ledger Accounting --
      AND xldl.ae_line_num = al.ae_line_num
      AND xldl.ae_header_id = al.ae_header_id
      AND al.ae_header_id = ah.ae_header_id
      AND al.application_id = ah.application_id
      AND ah.event_id = e.event_id
      AND e.entity_id = te.entity_id(+)
      AND e.application_id = te.application_id(+)
      -- Subledger Accounting  TO   GL  --
      AND al.gl_sl_link_id = gir.gl_sl_link_id
      -- GL  ---
      AND gir.je_header_id = jl.je_header_id
      AND gir.je_line_num = jl.je_line_num
      AND jl.je_header_id = glh.je_header_id
     AND jl.code_combination_id = glcc.code_combination_id
      -- Supplier Detail --
      AND api.vendor_id = aps.vendor_id
      AND ah.je_category_name = 'Purchase Invoices'
      AND ah.gl_transfer_status_code= 'Y'
      AND glh.STATUS='P'
      --      AND api.invoice_num = 'ERS-9772-135635'