-- Ejercicio 01 - Demo: preparar datos mínimos, ejecutar el procedimiento y verificar trigger

-- Insertar datos de referencia mínimos (idempotente)
INSERT INTO time_zone (time_zone_id, time_zone_name, utc_offset_minutes) VALUES (gen_random_uuid(), 'UTC_EX1', 0) ON CONFLICT (time_zone_name) DO NOTHING;
INSERT INTO continent (continent_id, continent_code, continent_name) VALUES (gen_random_uuid(), 'NA_EX', 'NorthEx') ON CONFLICT (continent_code) DO NOTHING;
INSERT INTO country (country_id, continent_id, iso_alpha2, iso_alpha3, country_name) 
VALUES (gen_random_uuid(), (SELECT continent_id FROM continent WHERE continent_code='NA_EX'), 'US', 'USA', 'United States Ex') ON CONFLICT (iso_alpha2) DO NOTHING;
INSERT INTO state_province (state_province_id, country_id, state_code, state_name)
VALUES (gen_random_uuid(), (SELECT country_id FROM country WHERE iso_alpha2='US'), 'EX', 'StateEx') ON CONFLICT (country_id, state_name) DO NOTHING;
INSERT INTO city (city_id, state_province_id, time_zone_id, city_name)
VALUES (gen_random_uuid(), (SELECT state_province_id FROM state_province WHERE state_name='StateEx'), (SELECT time_zone_id FROM time_zone WHERE time_zone_name='UTC_EX1'), 'CityEx') ON CONFLICT (state_province_id, city_name) DO NOTHING;
INSERT INTO district (district_id, city_id, district_name)
VALUES (gen_random_uuid(), (SELECT city_id FROM city WHERE city_name='CityEx'), 'DistrictEx') ON CONFLICT (city_id, district_name) DO NOTHING;
INSERT INTO address (address_id, district_id, address_line_1)
VALUES (gen_random_uuid(), (SELECT district_id FROM district WHERE district_name='DistrictEx'), 'Address Ex 123') ON CONFLICT (address_id) DO NOTHING;

INSERT INTO currency (currency_id, iso_currency_code, currency_name, minor_units) 
VALUES (gen_random_uuid(), 'USD', 'US Dollar', 2) ON CONFLICT (iso_currency_code) DO NOTHING;

-- Airline / aircraft baseline
INSERT INTO airline (airline_id, home_country_id, airline_code, airline_name, iata_code, icao_code)
VALUES (gen_random_uuid(), (SELECT country_id FROM country WHERE iso_alpha2='US'), 'ALX1', 'Airline Ex', 'AX', 'ALX') ON CONFLICT (airline_code) DO NOTHING;
INSERT INTO aircraft_manufacturer (aircraft_manufacturer_id, manufacturer_name) VALUES (gen_random_uuid(), 'MANUF_EX') ON CONFLICT (manufacturer_name) DO NOTHING;
INSERT INTO aircraft_model (aircraft_model_id, aircraft_manufacturer_id, model_code, model_name) 
VALUES (gen_random_uuid(), (SELECT aircraft_manufacturer_id FROM aircraft_manufacturer WHERE manufacturer_name='MANUF_EX'), 'MDL1', 'Model EX', 10000) ON CONFLICT (aircraft_manufacturer_id, model_code) DO NOTHING;
INSERT INTO cabin_class (cabin_class_id, class_code, class_name) VALUES (gen_random_uuid(), 'ECON', 'Economy') ON CONFLICT (class_code) DO NOTHING;
INSERT INTO aircraft (aircraft_id, airline_id, aircraft_model_id, registration_number, serial_number)
VALUES (gen_random_uuid(), (SELECT airline_id FROM airline WHERE airline_code='ALX1'), (SELECT aircraft_model_id FROM aircraft_model WHERE model_code='MDL1' LIMIT 1), 'REG123', 'SN123') ON CONFLICT (registration_number) DO NOTHING;

