create or replace package body XXQGEN_LEX_HDR_LINE_PKG_DK
as

   FUNCTION afterreport
      RETURN BOOLEAN
      IS
    BEGIN 
     RETURN TRUE;
    END afterreport;
	
	FUNCTION GET_ORG_ID(P_ORG_ID NUMBER) 
	RETURN VARCHAR2
	IS
	BEGIN
		SELECT NAME
		INTO P_ORG_NAME
		FROM HR_OPERATING_UNITS
		WHERE ORGANIZATION_ID = P_ORG_ID;
		
		RETURN P_ORG_NAME;
	EXCEPTION
		WHEN OTHERS THAN 
			FND_FILE.PUT_LINE(FND_FILE.LOG, 'ERROR IN GET_ORG_ID FUNCTION ' || SQLCODE || ' - '|| SQLERRM);
	END GET_ORG_ID;

   FUNCTION beforereport
      RETURN BOOLEAN
      IS
     BEGIN 
	 
	 P_ORG_NAME := GET_ORG_ID(P_ORG_ID);
     
     IF P_ITEM_ID IS  NULL THEN
        LP_ITEM :='AND 1=1';
     ELSE
     LP_ITEM :='AND exists
        (SELECT 1
         FROM po_requisition_lines_all prla 
         WHERE prla.requisition_header_id = prha.requisition_header_id
         AND prla.ITEM_ID = :P_ITEM_ID)';
    END IF;
    RETURN TRUE;
   END beforereport;

end XXQGEN_LEX_HDR_LINE_PKG_DK;