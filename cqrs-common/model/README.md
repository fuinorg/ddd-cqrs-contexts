# cqrs-common-model

The reusable **"common"** CQRS DSL context. This module contains only the DSL source — the
single source of truth from which Java (and potentially other artifacts) is generated.

Part of [cqrs-common](../README.md) (in [ddd-cqrs-contexts](../../README.md)).

## Contents

The model is written in the fuin.org DDD/CQRS DSL under [`src/main/model`](src/main/model), split into
a [`public`](src/main/model/public) and a [`private`](src/main/model/private) part. Only the public one
is published; everything below is public today:

| File | Module | What it defines |
| ---- | ------ | --------------- |
| `types.cqrs` | `common.types` | Basic types mapped directly to Java types (`Byte`, `Integer`, `String`, `Date`, ...). |
| `basics.cqrs` | `common.basics` | Reusable value objects and enums (e.g. `EmailAddress`, `PhoneNumber`, `PostalAddress`, `GdprProtectionLevel`). |
| `constr.cqrs` | `common.constraints` | Reusable constraints (length, min/max value, pattern, not-empty, ...). |
| `exceptions.cqrs` | `common.exceptions` | Reusable domain exceptions (e.g. `DuplicateNameException`, `LimitExceededException`). |

## Packaging

The models *are* the artifact, and they are data - nothing in here ever belongs on a classpath, so it
is published as a plain **zip** rather than a jar. `src/main/model/public` is copied by
[an assembly](src/main/assembly/model.xml) keeping its folder:

```
cqrs-common-model-<version>.zip
    model/public/types.cqrs
    model/public/basics.cqrs
    ...
    model/public/model2JavaPackage.js
```

`src/main/model/private` is not named there and so cannot leak. There is no classifier: a consumer
simply resolves `org.fuin.dsl.cqrs.contexts:cqrs-common-model:<version>` with type `zip`. The `model/`
folder keeps the models apart from anything else the archive may carry, and a consuming editor or
build reads them **straight out of this zip in the local repository** - nothing is ever unpacked. The
Java generated from the model - from *both* parts - lives in the sibling module
[`cqrs-common-java`](../java/README.md).

### The two scripts

`aaa.cqrs` declares a `SrcGen4J` hint naming two JavaScript files. A script path is written from the
enclosing `model` folder, so it names the part the script lies in and reads the same here and inside
the zip:

| Script | Where | Why |
| ------ | ----- | --- |
| `model2JavaPackage.js` | `public/` | A consumer runs *our* copy to resolve an imported type to the Java package it was really generated into, so it has to travel with the models. |
| `artifact2Target.js` | `private/` | Names the Maven module a generated file goes to. That only means something to the project doing the generating, which always uses its own - so ours stays out of the zip. |

## Reusing this model in another DSL project

Because the context is published as a Maven artifact, other `.cqrs` models can reuse it by
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
snapshot repository, and read in place - nothing is unpacked.

While developing an unpublished change to this model, add a `local` clause to read the `.cqrs` files
straight from the public folder instead of resolving the artifact:

```
dependency "org.fuin.dsl.cqrs.contexts:cqrs-common-model:0.1.0-SNAPSHOT" local "../ddd-cqrs-contexts/cqrs-common/model/src/main/model/public"
```
