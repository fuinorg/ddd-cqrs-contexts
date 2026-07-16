package org.fuin.dsl.cqrs.common.basics;

import java.io.Serial;
import org.fuin.objects4j.common.ConstraintViolationException;
import org.fuin.objects4j.core.Validators;
import org.jspecify.annotations.Nullable;

/**
 * A phone number is a unique sequence of digits assigned to a telephone line, enabling calls and text messages to reach a specific person or device. It acts as a unique identifier within a telecommunications network, allowing users to connect with others. Phone numbers are always stored in international format with plus sign (+), then country code, city code, and local phone number.
 */
public final class PhoneNumber extends AbstractPhoneNumber {

    @Serial
    private static final long serialVersionUID = 1000L;

    /** Separates the type from the number in the base type representation. A type name never contains it. */
    private static final char SEPARATOR = ' ';

    /**
     * Default constructor.
     */
    @SuppressWarnings("NullAway.Init")
    protected PhoneNumber() {
        super();
    }
    
    /**
     * Constructor with all data.
     *
     * @param typ Type of phone number.
     * @param value Represents 16-bit Unicode strings. See <a href="http://docs.oracle.com/javase/8/docs/api/java/lang/String.html">java.lang.String</a>.
     */
    public PhoneNumber(final PhoneType typ, final String value) {
        super(typ, value);
    }
    
    @Override
    public String asBaseType() {
        return getTyp().name() + SEPARATOR + getValue();
    }
    
    /**
     * Returns the information if a given string can be converted into
     * an instance of PhoneNumber. A <code>null</code> value returns <code>true</code>.
     * 
     * @param value
     *            Value to check.
     * 
     * @return TRUE if it's a valid string, else FALSE.
     */
    public static boolean isValid(@Nullable final String value) {
        if (value == null) {
            return true;
        }
        final int idx = value.indexOf(SEPARATOR);
        if (idx < 1) {
            return false;
        }
        if (toPhoneType(value.substring(0, idx)) == null) {
            return false;
        }
        // Verifies the constraints the model defines for the "value" attribute
        return Validators.get()
                .validateValue(PhoneNumber.class, "value", value.substring(idx + 1))
                .isEmpty();
    }
    
    /**
     * Parses a given string and returns a new instance of PhoneNumber.
     * 
     * @param value
     *            Value to convert. A <code>null</code> value returns
     *            <code>null</code>.
     * 
     * @return Converted value.
     */
    @Nullable
    public static PhoneNumber valueOf(@Nullable final String value) {
        if (value == null) {
            return null;
        }
        final int idx = value.indexOf(SEPARATOR);
        final PhoneType typ = idx < 1 ? null : toPhoneType(value.substring(0, idx));
        if (typ == null || !isValid(value)) {
            throw new ConstraintViolationException("The argument 'value' is not valid: '" + value + "'");
        }
        return new PhoneNumber(typ, value.substring(idx + 1));
    }

    /**
     * Returns the phone type with a given name.
     *
     * @param name
     *            Name to find.
     *
     * @return Type or <code>null</code> if there is no type with that name.
     */
    @Nullable
    private static PhoneType toPhoneType(final String name) {
        for (final PhoneType type : PhoneType.ALL) {
            if (type.name().equals(name)) {
                return type;
            }
        }
        return null;
    }

}
