package org.fuin.dsl.cqrs.common.constraints;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

/** Makes sure a numeric is not less than or greater than a given value. */
// CHECKSTYLE:OFF:LineLength
public final class ValueRangeValidator implements ConstraintValidator<ValueRange, Long> {
    // CHECKSTYLE:ON:LineLength

    private long min;

    private long max;

    @Override
    public final void initialize(final ValueRange annotation) {
        this.min = annotation.min();
        this.max = annotation.max();
    }

    @Override
    public final boolean isValid(final Long object, final ConstraintValidatorContext ctx) {
        // A null value is considered valid (use a separate not-null constraint to forbid null)
        return object == null || (object >= min && object <= max);
    }

}
