CREATE OR REPLACE PACKAGE BODY XXQGEN_PO_REQ_BULK_COLL_DK IS
    FUNCTION beforereport (
        P_REQ_TYPE         IN VARCHAR2,
        P_REQUESTER_NAME   IN VARCHAR2,
        P_LINE_NUM         IN VARCHAR2,
        P_REQ_HDR_ID       IN VARCHAR2,
        P_ORG_ID           IN VARCHAR2
    ) RETURN BOOLEAN
    AS
        -- Cursor for Q_MAIN
        CURSOR CUR_HEAD_DATA IS
            SELECT 
                PRHA.REQUISITION_HEADER_ID HEADER_ID,
                PRHA.PREPARER_ID,
                PAPF.EMAIL_ADDRESS,
                PAPF.FULL_NAME,
                PRHA.SEGMENT1,
                PRHA.DESCRIPTION,
                PRHA.AUTHORIZATION_STATUS AUTH_STATUS,
                PRHA.TYPE_LOOKUP_CODE LOOKUP_CODE,
                PRHA.ORG_ID,
                HOU.NAME ORG_NAME
            FROM 
                PO_REQUISITION_HEADERS_ALL PRHA,
                PER_ALL_PEOPLE_F PAPF,
                HR_ORGANIZATION_UNITS HOU,
                PO_DOCUMENT_TYPES_ALL_VL PDTAV
            WHERE 
                PRHA.PREPARER_ID = PAPF.PERSON_ID
                AND PRHA.ORG_ID = HOU.ORGANIZATION_ID
                AND PDTAV.DOCUMENT_SUBTYPE = PRHA.TYPE_LOOKUP_CODE
                AND PRHA.ORG_ID = PDTAV.ORG_ID
                AND PDTAV.DOCUMENT_TYPE_CODE = 'REQUISITION'
                AND (PRHA.REQUISITION_HEADER_ID = P_REQ_HDR_ID OR P_REQ_HDR_ID IS NULL)
                AND (PRHA.ORG_ID = P_ORG_ID OR P_ORG_ID IS NULL)
                AND (PRHA.TYPE_LOOKUP_CODE = P_REQ_TYPE OR P_REQ_TYPE IS NULL)
                AND (PAPF.FULL_NAME = P_REQUESTER_NAME OR P_REQUESTER_NAME IS NULL);

        -- Cursor for Q_MAIN2
        CURSOR CUR_LINE_DATA (HEADER_ID IN NUMBER) IS
            SELECT 
                PRLA.LINE_NUM, 
                MSIB.SEGMENT1 NAME,
                PRLA.ITEM_DESCRIPTION DESCRIPTION,
                PRLA.ITEM_ID,
                PRLA.QUANTITY, 
                PRLA.UNIT_PRICE,
                PRLA.QUANTITY * PRLA.UNIT_PRICE AMOUNT,
                GCC.SEGMENT1 || '-' || GCC.SEGMENT2 || '-' || GCC.SEGMENT3 || '-' || GCC.SEGMENT4 AS CHARGE_ACCOUNT
            FROM 
                PO_REQUISITION_LINES_ALL PRLA,
                PO_REQ_DISTRIBUTIONS_ALL PRDA,
                MTL_SYSTEM_ITEMS_B MSIB,
                GL_CODE_COMBINATIONS GCC
            WHERE 
                PRDA.REQUISITION_LINE_ID = PRLA.REQUISITION_LINE_ID
                AND PRDA.CODE_COMBINATION_ID = GCC.CODE_COMBINATION_ID
                AND MSIB.INVENTORY_ITEM_ID = PRLA.ITEM_ID
                AND (PRLA.REQUISITION_HEADER_ID = HEADER_ID OR HEADER_ID IS NULL);
    
        -- Variable to store fetched data
        TYPE CUR_HEAD_DATA_TYPE IS TABLE OF CUR_HEAD_DATA%ROWTYPE INDEX BY PLS_INTEGER;
        HEAD_TBL        CUR_HEAD_DATA_TYPE;
        
        TYPE CUR_LINE_DATA_TYPE IS TABLE OF CUR_LINE_DATA%ROWTYPE INDEX BY PLS_INTEGER;
        LINE_TBL         CUR_LINE_DATA_TYPE;
        
    BEGIN
        -- Fetch data from Q_MAIN
        OPEN CUR_HEAD_DATA;
        LOOP
            FETCH CUR_HEAD_DATA BULK COLLECT INTO HEAD_TBL LIMIT 100;

            -- Exit when no more rows are found
            EXIT WHEN HEAD_TBL.COUNT = 0;

            FOR I IN 1 .. HEAD_TBL.COUNT LOOP
                -- Fetch line data for the current header
                OPEN CUR_LINE_DATA(HEAD_TBL(I).HEADER_ID);
                LOOP
                    FETCH CUR_LINE_DATA BULK COLLECT INTO LINE_TBL LIMIT 100;

                    -- Exit when no more rows are found
                    EXIT WHEN LINE_TBL.COUNT = 0;

                    FOR J IN 1 .. LINE_TBL.COUNT LOOP
                        -- Insert consolidated data into staging table
                        INSERT INTO XXQGEN_PO_REQ_DK (
                            HEADER_ID, 
                            PREPARER_ID, 
                            EMAIL_ADDRESS, 
                            FULL_NAME, 
                            SEGMENT1, 
                            DESCRIPTION, 
                            AUTH_STATUS, 
                            LOOKUP_CODE, 
                            ORG_ID, 
                            ORG_NAME, 
                            LINE_NUM, 
                            ITEM_NAME, 
                            ITEM_DESCRIPTION, 
                            ITEM_ID, 
                            QUANTITY, 
                            UNIT_PRICE, 
                            AMOUNT, 
                            CHARGE_ACCOUNT
                        )
                        VALUES (
                            HEAD_TBL(I).HEADER_ID, 
                            HEAD_TBL(I).PREPARER_ID, 
                            HEAD_TBL(I).EMAIL_ADDRESS, 
                            HEAD_TBL(I).FULL_NAME, 
                            HEAD_TBL(I).SEGMENT1, 
                            HEAD_TBL(I).DESCRIPTION, 
                            HEAD_TBL(I).AUTH_STATUS, 
                            HEAD_TBL(I).LOOKUP_CODE, 
                            HEAD_TBL(I).ORG_ID, 
                            HEAD_TBL(I).ORG_NAME, 
                            LINE_TBL(J).LINE_NUM, 
                            LINE_TBL(J).NAME, 
                            LINE_TBL(J).DESCRIPTION, 
                            LINE_TBL(J).ITEM_ID, 
                            LINE_TBL(J).QUANTITY, 
                            LINE_TBL(J).UNIT_PRICE, 
                            LINE_TBL(J).AMOUNT, 
                            LINE_TBL(J).CHARGE_ACCOUNT
                        );
                    END LOOP;
                END LOOP;
                CLOSE CUR_LINE_DATA;
            END LOOP;
        END LOOP;
        CLOSE CUR_HEAD_DATA;

        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            FND_FILE.PUT_LINE(FND_FILE.LOG, 'Error in beforeTrigger: ' || SQLCODE || ' - ' || SQLERRM);
            RETURN FALSE;
    END beforereport;
    
    FUNCTION afterreport 
    RETURN BOOLEAN
    IS
    BEGIN
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN FALSE;
    END afterreport;
END XXQGEN_PO_REQ_BULK_COLL_DK;
