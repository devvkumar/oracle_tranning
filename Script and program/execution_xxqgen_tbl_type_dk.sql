BEGIN
    XXQGEN_TBL_TYPE_DK.P_HDR(1).HEADER_ID := 625;
--    DBMS_OUTPUT.PUT_LINE(XXQGEN_TBL_TYPE_DK.P_HDR(1).HEADER_ID);
    XXQGEN_TBL_TYPE_DK.MAIN(XXQGEN_TBL_TYPE_DK.P_HDR,XXQGEN_TBL_TYPE_DK.P_LINE);
    FOR I IN 1 .. XXQGEN_TBL_TYPE_DK.P_LINE.COUNT
    LOOP
        DBMS_OUTPUT.PUT_LINE(XXQGEN_TBL_TYPE_DK.P_LINE(I).LINE_NUM || ' '  || XXQGEN_TBL_TYPE_DK.P_LINE(I).QUANTITY || ' ' || 
                                                   XXQGEN_TBL_TYPE_DK.P_LINE(I).PRICE || ' ' || XXQGEN_TBL_TYPE_DK.P_LINE(I).ITEM_DESCRIPTION );
                                                    
    END LOOP;
END;
