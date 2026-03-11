-- PRUEBA DE SEGURIDAD (El trigger de Roles)

-- Intento 1: Insertar un quinto rol (Debe fallar)
INSERT INTO role (name) VALUES ('SuperUsuario');

-- Intento 2: Cambiarle el nombre a un rol existente (Debe fallar)
UPDATE role SET name = 'Administrador Total' WHERE id = 1;

-- Intento 3: Borrar un rol (Debe fallar)
DELETE FROM role WHERE id = 4;

--------------------------------------------------------------------
-- PRUEBA DE 10 REGISTROS

SELECT 'Personas' AS tabla, COUNT(*) AS total FROM person
UNION ALL

SELECT 'Productos', COUNT(*) FROM product
UNION ALL

SELECT 'Usuarios', COUNT(*) FROM app_user
UNION ALL

SELECT 'Facturas', COUNT(*) FROM invoice;

--------------------------------------------------------------------
-- PRUEBA DE LOGICA DE NEGOCIO
SELECT 
    i.id AS factura_nro,
    p.first_name || ' ' || p.last_name AS cliente,
    pr.name AS producto,
    ii.quantity AS cantidad,
    ii.unit_price AS precio,
    i.total AS total_factura
FROM invoice i
JOIN app_order o ON i.order_id = o.id
JOIN customer c ON o.customer_id = c.id
JOIN person p ON c.person_id = p.id
JOIN invoice_item ii ON i.id = ii.invoice_id
JOIN product pr ON ii.product_id = pr.id
LIMIT 6;
--------------------------------------------------------------------
-- PRUEBA DE PERMISOS 
SELECT 
    r.name AS rol,
    m.name AS modulo,
    rm.can_create AS crear,
    rm.can_read AS leer,
    rm.can_update AS actualizar,
    rm.can_delete AS eliminar
FROM role_module rm
JOIN role r ON rm.role_id = r.id
JOIN module m ON rm.module_id = m.id
WHERE r.name = 'Cajero'; -- se puede cambiar por cualquier otro rol 


