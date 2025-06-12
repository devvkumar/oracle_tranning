   
--1. Basic Query: Fetching Requisition Headers
--Retrieve requisition details like requisition number, description, and status.

SELECT 
    prh.requisition_header_id,
    prh.segment1 AS requisition_number,
    prh.description,
    prh.authorization_status,
    prh.preparer_id,
    prh.creation_date
FROM 
    po_requisition_headers_all prh
WHERE 
    prh.authorization_status = 'APPROVED'; -- Filter for approved requisitions
    
    
--2. Intermediate Query: Requisition Lines with Items
--Fetch requisition lines along with item details.

SELECT 
    prh.segment1 AS requisition_number,
    prh.description AS requisition_description,
    prl.line_num AS requisition_line_number,
    prl.item_description,
    prl.quantity,
    prl.unit_price,
    prl.need_by_date
FROM 
    po_requisition_headers_all prh
JOIN 
    po_requisition_lines_all prl
ON 
    prh.requisition_header_id = prl.requisition_header_id
WHERE 
    prh.authorization_status = 'APPROVED'
AND 
    prl.item_id IS NOT NULL; -- Ensure the line is tied to an item

--3. Advanced Query: Requisition to Purchase Order Link
--Track requisitions converted to purchase orders.

SELECT 
    prh.segment1 AS requisition_number,
    prh.description AS requisition_description,
    prl.line_num AS requisition_line_number,
    prl.quantity AS req_quantity,
    pol.po_header_id,
    poh.segment1 AS po_number,
    pol.quantity AS po_quantity,
    pol.unit_price AS po_unit_price,
    poh.authorization_status AS po_status
FROM 
    po_requisition_headers_all prh
JOIN 
    po_requisition_lines_all prl
ON 
    prh.requisition_header_id = prl.requisition_header_id
JOIN 
    po_req_distributions_all prd
ON 
    prl.requisition_line_id = prd.requisition_line_id
JOIN 
    po_distributions_all pd
ON 
    prd.distribution_id = pd.req_distribution_id
JOIN 
    po_lines_all pol
ON 
    pd.po_line_id = pol.po_line_id
JOIN 
    po_headers_all poh
ON 
    pol.po_header_id = poh.po_header_id
WHERE 
    prh.authorization_status = 'APPROVED'
AND 
    poh.authorization_status IN ('APPROVED', 'IN PROCESS'); -- Filter for PO status

--4. Advanced Query: Requisition to Receiving and Invoices
--Track the full P2P flow from requisitions to receiving and invoices.

SELECT 
    prh.segment1 AS requisition_number,
    prl.line_num AS requisition_line_number,
    prl.item_description,
    prl.quantity AS req_quantity,
    poh.segment1 AS po_number,
    pol.quantity AS po_quantity,
    rcv.transaction_quantity AS received_quantity,
    ap.invoice_num,
    ap.invoice_amount,
    ap.payment_status_flag
FROM 
    po_requisition_headers_all prh
JOIN 
    po_requisition_lines_all prl
ON 
    prh.requisition_header_id = prl.requisition_header_id
JOIN 
    po_req_distributions_all prd
ON 
    prl.requisition_line_id = prd.requisition_line_id
JOIN 
    po_distributions_all pd
ON 
    prd.distribution_id = pd.req_distribution_id
JOIN 
    po_lines_all pol
ON 
    pd.po_line_id = pol.po_line_id
JOIN 
    po_headers_all poh
ON 
    pol.po_header_id = poh.po_header_id
LEFT JOIN 
    rcv_transactions rcv
ON 
    pol.po_line_id = rcv.po_line_id
LEFT JOIN 
    ap_invoices_all ap
ON 
    pd.po_distribution_id = ap.po_distribution_id
WHERE 
    prh.authorization_status = 'APPROVED'
AND 
    poh.authorization_status = 'APPROVED'
AND 
    rcv.transaction_type IN ('RECEIVE', 'DELIVER')
AND 
    ap.invoice_status = 'VALIDATED';
Explanation of Key Tables:
PO_REQUISITION_HEADERS_ALL: Stores requisition headers.
PO_REQUISITION_LINES_ALL: Stores requisition line details.
PO_HEADERS_ALL: Stores purchase order headers.
PO_LINES_ALL: Stores purchase order line details.
RCV_TRANSACTIONS: Stores receiving transactions.
AP_INVOICES_ALL: Stores invoice information.
Notes:
Adjust filters (authorization_status, transaction_type, etc.) based on your requirements.
Use appropriate date filters to limit the data set.
Always test these queries in a non-production environment before use.





