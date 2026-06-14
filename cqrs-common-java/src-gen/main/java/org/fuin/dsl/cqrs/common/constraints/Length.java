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
 * Makes sure a string has a defined length (min/max).
 */
@Target({ TYPE, METHOD, FIELD, ANNOTATION_TYPE, PARAMETER })
@Retention(RUNTIME)
@Constraint(validatedBy = LengthValidator.class)
@Documented
// CHECKSTYLE:OFF:LineLength
public @interface Length {

    /** Used to create an error message. */
    String message() default "Expected a length between {min} and {max} characters, but value was: '${validatedValue}'";

    /** Processing groups with which the constraint declaration is associated. */        
    Class<?>[] groups() default {};

    /** Payload with which the the constraint declaration is associated. */
    Class<? extends Payload>[] payload() default {};

    /** Expected minimum length (inclusive). */
    int min();
    
    /** Expected maximum length (inclusive). */
    int max();
    
}
//CHECKSTYLE:ON:LineLength
