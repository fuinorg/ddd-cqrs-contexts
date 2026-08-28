import 'package:cqrs_common/cqrs_common.dart';
import 'package:test/test.dart';

/// A row, answering by name and refusing what it does not carry - as a generated row does.
Object? Function(String) row(Map<String, Object?> values) => (name) => values.containsKey(name)
    ? values[name]
    : throw ArgumentError("no attribute '$name'");

void main() {
  group('a rule a client can answer', () {
    const mustBeAssigned = RuleDescriptor(
      rule: 'MustBeAssigned',
      predicate: RuleComparison('assignedEntry', CompareOp.ne, RuleNullOperand()),
      reason: r'Receipt ${receipt} is not assigned to a journal entry',
      fromAttribute: <String, String>{'assignedEntry': 'assignedEntry'},
    );

    test('holds when the row says so', () {
      expect(mustBeAssigned.holdsFor(row(<String, Object?>{'assignedEntry': 'JOURNAL_ENTRY 7'}), null),
          isTrue);
    });

    test('and does not when it says otherwise', () {
      expect(mustBeAssigned.holdsFor(row(<String, Object?>{'assignedEntry': null}), null), isFalse);
    });
  });

  test('the rule and the thing may call the same value different things', () {
    // The actuals are bound where the rule is used, so one rule carried by two operations is handed
    // the same value under whatever name each of them has for it.
    const rule = RuleDescriptor(
      rule: 'MustHaveNoLinks',
      predicate: RuleIsEmpty('entries'),
      reason: 'It still has journal-entry links',
      fromAttribute: <String, String>{'entries': 'linkedEntries'},
    );

    expect(rule.holdsFor(row(<String, Object?>{'linkedEntries': <String>[]}), null), isTrue);
    expect(rule.holdsFor(row(<String, Object?>{'linkedEntries': <String>['x']}), null), isFalse);
  });

  test('the identity is not an attribute, so it arrives separately', () {
    // An aggregate states its identity as "identifier" and never as an attribute; a rule is handed it
    // with "own-id", which is what lets a refusal name the thing it refused.
    const rule = RuleDescriptor(
      rule: 'MustStillExist',
      predicate: RuleComparison('receipt', CompareOp.ne, RuleNullOperand()),
      reason: 'It is gone',
      fromIdentity: <String>['receipt'],
    );

    expect(rule.holdsFor(row(const <String, Object?>{}), 'RECEIPT r-1'), isTrue);
    expect(rule.holdsFor(row(const <String, Object?>{}), null), isFalse);
  });

  test('a value the row does not carry means "cannot say", not "violated"', () {
    // Which the caller turns into offering the action. Hiding something the server would have allowed
    // looks exactly like a missing feature.
    const rule = RuleDescriptor(
      rule: 'MustBeAssigned',
      predicate: RuleComparison('assignedEntry', CompareOp.ne, RuleNullOperand()),
      reason: r'Receipt ${receipt} is not assigned to a journal entry',
      fromAttribute: <String, String>{'assignedEntry': 'assignedEntry'},
    );

    expect(
      () => rule.holdsFor(row(const <String, Object?>{'somethingElse': 1}), null),
      throwsA(isA<RuleEvaluationException>()),
    );
  });
}
