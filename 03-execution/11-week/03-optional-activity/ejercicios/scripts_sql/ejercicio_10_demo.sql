-- Ejercicio 10 - Demo: registrar documento de persona y verificar trigger

-- Preparar tipos
INSERT INTO document_type (document_type_id, type_code, type_name) VALUES (gen_random_uuid(), 'PAS', 'Passport') ON CONFLICT (type_code) DO NOTHING;
INSERT INTO person_type (person_type_id, type_code, type_name) VALUES (gen_random_uuid(), 'PAX', 'Passenger') ON CONFLICT (type_code) DO NOTHING;

-- Crear persona
INSERT INTO person (person_id, person_type_id, first_name, last_name, birth_date) VALUES (gen_random_uuid(), (SELECT person_type_id FROM person_type WHERE type_code='PAX'), 'Clara', 'Documento', '1990-01-01') ON CONFLICT (person_id) DO NOTHING;

-- Registrar documento mediante procedimiento (dispara trigger que actualiza person.updated_at)
CALL proc_register_person_document(
    (SELECT person_id FROM person WHERE first_name='Clara' AND last_name='Documento'),
    (SELECT document_type_id FROM document_type WHERE type_code='PAS'),
    (SELECT country_id FROM country LIMIT 1),
    'P-EX-123456',
    current_date - interval '5 year',
    current_date + interval '5 year'
);

-- Verificar documento creado y marca de actualización en person
SELECT pd.person_document_id, pd.document_number, pd.issued_on, pd.expires_on FROM person_document pd WHERE pd.person_id = (SELECT person_id FROM person WHERE first_name='Clara' AND last_name='Documento');

SELECT person_id, first_name, last_name, updated_at FROM person WHERE first_name='Clara' AND last_name='Documento';

-- Fin demo ejercicio 10
