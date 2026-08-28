/// The shape an entity identifier path is expected to have.
///
/// **Why a path needs a shape at all.** A child of a root there are many of cannot be addressed by its
/// own identifier - `TRANSACTION 45` exists in every account-year - so it travels as a path:
/// `ANNUAL_TRANSACTIONS 2026-a/TRANSACTION 45`. Untyped, such a path says nothing about what it
/// addresses, which is why a screen cannot tell one row's target from another's and a model can hold
/// fourteen of them all pointing at a transaction while stating it nowhere.
///
/// This is the same shape the JVM holds as `EntityIdPathSpec`, and the two match the same way. It is
/// deliberately about the **wire** form: a step names the entity type as it travels, `TRANSACTION`,
/// rather than a Dart class, because that is all a path string carries.
class EntityIdPathSpec {
  /// Constructor with the steps, in order.
  const EntityIdPathSpec(this.steps);

  /// The steps a path of this shape is made of.
  final List<EntityIdPathStep> steps;

  /// Whether [path] - the wire form, segments separated by a slash - has this shape.
  ///
  /// Answers `false` for anything it cannot read, rather than guessing: a path that does not parse is
  /// not a path of this shape either, and silently accepting one is how a wrong target reaches a screen.
  bool matches(String? path) {
    if (path == null) {
      return true;
    }
    return matchesSegments(path.split('/'));
  }

  /// Whether the already split [segments] have this shape.
  bool matchesSegments(List<String> segments) => _matches(0, segments, 0);

  /// The entity type this shape addresses, which is the type of its last step.
  String get addresses => steps.last.type;

  bool _matches(int stepIdx, List<String> segments, int segIdx) {
    if (stepIdx == steps.length) {
      return segIdx == segments.length;
    }
    final step = steps[stepIdx];
    var available = 0;
    while (segIdx + available < segments.length &&
        (step.max == null || available < step.max!) &&
        step.matchesSegment(segments[segIdx + available])) {
      available++;
    }
    // Backtracking rather than greedy: two unbounded steps of the same type in a row would otherwise
    // never match, and neither would a skippable one followed by something it could have swallowed.
    for (var taken = step.min; taken <= available; taken++) {
      if (_matches(stepIdx + 1, segments, segIdx + taken)) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() => steps.join(', ');
}

/// One step of a shape: the entity type it is made of, and how many of them it accepts.
///
/// The default is exactly one, which is every ordinary step. A wider range exists for an entity that may
/// contain another of its own kind - a role inside a role - and it is written out rather than marked,
/// because "may repeat" does not say whether the step may also be absent.
class EntityIdPathStep {
  /// Constructor with the entity type and, where it is not exactly one, how many it takes.
  const EntityIdPathStep(this.type, {this.min = 1, this.max = 1});

  /// The entity type as it travels, e.g. `TRANSACTION`.
  final String type;

  /// Fewest segments of this type the step accepts. Zero makes the step skippable.
  final int min;

  /// Most it accepts, or `null` for unbounded.
  final int? max;

  /// Whether one wire segment - `TRANSACTION 45` - is of this step's type.
  ///
  /// The type is the part before the first space, which is what makes a segment self-describing.
  bool matchesSegment(String segment) {
    final space = segment.indexOf(' ');
    return space > 0 && segment.substring(0, space) == type;
  }

  @override
  String toString() {
    if (min == 1 && max == 1) {
      return type;
    }
    return '$type[$min..${max ?? 'N'}]';
  }
}
