# Módulo Disponibilidad Académica
## Documento de Análisis Técnico y Arquitectónico

---

### 1. Introducción
El presente documento expone el análisis técnico, funcional y arquitectónico de la propuesta para incorporar el **Módulo de Disponibilidad Académica** como un componente independiente dentro del **Sistema de Gestión de Horarios SENA**. El objetivo de este sistema es centralizar, optimizar y validar la programación de la oferta educativa institucional, garantizando la convergencia sin conflictos de tres pilares operativos: Instructores, Ambientes de Formación y Fichas.

A través de un enfoque basado en Arquitectura Empresarial y Diseño Guiado por el Dominio (DDD), este informe evalúa la viabilidad, pertinencia y estructura de aislar las precondiciones temporales y operativas del proceso definitivo de asignación de horarios.

---

### 2. Contexto dentro del Sistema de Gestión de Horarios SENA
El Servicio Nacional de Aprendizaje (SENA) opera bajo un modelo de formación profesional integral altamente dinámico. La institución coordina múltiples jornadas (diurna, nocturna, mixta, madrugadas), tipologías de instructores (planta, contratistas) y recursos físicos compartidos (laboratorios especializados, ambientes polivalentes). 

En el ecosistema del sistema, coexisten módulos core ya definidos:
* **Actores:** Administra las hojas de vida, vinculaciones y perfiles de los instructores.
* **Infraestructura y Ambientes:** Gestiona las sedes, laboratorios, aulas y su capacidad física.
* **Oferta y Programas / Fichas:** Estructura las cohortes de aprendices que demandan formación en tiempos específicos.
* **Horarios:** Módulo encargado de la consolidación final de la grilla horaria institucional (quién, dónde y cuándo).

El módulo propuesto de **Disponibilidad Académica** se sitúa en la capa intermedia de este ecosistema, actuando como un validador predictivo y un unificador de restricciones previas a la persistencia de un horario.

---

### 3. Problema Identificado
Actualmente, el proceso de recolección y control de las condiciones previas a la programación sufre de tres deficiencias estructurales:

1.  **Sobrecarga de Responsabilidades en "Horarios":** El módulo de Horarios no solo debe resolver la asignación espacial y temporal, sino que absorbe la lógica de validar si el instructor está contratado para esa jornada, si el ambiente está reservado para mantenimientos, o si la ficha dispone de franjas libres. Esto genera un algoritmo de asignación altamente complejo, propenso a errores y costoso de mantener computationalmente.
2.  **Dispersión de Reglas de Negocio:** Las restricciones de tiempo de los instructores (por ejemplo, limitaciones de ley en contratistas o jornadas máximas) terminan acopladas a la gestión de datos básicos de los usuarios en el módulo *Actores*, o dispersas en hojas de cálculo externas.
3.  **Conflictos de Concurrencia en Tiempo de Diseño:** Al no existir una abstracción que centralice los "bloqueos" o "ventanas de tiempo viables", el sistema solo detecta colisiones *post-facto* (cuando el coordinador intenta guardar el horario), elevando el reproceso y la fricción operativa.

---

### 4. Origen de la Propuesta
Durante la fase de diseño arquitectónico, se observó que la programación académica no es un evento de un solo paso, sino el resultado de un flujo de preparación. La propuesta de segregar la **Disponibilidad Académica** surge de la necesidad de aplicar el principio de *Separación de Responsabilidades (Separation of Concerns)*. 

Se detectó que la "Disponibilidad" posee un ciclo de vida propio: se parametriza al inicio de un trimestre o semestre, es sujeta a concertación y bloqueos institucionales (como comités pedagógicos o mantenimientos preventivos), y se estabiliza *antes* de que el coordinador académico empiece a arrastrar componentes en una grilla horaria.

---

### 5. Objetivo del Módulo
El Módulo de Disponibilidad Académica tiene como objetivo principal **abstraer, centralizar y resolver de manera anticipada el espacio-tiempo hábil** de los recursos institucionales (Instructores, Ambientes y Fichas), proveyendo una capa de servicios de validación deterministas que impidan la generación de conflictos antes de que ocurran en el módulo de Horarios.

---

### 6. Responsabilidades Funcionales
El módulo propuesto asume las siguientes responsabilidades específicas:

