python3 - <<'PY'
import json
import os
from pathlib import Path

path = Path("/etc/vm-doc-agent/config.json")
data = json.loads(path.read_text())

url = os.environ["CENTRAL_URL"].rstrip("/")
allow_http = url.startswith("http://")

data["central"] = {
    "enabled": True,
    "url": url,
    "registration_token_file": "/etc/vm-doc-agent/central-registration-token",
    "heartbeat_interval": "5m",
    "retry_interval": "1m",
    "request_timeout": "60s",
    "advertise_url": "",
    "ca_file": "",
    "tls_server_name": "",
    "insecure_skip_verify": False,
    "allow_http": allow_http
}

backup = path.with_suffix(".json.before-1.1.0")
backup.write_text(path.read_text())
backup.chmod(0o600)

path.write_text(json.dumps(data, indent=2) + "\n")
path.chmod(0o600)

print("Config actualizat")
print("Central URL:", url)
print("allow_http:", allow_http)
PY
