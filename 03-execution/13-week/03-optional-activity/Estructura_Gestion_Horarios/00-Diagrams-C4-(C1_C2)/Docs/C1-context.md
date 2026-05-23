# C1 - Contexto del Sistema
## Sistema de Gestión de Horarios Académicos del SENA

**Fecha:** 21 de mayo de 2026 | **Autor:** Freinier Cardona

---

## 1. Introducción

El Sistema de Gestión de Horarios Académicos centraliza la programación de ambientes, instructores y fichas académicas del SENA, eliminando conflictos y optimizando recursos mediante validación automática.

---

## 2. Objetivo

**Problemas que resuelve:**
- Cruces de horarios
- Conflictos de ambientes
- Duplicidad de instructores
- Ineficiencia administrativa
- Subutilización de recursos

**Funcionalidades MVP:**
- CRUD de ambientes, instructores y fichas
- Validación automática de horarios
- Consulta de disponibilidad
- Reportes básicos
- Sistema de observaciones

---

## 3. Actores Principales

| Actor | Responsabilidades | Acceso |
|-------|-------------------|--------|
| **Coordinador Académico** | Programar fichas, asignar instructores, generar reportes | Completo |
| **Instructor** | Consultar disponibilidad, ver horarios asignados | Lectura |
| **Admin. Ambientes** | Gestionar espacios, registrar capacidades | Gestión de recursos |

---

## 4. Relaciones del Sistema

**Coordinador Académico** → Programa horarios, valida disponibilidad, genera reportes

**Instructor** → Consulta horarios asignados y disponibilidad personal

**Administrador de Ambientes** → Mantiene inventario de espacios, registra capacidades

```
[Coordinador] ────┐
[Instructor]      ├──→ [SISTEMA CENTRALIZADO] ←──→ Base de Datos
[Admin. Amb.] ────┘
```

---

## 5. Alcance

**Incluye:** Ambientes, instructores, fichas, validación de horarios, disponibilidad, reportes, observaciones

**Excluye:** Estudiantes, calificaciones, matrículas, asistencia, recursos financieros

---

## 6. Restricciones

- Acceso vía navegador web
- Conexión internet estable requerida
- Autenticación centralizada del SENA
- Base de datos compartida

