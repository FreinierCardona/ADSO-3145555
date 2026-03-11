-- Ejecutar el script .sql en una base de datos ya creada en PostgreSQL
---------------------------------------------------------------
-- ENTIDADES

-- MODULE 2: PARAMETER
CREATE TABLE type_document (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    -- Campos de auditoria simplificados
    created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ, deleted_at TIMESTAMPTZ,
    created_by INT, updated_by INT, deleted_by INT, status VARCHAR(20) DEFAULT 'Activo'
);

CREATE TABLE person (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    document_number VARCHAR(20) UNIQUE NOT NULL,
    type_document_id INT REFERENCES type_document(id),
    
    created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ, deleted_at TIMESTAMPTZ,
    created_by INT, updated_by INT, deleted_by INT, status VARCHAR(20) DEFAULT 'Activo'
);

CREATE TABLE file (
    id SERIAL PRIMARY KEY,
    file_name VARCHAR(255) NOT NULL,
    file_path TEXT NOT NULL,
    
    created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ, deleted_at TIMESTAMPTZ,
    created_by INT, updated_by INT, deleted_by INT, status VARCHAR(20) DEFAULT 'Activo'
);


-- MODULE 1: SECURITY
CREATE TABLE role (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    
    created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ, deleted_at TIMESTAMPTZ,
    created_by INT, updated_by INT, deleted_by INT, status VARCHAR(20) DEFAULT 'Activo'
);

CREATE TABLE app_user ( -- Se usa app_user porque user es palabra reservada en SQL
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    person_id INT REFERENCES person(id),
    
    created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ, deleted_at TIMESTAMPTZ,
    created_by INT, updated_by INT, deleted_by INT, status VARCHAR(20) DEFAULT 'Activo'
);

CREATE TABLE module (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    
    created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ, deleted_at TIMESTAMPTZ,
    created_by INT, updated_by INT, deleted_by INT, status VARCHAR(20) DEFAULT 'Activo'
);

CREATE TABLE app_view ( -- app_view porque view es palabra reservada
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    route_path VARCHAR(255) NOT NULL,
    
    created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ, deleted_at TIMESTAMPTZ,
    created_by INT, updated_by INT, deleted_by INT, status VARCHAR(20) DEFAULT 'Activo'
);

-- PIVOTES DE SEGURIDAD
CREATE TABLE user_role (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES app_user(id),
    role_id INT REFERENCES role(id),
    
    created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ, deleted_at TIMESTAMPTZ,
    created_by INT, updated_by INT, deleted_by INT, status VARCHAR(20) DEFAULT 'Activo'
);

CREATE TABLE role_module (
    id SERIAL PRIMARY KEY,
    role_id INT REFERENCES role(id),
    module_id INT REFERENCES module(id),
    can_create BOOLEAN DEFAULT false,
    can_read BOOLEAN DEFAULT true,
    can_update BOOLEAN DEFAULT false,
    can_delete BOOLEAN DEFAULT false,
    
    created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ, deleted_at TIMESTAMPTZ,
    created_by INT, updated_by INT, deleted_by INT, status VARCHAR(20) DEFAULT 'Activo'
);

CREATE TABLE module_view (
    id SERIAL PRIMARY KEY,
    module_id INT REFERENCES module(id),
    view_id INT REFERENCES app_view(id),
    
    created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ, deleted_at TIMESTAMPTZ,
    created_by INT, updated_by INT, deleted_by INT, status VARCHAR(20) DEFAULT 'Activo'
);


-- MODULE 3: INVENTORY
CREATE TABLE category (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    
    created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ, deleted_at TIMESTAMPTZ,
    created_by INT, updated_by INT, deleted_by INT, status VARCHAR(20) DEFAULT 'Activo'
);

CREATE TABLE supplier (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    contact_email VARCHAR(150),
    
    created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ, deleted_at TIMESTAMPTZ,
    created_by INT, updated_by INT, deleted_by INT, status VARCHAR(20) DEFAULT 'Activo'
);

CREATE TABLE product (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category_id INT REFERENCES category(id),
    supplier_id INT REFERENCES supplier(id),
    
    created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ, deleted_at TIMESTAMPTZ,
    created_by INT, updated_by INT, deleted_by INT, status VARCHAR(20) DEFAULT 'Activo'
);

CREATE TABLE inventory (
    id SERIAL PRIMARY KEY,
    product_id INT REFERENCES product(id),
    stock_quantity INT NOT NULL DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ, deleted_at TIMESTAMPTZ,
    created_by INT, updated_by INT, deleted_by INT, status VARCHAR(20) DEFAULT 'Activo'
);


-- MODULE 4: SALES
CREATE TABLE customer (
    id SERIAL PRIMARY KEY,
    person_id INT REFERENCES person(id),
    
    created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ, deleted_at TIMESTAMPTZ,
    created_by INT, updated_by INT, deleted_by INT, status VARCHAR(20) DEFAULT 'Activo'
);

CREATE TABLE app_order ( -- app_order porque order es reservada
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customer(id),
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ, deleted_at TIMESTAMPTZ,
    created_by INT, updated_by INT, deleted_by INT, status VARCHAR(20) DEFAULT 'Activo'
);

