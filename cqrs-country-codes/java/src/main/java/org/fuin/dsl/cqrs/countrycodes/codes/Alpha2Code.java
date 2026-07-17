package org.fuin.dsl.cqrs.countrycodes.codes;

import java.io.Serial;

/**
 * ISO 3166-1 alpha-2 code: a two-letter code that represents a country name, recommended as the general purpose code (e.g. "DE" for Germany, "US" for the United States).
 */
public final class Alpha2Code extends AbstractAlpha2Code {

    @Serial
    private static final long serialVersionUID = 1000L;
    
    /**
     * Default constructor.
     */
    @SuppressWarnings("NullAway.Init")
    protected Alpha2Code() {
        super();
    }
    
    /**
     * Constructor with all data.
     *
     * @param value Represents 16-bit Unicode strings. See <a href="http://docs.oracle.com/javase/8/docs/api/java/lang/String.html">java.lang.String</a>.
     */
    public Alpha2Code(final String value) {
        super(value);
    }
    
}
