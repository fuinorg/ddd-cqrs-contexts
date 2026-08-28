import 'package:cqrs_common/cqrs_common.dart';
import 'package:test/test.dart';

/// Mirrors `EntityIdPathSpecTest` on the JVM, because a path checked on one side and the same path
/// checked on the other must not disagree.
void main() {
  const twoSteps = EntityIdPathSpec(<EntityIdPathStep>[
    EntityIdPathStep('ANNUAL_TRANSACTIONS'),
    EntityIdPathStep('TRANSACTION'),
  ]);

  test('steps take exactly one by default', () {
    expect(twoSteps.matches('ANNUAL_TRANSACTIONS 2026-a/TRANSACTION 45'), isTrue);
    expect(twoSteps.matches('ANNUAL_TRANSACTIONS 2026-a'), isFalse);
    expect(twoSteps.matches('TRANSACTION 45/ANNUAL_TRANSACTIONS 2026-a'), isFalse);
    expect(twoSteps.matches('ANNUAL_TRANSACTIONS 2026-a/TRANSACTION 45/TRANSACTION 46'), isFalse);
  });

  test('an unbounded step takes one or more', () {
    const spec = EntityIdPathSpec(<EntityIdPathStep>[
      EntityIdPathStep('MASTER_DATA'),
      EntityIdPathStep('MASTERDATA_ROLE', max: null),
    ]);

    expect(spec.matches('MASTER_DATA 1/MASTERDATA_ROLE 2'), isTrue);
    expect(spec.matches('MASTER_DATA 1/MASTERDATA_ROLE 2/MASTERDATA_ROLE 3'), isTrue);
    // One or more, so the root on its own never addresses a role.
    expect(spec.matches('MASTER_DATA 1'), isFalse);
  });

  test('a skippable step may be absent', () {
    const spec = EntityIdPathSpec(<EntityIdPathStep>[
      EntityIdPathStep('COMPANY'),
      EntityIdPathStep('DEPARTEMENT', min: 0, max: null),
      EntityIdPathStep('GROUP'),
    ]);

    expect(spec.matches('COMPANY a/GROUP g'), isTrue);
    expect(spec.matches('COMPANY a/DEPARTEMENT d/GROUP g'), isTrue);
    expect(spec.matches('COMPANY a/DEPARTEMENT d/DEPARTEMENT e/GROUP g'), isTrue);
    expect(spec.matches('COMPANY a/DEPARTEMENT d'), isFalse);
  });

  test('a bounded step has a ceiling', () {
    const spec = EntityIdPathSpec(<EntityIdPathStep>[
      EntityIdPathStep('COMPANY'),
      EntityIdPathStep('DEPARTEMENT', min: 1, max: 2),
    ]);

    expect(spec.matches('COMPANY a/DEPARTEMENT d'), isTrue);
    expect(spec.matches('COMPANY a/DEPARTEMENT d/DEPARTEMENT e'), isTrue);
    expect(spec.matches('COMPANY a/DEPARTEMENT d/DEPARTEMENT e/DEPARTEMENT f'), isFalse);
  });

  test('a segment that is not typed at all matches nothing', () {
    // A bare id with no type in front is exactly what an untyped path leaves you holding.
    expect(twoSteps.matches('2026-a/45'), isFalse);
  });

  test('a path that is not there has no shape to be wrong about', () {
    expect(twoSteps.matches(null), isTrue);
  });

  test('it says what it wanted, and what it addresses', () {
    const spec = EntityIdPathSpec(<EntityIdPathStep>[
      EntityIdPathStep('COMPANY'),
      EntityIdPathStep('DEPARTEMENT', max: null),
      EntityIdPathStep('GROUP', min: 0, max: 2),
    ]);

    expect(spec.toString(), 'COMPANY, DEPARTEMENT[1..N], GROUP[0..2]');
    expect(spec.addresses, 'GROUP');
  });
}
