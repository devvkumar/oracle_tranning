create or replace package XXQGEN_ORDER_HOLD_FLAG_PKG_DK
as
  

   CODE VARCHAR(2000);
   P_FLAG        VARCHAR2(2);
   P_YEAR       VARCHAR2(15);

      FUNCTION afterreport
      RETURN BOOLEAN;

   FUNCTION beforereport
      RETURN BOOLEAN;


end XXQGEN_ORDER_HOLD_FLAG_PKG_DK;