# Business-rule conformance vectors

One predicate is answered twice: by a generated Java rule class on the server, and by the Dart evaluator
on the client. Two implementations of one semantics drift, and the way that drift shows up is a button
that quietly stops being offered — no error, no failing build, nothing to notice.

`vectors.json` is the shared table that turns drift into a failing test. Each entry is a predicate, the
attribute values to answer it with, and the expected verdict. It lives here rather than under `java/` or
`dart/` because the point is that both read the same file.

**Both halves run it now.**

- Dart: `dart/test/rule_conformance_test.dart`, against the evaluator in `cqrs_common`.
- Java: `conformance/`, against the classes the generator actually produces. There is no Java
  evaluator to compare with - on the server the semantics *are* the generated code - so that module
  holds a fixture model whose rules are these vectors one for one, generates rule classes from it with
  the same templates every real model uses, and drives them from this file by reflection.

The fixture declares plain types on purpose. A value here is a **wire** value, so it is handed to a
generated constructor as it stands, and the only conversions the Java test performs are the two the wire
cannot express by itself: the name of an enumeration instance, and an ISO-8601 date. Anything more would
be a third implementation of the semantics, sitting between the two this file exists to compare.

Every form the melkheftken corpus uses is covered, and each vector says which rule it stands for. A
vector's rule name is a label, and it has to keep telling the truth: `CategoryTypeMustMatch` used to
stand for "two attributes compared with each other" and no longer has that shape - a receipt's type and
a category's type are separate enumerations, which is a comparison the language now refuses - so the
vector moved to `EditMustNotConflictWithAssignment`, which does.
Values are **wire values** — a bool for a Boolean, the wire name for an instance of an enumeration, an
ISO-8601 string for a date, a list for a collection.
