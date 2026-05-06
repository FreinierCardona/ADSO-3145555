-- Ejercicio 02 - Setup: trigger para generar refund y procedimiento para registrar payment_transaction

DROP TRIGGER IF EXISTS trg_payment_transaction_after_insert ON payment_transaction;
DROP FUNCTION IF EXISTS payment_transaction_after_insert();
DROP PROCEDURE IF EXISTS proc_register_payment_transaction(uuid, varchar, varchar, numeric, timestamptz, text);

CREATE OR REPLACE FUNCTION payment_transaction_after_insert()
RETURNS trigger AS $$
BEGIN
    -- Si la transacción es de tipo REFUND, crear una fila en refund asociada al pago
    IF NEW.transaction_type = 'REFUND' THEN
        INSERT INTO refund (refund_id, payment_id, refund_reference, amount, requested_at, processed_at, refund_reason, created_at, updated_at)
        VALUES (gen_random_uuid(), NEW.payment_id, concat('RF-', substr(gen_random_uuid()::text,1,8)), NEW.transaction_amount, NEW.processed_at, NEW.processed_at, NEW.provider_message, now(), now())
        ON CONFLICT (refund_reference) DO NOTHING;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_payment_transaction_after_insert
AFTER INSERT ON payment_transaction
FOR EACH ROW
EXECUTE FUNCTION payment_transaction_after_insert();

CREATE OR REPLACE PROCEDURE proc_register_payment_transaction(
    p_payment_id uuid,
    p_transaction_reference varchar,
    p_transaction_type varchar,
    p_transaction_amount numeric,
    p_processed_at timestamptz,
    p_provider_message text
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO payment_transaction (payment_transaction_id, payment_id, transaction_reference, transaction_type, transaction_amount, processed_at, provider_message, created_at, updated_at)
    VALUES (gen_random_uuid(), p_payment_id, p_transaction_reference, p_transaction_type, p_transaction_amount, p_processed_at, p_provider_message, now(), now());
END;
$$;

-- Fin ejercicio 02 setup
