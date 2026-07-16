package org.fuin.dsl.cqrs.common.constraints;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

import java.util.List;
import java.util.Objects;

/**
 * Makes sure a collection contains no null elements.
 */
public final class NoNullElementsValidator implements ConstraintValidator<NoNullElements, List<?>> {

    @Override
    public void initialize(final NoNullElements annotation) {
        // Nothing to do
    }

    @Override
    public boolean isValid(final List<?> list, final ConstraintValidatorContext ctx) {
        if (list == null || list.isEmpty()) {
            return true;
        }
        // Cannot use "filter(...).findFirst()" here: an Optional cannot hold the null element it found
        return list.stream().noneMatch(Objects::isNull);
    }

}
