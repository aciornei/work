python3 - <<'PY'
from pathlib import Path

secrets_path = Path("/root/vm-doc-secrets-0.2.2.yaml")
token_path = Path("/root/vm-doc-agent-registration-token")

token = token_path.read_text().strip()
if len(token) < 32:
    raise SystemExit("Tokenul este prea scurt")

lines = secrets_path.read_text().splitlines()
result = []
found = False

for line in lines:
    if line.startswith("agent_registration_token:"):
        result.append(f'agent_registration_token: "{token}"')
        found = True
    else:
        result.append(line)

if not found:
    result.append(f'agent_registration_token: "{token}"')

secrets_path.write_text("\n".join(result) + "\n")
secrets_path.chmod(0o600)

print("agent_registration_token adaugat")
print("lungime token:", len(token))
PY
