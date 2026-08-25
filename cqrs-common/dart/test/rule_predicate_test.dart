import 'package:cqrs_common/cqrs_common.dart';
import 'package:test/test.dart';

/// The evaluator's own edges. What each predicate form answers is pinned by the shared conformance
/// vectors; this covers what it does when it cannot answer, and the one ordering property the whole
/// date comparison rests on.
void main() {
  group('when it cannot decide, it says so rather than guessing', () {
    test('a value the bag does not hold at all', () {
      // On the server this cannot happen - the validator constructs the rule with every value. Here it
      // means the predicate and whatever assembled the values disagree, and treating that as null
      // would turn the disagreement into a verdict.
      expect(
        () => const RuleAttrRef('enabled').evaluate(const <String, Object?>{}),
        throwsA(isA<RuleEvaluationException>()),
      );
    });

    test('a Boolean condition over something that is not one', () {
      expect(
        () => const RuleAttrRef('enabled').evaluate(const <String, Object?>{'enabled': 'true'}),
        throwsA(isA<RuleEvaluationException>()),
      );
    });

    test('a collection question about something that is not a collection', () {
      expect(
        () => const RuleIsEmpty('linkedEntries').evaluate(const <String, Object?>{'linkedEntries': ''}),
        throwsA(isA<RuleEvaluationException>()),
      );
    });

    test('an ordering with nothing to order against', () {
      // "dueDate >= null" has no answer. Absence is comparable with == and != and with nothing else.
      expect(
        () => const RuleComparison('dueDate', CompareOp.ge, RuleNullOperand())
            .evaluate(const <String, Object?>{'dueDate': '2026-08-21'}),
        throwsA(isA<RuleEvaluationException>()),
      );
    });

    test('and the exception says which value it was', () {
      expect(
        () => const RuleAttrRef('enabled').evaluate(const <String, Object?>{}),
        throwsA(
          isA<RuleEvaluationException>()
              .having((e) => e.toString(), 'toString', contains('enabled')),
        ),
      );
    });
  });

  group('a value absent on one side only', () {
    test('is unequal to a value that is present, rather than undecidable', () {
      // Several rules exist precisely to report absence, so null has to compare rather than throw.
      expect(
        const RuleComparison('assignedEntry', CompareOp.ne, RuleNullOperand())
            .evaluate(const <String, Object?>{'assignedEntry': 'JOURNAL_ENTRY 7'}),
        isTrue,
      );
      expect(
        const RuleComparison('kind', CompareOp.eq, RuleAttributeOperand('categoryKind'))
            .evaluate(const <String, Object?>{'kind': 'EXPENSE', 'categoryKind': null}),
        isFalse,
      );
    });
  });

  group('an operator short-circuits, as the generated Java does', () {
    test('&& does not evaluate its right side once the left is false', () {
      // Otherwise a conjunction guarding an undecidable second half would throw where the server
      // simply returns false.
      const predicate = RuleAnd(RuleAttrRef('enabled'), RuleAttrRef('missing'));

      expect(predicate.evaluate(const <String, Object?>{'enabled': false}), isFalse);
    });

    test('|| does not evaluate its right side once the left is true', () {
      const predicate = RuleOr(RuleAttrRef('enabled'), RuleAttrRef('missing'));

      expect(predicate.evaluate(const <String, Object?>{'enabled': true}), isTrue);
    });
  });

  test('ordering a date is ordering its ISO-8601 text, which is true of that format only', () {
    // The whole date comparison rests on this: yyyy-MM-dd sorts chronologically as text because every
    // field is fixed width and zero padded. Written down as a test rather than a comment, because the
    // day somebody ships a date in another format it stops being true and nothing else would notice.
    final dates = <String>['2026-12-31', '2026-01-05', '2027-01-01', '2026-01-15']..sort();

    expect(dates, <String>['2026-01-05', '2026-01-15', '2026-12-31', '2027-01-01']);
  });

  group('reading a predicate out of the vectors', () {
    test('refuses an operator it does not have', () {
      // The vectors are the one place a predicate is not built by the generator, so a typo there has
      // to fail loudly rather than evaluate to something.
      expect(
        () => RulePredicate.fromJson(const <String, dynamic>{
          'op': 'compare',
          'attribute': 'entries',
          'operator': 'contains',
          'right': <String, dynamic>{'kind': 'null'},
        }),
        throwsA(isA<RuleEvaluationException>()),
      );
    });

    test('refuses a form it does not have', () {
      expect(
        () => RulePredicate.fromJson(const <String, dynamic>{'op': 'exists', 'attribute': 'x'}),
        throwsA(isA<RuleEvaluationException>()),
      );
    });
  });
}
