package org.fuin.dsl.cqrs.common.exceptions;

import java.io.Serial;
import java.util.Objects;
import org.fuin.objects4j.common.Contract;
import org.fuin.objects4j.common.ExceptionShortIdentifable;
import org.fuin.objects4j.core.KeyValue;
import org.fuin.objects4j.core.KeyValueEL;

/**
 * A name that is expected to be unique does already exist.
 */
public final class DuplicateNameException extends Exception implements ExceptionShortIdentifable {

    @Serial
    private static final long serialVersionUID = 1000L;

    /** Name this exception is transported under. */
    public static final String ELEMENT_NAME = "duplicate-name-exception";

    /** Unique short identifier of this exception. */
    public static final String SHORT_ID = "CQRSCO-DUPLICATE_NAME";

    private String name;
    
    /**
     * Constructs a new instance of the exception.
     *
     * @param name Represents 16-bit Unicode strings. See <a href="http://docs.oracle.com/javase/8/docs/api/java/lang/String.html">java.lang.String</a>.
     */
    public DuplicateNameException(final String name) {
        super(Objects.requireNonNull(KeyValueEL.replace("The name '{name}' already exists",  new KeyValue("name", name))));
        Contract.requireArgNotNull("name", name);
        
        this.name = name;
    }

@Override
public final String getShortId() {
    return SHORT_ID;
}
            
    /**
     * Returns: Represents 16-bit Unicode strings. See <a href="http://docs.oracle.com/javase/8/docs/api/java/lang/String.html">java.lang.String</a>.
     *
     * @return Current value.
     */
    public final String getName() {
        return name;
    }
    
}
