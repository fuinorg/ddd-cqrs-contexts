import 'package:cqrs_common/cqrs_common.dart';
import 'package:test/test.dart';

/// A row, answering by name and refusing what it does not carry - as a generated row does.
Object? Function(String) row(Map<String, Object?> values) => (name) => values.containsKey(name)
    ? values[name]
    : throw ArgumentError("no attribute '$name'");

CommandDescriptor command(String type, List<RuleDescriptor> rules) => CommandDescriptor(
      type: type,
      module: 'bankaccounts',
      target: 'AnnualTransactions',
      targetType: 'TRANSACTION',
      kind: CommandKind.modify,
      doc: type,
      message: type,
      rules: rules,
    );

/// The transaction menu of the model, which is the extreme case: five actions, four of them gated.
const mustNotBeIgnored = RuleDescriptor(
  rule: 'MustNotBeIgnored',
  predicate: RuleComparison('status', CompareOp.ne, RuleValueOperand('IGNORED')),
  reason: r'Transaction ${transaction} is ignored',
  text: ModelText(bundle: 'Bankaccounts', key: 'TransactionIgnoredException'),
  fromAttribute: <String, String>{'status': 'status'},
  fromIdentity: <String>['transaction'],
);

const mustBeIgnored = RuleDescriptor(
  rule: 'MustBeIgnored',
  predicate: RuleComparison('status', CompareOp.eq, RuleValueOperand('IGNORED')),
  reason: r'Transaction ${transaction} is not ignored',
  fromAttribute: <String, String>{'status': 'status'},
  fromIdentity: <String>['transaction'],
);

const mustHaveNoLinks = RuleDescriptor(
  rule: 'MustHaveNoLinks',
  predicate: RuleIsEmpty('linkedEntries'),
  reason: r'Transaction ${transaction} still has journal-entry links; unlink them before ignoring it',
  fromAttribute: <String, String>{'linkedEntries': 'linkedEntries'},
  fromIdentity: <String>['transaction'],
);

const mustHaveLinks = RuleDescriptor(
  rule: 'MustHaveLinks',
  predicate: RuleNot(RuleIsEmpty('linkedEntries')),
  reason: r'Transaction ${transaction} has no journal-entry links',
  fromAttribute: <String, String>{'linkedEntries': 'linkedEntries'},
  fromIdentity: <String>['transaction'],
);

List<CommandDescriptor> get transactionMenu => <CommandDescriptor>[
      command('AnnotateTransactionCommand', const <RuleDescriptor>[]),
      command('IgnoreTransactionCommand', const <RuleDescriptor>[mustNotBeIgnored, mustHaveNoLinks]),
      command('ReopenTransactionCommand', const <RuleDescriptor>[mustBeIgnored]),
      command('LinkJournalEntriesCommand', const <RuleDescriptor>[mustNotBeIgnored]),
      command('UnlinkJournalEntriesCommand', const <RuleDescriptor>[mustHaveLinks]),
    ];

Map<String, CommandAvailability> menuFor(Map<String, Object?> values, String? identity) =>
    <String, CommandAvailability>{
      for (final gated in gateCommands(transactionMenu, row(values), identity))
        gated.command.type: gated.availability,
    };

