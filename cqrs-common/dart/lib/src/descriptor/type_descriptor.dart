import 'package:cqrs_common/src/descriptor/attribute_descriptor.dart';

/// A value object of the model, and the attributes it carries.
///
/// What a view method returns, and - through [AttributeDescriptor.nested] - what a composite attribute
/// inside such a row holds, which is the same question one level down.
///
/// It lives in a file of its own rather than beside the view descriptor because an attribute may point
/// at one: putting it back would make the two files import each other, which Dart permits and nobody
/// enjoys reading.
class TypeDescriptor {
  /// Constructor with all data.
  const TypeDescriptor({required this.name, required this.attributes});

  /// Name of the type in the model, e.g. `CategoryDetails`.
  final String name;

  /// Its attributes, in the order the model declares them - which is the order a screen shows them.
  final List<AttributeDescriptor> attributes;

  /// The attributes a screen shows, in model order.
  Iterable<AttributeDescriptor> get displayed => attributes.where((a) => a.displayed);

  /// The attribute that identifies a row of this type, or `null` when it carries no identity.
  ///
  /// A row without one is a perfectly ordinary thing - a rate for a day, a total for a category - and
  /// what it means is that a screen cannot address a command at it or route to a detail of it. That is
  /// a fact to read off the model rather than a case to crash on.
  AttributeDescriptor? get identity {
    for (final attribute in attributes) {
      if (attribute.role == AttributeRole.key || attribute.role == AttributeRole.identifier) {
        return attribute;
      }
    }
    return null;
  }

  /// Where rows of this type were projected from, or `null` when they carry no such statement.
  ///
  /// Its absence means "has the projection caught up with my write" has no answer for this type, so a
  /// screen re-reads plainly instead of settling a pending row.
  AttributeDescriptor? get source {
    for (final attribute in attributes) {
      if (attribute.role == AttributeRole.source) {
        return attribute;
      }
    }
    return null;
  }
}
