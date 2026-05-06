-- Ejercicio 08 - Demo: crear usuario, rol y asignar rol mediante procedimiento; validar auditoría

-- Preparar datos de referencia
INSERT INTO user_status (user_status_id, status_code, status_name) VALUES (gen_random_uuid(), 'ACTIVE', 'Active') ON CONFLICT (status_code) DO NOTHING;
INSERT INTO security_role (security_role_id, role_code, role_name) VALUES (gen_random_uuid(), 'OPS', 'Operations') ON CONFLICT (role_code) DO NOTHING;

-- Crear persona y cuenta de usuario
INSERT INTO person_type (person_type_id, type_code, type_name) VALUES (gen_random_uuid(), 'USR', 'User') ON CONFLICT (type_code) DO NOTHING;
INSERT INTO person (person_id, person_type_id, first_name, last_name) VALUES (gen_random_uuid(), (SELECT person_type_id FROM person_type WHERE type_code='USR'), 'Sec', 'User') ON CONFLICT (person_id) DO NOTHING;
INSERT INTO user_account (user_account_id, person_id, user_status_id, username, password_hash)
VALUES (gen_random_uuid(), (SELECT person_id FROM person WHERE first_name='Sec' AND last_name='User'), (SELECT user_status_id FROM user_status WHERE status_code='ACTIVE'), 'secuser', 'hash') ON CONFLICT (username) DO NOTHING;

-- Asignar rol con el procedimiento (dispara trigger que actualiza updated_at en user_account)
CALL proc_assign_user_role(
    (SELECT user_account_id FROM user_account WHERE username='secuser'),
    (SELECT security_role_id FROM security_role WHERE role_code='OPS'),
    NULL
);

-- Verificar asignación y auditoría
SELECT ur.user_role_id, ua.username, sr.role_code, ur.assigned_at
FROM user_role ur
JOIN user_account ua ON ur.user_account_id = ua.user_account_id
JOIN security_role sr ON ur.security_role_id = sr.security_role_id
WHERE ua.username = 'secuser';

SELECT user_account_id, username, updated_at FROM user_account WHERE username='secuser';

-- Fin demo ejercicio 08
