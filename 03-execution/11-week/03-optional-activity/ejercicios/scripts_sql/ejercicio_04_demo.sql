-- Ejercicio 04 - Demo: crear programa de fidelización, cuenta y registrar millas para validar upgrade automático

-- Referencias mínimas
INSERT INTO currency (currency_id, iso_currency_code, currency_name) VALUES (gen_random_uuid(), 'USD', 'US Dollar') ON CONFLICT (iso_currency_code) DO NOTHING;
INSERT INTO airline (airline_id, home_country_id, airline_code, airline_name) 
VALUES (gen_random_uuid(), (SELECT country_id FROM country LIMIT 1), 'ALLOY', 'LoyalAir') ON CONFLICT (airline_code) DO NOTHING;

-- Crear programa y tiers
INSERT INTO loyalty_program (loyalty_program_id, airline_id, default_currency_id, program_code, program_name, expiration_months)
VALUES (gen_random_uuid(), (SELECT airline_id FROM airline WHERE airline_code='ALLOY'), (SELECT currency_id FROM currency WHERE iso_currency_code='USD'), 'LP1', 'Loyal Program 1', 36) ON CONFLICT (program_code) DO NOTHING;

-- Tiers: Bronze 0, Silver 1000, Gold 5000
INSERT INTO loyalty_tier (loyalty_tier_id, loyalty_program_id, tier_code, tier_name, priority_level, required_miles)
VALUES (gen_random_uuid(), (SELECT loyalty_program_id FROM loyalty_program WHERE program_code='LP1'), 'BR', 'Bronze', 1, 0) ON CONFLICT (loyalty_program_id, tier_code) DO NOTHING;
INSERT INTO loyalty_tier (loyalty_tier_id, loyalty_program_id, tier_code, tier_name, priority_level, required_miles)
VALUES (gen_random_uuid(), (SELECT loyalty_program_id FROM loyalty_program WHERE program_code='LP1'), 'SI', 'Silver', 2, 1000) ON CONFLICT (loyalty_program_id, tier_code) DO NOTHING;
INSERT INTO loyalty_tier (loyalty_tier_id, loyalty_program_id, tier_code, tier_name, priority_level, required_miles)
VALUES (gen_random_uuid(), (SELECT loyalty_program_id FROM loyalty_program WHERE program_code='LP1'), 'GD', 'Gold', 3, 5000) ON CONFLICT (loyalty_program_id, tier_code) DO NOTHING;

-- Crear customer y loyalty_account
INSERT INTO person_type (person_type_id, type_code, type_name) VALUES (gen_random_uuid(), 'PAX', 'Passenger') ON CONFLICT (type_code) DO NOTHING;
INSERT INTO person (person_id, person_type_id, first_name, last_name) VALUES (gen_random_uuid(), (SELECT person_type_id FROM person_type WHERE type_code='PAX'), 'Alice', 'Loyal') ON CONFLICT (person_id) DO NOTHING;
INSERT INTO airline (airline_id, home_country_id, airline_code, airline_name) VALUES (gen_random_uuid(), (SELECT country_id FROM country LIMIT 1), 'ALCUST', 'CustomerAir') ON CONFLICT (airline_code) DO NOTHING;
INSERT INTO customer (customer_id, airline_id, person_id, customer_since) 
VALUES (gen_random_uuid(), (SELECT airline_id FROM airline WHERE airline_code='ALCUST'), (SELECT person_id FROM person WHERE first_name='Alice' AND last_name='Loyal'), current_date) ON CONFLICT (airline_id, person_id) DO NOTHING;

INSERT INTO loyalty_account (loyalty_account_id, customer_id, loyalty_program_id, account_number)
VALUES (gen_random_uuid(), (SELECT customer_id FROM customer WHERE person_id=(SELECT person_id FROM person WHERE first_name='Alice' AND last_name='Loyal')), (SELECT loyalty_program_id FROM loyalty_program WHERE program_code='LP1'), 'LA-ALICE-001') ON CONFLICT (account_number) DO NOTHING;

-- Registrar transacciones de millas mediante el procedimiento (dispara trigger que puede actualizar tiers)
CALL proc_register_miles_transaction((SELECT loyalty_account_id FROM loyalty_account WHERE account_number='LA-ALICE-001'), 'EARN', 600, now(), 'REF-001', 'First earn');
CALL proc_register_miles_transaction((SELECT loyalty_account_id FROM loyalty_account WHERE account_number='LA-ALICE-001'), 'EARN', 500, now(), 'REF-002', 'Second earn');
CALL proc_register_miles_transaction((SELECT loyalty_account_id FROM loyalty_account WHERE account_number='LA-ALICE-001'), 'EARN', 4000, now(), 'REF-003', 'Big earn to reach Gold');

-- Verificar historial de transacciones y niveles asignados
SELECT mt.miles_transaction_id, mt.transaction_type, mt.miles_delta, mt.occurred_at, mt.reference_code
FROM miles_transaction mt
WHERE mt.loyalty_account_id = (SELECT loyalty_account_id FROM loyalty_account WHERE account_number='LA-ALICE-001') ORDER BY mt.occurred_at;

SELECT lat.loyalty_account_tier_id, lt.tier_code, lt.tier_name, lat.assigned_at
FROM loyalty_account_tier lat
JOIN loyalty_tier lt ON lat.loyalty_tier_id = lt.loyalty_tier_id
WHERE lat.loyalty_account_id = (SELECT loyalty_account_id FROM loyalty_account WHERE account_number='LA-ALICE-001')
ORDER BY lat.assigned_at;

-- Fin demo ejercicio 04