CREATE TABLE order_item (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES app_order(id),
    product_id INT REFERENCES product(id),
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    
    created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ, deleted_at TIMESTAMPTZ,
    created_by INT, updated_by INT, deleted_by INT, status VARCHAR(20) DEFAULT 'Activo'
);


-- MODULE 5: METHOD PAYMENT
CREATE TABLE method_payment (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    
    created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ, deleted_at TIMESTAMPTZ,
    created_by INT, updated_by INT, deleted_by INT, status VARCHAR(20) DEFAULT 'Activo'
);


-- MODULE 6: BILLING
CREATE TABLE invoice (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES app_order(id),
    subtotal DECIMAL(10,2) NOT NULL,
    tax DECIMAL(10,2) NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    
    created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ, deleted_at TIMESTAMPTZ,
    created_by INT, updated_by INT, deleted_by INT, status VARCHAR(20) DEFAULT 'Activo'
);

CREATE TABLE invoice_item (
    id SERIAL PRIMARY KEY,
    invoice_id INT REFERENCES invoice(id),
    product_id INT REFERENCES product(id),
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    
    created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ, deleted_at TIMESTAMPTZ,
    created_by INT, updated_by INT, deleted_by INT, status VARCHAR(20) DEFAULT 'Activo'
);

CREATE TABLE payment (
    id SERIAL PRIMARY KEY,
    invoice_id INT REFERENCES invoice(id),
    method_payment_id INT REFERENCES method_payment(id),
    amount DECIMAL(10,2) NOT NULL,
    
    created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ, deleted_at TIMESTAMPTZ,
    created_by INT, updated_by INT, deleted_by INT, status VARCHAR(20) DEFAULT 'Activo'
);

------------------------------------------------------------------

-- REGISTROS 

-- 1. Insertar los 4 Roles fijos
INSERT INTO role (name) VALUES 
('Administrador'), ('Cajero'), ('Mesero'), ('Inventario');

-- 2. Tipos de Documento (10 registros)
INSERT INTO type_document (name) VALUES 
('Cédula de Ciudadanía'), ('Tarjeta de Identidad'), ('Cédula de Extranjería'), ('Pasaporte'), 
('NIT'), ('RUT'), ('Registro Civil'), ('Permiso Especial'), ('Carnet Estudiantil'), ('Otro');

-- 3. Personas (10 registros)
INSERT INTO person (first_name, last_name, document_number, type_document_id) VALUES 
('Juan', 'Pérez', '1001001', 1), ('María', 'Gómez', '1001002', 1), ('Carlos', 'López', '1001003', 1),
('Ana', 'Díaz', '1001004', 1), ('Luis', 'Martínez', '1001005', 2), ('Laura', 'García', '1001006', 2),
('Jorge', 'Rodríguez', '1001007', 3), ('Diana', 'Hernández', '1001008', 1), ('Diego', 'Ramírez', '1001009', 1),
('Sofía', 'Vargas', '1001010', 1);

-- 4. Usuarios (10 registros apuntando a las personas)
INSERT INTO app_user (username, password_hash, person_id) VALUES 
('jperez', 'hash123', 1), ('mgomez', 'hash123', 2), ('clopez', 'hash123', 3), ('adiaz', 'hash123', 4),
('lmartinez', 'hash123', 5), ('lgarcia', 'hash123', 6), ('jrodriguez', 'hash123', 7), 
('dhernandez', 'hash123', 8), ('dramirez', 'hash123', 9), ('svargas', 'hash123', 10);

-- 5. Módulos y Vistas (10 registros)
INSERT INTO module (name) VALUES 
('Seguridad'), ('Parámetros'), ('Inventario'), ('Ventas'), ('Facturación'), 
('Reportes'), ('Configuración'), ('Caja'), ('Cocina'), ('Proveedores');

INSERT INTO app_view (name, route_path) VALUES 
('Crear Usuario', '/users/create'), ('Listar Productos', '/products'), ('Nueva Venta', '/sales/new'),
('Ver Facturas', '/invoices'), ('Ajuste Inventario', '/inventory/adjust'), ('Dashboard', '/home'),
('Cerrar Caja', '/cash/close'), ('Pedidos Cocina', '/kitchen/orders'), ('Lista Clientes', '/customers'),
('Crear Proveedor', '/suppliers/create');

-- 6. Pivotes de Seguridad (10 registros)
INSERT INTO user_role (user_id, role_id) VALUES 
(1, 1), (2, 2), (3, 3), (4, 4), (5, 3), (6, 2), (7, 3), (8, 3), (9, 2), (10, 4);

-- Permisos (CRUD): Administrador puede todo en el módulo 1, Cajero solo leer en módulo 4, etc.
INSERT INTO role_module (role_id, module_id, can_create, can_read, can_update, can_delete) VALUES 
(1, 1, true, true, true, true), (1, 2, true, true, true, true), (2, 4, true, true, false, false),
(2, 5, true, true, false, false), (3, 4, true, true, false, false), (3, 9, true, true, false, false),
(4, 3, true, true, true, false), (4, 10, true, true, true, false), (1, 6, true, true, true, true),
(2, 8, true, true, false, false);

