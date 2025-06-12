-- program to execute a concurrent program from backend

DECLARE
LC_ID NUMBER:=0;
l_layout boolean;
BEGIN
apps.fnd_global.apps_initialize ('1014382','50578','201');

l_layout := apps.fnd_request.add_layout(
                            template_appl_name => 'PO',
                            template_code      => 'XXQGEN_AD15',
                            template_language  => 'en',
                            template_territory => 'US',
                            output_format      => 'PDF');

LC_ID:= fnd_request.submit_request('PO','XXQGEN_AD15');
COMMIT;
if lc_id = 0 then
    dbms_output.put_line('error in execution');
else 
    dbms_output.put_line(LC_ID||' '||'running');
end if;
END;