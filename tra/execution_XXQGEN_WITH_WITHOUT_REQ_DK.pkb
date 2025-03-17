CREATE OR REPLACE PACKAGE BODY XXQGEN_WITH_WITHOUT_REQ_DK
IS
   FUNCTION beforereport (P_ORG_ID IN NUMBER, P_REQ_TYPE IN VARCHAR2)
      RETURN BOOLEAN
   AS
      -- Cursor for Q_MAIN
      CURSOR CUR_HEAD_DATA
      IS
         SELECT pha.segment1,
                pha.po_header_id,
                pla.line_num,
                pla.unit_price,
                PLA.QUANTITY,
                pla.unit_price * pla.quantity amount,
                HOU.ORGANIZATION_ID,
                HOU.NAME
           FROM po_headers_all pha,
                po_lines_all pla,
                po_distributions_all pda,
                HR_OPERATING_UNITS HOU
          WHERE     1 = 1
                AND pha.po_header_id = pla.po_header_id
                AND pla.po_line_id = pda.po_line_id
                AND PHA.ORG_ID = HOU.ORGANIZATION_ID
                AND pda.REQ_DISTRIBUTION_ID IS NULL
                AND ROWNUM < 50
                AND (HOU.ORGANIZATION_ID = P_ORG_ID OR P_ORG_ID IS NULL)
                AND 1 = DECODE (P_REQ_TYPE, 'WITH REQUISITION', 1, 2)
         UNION
         SELECT pha.segment1,
                pha.po_header_id,
                pla.line_num,
                pla.unit_price,
                PLA.QUANTITY,
                pla.unit_price * pla.quantity amount,
                HOU.ORGANIZATION_ID,
                HOU.NAME
           FROM po_headers_all pha,
                po_lines_all pla,
                po_distributions_all pda,
                HR_OPERATING_UNITS HOU
          WHERE     1 = 1
                AND pha.po_header_id = pla.po_header_id
                AND pla.po_line_id = pda.po_line_id
                AND PHA.ORG_ID = HOU.ORGANIZATION_ID
                AND pda.REQ_DISTRIBUTION_ID IS NULL
                AND ROWNUM < 50
                AND (HOU.ORGANIZATION_ID = P_ORG_ID OR P_ORG_ID IS NULL)
                AND 1 = DECODE (P_REQ_TYPE, 'WITHOUT REQUISITION', 1, 2);

        v_segment1       VARCHAR2(500);
        v_po_header_id   NUMBER;
        v_line_num       NUMBER;
        v_unit_price     NUMBER;
        v_quantity       NUMBER;
        v_amount         NUMBER;
        v_organization_id NUMBER;
        v_name           VARCHAR2(500);

   BEGIN
   
         -- Open the cursor
    OPEN CUR_HEAD_DATA;
    
    LOOP
        -- Fetch data into variables
        FETCH CUR_HEAD_DATA INTO v_segment1, v_po_header_id, v_line_num, v_unit_price,
                                v_quantity, v_amount, v_organization_id, v_name;
        EXIT WHEN CUR_HEAD_DATA%NOTFOUND;

        -- Display data (for debugging)
        FND_FILE.PUT_LINE(FND_FILE.LOG,'Segment: ' || v_segment1 || ', PO Header ID: ' || v_po_header_id);
        
        -- Insert
         INSERT INTO WITH_WITHOUT_REQ_DK2 (
                                segment1,
                                PO_HEADER_ID,
                                LINE_NUM,
                                UNIT_PRICE,
                                QUANTITY,
                                AMOUNT)
            VALUES (v_segment1,
                                v_po_header_id,
                                v_line_num,
                                v_unit_price,
                                v_quantity,
                                v_amount);
    END LOOP;

    -- Close the cursor
    CLOSE CUR_HEAD_DATA;

      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         -- Log error to FND_FILE
         FND_FILE.PUT_LINE (
            FND_FILE.LOG,
            'Error in beforeTrigger: ' || SQLCODE || ' - ' || SQLERRM);
         RETURN FALSE;
   END beforereport;

   FUNCTION afterreport
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN FALSE;
   END afterreport;
END XXQGEN_WITH_WITHOUT_REQ_DK;
