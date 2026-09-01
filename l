sudo mariadb vm_doc <<'SQL'
SELECT
    (SELECT COUNT(*)
       FROM nomenclature_items
      WHERE category_code='architectural_domain') AS domenii,

    (SELECT COUNT(*)
       FROM vm_internal_service_assignments a
       JOIN nomenclature_items d
         ON d.id=a.architectural_domain_id
      WHERE d.category_code='architectural_domain') AS legaturi_vm,

    (SELECT COUNT(*)
       FROM nomenclature_item_parents p
       JOIN nomenclature_items d
         ON d.id=p.parent_item_id
      WHERE d.category_code='architectural_domain') AS legaturi_categorii,

    (SELECT COUNT(*)
       FROM vm_operational_nomenclatures v
       JOIN nomenclature_items d
         ON d.id=v.item_id
      WHERE d.category_code='architectural_domain') AS legaturi_legacy;
SQL
