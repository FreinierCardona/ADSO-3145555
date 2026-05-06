-- Ejercicio 07 - Demo: crear ticket y registrar equipaje mediante procedimiento; verificar actualización de ticket

-- Preparar datos mínimos (idempotente)
INSERT INTO currency (currency_id, iso_currency_code, currency_name) VALUES (gen_random_uuid(), 'USD', 'US Dollar') ON CONFLICT (iso_currency_code) DO NOTHING;
INSERT INTO reservation_status (reservation_status_id, status_code, status_name) VALUES (gen_random_uuid(), 'CONF', 'Confirmed') ON CONFLICT (status_code) DO NOTHING;
INSERT INTO sale_channel (sale_channel_id, channel_code, channel_name) VALUES (gen_random_uuid(), 'WEB', 'Web') ON CONFLICT (channel_code) DO NOTHING;

INSERT INTO reservation (reservation_id, reservation_status_id, sale_channel_id, reservation_code, booked_at)
VALUES (gen_random_uuid(), (SELECT reservation_status_id FROM reservation_status WHERE status_code='CONF'), (SELECT sale_channel_id FROM sale_channel WHERE channel_code='WEB'), 'R-BAG-001', now()) ON CONFLICT (reservation_code) DO NOTHING;

INSERT INTO sale (sale_id, reservation_id, currency_id, sale_code, sold_at)
VALUES (gen_random_uuid(), (SELECT reservation_id FROM reservation WHERE reservation_code='R-BAG-001'), (SELECT currency_id FROM currency WHERE iso_currency_code='USD'), 'S-BAG-001', now()) ON CONFLICT (sale_code) DO NOTHING;

-- Crear persona y reservation_passenger
INSERT INTO person_type (person_type_id, type_code, type_name) VALUES (gen_random_uuid(), 'PAX', 'Passenger') ON CONFLICT (type_code) DO NOTHING;
INSERT INTO person (person_id, person_type_id, first_name, last_name) VALUES (gen_random_uuid(), (SELECT person_type_id FROM person_type WHERE type_code='PAX'), 'Bob', 'Baggage') ON CONFLICT (person_id) DO NOTHING;
INSERT INTO reservation_passenger (reservation_passenger_id, reservation_id, person_id, passenger_sequence_no, passenger_type)
VALUES (gen_random_uuid(), (SELECT reservation_id FROM reservation WHERE reservation_code='R-BAG-001'), (SELECT person_id FROM person WHERE first_name='Bob' AND last_name='Baggage'), 1, 'ADULT') ON CONFLICT (reservation_id, person_id) DO NOTHING;

-- Crear fare minimal y ticket
INSERT INTO cabin_class (cabin_class_id, class_code, class_name) VALUES (gen_random_uuid(), 'ECON', 'Economy') ON CONFLICT (class_code) DO NOTHING;
INSERT INTO fare_class (fare_class_id, cabin_class_id, fare_class_code, fare_class_name) VALUES (gen_random_uuid(), (SELECT cabin_class_id FROM cabin_class WHERE class_code='ECON'), 'Y', 'Economy') ON CONFLICT (fare_class_code) DO NOTHING;
INSERT INTO address (address_id, district_id, address_line_1) VALUES (gen_random_uuid(), (SELECT district_id FROM district LIMIT 1), 'Addr BAG1') ON CONFLICT (address_id) DO NOTHING;
INSERT INTO airport (airport_id, address_id, airport_name, iata_code, icao_code) VALUES (gen_random_uuid(), (SELECT address_id FROM address WHERE address_line_1='Addr BAG1'), 'Airport BAG A', 'BGA', 'BGAA') ON CONFLICT (iata_code) DO NOTHING;
INSERT INTO airport (airport_id, address_id, airport_name, iata_code, icao_code) VALUES (gen_random_uuid(), (SELECT address_id FROM address WHERE address_line_1='Addr BAG1'), 'Airport BAG B', 'BGB', 'BGBB') ON CONFLICT (iata_code) DO NOTHING;
INSERT INTO airline (airline_id, home_country_id, airline_code, airline_name) VALUES (gen_random_uuid(), (SELECT country_id FROM country LIMIT 1), 'BGAIR', 'BagAir') ON CONFLICT (airline_code) DO NOTHING;
INSERT INTO fare (fare_id, airline_id, origin_airport_id, destination_airport_id, fare_class_id, currency_id, fare_code, base_amount, valid_from)
VALUES (gen_random_uuid(), (SELECT airline_id FROM airline WHERE airline_code='BGAIR'), (SELECT airport_id FROM airport WHERE iata_code='BGA'), (SELECT airport_id FROM airport WHERE iata_code='BGB'), (SELECT fare_class_id FROM fare_class WHERE fare_class_code='Y'), (SELECT currency_id FROM currency WHERE iso_currency_code='USD'), 'F-BAG-1', 50.0, current_date) ON CONFLICT (fare_code) DO NOTHING;

