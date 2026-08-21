import 'package:cqrs_common/src/descriptor/command_descriptor.dart';
import 'package:cqrs_common/src/descriptor/model_text.dart';
import 'package:cqrs_common/src/descriptor/view_descriptor.dart';

/// One entry in the navigation hub: a bounded context, with everything it offers.
///
/// The user-facing unit of navigation is a *group* of model modules, not a single one. The model splits
/// `categories` into `categories` (the aggregate and its commands) and `categories.categoryview` (the
/// read side), and a user has no use for that distinction. The group is what appears in the hub; its
/// views are the tabs inside it.
///
/// Enablement is decided per model module, not per group, because that is the granularity the
/// installation's switch works at - so a view is offered when *its own* [ViewDescriptor.module] is
/// enabled, and the group appears when at least one of its views survives that and the permission
/// check.
class ModuleDescriptor {
  /// Constructor with all data.
  const ModuleDescriptor({
    required this.group,
    required this.modules,
    required this.dependsOn,
    required this.views,
    required this.commands,
    this.text,
  });

  /// Name of the group, e.g. `categories`. This is what a route is keyed by.
  final String group;

  /// The model modules that make it up, e.g. `categories` and `categories.categoryview`.
  final List<String> modules;

  /// Groups this one needs. Switching a module off is refused while something still enabled needs it,
  /// and this is the graph that answer is read from.
  final List<String> dependsOn;

  /// The views it declares, in the order a tab bar should offer them.
  final List<ViewDescriptor> views;

  /// The commands it declares.
  final List<CommandDescriptor> commands;

  /// What to call it on screen.
  final ModelText? text;

  /// The commands targeting [aggregate], in model order.
  Iterable<CommandDescriptor> commandsFor(String aggregate) =>
      commands.where((c) => c.target == aggregate);
}

/// Everything this release of the model offers, as one const value.
///
/// This is what navigation is built from. A client that hard-codes a module list stops being correct
/// the moment a bounded context is added; one that reads this is complete the day the model compiles.
class ModuleCatalogue {
  /// Constructor with all data.
  const ModuleCatalogue({required this.context, required this.modules});

  /// The bounded context these modules belong to, e.g. `com.example.shop`.
  final String context;

  /// The groups, sorted by name.
  final List<ModuleDescriptor> modules;

  /// Returns the group called [group], or `null` when this release has none.
  ModuleDescriptor? module(String group) {
    for (final module in modules) {
      if (module.group == group) {
        return module;
      }
    }
    return null;
  }

  /// Returns the view called [id], or `null` when this release has none.
  ViewDescriptor? view(String id) {
    for (final module in modules) {
      for (final view in module.views) {
        if (view.id == id) {
          return view;
        }
      }
    }
    return null;
  }

  /// Returns the command of type [type], or `null` when this release has none.
  CommandDescriptor? command(String type) {
    for (final module in modules) {
      for (final command in module.commands) {
        if (command.type == type) {
          return command;
        }
      }
    }
    return null;
  }

  /// Every view method id in this release - the permission catalogue as far as reads are concerned.
  Iterable<String> get viewMethodIds =>
      modules.expand((m) => m.views).expand((v) => v.methods).map((m) => m.id);

  /// Every command type in this release - the permission catalogue as far as writes are concerned.
  Iterable<String> get commandTypes => modules.expand((m) => m.commands).map((c) => c.type);
}
