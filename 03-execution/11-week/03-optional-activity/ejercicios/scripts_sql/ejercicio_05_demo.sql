-- Ejercicio 05 - Demo: registrar mantenimiento y completar evento para validar actualización de aeronave

-- Insertar datos de referencia mínimos
INSERT INTO aircraft_manufacturer (aircraft_manufacturer_id, manufacturer_name) VALUES (gen_random_uuid(), 'MAINTEX') ON CONFLICT (manufacturer_name) DO NOTHING;
INSERT INTO aircraft_model (aircraft_model_id, aircraft_manufacturer_id, model_code, model_name) 
VALUES (gen_random_uuid(), (SELECT aircraft_manufacturer_id FROM aircraft_manufacturer WHERE manufacturer_name='MAINTEX'), 'MX1', 'MaintModel') ON CONFLICT (aircraft_manufacturer_id, model_code) DO NOTHING;
INSERT INTO airline (airline_id, home_country_id, airline_code, airline_name) VALUES (gen_random_uuid(), (SELECT country_id FROM country LIMIT 1), 'MAINT', 'MaintAir') ON CONFLICT (airline_code) DO NOTHING;

-- Crear aeronave mínima
INSERT INTO aircraft (aircraft_id, airline_id, aircraft_model_id, registration_number, serial_number)
VALUES (gen_random_uuid(), (SELECT airline_id FROM airline WHERE airline_code='MAINT'), (SELECT aircraft_model_id FROM aircraft_model WHERE model_code='MX1'), 'REG-MNT-01', 'SN-MNT-01') ON CONFLICT (registration_number) DO NOTHING;

-- Tipos y proveedores
INSERT INTO maintenance_type (maintenance_type_id, type_code, type_name) VALUES (gen_random_uuid(), 'CHK', 'Check') ON CONFLICT (type_code) DO NOTHING;
INSERT INTO maintenance_provider (maintenance_provider_id, provider_name) VALUES (gen_random_uuid(), 'ProviderEx') ON CONFLICT (provider_name) DO NOTHING;

-- Registrar evento de mantenimiento via procedimiento
CALL proc_register_maintenance_event(
    (SELECT aircraft_id FROM aircraft WHERE registration_number='REG-MNT-01'),
    (SELECT maintenance_type_id FROM maintenance_type WHERE type_code='CHK'),
    (SELECT maintenance_provider_id FROM maintenance_provider WHERE provider_name='ProviderEx'),
    'PLANNED',
    now(),
    'Revision programada'
);

-- Obtener el evento recien creado
SELECT me.maintenance_event_id, me.status_code, me.started_at FROM maintenance_event me
WHERE me.aircraft_id = (SELECT aircraft_id FROM aircraft WHERE registration_number='REG-MNT-01') ORDER BY me.created_at DESC LIMIT 1;

-- Actualizar a COMPLETED para disparar el trigger que actualiza aircraft.in_service_on
UPDATE maintenance_event SET status_code='COMPLETED', completed_at = now(), updated_at = now()
WHERE maintenance_event_id = (SELECT maintenance_event_id FROM maintenance_event WHERE aircraft_id=(SELECT aircraft_id FROM aircraft WHERE registration_number='REG-MNT-01') ORDER BY created_at DESC LIMIT 1);

-- Verificar aeronave actualizada
SELECT aircraft_id, registration_number, in_service_on, updated_at FROM aircraft WHERE registration_number='REG-MNT-01';

-- Fin demo ejercicio 05
