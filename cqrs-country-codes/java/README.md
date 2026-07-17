# cqrs-country-codes-java

The **Java code generated** from the "country-codes" CQRS DSL context (ISO 3166), packaged as a
JAR for use as a dependency.

Part of [cqrs-country-codes](../README.md) (in [ddd-cqrs-contexts](../../README.md)). The DSL
source it is generated from lives in the sibling module
[`cqrs-country-codes-model`](../model/README.md).

## How it is built

During the `process-sources` phase the
[srcgen4j-maven-plugin](pom.xml) (with the `ddd-templates`) reads the "country-codes" model and
generates Java into [`src-gen/main/java`](src-gen/main/java). The
`build-helper-maven-plugin` then adds that directory as an additional compile source root.

```
../model (.cqrs)  ──▶  src-gen/main/java (generated)  ──▶  cqrs-country-codes-java.jar
```

Generation configuration: [`srcgen4j-config.xml`](srcgen4j-config.xml). Its `modelPath` points at
this context's own model only; imports of the `cqrs-common` context are resolved (for cross
references, not regenerated) via [`../model/dependencies.json`](../model/dependencies.json).

## Dependency on `cqrs-common`

The generated value objects use the `cqrs-common` constraints as invariants, so the generated
code references `org.fuin.dsl.cqrs.common.constraints.*` (e.g. `@Pattern`, `@Length`). This module
therefore depends on the **`cqrs-common-java`** JAR, which supplies those constraint annotations
and their validators:

```xml
<dependency>
    <groupId>org.fuin.dsl.cqrs.contexts</groupId>
    <artifactId>cqrs-common-java</artifactId>
    <version>0.1.0-SNAPSHOT</version>
</dependency>
```

## Null-safety

The generated code is `@NullMarked` (JSpecify) and checked at compile time by NullAway via Error
Prone, as configured in the root [`pom.xml`](../../pom.xml).

## Using it as a dependency

```xml
<dependency>
    <groupId>org.fuin.dsl.cqrs.contexts</groupId>
    <artifactId>cqrs-country-codes-java</artifactId>
    <version>0.1.0-SNAPSHOT</version>
</dependency>
```

Released versions come from Maven Central; `-SNAPSHOT` versions from Sonatype Snapshots.

## Building

```bash
../../mvnw -pl :cqrs-country-codes-java -am clean install
```
