/// The condition a business rule verifies, as data a client can answer for itself.
///
/// **Why the client has a copy at all.** A rule is authoritative on the server, where it is a generated
/// class that throws a typed refusal. A client cannot use that: it has no exception to catch before it
/// has sent anything, and what it wants is not a refusal but a decision about whether to offer an
/// action. So the same predicate travels as data and is evaluated here - advisory, and stale by
/// definition, because a business rule exists precisely where the caller cannot guarantee the state.
///
/// The shape mirrors the DSL's own expression grammar one for one, which is what keeps the two ends
/// from drifting as the language grows: a bare Boolean attribute, a comparison, the one built-in
/// question about a collection, and the three operators.
sealed class RulePredicate {
  const RulePredicate();

  /// Whether the rule holds for [values], which are attribute values **as they travel on the wire**:
  /// a bool for a Boolean, the wire name for an instance of an enumeration, an ISO-8601 string for a
  /// date, a list for a collection.
  ///
  /// Throws [RuleEvaluationException] when it cannot decide - a value it needs is absent, or is not
  /// the shape the predicate expects. A caller treats that as "cannot say", which for an advisory
  /// check means offering the action rather than hiding it.
  bool evaluate(Map<String, Object?> values);

  /// Reads a predicate out of the conformance vectors, which are the one place it travels as JSON.
  ///
  /// Generated code builds these as `const` instead; this exists so that a single table of vectors can
  /// be run against this evaluator and, once rule classes are generated, against those.
  factory RulePredicate.fromJson(Map<String, dynamic> json) {
    final op = json['op'] as String;
    return switch (op) {
      'attr' => RuleAttrRef(json['attribute'] as String),
      'isEmpty' => RuleIsEmpty(json['attribute'] as String),
      'not' => RuleNot(RulePredicate.fromJson(json['expr'] as Map<String, dynamic>)),
      'and' => RuleAnd(
          RulePredicate.fromJson(json['left'] as Map<String, dynamic>),
          RulePredicate.fromJson(json['right'] as Map<String, dynamic>),
        ),
      'or' => RuleOr(
          RulePredicate.fromJson(json['left'] as Map<String, dynamic>),
          RulePredicate.fromJson(json['right'] as Map<String, dynamic>),
        ),
      'compare' => RuleComparison(
          json['attribute'] as String,
          CompareOp.values.firstWhere(
            (o) => o.name == json['operator'],
            orElse: () => throw RuleEvaluationException('unknown operator: ${json['operator']}'),
          ),
          switch (json['right']) {
            null => const RuleNullOperand(),
            final Map<String, dynamic> r when r['kind'] == 'null' => const RuleNullOperand(),
            final Map<String, dynamic> r when r['kind'] == 'attribute' =>
              RuleAttributeOperand(r['name'] as String),
            final Map<String, dynamic> r => RuleValueOperand(r['value'] as String),
            _ => throw RuleEvaluationException('unreadable right operand'),
          },
        ),
      _ => throw RuleEvaluationException('unknown predicate: $op'),
    };
  }
}

/// A bare Boolean attribute, which is the whole condition.
final class RuleAttrRef extends RulePredicate {
  /// Constructor with the attribute this asks about.
  const RuleAttrRef(this.attribute);

  /// Name of the rule attribute holding the answer.
  final String attribute;

  @override
  bool evaluate(Map<String, Object?> values) => _bool(attribute, _read(values, attribute));
}

/// Whether a collection attribute holds nothing.
final class RuleIsEmpty extends RulePredicate {
  /// Constructor with the attribute this asks about.
  const RuleIsEmpty(this.attribute);

  /// Name of the rule attribute holding the collection.
  final String attribute;

  @override
  bool evaluate(Map<String, Object?> values) {
    final value = _read(values, attribute);
    if (value is! Iterable) {
      throw RuleEvaluationException("'$attribute' is not a collection: ${value.runtimeType}");
    }
    return value.isEmpty;
  }
}

/// Negation.
final class RuleNot extends RulePredicate {
  /// Constructor with the expression this negates.
  const RuleNot(this.expr);

  /// What is negated.
  final RulePredicate expr;

  @override
  bool evaluate(Map<String, Object?> values) => !expr.evaluate(values);
}

/// Conjunction. Both sides are evaluated only as far as the answer needs, as in the generated Java.
final class RuleAnd extends RulePredicate {
  /// Constructor with both sides.
  const RuleAnd(this.left, this.right);

  /// Left hand side.
  final RulePredicate left;

  /// Right hand side.
  final RulePredicate right;

