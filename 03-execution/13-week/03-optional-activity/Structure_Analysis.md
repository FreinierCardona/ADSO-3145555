# Reestructuración del Repositorio Documental
## Sistema de Gestión de Horarios Académicos — SENA
 
---
 
| Campo | Detalle |
|---|---|
| **Fecha** | 19 de mayo de 2025 |
| **Autores** | Freinier Cardona / Santiago Gordo |
| **Sistema** | Sistema de Gestión de Horarios SENA |
| **Fase del proyecto** | Análisis, elección de arquitectura y organización inicial |
| **Tipo de documento** | Registro de decisiones organizacionales — Repositorio documental |
 
---
 
## Introducción
 
Este documento registra los cambios realizados sobre la estructura base del repositorio documental del proyecto, junto con la justificación de cada decisión tomada.
 
El repositorio documental es el lugar donde vive toda la documentación técnica y funcional del sistema: arquitectura, requerimientos, decisiones, estándares, manuales y más. Está pensado para que cualquier miembro del equipo, en cualquier momento, pueda encontrar la información que necesita sin depender de otra persona.
 
Los cambios descritos aquí responden a tres factores concretos del proyecto:
 
- La arquitectura confirmada es de **microservicios**.
- El equipo de desarrollo tiene entre **18 y 24 personas**.
- El **stack tecnológico y la herramienta ágil** aún no han sido decididos.
Cada cambio listado en este documento tiene una razón puntual. Nada fue modificado por estética o preferencia personal.
 
---
 
## Contexto de la Estructura Original
 
La estructura original contaba con 15 secciones numeradas dentro de `docs/`, carpetas de plantillas (`templates/`), recursos (`assets/`) y herramientas de automatización (`tools/`). Era una base sólida y profesional, pero tenía problemas concretos que se detallan a continuación.
 
---
 
## Cambios Realizados
 
### Cambio 1 — La sección de Microservicios ahora está justificada y se refuerza
 
**¿Qué pasó?**
En el análisis se confirma que el sistema usará **arquitectura de microservicios**, esta sección no solo se mantiene, sino que se refuerza.
 
**¿Qué se agregó dentro de la sección?**
Se añade el archivo `service-owner.md` dentro de la plantilla de cada servicio.
 
**¿Por qué?**
Con un equipo de 18 a 24 personas trabajando en paralelo sobre distintos servicios, si no queda documentado explícitamente quién es el responsable de cada servicio, nadie sabe a quién preguntarle cuando algo falla o cuando se necesita tomar una decisión sobre ese componente.
 
---
 
 
### Cambio 2 — Se agregan los scripts `.sh` junto a los `.ps1` en la carpeta `tools/`
 
**¿Qué pasó?**
Los archivos `validate-docs.ps1`, `validate-links.ps1` y `generate-index.ps1` son scripts de PowerShell. Solo funcionan en Windows.
 
**¿Por qué es un problema?**
El servidor de CI/CD (GitHub Actions) corre sobre Linux. Si los scripts no funcionan en Linux, la automatización documental no puede correr en el pipeline. Además, si algún miembro del equipo usa Mac o Linux, tampoco puede ejecutarlos localmente.
 
**¿Qué se hizo?**
Se crean versiones `.sh` (para Linux, Mac y CI/CD) manteniendo las versiones `.ps1` para quienes usen Windows. Ambas versiones hacen exactamente lo mismo, solo cambia el entorno donde corren.
 
---
 
### Cambio 3 — Se agrega `risk-register.md` en la sección de contexto del proyecto
 
**¿Qué pasó?**
En la estructura original existía una plantilla de riesgos (`risk-template.md`) pero no había ningún documento activo donde se registraran y dieran seguimiento a los riesgos reales del proyecto.
 
**¿Por qué importa?**
El propio contexto del proyecto tiene suposiciones críticas explícitas, por ejemplo: *"los coordinadores van a abandonar sus hojas de cálculo"* o *"las reglas de franjas horarias son estandarizables"*. Esas suposiciones son riesgos con nombre propio. Si no se registran con responsable, probabilidad e impacto, nadie los gestiona y pueden materializarse sin aviso.
 
**¿Dónde queda?**
Dentro de `01-project-context/risk-register.md`.
 
---
 
