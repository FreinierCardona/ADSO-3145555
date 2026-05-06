-- Ejercicio 06 - Setup: trigger AFTER INSERT en flight_delay y procedimiento para registrar retrasos

DROP TRIGGER IF EXISTS trg_flight_delay_after_insert ON flight_delay;
DROP FUNCTION IF EXISTS flight_delay_after_insert();
DROP PROCEDURE IF EXISTS proc_register_flight_delay(uuid, uuid, timestamptz, integer, text);

CREATE OR REPLACE FUNCTION flight_delay_after_insert()
RETURNS trigger AS $$
DECLARE
    delayed_status_id uuid;
    fid uuid;
BEGIN
    -- Asegurar existencia del status 'DELAYED'
    SELECT flight_status_id INTO delayed_status_id FROM flight_status WHERE status_code = 'DELAYED' LIMIT 1;
    IF delayed_status_id IS NULL THEN
        INSERT INTO flight_status (flight_status_id, status_code, status_name) VALUES (gen_random_uuid(), 'DELAYED', 'Delayed');
        SELECT flight_status_id INTO delayed_status_id FROM flight_status WHERE status_code = 'DELAYED' LIMIT 1;
    END IF;

    -- Obtener el vuelo asociado al segmento y actualizar su estado
    SELECT flight_id INTO fid FROM flight_segment WHERE flight_segment_id = NEW.flight_segment_id;
    IF fid IS NOT NULL THEN
        UPDATE flight SET flight_status_id = delayed_status_id, updated_at = now() WHERE flight_id = fid;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_flight_delay_after_insert
AFTER INSERT ON flight_delay
FOR EACH ROW
EXECUTE FUNCTION flight_delay_after_insert();

CREATE OR REPLACE PROCEDURE proc_register_flight_delay(
    p_flight_segment_id uuid,
    p_delay_reason_type_id uuid,
    p_reported_at timestamptz,
    p_delay_minutes integer,
    p_notes text
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO flight_delay (flight_delay_id, flight_segment_id, delay_reason_type_id, reported_at, delay_minutes, notes, created_at, updated_at)
    VALUES (gen_random_uuid(), p_flight_segment_id, p_delay_reason_type_id, p_reported_at, p_delay_minutes, p_notes, now(), now());
END;
$$;

-- Fin ejercicio 06 setup
