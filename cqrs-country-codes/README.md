# cqrs-country-codes

Grouping module for the reusable **"country-codes"** CQRS context — the
[ISO 3166](https://www.iso.org/iso-3166-country-codes.html) country and subdivision codes. It
aggregates two submodules:

| Module | Folder | Description |
| ------ | ------ | ----------- |
| [`cqrs-country-codes-model`](model/README.md) | `model` | The **"country-codes"** CQRS DSL context — the `.cqrs` source files. Published as a `tar.gz` (classifier `cqrs`). |
| [`cqrs-country-codes-java`](java/README.md) | `java` | The **Java code generated** from the model. Built into a JAR. |

This module has `pom` packaging and produces no artifacts of its own beyond the aggregator POM.

## Reuse of `cqrs-common`

The model **imports the `cqrs-common` context** (`org.fuin.dsl.cqrs.common.*`) and uses its
constraints (`Pattern`, `Length`) as invariants on the country-code value objects:
- in the **model**, the common namespaces are resolved as external types via
  [`model/dependencies.json`](model/dependencies.json) (a `local` entry points at the sibling
  `cqrs-common` source, so the reactor build resolves imports with no download);
- in the **java** module, the generated code references
  `org.fuin.dsl.cqrs.common.constraints.*`, so `cqrs-country-codes-java` depends on the
  `cqrs-common-java` JAR.

Part of [ddd-cqrs-contexts](../README.md). See each submodule's README for details.