### Cambio 4 — Se agrega `decision-log.md` en la sección de arquitectura
 
**¿Qué pasó?**
Los ADR (Architecture Decision Records) existentes son para decisiones grandes y formales de arquitectura. Pero en el día a día de un equipo de 20 personas se toman docenas de decisiones técnicas menores que no justifican un ADR completo.
 
**Ejemplo de decisión menor:** *"¿Usamos UUID o ID numérico autoincremental para las claves primarias?"*, *"¿Validamos los formularios solo en el backend o también en el frontend?"*.
 
**¿Por qué importa?**
Si estas decisiones no quedan escritas, en dos semanas nadie recuerda por qué se hizo algo de determinada manera. Eso genera debates repetidos, inconsistencias entre servicios y pérdida de tiempo.
 
**¿Dónde queda?**
Dentro de `04-architecture/decision-log.md`.
 
---
 
### Cambio 5 — Se agrega `developer-setup.md` en la sección de DevOps
 
**¿Qué pasó?**
No existía ningún documento que explicara cómo configurar el entorno local de desarrollo.
 
**¿Por qué importa?**
Con 18 a 24 personas en el equipo, alguien nuevo entra constantemente al proyecto. Sin una guía clara de configuración, esa persona pierde horas preguntándole a otros cómo instalar herramientas, qué versiones usar, cómo conectarse a la base de datos de desarrollo o cómo correr el proyecto localmente. Ese tiempo multiplicado por el tamaño del equipo es un costo real.
 
**¿Dónde queda?**
Dentro de `08-devops/developer-setup.md`.
 
---
 
### Cambio 6 — Se agrega `data-ownership.md` en la sección de arquitectura de datos
 
**¿Qué pasó?**
En la arquitectura de microservicios, una regla fundamental es que **cada servicio es dueño de sus propios datos** y no accede directamente a la base de datos de otro servicio. Si esto no queda documentado, los servicios terminan compartiendo tablas y el sistema se convierte en un monolito disfrazado.
 
**¿Por qué importa?**
Con varios equipos trabajando en paralelo, sin este documento cada equipo tomará sus propias decisiones sobre qué datos puede leer o escribir. Eso genera dependencias ocultas que son muy difíciles de eliminar después.
 
**¿Dónde queda?**
Dentro de `05-data-architecture/data-ownership.md`.
 
---
 
### Cambio 7 — Se agrega `service-communication.md` y `event-catalog.md` en arquitectura
 
**¿Qué pasó?**
No existía ningún documento que definiera cómo se comunican los servicios entre sí ni qué eventos existen en el sistema.
 
**¿Por qué importa?**
Si 5 equipos trabajan en 5 servicios distintos sin saber cómo deben hablar entre ellos, cada uno tomará sus propias decisiones. El resultado son servicios que usan diferentes patrones de comunicación, generan inconsistencias y son difíciles de mantener.
 
El catálogo de eventos (`event-catalog.md`) es especialmente importante: lista todos los eventos del sistema (quién los produce, quién los consume, qué información llevan). Sin esa lista, es imposible saber qué está pasando en el sistema cuando algo falla.
 
**¿Dónde queda?**
- `04-architecture/service-communication.md`
- `04-architecture/event-catalog.md`
---
 
### Cambio 8 — Se agrega `api-gateway.md` en el diseño de APIs
 
**¿Qué pasó?**
En microservicios existe un componente llamado API Gateway: es el punto de entrada único al sistema. Todos los clientes (el navegador web, por ejemplo) hablan con el gateway, y el gateway se encarga de enrutar cada solicitud al servicio correcto.
 
**¿Por qué importa?**
Sin documentar cómo funciona el gateway, los equipos no saben qué rutas existen, cómo se configuran, quién las mantiene ni cómo se protegen. Esto genera confusión y errores de integración.
 
**¿Dónde queda?**
Dentro de `06-api-design/api-gateway.md`.
 
---
 
### Cambio 9 — Se agrega `team-structure.md` en gobernanza
 
**¿Qué pasó?**
No existía ningún documento que registrara la estructura del equipo: quién pertenece a qué grupo, quién lidera cada área, quién es responsable de qué parte del sistema.
 
