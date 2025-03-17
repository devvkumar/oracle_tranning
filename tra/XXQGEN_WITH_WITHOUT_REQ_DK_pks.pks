CREATE OR REPLACE PACKAGE XXQGEN_WITH_WITHOUT_REQ_DK
AS
    P_ORG_ID            NUMBER;
    P_REQ_TYPE          VARCHAR2(100);
 
    FUNCTION afterreport RETURN BOOLEAN;
    FUNCTION beforereport(
        P_ORG_ID                     IN     NUMBER,
        P_REQ_TYPE                 IN     VARCHAR2
    ) RETURN BOOLEAN;
END XXQGEN_WITH_WITHOUT_REQ_DK;