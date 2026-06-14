# cqrs-common-model

The reusable **"common"** CQRS DSL context. This module contains only the DSL source — the
single source of truth from which Java (and potentially other artifacts) is generated.

Part of [ddd-cqrs-contexts](../README.md).

## Contents

The model is written in the fuin.org DDD/CQRS DSL under
[`src/main/cqrs`](src/main/cqrs), split into namespaces of the `common` context:

| File | Namespace | What it defines |
| ---- | --------- | --------------- |
| `types.cqrs` | `common.types` | Basic types mapped directly to Java types (`Byte`, `Integer`, `String`, `Date`, ...). |
| `basics.cqrs` | `common.basics` | Reusable value objects and enums (e.g. `EmailAddress`, `PhoneNumber`, `PostalAddress`, `GdprProtectionLevel`). |
| `constr.cqrs` | `common.constraints` | Reusable constraints (length, min/max value, pattern, not-empty, ...). |
| `exceptions.cqrs` | `common.exceptions` | Reusable domain exceptions (e.g. `DuplicateNameException`, `LimitExceededException`). |

## Packaging

This module has `pom` packaging and produces no Java. During `package` the
[maven-assembly-plugin](src/assembly/cqrs.xml) bundles the `.cqrs` files into:

```
cqrs-common-model-<version>-cqrs.tar.gz
```

The `cqrs` classifier lets other projects depend on and reuse this context as a code-generation
input. The Java generated from it lives in the sibling module
[`cqrs-common-java`](../cqrs-common-java/README.md).

## Reusing this model in another DSL project

Because the context is published as a `tar.gz` Maven artifact (classifier `cqrs`), other `.cqrs`
models can `import` its namespaces. To make them resolve in the Eclipse editor and the headless
generator, add this model to the
[`dependencies.json`](https://github.com/fuinorg/ddd-cqrs-dsl/blob/master/eclipse/README.md)
catalog in the root of the consuming project:

```json
[
  { "type": "maven",
    "namespaces": [
      "common.types",
      "common.basics",
      "common.constraints",
      "common.exceptions"
    ],
    "data": {
      "groupId": "org.fuin.dsl.cqrs.contexts",
      "artifactId": "cqrs-common-model",
      "version": "0.1.0-SNAPSHOT"
    }
  }
]
```

Models can then import any of those namespaces, e.g.:

```
import common.basics.*
import common.constraints.*
```
