import 'package:cqrs_common/src/rules/rule_predicate.dart';

/// One business rule as a client can answer it, and where to get the values from.
///
/// **Advisory, and stale by definition.** A business rule exists precisely where the caller cannot
/// guarantee the state, so this can only ever say "the server would probably refuse". It is for
/// deciding whether to *offer* an action, never for deciding whether one is allowed - the server
/// answers that, authoritatively, with a typed refusal.
///
/// **Only a rule a client can actually answer is described.** The model says what each rule is handed:
/// a value the carrier holds, the carrier's own identity, a parameter of the operation, or the answer
/// to a service call. The last two are not on the client at all - a parameter has not been typed yet,
/// and a service call is a question only the server can ask - so a rule needing either is left out
/// rather than half-described. That is the model answering "can a client decide this", instead of
/// anyone reading the Java to find out.
class RuleDescriptor {
  /// Constructor with all data.
  const RuleDescriptor({
    required this.rule,
    required this.predicate,
    this.fromAttribute = const <String, String>{},
    this.fromIdentity = const <String>[],
  });

  /// The rule's name in the model, which is also what a reader looks up when a refusal arrives.
  final String rule;

  /// The condition, as the same tree the JVM generates its check from.
  final RulePredicate predicate;

  /// What the rule calls a value, against what the thing it is about calls it.
  ///
  /// The two differ because the actuals are bound where the rule is used: one rule carried by two
  /// operations is handed the same value under whatever name each of them has for it.
  final Map<String, String> fromAttribute;

  /// The rule's own names for values that are the identity of the thing being acted on.
  final List<String> fromIdentity;

  /// Whether the rule holds, given a way to read the thing's attributes and its identity.
  ///
  /// Throws [RuleEvaluationException] when it cannot decide - a value is missing, or is not the shape
  /// the condition expects. A caller treats that as *offer the action*: guessing "violated" hides
  /// something the server would have allowed, which is indistinguishable from a missing feature.
  bool holdsFor(Object? Function(String) read, String? identity) {
    final values = <String, Object?>{};
    for (final entry in fromAttribute.entries) {
      try {
        values[entry.key] = read(entry.value);
      } on ArgumentError {
        // A generated row refuses a name it does not carry, which is right for a renderer reading a
        // descriptor. Here it is one more way of not being able to decide, and a caller should have
        // exactly one of those to handle.
        throw RuleEvaluationException(
            "'${entry.value}' is not something this row carries, so $rule cannot be decided");
      }
    }
    for (final name in fromIdentity) {
      values[name] = identity;
    }
    return predicate.evaluate(values);
  }
}