* **Gestión de Franjas de Disponibilidad de Instructores:** Registrar y administrar las ventanas horarias y jornadas semanales en las que un instructor puede impartir formación, respetando su tipo de vinculación.
* **Bloqueos Operativos de Ambientes:** Registrar indisponibilidades técnicas de la infraestructura, tales como mantenimientos, contingencias, eventos institucionales o uso compartido con otras sedes.
* **Restricciones Temporales de Fichas:** Mapear las jornadas oficiales asignadas a las fichas de caracterización para asegurar que no se programen sesiones fuera de sus límites aprobados.
* **Cálculo de Capacidad de Asignación (Contadores/Topes):** Controlar que a un instructor no se le asigne una carga horaria superior a la establecida en su contrato o plan de trabajo concertado para el periodo actual.
* **Provisión de API Interna de Consulta:** Exponer servicios rápidos de verificación de disponibilidad espacial y temporal para consumo exclusivo del módulo de Horarios.

---

### 7. Relación con los Módulos Existentes
El módulo de Disponibilidad Académica no almacena datos maestros; actúa como un pivote relacional de restricciones temporales entre los siguientes módulos:

```
+-----------------------------------------------------------+
|                      SISTEMA CORE                         |
+-----------------------------------------------------------+
       |                      |                       |
       v                      v                       v
+--------------+      +----------------+      +---------------+
|   ACTORES    |      | INFRAESTRUCTURA|      |   OFERTA Y    |
| (Instructor) |      |   (Ambiente)   |      |  PROG. (Ficha)|
+--------------+      +----------------+      +---------------+
       |                      |                       |
       +------------+         |         +-------------+
                    |         |         |
                    v         v         v
              +-------------------------------+
              |   DISPONIBILIDAD ACADÉMICA    |
              | (Restricciones y Validaciones)|
              +-------------------------------+
                              |
                              | (Provee matrices de tiempo libre)
                              v
                      +---------------+
                      |   HORARIOS    |
                      | (Asignación)  |
                      +---------------+
```

* **Con Actores:** Consume las identidades y tipologías de los instructores para aplicar topes de horas, y asocia a cada ID su matriz horaria permitida.
* **Con Infraestructura y Ambientes:** Vincula el ID del ambiente físico con excepciones de calendario (bloqueos por mantenimiento o desastres).
* **Con Oferta y Programas / Programas de Formación:** Lee la jornada asignada a la Ficha para delimitar su matriz de disponibilidad por defecto.
* **Con Horarios:** Actúa como un proveedor de servicios (*Upstream*). Horarios consulta a Disponibilidad si un slot `(Fecha, Hora, ID_Recurso)` está libre antes de confirmar una transacción de reserva de horario.

---

### 8. Flujo Operativo
El comportamiento del módulo dentro del ciclo de vida de la programación sigue la siguiente secuencia temporal:

1.  **Fase de Configuración Inicial (Pre-programación):**
    * El Administrador o Coordinador define el Periodo Académico.
    * Se heredan los límites de las Fichas desde la Oferta.
    * Los Instructores registran o se les asigna su disponibilidad horaria base según su contrato.
    * El área de Bienestar o Infraestructura registra los bloqueos programados de los ambientes.
2.  **Fase de Consolidación:**
    * El módulo procesa los datos y genera la **Matriz de Aptitud Operativa** (slots libres cruzados).
3.  **Fase de Consumo en Tiempo Real (Programación activa):**
    * El Coordinador Académico interactúa con el módulo *Horarios*.
    * Por cada asignación intentada, *Horarios* invoca al validador de *Disponibilidad Académica*.
    * Si la respuesta es exitosa, se guarda el registro de horario y se actualiza el contador de capacidad consumida de la disponibilidad.

---

### 9. Entidades Propuestas
Para evitar la sobreingeniería, se propone un modelo relacional normalizado compuesto únicamente por **cuatro (4) entidades esenciales**. Este esquema se modela a nivel conceptual para base de datos PostgreSQL.

#### Entidad 1: Periodo_Disponibilidad
* **Propósito:** Definir el marco temporal de vigencia de las reglas de disponibilidad (ej. Primer Trimestre 2026).
* **Responsabilidad:** Controlar las fechas de inicio y fin del ciclo para evitar que restricciones pasadas afecten planificaciones futuras.
* **Campos Clave:** `id_periodo` (PK), `nombre_periodo`, `fecha_inicio`, `fecha_fin`, `estado` (Activo/Inactivo).
* **Relación con otros módulos:** Ninguna directa, es un parámetro local del ciclo de gestión.

