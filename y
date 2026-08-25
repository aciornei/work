sudo mariadb vm_doc -e "
SELECT
    id,
    agent_id,
    schema_version,
    agent_uuid,
    hostname,
    os_name,
    os_version,
    primary_ip,
    payload_size,
    collected_at
FROM inventory_snapshots
ORDER BY id DESC
LIMIT 10;
"
