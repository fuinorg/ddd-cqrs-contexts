/// The types every model reaches into, and the runtime the generated code of any model speaks.
///
/// Two halves, and the split is the point:
///
/// - `src/` is **hand-written and permanent** - the descriptor types, the constraint types, the
///   transport interfaces and the JSON helpers. Nothing here knows about any bounded context, which is
///   why it is listed by hand: it does not change when a model does.
/// - `src-gen/` is **generated** from the `common` context and exports itself through `src-gen/model.dart`.
library;

export 'src/descriptor/attribute_descriptor.dart';
export 'src/descriptor/command_descriptor.dart';
export 'src/descriptor/constraint.dart';
export 'src/descriptor/model_text.dart';
export 'src/descriptor/module_catalogue.dart';
export 'src/descriptor/type_descriptor.dart';
export 'src/descriptor/view_descriptor.dart';
export 'src/json/json.dart';
export 'src/transport.dart';
export 'src-gen/common.dart';
