# Módulo 8 — Infraestructura: Ambientes e Inventario
## Sistema de Horarios SENA

> **Versión refactorizada** con enfoque institucional, académico y de trazabilidad  
> Punto 3 del análisis grupal — Infraestructura - Ambientes

---

## Objetivo General

Gestionar los ambientes de formación del SENA, controlar su disponibilidad, administrar el inventario asociado, registrar horarios de ocupación, realizar seguimiento a incidencias y generar reportes para garantizar una correcta operación académica.

---

## ¿Qué es el Módulo de Ambientes?

Es el módulo encargado de administrar **todos los espacios físicos** donde se realizan las actividades de formación en el SENA. Permite saber en todo momento qué ambientes existen, qué recursos tienen, quién los usa y en qué estado se encuentran.

Ejemplos de ambientes administrados:
- Sala de Sistemas 301
- Laboratorio de Redes
- Taller de Electrónica
- Aula Virtual
- Auditorio
- Laboratorio de Química

---

## Estructura del Módulo (6 submódulos)

El módulo se organiza en seis componentes funcionales que trabajan de manera integrada:

---

### Módulo 1 — Gestión de Ambientes

**Objetivo:** Administrar todos los espacios físicos del SENA con su información básica.

#### Datos principales del ambiente

| Campo | Descripción |
|---|---|
| Código del ambiente | Identificador único del espacio |
| Nombre del ambiente | Nombre descriptivo oficial |
| Tipo de ambiente | Sala de sistemas, taller, laboratorio, aula, etc. |
| Sede | Sede SENA a la que pertenece |
| Centro de formación | Centro al que está adscrito |
| Bloque | Bloque físico del edificio |
| Piso | Nivel del piso donde se ubica |
| Capacidad máxima | Número máximo de aprendices |
| Descripción | Información adicional del espacio |

#### Ejemplo de registro

```
Código:       ADSI-301
Nombre:       Sala de Sistemas 301
Tipo:         Sala de Sistemas
Sede:         Sede Norte
Centro:       Centro de Tecnología
Bloque:       B
Piso:         3
Capacidad:    35 aprendices
```

---

### Módulo 2 — Estados y Disponibilidad de Ambientes

**Objetivo:** Conocer la situación actual de cada ambiente en tiempo real.

#### Estados definidos

| Estado | Descripción |
|---|---|
| **Disponible** | Puede ser asignado para una clase |
| **Ocupado** | Tiene una clase programada actualmente |
| **En mantenimiento** | Se encuentra en reparación o limpieza |
| **Reservado** | Apartado para un evento o actividad especial |
| **Fuera de servicio** | No puede utilizarse por daño grave |
| **Suspendido** | Bloqueado temporalmente por decisión administrativa |

#### Beneficios del control de estados

- Evita **conflictos de programación** (doble asignación).
- Evita asignar **salones dañados** o no aptos.
- Facilita la **planeación académica** por parte de coordinación.
- Apoya el **Motor de Horarios** (Módulo 11) para validar cruces.

---

### Módulo 3 — Inventario por Ambiente

**Objetivo:** Controlar todos los recursos disponibles en cada ambiente.

#### Información del inventario

| Campo | Descripción |
|---|---|
| Código del recurso | Identificador único del elemento |
| Nombre del recurso | Nombre del equipo o mueble |
| Categoría | Hardware, mobiliario, audiovisual, herramienta, etc. |
| Marca | Fabricante del recurso |
| Serial | Número de serie del equipo |
| Cantidad | Número de unidades disponibles |
| Estado | Condición actual del recurso |
| Fecha de adquisición | Fecha de compra o ingreso al inventario |

#### Estados de recursos

| Estado | Significado |
|---|---|
| Disponible | Listo para uso normal |
| En uso | Siendo utilizado en una clase activa |
| En mantenimiento | En reparación temporal |
| Dañado | Con falla que impide su uso |
| Perdido | No se encuentra físicamente |
| Dado de baja | Retirado del inventario definitivamente |

#### Ejemplo — Sala de Sistemas 301

| Recurso | Cantidad | Estado |
|---|---|---|
| Computadores Dell | 35 | Disponible |
| Video Beam | 1 | Disponible |
| Sillas | 35 | Disponible |
| Mesas | 35 | Disponible |
| Router | 1 | Disponible |

---

### Módulo 4 — Programación y Ocupación Horaria

**Objetivo:** Controlar cuándo un ambiente está ocupado, con qué grupo y a cargo de quién.

#### Datos del registro de ocupación

| Campo | Descripción |
|---|---|
| Fecha | Día de la programación |
| Hora inicio | Hora de inicio de la clase |
| Hora fin | Hora de finalización |
| Instructor asignado | Nombre del instructor responsable |
| Ficha asignada | Número de ficha del grupo de aprendices |
| Programa de formación | Nombre del programa académico |

#### Ejemplo de ocupación — Sala de Sistemas 301

| Ambiente | Fecha | Hora Inicio | Hora Fin | Instructor | Ficha |
|---|---|---|---|---|---|
| Sala 301 | 15/06/2026 | 07:00 AM | 11:00 AM | Carlos Pérez | 2892341 |
| Sala 301 | 15/06/2026 | 02:00 PM | 06:00 PM | Ana Torres | 2871055 |

