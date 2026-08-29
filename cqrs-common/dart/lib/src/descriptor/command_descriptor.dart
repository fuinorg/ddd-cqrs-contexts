import 'package:cqrs_common/src/descriptor/attribute_descriptor.dart';
import 'package:cqrs_common/src/descriptor/model_text.dart';
import 'package:cqrs_common/src/rules/rule_descriptor.dart';
import 'package:cqrs_common/src/rules/rule_predicate.dart';
import 'package:cqrs_common/src/transport.dart';

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
    this.rules = const <RuleDescriptor>[],
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

  /// The attribute a refusal belongs on, or `null` when it belongs on the form as a whole.
  ///
  /// Read off what the server sent rather than from a table compiled into the client. A refusal carries
  /// the values it was about, keyed by the model's own attribute names, so the field is found by
  /// matching those keys against this command's own attributes - and a renamed attribute either matches
  /// on both sides or on neither.
  ///
  /// It used to be a map from an exception's *simple* name to a field, filled by the generator and
  /// joined to the server's *qualified* name with a substring. Both builds stayed green when a name
  /// changed, and the refusal silently stopped landing on its field.
  String? attributeFor(CommandResult result) {
    final data = result.data;
    if (data == null) {
      return null;
    }
    final displayed = attributes.where((a) => a.displayed).toList();

    // Exactly one, or none. Two of this command's fields named by the refusal means it does not say
    // which one it is about, and a message on the wrong field is worse than one above the form.
    final matching = displayed.where((a) => data.containsKey(a.name)).toList();
    if (matching.length == 1) {
      return matching.single.name;
    }

    // A form with one field: any field-level refusal is about it, whatever the refusal calls its own
    // values. This is what covers an edit, whose field is named after the change - `newName` where the
    // refusal says `name` - and it is exactly where matching on names alone stops working.
    if (displayed.length == 1) {
      return displayed.single.name;
    }
    return null;
  }

  /// The rules guarding this command that a client can answer for itself.
  ///
  /// **Advisory, and deliberately incomplete.** The server verifies every rule the model declares and
  /// refuses with a typed exception; these are the subset whose values are on the client at all, so a
  /// screen can avoid offering an action that is certain to be refused. A rule needing a parameter
  /// nobody has typed yet, or an answer only the server can look up, is not here - and neither is any
  /// rule when the row cannot supply what it reads.
  ///
  /// Empty means "nothing can be decided here", never "nothing guards this".
  final List<RuleDescriptor> rules;

  /// Whether the action needs a form at all, or is a bare confirm.
  bool get needsForm => attributes.any((a) => a.displayed);

  /// Whether any rule this client can answer says the command would be refused for [read]/[identity].
  ///
  /// Answers `false` when it cannot decide, which is what leaves the action offered: the server is
  /// authoritative either way, and hiding something it would have allowed is indistinguishable from a
  /// missing feature.
  bool refusedFor(Object? Function(String) read, String? identity) =>
      failingRules(read, identity).isNotEmpty;

  /// The rules this client can answer that say the command would be refused, in model order.
  ///
  /// A rule it cannot decide is not a failure: the server is authoritative either way, and hiding
  /// something it would have allowed is indistinguishable from a missing feature.
  List<RuleDescriptor> failingRules(Object? Function(String) read, String? identity) {
    final out = <RuleDescriptor>[];
    for (final rule in rules) {
      try {
        if (!rule.holdsFor(read, identity)) {
          out.add(rule);
        }
      } on RuleEvaluationException {
        // Cannot say. Offer it and let the server answer.
      }
    }
    return out;
  }
}
