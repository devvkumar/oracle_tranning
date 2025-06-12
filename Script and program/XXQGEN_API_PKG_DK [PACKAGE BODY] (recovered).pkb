CREATE OR REPLACE PACKAGE BODY xxqgen_api_pkg_dk AS

    /***************************************************************************************************
     * Procedure: CREATE_USER
     * Description: Creates a new user using FND_USER_PKG API.
     ***************************************************************************************************/
    PROCEDURE create_user (
        p_user_name           IN VARCHAR2,
        p_unencrypted_password IN VARCHAR2
    ) IS
    BEGIN
        fnd_user_pkg.createuser(
            x_user_name                => p_user_name,
            x_owner                    => NULL,
            x_unencrypted_password     => p_unencrypted_password,
            x_session_number           => NULL,
            x_start_date               => NULL,
            x_end_date                 => NULL,
            x_last_logon_date          => NULL,
            x_description              => NULL,
            x_password_date            => NULL,
            x_password_accesses_left   => NULL,
            x_password_lifespan_accesses => NULL,
            x_password_lifespan_days   => NULL,
            x_employee_id              => NULL,
            x_email_address            => NULL,
            x_fax                      => NULL,
            x_customer_id              => NULL,
            x_supplier_id              => NULL
        );

        -- Debug message
        DBMS_OUTPUT.PUT_LINE('User created successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error creating user: ' || SQLCODE || ' - ' || SQLERRM);
    END create_user;

    /***************************************************************************************************
     * Procedure: ADD_TO_GROUP
     * Description: Adds a program to a request group.
     ***************************************************************************************************/
    PROCEDURE add_to_group (
        p_program_short_name  IN VARCHAR2,
        p_program_application IN VARCHAR2,
        p_request_group       IN VARCHAR2,
        p_group_application   IN VARCHAR2
    ) IS
    BEGIN
        apps.fnd_program.add_to_group(
            program_short_name  => p_program_short_name,
            program_application => p_program_application,
            request_group       => p_request_group,
            group_application   => p_group_application
        );
        DBMS_OUTPUT.PUT_LINE('Program added to group successfully.');
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error adding program to group: ' || SQLCODE || ' - ' || SQLERRM);
    END add_to_group;

    /***************************************************************************************************
     * Procedure: SUBMIT_REQUEST
     * Description: Submits a concurrent request for a specific program.
     ***************************************************************************************************/
    PROCEDURE submit_request (
        p_application IN VARCHAR2,
        p_program     IN VARCHAR2,
        p_user_id     IN NUMBER,
        p_resp_id     IN NUMBER,
        p_resp_appl_id IN NUMBER
    ) IS
        l_request_id NUMBER;
    BEGIN
        apps.fnd_global.apps_initialize(p_user_id, p_resp_id, p_resp_appl_id);

        l_request_id := fnd_request.submit_request(
            application => p_application,
            program     => p_program
        );

        IF l_request_id = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Request submission failed.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Request submitted successfully. Request ID: ' || l_request_id);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error submitting request: ' || SQLCODE || ' - ' || SQLERRM);
    END submit_request;

    /***************************************************************************************************
     * Procedure: EXECUTABLE_EXIST
     * Description: Checks if an executable exists.
     ***************************************************************************************************/
    PROCEDURE executable_exist (
        p_executable_short_name IN VARCHAR2,
        p_application           IN VARCHAR2
    ) IS
    BEGIN
        IF apps.fnd_program.executable_exists(
            executable_short_name => p_executable_short_name,
            application           => p_application
        ) THEN
            DBMS_OUTPUT.PUT_LINE('Executable exists.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Executable does not exist.');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error checking executable existence: ' || SQLCODE || ' - ' || SQLERRM);
    END executable_exist;

    /***************************************************************************************************
     * Procedure: PROGRAM_EXIST
     * Description: Checks if a program exists.
     ***************************************************************************************************/
    PROCEDURE program_exist (
        p_program IN VARCHAR2,
        p_application IN VARCHAR2
    ) IS
    BEGIN
        IF apps.fnd_program.program_exists(
            program     => p_program,
            application => p_application
        ) THEN
            DBMS_OUTPUT.PUT_LINE('Program exists.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Program does not exist.');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error checking program existence: ' || SQLCODE || ' - ' || SQLERRM);
    END program_exist;

    /***************************************************************************************************
     * Procedure: REMOVE_FROM_GROUP
     * Description: Removes a program from a request group.
     ***************************************************************************************************/
    PROCEDURE remove_from_group (
        p_program_short_name  IN VARCHAR2,
        p_program_application IN VARCHAR2,
        p_request_group       IN VARCHAR2,
        p_group_application   IN VARCHAR2
    ) IS
    BEGIN
        apps.fnd_program.remove_from_group(
            program_short_name  => p_program_short_name,
            program_application => p_program_application,
            request_group       => p_request_group,
            group_application   => p_group_application
        );
        DBMS_OUTPUT.PUT_LINE('Program removed from group successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error removing program from group: ' || SQLCODE || ' - ' || SQLERRM);
    END remove_from_group;

    /***************************************************************************************************
     * Procedure: DELETE_EXECUTABLE
     * Description: Deletes an executable.
     ***************************************************************************************************/
    PROCEDURE delete_executable (
        p_executable_short_name IN VARCHAR2,
        p_application           IN VARCHAR2
    ) IS
    BEGIN
        apps.fnd_program.delete_executable(
            executable_short_name => p_executable_short_name,
            application           => p_application
        );
        DBMS_OUTPUT.PUT_LINE('Executable successfully deleted.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error deleting executable: ' || SQLCODE || ' - ' || SQLERRM);
    END delete_executable;

    /***************************************************************************************************
     * Procedure: DELETE_PROGRAM
     * Description: Deletes a program from the system.
     ***************************************************************************************************/
    PROCEDURE delete_program (
        p_program_short_name IN VARCHAR2,
        p_application_code   IN VARCHAR2
    ) IS
    BEGIN
        apps.fnd_program.delete_program(
            program_short_name  => p_program_short_name,
            application => p_application_code
        );
        DBMS_OUTPUT.PUT_LINE('Program successfully deleted.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error deleting program: ' || SQLCODE || ' - ' || SQLERRM);
    END delete_program;

    /***************************************************************************************************
     * Procedure: MAIN
     * Description: Main procedure.
     ***************************************************************************************************/
    PROCEDURE main IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Executing main process...');
    END main;

END xxqgen_api_pkg_dk;
/