#### Entidad 2: Disponibilidad_Instructor
* **Propósito:** Registrar los bloques de tiempo pactados en los que el instructor puede dictar formación.
* **Responsabilidad:** Validar las ventanas horarias permitidas y el tope de horas semanales/mensuales asignables.
* **Campos Clave:** `id_disp_instructor` (PK), `id_instructor` (FK hacia Actores), `id_periodo` (FK), `dia_semana` (1-7), `hora_inicio`, `hora_fin`, `horas_maximas_semanales`, `horas_asignadas_actuales`.
* **Relación con otros módulos:** Relación externa mediante `id_instructor` con el módulo **Actores**.

#### Entidad 3: Restriccion_Ambiente
* **Propósito:** Almacenar los periodos de tiempo en los cuales un ambiente físico no está apto para recibir sesiones de formación.
* **Responsabilidad:** Excluir proactivamente los ambientes del pool utilizable por motivos de mantenimiento o reservas administrativas.
* **Campos Clave:** `id_restriccion_ambiente` (PK), `id_ambiente` (FK hacia Infraestructura), `id_periodo` (FK), `fecha_indisponibilidad`, `hora_inicio`, `hora_fin`, `motivo_bloqueo`.
* **Relación con otros módulos:** Relación externa mediante `id_ambiente` con el módulo **Infraestructura y Ambientes**.

#### Entidad 4: Restriccion_Ficha
* **Propósito:** Salvaguardar la concordancia horaria de los grupos de aprendices según su jornada matriculada.
* **Responsabilidad:** Impedir que una ficha con jornada nocturna reciba programación en la mañana o viceversa.
* **Campos Clave:** `id_restriccion_ficha` (PK), `id_ficha` (FK hacia Oferta), `id_periodo` (FK), `dia_semana`, `hora_inicio_permitida`, `hora_fin_permitida`.
* **Relación con otros módulos:** Relación externa mediante `id_ficha` con el módulo **Oferta y Programas**.

---

### 10. Reglas de Negocio (Business Rules)
El módulo encapsula y gobierna de manera estricta las siguientes reglas operacionales del SENA:

* **BR-DISP-001 (Control de Carga Máxima):** La sumatoria de las horas asignadas en el módulo de *Horarios* a un instructor con contrato de prestación de servicios no podrá exceder el valor del campo `horas_maximas_semanales` configurado en su disponibilidad.
* **BR-DISP-002 (Exclusividad de Franja Temporal):** Un instructor no puede tener registros de disponibilidad superpuestos en el mismo día y rango horario dentro de un mismo periodo.
* **BR-DISP-003 (Prevalencia de Bloqueo de Ambiente):** Si existe un registro en `Restriccion_Ambiente` para un rango `X`, cualquier intento de asignación horaria en ese ambiente durante dicho rango debe ser rechazado automáticamente con código de excepción.
* **BR-DISP-004 (Límite de Jornada de Ficha):** Las asignaciones de horario ligadas a una Ficha específica deben estar contenidas estrictamente dentro del intervalo establecido por los campos `hora_inicio_permitida` y `hora_fin_permitida` de la entidad `Restriccion_Ficha`.

---

### 11. Beneficios Funcionales
La existencia autónoma del módulo provee claras ventajas operativas directas a los usuarios del sistema:

* **Mitigación de Errores Humanos en Cascada:** Al limpiar las opciones de asignación antes de pintar la pantalla de horarios, el coordinador solo visualiza elementos que *efectivamente* están libres y aptos, reduciendo drásticamente la tasa de error manual.
* **Transparencia en la Concertación de Disponibilidades:** Permite una etapa de auditoría previa donde los instructores validan sus horarios hábiles y cargues máximos antes de iniciar el proceso estresante de armado de la grilla horaria.
* **Flexibilidad ante Contingencias:** Ante una eventualidad física en un ambiente (ej. daño eléctrico en un laboratorio de soldadura), se genera una restricción temporal en este módulo y de inmediato el sistema alerta y congela las asignaciones de ese espacio en Horarios, sin necesidad de alterar los metadatos maestros del ambiente.

---

### 12. Beneficios Arquitectónicos
Desde la perspectiva de la ingeniería de software y la calidad sistémica:

* **Alta Cohesión Funcional:** El módulo tiene un único motivo para cambiar: las políticas, contratos o lógicas de asignación de tiempos y disponibilidad previa en la institución.
* **Bajo Acoplamiento Aferente/Eferente:** Evita que el módulo *Horarios* se conecte directamente a los esquemas internos de contratos de *Actores* o planes de mantenimiento de *Infraestructura*. Horarios solo habla con la interfaz simplificada de *Disponibilidad*.
* **Optimización del Rendimiento en Consultas (Performance):** Las consultas de validación en tiempo real de horarios se ejecutan sobre tablas dinámicas optimizadas de disponibilidad (booleanos/rangos), en lugar de realizar complejos `JOINs` multi-módulo que degradarían la base de datos relacional.
* **Separación de Ciclos de Vida:** Permite desplegar actualizaciones en las reglas de negocio de disponibilidad (por ejemplo, cambios normativos en el tope de horas de instructores) sin afectar, compilar o detener el motor de persistencia de Horarios.

