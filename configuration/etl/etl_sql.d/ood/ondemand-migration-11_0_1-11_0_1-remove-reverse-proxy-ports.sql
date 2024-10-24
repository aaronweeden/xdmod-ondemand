/* Remove the reverse_proxy_port_id column from page_impressions table
 * and drop the reverse_proxy_port table.
 */

/* Create a new page_impressions table. */
CREATE TABLE new_page_impressions LIKE page_impressions
//
/* Temporarily drop the indexes. */
ALTER TABLE new_page_impressions
DROP INDEX uniq,
DROP INDEX aggregation,
DROP INDEX agg_and_person_lookup,
DROP INDEX request_path,
DROP INDEX app_resource
//
/* Drop the reverse_proxy_port_id column. */
ALTER TABLE new_page_impressions DROP COLUMN reverse_proxy_port_id
//
/* Copy the contents of the old page_impressions table. */
INSERT INTO new_page_impressions(
    id,
    log_time_ts,
    log_day_id,
    resource_id,
    resource_organization_id,
    person_id,
    person_organization_id,
    person_nsfstatuscode_id,
    user_id,
    request_path_id,
    request_method_id,
    reverse_proxy_host_id,
    app_id,
    location_id,
    ua_family_id,
    ua_os_family_id,
    last_modified
)
SELECT
    id,
    log_time_ts,
    log_day_id,
    resource_id,
    resource_organization_id,
    person_id,
    person_organization_id,
    person_nsfstatuscode_id,
    user_id,
    request_path_id,
    request_method_id,
    reverse_proxy_host_id,
    app_id,
    location_id,
    ua_family_id,
    ua_os_family_id,
    last_modified
FROM page_impressions
//
/* Add the indexes back in. */
ALTER TABLE new_page_impressions
ADD UNIQUE INDEX uniq (
    log_time_ts,
    resource_id,
    user_id,
    request_path_id,
    request_method_id,
    reverse_proxy_host_id,
    app_id,
    location_id,
    ua_family_id,
    ua_os_family_id
),
ADD INDEX aggregation (log_day_id),
ADD INDEX agg_and_person_lookup (last_modified, person_id, resource_id),
ADD INDEX request_path (request_path_id),
ADD INDEX app_resource (app_id, resource_id)
//
/* Drop the old page_impressions table. */
DROP TABLE page_impressions
//
/* Rename the new page_impressions table. */
ALTER TABLE new_page_impressions RENAME page_impressions
//
/* Drop the reverse_proxy_port table. */
DROP TABLE reverse_proxy_port
//
