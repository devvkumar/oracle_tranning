declare
pragma AUTONOMOUS_TRANSACTION;
lv1     number;
lv2     number;

begin
    declare
    pragma autonomous_transaction;
    begin
    
        select requisition_header_id
        into lv1
        from po_requisition_headers_all;
    exception
        when others then
            dbms_output.put_line('error in first anomonous block : ' || sqlerrm );
    end;
    begin
        select segment1
        into lv2
        from po_requisition_headers_all
        where segment1 = '0000000';
    exception
        when others then
            dbms_output.put_line('error in inner second anomonous block : ' || sqlerrm || ' - ' || sqlcode);
    end;
end;


declare
    custom_error exception;
    salary  number := 0;
begin
    if salary <= 0 then
        raise custom_error;
    end if;
exception
    when custom_error then
        dbms_output.put_line('custom exception is raise');
    when others then
        dbms_output.put_line('others error : ' || sqlerrm || ' - ' || sqlcode);
end;
/

declare
    user_define_exception       exception;
    pragma exception_init(user_define_exception, +100);
    lv_user_name  varchar2(500);
begin

    select user_name
    into lv_user_name
    from fnd_user
    where user_id = 01313131313133313;

exception
    when user_define_exception then
        dbms_output.put_line('error comming : ' || sqlerrm || ' - ' || sqlcode );
end;
/