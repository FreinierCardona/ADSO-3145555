# Sistema de Gestión de Horarios del SENA

**Autor:** Freinier Cardona

**Fecha:** 21 de mayo de 2026

## Introducción
Este repositorio presenta cuatro propuestas arquitectónicas paralelas para el Sistema de Gestión de Horarios del SENA. Cada propuesta usa una organización clara, con una base común de carpetas para facilitar la comparación y la evolución.

## Problemática
- Cruces de horarios entre grupos.
- Conflictos de instructores.
- Conflictos de ambientes físicos.
- Sobrecarga administrativa manual.
- Mala asignación de recursos y tiempos.

## Objetivo general
Definir una base arquitectónica profesional que permita un desarrollo ordenado, con alta cohesión, bajo acoplamiento y una separación clara de responsabilidades.

## Objetivos específicos
- Establecer estructuras de carpetas por arquitectura.
- Mantener consistencia con principios de arquitectura empresarial.
- Proveer ejemplos de entidades y contratos base.
- Preservar escalabilidad y mantenibilidad.

## Alcance MVP
- Estructuras de carpetas vacías.
- Ejemplos base para `user_account`, `rol` y `user_rol`.
- Documentación técnica por arquitectura.
- Sin lógica de negocio implementada.

## Arquitecturas propuestas
| Arquitectura | Enfoque | Ventaja central |
| --- | --- | --- |
| `All_Proyect` | Centralizada por capas | Simplicidad de monolito |
| `By_Module` | Modular por contexto | Escalado por subdominios |
| `DDD` | Dominio rico con bounded contexts | Fuerte modelado de negocio |
| `MVC` | Tradicional web | Claridad en interfaz y control |

## Justificación técnica
La estructura propuesta define una base empresarial que puede evolucionar hacia pruebas, CI/CD y versiones distribuidas, sin entrar todavía en detalles de tecnologías concretas.

## KPIs sugeridos
- Definición de arquitectura lista en 1 día.
- Comparación de propuestas en 2 iteraciones.
- Reutilización de carpetas base en 100% de arquitecturas.
- Reducción del acoplamiento en cada propuesta.

## Riesgos
- Complejidad de comparación si no se documenta bien.
- Duplicación de artefactos sin criterios claros.
- Sobredimensionamiento de una propuesta antes de validar el MVP.

## Beneficios
- Base homogénea para evaluación técnica.
- Claridad en responsabilidades de carpetas.
- Preparación para futuras expansiones.
- Base lista para pruebas y documentación.

## Buenas prácticas
- Alta cohesión en cada carpeta.
- Bajo acoplamiento entre módulos.
- Nombres descriptivos y consistentes.
- Uso de `IService` para contratos de servicio y `IDto` para objetos de transferencia.
- Documentación empresarial dentro de cada propuesta.
- Uso de `.gitkeep` en carpetas vacías.

## Escalabilidad
El repositorio está diseñado para crecer desde una base controlada hacia implementaciones distribuidas. Cada arquitectura puede evolucionar hacia microservicios sin reescribir la raíz del proyecto.

## Separación arquitectónica
- `All_Proyect`: capas horizontales.
- `By_Module`: módulos verticales.
- `DDD`: dominio, aplicación y bounded contexts.
- `MVC`: modelo, vista y controlador.

## Posibles futuras integraciones
- Sistema de notificaciones.
- Motor de conciliación de horarios.
- Gestión de ambientes y recursos.
- Integración con sistemas académicos del SENA.

## Estructura general del repositorio
```text
README.md

All_Proyect/
  Entity/
  IRepository/
  Service/
  IService/
  Controller/
  Dto/
  IDto/
  Utils/

By_Module/
  modules/
    user_management/
      Entity/
      IRepository/
      Service/
      IService/
      Controller/
      Dto/
      IDto/
      Utils/
    role_management/
      Entity/
      IRepository/
      Service/
      IService/
      Controller/
      Dto/
      IDto/
      Utils/
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

## Observaciones
Cada arquitectura incluye las carpetas base: `Entity`, `IRepository`, `Service`, `IService`, `Controller`, `Dto`, `IDto`, `Utils`.
