# cqrs-common-model

The reusable **"common"** CQRS DSL context. This module contains only the DSL source — the
single source of truth from which Java (and potentially other artifacts) is generated.

Part of [cqrs-common](../README.md) (in [ddd-cqrs-contexts](../../README.md)).

## Contents

The model is written in the fuin.org DDD/CQRS DSL under
[`src/main/cqrs`](src/main/cqrs), split into modules of the `common` context:

| File | Module | What it defines |
| ---- | ------ | --------------- |
| `types.cqrs` | `common.types` | Basic types mapped directly to Java types (`Byte`, `Integer`, `String`, `Date`, ...). |
| `basics.cqrs` | `common.basics` | Reusable value objects and enums (e.g. `EmailAddress`, `PhoneNumber`, `PostalAddress`, `GdprProtectionLevel`). |
| `constr.cqrs` | `common.constraints` | Reusable constraints (length, min/max value, pattern, not-empty, ...). |
| `exceptions.cqrs` | `common.exceptions` | Reusable domain exceptions (e.g. `DuplicateNameException`, `LimitExceededException`). |

## Packaging

The models *are* the artifact. `src/main/cqrs` is packaged as a resource under `model/`, so ordinary
`jar` packaging produces:

```
cqrs-common-model-<version>.jar
    model/types.cqrs
    model/basics.cqrs
    ...
```

No classifier and no assembly: a consumer simply depends on
`org.fuin.dsl.cqrs.contexts:cqrs-common-model:<version>`. The `model/` folder keeps the models apart
from anything else the jar carries, and a consuming editor or build reads them **straight out of this
jar in the local repository** - nothing is ever unpacked. The Java generated from the model lives in
the sibling module [`cqrs-common-java`](../java/README.md).

## Reusing this model in another DSL project

Because the context is published as an ordinary Maven jar, other `.cqrs` models can reuse it by
declaring it as a `dependency` on their `context` (where it applies to every module) or on a single
`module`. The dependency makes the models resolvable; an `import` then decides
which of their types are visible:

```
context com.acme.shop {

    dependency "org.fuin.dsl.cqrs.contexts:cqrs-common-model:0.1.0-SNAPSHOT"

    module ordering {
        import org.fuin.dsl.cqrs.common.types.*

        value-object OrderName base String {
            String value
        }
    }

}
```

The dependency makes every module this artifact declares - `types`, `basics`, `constraints`,
`exceptions` - resolvable, with no external catalog file; each `import` above then picks what is
actually visible. A whole context can be pulled in at once with `import org.fuin.dsl.cqrs.*`. The
artifact is resolved from the local `~/.m2/repository` first, otherwise from Maven Central or the
snapshot repository, and unpacked once into a `.dependencies-cache` directory next to the model that
declares it.

While developing an unpublished change to this model, add a `local` clause to read the `.cqrs` files
straight from this directory instead of resolving the artifact:

```
dependency "org.fuin.dsl.cqrs.contexts:cqrs-common-model:0.1.0-SNAPSHOT" local "../ddd-cqrs-contexts/cqrs-common/model/src/main/cqrs"
```