You said:
more questions
ChatGPT said:
ChatGPT
Here are additional P2P requisition-related questions, ranging from basic to advanced, that you might encounter during an interview or while working on Oracle EBS:

Basic Questions
What is the P2P process?
What is a requisition, and why is it created in the P2P cycle?
What are the key tables involved in storing requisition details in Oracle EBS?
What is the difference between requisition types: Internal and Purchase Requisition?
What is the significance of the authorization_status column in the PO_REQUISITION_HEADERS_ALL table?
How is the preparer of a requisition identified in the database?
What is the purpose of the item_id in PO_REQUISITION_LINES_ALL?
Intermediate Questions
How do you identify approved requisitions in Oracle EBS?
How can you fetch the list of requisitions created within a specific date range?
How do you link requisitions to purchase orders in the database?
What are the different statuses a requisition can have, and what do they mean?
How do you differentiate between standard purchase orders and blanket purchase agreements in a query?
Explain the relationship between PO_REQUISITION_LINES_ALL and PO_REQ_DISTRIBUTIONS_ALL.
What is the significance of the org_id column in requisition-related tables?
Advanced Questions
How can you track a requisition’s progress from creation to invoice payment?
How would you write a query to find requisitions pending approval?
How do you identify requisitions that are fully received but not invoiced?
How can you optimize a query linking requisitions, purchase orders, receiving, and invoices?
What is the difference between RECEIVE and DELIVER transaction types in the receiving process?
How would you find out if a requisition line has multiple distributions?
Explain how financials (GL codes, cost centers, etc.) are tied to requisitions in the database.
How do you handle requisitions created with invalid items or suppliers?
Scenario-Based Questions
A requisition has been approved but isn’t showing up in the buyer’s worklist. What steps would you take to debug this?
A requisition is created, but the approval workflow fails. How would you identify the issue?
Some requisitions are stuck in a pre-approved status. How can you find and resolve these requisitions?
How do you identify requisitions that have not been converted to purchase orders?
A purchase order linked to a requisition is closed, but the requisition line is still open. How would you debug this?
Technical Questions
How do you enable debugging for a P2P workflow in Oracle EBS?
What are the APIs used to create and update requisitions programmatically?
How do you handle changes to a requisition after it’s been approved?
Explain the role of PO_REQAPPROVAL_INIT1 in requisition approval workflows.
What is the difference between po_requisition_headers_all and po_requisition_headers views?
How do you ensure data consistency between requisitions and purchase orders in a multi-org setup?
Analytical Questions
How do you create a report that lists all requisitions and their associated purchase orders, including their statuses?
How would you find the total spend by supplier based on requisitions?
How can you identify trends in requisition creation by department or preparer?
How would you identify high-value requisitions that require additional approvals?
How can you create a dashboard to monitor requisitions pending in various statuses?
Let me know if you'd like detailed queries or solutions to any of these questions!'






You said:
query questions on fnd user , people , concurrent program, request program etc all ebs operation
ChatGPT said:
ChatGPT
Here’s a comprehensive list of query questions related to Oracle EBS operations involving FND Users, People, Concurrent Programs, Request Programs, and more. These queries cover various functional areas and help understand EBS processes:

FND_USER Queries
Retrieve a list of all active users:

sql
Copy code
SELECT 
    user_id,
    user_name,
    start_date,
    end_date,
    last_logon_date
FROM 
    fnd_user
WHERE 
    account_status = 'ACTIVE';
Find user details based on responsibilities assigned:

sql
Copy code
SELECT 
    fu.user_name,
    fu.description AS user_description,
    fr.responsibility_name,
    frv.start_date,
    frv.end_date
FROM 
    fnd_user fu
JOIN 
    fnd_user_resp_groups_direct frv
ON 
    fu.user_id = frv.user_id
JOIN 
    fnd_responsibility_tl fr
ON 
    frv.responsibility_id = fr.responsibility_id
WHERE 
    frv.end_date IS NULL;
Track users who haven’t logged in for a long time:

sql
Copy code
SELECT 
    user_name,
    last_logon_date,
    account_status
FROM 
    fnd_user
WHERE 
    last_logon_date < SYSDATE - 90; -- No login in the last 90 days
Identify locked user accounts:

sql
Copy code
SELECT 
    user_name,
    start_date,
    end_date
FROM 
    fnd_user
WHERE 
    account_status = 'LOCKED';
HR People (PER_ALL_PEOPLE_F) Queries
Retrieve active employees and their user accounts:

sql
Copy code
SELECT 
    paf.person_id,
    papf.full_name,
    fnd_user.user_name,
    papf.date_of_birth
FROM 
    per_all_people_f papf
