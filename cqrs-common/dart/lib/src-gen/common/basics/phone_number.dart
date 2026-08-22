import 'package:cqrs_common/src-gen/common/basics/phone_type.dart';
import 'package:cqrs_common/src/descriptor/attribute_descriptor.dart';
import 'package:cqrs_common/src/descriptor/view_descriptor.dart';
import 'package:cqrs_common/src/json/json.dart';

/// A phone number is a unique sequence of digits assigned to a telephone line, enabling calls and
/// text messages to reach a specific person or device. It acts as a unique identifier within a
/// telecommunications network, allowing users to connect with others. Phone numbers are always
/// stored in international format with plus sign (+), then country code, city code, and local phone
/// number.
class PhoneNumber {
  /// Constructor with all data.
  const PhoneNumber({
    required this.typ,
    required this.value,
  });

  /// Reads the row off the server's JSON.
  factory PhoneNumber.fromJson(Map<String, dynamic> json) => PhoneNumber(
        typ: PhoneType.fromWire(requiredString(json, 'typ')),
        value: requiredString(json, 'value'),
      );

  /// What this type is called on screen, attribute by attribute.
  static const TypeDescriptor descriptor = TypeDescriptor(
    name: 'PhoneNumber',
    attributes: <AttributeDescriptor>[
      AttributeDescriptor(
        name: 'typ',
        kind: ValueKind.enumeration,
        modelType: 'PhoneType',
        values: PhoneType.descriptors,
      ),
      AttributeDescriptor(
        name: 'value',
        kind: ValueKind.text,
      ),
    ],
  );

  final PhoneType typ;

  final String value;

  /// Reads the attribute called [attribute] off this row, for a renderer that has only a
  /// descriptor.
  ///
  /// An operator rather than a method, because a method needs a name and every name is one a
  /// model is entitled to give an attribute - `value` among them, which is what a wrapped
  /// single value is habitually called.
  Object? operator [](String attribute) => switch (attribute) {
        'typ' => typ.wireName,
        'value' => value,
        _ => throw ArgumentError("PhoneNumber has no attribute '$attribute'"),
      };

  /// Writes the row back as JSON.
  Map<String, Object?> toJson() => <String, Object?>{
        'typ': typ.wireName,
        'value': value,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneNumber &&
          other.typ == typ &&
          other.value == value;

  @override
  int get hashCode => Object.hash(typ, value);

  @override
  String toString() => 'PhoneNumber[typ=${typ.wireName}, value=$value]';
}
