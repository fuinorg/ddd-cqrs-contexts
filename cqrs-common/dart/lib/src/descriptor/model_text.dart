/// What to call one model element on screen, as the model states it.
///
/// The JVM side reads this off `@ShortLabel`/`@Label`/`@Tooltip`/`@Prompt` annotations at runtime.
/// Flutter cannot: `dart:mirrors` is unsupported, so there is no annotation analyzer to write and the
/// wording has to arrive as generated const data instead. This is that data.
///
/// Any of the four texts may be `null` - a model states the wording it has a use for, not all of it.
/// Absent is deliberately different from empty: it lets a caller tell "the model says nothing" from
/// "the model says this", and decide for itself what to do about it.
///
/// [bundle] and [key] are carried so a translation can be looked up later without touching a widget:
/// the generated `.arb` files are keyed the same way, so a German build is a second `.arb` and nothing
/// else. A bundle translates what the model states; it does not add to it.
class ModelText {
  /// Constructor with all data.
  const ModelText({
    required this.bundle,
    required this.key,
    this.shortLabel,
    this.label,
    this.tooltip,
    this.prompt,
  });

  /// Resource bundle of the module that declares the element.
  final String bundle;

  /// Key to look this element's texts up under, suffixed `.slabel`, `.label`, `.tooltip`, `.prompt`.
  final String key;

  /// Short form, for a column heading or a tab.
  final String? shortLabel;

  /// Full form, for a form field label or a heading.
  final String? label;

  /// Help text - a field's helper line on desktop, an info affordance on mobile.
  final String? tooltip;

  /// What a plausible value looks like, for a field's placeholder.
  final String? prompt;

  /// Whether the model states any wording at all. An absent block and an empty one are the same.
  bool get states => shortLabel != null || label != null || tooltip != null;
}
