DB_NAME=$(awk '
  /^database:/ {inside=1; next}
  inside && /^[^[:space:]]/ {inside=0}
  inside && $1=="name:" {
    gsub(/"/, "", $2)
    print $2
    exit
  }
' /etc/vm-doc-server/config.yaml)

echo "$DB_NAME"
