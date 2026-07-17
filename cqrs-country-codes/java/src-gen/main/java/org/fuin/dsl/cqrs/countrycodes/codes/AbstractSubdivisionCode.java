package org.fuin.dsl.cqrs.countrycodes.codes;

import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import java.io.Serial;
import java.io.Serializable;
import org.fuin.objects4j.common.Contract;
import org.fuin.objects4j.common.ValueObject;
import org.fuin.objects4j.ui.Examples;

/**
 * ISO 3166-2 subdivision code: the alpha-2 country code, a separator and up to three alphanumeric characters identifying a principal subdivision such as a province or state (e.g. "ID-RI" for the Riau province of Indonesia, "NG-RI" for the Rivers province in Nigeria).
 */
public abstract class AbstractSubdivisionCode implements ValueObject, Serializable {

    @Serial
    private static final long serialVersionUID = 1000L;
    
    @Size(min=4, max=6) 
    @Pattern(regexp="[A-Z]{2}-[A-Z0-9]{1,3}")
    @Examples(value = { "ID-RI","NG-RI" })
    private String value;
    
    /**
     * Default constructor.
     */
    @SuppressWarnings("NullAway.Init")
    protected AbstractSubdivisionCode() {
        super();
    }
    
    /**
     * Constructor with all data.
     *
     * @param value Represents 16-bit Unicode strings. See <a href="http://docs.oracle.com/javase/8/docs/api/java/lang/String.html">java.lang.String</a>.
     */
    public AbstractSubdivisionCode(@Size(min=4, max=6) @Pattern(regexp="[A-Z]{2}-[A-Z0-9]{1,3}") final String value) {
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
