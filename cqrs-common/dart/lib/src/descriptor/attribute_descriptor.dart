import 'package:cqrs_common/src/descriptor/constraint.dart';
import 'package:cqrs_common/src/descriptor/model_text.dart';
import 'package:cqrs_common/src/descriptor/type_descriptor.dart';

/// What kind of value an attribute holds, as far as rendering and parsing are concerned.
///
/// This is deliberately coarser than the model's type system: two value objects that are both a
/// bounded string render identically, and the renderer has no use for knowing which is which. What it
/// does need is whether to offer a text field, a picker or a date picker, and how to format the value
/// in a cell.
enum ValueKind {
  /// Free text.
  text,

  /// Whole number.
  integer,

  /// A number with a fractional part that must not be a `double` - a tax rate, an exchange rate.
  decimal,

  /// An amount in minor units, with a currency code beside it.
  money,

  /// True or false.
  boolean,

  /// A date without a time.
  date,

  /// A point in time.
  timestamp,

  /// One of a fixed set of instances, each with its own wording.
  enumeration,

  /// An identifier. Rendered only where an identifier is what the user is looking at.
  identifier,
}

/// What an attribute is for, which decides whether a screen shows it at all.
enum AttributeRole {
  /// Ordinary data - the reason the row or the form exists. Must carry wording.
  data,

  /// The identity of the row. Carried so a detail route and a command can be built, not displayed.
  ///
  /// A surrogate: an aggregate or entity id that means nothing to the person reading the screen.
  identifier,

  /// The identity of the row, and the thing the user reads.
  ///
  /// A natural key - a module's name, an ISBN. It is what a command addresses and what a route is
  /// built from, exactly like [identifier], and it is also a column, exactly like [data]. The type
  /// cannot say which of the two an attribute is, because a natural key is an ordinary value object;
  /// the model states it with `@Key`.
  key,

  /// Where the row was projected from and which aggregate version it reflects.
  ///
  /// This is what makes "has the projection caught up with my write" answerable instead of guessed by
  /// sleeping, and it is never shown.
  source,
}

/// One instance of an enumeration, with the wording the model gives it.
class EnumValueDescriptor {
  /// Constructor with all data.
  const EnumValueDescriptor({required this.name, required this.text});

  /// The instance as it appears on the wire, e.g. `INCOME`.
  final String name;

  /// What to call it on screen.
  final ModelText text;
}

/// One attribute: a field of a read-model row, a parameter of a view method, or an attribute of a
/// command.
///
/// The same descriptor serves all three because a renderer does the same two things with each - draw
/// an input for it, or draw a cell showing it - and a filter that rendered unlike the field it filters
/// on would be a design accident, not a decision.
class AttributeDescriptor {
  /// Constructor with all data.
  const AttributeDescriptor({
    required this.name,
    required this.kind,
    this.role = AttributeRole.data,
    this.text,
    this.modelType,
    this.nested,
    this.optional = false,
    this.multiple = false,
    this.constraints = const <Constraint>[],
    this.values = const <EnumValueDescriptor>[],
  });

  /// Name on the wire, and the key everything else is looked up by.
  final String name;

  /// What kind of value it holds.
  final ValueKind kind;

  /// What it is for, which decides whether it is shown.
  final AttributeRole role;

  /// What to call it on screen. Absent only where the attribute is not [displayed].
  final ModelText? text;

  /// The model's own name for what it holds - the element type for a list, the declared type
  /// otherwise.
  ///
  /// What it is for: saying that two attributes are about the same thing when they are not called the
  /// same thing. A rename command's `newName` and a row's `name` are both a `CategoryName`, and that
  /// is the only statement in the model letting a form open with the value the row already holds.
  final String? modelType;

  /// The descriptor of the composite it holds, or `null` when it holds a value a cell can show.
  ///
  /// A composite value object - a person's name, a postal address - arrives as a JSON object, so a
  /// cell handed one has nothing printable and would render the map. This is what gives a cell the
  /// sub-attributes and their wording, and a form the fields to draw.
  final TypeDescriptor? nested;

  /// Whether the model allows it to be absent.
  final bool optional;

  /// Whether it holds several values rather than one.
  ///
  /// [kind], [constraints] and [values] describe one **element** either way. A list of categories is
  /// still an enumeration; what changes is that a renderer draws chips instead of a single value, and
  /// a form offers a multi-select instead of a picker.
  final bool multiple;

  /// The invariants the model declares on it.
  final List<Constraint> constraints;

  /// The instances, when [kind] is [ValueKind.enumeration]. Empty otherwise.
  final List<EnumValueDescriptor> values;

  /// Whether a screen shows this attribute.
  bool get displayed => role == AttributeRole.data || role == AttributeRole.key;

  /// Returns the first constraint [value] violates, or `null` when it satisfies all of them.
  String? validate(Object? value) {
    final label = text?.label ?? name;
    if (!optional) {
      final missing = const Required().validate(value, label);
      if (missing != null) {
        return missing;
      }
    }
    for (final constraint in constraints) {
      final message = constraint.validate(value, label);
      if (message != null) {
        return message;
      }
    }
    return null;
  }
}
