import 'package:cqrs_common/src/descriptor/attribute_descriptor.dart';
import 'package:cqrs_common/src/descriptor/message_template.dart';

/// A value object of the model, and the attributes it carries.
///
/// In its own file because an attribute may point at one, and putting it back beside the view
/// descriptor would make the two import each other.
class TypeDescriptor {
  /// Constructor with all data.
  const TypeDescriptor({required this.name, required this.attributes, this.displayFormat});

  /// Name of the type in the model, e.g. `CategoryDetails`.
  final String name;

  /// Its attributes, in the order the model declares them - which is the order a screen shows them.
  final List<AttributeDescriptor> attributes;

  /// How to name one row of this type to a person, or `null` where the model does not say.
  ///
  /// It comes from the `display-as` of the business key the type is recognised by, and it is a format
  /// rather than an attribute because a composite key needs one: `(name, kind)` has to read as
  /// "Office supplies (expense)", which no combination of the two attributes' own captions produces.
  ///
  /// `null` is not a gap to fill silently - a type that says nothing has no display key, and a caller
  /// falls back to the first displayed attribute visibly rather than by a rule that looks like a
  /// decision.
  final String? displayFormat;

  /// The attributes a screen shows, in model order.
  Iterable<AttributeDescriptor> get displayed => attributes.where((a) => a.displayed);

  /// One row of this type named as the model says, or `null` where it says nothing.
  ///
  /// [read] is asked for each attribute the format names, exactly as a command's confirmation message
  /// asks - so a label and a message render the same string from the same row, and a placeholder that
  /// resolves to nothing is left standing rather than blanked.
  String? describe(Object? Function(String) read) {
    final format = displayFormat;
    return format == null ? null : renderMessage(format, read);
  }

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
