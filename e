mysql vm_doc -e "
SELECT
  id,
  agent_id,
  source,
  status,
  error_code,
  error_message,
  created_at
FROM collection_jobs
WHERE source='push'
ORDER BY id DESC
LIMIT 5\G
"



python3 - <<'PY'
from pathlib import Path

path = Path("internal/server/server.go")
text = path.read_text()

old = '''\
	result, err := a.Registration.SaveInventory(r.Context(), raw)
	if err == nil && a.Logger != nil {
		a.Logger.Info("agent inventory received", "agent_id", result.AgentID, "inventory_id", result.InventoryID, "vm_id", result.VMID, "linked", result.Linked)
	}
	respondStatus(w, result, err, http.StatusCreated)
'''

new = '''\
	result, err := a.Registration.SaveInventory(r.Context(), raw)
	if err != nil && a.Logger != nil {
		a.Logger.Error("agent inventory push failed",
			"error", err,
			"remote_ip", resolvedClientIP(r, a.Config.Server.TrustedProxies),
			"payload_bytes", len(raw),
		)
	}
	if err == nil && a.Logger != nil {
		a.Logger.Info("agent inventory received",
			"agent_id", result.AgentID,
			"inventory_id", result.InventoryID,
			"vm_id", result.VMID,
			"linked", result.Linked,
		)
	}
	respondStatus(w, result, err, http.StatusCreated)
'''

if old not in text:
    raise SystemExit("Blocul agentInventoryPush nu a fost găsit.")

path.write_text(text.replace(old, new, 1))
print("Logarea erorii inventory push a fost adăugată.")
PY
