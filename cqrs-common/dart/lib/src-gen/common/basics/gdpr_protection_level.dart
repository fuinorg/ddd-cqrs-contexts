import 'package:cqrs_common/src/descriptor/attribute_descriptor.dart';

/// Classification of the data related to the \"General Data Protection Regulation\" (GDPR).
enum GdprProtectionLevel {
  /// No protection required.
  none('NONE'),

  /// Personal data whose unlawful processing could adversely affect the data subject"s social
  /// standing or economic situation. The impact of the damage would be limited and manageable.
  normal('NORMAL'),

  /// Personal data which, if processed unlawfully, could significantly affect the data subject's
  /// social standing or economic situation. The impact on the data subject would be considerable.
  high('HIGH'),

  /// Personal data that, if processed unlawfully, would pose a risk to life and limb or the personal
  /// freedom of the data subject. The consequences of the damage would be of a directly existentially
  /// threatening, catastrophic extent for those affected.
  veryHigh('VERY_HIGH');

  /// Constructor with mandatory data.
  const GdprProtectionLevel(this.wireName);

  /// The instance as it appears on the wire.
  final String wireName;

  /// All instances, in model order.
  static const List<GdprProtectionLevel> all = <GdprProtectionLevel>[none, normal, high, veryHigh];

  /// Valid instances - those not marked deprecated in the model.
  static const List<GdprProtectionLevel> valid = <GdprProtectionLevel>[none, normal, high, veryHigh];

  /// Deprecated instances.
  static const List<GdprProtectionLevel> deprecated = <GdprProtectionLevel>[];

  /// What to call each instance on screen.
  ///
  /// Always present, empty when the model captions nothing. A renderer that is handed this then
  /// shows the wire name, which is honest - and a member that appears and disappears would make
  /// every descriptor referencing it depend on whether somebody happened to write a label.
  static const List<EnumValueDescriptor> descriptors = <EnumValueDescriptor>[
  ];

  /// Reads an instance off its wire name.
  static GdprProtectionLevel fromWire(String wireName) => all.firstWhere(
        (v) => v.wireName == wireName,
        orElse: () => throw FormatException('Unknown GdprProtectionLevel: $wireName'),
      );
}
