CREATE OR REPLACE PACKAGE BODY XXQGEN_REQ_GRP_PAR_RPT_DS
AS 

   FUNCTION afterreport
      RETURN BOOLEAN
      IS
    BEGIN 
    
     RETURN TRUE;
    END afterreport;

   FUNCTION beforereport
      RETURN BOOLEAN
      IS
     BEGIN 
     
     RETURN TRUE
    END beforereport;

END XXQGEN_REQ_GRP_PAR_RPT_DS;