JOIN 
    per_all_assignments_f paf
ON 
    papf.person_id = paf.person_id
JOIN 
    fnd_user
ON 
    paf.person_id = fnd_user.employee_id
WHERE 
    SYSDATE BETWEEN papf.effective_start_date AND papf.effective_end_date
AND 
    paf.assignment_status_type IN ('ACTIVE');
Find employees who don’t have user accounts:

sql
Copy code
SELECT 
    papf.person_id,
    papf.full_name
FROM 
    per_all_people_f papf
WHERE 
    papf.person_id NOT IN (
        SELECT 
            employee_id
        FROM 
            fnd_user
        WHERE 
            employee_id IS NOT NULL
    );
Concurrent Programs Queries
Fetch details of all concurrent programs:

sql
Copy code
SELECT 
    concurrent_program_id,
    concurrent_program_name,
    description,
    enabled_flag
FROM 
    fnd_concurrent_programs;
Retrieve details of requests submitted for a specific program:

sql
Copy code;
SELECT 
    fcr.request_id,
    fcr.concurrent_program_id,
    fcr.status_code,
    fcr.phase_code,
    fcr.request_date
FROM 
    fnd_concurrent_requests fcr
JOIN 
    fnd_concurrent_programs fcp
ON 
    fcr.concurrent_program_id = fcp.concurrent_program_id
WHERE 
    fcp.concurrent_program_name = 'YOUR_PROGRAM_NAME';
Identify programs with the most failures:

sql
Copy code
SELECT 
    fcp.concurrent_program_name,
    COUNT(*) AS failure_count
FROM 
    fnd_concurrent_requests fcr
JOIN 
    fnd_concurrent_programs fcp
ON 
    fcr.concurrent_program_id = fcp.concurrent_program_id
WHERE 
    fcr.phase_code = 'COMPLETED'
AND 
    fcr.status_code = 'ERROR'
GROUP BY 
    fcp.concurrent_program_name
ORDER BY 
    failure_count DESC;
Retrieve running requests:

sql
Copy code
SELECT 
    request_id,
    concurrent_program_id,
    phase_code,
    status_code,
    logfile_name
FROM 
    fnd_concurrent_requests
WHERE 
    phase_code = 'RUNNING';
Request Sets and Programs Queries
Fetch details of request sets:

sql
Copy code
SELECT 
    request_set_id,
    request_set_name,
    application_id
FROM 
    fnd_request_sets;
List all requests in a request set:

sql
Copy code
SELECT 
    frs.request_set_id,
    frs.request_set_name,
    frs.stage_id,
    fcp.concurrent_program_name
FROM 
    fnd_request_set_stages frss
JOIN 
    fnd_request_sets frs
ON 
    frss.request_set_id = frs.request_set_id
JOIN 
    fnd_concurrent_programs fcp
ON 
    frss.concurrent_program_id = fcp.concurrent_program_id;
Security and Responsibility Queries
Retrieve responsibilities assigned to a user:

sql
Copy code
SELECT 
    fu.user_name,
    fr.responsibility_name
FROM 
    fnd_user fu
JOIN 
    fnd_user_resp_groups frg
ON 
    fu.user_id = frg.user_id
JOIN 
    fnd_responsibility_tl fr
ON 
    frg.responsibility_id = fr.responsibility_id
WHERE 
    fu.user_name = 'YOUR_USER_NAME';
Check if a responsibility is end-dated:

sql
Copy code
SELECT 
    responsibility_name,
    start_date,
    end_date
FROM 
    fnd_responsibility
WHERE 
    responsibility_id = 'RESPONSIBILITY_ID';
Diagnostic and Utility Queries
Check invalid logins:

sql
Copy code
SELECT 
    user_name,
    last_logon_date,
    failed_login_attempts
FROM 
    fnd_user
WHERE 
    failed_login_attempts > 0;
Audit changes to user accounts:

sql
Copy code
SELECT 
    user_id,
    user_name,
    last_update_date,
    last_updated_by
FROM 
    fnd_user
WHERE 
    last_update_date > SYSDATE - 30; -- Changes in the last 30 days
Monitor long-running concurrent requests:

sql
Copy code
SELECT 
    request_id,
    user_name,
    concurrent_program_name,
    requested_start_date,
    elapsed_time
FROM 
    fnd_concurrent_requests
WHERE 
    elapsed_time > 30; -- Requests running for more than 30 minutes
Fetch error messages for failed requests:

sql
Copy code
SELECT 
    request_id,
    phase_code,
    status_code,
    log_file_name,
    oracle_process_id
FROM 
    fnd_concurrent_requests