**¿Por qué importa?**
Con 18 a 24 personas, sin este documento es imposible saber a quién preguntarle sobre un servicio específico, quién aprueba qué tipo de decisiones o cómo están organizados los equipos. La falta de claridad en roles genera bloqueos y decisiones tomadas por las personas equivocadas.
 
**¿Dónde queda?**
Dentro de `00-governance/team-structure.md`.
 
---
 
### Cambio 10 — Se elimina `level-4-code.md` del modelo C4
 
**¿Qué pasó?**
El modelo C4 tiene 4 niveles de documentación de arquitectura. El nivel 4 documenta el código en detalle: clases, interfaces, métodos. Este archivo existía en la sección de arquitectura.
 
**¿Por qué se elimina?**
El nivel 4 del C4 se desactualiza cada vez que alguien cambia una línea de código. En la práctica, ese documento queda obsoleto en horas y nadie lo mantiene. Los tres primeros niveles (contexto, contenedores y componentes) son los que realmente aportan valor y son posibles de mantener durante el ciclo de vida del proyecto.
 
---
 
### Cambio 11 — Se elimina la carpeta `drawio/` de los diagramas fuente
 
**¿Qué pasó?**
La carpeta `source/drawio/` era el lugar para guardar diagramas creados con la herramienta draw.io.
 
**¿Por qué se elimina?**
Los archivos de draw.io son archivos binarios o semibinarios. Git, el sistema de control de versiones, no puede mostrar qué cambió entre una versión y otra de ese archivo. Si dos personas modifican el mismo diagrama, no hay forma de resolver el conflicto ni de ver el historial de cambios.
 
Los diagramas en PlantUML y Mermaid son texto puro: se puede ver exactamente qué línea cambió, quién lo cambió y cuándo. Se mantienen esas dos carpetas y se elimina `drawio/`.
 
> **Nota:** Si alguien del equipo usa draw.io, puede exportar sus diagramas a SVG o PNG y guardar esa versión exportada en `exported/svg/` o `exported/png/`. Lo que no debe versionarse es el archivo fuente `.drawio`.
  
---
 
## Resumen de Todos los Cambios
 
| # | Cambio | Tipo | Razón principal |
|---|---|---|---|
| 1 | Sección `12-microservices/` justificada y reforzada con `service-owner.md` | Confirmación + Adición | Arquitectura de microservicios confirmada y equipo de 20+ personas |
| 2 | Scripts duales `.sh` + `.ps1` en `tools/` | Corrección | Los `.ps1` no funcionan en CI/CD Linux ni en Mac |
| 3 | `risk-register.md` en `01-project-context/` | Adición | Los riesgos del proyecto necesitan seguimiento activo, no solo una plantilla |
| 4 | `decision-log.md` en `04-architecture/` | Adición | Las decisiones técnicas cotidianas necesitan quedar registradas |
| 5 | `developer-setup.md` en `08-devops/` | Adición | Guía de configuración esencial para un equipo de 20+ personas |
| 6 | `data-ownership.md` en `05-data-architecture/` | Adición | Cada servicio debe tener claro de qué datos es dueño |
| 7 | `service-communication.md` y `event-catalog.md` en `04-architecture/` | Adición | Define cómo hablan los servicios y qué eventos existen en el sistema |
| 8 | `api-gateway.md` en `06-api-design/` | Adición | El gateway es el punto de entrada único en microservicios y debe estar documentado |
| 9 | `team-structure.md` en `00-governance/` | Adición | Con 20+ personas es esencial saber quién es responsable de qué |
| 10 | `level-4-code.md` eliminado del modelo C4 | Eliminación | No es mantenible: se desactualiza con cada cambio de código |
| 11 | Carpeta `drawio/` eliminada de diagramas fuente | Eliminación | Archivos binarios no comparables en Git, generan conflictos irresolubles |
 
---
 
## Estructura Final del Repositorio
 
