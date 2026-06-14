package org.fuin.dsl.cqrs.common.exceptions;

import java.util.Objects;
import org.fuin.objects4j.common.Contract;
import org.fuin.objects4j.core.KeyValue;

/**
 * The maximum number of items was exceeded.
 */
public final class LimitExceededException extends Exception {

    private static final long serialVersionUID = 1000L;

    private Integer max;
    
    /**
     * Constructs a new instance of the exception.
     *
     * @param max 32-bit signed two's complement integer, which has a minimum value of -231 and a maximum value of 231-1. See <a href="http://docs.oracle.com/javase/8/docs/api/java/lang/Integer.html">java.lang.Integer</a>.
     */
    public LimitExceededException(final Integer max) {
        super(Objects.requireNonNull(KeyValue.replace("The maximum number of items ({max}) was exceeded",  new KeyValue("max", max))));
        Contract.requireArgNotNull("max", max);
        
        this.max = max;
    }

    /**
     * Returns: 32-bit signed two's complement integer, which has a minimum value of -231 and a maximum value of 231-1. See <a href="http://docs.oracle.com/javase/8/docs/api/java/lang/Integer.html">java.lang.Integer</a>.
     *
     * @return Current value.
     */
    public final Integer getMax() {
        return max;
    }
    
}
