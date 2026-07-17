package org.fuin.dsl.cqrs.countrycodes.codes;

import java.io.Serial;

/**
 * ISO 3166-2 subdivision code: the alpha-2 country code, a separator and up to three alphanumeric characters identifying a principal subdivision such as a province or state (e.g. "ID-RI" for the Riau province of Indonesia, "NG-RI" for the Rivers province in Nigeria).
 */
public final class SubdivisionCode extends AbstractSubdivisionCode {

    @Serial
    private static final long serialVersionUID = 1000L;
    
    /**
     * Default constructor.
     */
    @SuppressWarnings("NullAway.Init")
    protected SubdivisionCode() {
        super();
    }
    
    /**
     * Constructor with all data.
     *
     * @param value Represents 16-bit Unicode strings. See <a href="http://docs.oracle.com/javase/8/docs/api/java/lang/String.html">java.lang.String</a>.
     */
    public SubdivisionCode(final String value) {
        super(value);
    }
    
}