  @override
  bool evaluate(Map<String, Object?> values) => left.evaluate(values) && right.evaluate(values);
}

/// Disjunction.
final class RuleOr extends RulePredicate {
  /// Constructor with both sides.
  const RuleOr(this.left, this.right);

  /// Left hand side.
  final RulePredicate left;

  /// Right hand side.
  final RulePredicate right;

  @override
  bool evaluate(Map<String, Object?> values) => left.evaluate(values) || right.evaluate(values);
}

/// How a comparison relates its two sides.
enum CompareOp {
  /// Value equality. Never Java's own `==`, which is identity - every attribute here is a value object.
  eq,

  /// Value inequality.
  ne,

  /// Orders two dates.
  lt,

  /// Orders two dates.
  le,

  /// Orders two dates.
  gt,

  /// Orders two dates.
  ge,
}

/// The right hand side of a comparison: another attribute, a named value of an enumeration, or null.
sealed class RuleOperand {
  const RuleOperand();
}

/// Another of the rule's own attributes.
final class RuleAttributeOperand extends RuleOperand {
  /// Constructor with the attribute's name.
  const RuleAttributeOperand(this.name);

  /// Name of the rule attribute holding the value.
  final String name;
}

/// A named value of an enumeration, as it travels on the wire.
final class RuleValueOperand extends RuleOperand {
  /// Constructor with the wire value.
  const RuleValueOperand(this.value);

  /// The instance's name on the wire - `IGNORED`, not the Dart constant.
  final String value;
}

/// Absence.
final class RuleNullOperand extends RuleOperand {
  /// Constructor.
  const RuleNullOperand();
}

/// A comparison of one attribute against another value.
final class RuleComparison extends RulePredicate {
  /// Constructor with the attribute, the operator and what it is compared against.
  const RuleComparison(this.attribute, this.operator, this.right);

  /// Name of the rule attribute on the left.
  final String attribute;

  /// How the two sides are related.
  final CompareOp operator;

  /// What the attribute is compared against.
  final RuleOperand right;

  @override
  bool evaluate(Map<String, Object?> values) {
    final left = _read(values, attribute);
    final other = switch (right) {
      RuleNullOperand() => null,
      RuleValueOperand(:final value) => value,
      RuleAttributeOperand(:final name) => _read(values, name),
    };
    return switch (operator) {
      // Value equality, which is what Objects.equals means on the other side. Absence compares too:
      // "assignedEntry == null" is the whole point of several rules.
      CompareOp.eq => left == other,
      CompareOp.ne => left != other,
      CompareOp.lt => _order(left, other) < 0,
      CompareOp.le => _order(left, other) <= 0,
      CompareOp.gt => _order(left, other) > 0,
      CompareOp.ge => _order(left, other) >= 0,
    };
  }

  /// Orders two dates.
  ///
  /// They arrive as ISO-8601 strings, and for `yyyy-MM-dd` that ordering is chronological - which is
  /// true of the format rather than of strings in general, so it is pinned by its own test. Nothing
  /// but a date is ordered in this language.
  int _order(Object? left, Object? right) {
    if (left is String && right is String) {
      return left.compareTo(right);
    }
    if (left is Comparable && right != null && left.runtimeType == right.runtimeType) {
      return left.compareTo(right);
    }
    throw RuleEvaluationException('cannot order $left against $right');
  }
}

/// The evaluator could not decide.
///
/// Not a verdict: a caller that gets this should offer the action, because the check is advisory and
/// the server will answer authoritatively either way. Guessing "violated" hides a button the server
/// would have allowed, which looks to a user exactly like a missing feature.
class RuleEvaluationException implements Exception {
  /// Constructor with what could not be decided.
  const RuleEvaluationException(this.message);

  /// Why the predicate could not be answered.
  final String message;

  @override
  String toString() => 'RuleEvaluationException: $message';
}

/// The value of one attribute, refusing rather than guessing when the bag does not hold it.
///
/// A name that is not there is a mismatch between the predicate and whatever assembled the values, and
/// on the server it could not happen - the validator constructs the rule with all of them. Treating it
/// as null here would silently turn that mismatch into a verdict.
Object? _read(Map<String, Object?> values, String attribute) {
  if (!values.containsKey(attribute)) {
    throw RuleEvaluationException("no value for '$attribute'");
  }
  return values[attribute];
}

/// The value of a Boolean attribute.
bool _bool(String attribute, Object? value) {
  if (value is! bool) {
    throw RuleEvaluationException("'$attribute' is not a Boolean: ${value.runtimeType}");
  }
  return value;
}
