package org.fuin.dsl.cqrs.common.basics;

import java.util.List;
import org.fuin.objects4j.common.Contract;
import org.jspecify.annotations.Nullable;

/** Type of phone number. */
public enum PhoneType {

    /**
                     * A mobile phone number is a unique sequence of digits assigned
                     * to a mobile phone or mobile network for the purpose of making and 
                     * receiving calls, sending and receiving text messages, and using 
                     * other mobile services. It differs from a landline number because 
                     * it's associated with a mobile device and its wireless network connection, 
                     * allowing for mobility and use outside of a fixed location. 
                     */
    MOBILE(1),
    
        /**
                     * A landline phone number is a traditional telephone number connected 
                     * to a fixed-line network, typically using physical wires (copper or 
                     * fiber optic cables) to transmit voice calls. These numbers are associated
                     * with a specific location, like a home or office, and are part of the Public
                     * Switched Telephone Network (PSTN). Unlike mobile phones, landlines do not
                     * rely on cellular networks or radio waves. 
                     */
    LANDLINE(2)
    
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
    public static final List<PhoneType> ALL = List.of(
        MOBILE, LANDLINE
    );
    
    /** Valid instances. */
    public static final List<PhoneType> VALID = List.of(
        MOBILE, LANDLINE
    );
    
    /** Deprecated instances. */
    public static final List<PhoneType> DEPRECATED = List.of(
    );
    
    private PhoneType(final Integer value) {
        Contract.requireArgNotNull("value", value);
        
        this.value = value;
    }

}