---

### 13. Riesgos y Consideraciones

#### Si NO se implementa el módulo como un componente independiente:
* **Degradación del Código (Monolito de Lógica):** El módulo de Horarios se convertirá en un componente hipertrofiado de código, difícil de testear mediante pruebas unitarias debido a la cantidad masiva de variables externas que tendría que validar concurrentemente.
* **Inconsistencia de Datos:** Reglas de validación idénticas tendrían que duplicarse en pantallas de visualización de instructores y en procesos de generación de reportes, provocando desincronización si una regla cambia.

#### Si se implementa INCORRECTAMENTE (Mal diseño):
* **Problemas de Sincronización Temporal (Latencia):** Si el módulo de Disponibilidad realiza consultas lentas en tiempo real a los otros módulos mediante llamadas de red pesadas, bloqueará la interfaz del usuario en el armado de horarios, causando una experiencia lenta y frustrante.
* **Acoplamiento Circular:** Un error crítico sería permitir que *Disponibilidad* dependa directamente de los datos internos de las asignaciones de *Horarios* de forma bidireccional, rompiendo la jerarquía de capas arquitectónicas y provocando bloqueos de base de datos (*deadlocks*).

---

### 14. Evaluación de Viabilidad
Aplicando los criterios de Arquitectura de Software y análisis de dominios:

| Criterio | Evaluación | Justificación Técnica |
| :--- | :--- | :--- |
| **Identidad de Dominio** | **Alta** | La "Disponibilidad" no es un atributo pasivo de un usuario o un aula. Posee un estado mutable (Abierto, Bloqueado, Agotado), un ciclo de vida temporal (trimestral) y responde a reglas de negocio de contratación estatal. |
| **Complejidad Algorítmica** | **Medio-Alta** | Resolver colisiones de tres dimensiones (Persona, Espacio, Tiempo) requiere un aislamiento lógico claro para permitir optimizaciones de indexación temporal en la base de datos. |
| **Frecuencia de Cambio** | **Alta** | Las reglas de disponibilidad y asignación de franjas varían significativamente entre centros de formación y vigencias presupuestales, requiriendo un aislamiento que dote al sistema de adaptabilidad. |

---

### 15. Conclusiones
El análisis evidencia que las responsabilidades agrupadas bajo el concepto de **Disponibilidad Académica** trascienden la simple categorización de "datos de soporte". No constituyen una funcionalidad secundaria que deba diluirse dentro de la gestión de Horarios, ni son metadatos planos que pertenezcan conceptualmente a las hojas de vida de los Instructores o a la ficha técnica de los Ambientes.

La correcta estructuración de este sistema demanda que el proceso de control de precondiciones y restricciones de tiempo cuente con un límite de contexto claro (*Bounded Context*), garantizando la mantenibilidad, escalabilidad de las reglas de negocio y un rendimiento óptimo de las consultas concurrentes.

---

### 16. Recomendación Arquitectónica Final

**Dictamen:** **APROBADO** para existir como un módulo independiente.

#### Lineamientos estratégicos para su desarrollo:
1.  **Modelo de Datos Segregado:** Implementar las cuatro entidades propuestas (`Periodo_Disponibilidad`, `Disponibilidad_Instructor`, `Restriccion_Ambiente`, `Restriccion_Ficha`) en un esquema lógico claramente diferenciado dentro de la base de datos PostgreSQL.
2.  **Direccionalidad del Acoplamiento:** Asegurar que el módulo de *Disponibilidad Académica* sea aguas arriba (*Upstream*) de *Horarios*. El módulo de *Horarios* puede conocer y consumir los servicios de disponibilidad, pero *Disponibilidad Académica* jamás debe conocer las tablas o lógica interna de la asignación final de horarios.
3.  **Patrón de Validación Eficiente:** Diseñar el módulo para que exponga un servicio optimizado que reciba un lote de consultas de disponibilidad y retorne matrices binarias (disponible/no disponible), protegiendo la UI del coordinador académico durante el proceso de arrastre y asignación de horarios en tiempo real.