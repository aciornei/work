sudo mariadb vm_doc <<'SQL'
DROP PROCEDURE IF EXISTS reset_architectural_domains_keep_unspecified;

DELIMITER //

CREATE PROCEDURE reset_architectural_domains_keep_unspecified()
BEGIN
    DECLARE unspecified_id BIGINT DEFAULT NULL;
    DECLARE other_vm_links BIGINT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SELECT id
      INTO unspecified_id
      FROM nomenclature_items
     WHERE category_code='architectural_domain'
       AND LOWER(TRIM(name))='nespecificat'
     LIMIT 1;

    IF unspecified_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT='Nu a fost gasit domeniul Nespecificat.';
    END IF;

    SELECT COUNT(*)
      INTO other_vm_links
      FROM vm_internal_service_assignments a
      JOIN nomenclature_items d
        ON d.id=a.architectural_domain_id
     WHERE d.category_code='architectural_domain'
       AND d.id<>unspecified_id;

    IF other_vm_links > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT='Exista VM-uri legate de alte domenii. Stergerea a fost oprita.';
    END IF;

    START TRANSACTION;

    DELETE relation
      FROM nomenclature_item_parents relation
      JOIN nomenclature_items domain_item
        ON domain_item.category_code='architectural_domain'
       AND domain_item.id<>unspecified_id
       AND (
            relation.parent_item_id=domain_item.id
            OR relation.child_item_id=domain_item.id
       );

    DELETE mapping
      FROM vm_operational_nomenclatures mapping
      JOIN nomenclature_items domain_item
        ON domain_item.id=mapping.item_id
       AND domain_item.category_code='architectural_domain'
       AND domain_item.id<>unspecified_id;

    DELETE FROM nomenclature_items
     WHERE category_code='architectural_domain'
       AND id<>unspecified_id;

    COMMIT;

    SELECT unspecified_id AS domeniu_nespecificat_pastrat;
END//

DELIMITER ;

CALL reset_architectural_domains_keep_unspecified();
DROP PROCEDURE reset_architectural_domains_keep_unspecified;
SQL
