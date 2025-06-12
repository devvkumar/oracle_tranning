CREATE OR REPLACE PACKAGE BODY XXQGEN_INVOICE_AP_STATUS 
IS
    FUNCTION beforereport (P_END_CREATION_DATE IN DATE, P_START_CREATION_DATE IN DATE, P_TRADING_PARTNER IN VARCHAR2) RETURN BOOLEAN
    AS
        CURSOR CUR_INVOICE_DATA IS 
            SELECT 
                inv1.vendor_id AS c_vendor_id,
                hp.party_name AS trading_partner,
                TO_CHAR(inv1.invoice_date, 'DD-MON-RRRR HH24:MI') AS invoice_date,
                b.batch_name AS batch_name,
                inv1.invoice_id AS c_invoice_id,
                inv1.invoice_num AS invoice_num,
                (SELECT DISTINCT poh.segment1 AS c_po_number
                   FROM po_headers poh,
                        po_distributions_all pda,
                        ap_invoice_distributions_all aida
                  WHERE poh.po_header_id = pda.po_header_id
                    AND pda.po_distribution_id = aida.po_distribution_id
                    AND aida.invoice_id = inv1.invoice_id) AS po_number,
                DECODE(inv1.invoice_currency_code,
                       'USD', inv1.invoice_amount,
                       inv1.base_amount) AS original_amount,
                DECODE(inv1.invoice_currency_code,
                       'USD', inv1.invoice_amount,
                       inv1.base_amount) 
                - DECODE(inv1.payment_currency_code,
                         'USD', NVL(inv1.amount_paid, 0) + NVL(discount_amount_taken, 0),
                         ROUND((DECODE(inv1.payment_cross_rate_type,
                                       'EMU FIXED', 1 / inv1.payment_cross_rate,
                                       inv1.exchange_rate) * NVL(inv1.amount_paid, 0)), f.precision)
                         + ROUND((DECODE(inv1.payment_cross_rate_type,
                                         'EMU FIXED', 1 / inv1.payment_cross_rate,
                                         inv1.exchange_rate) * NVL(inv1.discount_amount_taken, 0)), f.precision)
                        ) AS amount_remaining,
                inv1.description AS c_description,
                apps.ap_invoices_pkg.get_approval_status(
                    inv1.invoice_id, inv1.invoice_amount, 
                    inv1.payment_status_flag, inv1.invoice_type_lookup_code
                ) AS approval_status,
                aiaha.last_update_date AS due_date,
                apt.name AS payment_term,
                aiaha.response AS notes,
                aiaha.approver_name
            FROM 
                hz_parties hp,
                ap_invoices_all inv1,
                ap_batches_all b,
                ap_payment_schedules_all s,
                ap_terms apt,
                ap_inv_aprvl_hist_all aiaha,
                fnd_currencies_vl f
            WHERE hp.party_id = inv1.party_id
              AND (hp.party_id = P_TRADING_PARTNER OR P_TRADING_PARTNER IS NULL)
              AND b.batch_id(+) = inv1.batch_id
              AND s.invoice_id(+) = inv1.invoice_id
              AND apt.term_id = inv1.terms_id
              AND aiaha.invoice_id(+) = inv1.invoice_id
              AND f.currency_code = inv1.invoice_currency_code
              AND f.currency_code = 'USD'
              AND TRUNC(inv1.creation_date) >= NVL(TRUNC(P_START_CREATION_DATE), TRUNC(inv1.creation_date))
              AND TRUNC(inv1.creation_date) <= NVL(TRUNC(P_END_CREATION_DATE), TRUNC(inv1.creation_date));
              
        TYPE CUR_INVOICE_DATA_TYPE IS TABLE OF CUR_INVOICE_DATA%ROWTYPE INDEX BY PLS_INTEGER;
        INV_TBL CUR_INVOICE_DATA_TYPE;

    BEGIN
        -- Free unused memory
        DBMS_SESSION.free_unused_user_memory;

        -- Open the cursor and fetch data in bulk
        OPEN CUR_INVOICE_DATA;
        LOOP
            FETCH CUR_INVOICE_DATA BULK COLLECT INTO INV_TBL LIMIT 100;

            -- Process the fetched data
            FORALL IDX IN 1 .. INV_TBL.COUNT
                INSERT INTO XXQGEN_PO_APPROV_STATUS_DK -- Replace with actual table name
                (VENDOR_ID, 
                TRADING_PARTNER, 
                INVOICE_DATE, 
                BATCH_NAME, 
                INVOICE_ID, 
                INVOICE_NUM, 
                PO_NUMBER, 
                ORIGINAL_AMOUNT, 
                 AMOUNT_REMAINING, 
                 DESCRIPTION, 
                 APPROVAL_STATUS, 
                 DUE_DATE, 
                 payment_term, 
                 NOTES, 
                 APPROVER_NAME)
                VALUES 
                (INV_TBL(IDX).c_vendor_id, 
                INV_TBL(IDX).trading_partner, 
                INV_TBL(IDX).invoice_date, 
                INV_TBL(IDX).batch_name, 
                INV_TBL(IDX).c_invoice_id, 
                INV_TBL(IDX).invoice_num, 
                INV_TBL(IDX).po_number, 
                INV_TBL(IDX).original_amount, 
                INV_TBL(IDX).amount_remaining, 
                INV_TBL(IDX).c_description, 
                INV_TBL(IDX).approval_status, 
                INV_TBL(IDX).due_date, 
                 INV_TBL(IDX).payment_term, 
                 INV_TBL(IDX).notes, 
                 INV_TBL(IDX).approver_name);

            EXIT WHEN INV_TBL.COUNT = 0;
        END LOOP;

        -- Close the cursor
        CLOSE CUR_INVOICE_DATA;

        RETURN TRUE;

    EXCEPTION
        WHEN OTHERS THEN
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR: ' || SQLCODE || ' : ' || SQLERRM);
            RETURN FALSE;
    END beforereport;

    FUNCTION afterreport (p_orgid IN NUMBER) RETURN BOOLEAN
    AS
    BEGIN
        -- Uncomment and specify the table name if truncation is needed
        -- EXECUTE IMMEDIATE 'TRUNCATE TABLE XXQGEN_PO_APPROV_STATUS_DK';
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR in afterReport: ' || SQLERRM);
            RETURN FALSE;
    END afterreport;

END XXQGEN_INVOICE_AP_STATUS;
