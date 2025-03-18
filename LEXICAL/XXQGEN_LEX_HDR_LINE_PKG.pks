create or replace package XXQGEN_LEX_HDR_LINE_PKG_DK
as
   gn_org_id   hr_all_organization_units.organization_id%TYPE := fnd_profile.VALUE ( 'ORG_ID' );
   gc_user_name   fnd_user.user_name%TYPE  := fnd_profile.VALUE ( 'USERNAME' );
   gc_resp_name   fnd_responsibility_tl.responsibility_name%TYPE := fnd_profile.VALUE ( 'RESP_NAME' );
   gn_request_id   fnd_concurrent_requests.request_id%TYPE  := fnd_profile.VALUE ( 'CONC_REQUEST_ID' );
   gn_user_id      fnd_user.user_id%TYPE  := fnd_profile.VALUE ( 'USER_ID' );
   gn_resp_id      fnd_responsibility_tl.responsibility_id%TYPE  := fnd_profile.VALUE ( 'RESP_ID' );
   gn_resp_appl_id fnd_responsibility_tl.application_id%TYPE  := fnd_profile.VALUE ( 'RESP_APPL_ID' );
   gn_login_id     fnd_logins.login_id%TYPE  := fnd_profile.VALUE ( 'LOGIN_ID' );
   gd_date DATE := SYSDATE;
  
   P_REQ_HDR_ID PO_REQUISITION_HEADERS_ALL.REQUISITION_HEADER_ID%TYPE;
   
   P_ORG_ID HR_OPERATING_UNITS.ORGANIZATION_ID%TYPE;
   
   P_ORG_NAME VARCHAR2(100);
   
   P_REQ_TYPE PO_REQUISITION_HEADERS_ALL.TYPE_LOOKUP_CODE%TYPE ;

   P_REQ_NAME_ID NUMBER ;

   P_ITEM_ID mtl_system_items_b.SEGMENT1%TYPE ;

   LP_ITEM VARCHAR(2000);

      FUNCTION afterreport
      RETURN BOOLEAN;

   FUNCTION beforereport
      RETURN BOOLEAN;


end XXQGEN_LEX_HDR_LINE_PKG_DK;