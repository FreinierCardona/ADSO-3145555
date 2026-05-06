-- Ejercicio 03 - Setup: trigger AFTER INSERT sobre invoice_line y procedimiento para agregar líneas

DROP TRIGGER IF EXISTS trg_invoice_line_after_insert ON invoice_line;
DROP FUNCTION IF EXISTS invoice_line_after_insert();
DROP PROCEDURE IF EXISTS proc_add_invoice_line(uuid, uuid, integer, varchar, numeric, numeric);

CREATE OR REPLACE FUNCTION invoice_line_after_insert()
RETURNS trigger AS $$
BEGIN
    -- Al insertar una línea, actualizar la cabecera de la factura (updated_at)
    UPDATE invoice SET updated_at = now() WHERE invoice_id = NEW.invoice_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_invoice_line_after_insert
AFTER INSERT ON invoice_line
FOR EACH ROW
EXECUTE FUNCTION invoice_line_after_insert();

CREATE OR REPLACE PROCEDURE proc_add_invoice_line(
    p_invoice_id uuid,
    p_tax_id uuid,
    p_line_number integer,
    p_line_description varchar,
    p_quantity numeric,
    p_unit_price numeric
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO invoice_line (invoice_line_id, invoice_id, tax_id, line_number, line_description, quantity, unit_price, created_at, updated_at)
    VALUES (gen_random_uuid(), p_invoice_id, p_tax_id, p_line_number, p_line_description, p_quantity, p_unit_price, now(), now());
END;
$$;

-- Fin ejercicio 03 setup
