package org.fuin.dsl.cqrs.common.constraints;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

/** Makes sure a string is not empty. */
// CHECKSTYLE:OFF:LineLength
public final class NotEmptyValidator implements ConstraintValidator<NotEmpty, String> {
    // CHECKSTYLE:ON:LineLength

    @Override
    public final void initialize(final NotEmpty annotation) {
        // Nothing to initialize
    }

    @Override
    public final boolean isValid(final String object, final ConstraintValidatorContext ctx) {
        // A null value is considered valid (use a separate not-null constraint to forbid null)
        return object == null || !object.isEmpty();
    }

}
