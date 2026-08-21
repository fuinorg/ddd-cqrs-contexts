import 'package:decimal/decimal.dart';

/// An invariant the model declares on a value, checked before the round trip.
///
/// This never replaces the server's answer - the server checks every rule again and its refusal is the
/// one that counts. It only saves a round trip and points at the field that is wrong, which is the same
/// division of labour the JavaFX client's `ModelConstraints` follows.
sealed class Constraint {
  /// Constructor.
  const Constraint();

  /// Returns a message naming what is wrong with [value], or `null` when it satisfies this constraint.
  ///
  /// [label] is what to call the value in the message - the field's label from the model, so the
  /// wording a user reads is the wording the model states.
  String? validate(Object? value, String label);
}

/// The value must be present.
class Required extends Constraint {
  /// Constructor.
  const Required();

  @override
  String? validate(Object? value, String label) {
    if (value == null || (value is String && value.isEmpty)) {
      return '$label is required';
    }
    return null;
  }
}

/// The text length must lie between [min] and [max] inclusive.
class Length extends Constraint {
  /// Constructor.
  const Length(this.min, this.max);

  /// Shortest accepted length.
  final int min;

  /// Longest accepted length.
  final int max;

  @override
  String? validate(Object? value, String label) {
    if (value == null) {
      return null;
    }
    final length = value.toString().length;
    if (length < min) {
      return min == 1 ? '$label is required' : '$label must be at least $min characters';
    }
    if (length > max) {
      return '$label must be at most $max characters';
    }
    return null;
  }
}

/// The decimal value must lie between [min] and [max] inclusive, either of which may be absent.
class DecimalRange extends Constraint {
  /// Constructor.
  const DecimalRange({this.min, this.max});

  /// Smallest accepted value, or `null` for unbounded.
  final Decimal? min;

  /// Largest accepted value, or `null` for unbounded.
  final Decimal? max;

  @override
  String? validate(Object? value, String label) {
    if (value == null) {
      return null;
    }
    final decimal = value is Decimal ? value : Decimal.tryParse(value.toString());
    if (decimal == null) {
      return '$label is not a number';
    }
    if (min != null && decimal < min!) {
      return '$label must be at least $min';
    }
    if (max != null && decimal > max!) {
      return '$label must be at most $max';
    }
    return null;
  }
}
