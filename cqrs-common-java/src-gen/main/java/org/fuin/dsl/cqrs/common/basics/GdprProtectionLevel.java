package org.fuin.dsl.cqrs.common.basics;

import java.util.List;
import org.fuin.objects4j.common.Contract;
import org.jspecify.annotations.Nullable;

/** Classification of the data related to the "General Data Protection Regulation" (GDPR). */
public enum GdprProtectionLevel {

    /**
                    * No protection required.
                    */
    NONE(0),
    
        /**
                    * Personal data whose unlawful processing could adversely affect the data subject's social standing or economic situation. 
                    * The impact of the damage would be limited and manageable.
                    */
    NORMAL(1),
    
        /**
                    * Personal data which, if processed unlawfully, could significantly affect the data subject's social standing or economic situation. 
                    * The impact on the data subject would be considerable.
                    */
    HIGH(2),
    
        /**
                    * Personal data that, if processed unlawfully, would pose a risk to life and limb or the personal freedom of the data subject.
                    * The consequences of the damage would be of a directly existentially threatening, catastrophic extent for those affected.
                    */
    VERY_HIGH(3)
    
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
    public static final List<GdprProtectionLevel> ALL = List.of(
        NONE, NORMAL, HIGH, VERY_HIGH
    );
    
    /** Valid instances. */
    public static final List<GdprProtectionLevel> VALID = List.of(
        NONE, NORMAL, HIGH, VERY_HIGH
    );
    
    /** Deprecated instances. */
    public static final List<GdprProtectionLevel> DEPRECATED = List.of(
    );
    
    private GdprProtectionLevel(final Integer value) {
        Contract.requireArgNotNull("value", value);
        
        this.value = value;
    }

}
