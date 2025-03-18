/* Formatted on 2/12/2025 10:35:52 AM (QP5 v5.163.1008.3004) */
CREATE OR REPLACE PACKAGE XXQGEN_PO_REQ_IMP_DK
AS

    GC_REQUEST_ID       NUMBER      := FND_PROFILE.VALUE('CONC_REQUEST_ID');
    
   /***************************************************************************************************
    * Program Name : XXQGEN_REQ_INT_DK.pks
    * Language     : PL/SQL
    * Description  : Specks for XXQGEN_REQ_INT_AD.pks
    * History      :
    * WHO              Version #   WHEN            WHAT
    * ======================================================================
    * DKUMAR          1.0         11-FEB-2025     Initial Version
    *******************************S********************************************************************/
    PROCEDURE BEFOREREPORT;
    PROCEDURE AFTERREPORT;

END XXQGEN_PO_REQ_IMP_DK;