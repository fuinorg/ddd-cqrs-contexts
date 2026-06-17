package org.fuin.dsl.cqrs.common.basics;

import jakarta.annotation.Generated;
import jakarta.validation.Constraint;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import jakarta.validation.Payload;
import java.io.Serial;
import java.io.Serializable;
import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.util.Objects;
import javax.annotation.concurrent.Immutable;
import org.fuin.objects4j.common.AsStringCapable;
import org.fuin.objects4j.common.ConstraintViolationException;
import org.fuin.objects4j.common.HasPublicStaticIsValidMethod;
import org.fuin.objects4j.common.HasPublicStaticValueOfMethod;
import org.fuin.objects4j.common.ValueObjectWithBaseType;

/**
 * Path and name of a file in the storage.
 */
@Immutable
@Generated("Generated class - Manual changes will be overwritten")
@HasPublicStaticIsValidMethod
@HasPublicStaticValueOfMethod
public final class FilePathAndName implements ValueObjectWithBaseType<String>, Comparable<FilePathAndName>, Serializable, AsStringCapable {

    @Serial
    private static final long serialVersionUID = 1000L;

    private static final int MAX_LENGTH = 100;

    @FilePathAndNameStr
    private String value;

    /**
     * Protected default constructor for deserialization.
     */
    @SuppressWarnings("NullAway.Init")
    protected FilePathAndName() {
        super();
    }

    /**
     * Constructor with mandatory data.
     * 
     * @param value
     *            Value.
     */
    public FilePathAndName(final String value) {
        super();
        requireArgValid("value", value);
        this.value = value;
    }

    @Override
    public String asBaseType() {
        return value;
    }

    @Override
    public String toString() {
        return value;
    }

    @Override
    public String asString() {
        return value;
    }

    @Override
    public int hashCode() {
        return Objects.hash(value);
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final FilePathAndName other = (FilePathAndName) obj;
        return Objects.equals(value, other.value);
    }

    @Override
    public int compareTo(final FilePathAndName other) {
        return value.compareTo(other.value);
    }

    @Override
    public Class<String> getBaseType() {
        return String.class;
    }

    /**
     * Verifies that a given string can be converted into the type.
     * 
     * @param value
     *            Value to validate.
     * 
     * @return Returns {@literal true} if it's a valid type else {@literal false}.
     */
    public static boolean isValid(final String value) {
        if (value == null) {
            return true;
        }
        if (value.isEmpty()) {
            return false;
        }
        final String trimmed = value.trim();
        return trimmed.length() <= MAX_LENGTH;
    }

    /**
     * Verifies if the argument is valid and throws an exception if this is not
     * the case.
     * 
     * @param name
     *            Name of the value for a possible error message.
     * @param value
     *            Value to check.
     * 
     * @throws ConstraintViolationException
     *             The value was not valid.
     */
    public static void requireArgValid(final String name, final String value) throws ConstraintViolationException {

        if (!isValid(value)) {
            throw new ConstraintViolationException("The argument '" + name
                    + "' is not valid: '" + value + "'");
        }

    }

    /**
     * Ensures that the string can be converted into the type.
     */
    @Target({ ElementType.METHOD, ElementType.PARAMETER, ElementType.FIELD,
            ElementType.ANNOTATION_TYPE })
    @Retention(RetentionPolicy.RUNTIME)
    @Constraint(validatedBy = { Validator.class })
    @Documented
    public @interface FilePathAndNameStr {

        String message()

        default "{org.fuin.dsl.cqrs.common.basics.FilePathAndName.message}";

        Class<?>[] groups() default {};

        Class<? extends Payload>[] payload() default {};

    }

    /**
     * Validates if a string is compliant with the type.
     */
    public static final class Validator implements
            ConstraintValidator<FilePathAndNameStr, String> {

        @Override
        public void initialize(
                final FilePathAndNameStr annotation) {
            // Not used
        }

        @Override
        public boolean isValid(final String value,
                final ConstraintValidatorContext context) {
            return FilePathAndName.isValid(value);
        }

    }


}