WHERE 
    phase_code = 'COMPLETED'
AND 
    status_code = 'ERROR';
Let me know which area you'd like to explore further or if you need explanations or more queries!'






You said:
more querry questions
ChatGPT said:
ChatGPT
Here’s an extended set of query questions for Oracle EBS that you can explore across different domains such as FND Users, Concurrent Programs, Responsibilities, and Security, along with some more advanced operational queries:

FND_USER and User-Related Queries
List users with expired accounts:

sql
Copy code
SELECT 
    user_id, 
    user_name, 
    end_date 
FROM 
    fnd_user 
WHERE 
    end_date < SYSDATE;
Find the last logon details for a specific user:

sql
Copy code
SELECT 
    user_name, 
    last_logon_date 
FROM 
    fnd_user 
WHERE 
    user_name = 'YOUR_USER_NAME';
Identify all system administrators in the application:

sql
Copy code
SELECT 
    fu.user_name, 
    fr.responsibility_name 
FROM 
    fnd_user fu 
JOIN 
    fnd_user_resp_groups_direct furg 
ON 
    fu.user_id = furg.user_id 
JOIN 
    fnd_responsibility fr 
ON 
    furg.responsibility_id = fr.responsibility_id 
WHERE 
    fr.responsibility_name LIKE '%System Administrator%';
Find users linked to terminated employees:

sql
Copy code
SELECT 
    fu.user_name, 
    fu.employee_id 
FROM 
    fnd_user fu 
JOIN 
    per_all_people_f papf 
ON 
    fu.employee_id = papf.person_id 
WHERE 
    papf.effective_end_date < SYSDATE;
Responsibilities and Roles Queries
List responsibilities not assigned to any user:

sql
Copy code
SELECT 
    responsibility_name 
FROM 
    fnd_responsibility 
WHERE 
    responsibility_id NOT IN (
        SELECT 
            DISTINCT responsibility_id 
        FROM 
            fnd_user_resp_groups_direct
    );
Fetch a user’s responsibilities with effective dates:

sql
Copy code
SELECT 
    fu.user_name, 
    fr.responsibility_name, 
    frg.start_date, 
    frg.end_date 
FROM 
    fnd_user fu 
JOIN 
    fnd_user_resp_groups frg 
ON 
    fu.user_id = frg.user_id 
JOIN 
    fnd_responsibility fr 
ON 
    frg.responsibility_id = fr.responsibility_id 
WHERE 
    fu.user_name = 'YOUR_USER_NAME';
Check if a specific responsibility is available in a given application:

sql
Copy code
SELECT 
    responsibility_name 
FROM 
    fnd_responsibility 
WHERE 
    application_id = 'APPLICATION_ID' 
AND 
    responsibility_name = 'RESPONSIBILITY_NAME';
Concurrent Programs Queries
Fetch all disabled concurrent programs:

sql
Copy code
SELECT 
    concurrent_program_name, 
    description 
FROM 
    fnd_concurrent_programs 
WHERE 
    enabled_flag = 'N';
Find completed concurrent requests with warnings:

sql
Copy code
SELECT 
    request_id, 
    phase_code, 
    status_code 
FROM 
    fnd_concurrent_requests 
WHERE 
    phase_code = 'COMPLETED' 
AND 
    status_code = 'WARNING';
Get the execution time of a specific request:

sql
Copy code
SELECT 
    request_id, 
    requested_start_date, 
    actual_start_date, 
    actual_completion_date, 
    (actual_completion_date - actual_start_date) * 24 * 60 AS execution_time_minutes 
FROM 
    fnd_concurrent_requests 
WHERE 
    request_id = 'REQUEST_ID';
Retrieve logs of failed concurrent requests:

sql
Copy code
SELECT 
    request_id, 
    logfile_name, 
    logfile_node 
FROM 
    fnd_concurrent_requests 
WHERE 
    status_code = 'ERROR';
People (PER_ALL_PEOPLE_F) Queries
Find all employees under a specific manager:

sql
Copy code
SELECT 
    employee_id, 
    full_name, 
    assignment_id 
FROM 
    per_all_assignments_f 
WHERE 
    manager_id = 'MANAGER_PERSON_ID';
List employees in a specific department:

sql
Copy code
SELECT 
    papf.person_id, 
    papf.full_name, 
    per.organization_id, 
    hrorg.name AS department_name 
FROM 
    per_all_people_f papf 
JOIN 
    per_all_assignments_f per 
ON 
    papf.person_id = per.person_id 
JOIN 
    hr_all_organization_units hrorg 
ON 
    per.organization_id = hrorg.organization_id 
WHERE 
    hrorg.name = 'DEPARTMENT_NAME';
