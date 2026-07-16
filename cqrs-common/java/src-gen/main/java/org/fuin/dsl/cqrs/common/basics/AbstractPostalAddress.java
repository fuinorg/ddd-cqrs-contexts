package org.fuin.dsl.cqrs.common.basics;

import jakarta.validation.constraints.Size;
import java.io.Serial;
import java.io.Serializable;
import java.util.List;
import org.fuin.objects4j.common.Contract;
import org.fuin.objects4j.common.ValueObject;

/**
 * A postal address, also known as a mailing address, is the location where mail and packages can be delivered. It typically includes the recipient's name, street address or P.O. Box number, city, state, and postal code.
 */
public abstract class AbstractPostalAddress implements ValueObject, Serializable {

    @Serial
    private static final long serialVersionUID = 1000L;
    
    @Size(min=1, max=10)
    private List<String> lines;
    
    /**
     * Default constructor.
     */
    @SuppressWarnings("NullAway.Init")
    protected AbstractPostalAddress() {
        super();
    }
    
    /**
     * Constructor with all data.
     *
     * @param lines An ordered collection (also known as sequence). See <a href="http://docs.oracle.com/javase/8/docs/api/java/util/List.htmll">java.util.List</a>.
     */
    public AbstractPostalAddress(@Size(min=1, max=10) final List<String> lines) {
        super();
        Contract.requireArgNotNull("lines", lines);
        
        this.lines = lines;
    }
    
    /**
     * Returns: An ordered collection (also known as sequence). See <a href="http://docs.oracle.com/javase/8/docs/api/java/util/List.htmll">java.util.List</a>.
     *
     * @return Current value.
     */
    public final List<String> getLines() {
        return lines;
    }
    
}
