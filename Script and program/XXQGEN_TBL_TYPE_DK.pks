CREATE OR REPLACE PACKAGE XXQGEN_TBL_TYPE_DK
AS
   /***************************************************************************************************
    * Program Name : XXQGEN_TBL_TYPE_DK.pks
    * Language     : PL/SQL
    * Description  : Specks for XXQGEN_TBL_TYPE_DK.pks
    * History      :
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR          1.0         12-FEB-2025     Initial Version
    ***************************************************************************************************/
    TYPE REC_HDR IS RECORD 
    (
        HEADER_ID NUMBER,
        SEGMENT1  VARCHAR2(50)
    );
    
    TYPE TBL_HDR IS TABLE OF REC_HDR INDEX BY BINARY_INTEGER;
    
    P_HDR TBL_HDR;
    
    TYPE REC_LINE IS RECORD
    (
        LINE_NUM        NUMBER,
        QUANTITY        NUMBER,
        PRICE              NUMBER,
        ITEM_DESCRIPTION   VARCHAR2(100)
    );
    
    TYPE TBL_LINE IS TABLE OF REC_LINE INDEX BY BINARY_INTEGER;
    
    P_LINE TBL_LINE;

   PROCEDURE MAIN(P_HDR IN TBL_HDR, P_LINE OUT TBL_LINE);
END XXQGEN_TBL_TYPE_DK;