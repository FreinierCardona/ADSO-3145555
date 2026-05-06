-- Ejercicio 07 - Setup: trigger AFTER INSERT en baggage y procedimiento para registrar equipaje

DROP TRIGGER IF EXISTS trg_baggage_after_insert ON baggage;
DROP FUNCTION IF EXISTS baggage_after_insert();
DROP PROCEDURE IF EXISTS proc_register_baggage(uuid, varchar, varchar, varchar, numeric);

CREATE OR REPLACE FUNCTION baggage_after_insert()
RETURNS trigger AS $$
DECLARE
    tid uuid;
BEGIN
    -- Actualizar la cabecera del ticket (updated_at) cuando se registra equipaje
    SELECT ticket_id INTO tid FROM ticket_segment WHERE ticket_segment_id = NEW.ticket_segment_id LIMIT 1;
    IF tid IS NOT NULL THEN
        UPDATE ticket SET updated_at = now() WHERE ticket_id = tid;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_baggage_after_insert
AFTER INSERT ON baggage
FOR EACH ROW
EXECUTE FUNCTION baggage_after_insert();

CREATE OR REPLACE PROCEDURE proc_register_baggage(
    p_ticket_segment_id uuid,
    p_baggage_tag varchar,
    p_baggage_type varchar,
    p_baggage_status varchar,
    p_weight numeric
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO baggage (baggage_id, ticket_segment_id, baggage_tag, baggage_type, baggage_status, weight_kg, checked_at, created_at, updated_at)
    VALUES (gen_random_uuid(), p_ticket_segment_id, p_baggage_tag, p_baggage_type, p_baggage_status, p_weight, now(), now(), now());
END;
$$;

-- Fin ejercicio 07 setup
