package org.fuin.dsl.cqrs.countrycodes.codes;

import java.io.Serial;

/**
 * ISO 3166-1 numeric code: a three-digit code that represents a country name (e.g. "276" for Germany, "840" for the United States). Stored as a string to preserve leading zeros (e.g. "004" for Afghanistan).
 */
public final class NumericCode extends AbstractNumericCode {

    @Serial
    private static final long serialVersionUID = 1000L;
    
    /**
     * Default constructor.
     */
    @SuppressWarnings("NullAway.Init")
    protected NumericCode() {
        super();
    }
    
    /**
     * Constructor with all data.
     *
     * @param value Represents 16-bit Unicode strings. See <a href="http://docs.oracle.com/javase/8/docs/api/java/lang/String.html">java.lang.String</a>.
     */
    public NumericCode(final String value) {
        super(value);
    }
    
}
