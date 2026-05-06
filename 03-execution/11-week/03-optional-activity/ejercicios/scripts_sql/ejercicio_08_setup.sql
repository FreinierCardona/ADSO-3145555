-- Ejercicio 08 - Setup: trigger AFTER INSERT en user_role y procedimiento para asignar rol a usuario

DROP TRIGGER IF EXISTS trg_user_role_after_insert ON user_role;
DROP FUNCTION IF EXISTS user_role_after_insert();
DROP PROCEDURE IF EXISTS proc_assign_user_role(uuid, uuid, uuid);

CREATE OR REPLACE FUNCTION user_role_after_insert()
RETURNS trigger AS $$
BEGIN
    -- Actualizar updated_at en user_account como evidencia de cambio de roles
    UPDATE user_account SET updated_at = now() WHERE user_account_id = NEW.user_account_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_user_role_after_insert
AFTER INSERT ON user_role
FOR EACH ROW
EXECUTE FUNCTION user_role_after_insert();

CREATE OR REPLACE PROCEDURE proc_assign_user_role(
    p_user_account_id uuid,
    p_security_role_id uuid,
    p_assigned_by_user_id uuid
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO user_role (user_role_id, user_account_id, security_role_id, assigned_at, assigned_by_user_id, created_at, updated_at)
    VALUES (gen_random_uuid(), p_user_account_id, p_security_role_id, now(), p_assigned_by_user_id, now(), now())
    ON CONFLICT (user_account_id, security_role_id) DO NOTHING;
END;
$$;

-- Fin ejercicio 08 setup
