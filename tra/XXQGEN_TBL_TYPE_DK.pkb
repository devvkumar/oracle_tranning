CREATE OR REPLACE PACKAGE BODY XXQGEN_TBL_TYPE_DK
AS
   PROCEDURE MAIN(P_HDR IN TBL_HDR, P_LINE OUT TBL_LINE)
   IS

      -- Cursor to fetch header data
--      CURSOR CUR_HDR(HEADER_ID NUMBER) IS
--         SELECT REQUISITION_HEADER_ID
--           FROM PO_REQUISITION_HEADERS_ALL
--          WHERE REQUISITION_HEADER_ID = HEADER_ID;

      -- Cursor to fetch line details
      CURSOR CUR_LINE(P_HDR NUMBER) IS
         SELECT LINE_NUM, QUANTITY, UNIT_PRICE, ITEM_DESCRIPTION
           FROM PO_REQUISITION_LINES_ALL
          WHERE REQUISITION_HEADER_ID = P_HDR;

        I NUMBER := 1;

   BEGIN
      -- Iterate through P_HDR (indexed table)
      i := P_HDR.FIRST;

      FOR k IN 1 .. P_HDR.COUNT
      LOOP
            FOR line_rec IN CUR_LINE(P_HDR(i).HEADER_ID) LOOP
               -- Store data into P_LINE
               P_LINE(i).LINE_NUM := line_rec.LINE_NUM;
               P_LINE(i).QUANTITY := line_rec.QUANTITY;
               P_LINE(i).PRICE := line_rec.UNIT_PRICE;
               P_LINE(i).ITEM_DESCRIPTION := line_rec.ITEM_DESCRIPTION;

            END LOOP;
            I := I+1;
      END LOOP;
   EXCEPTION
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE (
            'ERROR IN MAIN: ' || SQLCODE || ' - ' || SQLERRM);
   END MAIN;

END XXQGEN_TBL_TYPE_DK;
/
