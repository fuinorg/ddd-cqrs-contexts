package org.fuin.dsl.cqrs.common.basics;

import java.util.List;
import org.fuin.objects4j.common.Contract;
import org.jspecify.annotations.Nullable;

/** The male sex or the female sex, especially when considered with reference to social and cultural differences rather than biological ones. */
public enum Gender {

    /** Not yet known. */
    UNKNOWN(0),
    
        /** A man or a boy. */
    MALE(1),
    
        /** A woman or a girl. */
    FEMALE(2),
    
        /** Not conform to the traditional male/female binary. */
    DIVERSE(3)
    
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
    public static final List<Gender> ALL = List.of(
        UNKNOWN, MALE, FEMALE, DIVERSE
    );
    
    /** Valid instances. */
    public static final List<Gender> VALID = List.of(
        UNKNOWN, MALE, FEMALE, DIVERSE
    );
    
    /** Deprecated instances. */
    public static final List<Gender> DEPRECATED = List.of(
    );
    
    private Gender(final Integer value) {
        Contract.requireArgNotNull("value", value);
        
        this.value = value;
    }

}
