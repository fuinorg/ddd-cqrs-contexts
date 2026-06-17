package org.fuin.dsl.cqrs.common.constraints;

import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;
import java.util.List;

/**
 * Base class for the constraint validator tests. Provides a shared Bean Validation
 * {@link Validator} (backed by Hibernate Validator) and small helpers that report whether a bean
 * is free of violations and what (fully interpolated) messages it produced.
 */
abstract class ValidatorTestBase {

    private static final ValidatorFactory FACTORY = Validation.buildDefaultValidatorFactory();

    static final Validator VALIDATOR = FACTORY.getValidator();

    /** Returns {@code true} if the given bean has no constraint violations. */
    static boolean valid(final Object bean) {
        return VALIDATOR.validate(bean).isEmpty();
    }

    /**
     * Returns the interpolated messages of all constraint violations of the given bean. Forcing the
     * message to be built makes sure every message expression and parameter actually resolves
     * instead of failing silently during interpolation.
     */
    static List<String> messages(final Object bean) {
        return VALIDATOR.validate(bean).stream().map(ConstraintViolation::getMessage).toList();
    }

}
