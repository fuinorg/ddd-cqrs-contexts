# cqrs-country-codes-model

The reusable **"country-codes"** CQRS DSL context: the [ISO 3166](https://www.iso.org/iso-3166-country-codes.html)
country and subdivision codes. This module contains only the DSL source — the single source of
truth from which Java (and potentially other artifacts) is generated.

Part of [cqrs-country-codes](../README.md) (in [ddd-cqrs-contexts](../../README.md)).

## Contents

The model is written in the fuin.org DDD/CQRS DSL under
[`src/main/cqrs`](src/main/cqrs) in the `org.fuin.dsl.cqrs.countrycodes` context,
namespace `codes`:

| Value object | ISO 3166 part | What it represents |
| ------------ | ------------- | ------------------ |
| `Alpha2Code` | 3166-1 | Two-letter country code, e.g. `DE`, `US`. |
| `Alpha3Code` | 3166-1 | Three-letter country code, e.g. `DEU`, `USA`. |
| `NumericCode` | 3166-1 | Three-digit country code (kept as a string to preserve leading zeros), e.g. `276`, `004`. |
| `SubdivisionCode` | 3166-2 | Alpha-2 code, a separator and up to three alphanumerics, e.g. `ID-RI`, `NG-RI`. |

## Reuse of the `cqrs-common` context

The model imports the `cqrs-common` namespaces and uses its constraints as invariants:

```
import org.fuin.dsl.cqrs.common.types.*
import org.fuin.dsl.cqrs.common.constraints.*

value-object Alpha2Code {
    String value invariants Pattern("[A-Z]{2}") { examples "DE" "US" }
}
```

These cross-context imports are resolved during the build via the
[`dependencies.json`](dependencies.json) catalog read by the DSL's standalone setup
(`org.fuin.dsl.cqrs.scoping`). Each entry maps the provided namespaces to the Maven artifact that
holds them (`org.fuin.dsl.cqrs.contexts:cqrs-common-model`, classifier `cqrs`); the optional
`local` directory points straight at the sibling `cqrs-common` source so the reactor build
resolves the imports offline (no artifact download). The imported model is used for **reference
resolution only** — it is not regenerated here.

## Packaging

This module has `pom` packaging and produces no Java. During `package` the
[maven-assembly-plugin](src/assembly/cqrs.xml) bundles the `.cqrs` files into:

```
cqrs-country-codes-model-<version>-cqrs.tar.gz
```

The `cqrs` classifier lets other projects depend on and reuse this context as a code-generation
input. The Java generated from it lives in the sibling module
[`cqrs-country-codes-java`](../java/README.md).
