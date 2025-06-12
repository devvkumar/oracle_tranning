/* Formatted on 2/12/2025 10:35:52 AM (QP5 v5.163.1008.3004) */
CREATE OR REPLACE PACKAGE XXQGEN_REQ_INT_DK
AS

    GC_BATCH_ID           NUMBER      := XXQGEN_PO_REQ_BATCH_ID_DK.NEXTVAL;
    GC_REQUEST_ID       NUMBER      := 1001; --FND_PROFILE.VALUE('CONC_REQUEST_ID');
    
   /***************************************************************************************************
    * Program Name : XXQGEN_REQ_INT_DK.pks
    * Language     : PL/SQL
    * Description  : Specks for XXQGEN_REQ_INT_DK.pks
    * History      :
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR          1.0         16-FEB-2025     Initial Version
    *******************************S********************************************************************/
    PROCEDURE VALIDATION(P_BATCH_ID NUMBER);
    PROCEDURE VALIDATE_REQUIRE(P_BATCH_ID NUMBER);

    PROCEDURE MAIN(errbuf   out varchar2,
                retcode  out number);
END XXQGEN_REQ_INT_DK;