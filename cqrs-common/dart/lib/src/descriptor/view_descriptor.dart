import 'package:cqrs_common/src/descriptor/attribute_descriptor.dart';
import 'package:cqrs_common/src/descriptor/model_text.dart';
import 'package:cqrs_common/src/descriptor/type_descriptor.dart';

// Re-exported so that everything naming a view's return type keeps finding it here, which is where it
// used to live and where every generated row still imports it from.
export 'package:cqrs_common/src/descriptor/type_descriptor.dart';

/// What a view method returns, and therefore what shape of screen it is.
enum MethodKind {
  /// Several rows. A list screen: cards on a phone, a dense table on a desktop.
  list,

  /// One row, or nothing. A detail screen: a pushed route on a phone, the right-hand pane beside the
  /// list on a desktop.
  detail,

  /// A single value. Never a screen - a badge, or a guard on a delete action.
  scalar,
}

/// One method of a view: a screen, a filter or a guard.
class MethodDescriptor {
  /// Constructor with all data.
  const MethodDescriptor({
    required this.id,
    required this.name,
    required this.path,
    required this.kind,
    required this.doc,
    this.text,
    this.params = const <AttributeDescriptor>[],
    this.returns,
    this.scalarKind,
  });

  /// `<View>.<method>` - the permission id, and the key into the UI catalogue. One id answers both
  /// "may I call this" and "what do I call it".
  final String id;

  /// Method name in the model, e.g. `listCategories`.
  final String name;

  /// Path segment below the view's rest path, e.g. `/list-categories`.
  final String path;

  /// What shape of screen this is.
  final MethodKind kind;

  /// The model's documentation of the method.
  final String doc;

  /// What to call it on screen.
  final ModelText? text;

  /// Its parameters - the filters of a list, the identity of a detail.
  final List<AttributeDescriptor> params;

  /// What it returns, for [MethodKind.list] and [MethodKind.detail].
  final TypeDescriptor? returns;

  /// What it returns, for [MethodKind.scalar].
  final ValueKind? scalarKind;

  /// Whether this method can be called with nothing filled in, which is what makes it a landing screen.
  bool get callableWithoutInput => params.every((p) => p.optional);
}

/// One view: a set of read methods over one projection, reachable under one rest path.
class ViewDescriptor {
  /// Constructor with all data.
  const ViewDescriptor({
    required this.id,
    required this.module,
    required this.restPath,
    required this.doc,
    required this.methods,
    this.text,
  });

  /// Name of the view, e.g. `CategoryView`. Assumed unique across the context, as in the permission
  /// catalogue.
  final String id;

  /// Model module that declares it, e.g. `categories.categoryview`. This is the name the installation's
  /// enabled-module set is expressed in, so it is what enablement is decided on.
  final String module;

  /// Rest path the view is served under, e.g. `/view/category`.
  final String restPath;

  /// The model's documentation of the view.
  final String doc;

  /// Its methods, in model order.
  final List<MethodDescriptor> methods;

  /// What to call it on screen.
  final ModelText? text;

  /// Returns the method with [id], or `null` when this view has none.
  MethodDescriptor? method(String id) {
    for (final method in methods) {
      if (method.id == id) {
        return method;
      }
    }
    return null;
  }
}
