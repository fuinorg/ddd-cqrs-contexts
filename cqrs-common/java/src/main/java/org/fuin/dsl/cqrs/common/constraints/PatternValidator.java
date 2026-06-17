package org.fuin.dsl.cqrs.common.constraints;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

/** Makes sure a string matches a given pattern. */
// CHECKSTYLE:OFF:LineLength
// The pattern field is populated by the framework via initialize(), not the constructor.
@SuppressWarnings("NullAway.Init")
public final class PatternValidator implements ConstraintValidator<Pattern, String> {
    // CHECKSTYLE:ON:LineLength

    // Fully qualified to avoid a clash with the 'Pattern' annotation in this package
    private java.util.regex.Pattern pattern;

    @Override
    public final void initialize(final Pattern annotation) {
        this.pattern = java.util.regex.Pattern.compile(annotation.value());
    }

    @Override
    public final boolean isValid(final String object, final ConstraintValidatorContext ctx) {
        // A null value is considered valid (use a separate not-null constraint to forbid null)
        return object == null || pattern.matcher(object).matches();
    }

}
