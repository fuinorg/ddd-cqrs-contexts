import 'package:cqrs_common/src/descriptor/attribute_descriptor.dart';

/// State of verification of an email address.
enum EmailAddressValidationState {
  /// There was no proof yet that the email address exists.
  notVerified('NOT_VERIFIED', 1),

  /// It was confirmed that the email addess exists.
  verified('VERIFIED', 2);

  /// Constructor with mandatory data.
  const EmailAddressValidationState(this.wireName, this.value);

  /// The instance as it appears on the wire.
  final String wireName;

  final int value;

  /// All instances, in model order.
  static const List<EmailAddressValidationState> all = <EmailAddressValidationState>[notVerified, verified];

  /// Valid instances - those not marked deprecated in the model.
  static const List<EmailAddressValidationState> valid = <EmailAddressValidationState>[notVerified, verified];

  /// Deprecated instances.
  static const List<EmailAddressValidationState> deprecated = <EmailAddressValidationState>[];

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
        _ => throw ArgumentError("EmailAddressValidationState has no attribute '$attribute'"),
      };

  /// Reads an instance off its wire name.
  static EmailAddressValidationState fromWire(String wireName) => all.firstWhere(
        (v) => v.wireName == wireName,
        orElse: () => throw FormatException('Unknown EmailAddressValidationState: $wireName'),
      );
}
