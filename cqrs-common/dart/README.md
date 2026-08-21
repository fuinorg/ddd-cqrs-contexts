# cqrs-common / dart

The Dart half of the `common` context: the types every model reaches into, plus the runtime the
generated code of *any* model speaks.

Two halves, and the split is the point:

- `lib/src/` is **hand-written and permanent** — the descriptor types, the constraint types, the
  transport interfaces and the JSON helpers. Nothing here knows about any bounded context.
- `lib/src-gen/` is **generated** from `../model/src/main/model` and must not be edited.

Both are committed, because a consumer takes this package straight from git and pub runs no build step
on a dependency:

```yaml
dependencies:
  cqrs_common:
    git:
      url: https://github.com/fuinorg/ddd-cqrs-contexts.git
      path: cqrs-common/dart
      ref: main
```

Regenerate with `mvn -pl cqrs-common/dart generate-sources` from the reactor root.
