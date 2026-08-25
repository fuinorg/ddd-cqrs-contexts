/// Fills the `${...}` placeholders of a model message from [read].
///
/// **Why this exists twice.** A command's message is a confirmation prompt, shown *before* the command
/// is sent, so the server cannot render it and the client must. On the JVM the same string is rendered
/// by Jakarta EL, which a Dart client has no equivalent of - so the model restricts what a command's
/// message may write to what both sides can do: a plain variable, or a dotted path. That restriction is
/// checked when the model is compiled, which is what keeps these two renderers saying the same thing.
///
/// [read] is asked for the first segment of each path. What comes back is walked one segment at a time
/// through `operator []`, which generated rows and generated enums both offer - Dart resolves members at
/// compile time, so a value that does not offer one cannot be asked for "the attribute called this".
///
/// **An unresolvable placeholder is left standing** rather than blanked. `${provider.id}` on screen is a
/// visible bug somebody reports; an empty gap in a sentence reads like the model meant it.
String renderMessage(String template, Object? Function(String) read) {
  final out = StringBuffer();
  var from = 0;
  while (true) {
    final start = template.indexOf(r'${', from);
    if (start < 0) {
      break;
    }
    final end = template.indexOf('}', start + 2);
    if (end < 0) {
      // Nothing closes it, so there is no placeholder here - only text that looks like one.
      break;
    }
    out.write(template.substring(from, start));
    final path = template.substring(start + 2, end).split('.');
    final value = _walk(_rootOf(path.first, read), path.skip(1));
    out.write(value == null ? template.substring(start, end + 1) : _text(value));
    from = end + 1;
  }
  out.write(template.substring(from));
  return out.toString();
}

/// The value the path starts at, or `null` when the bag does not hold it.
///
/// A row answers an attribute it does not have by throwing, which is right for a renderer reading a
/// descriptor and wrong here: a message naming something absent should leave its placeholder standing
/// like any other unresolvable one.
Object? _rootOf(String name, Object? Function(String) read) {
  try {
    return read(name);
  } on ArgumentError {
    return null;
  }
}

/// Walks the remaining segments, giving up rather than throwing at the first one that cannot be taken.
Object? _walk(Object? value, Iterable<String> steps) {
  var current = value;
  for (final step in steps) {
    if (current == null) {
      return null;
    }
    final dynamic holder = current;
    try {
      current = holder[step] as Object?;
    } on NoSuchMethodError {
      // The value has no lookup at all - an int, a DateTime.
      return null;
    } on TypeError {
      // It has one that is not keyed by name. A String is the trap here: "name.length" reaches its
      // operator [], which wants an index, and the failure is a TypeError rather than a missing method.
      return null;
    } on ArgumentError {
      // It is keyed by name, and does not carry this one.
      return null;
    }
  }
  return current;
}

/// How a resolved value reads in a sentence.
///
/// An enum's `toString()` is its Dart declaration - `ExchangeRateProvider.ecb` - which is no way to
/// finish "Import exchange rates from". Everything a model puts in a message is a value that reads for
/// itself; only an enumeration needs saying differently, and its own name is the honest fallback when
/// the caller has given it no wording.
String _text(Object value) {
  if (value is Enum) {
    final dynamic holder = value;
    try {
      return holder.wireName as String;
    } on NoSuchMethodError {
      return value.name;
    }
  }
  return value.toString();
}
