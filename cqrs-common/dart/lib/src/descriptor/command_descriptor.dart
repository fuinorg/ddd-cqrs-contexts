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

/// Where the `entity-id-path` of a command comes from. Getting it wrong addresses the write at the
/// wrong aggregate.
///
/// A singleton aggregate is indistinguishable from an ordinary one here and arrives as
/// [clientGenerated], so a screen must also match [CommandDescriptor.targetType] against its rows.
enum CommandTargetOrigin {
  /// The client mints a fresh identifier. A new aggregate root with a surrogate id.
  clientGenerated,

  /// The parent's segment of the row's path - a new child entity, whose own id the write side assigns.
  parentOfRow,

  /// The path of the row being acted on, which is every ordinary change and removal.
  row,

  /// A natural key, which the client cannot compose without an encoding only the write side has.
  derived,
}

/// One command: an action a user can take, and the form that collects what it needs.
class CommandDescriptor {
  /// Constructor with all data.
  const CommandDescriptor({
    required this.type,
    required this.module,
    required this.target,
    required this.kind,
    this.targetType,
    this.targetOrigin = CommandTargetOrigin.row,
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

  /// The wire type it addresses, e.g. `CATEGORY`. Not recoverable from [target] - an
  /// `AccountTransactionId` is a `TRANSACTION` - and it is what matches a command against rows.
  final String? targetType;

  /// Where the `entity-id-path` is supposed to come from.
  final CommandTargetOrigin targetOrigin;

  /// The model's documentation of the command.
  final String doc;

  /// The model's message template, e.g. `Create ${kind} category '${name}'`. Written to be read by a
  /// person, and used for the confirmation a destructive action needs.
  final String message;

  /// What to call the action on screen.
  ///
  /// Optional, because wording is optional in the model: a command that states none still has to
  /// render, and a caller falls back to [doc] for it. It was null for every command until the grammar
  /// gave `command` the `slabel`/`label`/`tooltip` block every other named element carries - before
  /// that a menu entry could only show the sentence documenting the command.
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
