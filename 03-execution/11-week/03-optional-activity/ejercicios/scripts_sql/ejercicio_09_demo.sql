-- Ejercicio 09 - Demo: publicar una tarifa y verificar su creación

-- Datos mínimos
INSERT INTO currency (currency_id, iso_currency_code, currency_name) VALUES (gen_random_uuid(), 'USD', 'US Dollar') ON CONFLICT (iso_currency_code) DO NOTHING;
INSERT INTO address (address_id, district_id, address_line_1) VALUES (gen_random_uuid(), (SELECT district_id FROM district LIMIT 1), 'Addr F1') ON CONFLICT (address_id) DO NOTHING;
INSERT INTO airport (airport_id, address_id, airport_name, iata_code, icao_code) VALUES (gen_random_uuid(), (SELECT address_id FROM address WHERE address_line_1='Addr F1'), 'Fare Origin', 'ORF', 'ORFX') ON CONFLICT (iata_code) DO NOTHING;
INSERT INTO airport (airport_id, address_id, airport_name, iata_code, icao_code) VALUES (gen_random_uuid(), (SELECT address_id FROM address WHERE address_line_1='Addr F1'), 'Fare Dest', 'DFT', 'DFTX') ON CONFLICT (iata_code) DO NOTHING;
INSERT INTO airline (airline_id, home_country_id, airline_code, airline_name) VALUES (gen_random_uuid(), (SELECT country_id FROM country LIMIT 1), 'FAIR', 'FareAir') ON CONFLICT (airline_code) DO NOTHING;
INSERT INTO cabin_class (cabin_class_id, class_code, class_name) VALUES (gen_random_uuid(), 'BUS', 'Business') ON CONFLICT (class_code) DO NOTHING;
INSERT INTO fare_class (fare_class_id, cabin_class_id, fare_class_code, fare_class_name) VALUES (gen_random_uuid(), (SELECT cabin_class_id FROM cabin_class WHERE class_code='BUS'), 'J', 'Business') ON CONFLICT (fare_class_code) DO NOTHING;

-- Publicar tarifa mediante procedimiento
CALL proc_publish_fare(
    (SELECT airline_id FROM airline WHERE airline_code='FAIR'),
    (SELECT airport_id FROM airport WHERE iata_code='ORF'),
    (SELECT airport_id FROM airport WHERE iata_code='DFT'),
    (SELECT fare_class_id FROM fare_class WHERE fare_class_code='J'),
    (SELECT currency_id FROM currency WHERE iso_currency_code='USD'),
    'F-FAIR-001',
    350.00,
    current_date,
    current_date + interval '30 days'
);

-- Verificar tarifa creada
SELECT fare_id, fare_code, base_amount, valid_from, valid_to, updated_at FROM fare WHERE fare_code='F-FAIR-001';

-- Fin demo ejercicio 09
