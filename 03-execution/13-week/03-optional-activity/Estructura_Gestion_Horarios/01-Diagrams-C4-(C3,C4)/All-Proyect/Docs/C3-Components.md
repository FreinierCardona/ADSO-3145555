# C3 — Components (All_Proyect)

Guía: [C1 - Contexto](00-Diagrams-C4-(C1_C2)/Docs/C1-context.md) • [C2 - Contenedores](00-Diagrams-C4-(C1_C2)/Docs/C2-containers.md)

Propósito de este documento
- Identificar los componentes a nivel de arquitectura (C3) en la propuesta `All_Proyect`.
- Explicar por qué existe cada componente y cómo se relaciona con los demás (dirección de dependencias, responsabilidades de frontera).

Visión general
- `All_Proyect` sigue un patrón por capas: Controladores (entrada), Servicios (lógica), Repositorios (persistencia), Entidades (modelo) y DTOs (fronteras). La separación busca transaccionalidad y operaciones coherentes dentro de un monolito.

Componentes y por qué existen
- **Controllers** — Archivos: [All_Proyect/Controller/RolController.java](All_Proyect/Controller/RolController.java), [All_Proyect/Controller/UserAccountController.java](All_Proyect/Controller/UserAccountController.java), [All_Proyect/Controller/UserRolController.java](All_Proyect/Controller/UserRolController.java)
  - Por qué: punto de entrada HTTP/CLI para casos de uso; validan entrada, autorizan y adaptan payloads a objetos internos.
  - Relación: llaman a `IService` / `Service` para ejecutar la lógica; consumen/produces DTOs.

- **Services (IService + Service)** — Archivos: [All_Proyect/IService/IRolService.java](All_Proyect/IService/IRolService.java), [All_Proyect/Service/RolService.java](All_Proyect/Service/RolService.java), etc.
  - Por qué: encapsulan reglas de negocio, coordinan transacciones y orquestan llamadas a repositorios y utilidades.
  - Relación: dependen de `IRepository` para persistencia; son llamados por los Controladores.

- **Repositories (IRepository)** — Archivos: [All_Proyect/IRepository/IRolRepository.java](All_Proyect/IRepository/IRolRepository.java), etc.
  - Por qué: fronteras de persistencia (DAO); abstraen acceso a la base de datos y operaciones CRUD sobre `Entity`.
  - Relación: son usados por `Service` y devuelven `Entity` a nivel de dominio.

- **Entities** — Archivos: [All_Proyect/Entity/Rol.java](All_Proyect/Entity/Rol.java), [All_Proyect/Entity/UserAccount.java](All_Proyect/Entity/UserAccount.java)
  - Por qué: representan el modelo del dominio y la estructura persistida.
  - Relación: son materializados/consumidos por `Repository` y manipulados por `Service`.

- **DTO / IDTO** — Archivos: [All_Proyect/Dto/RolDto.java](All_Proyect/Dto/RolDto.java), [All_Proyect/IDto/IRolDto.java](All_Proyect/IDto/IRolDto.java)
  - Por qué: delimitar contratos entre capas; evitar exponer entidades internas y estandarizar payloads.
  - Relación: son usados en las fronteras (Controllers ↔ Services) y en las integraciones (API responses).

- **Utils** — Propósito: utilidades compartidas (formateo, validaciones auxiliares).

Relaciones principales (cadena típica)
- `Controller` → `IService` (inyección) → `Service` → `IRepository` → persistencia (Entity)
- Datos entrantes: JSON → `DTO` → `Service` → `Entity` → `Repository`
- Datos salientes: `Entity` → `DTO` → JSON

Cómo representar en un diagrama C3
- Cada componente (Controller, Service, Repository, Entity) se representa como un contenedor lógico dentro del mismo sistema; las flechas marcan dependencia (ej.: Controller → Service). Detalla las interfaces públicas (p.ej. `IRolService`) y responsabilidades (p.ej. "gestion de roles: CRUD, validaciones de conflicto").

Notas finales
- La organización favorece transacciones y mensajes coherentes en un monolito y facilita la migración a módulos o microservicios cuando se identifiquen límites de contexto.
