package org.fuin.dsl.cqrs.common.constraints;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import java.lang.annotation.Documented;
import java.lang.annotation.Retention;
import java.lang.annotation.Target;
import static java.lang.annotation.ElementType.ANNOTATION_TYPE;
import static java.lang.annotation.ElementType.FIELD;
import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.ElementType.PARAMETER;
import static java.lang.annotation.ElementType.TYPE;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

/**
 * Makes sure a numeric is not less than or greater than a given value.
 */
@Target({ TYPE, METHOD, FIELD, ANNOTATION_TYPE, PARAMETER })
@Retention(RUNTIME)
@Constraint(validatedBy = ValueRangeValidator.class)
@Documented
// CHECKSTYLE:OFF:LineLength
public @interface ValueRange {

    /** Used to create an error message. */
    String message() default "Expected a value between {min} and {max}, but actual was: ${validatedValue}";

    /** Processing groups with which the constraint declaration is associated. */        
    Class<?>[] groups() default {};

    /** Payload with which the the constraint declaration is associated. */
    Class<? extends Payload>[] payload() default {};

    /** Expected minimum value (inclusive). */
    long min();
    
    /** Expected maximum value (inclusive). */
    long max();
    
}
//CHECKSTYLE:ON:LineLength
