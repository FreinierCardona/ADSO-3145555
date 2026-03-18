# 🧪 Implementación de Liquibase con Docker y PostgreSQL

## 📌 Objetivo

Implementar una solución básica utilizando **Liquibase** en un
contenedor Docker para gestionar cambios en una base de datos
**PostgreSQL**, también ejecutándose en un contenedor, permitiendo la
automatización de actualizaciones de esquema.

------------------------------------------------------------------------

## 🧠 ¿Qué es Liquibase?

Liquibase es una herramienta de control de versiones para bases de datos
que permite:

-   Gestionar cambios estructurales (tablas, columnas, etc.)
-   Versionar la base de datos
-   Automatizar migraciones
-   Mantener consistencia entre entornos

------------------------------------------------------------------------

## 🐳 Arquitectura utilizada

Se implementó una arquitectura basada en contenedores:

-   📦 Contenedor 1: PostgreSQL (motor de base de datos)
-   📦 Contenedor 2: Liquibase (ejecución temporal)
-   🌐 Red Docker: permite la comunicación entre contenedores

------------------------------------------------------------------------

## ⚙️ Paso 1: Creación de la red Docker

``` bash
docker network create liquibase-net
```

------------------------------------------------------------------------

## 🗄️ Paso 2: Creación del contenedor PostgreSQL

``` bash
docker run -d \
--name postgres_liquibase \
--network liquibase-net \
-e POSTGRES_DB=dockerLiquiBase \
-e POSTGRES_USER=postgres \
-e POSTGRES_PASSWORD=1234 \
-p 5433:5432 \
postgres:15
```

------------------------------------------------------------------------

## 📁 Paso 3: Estructura del proyecto

    LiquiBasePractice/
    ├── changelog.xml
    ├── liquibase.properties
    └── drivers/
        └── postgresql-42.x.x.jar

------------------------------------------------------------------------

## ⚙️ Paso 4: Configuración (`liquibase.properties`)

``` properties
url=jdbc:postgresql://postgres_liquibase:5432/dockerLiquiBase
username=postgres
password=1234
driver=org.postgresql.Driver
changeLogFile=changelog.xml
```

------------------------------------------------------------------------

## 📄 Paso 5: Archivo (`changelog.xml`)

``` xml
<?xml version="1.0" encoding="UTF-8"?>

<databaseChangeLog
    xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="
        http://www.liquibase.org/xml/ns/dbchangelog
        http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-latest.xsd">

    <changeSet id="1" author="steven">
        <createTable tableName="persona">
            <column name="id" type="int" autoIncrement="true">
                <constraints primaryKey="true"/>
            </column>
            <column name="nombre" type="varchar(100)"/>
        </createTable>
    </changeSet>

</databaseChangeLog>
```

------------------------------------------------------------------------

## 🔌 Paso 6: Driver PostgreSQL

Descargar desde: https://jdbc.postgresql.org/download/

Ubicar en:

    drivers/postgresql-42.x.x.jar

------------------------------------------------------------------------

## 🚀 Paso 7: Ejecución

``` bash
docker run --rm --network liquibase-net -v ${PWD}:/liquibase/changelog -v ${PWD}/drivers:/liquibase/lib liquibase/liquibase --defaultsFile=/liquibase/changelog/liquibase.properties update
```

------------------------------------------------------------------------

## ✅ Resultado

-   Tabla `persona` creada
-   Tablas:
    -   databasechangelog
    -   databasechangeloglock

------------------------------------------------------------------------

## 🎯 Conclusión

Se logró:

-   Uso de Liquibase con Docker
-   Conexión entre contenedores
-   Versionamiento de base de datos
-   Automatización de cambios
