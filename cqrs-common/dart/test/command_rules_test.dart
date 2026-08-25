import 'package:cqrs_common/cqrs_common.dart';
import 'package:test/test.dart';

Object? Function(String) row(Map<String, Object?> values) => (name) => values.containsKey(name)
    ? values[name]
    : throw ArgumentError("no attribute '$name'");

CommandDescriptor command(List<RuleDescriptor> rules) => CommandDescriptor(
      type: 'UnassignReceiptCommand',
      module: 'receipts',
      target: 'Receipt',
      kind: CommandKind.modify,
      doc: 'Clears the assignment.',
      message: 'Clear the assignment',
      rules: rules,
    );

void main() {
  const mustBeAssigned = RuleDescriptor(
    rule: 'MustBeAssigned',
    predicate: RuleComparison('assignedEntry', CompareOp.ne, RuleNullOperand()),
    fromAttribute: <String, String>{'assignedEntry': 'assignedEntry'},
  );

  test('an action certain to be refused can be left out of a screen', () {
    expect(
      command(<RuleDescriptor>[mustBeAssigned])
          .refusedFor(row(<String, Object?>{'assignedEntry': null}), null),
      isTrue,
    );
  });

  test('and one the rules allow is offered', () {
    expect(
      command(<RuleDescriptor>[mustBeAssigned])
          .refusedFor(row(<String, Object?>{'assignedEntry': 'JOURNAL_ENTRY 7'}), null),
      isFalse,
    );
  });

  test('a rule it cannot decide leaves the action offered', () {
    // The server is authoritative either way, and hiding something it would have allowed looks
    // exactly like a missing feature.
    expect(
      command(<RuleDescriptor>[mustBeAssigned]).refusedFor(row(const <String, Object?>{}), null),
      isFalse,
    );
  });

  test('no rules means nothing can be decided here, not that nothing guards it', () {
    // Every command is guarded on the server; this list is only the part a client can answer.
    expect(command(const <RuleDescriptor>[]).refusedFor(row(const <String, Object?>{}), null), isFalse);
  });
}
