create or replace package body XXQGEN_ORDER_HOLD_FLAG_PKG_DK
as

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
     
     
     IF P_FLAG = 'N' THEN
        CODE :='AND OHA.RELEASE_FLAG = ''Y''';
     ELSE
        CODE := 'AND 1=1';
    END IF;
    RETURN TRUE;
   END beforereport;

end XXQGEN_ORDER_HOLD_FLAG_PKG_DK;