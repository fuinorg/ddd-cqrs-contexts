package org.fuin.dsl.cqrs.common.constraints;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

/** Makes sure a string has exactly a given size. */
// CHECKSTYLE:OFF:LineLength
public final class ExactLengthValidator implements ConstraintValidator<ExactLength, String> {
    // CHECKSTYLE:ON:LineLength

    private int expected;

    @Override
    public final void initialize(final ExactLength annotation) {
        this.expected = annotation.value();
    }

    @Override
    public final boolean isValid(final String object, final ConstraintValidatorContext ctx) {
        // A null value is considered valid (use a separate not-null constraint to forbid null)
        return object == null || object.length() == expected;
    }

}
