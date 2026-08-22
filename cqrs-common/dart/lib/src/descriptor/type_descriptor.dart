import 'package:cqrs_common/src/descriptor/attribute_descriptor.dart';

/// A value object of the model, and the attributes it carries.
///
/// In its own file because an attribute may point at one, and putting it back beside the view
/// descriptor would make the two import each other.
class TypeDescriptor {
  /// Constructor with all data.
  const TypeDescriptor({required this.name, required this.attributes});

  /// Name of the type in the model, e.g. `CategoryDetails`.
  final String name;

  /// Its attributes, in the order the model declares them - which is the order a screen shows them.
  final List<AttributeDescriptor> attributes;

  /// The attributes a screen shows, in model order.
  Iterable<AttributeDescriptor> get displayed => attributes.where((a) => a.displayed);

  /// The attribute that identifies a row of this type, or `null` when it carries no identity - a rate
  /// for a day, a total for a category - and therefore nothing a command can be addressed at.
  AttributeDescriptor? get identity {
    for (final attribute in attributes) {
      if (attribute.role == AttributeRole.key || attribute.role == AttributeRole.identifier) {
        return attribute;
      }
    }
    return null;
  }

  /// Where rows of this type were projected from, or `null` - in which case "has the projection caught
  /// up" has no answer and a screen re-reads plainly instead of settling a pending row.
  AttributeDescriptor? get source {
    for (final attribute in attributes) {
      if (attribute.role == AttributeRole.source) {
        return attribute;
      }
    }
    return null;
  }
}
