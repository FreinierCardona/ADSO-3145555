-- Ejercicio 02 - Demo: preparar venta y pago, registrar transacción y verificar que se genere refund por trigger

-- Datos de referencia idempotentes
INSERT INTO currency (currency_id, iso_currency_code, currency_name) VALUES (gen_random_uuid(), 'USD', 'US Dollar') ON CONFLICT (iso_currency_code) DO NOTHING;
INSERT INTO payment_status (payment_status_id, status_code, status_name) VALUES (gen_random_uuid(), 'AUTH', 'Authorized') ON CONFLICT (status_code) DO NOTHING;
INSERT INTO payment_method (payment_method_id, method_code, method_name) VALUES (gen_random_uuid(), 'CC', 'Credit Card') ON CONFLICT (method_code) DO NOTHING;

-- Crear una reservation y venta mínima (si no existen)
INSERT INTO reservation_status (reservation_status_id, status_code, status_name) VALUES (gen_random_uuid(), 'CONF', 'Confirmed') ON CONFLICT (status_code) DO NOTHING;
INSERT INTO sale_channel (sale_channel_id, channel_code, channel_name) VALUES (gen_random_uuid(), 'WEB', 'Web') ON CONFLICT (channel_code) DO NOTHING;
INSERT INTO reservation (reservation_id, reservation_status_id, sale_channel_id, reservation_code, booked_at)
VALUES (gen_random_uuid(), (SELECT reservation_status_id FROM reservation_status WHERE status_code='CONF'), (SELECT sale_channel_id FROM sale_channel WHERE channel_code='WEB'), 'R-PAY-001', now()) ON CONFLICT (reservation_code) DO NOTHING;

INSERT INTO sale (sale_id, reservation_id, currency_id, sale_code, sold_at)
VALUES (gen_random_uuid(), (SELECT reservation_id FROM reservation WHERE reservation_code='R-PAY-001'), (SELECT currency_id FROM currency WHERE iso_currency_code='USD'), 'S-PAY-001', now()) ON CONFLICT (sale_code) DO NOTHING;

-- Crear un payment asociado a la venta
INSERT INTO payment (payment_id, sale_id, payment_status_id, payment_method_id, currency_id, payment_reference, amount, authorized_at)
VALUES (gen_random_uuid(), (SELECT sale_id FROM sale WHERE sale_code='S-PAY-001'), (SELECT payment_status_id FROM payment_status WHERE status_code='AUTH'), (SELECT payment_method_id FROM payment_method WHERE method_code='CC'), (SELECT currency_id FROM currency WHERE iso_currency_code='USD'), 'PAYREF-001', 150.00, now()) ON CONFLICT (payment_reference) DO NOTHING;

-- Registrar una transacción tipo REFUND usando el procedimiento (dispara trigger que crea refund)
CALL proc_register_payment_transaction(
    (SELECT payment_id FROM payment WHERE payment_reference='PAYREF-001'),
    'TX-REF-001',
    'REFUND',
    150.00,
    now(),
    'Reembolso por prueba'
);

-- Verificar que la transacción y el refund fueron creados
SELECT pt.payment_transaction_id, pt.transaction_reference, pt.transaction_type, pt.transaction_amount, pt.processed_at
FROM payment_transaction pt
WHERE pt.transaction_reference = 'TX-REF-001';

SELECT r.refund_id, r.refund_reference, r.amount, r.requested_at
FROM refund r
WHERE r.refund_reference LIKE 'RF-%' ORDER BY r.created_at DESC LIMIT 1;

-- Fin demo ejercicio 02
