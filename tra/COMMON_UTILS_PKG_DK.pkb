CREATE OR REPLACE PACKAGE BODY COMMON_UTILS_PKG_DK AS
 
FUNCTION REMOVE_SPL_CHAR (
        p_in_str   IN VARCHAR2
    ) RETURN VARCHAR2 AS
        l_length    NUMBER;
        l_ascii     NUMBER;
        l_out_str   VARCHAR2(32767);
    BEGIN
        l_length := length(
            p_in_str
        );
        FOR i IN 1..l_length LOOP
            l_ascii := ascii(
                substr(
                    p_in_str,
                i,1)
            );
            IF (
                    l_ascii >= 32
                AND
                    l_ascii <= 126
            ) THEN
                l_out_str := l_out_str
                 ||  chr(
                    l_ascii
                );
            ELSE
                l_out_str := l_out_str || NULL;
            END IF;

        END LOOP;

        return(
            l_out_str
        );
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
END REMOVE_SPL_CHAR;
 
END COMMON_UTILS_PKG_DK;


/