void main() {
  group('the transaction menu', () {
    test('an ignored transaction can in truth do exactly two things', () {
      // Which is the finding T6 started from: the menu was not merely long, it was wrong.
      final menu = menuFor(
        <String, Object?>{'status': 'IGNORED', 'linkedEntries': <String>[]},
        'TRANSACTION 45',
      );
      expect(
        menu.entries
            .where((e) => e.value == CommandAvailability.offered)
            .map((e) => e.key)
            .toList(),
        <String>['AnnotateTransactionCommand', 'ReopenTransactionCommand'],
      );
      expect(menu.values.contains(CommandAvailability.disabled), isFalse);
    });

    test('an open transaction with links offers the unlink that has to happen first', () {
      // The record feared this case: "ignore" and "reopen" both vanish and nothing says the links
      // must go. They do vanish - and "unlink" is standing there, which is what says it. The mirror
      // is per rule, not per command, so "ignore" is explained by "unlink" rather than by "reopen".
      final menu = menuFor(
        <String, Object?>{'status': 'OPEN', 'linkedEntries': <String>['JOURNAL_ENTRY 7']},
        'TRANSACTION 45',
      );
      expect(menu['IgnoreTransactionCommand'], CommandAvailability.hidden);
      expect(menu['ReopenTransactionCommand'], CommandAvailability.hidden);
      expect(menu['UnlinkJournalEntriesCommand'], CommandAvailability.offered);
      expect(menu.values.contains(CommandAvailability.disabled), isFalse);
    });

    test('an open transaction without links can be ignored or linked', () {
      final menu = menuFor(
        <String, Object?>{'status': 'OPEN', 'linkedEntries': <String>[]},
        'TRANSACTION 45',
      );
      expect(menu['IgnoreTransactionCommand'], CommandAvailability.offered);
      expect(menu['LinkJournalEntriesCommand'], CommandAvailability.offered);
      expect(menu['UnlinkJournalEntriesCommand'], CommandAvailability.hidden);
    });
  });

  test('two values of the same enumeration exclude each other without being negations', () {
    // "kind == COMPANY" is not the syntactic negation of "kind == PERSON", and the two still cannot
    // both hold. Renaming a business partner is how this model spells most of its either/ors.
    const mustBeCompany = RuleDescriptor(
      rule: 'MustBeCompany',
      predicate: RuleComparison('actual', CompareOp.eq, RuleValueOperand('COMPANY')),
      reason: 'The business partner is a person',
      fromAttribute: <String, String>{'actual': 'kind'},
    );
    const mustBePerson = RuleDescriptor(
      rule: 'MustBePerson',
      predicate: RuleComparison('actual', CompareOp.eq, RuleValueOperand('PERSON')),
      reason: 'The business partner is a company',
      fromAttribute: <String, String>{'actual': 'kind'},
    );
    final menu = gateCommands(
      <CommandDescriptor>[
        command('RenameCompanyPartnerCommand', const <RuleDescriptor>[mustBeCompany]),
        command('RenamePersonPartnerCommand', const <RuleDescriptor>[mustBePerson]),
      ],
      row(<String, Object?>{'kind': 'PERSON'}),
      null,
    );
    expect(menu.first.availability, CommandAvailability.hidden);
    expect(menu.last.availability, CommandAvailability.offered);
  });

  test('the rule and the row may call the same value different things', () {
    // Two rules are only comparable once both are written in the row's vocabulary: one calls it
    // "current" and the other "state", and both are the row's "status".
    const mustBeOpen = RuleDescriptor(
      rule: 'MustBeOpen',
      predicate: RuleComparison('current', CompareOp.eq, RuleValueOperand('OPEN')),
      reason: 'It is not open',
      fromAttribute: <String, String>{'current': 'status'},
    );
    const mustBeClosed = RuleDescriptor(
      rule: 'MustBeClosed',
      predicate: RuleComparison('state', CompareOp.ne, RuleValueOperand('OPEN')),
      reason: 'It is open',
      fromAttribute: <String, String>{'state': 'status'},
    );
    final menu = gateCommands(
      <CommandDescriptor>[
        command('CloseCommand', const <RuleDescriptor>[mustBeOpen]),
        command('ReopenCommand', const <RuleDescriptor>[mustBeClosed]),
      ],
      row(<String, Object?>{'status': 'CLOSED'}),
      null,
    );
    expect(menu.first.availability, CommandAvailability.hidden);
  });

  test('an action nothing else explains stays, disabled, wearing its refusal', () {
    // A gate whose opposite is carried by no other action in the menu. Removing it would leave the
    // menu saying nothing at all about why, so it is shown and the rule speaks for itself.
    final menu = gateCommands(
      <CommandDescriptor>[
        command('ClearTaxNumberCommand', const <RuleDescriptor>[
          RuleDescriptor(
            rule: 'TaxNumberMustBeAssigned',
            predicate: RuleComparison('taxNumber', CompareOp.ne, RuleNullOperand()),
            reason: r'${companyName} has no tax number',
            fromAttribute: <String, String>{
              'taxNumber': 'taxNumber',
              'companyName': 'companyName',
            },
          ),
        ]),
        command('AssignTaxNumberCommand', const <RuleDescriptor>[]),
      ],
      row(<String, Object?>{'taxNumber': null, 'companyName': 'Acme AG'}),
      null,
    );
    expect(menu.first.availability, CommandAvailability.disabled);
    expect(menu.first.reason, 'Acme AG has no tax number');
  });

  test('the reason is said in the language the caller supplies it in', () {
    // The caption above a disabled action comes from a bundle; for as long as this did not, it was the
    // one line on the screen that stayed in the model's own language. Substitution runs after the
    // lookup - a translation is a template too.
    final menu = gateCommands(
      <CommandDescriptor>[
        command('IgnoreTransactionCommand', const <RuleDescriptor>[mustNotBeIgnored]),
      ],
      row(const <String, Object?>{'status': 'IGNORED'}),
      'TRANSACTION 45',
      reasonTemplate: (rule) => rule.text?.key == 'TransactionIgnoredException'
          ? r'Umsatz ${transaction} ist ignoriert'
          : null,
    );

    expect(menu.single.availability, CommandAvailability.disabled);
    expect(menu.single.reason, 'Umsatz TRANSACTION 45 ist ignoriert');
  });

  test('and falls back to the model when the caller has no translation for it', () {
    final menu = gateCommands(
      <CommandDescriptor>[
        command('IgnoreTransactionCommand', const <RuleDescriptor>[mustNotBeIgnored]),
      ],
      row(const <String, Object?>{'status': 'IGNORED'}),
      'TRANSACTION 45',
      reasonTemplate: (rule) => null,
    );

    expect(menu.single.reason, 'Transaction TRANSACTION 45 is ignored');
  });

  test('a rule this client cannot answer leaves the action offered', () {
    // The row does not carry what the rule reads. The server is authoritative either way, and hiding
    // something it would have allowed is indistinguishable from a feature nobody built.
    final menu = gateCommands(
      <CommandDescriptor>[
        command('IgnoreTransactionCommand', const <RuleDescriptor>[mustHaveNoLinks]),
      ],
      row(const <String, Object?>{'status': 'OPEN'}),
      'TRANSACTION 45',
    );
    expect(menu.single.availability, CommandAvailability.offered);
  });
}
