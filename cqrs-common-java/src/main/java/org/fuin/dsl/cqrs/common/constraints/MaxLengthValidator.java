package org.fuin.dsl.cqrs.common.constraints;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

/** Makes sure a string has at a maximum length. */
// CHECKSTYLE:OFF:LineLength
public final class MaxLengthValidator implements ConstraintValidator<MaxLength, String> {
    // CHECKSTYLE:ON:LineLength

    private int max;

    @Override
    public final void initialize(final MaxLength annotation) {
        this.max = annotation.value();
    }

    @Override
    public final boolean isValid(final String object, final ConstraintValidatorContext ctx) {
        // A null value is considered valid (use a separate not-null constraint to forbid null)
        return object == null || object.length() <= max;
    }

}
