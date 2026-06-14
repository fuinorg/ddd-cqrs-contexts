package org.fuin.dsl.cqrs.common.constraints;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import java.util.List;

/** Makes sure a list has a defined size (min/max). */
// CHECKSTYLE:OFF:LineLength
public final class ListLengthValidator implements ConstraintValidator<ListLength, List> {
    // CHECKSTYLE:ON:LineLength

    private int min;

    private int max;

    @Override
    public final void initialize(final ListLength annotation) {
        this.min = annotation.min();
        this.max = annotation.max();
    }

    @Override
    public final boolean isValid(final List object, final ConstraintValidatorContext ctx) {
        // A null list is considered valid (use a separate not-null constraint to forbid null)
        if (object == null) {
            return true;
        }
        final int size = object.size();
        return size >= min && size <= max;
    }

}
