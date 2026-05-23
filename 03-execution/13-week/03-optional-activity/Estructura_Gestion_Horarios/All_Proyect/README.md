# Arquitectura All_Proyect

## ¿Qué es?
All_Proyect es un diseño monolítico tradicional con una estructura de carpetas normalizada para facilitar la organización y el mantenimiento.

## ¿Cómo funciona?
Se agrupan los elementos de aplicación en capas funcionales, cada una con un propósito claro:
- `Entity`: modelado de los objetos de dominio.
- `IRepository`: contratos para acceso a datos.
- `Service`: implementaciones de servicios de aplicación.
- `IService`: interfaces de servicio para desacoplar dependencias.
- `Controller`: controladores que exponen casos de uso.
- `Dto`: objetos de transferencia de datos.
- `IDto`: contratos de DTO para estandarizar la comunicación.
- `Utils`: utilidades repartidas.

## ¿Por qué para este proyecto?
Permite una primera organización sólida donde el sistema de gestión de horarios se gestiona como una única aplicación coherente, ideal para validación temprana.

## Ventajas
- Alta cohesión dentro de cada capa.
- Claridad en responsabilidades.
- Fácil de entender para equipos empresariales.
- Base sólida para evolucionar hacia otras arquitecturas.

## Desventajas
- No es la forma más flexible para servicios distribuidos.
- Escala menos naturalmente que una arquitectura modular.

## Casos ideales
- Productos iniciales con un único equipo de desarrollo.
- Proyectos de alcance empresarial controlado.
- Sistemas que requieren trazabilidad clara en capas.

## Escalabilidad
Escala principalmente verticalmente y puede evolucionar hacia capas adicionales sin cambiar la base.

## Mantenibilidad
- Buena mantenibilidad si se respeta la separación de carpetas.
- La introducción de `IService` e `IDto` reduce el acoplamiento.

## Separación de responsabilidades
- `Entity`: objetos de negocio.
- `IRepository`: contratos de persistencia.
- `Service` / `IService`: lógica de aplicación.
- `Controller`: puntos de entrada.
- `Dto` / `IDto`: datos entre capas.
- `Utils`: funciones de apoyo.

## Estructura base
```text
All_Proyect/
  Entity/
  IRepository/
  Service/
  IService/
  Controller/
  Dto/
  IDto/
  Utils/
```
