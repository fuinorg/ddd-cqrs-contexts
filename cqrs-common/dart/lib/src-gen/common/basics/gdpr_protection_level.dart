import 'package:cqrs_common/src/descriptor/attribute_descriptor.dart';

/// Classification of the data related to the \"General Data Protection Regulation\" (GDPR).
enum GdprProtectionLevel {
  /// No protection required.
  none('NONE', 0),

  /// Personal data whose unlawful processing could adversely affect the data subject"s social
  /// standing or economic situation. The impact of the damage would be limited and manageable.
  normal('NORMAL', 1),

  /// Personal data which, if processed unlawfully, could significantly affect the data subject's
  /// social standing or economic situation. The impact on the data subject would be considerable.
  high('HIGH', 2),

  /// Personal data that, if processed unlawfully, would pose a risk to life and limb or the personal
  /// freedom of the data subject. The consequences of the damage would be of a directly existentially
  /// threatening, catastrophic extent for those affected.
  veryHigh('VERY_HIGH', 3);

  /// Constructor with mandatory data.
  const GdprProtectionLevel(this.wireName, this.value);

  /// The instance as it appears on the wire.
  final String wireName;

  final int value;

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

  /// Reads the attribute called [attribute] off this instance, for a caller that has only its
  /// name - filling a command message's `${provider.id}` is the one that needs it.
  ///
  /// An operator rather than a method, matching what a generated row offers, and for the same
  /// reason: a method needs a name and every name is one a model may give an attribute.
  Object? operator [](String attribute) => switch (attribute) {
        'value' => value,
        _ => throw ArgumentError("GdprProtectionLevel has no attribute '$attribute'"),
      };

  /// Reads an instance off its wire name.
  static GdprProtectionLevel fromWire(String wireName) => all.firstWhere(
        (v) => v.wireName == wireName,
        orElse: () => throw FormatException('Unknown GdprProtectionLevel: $wireName'),
      );
}