```
design-software-docs/
│
├── README.md
├── CHANGELOG.md
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
├── LICENSE
│
├── .github/
│   ├── pull_request_template.md
│   └── workflows/
│       ├── docs-lint.yml
│       └── links-check.yml
│
├── docs/
│   ├── README.md
│   │
│   ├── 00-governance/
│   │   ├── README.md
│   │   ├── repository-purpose.md
│   │   ├── documentation-rules.md
│   │   ├── naming-conventions.md
│   │   ├── folder-conventions.md
│   │   ├── versioning-rules.md
│   │   ├── review-process.md
│   │   ├── definition-of-done.md
│   │   └── team-structure.md              ← NUEVO
│   │
│   ├── 01-project-context/
│   │   ├── README.md
│   │   ├── initial-context.md
│   │   ├── problem-space.md
│   │   ├── business-objectives.md
│   │   ├── scope.md
│   │   ├── out-of-scope.md
│   │   ├── constraints.md
│   │   ├── assumptions.md
│   │   ├── glossary.md
│   │   └── risk-register.md               ← NUEVO
│   │
│   ├── 02-sena-domain/
│   │   ├── README.md
│   │   ├── domain-glossary.md
│   │   ├── institutional-concepts.md
│   │   ├── actors.md
│   │   ├── business-rules.md
│   │   ├── domain-boundaries.md
│   │   └── examples/
│   │       ├── aprendiz.md
│   │       ├── instructor.md
│   │       ├── ficha.md
│   │       ├── ambiente-formacion.md
│   │       ├── programa-formacion.md
│   │       └── horario.md
│   │
│   ├── 03-product-definition/
│   │   ├── README.md
│   │   ├── product-vision.md
│   │   ├── mvp-definition.md
│   │   ├── roadmap.md
│   │   ├── user-personas.md
│   │   ├── user-journeys.md
│   │   ├── functional-requirements.md
│   │   ├── non-functional-requirements.md
│   │   └── acceptance-criteria.md
│   │
│   ├── 04-architecture/
│   │   ├── README.md
│   │   ├── architecture-principles.md
│   │   ├── architecture-overview.md
│   │   ├── architecture-decisions-summary.md
│   │   ├── quality-attributes.md
│   │   ├── integration-strategy.md
│   │   ├── deployment-strategy.md
│   │   ├── decision-log.md                ← NUEVO
│   │   ├── service-communication.md       ← NUEVO
│   │   ├── event-catalog.md               ← NUEVO
│   │   │
│   │   ├── c4/
│   │   │   ├── README.md
│   │   │   ├── level-1-context.md
│   │   │   ├── level-2-containers.md
│   │   │   └── level-3-components.md
│   │   │   (eliminado: level-4-code.md)   ← ELIMINADO
│   │   │
│   │   ├── adr/
│   │   │   ├── README.md
│   │   │   ├── proposed/
│   │   │   │   └── ADR-000-template.md
│   │   │   ├── accepted/
│   │   │   │   └── .gitkeep
│   │   │   ├── superseded/
│   │   │   │   └── .gitkeep
│   │   │   └── rejected/
│   │   │       └── .gitkeep
│   │   │
│   │   └── diagrams/
│   │       ├── README.md
│   │       ├── source/
│   │       │   ├── plantuml/
│   │       │   │   └── .gitkeep
│   │       │   └── mermaid/
│   │       │       └── .gitkeep
│   │       │   (eliminado: drawio/)        ← ELIMINADO
│   │       └── exported/
│   │           ├── png/
│   │           │   └── .gitkeep
│   │           └── svg/
│   │               └── .gitkeep
│   │
│   ├── 05-data-architecture/
│   │   ├── README.md
│   │   ├── conceptual-model.md
│   │   ├── logical-model.md
│   │   ├── relational-model.md
│   │   ├── entity-catalog.md
│   │   ├── data-dictionary.md
│   │   ├── database-standards.md
│   │   ├── data-ownership.md              ← NUEVO
│   │   ├── migration-strategy.md
│   │   └── diagrams/
│   │       ├── erd.md
│   │       └── mer.md
│   │
│   ├── 06-api-design/
│   │   ├── README.md
│   │   ├── api-standards.md
│   │   ├── api-gateway.md                 ← NUEVO
│   │   ├── error-handling.md
│   │   ├── pagination-filtering-sorting.md
│   │   ├── authentication-authorization.md
│   │   ├── versioning.md
│   │   └── contracts/
│   │       ├── openapi/
│   │       │   └── .gitkeep
│   │       └── asyncapi/                  
│   │           └── .gitkeep
│   │
│   ├── 07-security/
│   │   ├── README.md
│   │   ├── security-principles.md
│   │   ├── identity-access-management.md
│   │   ├── roles-permissions.md
│   │   ├── threat-model.md
│   │   ├── data-protection.md
│   │   ├── auditability.md
│   │   └── security-checklist.md
│   │
│   ├── 08-devops/
│   │   ├── README.md
│   │   ├── developer-setup.md             ← NUEVO
│   │   ├── repository-strategy.md
│   │   ├── branching-strategy.md
│   │   ├── ci-cd-strategy.md
│   │   ├── environments.md
│   │   ├── docker-standards.md
│   │   ├── deployment-checklist.md
│   │   └── observability.md
│   │
│   ├── 09-quality-assurance/
│   │   ├── README.md
│   │   ├── testing-strategy.md
│   │   ├── unit-testing.md
│   │   ├── integration-testing.md
│   │   ├── e2e-testing.md
│   │   ├── performance-testing.md
│   │   ├── accessibility-testing.md
│   │   └── quality-gates.md
│   │
│   ├── 10-user-experience/
│   │   ├── README.md
│   │   ├── ux-principles.md
│   │   ├── information-architecture.md
│   │   ├── navigation-model.md
│   │   ├── wireframes.md
│   │   ├── design-system.md
│   │   └── accessibility-guidelines.md
│   │
│   ├── 11-backlog/
│   │   ├── README.md
│   │   ├── epics/
│   │   │   └── EPIC-000-template.md
│   │   ├── features/
│   │   │   └── .gitkeep
│   │   ├── user-stories/
│   │   │   └── HU-000-template.md
│   │   ├── tasks/
│   │   │   └── TASK-000-template.md
│   │   └── traceability-matrix.md
│   │
│   ├── 12-microservices/                  
│   │   ├── README.md
│   │   ├── microservice-catalog.md
│   │   │
│   │   ├── microservice-template/
│   │   │   ├── README.md
│   │   │   ├── service-context.md
│   │   │   ├── service-responsibilities.md
│   │   │   ├── service-boundaries.md
│   │   │   ├── service-api.md
│   │   │   ├── service-data-model.md
│   │   │   ├── service-security.md
│   │   │   ├── service-deployment.md
│   │   │   ├── service-testing.md
│   │   │   ├── service-runbook.md
│   │   │   └── service-owner.md           ← NUEVO
│   │   │
│   │   └── services/
│   │       ├── README.md
│   │       └── .gitkeep
│   │
│   ├── 13-operations/
│   │   ├── README.md
│   │   ├── runbooks.md
│   │   ├── incident-management.md
│   │   ├── backup-restore.md
│   │   ├── monitoring-alerting.md
│   │   └── support-model.md
│   │
│   ├── 14-training-and-adoption/
│   │   ├── README.md
│   │   ├── user-manual.md
│   │   ├── instructor-guide.md
│   │   ├── administrator-guide.md
│   │   ├── onboarding.md
│   │   └── faq.md
│   │
│   └── 99-archive/
│       ├── README.md
│       ├── deprecated/
│       │   └── .gitkeep
│       └── legacy/
│           └── .gitkeep
│
├── templates/
│   ├── README.md
│   ├── adr-template.md
│   ├── hu-template.md
│   ├── epic-template.md
│   ├── risk-template.md
│   ├── api-contract-template.md
│   ├── microservice-doc-template.md
│   ├── runbook-template.md
│   ├── test-plan-template.md
│   └── decision-log-template.md
│
├── assets/
│   ├── README.md
│   ├── images/
│   │   └── .gitkeep
│   ├── icons/
│   │   └── .gitkeep
│   └── exports/
│       └── .gitkeep
│
└── tools/
    ├── README.md
    ├── validate-docs.sh       ← Para Linux / Mac / CI-CD
    ├── validate-docs.ps1      ← Para Windows
    ├── validate-links.sh
    ├── validate-links.ps1
    ├── generate-index.sh
    └── generate-index.ps1
```
 
---
 
## Notas Finales para el Equipo
 
**Sobre el mantenimiento de esta estructura:**
Una estructura bien diseñada no se mantiene sola. Se recomienda designar desde el inicio un responsable de documentación que garantice que los archivos se actualicen cuando el sistema cambia y que el índice principal (`docs/README.md`) refleje el estado real de cada sección.
 
---

 