package org.fuin.dsl.cqrs.common.constraints;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

/** Makes sure a string has at least a given length. */
// CHECKSTYLE:OFF:LineLength
public final class MinLengthValidator implements ConstraintValidator<MinLength, String> {
    // CHECKSTYLE:ON:LineLength

    private int min;

    @Override
    public final void initialize(final MinLength annotation) {
        this.min = annotation.value();
    }

    @Override
    public final boolean isValid(final String object, final ConstraintValidatorContext ctx) {
        // A null value is considered valid (use a separate not-null constraint to forbid null)
        return object == null || object.length() >= min;
    }

}
