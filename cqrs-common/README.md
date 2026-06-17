# cqrs-common

Grouping module for the reusable **"common"** CQRS context. It aggregates two submodules:

| Module | Folder | Description |
| ------ | ------ | ----------- |
| [`cqrs-common-model`](model/README.md) | `model` | The **"common"** CQRS DSL context — the `.cqrs` source files. Published as a `tar.gz` (classifier `cqrs`). |
| [`cqrs-common-java`](java/README.md) | `java` | The **Java code generated** from the model, plus hand-written validators and tests. Built into a JAR. |

This module has `pom` packaging and produces no artifacts of its own beyond the aggregator POM.
The submodules keep their original Maven coordinates
(`org.fuin.dsl.cqrs.contexts:cqrs-common-model` and `:cqrs-common-java`).

Part of [ddd-cqrs-contexts](../README.md). See each submodule's README for details.
