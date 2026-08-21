import 'package:cqrs_common/src/descriptor/constraint.dart';

/// Path and name of a file in the storage.
class FilePathAndName {
  /// Constructor with mandatory data.
  const FilePathAndName(this.value);

  /// Reads the value off the wire, where a wrapper of one value travels as that value.
  ///
  /// A single-value object is not an object on the wire - the server writes the value itself -
  /// so there is nothing here for a `fromJson` to read a field out of. This is the same door an
  /// id and an enum offer, for the same reason.
  factory FilePathAndName.fromWire(Object value) => FilePathAndName(value as String);

  /// The invariants the model declares on this type, as far as this target can express them.
  ///
  /// Always present, even when empty. Whether a constraint has a Dart equivalent is this
  /// target's business, not a caller's: a descriptor naming this type's constraints has to
  /// compile whatever the model happens to declare, and a member that appears and disappears
  /// makes one factory's output depend on another's.
  static const List<Constraint> constraints = <Constraint>[Length(1, 248)];

  final String value;

  /// Whether [value] satisfies the model's invariants.
  static bool isValid(Object? value) => validate(value, 'FilePathAndName') == null;

  /// What is wrong with [value], or `null` when it satisfies the model's invariants.
  ///
  /// [label] is what to call the value in the message - a field's label from the model, so the
  /// wording a user reads is the wording the model states.
  static String? validate(Object? value, String label) {
    for (final constraint in constraints) {
      final message = constraint.validate(value, label);
      if (message != null) {
        return message;
      }
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FilePathAndName && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();
}
