CREATE OR REPLACE PACKAGE BODY xxqgen_metadata_po_depn_dk
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
     
     RETURN TRUE;
    END beforereport;

END xxqgen_metadata_po_depn_dk;