Get details of all terminated employees:

sql
Copy code
SELECT 
    papf.person_id, 
    papf.full_name, 
    paf.effective_end_date 
FROM 
    per_all_people_f papf 
JOIN 
    per_all_assignments_f paf 
ON 
    papf.person_id = paf.person_id 
WHERE 
    paf.assignment_status_type = 'TERMINATED';
System Administration Queries
Find top N requests consuming the most runtime:

sql
Copy code
SELECT 
    request_id, 
    concurrent_program_id, 
    elapsed_time, 
    requested_start_date 
FROM 
    fnd_concurrent_requests 
ORDER BY 
    elapsed_time DESC 
FETCH FIRST 10 ROWS ONLY;
List all custom concurrent programs in the system:

sql
Copy code
SELECT 
    concurrent_program_name, 
    description 
FROM 
    fnd_concurrent_programs 
WHERE 
    concurrent_program_name LIKE 'XX%';
Find all requests submitted by a specific user:

sql
Copy code
SELECT 
    fcr.request_id, 
    fcr.concurrent_program_id, 
    fcr.phase_code, 
    fcr.status_code, 
    fcr.request_date 
FROM 
    fnd_concurrent_requests fcr 
JOIN 
    fnd_user fu 
ON 
    fcr.requested_by = fu.user_id 
WHERE 
    fu.user_name = 'YOUR_USER_NAME';
Audit which users have added or updated concurrent programs:

sql
Copy code
SELECT 
    concurrent_program_id, 
    concurrent_program_name, 
    last_updated_by, 
    last_update_date 
FROM 
    fnd_concurrent_programs 
WHERE 
    last_update_date > SYSDATE - 30; -- Programs updated in the last 30 days
Diagnostic and Validation Queries
Check users with invalid configurations:

sql
Copy code
SELECT 
    fu.user_name, 
    fu.account_status 
FROM 
    fnd_user fu 
WHERE 
    NVL(fu.end_date, SYSDATE) < SYSDATE 
OR 
    NVL(fu.start_date, SYSDATE) > SYSDATE;
Validate if a concurrent program is associated with any request group:

sql
Copy code
SELECT 
    fcp.concurrent_program_name, 
    frg.request_group_name 
FROM 
    fnd_request_group_units frgu 
JOIN 
    fnd_request_groups frg 
ON 
    frgu.request_group_id = frg.request_group_id 
JOIN 
    fnd_concurrent_programs fcp 
ON 
    frgu.request_unit_id = fcp.concurrent_program_id 
WHERE 
    fcp.concurrent_program_name = 'YOUR_PROGRAM_NAME';
Check for unused responsibilities:

sql
Copy code
SELECT 
    responsibility_id, 
    responsibility_name 
FROM 
    fnd_responsibility 
WHERE 
    responsibility_id NOT IN (
        SELECT 
            DISTINCT responsibility_id 
        FROM 
            fnd_user_resp_groups_direct
    );
Would you like additional questions on any specific area? Or do you need explanations or step-by-step solutions? Let me know!






You said:
more querry questions
ChatGPT said:
ChatGPT
Here are more query questions for Oracle EBS focusing on FND User, Concurrent Programs, Responsibilities, Requests, Data Security, and other operational aspects:

FND User and Security Queries
Find all inactive users:

sql
Copy code
SELECT 
    user_name, 
    start_date, 
    end_date 
FROM 
    fnd_user 
WHERE 
    NVL(end_date, SYSDATE) < SYSDATE;
Check if a specific user has logged in within the past 30 days:

sql
Copy code
SELECT 
    user_name, 
    last_logon_date 
FROM 
    fnd_user 
WHERE 
    user_name = 'USERNAME' 
AND 
    last_logon_date >= SYSDATE - 30;
List all users with SYSADMIN privileges:

sql
Copy code
SELECT 
    fu.user_name, 
    fr.responsibility_name 
FROM 
    fnd_user fu 
JOIN 
    fnd_user_resp_groups_direct furg 
ON 
    fu.user_id = furg.user_id 
JOIN 
    fnd_responsibility fr 
ON 
    furg.responsibility_id = fr.responsibility_id 
WHERE 
    fr.responsibility_name LIKE '%SYSADMIN%';
Audit changes to user details in the last 7 days:

sql
Copy code
SELECT 
    user_name, 
    last_update_date, 
    last_updated_by 
FROM 
    fnd_user 
WHERE 
    last_update_date >= SYSDATE - 7;
List users linked to multiple employees:

sql
Copy code
SELECT 
    user_name, 
    employee_id 
FROM 
    fnd_user 