-- Airport and flight
INSERT INTO airport (airport_id, address_id, airport_name, iata_code, icao_code)
VALUES (gen_random_uuid(), (SELECT address_id FROM address LIMIT 1), 'Airport Ex A', 'APX', 'APEX') ON CONFLICT (iata_code) DO NOTHING;
INSERT INTO airport (airport_id, address_id, airport_name, iata_code, icao_code)
VALUES (gen_random_uuid(), (SELECT address_id FROM address LIMIT 1), 'Airport Ex B', 'BPX', 'BPEX') ON CONFLICT (iata_code) DO NOTHING;

INSERT INTO flight_status (flight_status_id, status_code, status_name)
VALUES (gen_random_uuid(), 'SCHEDULED', 'Scheduled') ON CONFLICT (status_code) DO NOTHING;

INSERT INTO flight (flight_id, airline_id, aircraft_id, flight_status_id, flight_number, service_date)
VALUES (gen_random_uuid(), (SELECT airline_id FROM airline WHERE airline_code='ALX1'), (SELECT aircraft_id FROM aircraft WHERE registration_number='REG123'), (SELECT flight_status_id FROM flight_status WHERE status_code='SCHEDULED'), 'FX100', current_date) ON CONFLICT (airline_id, flight_number, service_date) DO NOTHING;

INSERT INTO flight_segment (flight_segment_id, flight_id, origin_airport_id, destination_airport_id, segment_number, scheduled_departure_at, scheduled_arrival_at)
VALUES (gen_random_uuid(), (SELECT flight_id FROM flight WHERE flight_number='FX100' AND service_date=current_date), (SELECT airport_id FROM airport WHERE iata_code='APX'), (SELECT airport_id FROM airport WHERE iata_code='BPX'), 1, now() + interval '2 hour', now() + interval '4 hour') ON CONFLICT (flight_id, segment_number) DO NOTHING;

-- Sale / reservation / passenger / ticket
INSERT INTO reservation_status (reservation_status_id, status_code, status_name) VALUES (gen_random_uuid(), 'CONF', 'Confirmed') ON CONFLICT (status_code) DO NOTHING;
INSERT INTO sale_channel (sale_channel_id, channel_code, channel_name) VALUES (gen_random_uuid(), 'WEB', 'Web') ON CONFLICT (channel_code) DO NOTHING;

INSERT INTO reservation (reservation_id, reservation_status_id, sale_channel_id, reservation_code, booked_at)
VALUES (gen_random_uuid(), (SELECT reservation_status_id FROM reservation_status WHERE status_code='CONF'), (SELECT sale_channel_id FROM sale_channel WHERE channel_code='WEB'), 'R-EX-001', now()) ON CONFLICT (reservation_code) DO NOTHING;

INSERT INTO person_type (person_type_id, type_code, type_name) VALUES (gen_random_uuid(), 'PAX', 'Passenger') ON CONFLICT (type_code) DO NOTHING;
INSERT INTO person (person_id, person_type_id, first_name, last_name) 
VALUES (gen_random_uuid(), (SELECT person_type_id FROM person_type WHERE type_code='PAX'), 'John', 'Doe') ON CONFLICT (person_id) DO NOTHING;

INSERT INTO reservation_passenger (reservation_passenger_id, reservation_id, person_id, passenger_sequence_no, passenger_type)
VALUES (gen_random_uuid(), (SELECT reservation_id FROM reservation WHERE reservation_code='R-EX-001'), (SELECT person_id FROM person WHERE first_name='John' AND last_name='Doe'), 1, 'ADULT') ON CONFLICT (reservation_id, person_id) DO NOTHING;

INSERT INTO sale (sale_id, reservation_id, currency_id, sale_code, sold_at)
VALUES (gen_random_uuid(), (SELECT reservation_id FROM reservation WHERE reservation_code='R-EX-001'), (SELECT currency_id FROM currency WHERE iso_currency_code='USD'), 'S-EX-001', now()) ON CONFLICT (sale_code) DO NOTHING;

