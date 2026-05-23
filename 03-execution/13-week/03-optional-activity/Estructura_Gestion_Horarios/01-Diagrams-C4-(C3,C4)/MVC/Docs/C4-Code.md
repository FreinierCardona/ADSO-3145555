# C4 — Code (MVC)

Referencias: [C1 - Contexto](00-Diagrams-C4-(C1_C2)/Docs/C1-context.md) • [C2 - Contenedores](00-Diagrams-C4-(C1_C2)/Docs/C2-containers.md)

Listado de clases y relaciones (MVC/app)
- **Controllers**
  - `MVC/app/Controller/RolController.java` — expone operaciones relacionadas con roles.
  - `MVC/app/Controller/UserAccountController.java`
  - `MVC/app/Controller/UserRolController.java`
  - Relaciones: cada controlador depende de su `IService`/`Service` correspondiente y usa `Dto` para entrada/salida.

- **Services / Interfaces**
  - `MVC/app/IService/IRolService.java` / `MVC/app/Service/RolService.java` — contratos e implementaciones para reglas de negocio.
  - `Service` orquesta repositorios y transforma `Entity` ↔ `Dto`.

- **Repositories / Entities / DTOs**
  - `MVC/app/IRepository/*` — interfaces de persistencia.
  - `MVC/app/Entity/*` — modelos de dominio.
  - `MVC/app/Dto/*` — objetos de transporte.

Relaciones conceptuales
- `Controller` → `Service` → `Repository` → `Entity`.
- El `Service` actúa como límite de dominio entre la capa de presentación y la persistencia; los `Dto` son la frontera de integración.

Cómo usar este documento
- Tome las clases listadas y represéntelas como nodos en C4 nivel 4, mostrando interfaces (`IService`, `IRepository`) como contratos y las implementaciones concretas como adaptadores.