GROUP BY 
    user_name, 
    employee_id 
HAVING 
    COUNT(employee_id) > 1;
Responsibilities and Role Management
Get responsibilities assigned to users for a specific application:

sql
Copy code
SELECT 
    fu.user_name, 
    fr.responsibility_name, 
    frg.start_date, 
    frg.end_date 
FROM 
    fnd_user fu 
JOIN 
    fnd_user_resp_groups frg 
ON 
    fu.user_id = frg.user_id 
JOIN 
    fnd_responsibility fr 
ON 
    frg.responsibility_id = fr.responsibility_id 
WHERE 
    fr.application_id = 'APPLICATION_ID';
Check users with responsibilities that have expired:

sql
Copy code
SELECT 
    fu.user_name, 
    fr.responsibility_name, 
    frg.end_date 
FROM 
    fnd_user fu 
JOIN 
    fnd_user_resp_groups frg 
ON 
    fu.user_id = frg.user_id 
JOIN 
    fnd_responsibility fr 
ON 
    frg.responsibility_id = fr.responsibility_id 
WHERE 
    frg.end_date < SYSDATE;
Find responsibilities assigned to multiple users:

sql
Copy code
SELECT 
    responsibility_name, 
    COUNT(user_id) AS user_count 
FROM 
    fnd_user_resp_groups 
GROUP BY 
    responsibility_name 
HAVING 
    COUNT(user_id) > 1;
Concurrent Programs and Requests
List all concurrent programs created or modified in the last 6 months:

sql
Copy code
SELECT 
    concurrent_program_name, 
    description, 
    last_update_date 
FROM 
    fnd_concurrent_programs 
WHERE 
    last_update_date >= SYSDATE - 180;
Retrieve all scheduled concurrent requests for a specific user:

sql
Copy code
SELECT 
    request_id, 
    phase_code, 
    status_code, 
    requested_start_date 
FROM 
    fnd_concurrent_requests 
WHERE 
    requested_by = (SELECT user_id FROM fnd_user WHERE user_name = 'USERNAME');
Identify requests that failed due to errors:

sql
Copy code
SELECT 
    request_id, 
    phase_code, 
    status_code, 
    log_file_name 
FROM 
    fnd_concurrent_requests 
WHERE 
    phase_code = 'COMPLETED' 
AND 
    status_code = 'ERROR';
Audit request groups containing custom concurrent programs:

sql
Copy code
SELECT 
    frg.request_group_name, 
    fcp.concurrent_program_name 
FROM 
    fnd_request_group_units frgu 
JOIN 
    fnd_request_groups frg 
ON 
    frgu.request_group_id = frg.request_group_id 
JOIN 
    fnd_concurrent_programs fcp 
ON 
    frgu.request_unit_id = fcp.concurrent_program_id 
WHERE 
    fcp.concurrent_program_name LIKE 'XX%';
Retrieve historical runtime for a specific program:

sql
Copy code
SELECT 
    request_id, 
    actual_start_date, 
    actual_completion_date, 
    (actual_completion_date - actual_start_date) * 24 * 60 AS runtime_minutes 
FROM 
    fnd_concurrent_requests 
WHERE 
    concurrent_program_id = (SELECT concurrent_program_id FROM fnd_concurrent_programs WHERE concurrent_program_name = 'PROGRAM_NAME');
Data Security and Auditing
List security profiles associated with a specific responsibility:

sql
Copy code
SELECT 
    fr.responsibility_name, 
    fp.security_profile_name 
FROM 
    fnd_responsibility fr 
JOIN 
    fnd_profile_options fpo 
ON 
    fr.responsibility_id = fpo.level_id 
JOIN 
    fnd_security_profiles fp 
ON 
    fpo.profile_option_value = fp.security_profile_id 
WHERE 
    fr.responsibility_name = 'RESPONSIBILITY_NAME';
Find all profile options and their values for a specific user:

sql
Copy code
SELECT 
    fpo.profile_option_name, 
    fu.user_name, 
    fpor.profile_option_value 
FROM 
    fnd_profile_options fpo 
JOIN 
    fnd_profile_option_responsibilities fpor 
ON 
    fpo.profile_option_id = fpor.profile_option_id 
JOIN 
    fnd_user fu 
ON 
    fpor.level_value = fu.user_id 
WHERE 
    fu.user_name = 'USERNAME';
Track changes to responsibilities for a specific user:

sql
Copy code
SELECT 
    fu.user_name, 
    fr.responsibility_name, 
    furg.creation_date, 
    furg.last_update_date 
FROM 
    fnd_user fu 
JOIN 
    fnd_user_resp_groups_direct furg 
