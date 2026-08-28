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

  /// The same condition with every attribute name replaced by what [names] calls it.
  ///
  /// A rule names its own attributes; the thing it is about names them however it likes, and the
  /// binding between the two is per usage. Two rules can only be compared once both are written in the
  /// second vocabulary - which is what [contradicts] needs, and the only reason this exists.
  RulePredicate rename(Map<String, String> names);

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
            final Map<String, dynamic> r when r['kind'] == 'literal' =>
              RuleLiteralOperand(r['value']),
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

  @override
  RulePredicate rename(Map<String, String> names) => RuleAttrRef(names[attribute] ?? attribute);

  @override
  bool operator ==(Object other) => other is RuleAttrRef && other.attribute == attribute;

  @override
  int get hashCode => Object.hash(RuleAttrRef, attribute);
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

  @override
  RulePredicate rename(Map<String, String> names) => RuleIsEmpty(names[attribute] ?? attribute);

  @override
  bool operator ==(Object other) => other is RuleIsEmpty && other.attribute == attribute;

  @override
  int get hashCode => Object.hash(RuleIsEmpty, attribute);
}

/// Negation.
final class RuleNot extends RulePredicate {
  /// Constructor with the expression this negates.
  const RuleNot(this.expr);

  /// What is negated.
  final RulePredicate expr;

  @override
  bool evaluate(Map<String, Object?> values) => !expr.evaluate(values);

  @override
  RulePredicate rename(Map<String, String> names) => RuleNot(expr.rename(names));

  @override
  bool operator ==(Object other) => other is RuleNot && other.expr == expr;

  @override
  int get hashCode => Object.hash(RuleNot, expr);
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

  @override
  RulePredicate rename(Map<String, String> names) =>
      RuleAnd(left.rename(names), right.rename(names));

  @override
  bool operator ==(Object other) => other is RuleAnd && other.left == left && other.right == right;

  @override
  int get hashCode => Object.hash(RuleAnd, left, right);
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

  @override
  RulePredicate rename(Map<String, String> names) =>
      RuleOr(left.rename(names), right.rename(names));

  @override
  bool operator ==(Object other) => other is RuleOr && other.left == left && other.right == right;

  @override
  int get hashCode => Object.hash(RuleOr, left, right);
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

/// The right hand side of a comparison: another attribute, a named value of an enumeration, a value
/// written out in the condition, or null.
sealed class RuleOperand {
  const RuleOperand();

  /// The same operand with an attribute name replaced by what [names] calls it.
  RuleOperand rename(Map<String, String> names) => this;

  /// Whether this stands for a value fixed by the rule rather than read off the thing being judged.
  ///
  /// Two `==` against *different* fixed values cannot both hold, which is how one enum value is seen
  /// to exclude another. Against an attribute nothing can be said: both sides may move.
  bool get fixed => true;
}

/// Another of the rule's own attributes.
final class RuleAttributeOperand extends RuleOperand {
  /// Constructor with the attribute's name.
  const RuleAttributeOperand(this.name);

  /// Name of the rule attribute holding the value.
  final String name;

  @override
  RuleOperand rename(Map<String, String> names) => RuleAttributeOperand(names[name] ?? name);

  @override
  bool get fixed => false;

  @override
  bool operator ==(Object other) => other is RuleAttributeOperand && other.name == name;

  @override
  int get hashCode => Object.hash(RuleAttributeOperand, name);
}

/// A named value of an enumeration, as it travels on the wire.
final class RuleValueOperand extends RuleOperand {
  /// Constructor with the wire value.
  const RuleValueOperand(this.value);

  /// The instance's name on the wire - `IGNORED`, not the Dart constant.
  final String value;

  @override
  bool operator ==(Object other) => other is RuleValueOperand && other.value == value;

  @override
  int get hashCode => Object.hash(RuleValueOperand, value);
}

/// A value written out in the condition itself, such as the `0` in `referenceCount == 0`.
///
/// It carries the value rather than a name to look up: the boundary is part of the rule, not of the
/// state being judged, so there is nothing for a caller to supply.
final class RuleLiteralOperand extends RuleOperand {
  /// Constructor with the value.
  const RuleLiteralOperand(this.value);

  /// The value itself - a number, a string or a bool.
  final Object? value;

  @override
  bool operator ==(Object other) => other is RuleLiteralOperand && other.value == value;

  @override
  int get hashCode => Object.hash(RuleLiteralOperand, value);
}

/// Absence.
final class RuleNullOperand extends RuleOperand {
  /// Constructor.
  const RuleNullOperand();

  @override
  bool operator ==(Object other) => other is RuleNullOperand;

  @override
  int get hashCode => (RuleNullOperand).hashCode;
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
      RuleLiteralOperand(:final value) => value,
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

  @override
  RulePredicate rename(Map<String, String> names) =>
      RuleComparison(names[attribute] ?? attribute, operator, right.rename(names));

  @override
  bool operator ==(Object other) =>
      other is RuleComparison &&
      other.attribute == attribute &&
      other.operator == operator &&
      other.right == right;

  @override
  int get hashCode => Object.hash(RuleComparison, attribute, operator, right);
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

/// Whether [a] and [b] cannot both hold, so that one being satisfied explains the other's absence.
///
/// **What this is for.** A menu hides an action whose rule fails, and an absent action is only
/// readable when its opposite is standing there instead - `reopen` where `ignore` was. Deciding that
/// is deciding whether two conditions exclude each other, which the shapes below answer without
/// anyone declaring a pairing.
///
/// Both predicates must already be written in the same vocabulary - see [RulePredicate.rename] -
/// because two rules name the same value whatever each of them likes.
///
/// Says `false` whenever it cannot see an exclusion. That is the safe answer: it shows the action
/// disabled with its reason rather than removing it and leaving nothing behind.
bool contradicts(RulePredicate a, RulePredicate b) {
  if (a is RuleNot && a.expr == b) {
    return true;
  }
  if (b is RuleNot && b.expr == a) {
    return true;
  }
  if (a is RuleComparison && b is RuleComparison && a.attribute == b.attribute) {
    if (a.right == b.right) {
      return _opposed(a.operator, b.operator);
    }
    // `kind == COMPANY` and `kind == PERSON` are not negations of one another and still cannot both
    // hold. Two-valued enumerations are how this model spells most of its either/ors.
    return a.operator == CompareOp.eq &&
        b.operator == CompareOp.eq &&
        a.right.fixed &&
        b.right.fixed;
  }
  return false;
}

/// Whether two operators are each other's opposite over the same two sides.
bool _opposed(CompareOp a, CompareOp b) => switch ((a, b)) {
      (CompareOp.eq, CompareOp.ne) || (CompareOp.ne, CompareOp.eq) => true,
      (CompareOp.lt, CompareOp.ge) || (CompareOp.ge, CompareOp.lt) => true,
      (CompareOp.le, CompareOp.gt) || (CompareOp.gt, CompareOp.le) => true,
      _ => false,
    };
