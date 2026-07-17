package org.fuin.dsl.cqrs.countrycodes.codes;

import java.io.Serial;

/**
 * ISO 3166-1 alpha-3 code: a three-letter code that represents a country name, which is usually more closely related to the country name (e.g. "DEU" for Germany, "USA" for the United States).
 */
public final class Alpha3Code extends AbstractAlpha3Code {

    @Serial
    private static final long serialVersionUID = 1000L;
    
    /**
     * Default constructor.
     */
    @SuppressWarnings("NullAway.Init")
    protected Alpha3Code() {
        super();
    }
    
    /**
     * Constructor with all data.
     *
     * @param value Represents 16-bit Unicode strings. See <a href="http://docs.oracle.com/javase/8/docs/api/java/lang/String.html">java.lang.String</a>.
     */
    public Alpha3Code(final String value) {
        super(value);
    }
    
}