ON 
    fu.user_id = furg.user_id 
JOIN 
    fnd_responsibility fr 
ON 
    furg.responsibility_id = fr.responsibility_id 
WHERE 
    fu.user_name = 'USERNAME';
People and Assignment Queries
Fetch active employees with assigned responsibilities:

sql
Copy code
SELECT 
    papf.person_id, 
    papf.full_name, 
    fr.responsibility_name 
FROM 
    per_all_people_f papf 
JOIN 
    fnd_user fu 
ON 
    papf.person_id = fu.employee_id 
JOIN 
    fnd_user_resp_groups frg 
ON 
    fu.user_id = frg.user_id 
JOIN 
    fnd_responsibility fr 
ON 
    frg.responsibility_id = fr.responsibility_id 
WHERE 
    papf.effective_end_date IS NULL;
List terminated employees still linked to active user accounts:

sql
Copy code
SELECT 
    fu.user_name, 
    papf.full_name, 
    papf.effective_end_date 
FROM 
    fnd_user fu 
JOIN 
    per_all_people_f papf 
ON 
    fu.employee_id = papf.person_id 
WHERE 
    papf.effective_end_date < SYSDATE 
AND 
    NVL(fu.end_date, SYSDATE) > SYSDATE;
Would you like more advanced queries, or help with any of these?






You said:
yes more advance querry questions
ChatGPT said:
ChatGPT
Here are advanced query questions related to Oracle EBS for various operations, diving deeper into real-world use cases:

Advanced FND User Queries
Identify users with overlapping responsibilities:

sql
Copy code
SELECT 
    fu.user_name, 
    fr.responsibility_name, 
    COUNT(*) 
FROM 
    fnd_user_resp_groups frg 
JOIN 
    fnd_user fu 
ON 
    frg.user_id = fu.user_id 
JOIN 
    fnd_responsibility fr 
ON 
    frg.responsibility_id = fr.responsibility_id 
WHERE 
    frg.start_date <= NVL(frg.end_date, SYSDATE) 
GROUP BY 
    fu.user_name, 
    fr.responsibility_name 
HAVING 
    COUNT(*) > 1;
Track inactive users assigned to critical responsibilities:

sql
Copy code
SELECT 
    fu.user_name, 
    fr.responsibility_name, 
    frg.start_date, 
    frg.end_date 
FROM 
    fnd_user fu 
JOIN 
    fnd_user_resp_groups frg 
ON 
    fu.user_id = frg.user_id 
JOIN 
    fnd_responsibility fr 
ON 
    frg.responsibility_id = fr.responsibility_id 
WHERE 
    fu.end_date IS NOT NULL 
AND 
    fr.responsibility_name IN ('SYSADMIN', 'SECURITY ADMINISTRATOR');
Fetch user account lock/unlock activity logs:

sql
Copy code
SELECT 
    fu.user_name, 
    fl.message_text, 
    fl.creation_date 
FROM 
    fnd_logins fl 
JOIN 
    fnd_user fu 
ON 
    fl.user_id = fu.user_id 
WHERE 
    fl.message_text LIKE '%Account%Locked%' 
OR 
    fl.message_text LIKE '%Account%Unlocked%';
Concurrent Program and Request Queries
Fetch the top 10 longest-running concurrent requests:

sql
Copy code
SELECT 
    request_id, 
    concurrent_program_id, 
    actual_start_date, 
    actual_completion_date, 
    ROUND((actual_completion_date - actual_start_date) * 1440, 2) AS runtime_minutes 
FROM 
    fnd_concurrent_requests 
WHERE 
    phase_code = 'C' 
AND 
    status_code = 'C' 
ORDER BY 
    runtime_minutes DESC 
FETCH FIRST 10 ROWS ONLY;
List concurrent programs without request groups:

sql
Copy code
SELECT 
    concurrent_program_name 
FROM 
    fnd_concurrent_programs fcp 
WHERE 
    NOT EXISTS (
        SELECT 
            1 
        FROM 
            fnd_request_group_units frgu 
        WHERE 
            frgu.request_unit_id = fcp.concurrent_program_id
    );
Identify failed requests for a specific program in the last 30 days:

sql
Copy code
SELECT 
    request_id, 
    log_file_name, 
    phase_code, 
    status_code 
FROM 
    fnd_concurrent_requests 
WHERE 
    concurrent_program_id = (SELECT concurrent_program_id FROM fnd_concurrent_programs WHERE concurrent_program_name = 'PROGRAM_NAME') 
AND 
    phase_code = 'C' 
AND 
    status_code = 'E' 
AND 
    requested_start_date >= SYSDATE - 30;
