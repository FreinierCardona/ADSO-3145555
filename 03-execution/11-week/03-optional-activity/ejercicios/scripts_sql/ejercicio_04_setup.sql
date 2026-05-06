-- Ejercicio 04 - Setup: trigger AFTER INSERT en miles_transaction para actualizar nivel (loyalty_account_tier)

DROP TRIGGER IF EXISTS trg_miles_transaction_after_insert ON miles_transaction;
DROP FUNCTION IF EXISTS miles_transaction_after_insert();
DROP PROCEDURE IF EXISTS proc_register_miles_transaction(uuid, varchar, integer, timestamptz, varchar, text);

CREATE OR REPLACE FUNCTION miles_transaction_after_insert()
RETURNS trigger AS $$
DECLARE
    total_miles bigint;
    prog_id uuid;
    new_tier_id uuid;
    last_tier_id uuid;
BEGIN
    -- Calcular millas acumuladas (consideramos todas las transacciones)
    SELECT COALESCE(SUM(miles_delta),0) INTO total_miles FROM miles_transaction WHERE loyalty_account_id = NEW.loyalty_account_id;

    -- Obtener el programa de fidelizacion asociado a la cuenta
    SELECT loyalty_program_id INTO prog_id FROM loyalty_account WHERE loyalty_account_id = NEW.loyalty_account_id;

    IF prog_id IS NULL THEN
        RETURN NEW;
    END IF;

    -- Buscar el mejor tier alcanzado
    SELECT loyalty_tier_id INTO new_tier_id
    FROM loyalty_tier
    WHERE loyalty_program_id = prog_id AND required_miles <= total_miles
    ORDER BY required_miles DESC LIMIT 1;

    IF new_tier_id IS NULL THEN
        RETURN NEW; -- no hay tier aplicable
    END IF;

    -- Obtener el último tier asignado
    SELECT loyalty_tier_id INTO last_tier_id FROM loyalty_account_tier WHERE loyalty_account_id = NEW.loyalty_account_id ORDER BY assigned_at DESC LIMIT 1;

    -- Si el nuevo tier es distinto al último, registrar asignación
    IF last_tier_id IS NULL OR last_tier_id <> new_tier_id THEN
        INSERT INTO loyalty_account_tier (loyalty_account_tier_id, loyalty_account_id, loyalty_tier_id, assigned_at, created_at, updated_at)
        VALUES (gen_random_uuid(), NEW.loyalty_account_id, new_tier_id, now(), now(), now())
        ON CONFLICT (loyalty_account_id, assigned_at) DO NOTHING;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_miles_transaction_after_insert
AFTER INSERT ON miles_transaction
FOR EACH ROW
EXECUTE FUNCTION miles_transaction_after_insert();

-- Procedimiento para registrar transacciones de millas
CREATE OR REPLACE PROCEDURE proc_register_miles_transaction(
    p_loyalty_account_id uuid,
    p_transaction_type varchar,
    p_miles_delta integer,
    p_occurred_at timestamptz,
    p_reference_code varchar,
    p_notes text
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO miles_transaction (miles_transaction_id, loyalty_account_id, transaction_type, miles_delta, occurred_at, reference_code, notes, created_at, updated_at)
    VALUES (gen_random_uuid(), p_loyalty_account_id, p_transaction_type, p_miles_delta, p_occurred_at, p_reference_code, p_notes, now(), now());
END;
$$;

-- Fin ejercicio 04 setup
