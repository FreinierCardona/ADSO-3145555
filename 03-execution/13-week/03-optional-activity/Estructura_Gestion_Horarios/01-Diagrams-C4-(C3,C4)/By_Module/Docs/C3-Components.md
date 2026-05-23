# C3 — Components (By_Module)

Guía: [C1 - Contexto](00-Diagrams-C4-(C1_C2)/Docs/C1-context.md) • [C2 - Contenedores](00-Diagrams-C4-(C1_C2)/Docs/C2-containers.md)

Propósito
- Mapear los componentes por módulo y describir por qué existen y cómo interactúan entre sí dentro de cada módulo y entre módulos.

Estructura por módulo (resumen)
- Cada módulo contiene las mismas responsabilidades conceptuales: `Controller` (API), `IService`/`Service` (lógica), `IRepository` (persistencia), `Entity` (modelo), `Dto`/`IDto` (frontera), `Utils` (utilidades).

- **Módulo: role_management**
  - Archivos representativos:
    - Controladores: `By_Module/modules/role_management/Controller/RolController.java`, `UserAccountController.java`, `UserRolController.java`
    - Servicios: `By_Module/modules/role_management/Service/RolService.java`, `UserAccountService.java`, `UserRolService.java`
    - Repositorios/DTOs/Entities: dentro de `IRepository`, `Dto`, `Entity`.
  - Por qué: encapsula todo el comportamiento relacionado con la gestión de roles (definición, asignación, validaciones de regla de negocio específicas para roles).
  - Relaciones: `RolController` → `IRolService` → `IRolRepository` → `Rol` (Entity). El módulo expone únicamente las interfaces públicas necesarias para integrarse con otros módulos.

- **Módulo: user_management**
  - Archivos representativos: `By_Module/modules/user_management/...` (mismo patrón de carpetas).
  - Por qué: gestion de cuentas y atributos de usuario, separación de responsabilidades respecto a `role_management`.
  - Relaciones: cuando interactúa con `role_management` lo hace mediante interfaces (servicios) y DTOs, manteniendo bajo acoplamiento.

Relaciones entre módulos
- Comunicación entre módulos: preferir llamadas a `IService` expuestas por el módulo receptor o eventos/colas si la interacción debe ser desacoplada.
- Evite dependencias directas a `Entity` de otro módulo; use `DTO` o adaptadores.

Cómo representar en C3
- Cada módulo es un agrupador de componentes en el diagrama C3; dentro de cada agrupador muestre `Controller`, `Service`, `Repository` con sus interfaces públicas y las dependencias cruzadas (p.ej. `user_management` → `role_management` via `IUserRoleService`).

Checklist para evitar puntos muertos
- Documentar los contratos públicos (métodos y DTOs) en `IService`/`IDto`.
- Registrar los puntos de integración y los formatos de mensajes/DTOs.

