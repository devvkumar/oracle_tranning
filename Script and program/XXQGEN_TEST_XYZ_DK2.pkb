create or replace package xxqgen_test_xyz_dk
as
--    pragma autonomous_transaction;
    procedure main;
    
    function run;
end xxqgen_test_xyz_dk;
/


create or replace package body xxqgen_test_xyz_dk
as
    pragma autonomous_transaction;
    procedure main
    is
    begin
        insert into XXQGEN_PRAGMA_AUTO_TEST_DK values (3,'d');
    end main;
end xxqgen_test_xyz_dk;
/