package org.fuin.dsl.cqrs.common.basics;

import java.io.Serial;
import java.util.List;

/**
 * A postal address, also known as a mailing address, is the location where mail and packages can be delivered. It typically includes the recipient's name, street address or P.O. Box number, city, state, and postal code.
 */
public final class PostalAddress extends AbstractPostalAddress {

    @Serial
    private static final long serialVersionUID = 1000L;
    
    /**
     * Default constructor.
     */
    @SuppressWarnings("NullAway.Init")
    protected PostalAddress() {
        super();
    }
    
    /**
     * Constructor with all data.
     *
     * @param lines An ordered collection (also known as sequence). See <a href="http://docs.oracle.com/javase/8/docs/api/java/util/List.htmll">java.util.List</a>.
     */
    public PostalAddress(final List<String> lines) {
        super(lines);
    }
    
}
