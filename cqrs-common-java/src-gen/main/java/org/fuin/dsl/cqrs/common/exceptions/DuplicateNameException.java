package org.fuin.dsl.cqrs.common.exceptions;

import java.io.Serial;
import java.util.Objects;
import org.fuin.objects4j.common.Contract;
import org.fuin.objects4j.core.KeyValue;

/**
 * A name that is expected to be unique does already exist.
 */
public final class DuplicateNameException extends Exception {

    @Serial
    private static final long serialVersionUID = 1000L;

    private String name;
    
    /**
     * Constructs a new instance of the exception.
     *
     * @param name Represents 16-bit Unicode strings. See <a href="http://docs.oracle.com/javase/8/docs/api/java/lang/String.html">java.lang.String</a>.
     */
    public DuplicateNameException(final String name) {
        super(Objects.requireNonNull(KeyValue.replace("The name '{name}' already exists",  new KeyValue("name", name))));
        Contract.requireArgNotNull("name", name);
        
        this.name = name;
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
