python3 - <<'PY'
from pathlib import Path

path = Path("internal/inventory/inventory.go")
text = path.read_text()

old = '''v, err := scanInventory(s.DB.QueryRowContext(ctx, query), raw)'''
new = '''v, err := scanInventory(s.DB.QueryRowContext(ctx, query, id), raw)'''

if old not in text:
    if new in text:
        print("Corecția este deja aplicată.")
    else:
        raise SystemExit("Linia așteptată nu a fost găsită.")

else:
    path.write_text(text.replace(old, new, 1))
    print("inventory.Get reparat: parametrul id este transmis query-ului.")
PY

grep -n -A5 -B2 'func (s Service) Get' internal/inventory/inventory.go

func (s Service) Get(ctx context.Context, id int64, raw bool) (domain.Inventory, error) {
    query := inventorySelect + ` WHERE i.id=?`
    v, err := scanInventory(s.DB.QueryRowContext(ctx, query, id), raw)
