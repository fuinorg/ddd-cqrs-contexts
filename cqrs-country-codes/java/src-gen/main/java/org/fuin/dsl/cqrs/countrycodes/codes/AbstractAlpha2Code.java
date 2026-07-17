package org.fuin.dsl.cqrs.countrycodes.codes;

import jakarta.validation.constraints.Pattern;
import java.io.Serial;
import java.io.Serializable;
import org.fuin.objects4j.common.Contract;
import org.fuin.objects4j.common.ValueObject;
import org.fuin.objects4j.ui.Examples;

/**
 * ISO 3166-1 alpha-2 code: a two-letter code that represents a country name, recommended as the general purpose code (e.g. "DE" for Germany, "US" for the United States).
 */
public abstract class AbstractAlpha2Code implements ValueObject, Serializable {

    @Serial
    private static final long serialVersionUID = 1000L;
    
    @Pattern(regexp="[A-Z]{2}")
    @Examples(value = { "DE","US" })
    private String value;
    
    /**
     * Default constructor.
     */
    @SuppressWarnings("NullAway.Init")
    protected AbstractAlpha2Code() {
        super();
    }
    
    /**
     * Constructor with all data.
     *
     * @param value Represents 16-bit Unicode strings. See <a href="http://docs.oracle.com/javase/8/docs/api/java/lang/String.html">java.lang.String</a>.
     */
    public AbstractAlpha2Code(@Pattern(regexp="[A-Z]{2}") final String value) {
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
