import 'package:cqrs_common/src/descriptor/attribute_descriptor.dart';
import 'package:cqrs_common/src/descriptor/view_descriptor.dart';
import 'package:cqrs_common/src/json/json.dart';

/// A postal address, also known as a mailing address, is the location where mail and packages can
/// be delivered. It typically includes the recipient's name, street address or P.O. Box number,
/// city, state, and postal code.
class PostalAddress {
  /// Constructor with all data.
  const PostalAddress({
    required this.lines,
  });

  /// Reads the row off the server's JSON.
  factory PostalAddress.fromJson(Map<String, dynamic> json) => PostalAddress(
        lines: requiredList(json, 'lines', (e) => e as String),
      );

  /// What this type is called on screen, attribute by attribute.
  static const TypeDescriptor descriptor = TypeDescriptor(
    name: 'PostalAddress',
    attributes: <AttributeDescriptor>[
      AttributeDescriptor(
        name: 'lines',
        kind: ValueKind.text,
        multiple: true,
      ),
    ],
  );

  final List<String> lines;

  /// Reads the attribute called [attribute] off this row, for a renderer that has only a
  /// descriptor.
  ///
  /// An operator rather than a method, because a method needs a name and every name is one a
  /// model is entitled to give an attribute - `value` among them, which is what a wrapped
  /// single value is habitually called.
  Object? operator [](String attribute) => switch (attribute) {
        'lines' => lines,
        _ => throw ArgumentError("PostalAddress has no attribute '$attribute'"),
      };

  /// Writes the row back as JSON.
  Map<String, Object?> toJson() => <String, Object?>{
        'lines': lines,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostalAddress &&
          other.lines == lines;

  @override
  int get hashCode => lines.hashCode;

  @override
  String toString() => 'PostalAddress[lines=$lines]';
}
