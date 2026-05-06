-- Ejercicio 05 - Setup: trigger AFTER UPDATE sobre maintenance_event y procedimiento para registrar eventos

DROP TRIGGER IF EXISTS trg_maintenance_event_after_update ON maintenance_event;
DROP FUNCTION IF EXISTS maintenance_event_after_update();
DROP PROCEDURE IF EXISTS proc_register_maintenance_event(uuid, uuid, uuid, varchar, timestamptz, text);

CREATE OR REPLACE FUNCTION maintenance_event_after_update()
RETURNS trigger AS $$
BEGIN
    -- Si el evento pasa a COMPLETED, actualizar la fecha in_service_on de la aeronave
    IF NEW.status_code = 'COMPLETED' AND NEW.completed_at IS NOT NULL THEN
        UPDATE aircraft SET in_service_on = NEW.completed_at, updated_at = now() WHERE aircraft_id = NEW.aircraft_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_maintenance_event_after_update
AFTER UPDATE ON maintenance_event
FOR EACH ROW
EXECUTE FUNCTION maintenance_event_after_update();

CREATE OR REPLACE PROCEDURE proc_register_maintenance_event(
    p_aircraft_id uuid,
    p_maintenance_type_id uuid,
    p_maintenance_provider_id uuid,
    p_status_code varchar,
    p_started_at timestamptz,
    p_notes text
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO maintenance_event (maintenance_event_id, aircraft_id, maintenance_type_id, maintenance_provider_id, status_code, started_at, notes, created_at, updated_at)
    VALUES (gen_random_uuid(), p_aircraft_id, p_maintenance_type_id, p_maintenance_provider_id, p_status_code, p_started_at, p_notes, now(), now());
END;
$$;

-- Fin ejercicio 05 setup
