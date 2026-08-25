import 'package:cqrs_common/src/descriptor/attribute_descriptor.dart';

/// The male sex or the female sex, especially when considered with reference to social and cultural
/// differences rather than biological ones.
enum Gender {
  /// Not yet known.
  unknown('UNKNOWN', 0),

  /// A man or a boy.
  male('MALE', 1),

  /// A woman or a girl.
  female('FEMALE', 2),

  /// Not conform to the traditional male/female binary.
  diverse('DIVERSE', 3);

  /// Constructor with mandatory data.
  const Gender(this.wireName, this.value);

  /// The instance as it appears on the wire.
  final String wireName;

  final int value;

  /// All instances, in model order.
  static const List<Gender> all = <Gender>[unknown, male, female, diverse];

  /// Valid instances - those not marked deprecated in the model.
  static const List<Gender> valid = <Gender>[unknown, male, female, diverse];

  /// Deprecated instances.
  static const List<Gender> deprecated = <Gender>[];

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
        _ => throw ArgumentError("Gender has no attribute '$attribute'"),
      };

  /// Reads an instance off its wire name.
  static Gender fromWire(String wireName) => all.firstWhere(
        (v) => v.wireName == wireName,
        orElse: () => throw FormatException('Unknown Gender: $wireName'),
      );
}
