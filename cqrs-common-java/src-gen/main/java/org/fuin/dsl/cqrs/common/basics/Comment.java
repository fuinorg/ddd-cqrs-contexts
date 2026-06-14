package org.fuin.dsl.cqrs.common.basics;

import java.io.Serial;
import java.io.Serializable;
import org.fuin.dsl.cqrs.common.constraints.Length;
import org.fuin.objects4j.common.Contract;
import org.fuin.objects4j.common.ValueObject;

/**
 * Represents a comment on something.
 */
public final class Comment implements ValueObject, Serializable {

    @Serial
    private static final long serialVersionUID = 1000L;
    
    private MediaType mimeType;
    
    @Length(min = 1, max = 2000)
    private String value;
    
    /**
     * Default constructor.
     */
    @SuppressWarnings("NullAway.Init")
    protected Comment() {
        super();
    }
    
    /**
     * Constructor with all data.
     *
     * @param mimeType A media type (formerly known as a Multipurpose Internet Mail Extensions or MIME type)     indicates the nature and format of a document, file, or assortment of bytes. MIME     types are defined and standardized in IETF's RFC 6838. The format is something like:     "type/subtype;parameter=value" (Example: "text/plain" or "application/json; encoding=UTF-8; version=1").
     * @param value Represents 16-bit Unicode strings. See <a href="http://docs.oracle.com/javase/8/docs/api/java/lang/String.html">java.lang.String</a>.
     */
    public Comment(final MediaType mimeType, @Length(min = 1, max = 2000) final String value) {
        super();
        Contract.requireArgNotNull("mimeType", mimeType);
        Contract.requireArgNotNull("value", value);
        
        this.mimeType = mimeType;
        this.value = value;
    }
    
    /**
     * Returns: A media type (formerly known as a Multipurpose Internet Mail Extensions or MIME type)   indicates the nature and format of a document, file, or assortment of bytes. MIME   types are defined and standardized in IETF's RFC 6838. The format is something like:   "type/subtype;parameter=value" (Example: "text/plain" or "application/json; encoding=UTF-8; version=1").
     *
     * @return Current value.
     */
    public final MediaType getMimeType() {
        return mimeType;
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
