import 'dart:convert';
import 'dart:io';

import 'package:cqrs_common/cqrs_common.dart';
import 'package:test/test.dart';

/// Runs the shared conformance vectors against the Dart evaluator.
///
/// The table is deliberately outside this package - one predicate is answered twice, here and by a
/// generated Java rule class on the server, and two implementations of one semantics drift. The way
/// that drift shows up in a running system is a button that quietly stops being offered, which is why
/// it is worth a shared table rather than two sets of tests that happen to agree.
void main() {
  final file = File('../rule-conformance/vectors.json');

  test('the vector table is where both ends can read it', () {
    // A moved file would otherwise show up as "0 vectors ran, all passed".
    expect(file.existsSync(), isTrue, reason: 'no vectors at ${file.absolute.path}');
  });

  final vectors = (jsonDecode(file.readAsStringSync()) as List).cast<Map<String, dynamic>>();

  test('every vector carries at least one case', () {
    expect(vectors, isNotEmpty);
    for (final vector in vectors) {
      expect(vector['cases'], isNotEmpty, reason: '${vector['name']} decides nothing');
    }
  });

  for (final vector in vectors) {
    group('${vector['rule']} - ${vector['name']}', () {
      final predicate = RulePredicate.fromJson(vector['predicate'] as Map<String, dynamic>);

      for (final (index, dynamic raw) in (vector['cases'] as List).indexed) {
        final testCase = raw as Map<String, dynamic>;
        final values = (testCase['values'] as Map<String, dynamic>).cast<String, Object?>();
        final expected = testCase['expected'] as bool;
        final label = testCase['comment'] as String? ?? 'case ${index + 1}';

        test(label, () {
          expect(predicate.evaluate(values), expected, reason: jsonEncode(values));
        });
      }
    });
  }
}
