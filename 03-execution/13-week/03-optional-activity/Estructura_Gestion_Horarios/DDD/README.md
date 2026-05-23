# Arquitectura DDD

## ¿Qué es?
Domain Driven Design organiza el software en torno al dominio y sus contextos. En este repositorio se usa `bounded_contexts` como base y cada contexto incluye la estructura requerida.

## ¿Cómo funciona?
Cada bounded context contiene:
- `Entity`
- `IRepository`
- `Service`
- `IService`
- `Controller`
- `Dto`
- `IDto`
- `Utils`

Esto conserva los principios de DDD y añade una capa de contratos y objetos de transferencia claros.

## ¿Por qué para este proyecto?
DDD es adecuado para un sistema con reglas de horarios, roles y conflictos que deben modelarse con claridad y separación de contexto.

## Ventajas
- Fuerte alineación con el dominio.
- Mejora la comunicación del negocio.
- Reduce el acoplamiento entre contextos.
- Estructura preparada para servicios independientes.

## Desventajas
- Mayor complejidad de diseño inicial.
- Requiere claridad en los límites de contexto.

## Casos ideales
- Sistemas con múltiples subdominios.
- Reglas de negocio complejas.
- Equipos que usan lenguaje ubicuo de dominio.

## Escalabilidad
Alta, porque cada bounded context puede evolucionar de forma independiente.

## Mantenibilidad
- Alta si cada contexto respeta su propio modelo.
- Los contratos `IService` y `IDto` ayudan a desacoplar implementaciones.

## Separación de responsabilidades
- `Entity`: modelo del dominio del contexto.
- `IRepository`: contrato de persistencia del contexto.
- `Service` / `IService`: lógica de aplicación.
- `Controller`: puntos de entrada del contexto.
- `Dto` / `IDto`: transporte de datos.
- `Utils`: utilidades específicas.

## Estructura base
```text
DDD/
  bounded_contexts/
    user_management/
      Entity/
      IRepository/
      Service/
      IService/
      Controller/
      Dto/
      IDto/
      Utils/
    security/
      Entity/
      IRepository/
      Service/
      IService/
      Controller/
      Dto/
      IDto/
      Utils/
```
