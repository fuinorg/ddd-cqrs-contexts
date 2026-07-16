package org.fuin.dsl.cqrs.common.basics;

import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;
import java.util.List;

/**
 * Base class for the value object tests. Provides a shared Bean Validation {@link Validator} (backed by
 * Hibernate Validator) and small helpers that report whether a value object is free of violations and what
 * (fully interpolated) messages it produced. This verifies the constraints the model defines as "invariants"
 * are actually enforced by the annotations the code generator creates from them.
 */
abstract class ValueObjectTestBase {

    private static final ValidatorFactory FACTORY = Validation.buildDefaultValidatorFactory();

    static final Validator VALIDATOR = FACTORY.getValidator();

    /** Returns {@code true} if the given value object has no constraint violations. */
    static boolean valid(final Object obj) {
        return VALIDATOR.validate(obj).isEmpty();
    }

    /**
     * Returns the interpolated messages of all constraint violations of the given value object. Forcing the
     * message to be built makes sure every message expression and parameter actually resolves instead of
     * failing silently during interpolation.
     */
    static List<String> messages(final Object obj) {
        return VALIDATOR.validate(obj).stream().map(ConstraintViolation::getMessage).toList();
    }

}
