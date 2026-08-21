/// Everything the common context offers, in one import.
///
/// Every export earns its place by being in the model: a type is reachable here the moment it
/// compiles, and stops being reachable in the same step it is dropped. That is what makes this
/// file answer "what does this context offer" honestly, which a hand-kept list cannot.
///
/// One file per context on purpose - a library is Dart's namespace, and two contexts may name
/// the same thing differently or the same. Import the one you mean.
library;

export 'common/basics/comment.dart';
export 'common/basics/email_address.dart';
export 'common/basics/email_address_validation_state.dart';
export 'common/basics/file_path_and_name.dart';
export 'common/basics/gdpr_protection_level.dart';
export 'common/basics/gender.dart';
export 'common/basics/image.dart';
export 'common/basics/media_type.dart';
export 'common/basics/phone_number.dart';
export 'common/basics/phone_type.dart';
export 'common/basics/postal_address.dart';
export 'common/basics/versioned_entity_id_path.dart';
