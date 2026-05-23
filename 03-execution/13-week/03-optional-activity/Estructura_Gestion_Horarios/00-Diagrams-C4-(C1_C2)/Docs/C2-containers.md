# C2 - Contenedores del Sistema
## Sistema de Gestión de Horarios Académicos del SENA

**Fecha:** 21 de mayo de 2026 | **Autor:** Freinier Cardona

---

## 1. Introducción

El Nivel 2 (Containers) describe los componentes principales del sistema: Frontend, Backend API, Motor de Lógica de Negocio y Base de Datos. Cada contenedor es una aplicación o servicio independiente que se comunica mediante protocolos definidos.

---

## 2. Contenedores Principales

### 2.1 Frontend Web

**Propósito:** Interfaz de usuario para coordinadores e instructores

**Funcionalidades:**
- Gestión de horarios
- Visualización de calendarios
- Consulta de disponibilidad
- Reportes (PDF/Excel)

**Tecnología:** React / Vue 3 / Angular

**Comunicación:** HTTP/HTTPS (REST + JWT)

---

### 2.2 API REST Backend

**Propósito:** Orquestación de lógica de negocio y servicios

**Responsabilidades:**
- Autenticación y autorización
- Validación de reglas de negocio
- CRUD de recursos
- Manejo de conflictos de horarios

**Recursos principales:**
```
GET/POST/PUT/DELETE
  /ambientes
  /instructores
  /fichas
  /horarios
  /disponibilidad
  /reportes
```

**Seguridad:** JWT en encabezados

**Tecnología:** Spring Boot 3.0+ / Node.js / ASP.NET Core

---

### 2.3 Motor de Lógica de Negocio

**Propósito:** Validación y procesamiento de horarios

**Reglas principales:**
- Evitar asignación simultánea de ambientes
- Prevenir conflicto de instructores
- Validar rangos horarios
- Verificar capacidad de ambientes

**Integración:** Componente interno del Backend

---

### 2.4 Base de Datos

**Propósito:** Persistencia centralizada

**Entidades:**
- Ambientes
- Instructores
- Fichas
- Horarios
- Observaciones

**Características:**
- Transacciones ACID
- Integridad referencial
- Backups automáticos
- Índices para optimización

**Tecnología:** PostgreSQL 13+ / MySQL 8+

**Acceso:** Solo a través del Backend

---

## 3. Relaciones entre Contenedores

### 3.1 Frontend → API
HTTP/HTTPS + JSON + JWT

### 3.2 API → Motor de Lógica
Llamadas internas síncronas

### 3.3 API → Base de Datos
SQL/TCP

### 3.4 Flujo Completo

```
Frontend → (HTTPS/JWT) → API → (Lógica) → BD
   ↑                                        ↓
   └─────────── Respuesta JSON ────────────┘
```

---

## 4. Tecnologías Sugeridas

| Componente | Tecnología | Justificación |
|-----------|-----------|------------------|
| **Frontend** | React 18 / Vue 3 | Ecosistema maduro, componentes reutilizables |
| **Backend** | Spring Boot 3.0 / Node.js | Rendimiento, escalabilidad, soporte LTS |
| **BD** | PostgreSQL 13+ | Confiable, open source, ACID completo |
| **Autenticación** | JWT | Estándar en APIs REST, stateless |
| **API Doc** | OpenAPI/Swagger | Documentación automática |
| **Deployment** | Docker + Docker Compose | Contenedores, reproducibilidad |
| **Testing** | JUnit/Jest | Cobertura de pruebas |

---

## 5. Seguridad

- **Frontend:** HTTPS obligatorio, validación de entrada, sanitización contra XSS
- **API:** Autenticación JWT, autorización por roles (RBAC), rate limiting
- **BD:** Credenciales en variables de entorno, backups cifrados, acceso restringido

---

## 6. Formato de Comunicación

**Respuesta exitosa:**
```json
{
  "success": true,
  "data": { /* datos */ },
  "timestamp": "2026-05-21T10:30:00Z"
}
```

**Respuesta con error:**
```json
{
  "success": false,
  "error": {
    "code": "HORARIO_CONFLICTO",
    "message": "El horario propuesto entra en conflicto"
  },
  "timestamp": "2026-05-21T10:30:00Z"
}
```
