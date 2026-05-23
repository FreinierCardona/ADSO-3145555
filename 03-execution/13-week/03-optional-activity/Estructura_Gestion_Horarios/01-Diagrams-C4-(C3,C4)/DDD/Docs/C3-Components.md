# C3 — Components (DDD / bounded contexts)

Guía: [C1 - Contexto](00-Diagrams-C4-(C1_C2)/Docs/C1-context.md) • [C2 - Contenedores](00-Diagrams-C4-(C1_C2)/Docs/C2-containers.md)

Propósito
- Identificar componentes por bounded context y explicar por qué existen (roles de dominio) y cómo se relacionan internamente y con otros contextos.

Estructura por bounded context
- Cada contexto contiene su propio modelo, servicios y repositorios. Esto preserva la independencia del lenguaje ubicuo y evita fugas del modelo.

- **Bounded Context: user_management**
  - Componentes representativos:
    - `DDD/bounded_contexts/user_management/Controller/*` — interfaces de entrada del contexto.
    - `DDD/bounded_contexts/user_management/Service/*` — Application o Domain Services que aplican reglas de negocio del contexto.
    - `DDD/bounded_contexts/user_management/Entity/*` — entidades y agregados propios del contexto.
    - `DDD/bounded_contexts/user_management/IRepository/*` — contratos de persistencia para los agregados.
  - Por qué: concentra todo el comportamiento y reglas del subdominio de gestión de usuarios (agregados, invariantes, validaciones específicas).
  - Relaciones: los controladores del contexto llaman a sus servicios; los servicios usan sus repositorios; los datos que deben cruzar contextos se exponen mediante DTOs/servicios bien definidos.

- **Bounded Context: security**
  - Componentes representativos: `DDD/bounded_contexts/security/Controller`, `Service`, `Entity`, `IRepository`, `Dto`.
  - Por qué: centraliza aspectos de autenticación/autorización y reglas de seguridad que tienen sentido propio.
  - Relaciones: posible consumidor de `security` es `user_management` mediante interfaces de integración (servicios) o adaptadores.

Interacciones entre bounded contexts
- Use puntos de integración explícitos: servicios de aplicación, adaptadores o eventos. En diagramas C3 muestre estos puntos como interfaces públicas del contexto (no como acoplamiento directo a entidades internas).

Cómo representar en C3
- Dibuje cada bounded context como un contenedor lógico con sus componentes internos (Controller, Service, Repository, Entities). Marque claramente las interfaces públicas y los flujos de datos entre contextos.

