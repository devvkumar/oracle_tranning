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

   BEGIN
   
        FOR REC_HEAD_DATA IN CUR_HEAD_DATA LOOP
            INSERT INTO WITH_WITHOUT_REQ_DK (
                                segment1,
                                PO_HEADER_ID,
                                LINE_NUM,
                                UNIT_PRICE,
                                QUANTITY,
                                AMOUNT)
            VALUES (REC_HEAD_DATA.segment1,
                                REC_HEAD_DATA.po_header_id,
                                REC_HEAD_DATA.LINE_NUM,
                                REC_HEAD_DATA.UNIT_PRICE,
                                REC_HEAD_DATA.QUANTITY,
                                REC_HEAD_DATA.AMOUNT);
            FND_FILE.PUT_LINE ( FND_FILE.LOG, 'ERROR IN BULK COLLECT BEGIN END: ' || SQLCODE || '-' || SQLERRM);
        END LOOP;
      COMMIT;

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
