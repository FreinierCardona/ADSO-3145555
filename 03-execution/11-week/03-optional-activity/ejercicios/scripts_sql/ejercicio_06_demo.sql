-- Ejercicio 06 - Demo: preparar vuelo y registrar demora para validar cambio de estado a DELAYED

-- Datos mínimos
INSERT INTO flight_status (flight_status_id, status_code, status_name) VALUES (gen_random_uuid(), 'SCHEDULED', 'Scheduled') ON CONFLICT (status_code) DO NOTHING;
INSERT INTO flight_status (flight_status_id, status_code, status_name) VALUES (gen_random_uuid(), 'DELAYED', 'Delayed') ON CONFLICT (status_code) DO NOTHING;

INSERT INTO airline (airline_id, home_country_id, airline_code, airline_name) VALUES (gen_random_uuid(), (SELECT country_id FROM country LIMIT 1), 'FLX', 'FlightEx') ON CONFLICT (airline_code) DO NOTHING;
INSERT INTO aircraft_manufacturer (aircraft_manufacturer_id, manufacturer_name) VALUES (gen_random_uuid(), 'FMX') ON CONFLICT (manufacturer_name) DO NOTHING;
INSERT INTO aircraft_model (aircraft_model_id, aircraft_manufacturer_id, model_code, model_name) 
VALUES (gen_random_uuid(), (SELECT aircraft_manufacturer_id FROM aircraft_manufacturer WHERE manufacturer_name='FMX'), 'FMDL', 'FlightModel') ON CONFLICT (aircraft_manufacturer_id, model_code) DO NOTHING;
INSERT INTO aircraft (aircraft_id, airline_id, aircraft_model_id, registration_number, serial_number)
VALUES (gen_random_uuid(), (SELECT airline_id FROM airline WHERE airline_code='FLX'), (SELECT aircraft_model_id FROM aircraft_model WHERE model_code='FMDL'), 'REG-FLX-01', 'SN-FLX-01') ON CONFLICT (registration_number) DO NOTHING;

-- Airports
INSERT INTO address (address_id, district_id, address_line_1) VALUES (gen_random_uuid(), (SELECT district_id FROM district LIMIT 1), 'Addr FX1') ON CONFLICT (address_id) DO NOTHING;
INSERT INTO airport (airport_id, address_id, airport_name, iata_code, icao_code) VALUES (gen_random_uuid(), (SELECT address_id FROM address WHERE address_line_1='Addr FX1'), 'Airport FX1', 'AFX', 'AFX1') ON CONFLICT (iata_code) DO NOTHING;
INSERT INTO airport (airport_id, address_id, airport_name, iata_code, icao_code) VALUES (gen_random_uuid(), (SELECT address_id FROM address WHERE address_line_1='Addr FX1'), 'Airport FX2', 'BFX', 'BFX2') ON CONFLICT (iata_code) DO NOTHING;

-- Flight and segment
INSERT INTO flight (flight_id, airline_id, aircraft_id, flight_status_id, flight_number, service_date)
VALUES (gen_random_uuid(), (SELECT airline_id FROM airline WHERE airline_code='FLX'), (SELECT aircraft_id FROM aircraft WHERE registration_number='REG-FLX-01'), (SELECT flight_status_id FROM flight_status WHERE status_code='SCHEDULED'), 'FLX100', current_date) ON CONFLICT (airline_id, flight_number, service_date) DO NOTHING;

INSERT INTO flight_segment (flight_segment_id, flight_id, origin_airport_id, destination_airport_id, segment_number, scheduled_departure_at, scheduled_arrival_at)
VALUES (gen_random_uuid(), (SELECT flight_id FROM flight WHERE flight_number='FLX100' AND service_date=current_date), (SELECT airport_id FROM airport WHERE iata_code='AFX'), (SELECT airport_id FROM airport WHERE iata_code='BFX'), 1, now() + interval '1 hour', now() + interval '3 hour') ON CONFLICT (flight_id, segment_number) DO NOTHING;

-- Tipo de motivo de demora
INSERT INTO delay_reason_type (delay_reason_type_id, reason_code, reason_name) VALUES (gen_random_uuid(), 'TECH', 'Technical') ON CONFLICT (reason_code) DO NOTHING;

-- Registrar demora mediante el procedimiento (dispara trigger que actualiza el estado del vuelo)
CALL proc_register_flight_delay(
    (SELECT flight_segment_id FROM flight_segment WHERE flight_id=(SELECT flight_id FROM flight WHERE flight_number='FLX100') LIMIT 1),
    (SELECT delay_reason_type_id FROM delay_reason_type WHERE reason_code='TECH'),
    now(),
    45,
    'Engine check'
);

-- Validar: verificar que el vuelo tiene estado DELAYED
SELECT f.flight_id, f.flight_number, fs.status_code, fs.status_name
FROM flight f JOIN flight_status fs ON f.flight_status_id = fs.flight_status_id
WHERE f.flight_number='FLX100';

SELECT * FROM flight_delay WHERE flight_segment_id = (SELECT flight_segment_id FROM flight_segment WHERE flight_id=(SELECT flight_id FROM flight WHERE flight_number='FLX100'));

-- Fin demo ejercicio 06
