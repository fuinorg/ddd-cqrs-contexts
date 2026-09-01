import 'package:cqrs_common/src/descriptor/command_descriptor.dart';
import 'package:cqrs_common/src/rules/rule_descriptor.dart';
import 'package:cqrs_common/src/rules/rule_predicate.dart';

/// What a menu does with one command, given the state of the thing it is about.
enum CommandAvailability {
  /// Shown and usable.
  offered,

  /// Not shown at all, because another action in the same menu carries the opposite condition and
  /// its presence is what says why this one is gone.
  hidden,

  /// Shown greyed out with the refusal's own wording, because nothing else in the menu explains the
  /// absence and a silently missing action is indistinguishable from a missing feature.
  disabled,
}

/// One command as a menu should offer it.
class GatedCommand {
  /// Constructor with all data.
  const GatedCommand(this.command, this.availability, {this.reason});

  /// The command.
  final CommandDescriptor command;

  /// What the menu does with it.
  final CommandAvailability availability;

  /// Why it cannot be taken, set only for [CommandAvailability.disabled].
  final String? reason;
}

/// How a menu should offer [commands] for the thing [read] and [identity] describe.
///
/// **Advisory, and stale by definition.** Every one of these rules is verified again on the server,
/// which is the authority; this only decides whether offering the action is worth the user's time. A
/// rule that cannot be answered here - a value the row does not carry, a shape the predicate did not
/// expect - leaves the command offered, because hiding something the server would have allowed looks
/// exactly like a feature that was never built.
///
/// **Why hiding is the default.** Nearly every gated command in a model has its opposite in the same
/// menu: `unassign` goes and `assign` is there, `ignore` goes and `reopen` is there. The menu then
/// reads as the row's state rather than as a gap, and it is shorter for it. That is decided per rule
/// rather than per command: an action is hidden only when *every* condition it failed is contradicted
/// by a condition some other action in this menu carries.
///
/// Where it is not - where removing the action would leave nothing behind saying why - the action
/// stays, disabled, wearing the sentence the server would have refused it with.
///
/// [reasonTemplate] supplies that sentence in the language on screen, looked up under the rule's own
/// [RuleDescriptor.text]. Without it the model's wording is used, which is English: the caption above a
/// disabled action comes from a bundle, and for as long as this did not, it was the one line on the
/// screen that did not follow the language.
List<GatedCommand> gateCommands(
  Iterable<CommandDescriptor> commands,
  Object? Function(String) read,
  String? identity, {
  String? Function(RuleDescriptor)? reasonTemplate,
}) {
  final all = commands.toList(growable: false);
  final failing = <int, List<RuleDescriptor>>{
    for (var i = 0; i < all.length; i++) i: all[i].failingRules(read, identity),
  };
  final gated = <GatedCommand>[];
  for (var i = 0; i < all.length; i++) {
    final failed = failing[i]!;
    if (failed.isEmpty) {
      gated.add(GatedCommand(all[i], CommandAvailability.offered));
      continue;
    }
    final elsewhere = <RulePredicate>[
      for (var j = 0; j < all.length; j++)
        if (j != i)
          for (final rule in all[j].rules) rule.carrierPredicate,
    ];
    final explained = failed.every((rule) =>
        elsewhere.any((other) => contradicts(rule.carrierPredicate, other)));
    gated.add(explained
        ? GatedCommand(all[i], CommandAvailability.hidden)
        : GatedCommand(all[i], CommandAvailability.disabled,
            reason: failed.first.reasonFor(read, identity,
                template: reasonTemplate?.call(failed.first))));
  }
  return gated;
}
