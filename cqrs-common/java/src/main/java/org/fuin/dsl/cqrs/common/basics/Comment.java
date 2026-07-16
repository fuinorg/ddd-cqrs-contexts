package org.fuin.dsl.cqrs.common.basics;

import java.io.Serial;

/**
 * Represents a comment on something.
 */
public final class Comment extends AbstractComment {

    @Serial
    private static final long serialVersionUID = 1000L;
    
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
     * @param mimeType A media type (formerly known as a Multipurpose Internet Mail Extensions or MIME type) indicates the nature and format of a document, file, or assortment of bytes. MIME types are defined and standardized in IETF's RFC 6838. The format is something like: "type/subtype;parameter=value" (Example: "text/plain" or "application/json; encoding=UTF-8; version=1").
     * @param value Represents 16-bit Unicode strings. See <a href="http://docs.oracle.com/javase/8/docs/api/java/lang/String.html">java.lang.String</a>.
     */
    public Comment(final MediaType mimeType, final String value) {
        super(mimeType, value);
    }
    
}
