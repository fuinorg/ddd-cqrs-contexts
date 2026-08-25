import 'package:cqrs_common/src/descriptor/attribute_descriptor.dart';

/// Type of phone number.
enum PhoneType {
  /// A mobile phone number is a unique sequence of digits assigned to a mobile phone or mobile
  /// network for the purpose of making and receiving calls, sending and receiving text messages, and
  /// using other mobile services. It differs from a landline number because it's associated with a
  /// mobile device and its wireless network connection, allowing for mobility and use outside of a
  /// fixed location.
  mobile('MOBILE', 1),

  /// A landline phone number is a traditional telephone number connected to a fixed-line network,
  /// typically using physical wires (copper or fiber optic cables) to transmit voice calls. These
  /// numbers are associated with a specific location, like a home or office, and are part of the
  /// Public Switched Telephone Network (PSTN). Unlike mobile phones, landlines do not rely on
  /// cellular networks or radio waves.
  landline('LANDLINE', 2);

  /// Constructor with mandatory data.
  const PhoneType(this.wireName, this.value);

  /// The instance as it appears on the wire.
  final String wireName;

  final int value;

  /// All instances, in model order.
  static const List<PhoneType> all = <PhoneType>[mobile, landline];

  /// Valid instances - those not marked deprecated in the model.
  static const List<PhoneType> valid = <PhoneType>[mobile, landline];

  /// Deprecated instances.
  static const List<PhoneType> deprecated = <PhoneType>[];

  /// What to call each instance on screen.
  ///
  /// Always present, empty when the model captions nothing. A renderer that is handed this then
  /// shows the wire name, which is honest - and a member that appears and disappears would make
  /// every descriptor referencing it depend on whether somebody happened to write a label.
  static const List<EnumValueDescriptor> descriptors = <EnumValueDescriptor>[
  ];

  /// Reads the attribute called [attribute] off this instance, for a caller that has only its
  /// name - filling a command message's `${provider.id}` is the one that needs it.
  ///
  /// An operator rather than a method, matching what a generated row offers, and for the same
  /// reason: a method needs a name and every name is one a model may give an attribute.
  Object? operator [](String attribute) => switch (attribute) {
        'value' => value,
        _ => throw ArgumentError("PhoneType has no attribute '$attribute'"),
      };

  /// Reads an instance off its wire name.
  static PhoneType fromWire(String wireName) => all.firstWhere(
        (v) => v.wireName == wireName,
        orElse: () => throw FormatException('Unknown PhoneType: $wireName'),
      );
}
