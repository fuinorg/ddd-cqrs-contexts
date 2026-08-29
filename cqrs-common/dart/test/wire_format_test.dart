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

  group('what a refusal says', () {
    const command = CommandDescriptor(
      type: 'CreateCategoryCommand',
      module: 'categories',
      target: 'Category',
      kind: CommandKind.create,
      doc: 'Creates a category.',
      message: 'Create category',
      attributes: <AttributeDescriptor>[
        AttributeDescriptor(name: 'name', kind: ValueKind.text),
        AttributeDescriptor(name: 'kind', kind: ValueKind.text),
      ],
    );

    test('the kind of problem, and the values it was about', () {
      // Self describing: the payload sits under the element the result names, so nothing guesses which
      // field of the JSON is the data.
      final result = CommandResult.fromJson(<String, dynamic>{
        'type': 'ERROR',
        'code': 'MELK-DUPLICATE_CATEGORY_NAME',
        'message': "A EXPENSE category named 'Office supplies' already exists",
        'data-class': 'de.fuin.melkheftken.shared.domain.categories.DuplicateCategoryNameExceptionData',
        'data-element': 'duplicate-category-name-exception',
        'duplicate-category-name-exception': <String, dynamic>{'name': 'Office supplies', 'kind': 'EXPENSE'},
      });

      expect(result.accepted, isFalse);
      expect(result.code, 'MELK-DUPLICATE_CATEGORY_NAME');
      expect(result.data, <String, dynamic>{'name': 'Office supplies', 'kind': 'EXPENSE'});
    });

    final refusal = CommandResult.fromJson(<String, dynamic>{
      'type': 'ERROR',
      'code': 'MELK-DUPLICATE_CATEGORY_NAME',
      'data-element': 'e',
      'e': <String, dynamic>{'name': 'Office supplies', 'kind': 'EXPENSE'},
    });

    test('a refusal naming two of the command own fields belongs above the form', () {
      // It does not say which of the two it is about, and a message on the wrong field is worse than
      // one above the form.
      expect(command.attributeFor(refusal), isNull);
    });

    test('a form with one field takes the refusal whatever the refusal calls its values', () {
      // The case the old table existed for: an edit names its field after the change, so the refusal
      // says `name` where the form says `newName` and matching on names alone finds nothing.
      const rename = CommandDescriptor(
        type: 'RenameCategoryCommand',
        module: 'categories',
        target: 'Category',
        kind: CommandKind.modify,
        doc: 'Renames a category.',
        message: 'Rename category',
        attributes: <AttributeDescriptor>[
          AttributeDescriptor(name: 'newName', kind: ValueKind.text),
        ],
      );

      expect(rename.attributeFor(refusal), 'newName');
    });

    test('a refusal carrying nothing belongs on the form as a whole', () {
      final result = CommandResult.fromJson(<String, dynamic>{
        'type': 'ERROR',
        'code': 'MELK-SOMETHING_ELSE',
        'message': 'Nope',
      });

      expect(result.data, isNull);
      expect(command.attributeFor(result), isNull);
    });

    test('and so does one about something this command does not have', () {
      final result = CommandResult.fromJson(<String, dynamic>{
        'type': 'ERROR',
        'data-element': 'e',
        'e': <String, dynamic>{'somethingElse': 1},
      });

      expect(command.attributeFor(result), isNull);
    });
  });

  group('how a row is named to a person', () {
    const row = TypeDescriptor(
      name: 'CategoryDetails',
      attributes: <AttributeDescriptor>[
        AttributeDescriptor(name: 'id', kind: ValueKind.identifier, role: AttributeRole.identifier),
        AttributeDescriptor(name: 'name', kind: ValueKind.text),
        AttributeDescriptor(name: 'kind', kind: ValueKind.text),
      ],
      displayFormat: r'${name} (${kind})',
    );

    test('a composite key reads as one phrase', () {
      // Which is the whole reason it is a format: no combination of the two attributes' own captions
      // produces "Office supplies (expense)".
      final values = <String, Object?>{'name': 'Office supplies', 'kind': 'expense'};
      expect(row.describe((n) => values[n]), 'Office supplies (expense)');
    });

    test('a placeholder that resolves to nothing is left standing', () {
      // Visible, so somebody reports it. An empty gap reads like the model meant it.
      final values = <String, Object?>{'name': 'Office supplies'};
      expect(row.describe((n) => values[n]), r'Office supplies (${kind})');
    });

    test('a type that says nothing has no display key', () {
      // Not a gap to fill silently: the caller falls back to the first displayed attribute, visibly.
      const silent = TypeDescriptor(
        name: 'Rate',
        attributes: <AttributeDescriptor>[AttributeDescriptor(name: 'rate', kind: ValueKind.decimal)],
      );

      expect(silent.describe((n) => null), isNull);
    });
  });
}
