package org.fuin.dsl.cqrs.common.constraints;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import java.util.List;

/** Makes sure a collection contains no null elements. */
// CHECKSTYLE:OFF:LineLength
public final class NoNullElementsValidator implements ConstraintValidator<NoNullElements, List> {
    // CHECKSTYLE:ON:LineLength

    @Override
    public final void initialize(final NoNullElements annotation) {
        // Nothing to initialize
    }

    @Override
    public final boolean isValid(final List object, final ConstraintValidatorContext ctx) {
        // A null list is considered valid (use a separate not-null constraint to forbid null)
        if (object == null) {
            return true;
        }
        for (final Object element : object) {
            if (element == null) {
                return false;
            }
        }
        return true;
    }

}