INSERT INTO ticket_status (ticket_status_id, status_code, status_name) VALUES (gen_random_uuid(), 'ISSUED', 'Issued') ON CONFLICT (status_code) DO NOTHING;
INSERT INTO ticket (ticket_id, sale_id, reservation_passenger_id, fare_id, ticket_status_id, ticket_number, issued_at)
VALUES (gen_random_uuid(), (SELECT sale_id FROM sale WHERE sale_code='S-BAG-001'), (SELECT reservation_passenger_id FROM reservation_passenger WHERE reservation_id=(SELECT reservation_id FROM reservation WHERE reservation_code='R-BAG-001') LIMIT 1), (SELECT fare_id FROM fare WHERE fare_code='F-BAG-1'), (SELECT ticket_status_id FROM ticket_status WHERE status_code='ISSUED'), 'TK-BAG-001', now()) ON CONFLICT (ticket_number) DO NOTHING;

-- Crear un flight/segment para asociar (si no existe)
INSERT INTO flight_status (flight_status_id, status_code, status_name) VALUES (gen_random_uuid(), 'SCHEDULED', 'Scheduled') ON CONFLICT (status_code) DO NOTHING;
INSERT INTO aircraft_manufacturer (aircraft_manufacturer_id, manufacturer_name) VALUES (gen_random_uuid(), 'BMA') ON CONFLICT (manufacturer_name) DO NOTHING;
INSERT INTO aircraft_model (aircraft_model_id, aircraft_manufacturer_id, model_code, model_name) 
VALUES (gen_random_uuid(), (SELECT aircraft_manufacturer_id FROM aircraft_manufacturer WHERE manufacturer_name='BMA'), 'BMDL', 'BagModel') ON CONFLICT (aircraft_manufacturer_id, model_code) DO NOTHING;
INSERT INTO aircraft (aircraft_id, airline_id, aircraft_model_id, registration_number, serial_number)
VALUES (gen_random_uuid(), (SELECT airline_id FROM airline WHERE airline_code='BGAIR'), (SELECT aircraft_model_id FROM aircraft_model WHERE model_code='BMDL'), 'REG-BAG-01', 'SN-BAG-01') ON CONFLICT (registration_number) DO NOTHING;
INSERT INTO flight (flight_id, airline_id, aircraft_id, flight_status_id, flight_number, service_date)
VALUES (gen_random_uuid(), (SELECT airline_id FROM airline WHERE airline_code='BGAIR'), (SELECT aircraft_id FROM aircraft WHERE registration_number='REG-BAG-01'), (SELECT flight_status_id FROM flight_status WHERE status_code='SCHEDULED'), 'BG100', current_date) ON CONFLICT (airline_id, flight_number, service_date) DO NOTHING;
INSERT INTO flight_segment (flight_segment_id, flight_id, origin_airport_id, destination_airport_id, segment_number, scheduled_departure_at, scheduled_arrival_at)
VALUES (gen_random_uuid(), (SELECT flight_id FROM flight WHERE flight_number='BG100'), (SELECT airport_id FROM airport WHERE iata_code='BGA'), (SELECT airport_id FROM airport WHERE iata_code='BGB'), 1, now()+ interval '1 hour', now()+ interval '2 hours') ON CONFLICT (flight_id, segment_number) DO NOTHING;

-- Asociar ticket_segment
INSERT INTO ticket_segment (ticket_segment_id, ticket_id, flight_segment_id, segment_sequence_no)
VALUES (gen_random_uuid(), (SELECT ticket_id FROM ticket WHERE ticket_number='TK-BAG-001'), (SELECT flight_segment_id FROM flight_segment WHERE flight_id=(SELECT flight_id FROM flight WHERE flight_number='BG100') LIMIT 1), 1) ON CONFLICT (ticket_id, segment_sequence_no) DO NOTHING;

-- Registrar equipaje mediante procedimiento (dispara trigger que actualiza ticket.updated_at)
CALL proc_register_baggage(
    (SELECT ticket_segment_id FROM ticket_segment WHERE ticket_id=(SELECT ticket_id FROM ticket WHERE ticket_number='TK-BAG-001') LIMIT 1),
    'TAG-BAG-001',
    'CHECKED',
    'REGISTERED',
    23.5
);

-- Verificar equipaje y fecha de actualización del ticket
SELECT b.baggage_id, b.baggage_tag, b.baggage_type, b.baggage_status, b.checked_at FROM baggage b WHERE b.baggage_tag='TAG-BAG-001';

SELECT t.ticket_id, t.ticket_number, t.updated_at FROM ticket t WHERE t.ticket_number='TK-BAG-001';

-- Fin demo ejercicio 07
