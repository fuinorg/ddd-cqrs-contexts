# private

The part of the model that is **not** published. Everything here is parsed and generated exactly like
the public part, but the assembly (`../../assembly/model.xml`) never names this folder, so none of it
reaches the zip.

Put a model here when it is an internal detail of this project: a type that other projects should not
depend on, or one that is not ready to be committed to yet. Keep in mind that nothing enforces the
split - a public model referencing a private type would publish a zip with a dangling reference.

It also holds `artifact2Target.js`. That script names the Maven module and folder a generated file is
written to, which only means something to the project doing the generating: a consumer always uses its
own, never ours. `model2JavaPackage.js` is the opposite case and therefore lives in
[`../public`](../public).
