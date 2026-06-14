package org.fuin.dsl.cqrs.common.constraints;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

/** Makes sure a numeric is not less than a given value. */
// CHECKSTYLE:OFF:LineLength
public final class MinValueValidator implements ConstraintValidator<MinValue, Long> {
    // CHECKSTYLE:ON:LineLength

    private long min;

    @Override
    public final void initialize(final MinValue annotation) {
        this.min = annotation.value();
    }

    @Override
    public final boolean isValid(final Long object, final ConstraintValidatorContext ctx) {
        // A null value is considered valid (use a separate not-null constraint to forbid null)
        return object == null || object >= min;
    }

}
