import 'package:cqrs_common/cqrs_common.dart';
import 'package:test/test.dart';

/// Stands in for a generated enum: model attributes reachable by name, plus a wire name.
enum _Provider {
  bazgCh('BAZG_CH', 'BAZG', 'Swiss customs'),
  ecb('ECB', 'ECB', 'European Central Bank');

  const _Provider(this.wireName, this.id, this.name);

  final String wireName;
  final String id;
  final String name;

  Object? operator [](String attribute) => switch (attribute) {
        'id' => id,
        'name' => name,
        _ => throw ArgumentError("_Provider has no attribute '$attribute'"),
      };
}

void main() {
  Object? Function(String) bag(Map<String, Object?> values) =>
      (name) => values.containsKey(name)
          ? values[name]
          : throw ArgumentError("no attribute '$name'");

  group('a command message on the client', () {
    test('fills a plain variable', () {
      expect(
        renderMessage(r"Assign tax number '${taxNumber}'", bag({'taxNumber': 'CHE-1'})),
        "Assign tax number 'CHE-1'",
      );
    });

    test('fills several, and keeps the text between them', () {
      expect(
        renderMessage(r"Create ${kind} category '${name}'", bag({'kind': 'EXPENSE', 'name': 'Office'})),
        "Create EXPENSE category 'Office'",
      );
    });

    test('leaves a message with no placeholders exactly as it stands', () {
      expect(renderMessage('Switch this module off', bag({})), 'Switch this module off');
    });

    test('walks a dotted path through the value, which is the whole reason for the restriction', () {
      // The JVM renders this one through Jakarta EL against the generated Java enum. The client has to
      // reach the same "BAZG" - not the wire name "BAZG_CH", which is what it had before the model's
      // attributes were generated into the Dart enum.
      expect(
        renderMessage(r'Import rates from ${provider.id}', bag({'provider': _Provider.bazgCh})),
        'Import rates from BAZG',
      );
    });

    test('reads an enumeration as its wire name rather than as its Dart declaration', () {
      // "ExchangeRateProvider.ecb" is no way to finish a sentence.
      expect(
        renderMessage(r'Import rates from ${provider}', bag({'provider': _Provider.ecb})),
        'Import rates from ECB',
      );
    });
  });

  group('what it cannot resolve', () {
    test('stays visible, so it is reported rather than read as a gap the model meant', () {
      expect(
        renderMessage(r"Remove '${name}'", bag({})),
        r"Remove '${name}'",
      );
    });

    test('including a step the value does not carry', () {
      expect(
        renderMessage(r'From ${provider.currency}', bag({'provider': _Provider.ecb})),
        r'From ${provider.currency}',
      );
    });

    test('and a step off a value that offers no lookup at all', () {
      expect(
        renderMessage(r'From ${name.length}', bag({'name': 'Office'})),
        r'From ${name.length}',
      );
    });

    test('and an absent optional value, which is not the same as an unknown name', () {
      expect(renderMessage(r'Note ${remark}', bag({'remark': null})), r'Note ${remark}');
    });
  });

  test('text that merely looks like a placeholder is left alone', () {
    // The validator refuses an unclosed one in the model, so this is a message that never went
    // through it - and mangling the rest of the string would be a poor way to say so.
    expect(renderMessage(r'Costs ${100', bag({})), r'Costs ${100');
  });
}
