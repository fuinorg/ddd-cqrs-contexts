import 'package:cqrs_common/src/descriptor/attribute_descriptor.dart';

/// The male sex or the female sex, especially when considered with reference to social and cultural
/// differences rather than biological ones.
enum Gender {
  /// Not yet known.
  unknown('UNKNOWN'),

  /// A man or a boy.
  male('MALE'),

  /// A woman or a girl.
  female('FEMALE'),

  /// Not conform to the traditional male/female binary.
  diverse('DIVERSE');

  /// Constructor with mandatory data.
  const Gender(this.wireName);

  /// The instance as it appears on the wire.
  final String wireName;

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

  /// Reads an instance off its wire name.
  static Gender fromWire(String wireName) => all.firstWhere(
        (v) => v.wireName == wireName,
        orElse: () => throw FormatException('Unknown Gender: $wireName'),
      );
}