INSERT INTO fare_class (fare_class_id, cabin_class_id, fare_class_code, fare_class_name)
VALUES (gen_random_uuid(), (SELECT cabin_class_id FROM cabin_class WHERE class_code='ECON'), 'Y', 'Economy') ON CONFLICT (fare_class_code) DO NOTHING;

INSERT INTO fare (fare_id, airline_id, origin_airport_id, destination_airport_id, fare_class_id, currency_id, fare_code, base_amount, valid_from)
VALUES (gen_random_uuid(), (SELECT airline_id FROM airline WHERE airline_code='ALX1'), (SELECT airport_id FROM airport WHERE iata_code='APX'), (SELECT airport_id FROM airport WHERE iata_code='BPX'), (SELECT fare_class_id FROM fare_class WHERE fare_class_code='Y'), (SELECT currency_id FROM currency WHERE iso_currency_code='USD'), 'FEX1', 100.00, current_date) ON CONFLICT (fare_code) DO NOTHING;

INSERT INTO ticket_status (ticket_status_id, status_code, status_name) VALUES (gen_random_uuid(), 'ISSUED', 'Issued') ON CONFLICT (status_code) DO NOTHING;

INSERT INTO ticket (ticket_id, sale_id, reservation_passenger_id, fare_id, ticket_status_id, ticket_number, issued_at)
VALUES (gen_random_uuid(), (SELECT sale_id FROM sale WHERE sale_code='S-EX-001'), (SELECT reservation_passenger_id FROM reservation_passenger WHERE passenger_sequence_no=1 AND reservation_id=(SELECT reservation_id FROM reservation WHERE reservation_code='R-EX-001')), (SELECT fare_id FROM fare WHERE fare_code='FEX1'), (SELECT ticket_status_id FROM ticket_status WHERE status_code='ISSUED'), 'TK-EX-001', now()) ON CONFLICT (ticket_number) DO NOTHING;

INSERT INTO ticket_segment (ticket_segment_id, ticket_id, flight_segment_id, segment_sequence_no)
VALUES (gen_random_uuid(), (SELECT ticket_id FROM ticket WHERE ticket_number='TK-EX-001'), (SELECT flight_segment_id FROM flight_segment WHERE segment_number=1 AND flight_id=(SELECT flight_id FROM flight WHERE flight_number='FX100')), 1) ON CONFLICT (ticket_id, segment_sequence_no) DO NOTHING;

-- Datos para check-in: estado y grupo
INSERT INTO check_in_status (check_in_status_id, status_code, status_name) VALUES (gen_random_uuid(), 'OK', 'Checked') ON CONFLICT (status_code) DO NOTHING;
INSERT INTO boarding_group (boarding_group_id, group_code, group_name, sequence_no) VALUES (gen_random_uuid(), 'BG1', 'Group 1', 1) ON CONFLICT (group_code) DO NOTHING;

-- Ejecutar el procedimiento para registrar check-in (dispara trigger que crea boarding_pass)
CALL proc_register_check_in(
    (SELECT ticket_segment_id FROM ticket_segment WHERE ticket_id=(SELECT ticket_id FROM ticket WHERE ticket_number='TK-EX-001') LIMIT 1),
    (SELECT check_in_status_id FROM check_in_status WHERE status_code='OK'),
    (SELECT boarding_group_id FROM boarding_group WHERE group_code='BG1'),
    NULL
);

-- Verificar resultados
SELECT 'CheckIns' AS section, c.check_in_id, c.ticket_segment_id, cis.status_name, bg.group_name, c.checked_in_at
FROM check_in c
JOIN check_in_status cis ON c.check_in_status_id = cis.check_in_status_id
LEFT JOIN boarding_group bg ON c.boarding_group_id = bg.boarding_group_id
WHERE c.checked_in_at > now() - interval '1 hour';

SELECT 'BoardingPasses' AS section, bp.boarding_pass_id, bp.check_in_id, bp.boarding_pass_code, bp.barcode_value, bp.issued_at
FROM boarding_pass bp
WHERE bp.issued_at > now() - interval '1 hour';

-- Fin demo ejercicio 01