#### Consulta esperada

Al seleccionar un ambiente, el sistema debe mostrar:
- Fecha ocupada
- Hora de inicio y hora final
- Instructor responsable
- Ficha asignada
- Estado actual del ambiente

---

### Módulo 5 — Incidencias y Mantenimiento

**Objetivo:** Registrar novedades de infraestructura que afecten el normal funcionamiento de los ambientes.

#### Ejemplos de incidencias

- Computador dañado
- Proyector averiado
- Aire acondicionado dañado
- Sillas deterioradas
- Falla en la red eléctrica
- Daño en la conectividad de red

#### Información registrada en la incidencia

| Campo | Descripción |
|---|---|
| Fecha | Fecha en que se reporta la novedad |
| Responsable | Persona que reporta o gestiona |
| Tipo de incidencia | Categoría del problema (eléctrico, tecnológico, mobiliario, etc.) |
| Descripción | Detalle del problema encontrado |
| Estado de solución | Estado actual de la gestión |

#### Estados de incidencia

| Estado | Descripción |
|---|---|
| **Reportada** | Se acaba de registrar la novedad |
| **En proceso** | En gestión o reparación activa |
| **Solucionada** | El problema fue resuelto |
| **Cerrada** | Verificada y cerrada formalmente |

> Las incidencias se conectan con el **Módulo 12 — Observaciones e Incidencias** del sistema general para seguimiento y trazabilidad institucional.

---

### Módulo 6 — Reportes y Trazabilidad

**Objetivo:** Generar información útil para la toma de decisiones académicas y administrativas.

#### Reportes disponibles

| Reporte | Utilidad |
|---|---|
| Ambientes más utilizados | Identifica los espacios con mayor demanda |
| Ambientes disponibles | Facilita la asignación rápida de espacios |
| Inventario por sede | Visión consolidada de recursos por sede |
| Equipos dañados | Prioriza gestión de mantenimiento |
| Historial de uso | Audita qué grupos usaron cada ambiente |
| Costos de mantenimiento | Apoya decisiones presupuestales |

#### Trazabilidad del sistema

El módulo permite responder las siguientes preguntas:

- **¿Quién** utilizó el ambiente?
- **¿Cuándo** fue utilizado?
- **¿Qué recursos** se usaron?
- **¿Qué cambios** se realizaron al inventario?
- **¿Qué incidencias** ocurrieron en el ambiente?

---

## Relación con Otros Módulos del Sistema

El Módulo de Ambientes se conecta con los siguientes módulos del Sistema de Horarios SENA:

| Módulo | Nombre | Relación |
|---|---|---|
| **7** | Instructores | Saber en qué ambiente imparte clase cada instructor |
| **9** | Fichas y Franjas Horarias | Asignar un ambiente a cada bloque horario de una ficha |
| **11** | Motor de Horarios | Validar disponibilidad sin cruces de ocupación |
| **12** | Observaciones e Incidencias | Reportar daños o novedades de recursos e infraestructura |

---

## Funcionalidades Clave del Módulo

1. **Registro de ambientes** — Crear y mantener la ficha de cada espacio físico.
2. **Consulta de disponibilidad** — Ver en tiempo real qué ambientes están libres.
3. **Control de estados** — Gestionar el ciclo de vida de cada ambiente.
4. **Inventario detallado** — Asociar recursos a cada ambiente con su estado.
5. **Visualización de horarios** — Ver fecha y hora de ocupación por ambiente.
6. **Registro de incidencias** — Documentar novedades y daños.
7. **Gestión de mantenimientos** — Seguimiento al ciclo de reparación.
8. **Reportes estadísticos** — Información consolidada para decisiones.
9. **Historial y trazabilidad completa** — Auditoría de todo lo que ocurre en un ambiente.

---

## Problemas que Previene este Módulo

| Problema | Cómo lo previene |
|---|---|
| Doble asignación de ambientes | Control de estados y validación en el Motor de Horarios |
| Pérdida de equipos | Inventario con serial y seguimiento de estados |
| Sobreocupación de salones | Capacidad máxima registrada y visible |
| Falta de recursos en clases | Inventario actualizado por ambiente |
| Asignación de salones dañados | Estado "Fuera de servicio" o "En mantenimiento" |
| Falta de trazabilidad | Historial completo de uso, cambios e incidencias |

---

## Resumen para Exposición

> El **Módulo de Infraestructura y Ambientes** administra todos los espacios físicos del SENA y el inventario de recursos disponibles en cada uno. Permite registrar aulas, laboratorios y talleres; controlar su capacidad y disponibilidad en tiempo real; llevar el inventario de equipos con su estado; registrar la programación de clases por horario; gestionar incidencias y mantenimientos; y generar reportes para apoyar la programación académica. Todo esto garantiza que los ambientes cuenten con los recursos necesarios para la formación y que no existan conflictos en su asignación.

---

*Propuesta funcional — Sistema de Horarios SENA | MVP + Escalamiento Institucional*  
*Incluye estructura institucional SENA, oferta académica y trazabilidad de proyectos formativos*

















