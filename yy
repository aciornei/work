sudo mariadb vm_doc -e "
SELECT
    id,
    agent_id,
    kind,
    source,
    status,
    http_status,
    error_code,
    error_message,
    created_at,
    started_at,
    finished_at
FROM collection_jobs
ORDER BY id DESC
LIMIT 10;
"
