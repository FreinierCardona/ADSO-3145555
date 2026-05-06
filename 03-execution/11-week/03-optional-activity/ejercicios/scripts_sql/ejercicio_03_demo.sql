-- Ejercicio 03 - Demo: preparar factura y añadir línea facturable mediante procedimiento

-- Referencias mínimas
INSERT INTO currency (currency_id, iso_currency_code, currency_name) VALUES (gen_random_uuid(), 'USD', 'US Dollar') ON CONFLICT (iso_currency_code) DO NOTHING;
INSERT INTO invoice_status (invoice_status_id, status_code, status_name) VALUES (gen_random_uuid(), 'DRAFT', 'Draft') ON CONFLICT (status_code) DO NOTHING;

-- Crear venta mínima y factura
INSERT INTO reservation_status (reservation_status_id, status_code, status_name) VALUES (gen_random_uuid(), 'CONF', 'Confirmed') ON CONFLICT (status_code) DO NOTHING;
INSERT INTO sale_channel (sale_channel_id, channel_code, channel_name) VALUES (gen_random_uuid(), 'WEB', 'Web') ON CONFLICT (channel_code) DO NOTHING;
INSERT INTO reservation (reservation_id, reservation_status_id, sale_channel_id, reservation_code, booked_at)
VALUES (gen_random_uuid(), (SELECT reservation_status_id FROM reservation_status WHERE status_code='CONF'), (SELECT sale_channel_id FROM sale_channel WHERE channel_code='WEB'), 'R-INV-001', now()) ON CONFLICT (reservation_code) DO NOTHING;
INSERT INTO sale (sale_id, reservation_id, currency_id, sale_code, sold_at)
VALUES (gen_random_uuid(), (SELECT reservation_id FROM reservation WHERE reservation_code='R-INV-001'), (SELECT currency_id FROM currency WHERE iso_currency_code='USD'), 'S-INV-001', now()) ON CONFLICT (sale_code) DO NOTHING;

INSERT INTO invoice (invoice_id, sale_id, invoice_status_id, currency_id, invoice_number, issued_at)
VALUES (gen_random_uuid(), (SELECT sale_id FROM sale WHERE sale_code='S-INV-001'), (SELECT invoice_status_id FROM invoice_status WHERE status_code='DRAFT'), (SELECT currency_id FROM currency WHERE iso_currency_code='USD'), 'INV-EX-001', now()) ON CONFLICT (invoice_number) DO NOTHING;

-- Crear impuesto
INSERT INTO tax (tax_id, tax_code, tax_name, rate_percentage, effective_from) VALUES (gen_random_uuid(), 'VAT', 'VAT 10%', 10.000, current_date) ON CONFLICT (tax_code) DO NOTHING;

-- Llamar al procedimiento para añadir una línea
CALL proc_add_invoice_line(
    (SELECT invoice_id FROM invoice WHERE invoice_number='INV-EX-001'),
    (SELECT tax_id FROM tax WHERE tax_code='VAT'),
    1,
    'Servicio de transporte',
    1,
    100.00
);

-- Validar: revisar las líneas y la cabecera actualizada
SELECT il.invoice_line_id, il.line_number, il.line_description, il.quantity, il.unit_price, t.tax_code
FROM invoice_line il LEFT JOIN tax t ON il.tax_id = t.tax_id
WHERE il.invoice_id = (SELECT invoice_id FROM invoice WHERE invoice_number='INV-EX-001');

SELECT invoice_id, invoice_number, issued_at, updated_at FROM invoice WHERE invoice_number='INV-EX-001';

-- Fin demo ejercicio 03
