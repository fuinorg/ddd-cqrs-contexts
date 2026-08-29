package org.fuin.dsl.cqrs.common.exceptions;

import java.io.Serial;
import java.util.Objects;
import org.fuin.objects4j.common.Contract;
import org.fuin.objects4j.common.ExceptionShortIdentifable;
import org.fuin.objects4j.core.KeyValue;
import org.fuin.objects4j.core.KeyValueEL;

/**
 * The maximum number of items was exceeded.
 */
public final class LimitExceededException extends Exception implements ExceptionShortIdentifable {

    @Serial
    private static final long serialVersionUID = 1000L;

    /** Name this exception is transported under. */
    public static final String ELEMENT_NAME = "limit-exceeded-exception";

    /** Unique short identifier of this exception. */
    public static final String SHORT_ID = "CQRSCO-LIMIT_EXCEEDED";

    private int max;
    
    /**
     * Constructs a new instance of the exception.
     *
     * @param max 32-bit signed two's complement integer, which has a minimum value of -231 and a maximum value of 231-1. See <a href="http://docs.oracle.com/javase/8/docs/api/java/lang/Integer.html">java.lang.Integer</a>.
     */
    public LimitExceededException(final int max) {
        super(Objects.requireNonNull(KeyValueEL.replace("The maximum number of items ({max}) was exceeded",  new KeyValue("max", max))));
        Contract.requireArgNotNull("max", max);
        
        this.max = max;
    }

@Override
public final String getShortId() {
    return SHORT_ID;
}
            
    /**
     * Returns: 32-bit signed two's complement integer, which has a minimum value of -231 and a maximum value of 231-1. See <a href="http://docs.oracle.com/javase/8/docs/api/java/lang/Integer.html">java.lang.Integer</a>.
     *
     * @return Current value.
     */
    public final int getMax() {
        return max;
    }
    
}