Retrieve concurrent programs with a specific parameter value:

sql
Copy code
SELECT 
    fcp.concurrent_program_name, 
    fcp.description, 
    fcr.argument_text 
FROM 
    fnd_concurrent_requests fcr 
JOIN 
    fnd_concurrent_programs fcp 
ON 
    fcr.concurrent_program_id = fcp.concurrent_program_id 
WHERE 
    fcr.argument_text LIKE '%VALUE%';
Responsibility and Security
Find responsibilities without any users assigned:

sql
Copy code
SELECT 
    responsibility_name 
FROM 
    fnd_responsibility 
WHERE 
    NOT EXISTS (
        SELECT 
            1 
        FROM 
            fnd_user_resp_groups_direct 
        WHERE 
            fnd_user_resp_groups_direct.responsibility_id = fnd_responsibility.responsibility_id
    );
Audit changes to responsibility assignments in the last 90 days:

sql
Copy code
SELECT 
    fu.user_name, 
    fr.responsibility_name, 
    frg.creation_date, 
    frg.last_update_date 
FROM 
    fnd_user_resp_groups_direct frg 
JOIN 
    fnd_user fu 
ON 
    frg.user_id = fu.user_id 
JOIN 
    fnd_responsibility fr 
ON 
    frg.responsibility_id = fr.responsibility_id 
WHERE 
    frg.last_update_date >= SYSDATE - 90;
Find users with expired responsibilities still active:

sql
Copy code
SELECT 
    fu.user_name, 
    fr.responsibility_name, 
    frg.end_date 
FROM 
    fnd_user_resp_groups_direct frg 
JOIN 
    fnd_user fu 
ON 
    frg.user_id = fu.user_id 
JOIN 
    fnd_responsibility fr 
ON 
    frg.responsibility_id = fr.responsibility_id 
WHERE 
    NVL(frg.end_date, SYSDATE) < SYSDATE 
AND 
    NVL(fu.end_date, SYSDATE) > SYSDATE;
Employee and Person Queries
Fetch users without employees linked:

sql
Copy code
SELECT 
    user_name 
FROM 
    fnd_user 
WHERE 
    employee_id IS NULL;
Identify terminated employees still associated with active responsibilities:

sql
Copy code
SELECT 
    papf.full_name, 
    papf.person_id, 
    fu.user_name, 
    fr.responsibility_name 
FROM 
    per_all_people_f papf 
JOIN 
    fnd_user fu 
ON 
    papf.person_id = fu.employee_id 
JOIN 
    fnd_user_resp_groups frg 
ON 
    fu.user_id = frg.user_id 
JOIN 
    fnd_responsibility fr 
ON 
    frg.responsibility_id = fr.responsibility_id 
WHERE 
    papf.effective_end_date < SYSDATE 
AND 
    NVL(fu.end_date, SYSDATE) > SYSDATE;
Fetch employees with roles across multiple responsibilities:

sql
Copy code
SELECT 
    papf.person_id, 
    papf.full_name, 
    fr.responsibility_name, 
    COUNT(*) AS responsibility_count 
FROM 
    per_all_people_f papf 
JOIN 
    fnd_user fu 
ON 
    papf.person_id = fu.employee_id 
JOIN 
    fnd_user_resp_groups frg 
ON 
    fu.user_id = frg.user_id 
JOIN 
    fnd_responsibility fr 
ON 
    frg.responsibility_id = fr.responsibility_id 
GROUP BY 
    papf.person_id, 
    papf.full_name, 
    fr.responsibility_name 
HAVING 
    COUNT(*) > 1;
Advanced Logging and Debugging
Retrieve failed concurrent requests with log file details:

sql
Copy code
SELECT 
    fcr.request_id, 
    fcp.concurrent_program_name, 
    fcr.log_file_name, 
    fcr.phase_code, 
    fcr.status_code 
FROM 
    fnd_concurrent_requests fcr 
JOIN 
    fnd_concurrent_programs fcp 
ON 
    fcr.concurrent_program_id = fcp.concurrent_program_id 
WHERE 
    fcr.phase_code = 'C' 
AND 
    fcr.status_code = 'E';
Track changes to system profile values in the past 30 days:

sql
Copy code
SELECT 
    fpo.profile_option_name, 
    fps.level_value, 
    fps.profile_option_value, 
    fps.last_update_date, 
    fps.last_updated_by 
FROM 
    fnd_profile_option_values fps 
JOIN 
    fnd_profile_options fpo 
ON 
    fps.profile_option_id = fpo.profile_option_id 
WHERE 
    fps.last_update_date >= SYSDATE - 30;