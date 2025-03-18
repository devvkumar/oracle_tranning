BEGIN
 AD_ZD_TABLE.UPGRADE('PO','XXQGEN_PO_HEADER_DK');
 END;
 /
 
BEGIN
 AD_ZD_TABLE.PATCH('PO','XXQGEN_PO_HEADER_DK');
END;
/

 DROP TABLE XXQGEN_PO_HEADER_DK;
 
 
 CREATE TABLE PO.XXQGEN_PO_HEADER_DK(
                HEADER_ID   NUMBER
                                                                );
                                                                
                                                                
                                                                
SELECT *
FROM XXQGEN_PO_HEADER_DK;

DELETE FROM XXQGEN_PO_HEADER_DK WHERE HEADER_ID = 1;

INSERT INTO XXQGEN_PO_HEADER_DK (HEADER_ID) VALUES (1);