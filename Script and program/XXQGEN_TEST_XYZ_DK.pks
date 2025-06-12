insert into XXQGEN_PRAGMA_AUTO_TEST_DK values (1,  'A');

declare
pragma AUTONOMOUS_TRANSACTION;
begin

    insert into xxqgen_pragma_auto_test_dk values (2,'B');
--    commit;

end;
/

select *
from xxqgen_pragma_auto_test_dk;

rollback;


create or replace package xxqgen_test_xyz_dk
as
    pragma autonomous_transaction;
    procedure main;
end xxqgen_test_xyz_dk;