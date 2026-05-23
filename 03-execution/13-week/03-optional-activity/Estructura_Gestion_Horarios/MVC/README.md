# Arquitectura MVC

## ¿Qué es?
MVC es un patrón clásico donde la aplicación se divide en modelos, controladores y vistas. En esta propuesta se integra la estructura base requerida dentro de la carpeta `app`.

## ¿Cómo funciona?
Dentro de `MVC/app` existen:
- `Entity`
- `IRepository`
- `Service`
- `IService`
- `Controller`
- `Dto`
- `IDto`
- `Utils`

Esto permite mantener el patrón MVC al tiempo que se incorpora una organización de contratos y datos clara.

## ¿Por qué para este proyecto?
MVC es útil para una primera versión web del sistema de horarios con una separación clara entre la lógica de presentación y la lógica de datos.

## Ventajas
- Diseño sencillo y fácil de explicar.
- Claridad en el flujo de datos.
- Buen punto de partida para interfaces web.

## Desventajas
- Puede volverse rígido si se añade demasiada lógica en los controladores.
- No prioriza tanto el dominio como DDD.

## Casos ideales
- Aplicaciones web empresariales iniciales.
- Interfaces con controladores claramente definidos.
- Sistemas que requieren una capa de presentación limpia.

## Escalabilidad
- Aceptable para MVPs y primeras versiones.
- Puede evolucionar si se aplica una capa de servicios adicional.

## Mantenibilidad
- Buena si se mantiene la división entre `Controller` y `Service`.
- `IService` e `IDto` ayudan a estandarizar la comunicación.

## Separación de responsabilidades
- `Entity`: objetos de dominio.
- `IRepository`: contratos de datos.
- `Service` / `IService`: lógica de aplicación.
- `Controller`: control de flujo.
- `Dto` / `IDto`: estructuras de datos.
- `Utils`: utilidades.

## Estructura base
```text
MVC/
  app/
    Entity/
    IRepository/
    Service/
    IService/
    Controller/
    Dto/
    IDto/
    Utils/
```
