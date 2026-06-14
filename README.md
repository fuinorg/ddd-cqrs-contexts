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

This is a Maven multi-module build with two modules:

| Module | Description |
| ------ | ----------- |
| [`cqrs-common-model`](cqrs-common-model/README.md) | The reusable **"common"** CQRS DSL context — the `.cqrs` source files (types, basics, constraints, exceptions). Packaged and published as a `tar.gz` (classifier `cqrs`) so other projects can reuse the model. |
| [`cqrs-common-java`](cqrs-common-java/README.md) | The **Java code generated** from the "common" context, plus hand-written validators and tests. Built into a normal JAR for use as a dependency. |

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
