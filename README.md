# ddd-cqrs-contexts

[![Build Status](https://github.com/fuinorg/ddd-cqrs-contexts/actions/workflows/maven.yml/badge.svg)](https://github.com/fuinorg/ddd-cqrs-contexts/actions/workflows/maven.yml)
[![Coverage Status](https://sonarcloud.io/api/project_badges/measure?project=org.fuin.dsl.cqrs.contexts%3Addd-cqrs-contexts&metric=coverage)](https://sonarcloud.io/dashboard?id=org.fuin.dsl.cqrs.contexts%3Addd-cqrs-contexts)
[![LGPL v2.1 License](http://img.shields.io/badge/license-LGPL%20v2.1-blue.svg)](http://www.fsf.org/licensing/licenses/lgpl.html)
[![Java Development Kit 21](https://img.shields.io/badge/JDK-21-green.svg)](https://openjdk.java.net/projects/jdk/21/)

Reusable **DDD/CQRS contexts** defined with the [DDD/CQRS DSL](https://github.com/fuinorg/ddd-cqrs-dsl/),
together with the Java code generated from them.

The idea is to model bounded contexts (their types, value objects, enums, constraints and
exceptions) once in a concise, language-neutral DSL, and then generate the corresponding Java
artifacts automatically. The DSL model is the single source of truth; the generated Java is a
build output.

```
.cqrs DSL model  ── (srcgen4j + ddd-templates) ──▶  generated Java sources  ──▶  JAR
```

## Modules

This is a Maven multi-module build. Each bounded context is grouped under its own module, with a
`model` submodule (the `.cqrs` DSL source, published as a `tar.gz` with classifier `cqrs`) and a
`java` submodule (the generated Java, built into a JAR).

### [`cqrs-common`](cqrs-common/README.md) — the reusable "common" context

| Module | Description |
| ------ | ----------- |
| [`cqrs-common-model`](cqrs-common/model/README.md) | The reusable **"common"** CQRS DSL context — the `.cqrs` source files (types, basics, constraints, exceptions). |
| [`cqrs-common-java`](cqrs-common/java/README.md) | The **Java code generated** from the "common" context, plus hand-written validators and tests. |

### [`cqrs-country-codes`](cqrs-country-codes/README.md) — ISO 3166 country codes

| Module | Description |
| ------ | ----------- |
| [`cqrs-country-codes-model`](cqrs-country-codes/model/README.md) | The **"country-codes"** CQRS DSL context — ISO 3166 country and subdivision codes. **Reuses `cqrs-common`** by importing its namespaces as external types/constraints (resolved via `dependencies.json`). |
| [`cqrs-country-codes-java`](cqrs-country-codes/java/README.md) | The **Java code generated** from the "country-codes" context. Depends on the `cqrs-common-java` JAR. |

See each module's own README for details.

## Building

```bash
./mvnw clean install
```

Requires Java 21. Code generation runs automatically during the build (`process-sources` phase).

## Conventions

- Compile-time null-safety via [JSpecify](https://jspecify.dev/) (`@NullMarked` / `@Nullable`)
  enforced by [NullAway](https://github.com/uber/NullAway) through Error Prone.
- Versions of the fuin libraries used by the generated code are managed centrally in the
  parent [`pom.xml`](pom.xml).
