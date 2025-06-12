select *
from all_objects
where UPPER(object_name) like 'XXQGEN%DK';

XXQGEN_TEST_DK

CREATE OR REPLACE PACKAGE APPS.XXQGEN_TEST_DK AS
    PROCEDURE main(
        x_errbuff OUT NOCOPY VARCHAR2,
        x_retcode OUT NOCOPY VARCHAR2,
        p_request_id    in number,
        p_string            in varchar2
    );
END XXQGEN_TEST_DK;
/