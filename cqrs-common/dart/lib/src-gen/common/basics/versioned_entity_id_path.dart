import 'package:cqrs_common/src/descriptor/attribute_descriptor.dart';
import 'package:cqrs_common/src/descriptor/view_descriptor.dart';
import 'package:cqrs_common/src/json/json.dart';

/// Identifies the aggregate or entity some data was derived from, together with the version of that
/// aggregate at the time. A projection copies both values from the domain event into the read
/// model, and a client sends them back with a command, so the aggregate repository can tell on load
/// whether the data the change was based on is still current.
class VersionedEntityIdPath {
  /// Constructor with all data.
  const VersionedEntityIdPath({
    required this.entityIdPath,
    this.aggregateVersion,
  });

  /// Reads the row off the server's JSON.
  factory VersionedEntityIdPath.fromJson(Map<String, dynamic> json) => VersionedEntityIdPath(
        entityIdPath: requiredString(json, 'entityIdPath'),
        aggregateVersion: optionalInt(json, 'aggregateVersion'),
      );

  /// What this type is called on screen, attribute by attribute.
  static const TypeDescriptor descriptor = TypeDescriptor(
    name: 'VersionedEntityIdPath',
    attributes: <AttributeDescriptor>[
      AttributeDescriptor(
        name: 'entityIdPath',
        kind: ValueKind.text,
      ),
      AttributeDescriptor(
        name: 'aggregateVersion',
        kind: ValueKind.integer,
        optional: true,
      ),
    ],
  );

  /// Path from the aggregate root down to the entity the data was derived from.
  final String entityIdPath;

  /// Version of the aggregate the data reflects, or nothing if it is unknown.
  final int? aggregateVersion;

  /// Reads the attribute called [attribute] off this row, for a renderer that has only a
  /// descriptor.
  ///
  /// An operator rather than a method, because a method needs a name and every name is one a
  /// model is entitled to give an attribute - `value` among them, which is what a wrapped
  /// single value is habitually called.
  Object? operator [](String attribute) => switch (attribute) {
        'entityIdPath' => entityIdPath,
        'aggregateVersion' => aggregateVersion,
        _ => throw ArgumentError("VersionedEntityIdPath has no attribute '$attribute'"),
      };

  /// Writes the row back as JSON.
  Map<String, Object?> toJson() => <String, Object?>{
        'entityIdPath': entityIdPath,
        'aggregateVersion': aggregateVersion,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VersionedEntityIdPath &&
          other.entityIdPath == entityIdPath &&
          other.aggregateVersion == aggregateVersion;

  @override
  int get hashCode => Object.hash(entityIdPath, aggregateVersion);

  @override
  String toString() => 'VersionedEntityIdPath[entityIdPath=$entityIdPath, aggregateVersion=$aggregateVersion]';
}
