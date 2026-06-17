package org.fuin.dsl.cqrs.common.basics;

import java.util.List;
import org.fuin.objects4j.common.Contract;
import org.jspecify.annotations.Nullable;

/** State of verification of an email address. */
public enum EmailAddressValidationState {

    /** There was no proof yet that the email address exists. */
    NOT_VERIFIED(1),
    
        /** It was confirmed that the email addess exists. */
    VERIFIED(2)
    
    ;
    
    private Integer value;
    
    /**
     * Returns: 32-bit signed two's complement integer, which has a minimum value of -231 and a maximum value of 231-1. See <a href="http://docs.oracle.com/javase/8/docs/api/java/lang/Integer.html">java.lang.Integer</a>.
     *
     * @return Current value.
     */
    public Integer getValue() {
        return value;
    }
    
    /** All instances. */
    public static final List<EmailAddressValidationState> ALL = List.of(
        NOT_VERIFIED, VERIFIED
    );
    
    /** Valid instances. */
    public static final List<EmailAddressValidationState> VALID = List.of(
        NOT_VERIFIED, VERIFIED
    );
    
    /** Deprecated instances. */
    public static final List<EmailAddressValidationState> DEPRECATED = List.of(
    );
    
    /**
     * Determines if it's possible to return an enumeration instance for the
     * given value.
     * 
     * @param value
     *            Value to check.
     * 
     * @return TRUE if the {@link #valueOf(Integer)} will return a value else
     *         FALSE.
     */
    public static boolean isValid(@Nullable final Integer value) {
        if (value == null) {
            return true;
        }
        for (final EmailAddressValidationState v : ALL) {
            if (v.getValue().equals(value)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Returns an enumeration instance for the given value. Throws an
     * {@link IllegalArgumentException} if the value is invalid.
     * 
     * @param value
     *            Value to check.
     * 
     * @return Instance
     */
    @Nullable
    public static EmailAddressValidationState valueOf(@Nullable final Integer value) {
        if (value == null) {
            return null;
        }
        for (final EmailAddressValidationState v : ALL) {
            if (v.getValue().equals(value)) {
                return v;
            }
        }
        throw new IllegalArgumentException("Unknown value: " + value);
    }
    
    private EmailAddressValidationState(final Integer value) {
        Contract.requireArgNotNull("value", value);
        
        this.value = value;
    }

}
