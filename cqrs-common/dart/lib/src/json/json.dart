import 'dart:convert';

import 'package:decimal/decimal.dart';

/// Reads [key] off [json] as a string, failing loudly when it is absent or of the wrong type.
///
/// The generated `fromJson` methods use these rather than casting inline: a read model row that has
/// lost a field is a contract mismatch, and it should say which field rather than surface later as a
/// null somewhere else entirely.
String requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String) {
    return value;
  }
  throw FormatException("Expected a string at '$key', got: ${value.runtimeType}");
}

/// Reads [key] off [json] as a string, or `null` when it is absent.
String? optionalString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is String) {
    return value;
  }
  throw FormatException("Expected a string or nothing at '$key', got: ${value.runtimeType}");
}

/// Reads [key] off [json] as an integer, failing loudly when it is absent or of the wrong type.
int requiredInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is int) {
    return value;
  }
  throw FormatException("Expected an integer at '$key', got: ${value.runtimeType}");
}

/// Reads [key] off [json] as an integer, or `null` when it is absent.
int? optionalInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  throw FormatException("Expected an integer or nothing at '$key', got: ${value.runtimeType}");
}

/// Reads [key] off [json] as a boolean, failing loudly when it is absent or of the wrong type.
bool requiredBool(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is bool) {
    return value;
  }
  throw FormatException("Expected a boolean at '$key', got: ${value.runtimeType}");
}

/// Reads [key] off [json] as a boolean, or `null` when it is absent.
bool? optionalBool(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is bool) {
    return value;
  }
  throw FormatException("Expected a boolean or nothing at '$key', got: ${value.runtimeType}");
}

/// Reads [key] off [json] as a floating-point number, failing loudly when it is absent or not one.
///
/// Only for a model that asks for one. Nothing money-shaped comes through here - see [requiredDecimal].
double requiredDouble(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is num) {
    return value.toDouble();
  }
  throw FormatException("Expected a number at '$key', got: ${value.runtimeType}");
}

/// Reads [key] off [json] as a floating-point number, or `null` when it is absent.
double? optionalDouble(Map<String, dynamic> json, String key) {
  if (json[key] == null) {
    return null;
  }
  return requiredDouble(json, key);
}

/// Reads [key] off [json] as an exact decimal, failing loudly when it is absent or unparseable.
///
/// A number and a string are both accepted, because a decimal reaches a client either way: a JSON
/// number is what a serializer writes a `BigDecimal` as, a string is what one writes that wants the
/// digits to survive a reader that would round them. Neither is read through `double` - the whole
/// point of a `Decimal` is that a rate or an amount is not approximated on the way in.
Decimal requiredDecimal(Map<String, dynamic> json, String key) {
  final value = json[key];
  final decimal = value is num || value is String ? Decimal.tryParse(value.toString()) : null;
  if (decimal != null) {
    return decimal;
  }
  throw FormatException("Expected a decimal at '$key', got: $value");
}

/// Reads [key] off [json] as an exact decimal, or `null` when it is absent.
Decimal? optionalDecimal(Map<String, dynamic> json, String key) {
  if (json[key] == null) {
    return null;
  }
  return requiredDecimal(json, key);
}

/// Reads [key] off [json] as a date or timestamp, failing loudly when it is absent or unparseable.
///
/// The wire carries both as ISO-8601 strings - a `Date` as `2026-08-21`, a `Timestamp` with a time and
/// an offset - and `DateTime.parse` reads either. A date-only value comes back at midnight local time,
/// which is what a date means to a screen that only ever shows the day.
DateTime requiredDate(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String) {
    return DateTime.parse(value);
  }
  throw FormatException("Expected a date at '$key', got: ${value.runtimeType}");
}

/// Reads [key] off [json] as a date or timestamp, or `null` when it is absent.
DateTime? optionalDate(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is String) {
    return DateTime.parse(value);
  }
  throw FormatException("Expected a date or nothing at '$key', got: ${value.runtimeType}");
}

/// Reads [key] off [json] as binary content, failing loudly when it is absent or not decodable.
///
/// Bytes have no JSON form of their own, so they travel base64-encoded - which is what the JVM side
/// writes a `byte[]` as, and what this expects to find.
List<int> requiredBinary(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String) {
    return base64Decode(value);
  }
  throw FormatException("Expected base64 content at '$key', got: ${value.runtimeType}");
}

/// Reads [key] off [json] as binary content, or `null` when it is absent.
List<int>? optionalBinary(Map<String, dynamic> json, String key) {
  if (json[key] == null) {
    return null;
  }
  return requiredBinary(json, key);
}

/// Reads [key] off [json] as a nested object, failing loudly when it is absent or of the wrong type.
Map<String, dynamic> requiredObject(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is Map<String, dynamic>) {
    return value;
  }
  throw FormatException("Expected an object at '$key', got: ${value.runtimeType}");
}

/// Reads [key] off [json] as a nested object, or `null` when it is absent.
Map<String, dynamic>? optionalObject(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is Map<String, dynamic>) {
    return value;
  }
  throw FormatException("Expected an object or nothing at '$key', got: ${value.runtimeType}");
}

/// Applies a type's own reader to a value that may not be there.
///
/// Every reader a generated type offers - a constructor, a `fromWire`, a `fromJson` - takes a value,
/// because a wrapper cannot be built from nothing. So an optional attribute handles the absence out
/// here, once, instead of every reader having to answer for it.
T? optionalOf<T, V>(V? value, T Function(V) read) => value == null ? null : read(value);

/// Reads [key] off [json] as a list, converting each element with [read].
///
/// [read] takes one element as it arrives - a string, a number, a nested object - because what an
/// element becomes is the element type's business: an enum and an id read themselves from their wire
/// form, a row reads itself from a map, and a plain value is only cast.
List<T> requiredList<T>(Map<String, dynamic> json, String key, T Function(Object) read) {
  final value = json[key];
  if (value is List) {
    return value.map((e) {
      if (e == null) {
        throw FormatException("Expected no nulls in the list at '$key'");
      }
      return read(e as Object);
    }).toList(growable: false);
  }
  throw FormatException("Expected a list at '$key', got: ${value.runtimeType}");
}

/// Reads [key] off [json] as a list, or `null` when it is absent.
///
/// An absent list and an empty one are different answers, and both reach a client: a filter that was
/// not given is absent, a filter that matched nothing is empty. Neither is turned into the other here.
List<T>? optionalList<T>(Map<String, dynamic> json, String key, T Function(Object) read) {
  if (json[key] == null) {
    return null;
  }
  return requiredList(json, key, read);
}

/// Reads [body] as a list of objects, failing loudly when it is anything else.
List<Map<String, dynamic>> objectList(Object? body) {
  if (body is List) {
    return body.map((e) {
      if (e is Map<String, dynamic>) {
        return e;
      }
      throw FormatException('Expected a list of objects, found a ${e.runtimeType} in it');
    }).toList(growable: false);
  }
  throw FormatException('Expected a list of objects, got: ${body.runtimeType}');
}

/// Writes a calendar day the way the wire carries one: `2026-08-21`. A raw `DateTime` cannot be sent -
/// a JSON encoder refuses it, and a query string renders it `2026-08-21 00:00:00.000`.
String? wireDate(DateTime? value) {
  if (value == null) {
    return null;
  }
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year.toString().padLeft(4, '0')}-$month-$day';
}

/// Writes a point in time the way the wire carries one: ISO-8601.
String? wireTimestamp(DateTime? value) => value?.toIso8601String();
