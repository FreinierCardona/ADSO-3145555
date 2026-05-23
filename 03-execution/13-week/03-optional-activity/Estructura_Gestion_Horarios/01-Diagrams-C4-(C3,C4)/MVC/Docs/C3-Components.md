# C3 — Components (MVC)

Guía: [C1 - Contexto](00-Diagrams-C4-(C1_C2)/Docs/C1-context.md) • [C2 - Contenedores](00-Diagrams-C4-(C1_C2)/Docs/C2-containers.md)

Propósito
- Describir qué componentes forman la propuesta MVC y por qué están separados en esas capas, enfatizando responsabilidades y dependencias.

Componentes principales
- **Controllers** (`MVC/app/Controller/*`)
  - Responsabilidad: manejar la interacción con la capa de presentación (vistas o API REST), recibir solicitudes, validar entradas y delegar al servicio correspondiente.
  - Ejemplos: `RolController.java`, `UserAccountController.java`, `UserRolController.java`.

- **Services** (`MVC/app/Service/*`)
  - Responsabilidad: aplicar la lógica de negocio y preparar modelos para la vista o respuestas API; orquestan repositorios y utilidades.
  - Ejemplos: `RolService.java`, `UserAccountService.java`, `UserRolService.java`.

- **Repositories / Entities / DTOs**
  - `MVC/app/IRepository/*` — contratos de acceso a datos.
  - `MVC/app/Entity/*` — modelos del dominio.
  - `MVC/app/Dto/*` — objetos de transferencia entre capas.

Relaciones
- Flujo típico: `Controller` → `Service` → `Repository` → `Entity`.
- `Service` mapea `Entity` ↔ `Dto` y entrega la información a `Controller` para presentación.

Pautas para C3
- Documente para cada controlador qué servicios consume, y para cada servicio qué repositorios utiliza. Esto elimina posibles puntos muertos en la comprensión del flujo de datos.

