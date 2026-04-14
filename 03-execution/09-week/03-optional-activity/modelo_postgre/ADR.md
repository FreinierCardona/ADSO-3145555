# ADR-001: Refactorización y corrección del esquema PostgreSQL

| Campo | Valor |
|---|---|
| **Título** | ADR-001: Refactorización y Corrección del Esquema de Base de Datos |
| **Fecha** | 2026-04-13 |
| **Estado** | Aplicado |
| **Autor** | Freinier Steven Cardona Pérez |
| **Backup** | ADR.original.md |

## Tabla de contenidos

- [Resumen ejecutivo](#resumen-ejecutivo)
- [Contexto y problemas identificados](#contexto-y-problemas-identificados)
- [Decisión tomada](#decisi%C3%B3n-tomada)
- [Alternativas consideradas](#alternativas-consideradas)
- [Justificación técnica (Rationale)](#justificaci%C3%B3n-t%C3%A9cnica-rationale)
- [Consecuencias e impacto](#consecuencias-e-impacto)
- [Plan de migración](#plan-de-migraci%C3%B3n)
- [Plan de rollback](#plan-de-rollback)
- [Verificación y métricas](#verificaci%C3%B3n-y-m%C3%A9tricas)
- [Tareas pendientes](#tareas-pendientes)
- [Referencias](#referencias)
- [Apéndices (SQL)](#ap%C3%A9ndices-sql)
- [Changelog](#changelog)

---

## Resumen ejecutivo

Se realizó una refactorización y corrección del esquema PostgreSQL de la plataforma (aerolínea). El objetivo fue resolver fallos de creación del DDL, garantizar unicidad correcta de documentos, optimizar consultas críticas (p. ej. niveles de fidelidad), corregir huecos del modelo de negocio (infantes, direcciones, asignación de puertas) y añadir índices estratégicos.

El cambio incluye: creación de entidades faltantes, índices parciales para tratar NULL en unicidad, campos booleanos (`is_current`, `is_primary`) con índices parciales, nuevas relaciones (direcciones, asignación de puertas, tutores) y documentación ampliada del esquema.

---

## Contexto y problemas identificados

- Script DDL fallaba por tablas faltantes (`continent`, `country`, `time_zone`, `state_province`) — Impacto: crítico.
- Constraint `UNIQUE` en `person_document` permitía duplicados cuando `issuing_country_id IS NULL` — Impacto: crítico.
- Consultas de fidelización requerían `ORDER BY ... LIMIT 1`, escalabilidad pobre — Impacto: alto.
- `INFANT` sin vínculo a adulto responsable; `person` sin relación con `address`; puerta de embarque registrada solo al escaneo — Impacto: alto.
- Claves foráneas de alto tráfico sin índices — Impacto: medio.
- Documentación incompleta (5/65 tablas documentadas) — Impacto: medio.

---

## Decisión tomada

Se aplicaron las siguientes decisiones principales:

- D1 — Crear las entidades faltantes: `continent`, `country`, `time_zone`, `state_province`. Añadir `CHECK` en `time_zone.utc_offset_minutes`.
- D2 — Reemplazar el `UNIQUE` problemático por dos índices parciales en `person_document` (uno para filas con `issuing_country_id IS NOT NULL` y otro para `IS NULL`).
- D3 — Añadir campos `is_current` (en `loyalty_account_tier`) e `is_primary` (en `person_contact`) con índices parciales únicos para acceder al registro "activo" sin ordenar historial.
- D4 — Modelar reglas de negocio: `person_address` (1:N), `flight_gate_assignment` (desacoplar puertas de escaneo), `guardian_passenger_id` (autorreferencial en `reservation_passenger`) y `fare_id` en `ticket_segment` como nullable para retrocompatibilidad.
- D5 — Añadir índices en FKs de alto tráfico, ajustar tipos (p. ej. `gender_code` a `char(1)`), normalizar nombres de constraints y documentar todas las tablas.

---

## Alternativas consideradas

- Mantener `UNIQUE` original: descartada (no resuelve NULL != NULL en PostgreSQL).
- Forzar `issuing_country_id` NOT NULL con valor por defecto "unknown": descartada (contamina semántica de datos).
- Usar trigger para validar unicidad: descartada por complejidad y menor rendimiento frente a índices parciales.
- Desnormalizar a tabla de "documentos únicos": descartada por sobrecarga de sincronización.

Decisión final: índices parciales (solución estándar en PostgreSQL para este patrón).

---

## Justificación técnica (Rationale)

- Integridad: mover validaciones críticas al motor (índices/constraints) reduce surface de errores en capas superiores.
- Rendimiento: índices parciales y `is_current` permiten index scans en consultas de alta frecuencia y evitan full table scans y ordenamientos costosos.
- Operacional: el modelo refleja flujos reales (tutores, direcciones, asignación anticipada de puertas) evitando workarounds en código.

---

## Consecuencias e impacto

### Positivas

- Script DDL ejecutable y estable.
- Unicidad de documentos garantizada.
- Consultas críticas (nivel de fidelidad, contacto principal) pasan a ser O(1) por índice parcial.
- Modelo de negocio reflejado en esquema (mejor trazabilidad).

### Trade-offs / Riesgos

- Escritura: mayor overhead en INSERT/UPDATE por índices adicionales (trade-off aceptado).
- `is_current` requiere transacciones atómicas (UPDATE previous=false + INSERT new=true) en la capa de aplicación; falta automatización en BD (trigger) por compatibilidad migratoria.
- `fare_id` nullable obliga a usar `LEFT JOIN` en consultas que lo crucen; riesgo de exclusión si se usan `INNER JOIN` por descuido.
- Validaciones del `guardian_passenger_id` quedan en la aplicación (posibilidad de inconsistencias si la capa de negocio falla).

---

## Plan de migración

Antes de aplicar en producción: crear backups y snapshots, pruebas en staging con dataset representativo.

Pasos sugeridos:

1. Crear backup completo y snapshot de la BD.
2. Aplicar DDL de creación de entidades faltantes (sin índices pesados al inicio si se planifica bulk load).
3. Ejecutar scripts de carga incremental para tablas nuevas (`continent`, `country`, `time_zone`, `state_province`).
4. Crear índices parciales para `person_document` y añadir `is_current`/`is_primary` con valores por defecto `false`.
5. Migrar datos históricos: mapear direcciones a `person_address`, poblar `guardian_passenger_id` donde aplique y revisar `fare_id` NULLs.
6. Ejecutar pruebas de regresión y carga (pre/post índices) en staging y ajustar strategía de bulk-load (disable/enable indexes si necesario).
7. Desplegar cambios en ventana de mantenimiento con monitorización activa y plan de rollback listo.

---

## Plan de rollback

Si se detectan problemas críticos tras el despliegue:

- Restaurar snapshot previo (si el cambio afectó integridad de datos) — paso seguro pero costoso.
- Alternativa de rollback gradual: deshabilitar índices añadidos y revertir DDL no destructivo; volver a la versión anterior del esquema si es posible.
- Mantener scripts de reversión para cada paso de migración y probarlos en staging antes de producción.

---

## Verificación y métricas

KPIs y checks recomendados:

- Latencia promedio de consultas: `loyalty_account_tier` (antes vs después).
- Porcentaje de consultas que usan index scan vs seq scan en `EXPLAIN`.
- Tasa de errores transaccionales relacionados con `is_current` (alertas si > 0.1%).
- Impacto en latencia de escritura durante ingestas masivas.
- Auditoría de `person_document` para detectar duplicados residuales.

---

## Tareas pendientes

| ID | Tarea | Responsable | Prioridad |
|---:|---|---|---|
| 1 | Implementar triggers/ stored procedures para atomicidad de `is_current` | Backend / DBA | Alta |
| 2 | Script de migración para `person_address` y `guardian_passenger_id` | DBA | Alta |
| 3 | Revisar queries que JOIN con `ticket_segment` y `fare` (LEFT JOIN) | Backend | Media |
| 4 | Load testing y validación de índices | DevOps / DBA | Media |
| 5 | Documentar `rate_source` y valores permitidos | Data Team | Baja |

---

## Referencias

- Respaldo del original: `ADR.original.md`
- Scripts DDL (carpeta /sql/ddl/) — (referenciar si existe en repo)
- Diagrama ER (si aplica) — añadir enlace/imagen

---

## Apéndices (SQL)

### Índices parciales para `person_document`

```sql
-- Índice para registros con país emisor especificado
CREATE UNIQUE INDEX uq_person_document_with_country
  ON person_document (document_type_id, issuing_country_id, document_number)
  WHERE issuing_country_id IS NOT NULL;

-- Índice para registros sin país emisor
CREATE UNIQUE INDEX uq_person_document_no_country
  ON person_document (document_type_id, document_number)
  WHERE issuing_country_id IS NULL;
```

### Patrón `is_current` (ejemplo `loyalty_account_tier`)

```sql
ALTER TABLE loyalty_account_tier ADD COLUMN is_current BOOLEAN DEFAULT FALSE;
CREATE UNIQUE INDEX uq_loyalty_account_tier_current
  ON loyalty_account_tier (loyalty_account_id)
  WHERE is_current = true;
```

### CHECK para `time_zone.utc_offset_minutes` (ejemplo)

```sql
-- Rango válido: [-12:00, +14:00] => [-720, +840] minutos
ALTER TABLE time_zone ADD CONSTRAINT chk_time_zone_utc_offset
  CHECK (utc_offset_minutes BETWEEN -720 AND 840);
```

---

## Changelog

- 2026-04-13 — v1.0 — Versión inicial reescrita y estructurada. Autor: Freinier Steven Cardona Pérez.

---

*Nota:* Esta versión está generada para revisión. Si confirmas, puedo crear un PR o dejarlo tal cual (ya existe un respaldo `ADR.original.md`).
