select *
from fnd_concurrent_programs_vl
where CONCURRENT_PROGRAM_NAME = 'XXQGEN_TEST_DK02';


gn_cp_request_id :=
                fnd_request.submit_request (
                    application   => gc_application,
                    program       => gc_data_load_program,
                    argument1     => 1,
                    argument2     => 2
                    );

            COMMIT;

            fnd_file.put_line (
                fnd_file.LOG,
                   RPAD ('Loader Request ID.', 45, ' ')
                || ': '
                || gn_cp_request_id);
    IF gn_cp_request_id = 0
            THEN
                gc_data_validation := gc_error_flag;
                gc_error_message := fnd_message.get;
            ELSE
                /************************************************
                 * Checking request Status  for Completion.
                 ************************************************/

                IF gn_cp_request_id > 0
                THEN
                    LOOP
                        gc_conc_status :=
                            fnd_concurrent.wait_for_request (
                                request_id   => gn_cp_request_id,
                                interval     => gn_interval,
                                max_wait     => gn_max_wait,
                                phase        => gc_phase,
                                status       => gc_status,
                                dev_phase    => gc_dev_phase,
                                dev_status   => gc_dev_status,
                                MESSAGE      => gc_message);

                        EXIT WHEN    UPPER (gc_phase) = 'COMPLETED'
                                  OR UPPER (gc_status) IN
                                         ('CANCELLED', 'ERROR', 'TERMINATED');
                    END LOOP;

                    fnd_file.put_line (
                        fnd_file.LOG,
                           RPAD ('Loader Request Phase/Status.', 45, ' ')
                        || ': '
                        || gc_phase
                        || '-'
                        || gc_status);

                    IF (    UPPER (gc_phase) = 'COMPLETED'
                        AND UPPER (gc_status) = 'NORMAL')
                    THEN
                        gc_data_validation := gc_process_flag;
                        gc_error_message := NULL;
                    ELSE
                        gc_data_validation := gc_error_flag;
                        gc_error_message := SQLERRM;
                    END IF;
                END IF;
            END IF;