INSERT INTO module_view (module_id, view_id) VALUES 
(1, 1), (3, 2), (4, 3), (5, 4), (3, 5), (6, 6), (8, 7), (9, 8), (4, 9), (10, 10);

-- 7. Categorías y Proveedores (10 registros)
INSERT INTO category (name) VALUES 
('Bebidas Calientes'), ('Bebidas Frías'), ('Postres'), ('Panadería'), ('Sándwiches'),
('Snacks'), ('Café en Grano'), ('Tés e Infusiones'), ('Desayunos'), ('Mercancía');

INSERT INTO supplier (name, contact_email) VALUES 
('Café Quindío', 'ventas@cafe.com'), ('Lácteos del Valle', 'pedidos@lacteos.com'), ('Panificadora Nacional', 'pan@nacional.com'),
('Distribuidora de Vasos', 'insumos@vasos.com'), ('Dulces y Postres SAS', 'postres@dulces.com'), 
('Frutas Frescas', 'frutas@frescas.com'), ('Carnes y Embutidos', 'carnes@embutidos.com'), 
('Tés del Mundo', 'contacto@tes.com'), ('Aseo Limpio', 'aseo@limpio.com'), ('Papelería Central', 'papel@central.com');

-- 8. Productos e Inventario (10 registros)
INSERT INTO product (name, price, category_id, supplier_id) VALUES 
('Café Americano', 3500, 1, 1), ('Capuchino', 5000, 1, 1), ('Latte Frio', 6000, 2, 2),
('Croissant', 4000, 4, 3), ('Cheesecake', 8000, 3, 5), ('Sándwich de Pavo', 12000, 5, 7),
('Jugo Natural', 4500, 2, 6), ('Té Verde', 3000, 8, 8), ('Huevos Revueltos', 9000, 9, 2),
('Bolsa Café 500g', 25000, 7, 1);

INSERT INTO inventory (product_id, stock_quantity) VALUES 
(1, 100), (2, 80), (3, 50), (4, 30), (5, 15), (6, 20), (7, 40), (8, 60), (9, 25), (10, 10);

-- 9. Clientes y Pedidos (10 registros)
INSERT INTO customer (person_id) VALUES 
(1), (2), (3), (4), (5), (6), (7), (8), (9), (10);

INSERT INTO app_order (customer_id, total_amount) VALUES 
(1, 11500), (2, 8000), (3, 25000), (4, 4000), (5, 12000), (6, 3500), (7, 15000), (8, 9000), (9, 20000), (10, 6000);

INSERT INTO order_item (order_id, product_id, quantity, unit_price) VALUES 
(1, 1, 1, 3500), (1, 5, 1, 8000), (2, 5, 1, 8000), (3, 10, 1, 25000), (4, 4, 1, 4000),
(5, 6, 1, 12000), (6, 1, 1, 3500), (7, 2, 3, 5000), (8, 9, 1, 9000), (9, 2, 4, 5000);

-- 10. Métodos de pago, Facturas y Pagos (10 registros)
INSERT INTO method_payment (name) VALUES 
('Efectivo'), ('Tarjeta de Crédito'), ('Tarjeta de Débito'), ('Nequi'), ('Daviplata'),
('Transferencia'), ('Bono Regalo'), ('Puntos Fidelidad'), ('Cheque'), ('Criptomonedas');

INSERT INTO invoice (order_id, subtotal, tax, total) VALUES 
(1, 9663, 1837, 11500), (2, 6722, 1278, 8000), (3, 21008, 3992, 25000), (4, 3361, 639, 4000),
(5, 10084, 1916, 12000), (6, 2941, 559, 3500), (7, 12605, 2395, 15000), (8, 7563, 1437, 9000),
(9, 16806, 3194, 20000), (10, 5042, 958, 6000);

INSERT INTO invoice_item (invoice_id, product_id, quantity, unit_price) VALUES 
(1, 1, 1, 3500), (1, 5, 1, 8000), (2, 5, 1, 8000), (3, 10, 1, 25000), (4, 4, 1, 4000),
(5, 6, 1, 12000), (6, 1, 1, 3500), (7, 2, 3, 5000), (8, 9, 1, 9000), (9, 2, 4, 5000);

INSERT INTO payment (invoice_id, method_payment_id, amount) VALUES 
(1, 1, 11500), (2, 4, 8000), (3, 2, 25000), (4, 1, 4000), (5, 5, 12000),
(6, 1, 3500), (7, 2, 15000), (8, 4, 9000), (9, 3, 20000), (10, 1, 6000);


------------------------------------------------------------------

-- Funcion y Trigger 

-- Creamos la función básica
CREATE OR REPLACE FUNCTION seguridad_roles()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'No permitido: Los roles del sistema son fijos.';
END;
$$ LANGUAGE plpgsql;

-- Creamos el disparador
CREATE TRIGGER trg_roles_advertencia
BEFORE INSERT OR UPDATE OR DELETE ON role
FOR EACH ROW EXECUTE PROCEDURE seguridad_roles();
------------------------------------------------------------------
