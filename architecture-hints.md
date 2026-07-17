# Architecture hints

Non-obvious facts about how this repo's CQRS-DSL → Java code generation works. Learned by reading
the `srcgen4j` and `ddd-cqrs-dsl` sources in `~/.m2`; captured here to save the next person the dig.

## Module structure

- Each bounded context is a group module (`pom` packaging) with two submodules:
  `model/` (the `.cqrs` DSL source, published as a `tar.gz` with classifier `cqrs`) and
  `java/` (the generated Java, a JAR). The group module is also the Maven **parent** of its
  submodules; it inherits dependency/plugin management transitively from the root pom.
- Artifact ids keep the long form (`cqrs-common-java`) even though the folders are short
  (`java/`). Coordinates are independent of folder layout.

## Code generation (`srcgen4j` + `ddd-templates`)

- Generation runs in the `java` module during `process-sources` via `srcgen4j-maven-plugin`,
  driven by `<module>/java/srcgen4j-config.xml`. `build-helper-maven-plugin` then adds
  `src-gen/main/java` as a compile source root. Generated sources **are committed** to git.
- **Paths in `srcgen4j-config.xml` are relative to the reactor root** (the dir where `mvn` runs),
  not the module — they embed the module folder name, e.g.
  `cqrs-common/java/src-gen/main/java`. Moving a module means editing these.
- A `<folder>` that doesn't exist yet needs `create="true"`. Existing modules "work" with the
  default only because their `src-gen` is already committed; a brand-new module fails without it.
- The generator runs the model through **two passes** (`AbstractEMFGenerator`): a preparation
  pass over everything (to populate the cross-reference registry) and a real pass that only emits
  **primary** resources.

## External types

- `org.fuin.dsl.ddd.gen.resourceset.CtxExternalTypes` hard-codes the mapping of any context's
  `types` namespace to Java types (`String`→`java.lang.String`, `List`→`java.util.List`,
  `Binary`→`byte[]`, `Date/Time/Timestamp`→`java.time.*` overridable via config variables, etc.).
- There is no mapping file, and **declaring `type X` is not enough**: the type only has a Java class
  if `CtxExternalTypes` also carries a `refReg.putReference(name + "." + pkg + ".X", X.name)` line
  for it. Adding a type therefore means changing two repos — `types.cqrs` here and the generator in
  `ddd-cqrs-dsl`. To check the two lists agree, compare
  `grep -oP '^\s*type \K\w+' types.cqrs` with
  `grep -oP 'putReference\(.*pkg \+ "\.\K\w+' CtxExternalTypes.xtend`.

## Reusing another context's model (the key mechanism)

- A model reuses another context by **importing its namespaces** (`import
  org.fuin.dsl.cqrs.common.constraints.*`). Imports are resolved during the headless build by
  `org.fuin.dsl.cqrs.scoping.*` (wired into `CqrsDslStandaloneSetup`), via a **`dependencies.json`**
  catalog discovered by walking **up** from the `.cqrs` file's directory.
- Each catalog entry lists the **full** namespaces it provides
  (`org.fuin.dsl.cqrs.common.constraints`, matching the import string — *not* a short alias) and a
  Maven GAV (classifier `cqrs`, type `tar.gz`). An optional **`local`** dir (in `data`, resolved
  relative to the catalog) is read directly with **no download/cache/network** — the right choice
  for a sibling model in the same reactor. Otherwise the artifact is fetched and unpacked under
  `.dependencies-cache/`.
- **Imported models are resolved-only, never regenerated.** Only resources parsed from `modelPath`
  are "primary" (`PrimaryResources`); lazily-loaded dependency models are skipped by the generator.
  So keep `modelPath` pointed at the module's own model and let `dependencies.json` handle imports.
  (`modelPath` does support multiple `;`-separated dirs, but you don't need that here.)
- The **Java-side dependency** on the other context's JAR does *not* follow from using its
  constraints: a mapped constraint emits a `jakarta.validation.constraints.*` annotation, so nothing
  in the generated code points at the producing context (the only imports the generated VOs carry
  today are `jakarta.validation.constraints.Size`). The dependency is needed when the model
  references the other context's **types** — a value object, an enum, an entity id — or an
  **unmapped** constraint, whose annotation *is* generated into the producing context. Declaring it
  also fixes the reactor build order, which is why `cqrs-country-codes/java` depends on
  `cqrs-common-java`.

## Constraints → Java annotations

- A constraint is mapped to existing Java annotations by the **`constraintMappings`** list of the
  `SrcGen4J` hint (`<module>/model/src/main/cqrs/aaa.cqrs`), in the form `DSL=JAVA`:
  `org.fuin.dsl.cqrs.common.constraints.Length(min,max)=jakarta.validation.constraints.Size(min=min,max=max)`.
  The DSL parameter list is positional, the Java side names its attributes, and one constraint may
  map to several annotations (`ValueRange(min,max)` → `@Min` + `@Max`).
- The mappings are read from the hint of the model that **declares** the constraint, so a model that
  only imports it maps it the same way without repeating anything.
- **A mapped constraint generates no annotation and no validator of its own** — the factories bail
  out (`ValidatorAnnotationArtifactFactory` / `ValidatorArtifactFactory`). Only an **unmapped**
  constraint generates one: `NoNullElements` is currently the single unmapped constraint of
  `cqrs-common`, and correspondingly the only one with a generated `NoNullElements` annotation plus
  a hand-written `NoNullElementsValidator`.
- A constraint with **more than one `input` type** can never generate an annotation of its own
  (the factory skips it), so such a constraint *has* to be mapped or its usages reference a class
  that does not exist.

## Value-object generation quirks

- Field `invariants` are rendered as the mapped Java annotations, for wrapper and multi-field VOs
  alike: `String value invariants Length(3,320)` on `EmailAddress` becomes `@Size(min=3, max=320)`.
  Validation runs through Bean Validation (the constructor only enforces non-null); test with
  Hibernate Validator.
- **`base String` wrapper VOs** additionally generate a `@XxxStr` annotation whose validator
  delegates to the VO's `isValid(String)`, which in turn validates the `value` field
  (`Validators.get().validateValue(EmailAddress.class, "value", value)`) — so the declared
  invariants *are* enforced through that annotation too.
- `base String` **plus exactly one attribute** is generated as one complete final class
  (`SimpleStringValueObjectArtifactFactory`). **Every other shape** — including a `base` with
  several attributes, e.g. `PhoneNumber` (`base String` holding `PhoneType` + the number) — is
  generated as an abstract base class plus a final class that goes to the **non-generated** sources
  and supplies `asBaseType()`. Deleting that hand-written class loses real code.

## Build
- Build & verify with `./mvnw clean install -s settings.xml` from the root.
