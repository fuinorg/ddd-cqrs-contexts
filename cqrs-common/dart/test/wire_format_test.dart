import 'dart:convert';

import 'package:cqrs_common/cqrs_common.dart';
import 'package:test/test.dart';

void main() {
  group('a date on the wire', () {
    test('is a calendar day, zero padded', () {
      // The obvious implementation writes 2026-8-1 and the server refuses it. Padding is the whole
      // reason this is a function rather than an interpolation at each call site.
      expect(wireDate(DateTime(2026, 8, 1)), '2026-08-01');
      expect(wireDate(DateTime(2026, 12, 31)), '2026-12-31');
    });

    test('drops the time rather than zeroing it, because the model said a day', () {
      expect(wireDate(DateTime(2026, 8, 21, 14, 30, 5)), '2026-08-21');
    });

    test('stays absent when the value is', () {
      // An optional filter that is not given must be left out of the query, not sent as the word null.
      expect(wireDate(null), isNull);
      expect(wireTimestamp(null), isNull);
    });

    test('survives being encoded, which a DateTime does not', () {
      // This is the bug it exists for: jsonEncode refuses a DateTime outright, so a command carrying
      // one could not be sent at all, and a query string rendered it '2026-08-21 00:00:00.000'.
      expect(() => jsonEncode(<String, Object?>{'date': DateTime(2026, 8, 21)}), throwsA(anything));
      expect(
        jsonEncode(<String, Object?>{'date': wireDate(DateTime(2026, 8, 21))}),
        '{"date":"2026-08-21"}',
      );
    });
  });

  group('a timestamp on the wire', () {
    test('keeps the time, in ISO-8601', () {
      expect(wireTimestamp(DateTime.utc(2026, 8, 21, 14, 30, 5)), '2026-08-21T14:30:05.000Z');
    });
  });

  group('what a type descriptor says about itself', () {
    const row = TypeDescriptor(
      name: 'Row',
      attributes: <AttributeDescriptor>[
        AttributeDescriptor(name: 'source', kind: ValueKind.identifier, role: AttributeRole.source),
        AttributeDescriptor(name: 'code', kind: ValueKind.text, role: AttributeRole.key),
        AttributeDescriptor(name: 'label', kind: ValueKind.text),
      ],
    );

    test('a natural key identifies the row and is still shown', () {
      // Both halves matter. It is what a command is addressed at, and it is a column - which is the
      // case AttributeRole.identifier cannot express, because that one is never displayed.
      expect(row.identity?.name, 'code');
      expect(row.displayed.map((a) => a.name), <String>['code', 'label']);
    });

    test('and the source is neither shown nor mistaken for the identity', () {
      expect(row.source?.name, 'source');
      expect(row.displayed.map((a) => a.name), isNot(contains('source')));
    });

    test('a row that carries no identity says so instead of failing', () {
      // A rate for a day, a total for a category. What it means is that a screen cannot address a
      // command at it - a fact to read off the model, not a crash.
      const anonymous = TypeDescriptor(
        name: 'Rate',
        attributes: <AttributeDescriptor>[AttributeDescriptor(name: 'rate', kind: ValueKind.decimal)],
      );

      expect(anonymous.identity, isNull);
      expect(anonymous.source, isNull);
    });
  });
}
