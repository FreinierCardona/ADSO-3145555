-- Ejercicio 10 - Setup: trigger AFTER INSERT en person_document y procedimiento para registrar documentos

DROP TRIGGER IF EXISTS trg_person_document_after_insert ON person_document;
DROP FUNCTION IF EXISTS person_document_after_insert();
DROP PROCEDURE IF EXISTS proc_register_person_document(uuid, uuid, uuid, varchar, date, date);

CREATE OR REPLACE FUNCTION person_document_after_insert()
RETURNS trigger AS $$
BEGIN
    -- Actualizar la marca de tiempo de la persona al añadir un documento
    UPDATE person SET updated_at = now() WHERE person_id = NEW.person_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_person_document_after_insert
AFTER INSERT ON person_document
FOR EACH ROW
EXECUTE FUNCTION person_document_after_insert();

CREATE OR REPLACE PROCEDURE proc_register_person_document(
    p_person_id uuid,
    p_document_type_id uuid,
    p_issuing_country_id uuid,
    p_document_number varchar,
    p_issued_on date,
    p_expires_on date
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO person_document (person_document_id, person_id, document_type_id, issuing_country_id, document_number, issued_on, expires_on, created_at, updated_at)
    VALUES (gen_random_uuid(), p_person_id, p_document_type_id, p_issuing_country_id, p_document_number, p_issued_on, p_expires_on, now(), now());
END;
$$;

-- Fin ejercicio 10 setup
