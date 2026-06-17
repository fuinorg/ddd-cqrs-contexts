package org.fuin.dsl.cqrs.common.constraints;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

/** Makes sure a string has a defined length (min/max). */
// CHECKSTYLE:OFF:LineLength
public final class LengthValidator implements ConstraintValidator<Length, String> {
    // CHECKSTYLE:ON:LineLength

    private int min;

    private int max;

    @Override
    public final void initialize(final Length annotation) {
        this.min = annotation.min();
        this.max = annotation.max();
    }

    @Override
    public final boolean isValid(final String object, final ConstraintValidatorContext ctx) {
        // A null value is considered valid (use a separate not-null constraint to forbid null)
        if (object == null) {
            return true;
        }
        final int length = object.length();
        return length >= min && length <= max;
    }

}
