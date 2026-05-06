-- Ejercicio 09 - Setup: trigger AFTER INSERT en fare y procedimiento para publicar tarifas

DROP TRIGGER IF EXISTS trg_fare_after_insert ON fare;
DROP FUNCTION IF EXISTS fare_after_insert();
DROP PROCEDURE IF EXISTS proc_publish_fare(uuid, uuid, uuid, uuid, uuid, varchar, numeric, date, date);

CREATE OR REPLACE FUNCTION fare_after_insert()
RETURNS trigger AS $$
BEGIN
    -- Actualizar updated_at como evidencia de publicación
    UPDATE fare SET updated_at = now() WHERE fare_id = NEW.fare_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_fare_after_insert
AFTER INSERT ON fare
FOR EACH ROW
EXECUTE FUNCTION fare_after_insert();

CREATE OR REPLACE PROCEDURE proc_publish_fare(
    p_airline_id uuid,
    p_origin_airport_id uuid,
    p_destination_airport_id uuid,
    p_fare_class_id uuid,
    p_currency_id uuid,
    p_fare_code varchar,
    p_base_amount numeric,
    p_valid_from date,
    p_valid_to date
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO fare (fare_id, airline_id, origin_airport_id, destination_airport_id, fare_class_id, currency_id, fare_code, base_amount, valid_from, valid_to, created_at, updated_at)
    VALUES (gen_random_uuid(), p_airline_id, p_origin_airport_id, p_destination_airport_id, p_fare_class_id, p_currency_id, p_fare_code, p_base_amount, p_valid_from, p_valid_to, now(), now())
    ON CONFLICT (fare_code) DO NOTHING;
END;
$$;

-- Fin ejercicio 09 setup
