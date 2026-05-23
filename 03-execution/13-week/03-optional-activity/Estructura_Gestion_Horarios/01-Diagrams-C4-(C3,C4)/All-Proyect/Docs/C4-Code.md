# C4 — Code (All_Proyect)

Guía: [C1 - Contexto](00-Diagrams-C4-(C1_C2)/Docs/C1-context.md) • [C2 - Contenedores](00-Diagrams-C4-(C1_C2)/Docs/C2-containers.md)

Resumen: listado de clases/artefactos relevantes y sus relaciones dentro de la propuesta `All_Proyect`.

Clases y responsabilidad principal
- **Controllers**
  - `All_Proyect/Controller/RolController.java` — expone los casos de uso relacionados con `Rol` (entrada y adaptación de payloads).
  - `All_Proyect/Controller/UserAccountController.java` — punto de entrada para cuentas de usuario.
  - `All_Proyect/Controller/UserRolController.java` — manejo de asignaciones rol↔usuario.

- **Service Interfaces & Implementaciones**
  - `All_Proyect/IService/IRolService.java` / `All_Proyect/Service/RolService.java` — contrato e implementación para operaciones de negocio sobre `Rol`.
  - `All_Proyect/IService/IUserAccountService.java` / `All_Proyect/Service/UserAccountService.java` — servicios de cuentas.
  - `All_Proyect/IService/IUserRolService.java` / `All_Proyect/Service/UserRolService.java` — lógica de asignación de roles.

- **Repositories (contratos)**
  - `All_Proyect/IRepository/IRolRepository.java` — interfaz para persistencia de `Rol`.
  - `All_Proyect/IRepository/IUserAccountRepository.java`
  - `All_Proyect/IRepository/IUserRolRepository.java`

- **DTO / IDTO**
  - `All_Proyect/Dto/*Dto.java` — objetos de transferencia usados en fronteras.
  - `All_Proyect/IDto/*` — contratos de DTO para estandarizar payloads.

- **Entities**
  - `All_Proyect/Entity/Rol.java`, `All_Proyect/Entity/UserAccount.java`, `All_Proyect/Entity/UserRol.java` — modelos de dominio/persistencia.

Relaciones entre clases (dirección de dependencia)
- `Controller` → `IService` / `Service` (inyección de dependencias): los controladores delegan operaciones a servicios de aplicación.
- `Service` → `IRepository` (persistencia): los servicios orquestan reglas de negocio y usan repositorios para CRUD sobre `Entity`.
- `Repository` ↔ `Entity`: los repositorios materializan y persisten entidades.
- `Controller` ↔ `DTO`: los controladores exponen y reciben DTOs como contrato de entrada/salida.

Ejemplo (traza conceptual)
- `RolController` → `IRolService.createRol(RolDto)` → `RolService` valida reglas de dominio → `IRolRepository.save(Rol)` → DB

Cómo usar este documento para C4 nivel 4
- Use las clases listadas como nodos: represente interfaces (`IService`, `IRepository`) y clases concretas (`Service`, `Controller`) y muestre las dependencias por flechas. Anote para cada arista la naturaleza de la relación (ej.: inyección, llamada directa, mapeo DTO↔Entity).

Notas de modelado
- `IRolService` y `IRolRepository` son puntos de extensión: en diagramas muéstrelos como contratos. Esto facilita mostrar sustituciones (tests, adaptadores) y la separación de responsabilidades en C4.

