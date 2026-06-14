package org.fuin.dsl.cqrs.common.constraints;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import java.util.List;

/** Makes sure a collection is not empty. */
// CHECKSTYLE:OFF:LineLength
public final class ListNotEmptyValidator implements ConstraintValidator<ListNotEmpty, List> {
    // CHECKSTYLE:ON:LineLength

    @Override
    public final void initialize(final ListNotEmpty annotation) {
        // Nothing to initialize
    }

    @Override
    public final boolean isValid(final List object, final ConstraintValidatorContext ctx) {
        // A null list is considered valid (use a separate not-null constraint to forbid null)
        return object == null || !object.isEmpty();
    }

}
