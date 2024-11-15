CREATE PROCEDURE convert_page_impressions_to_sessions()
BEGIN
    DECLARE page_impression_count INT DEFAULT 0;
    DECLARE page_impression_id INT DEFAULT 0;
    DECLARE session_id INT DEFAULT 0;
    DECLARE old_resource_id INT DEFAULT 0;
    DECLARE old_user_id INT DEFAULT 0;
    DECLARE old_reverse_proxy_host_id INT DEFAULT 0;
    DECLARE old_reverse_proxy_port_id INT DEFAULT 0;
    DECLARE old_app_id INT DEFAULT 0;
    DECLARE old_location_id INT DEFAULT 0;
    DECLARE old_ua_family_id INT DEFAULT 0;
    DECLARE old_ua_os_family_id INT DEFAULT 0;
    DECLARE old_log_time_ts INT DEFAULT 0;
    DECLARE new_resource_id INT DEFAULT 0;
    DECLARE new_user_id INT DEFAULT 0;
    DECLARE new_reverse_proxy_host_id INT DEFAULT 0;
    DECLARE new_reverse_proxy_port_id INT DEFAULT 0;
    DECLARE new_app_id INT DEFAULT 0;
    DECLARE new_location_id INT DEFAULT 0;
    DECLARE new_ua_family_id INT DEFAULT 0;
    DECLARE new_ua_os_family_id INT DEFAULT 0;
    DECLARE new_log_time_ts INT DEFAULT 0;
    SELECT
        resource_id,
        user_id,
        reverse_proxy_host_id,
        reverse_proxy_port_id,
        app_id,
        location_id,
        ua_family_id,
        ua_os_family_id,
        log_time_ts
    INTO
        old_resource_id,
        old_user_id,
        old_reverse_proxy_host_id,
        old_reverse_proxy_port_id,
        old_app_id,
        old_location_id,
        old_ua_family_id,
        old_ua_os_family_id,
        old_log_time_ts
    FROM
        page_impressions
    LIMIT
        0, 1;
    SELECT COUNT(*) FROM page_impressions INTO page_impression_count;
    SET page_impression_id = 1;
    WHILE page_impression_id < page_impression_count DO
        SELECT
            resource_id,
            user_id,
            reverse_proxy_host_id,
            reverse_proxy_port_id,
            app_id,
            location_id,
            ua_family_id,
            ua_os_family_id,
            log_time_ts
        INTO
            new_resource_id,
            new_user_id,
            new_reverse_proxy_host_id,
            new_reverse_proxy_port_id,
            new_app_id,
            new_location_id,
            new_ua_family_id,
            new_ua_os_family_id,
            new_log_time_ts
        FROM
            page_impressions
        LIMIT
            page_impression_id, 1;
        IF
            new_resource_id = old_resource_id
        AND
            new_user_id = old_user_id
        AND
            new_reverse_proxy_host_id = old_reverse_proxy_host_id
        AND
            new_reverse_proxy_port_id = old_reverse_proxy_port_id
        AND
            new_app_id = old_app_id
        AND
            new_location_id = old_location_id
        AND
            new_ua_family_id = old_ua_family_id
        AND
            new_ua_os_family_id = old_ua_os_family_id
        THEN
            UPDATE
                sessions
            SET
                end_time_ts = new_log_time_ts
            WHERE
                id = session_id
            ;
            /* TODO: Insert ignore into session_requests, which has columns
               for session_id, request_path_id, and, request_method_id. */
        ELSE
            INSERT INTO sessions (
                start_time_ts,
                start_day_id,
                end_time_ts,
                end_day_id,
                resource_id,
                resource_organization_id,
                person_id,
                person_organization_id,
                person_nsfstatuscode_id,
                user_id,
                /* TODO: handle request paths and methods */
                reverse_proxy_host_id,
                /* TODO: This becomes just reverse_proxy_port */
                reverse_proxy_port_id,
                app_id,
                location_id,
                ua_family_id,
                ua_os_family_id
            )
            VALUES (
                new_log_time_ts,
                new_log_day_id,
                new_log_time_ts,
                new_log_day_id,
                new_resource_id,
                new_resource_organization_id,
                new_person_id,
                new_person_organization_id,
                new_person_nsfstatuscode_id,
                new_user_id,
                new_reverse_proxy_host_id,
                new_reverse_proxy_port_id,
                new_app_id,
                new_location_id,
                new_ua_family_id,
                new_ua_os_family_id
            )
            ;
        END IF
        ;
    SET page_impression_id = page_impression_id + 1;
    END WHILE;
END;
//
