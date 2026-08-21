import 'package:cqrs_common/src/descriptor/attribute_descriptor.dart';
import 'package:cqrs_common/src/descriptor/model_text.dart';

/// What a command does to the aggregate it targets, which decides how a screen offers it.
enum CommandKind {
  /// Brings the aggregate into being. There is at most one per aggregate, and it is the primary action
  /// of the module - the FAB on a phone, the toolbar button on a desktop.
  create,

  /// Changes an aggregate that already exists.
  modify,

  /// Ends it. Always confirmed, and confirmed destructively.
  remove,
}

/// One command: an action a user can take, and the form that collects what it needs.
class CommandDescriptor {
  /// Constructor with all data.
  const CommandDescriptor({
    required this.type,
    required this.module,
    required this.target,
    required this.kind,
    required this.doc,
    required this.message,
    this.text,
    this.attributes = const <AttributeDescriptor>[],
    this.rejections = const <String, String>{},
  });

  /// The command type, e.g. `CreateCategoryCommand`. This one string is three things at once: the last
  /// path segment of `POST /cmd/<type>`, the `EVENT_TYPE` the deserializer registry is keyed by, and
  /// the permission id.
  final String type;

  /// Model module that declares it, e.g. `categories`.
  final String module;

  /// Aggregate it targets, e.g. `Category`. This is what ties a command to the views that project the
  /// same aggregate, and therefore to the screens that should offer it.
  final String target;

  /// What it does to that aggregate.
  final CommandKind kind;

  /// The model's documentation of the command.
  final String doc;

  /// The model's message template, e.g. `Create ${kind} category '${name}'`. Written to be read by a
  /// person, and used for the confirmation a destructive action needs.
  final String message;

  /// What to call the action on screen.
  ///
  /// **Null for every command today.** The DSL grammar lets a module, a view and a view method carry
  /// `slabel`/`label`/`tooltip`, but a `command` carries only its documentation and its message - so
  /// there is no wording in the model for a generator to emit here. Until that changes this stays
  /// absent and a caller falls back to [doc]; when it changes, only the generator does.
  final ModelText? text;

  /// What the command needs, in model order.
  final List<AttributeDescriptor> attributes;

  /// Which attribute each business rule's refusal belongs on, keyed by the exception's simple name.
  ///
  /// A refusal arrives as the exception's **fully qualified class name** in `code` and the model's own
  /// wording in `message`, and the message is written to be read by a person. What the wire does not
  /// say is which field the rule was about - and showing "a category named X already exists" in a
  /// snackbar, rather than under the name field, is the difference between a correction and a puzzle.
  ///
  /// The model does know: a rule is declared on an operation and reads particular attributes. Guessing
  /// it from the class name works for `DuplicateCategoryNameException` and `name`, and stops working
  /// the moment the attribute is called `newName` - so it is stated rather than guessed, and the Dart
  /// target has to emit it from the operation's declared `business-rules`.
  final Map<String, String> rejections;

  /// The attribute the refusal [code] belongs on, or `null` when it belongs on the form as a whole.
  String? attributeFor(String? code) {
    if (code == null) {
      return null;
    }
    final simple = code.substring(code.lastIndexOf('.') + 1);
    return rejections[simple];
  }

  /// Whether the action needs a form at all, or is a bare confirm.
  bool get needsForm => attributes.any((a) => a.displayed);
}
