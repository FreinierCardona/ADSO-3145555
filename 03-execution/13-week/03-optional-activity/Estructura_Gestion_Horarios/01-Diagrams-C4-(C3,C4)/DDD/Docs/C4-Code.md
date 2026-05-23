# C4 — Code (DDD / bounded contexts)

Referencias: [C1 - Contexto](00-Diagrams-C4-(C1_C2)/Docs/C1-context.md) • [C2 - Contenedores](00-Diagrams-C4-(C1_C2)/Docs/C2-containers.md)

Resumen: inventario de clases por bounded context y descripción de sus dependencias conceptuales.

Contexto: `user_management`
- Clases principales:
	- Controladores: `DDD/bounded_contexts/user_management/Controller/RolController.java`, `UserAccountController.java`
	- Servicios: `DDD/bounded_contexts/user_management/Service/RolService.java`, `IService/*` (contratos)
	- Repositorios: `DDD/bounded_contexts/user_management/IRepository/*`
	- Entidades: `DDD/bounded_contexts/user_management/Entity/*`
- Relaciones: Controllers → Services (inyección) → Repositories → Entities. Los servicios encapsulan las reglas de negocio del contexto.

Contexto: `security`
- Clases principales:
	- `DDD/bounded_contexts/security/Controller/*`
	- `DDD/bounded_contexts/security/Service/*`
	- `DDD/bounded_contexts/security/IRepository/*`
	- `DDD/bounded_contexts/security/Entity/*`
- Relaciones: equivalente al contexto `user_management`, con responsabilidades centradas en seguridad (autorización, asignación de roles, verificaciones).

Interacción entre contexts (cómo modelarlo en C4 nivel 4)
- Si un contexto necesita datos de otro, modele la interacción como: consumer-controller → consumer-service → integration-adapter → provider-service (contrato público). No represente acceso directo a repositorios de otro contexto.
- Use DTOs o adaptadores para transferir datos entre contextos y marque claramente los contratos.

Representación en diagramas C4
- Liste los tipos de clases (Controller, Service, Repository, Entity) dentro de cada bounded context y dibuje flechas de dependencia entre ellos; indique si la relación es síncrona (llamada de servicio) o asíncrona (evento).

