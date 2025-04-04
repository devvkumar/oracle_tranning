create or replace package xxqgen_custom_error_raise_dk
as
    procedure main(ERRBUF OUT VARCHAR2, RETCODE OUT NUMBER);
end xxqgen_custom_error_raise_dk;
/