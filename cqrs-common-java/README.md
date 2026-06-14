# cqrs-common-java

The **Java code generated** from the "common" CQRS DSL context, packaged as a JAR for use as a
dependency.

Part of [ddd-cqrs-contexts](../README.md). The DSL source it is generated from lives in
[`cqrs-common-model`](../cqrs-common-model/README.md).

## How it is built

During the `process-sources` phase the
[srcgen4j-maven-plugin](pom.xml) (with the `ddd-templates`) reads the "common" model and
generates Java into [`src-gen/main/java`](src-gen/main/java). The
`build-helper-maven-plugin` then adds that directory as an additional compile source root.

```
../cqrs-common-model (.cqrs)  ──▶  src-gen/main/java (generated)  ──▶  cqrs-common-java.jar
```

Generation configuration: [`srcgen4j-config.xml`](srcgen4j-config.xml).

## Source layout

| Directory | Contents |
| --------- | -------- |
| `src-gen/main/java` | **Generated** code — value objects, enums and exceptions of the `common` context. Do not edit by hand; it is regenerated on each build. |
| `src/main/java` | Hand-written code that complements the generated types, mainly the constraint validators (e.g. `LengthValidator`, `PatternValidator`, `ValueRangeValidator`). |
| `src/test/java` | JUnit 5 / AssertJ tests for the validators, run against Hibernate Validator. |

## Null-safety

The generated and hand-written code is `@NullMarked` (JSpecify) and checked at compile time by
NullAway via Error Prone, as configured in the parent [`pom.xml`](../pom.xml).

## Using it as a dependency

The module is published as a normal JAR. Add it to your project to use the generated value
objects, enums, exceptions and constraint validators directly:

```xml
<dependency>
    <groupId>org.fuin.dsl.cqrs.contexts</groupId>
    <artifactId>cqrs-common-java</artifactId>
    <version>0.1.0-SNAPSHOT</version>
</dependency>
```

Released versions come from Maven Central; `-SNAPSHOT` versions from Sonatype Snapshots.

## Building

```bash
../mvnw -pl cqrs-common-java -am clean install
```
