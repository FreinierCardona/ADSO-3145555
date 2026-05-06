-- Ejercicio 01 - Setup: trigger, función y procedimiento para registro de check-in

-- El trigger AFTER INSERT sobre `check_in` generará un `boarding_pass` si no existe.

-- Limpiar definiciones previas (si existen)
DROP TRIGGER IF EXISTS trg_check_in_after_insert ON check_in;
DROP FUNCTION IF EXISTS boarding_pass_after_checkin();
DROP PROCEDURE IF EXISTS proc_register_check_in(uuid, uuid, uuid, uuid);

-- Función de trigger: crea boarding_pass al registrar un check_in
CREATE OR REPLACE FUNCTION boarding_pass_after_checkin()
RETURNS trigger AS $$
BEGIN
    -- Insertar pase de abordar sólo si no existe para ese check_in
    INSERT INTO boarding_pass (boarding_pass_id, check_in_id, boarding_pass_code, barcode_value, issued_at, created_at, updated_at)
    VALUES (
        gen_random_uuid(),
        NEW.check_in_id,
        concat('BP-', substr(gen_random_uuid()::text,1,8)),
        concat('BC-', substr(gen_random_uuid()::text,1,12)),
        NEW.checked_in_at,
        now(), now()
    ) ON CONFLICT (check_in_id) DO NOTHING;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear trigger
CREATE TRIGGER trg_check_in_after_insert
AFTER INSERT ON check_in
FOR EACH ROW
EXECUTE FUNCTION boarding_pass_after_checkin();

-- Procedimiento que encapsula el registro de un check-in
CREATE OR REPLACE PROCEDURE proc_register_check_in(
    p_ticket_segment_id uuid,
    p_check_in_status_id uuid,
    p_boarding_group_id uuid,
    p_checked_in_by_user_id uuid
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO check_in (check_in_id, ticket_segment_id, check_in_status_id, boarding_group_id, checked_in_by_user_id, checked_in_at, created_at, updated_at)
    VALUES (gen_random_uuid(), p_ticket_segment_id, p_check_in_status_id, p_boarding_group_id, p_checked_in_by_user_id, now(), now(), now());
END;
$$;

-- Fin ejercicio 01 setup
