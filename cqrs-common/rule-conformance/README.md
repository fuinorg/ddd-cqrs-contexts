# Business-rule conformance vectors

One predicate is answered twice: by a generated Java rule class on the server, and by the Dart evaluator
on the client. Two implementations of one semantics drift, and the way that drift shows up is a button
that quietly stops being offered — no error, no failing build, nothing to notice.

`vectors.json` is the shared table that turns drift into a failing test. Each entry is a predicate, the
attribute values to answer it with, and the expected verdict. It lives here rather than under `java/` or
`dart/` because the point is that both read the same file.

**Today only the Dart half runs it** (`dart/test/rule_conformance_test.dart`). There is no Java
evaluator to run it against: on the server the semantics live in generated code, so the Java half of
conformance arrives with the generator that produces rule classes, by generating them from a fixture
model whose predicates are these vectors.

Every form the melkheftken corpus uses is covered, and each vector says which rule it stands for.
Values are **wire values** — a bool for a Boolean, the wire name for an instance of an enumeration, an
ISO-8601 string for a date, a list for a collection.
