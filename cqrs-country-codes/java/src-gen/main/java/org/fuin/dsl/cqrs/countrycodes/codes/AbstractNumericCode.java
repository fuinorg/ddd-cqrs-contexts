package org.fuin.dsl.cqrs.countrycodes.codes;

import jakarta.validation.constraints.Pattern;
import java.io.Serial;
import java.io.Serializable;
import org.fuin.objects4j.common.Contract;
import org.fuin.objects4j.common.ValueObject;
import org.fuin.objects4j.ui.Examples;

/**
 * ISO 3166-1 numeric code: a three-digit code that represents a country name (e.g. "276" for Germany, "840" for the United States). Stored as a string to preserve leading zeros (e.g. "004" for Afghanistan).
 */
public abstract class AbstractNumericCode implements ValueObject, Serializable {

    @Serial
    private static final long serialVersionUID = 1000L;
    
    @Pattern(regexp="[0-9]{3}")
    @Examples(value = { "276","840","004" })
    private String value;
    
    /**
     * Default constructor.
     */
    @SuppressWarnings("NullAway.Init")
    protected AbstractNumericCode() {
        super();
    }
    
    /**
     * Constructor with all data.
     *
     * @param value Represents 16-bit Unicode strings. See <a href="http://docs.oracle.com/javase/8/docs/api/java/lang/String.html">java.lang.String</a>.
     */
    public AbstractNumericCode(@Pattern(regexp="[0-9]{3}") final String value) {
        super();
        Contract.requireArgNotNull("value", value);
        
        this.value = value;
    }
    
    /**
     * Returns: Represents 16-bit Unicode strings. See <a href="http://docs.oracle.com/javase/8/docs/api/java/lang/String.html">java.lang.String</a>.
     *
     * @return Current value.
     */
    public final String getValue() {
        return value;
    }
    
}
