DELETE FROM
    ${DESTINATION_SCHEMA}.staging
WHERE
    ${DESTINATION_SCHEMA}.staging.request_path LIKE '/pun/sys/dashboard/apps/icon/%'
OR 
    (
        ${DESTINATION_SCHEMA}.staging.request_path REGEXP '\\.(css|gif|ico|jpg|js|json|map|oga|png|svg|woff|woff2)(\\?.*)?$'
    AND
        ${DESTINATION_SCHEMA}.staging.request_path NOT LIKE '/pun/sys/dashboard/files/%'
    AND
        ${DESTINATION_SCHEMA}.staging.request_path NOT LIKE '/pun/sys/files/%'
    AND
        ${DESTINATION_SCHEMA}.staging.request_path NOT LIKE '/pun/sys/file-editor/%'
    )
//
