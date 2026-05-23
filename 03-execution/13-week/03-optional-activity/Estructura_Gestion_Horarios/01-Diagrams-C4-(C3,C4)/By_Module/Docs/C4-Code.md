# C4 — Code (By_Module)

Contexto: referencia C1/C2: [C1 - Contexto](00-Diagrams-C4-(C1_C2)/Docs/C1-context.md) • [C2 - Contenedores](00-Diagrams-C4-(C1_C2)/Docs/C2-containers.md)

Resumen: inventario de clases (por módulo) y descripción de relaciones entre ellas, pensado para alimentar un diagrama C4 a nivel de código.

Módulo: `role_management` — clases y relaciones
- **Controllers**
   - `By_Module/modules/role_management/Controller/RolController.java`
   - `By_Module/modules/role_management/Controller/UserAccountController.java`
   - `By_Module/modules/role_management/Controller/UserRolController.java`
   - Relación: cada controller delega en su `IService` correspondiente (p. ej. `IRolService`) y expone/consume `Dto`.

- **Services / Interfaces**
   - `By_Module/modules/role_management/IService/IRolService.java`
   - `By_Module/modules/role_management/Service/RolService.java`
   - Relación: `RolService` implementa `IRolService` y utiliza `IRepository` para persistencia.

- **Repositories / Entities / DTOs**
   - `By_Module/modules/role_management/IRepository/IRolRepository.java`
   - `By_Module/modules/role_management/Entity/Rol.java`
   - `By_Module/modules/role_management/Dto/RolDto.java`
   - Relación: `IRolRepository` opera sobre `Rol` (Entity); el mapeo Entity↔DTO se realiza en `Service` o en adaptadores.

Módulo: `user_management` — resumen similar
- Clases enumeradas en `By_Module/modules/user_management/...` (Controller, Service, IRepository, Dto, Entity).
- Relación típica: `UserAccountController` → `IUserAccountService` → `IUserAccountRepository` → `UserAccount` (Entity)

Relaciones entre módulos
- Cuando `user_management` necesita información de roles, debe hacerlo a través de `IService` expuesto por `role_management` o mediante DTOs; evite acceso directo a entidades de otro módulo.

Representación para C4 nivel 4
- Liste interfaces (`IService`, `IRepository`) y clases concretas (`Service`, `Controller`) como nodos. Añada aristas con el tipo de relación (inyección, mapeo DTO↔Entity, llamada HTTP interna).

