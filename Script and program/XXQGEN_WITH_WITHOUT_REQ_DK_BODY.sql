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

      -- Variable to store fetched data
      TYPE CUR_HEAD_DATA_TYPE IS TABLE OF CUR_HEAD_DATA%ROWTYPE
                                    INDEX BY PLS_INTEGER;

      HEAD_TBL   CUR_HEAD_DATA_TYPE;
   BEGIN
      -- Fetch data from CUR_HEAD_DATA
      OPEN CUR_HEAD_DATA;

      LOOP
         FETCH CUR_HEAD_DATA
         BULK COLLECT INTO HEAD_TBL;

         BEGIN
            IF HEAD_TBL.COUNT > 0 THEN
                FORALL I IN 1 .. HEAD_TBL.COUNT
                   INSERT INTO WITH_WITHOUT_REQ_DK (segment1,
                                                    PO_HEADER_ID,
                                                    LINE_NUM,
                                                    UNIT_PRICE,
                                                    QUANTITY,
                                                    AMOUNT)
                        VALUES (HEAD_TBL (I).segment1,
                                HEAD_TBL (I).po_header_id,
                                HEAD_TBL (I).LINE_NUM,
                                HEAD_TBL (I).UNIT_PRICE,
                                HEAD_TBL (I).QUANTITY,
                                HEAD_TBL (I).AMOUNT);
                         FND_FILE.PUT_LINE ( FND_FILE.LOG, 'ERROR IN BULK COLLECT BEGIN END: ' || SQLCODE || '-' || SQLERRM);
                         COMMIT;
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               FND_FILE.PUT_LINE (
                  FND_FILE.LOG,
                     'ERROR IN BULK COLLECT BEGIN END: '
                  || SQLCODE
                  || '-'
                  || SQLERRM);
         END;

         -- Exit when no more rows are found
         EXIT WHEN HEAD_TBL.COUNT = 0;
      END LOOP;

      CLOSE CUR_HEAD_DATA;

      -- Commit all changes outside the loop
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
      -- You can include logic for after-report actions if necessary
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         -- If any error occurs, return false
         RETURN FALSE;
   END afterreport;
END XXQGEN_WITH_WITHOUT_REQ_DK;
