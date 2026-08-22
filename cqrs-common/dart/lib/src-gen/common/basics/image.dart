import 'package:cqrs_common/src-gen/common/basics/file_path_and_name.dart';
import 'package:cqrs_common/src/descriptor/attribute_descriptor.dart';
import 'package:cqrs_common/src/descriptor/view_descriptor.dart';
import 'package:cqrs_common/src/json/json.dart';

/// Representation of an image used for uploads.
class Image {
  /// Constructor with all data.
  const Image({
    required this.pathAndName,
    required this.data,
  });

  /// Reads the row off the server's JSON.
  factory Image.fromJson(Map<String, dynamic> json) => Image(
        pathAndName: FilePathAndName(requiredString(json, 'pathAndName')),
        data: requiredBinary(json, 'data'),
      );

  /// What this type is called on screen, attribute by attribute.
  static const TypeDescriptor descriptor = TypeDescriptor(
    name: 'Image',
    attributes: <AttributeDescriptor>[
      AttributeDescriptor(
        name: 'pathAndName',
        kind: ValueKind.text,
        modelType: 'FilePathAndName',
        constraints: FilePathAndName.constraints,
      ),
      AttributeDescriptor(
        name: 'data',
        kind: ValueKind.text,
      ),
    ],
  );

  final FilePathAndName pathAndName;

  final List<int> data;

  /// Reads the attribute called [attribute] off this row, for a renderer that has only a
  /// descriptor.
  ///
  /// An operator rather than a method, because a method needs a name and every name is one a
  /// model is entitled to give an attribute - `value` among them, which is what a wrapped
  /// single value is habitually called.
  Object? operator [](String attribute) => switch (attribute) {
        'pathAndName' => pathAndName.value,
        'data' => data,
        _ => throw ArgumentError("Image has no attribute '$attribute'"),
      };

  /// Writes the row back as JSON.
  Map<String, Object?> toJson() => <String, Object?>{
        'pathAndName': pathAndName.value,
        'data': data,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Image &&
          other.pathAndName == pathAndName &&
          other.data == data;

  @override
  int get hashCode => Object.hash(pathAndName, data);

  @override
  String toString() => 'Image[pathAndName=${pathAndName.value}, data=$data]';
}
