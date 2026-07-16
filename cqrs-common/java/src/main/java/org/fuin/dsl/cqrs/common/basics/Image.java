package org.fuin.dsl.cqrs.common.basics;

import java.io.Serial;

/**
 * Representation of an image used for uploads.
 */
public final class Image extends AbstractImage {

    @Serial
    private static final long serialVersionUID = 1000L;
    
    /**
     * Default constructor.
     */
    @SuppressWarnings("NullAway.Init")
    protected Image() {
        super();
    }
    
    /**
     * Constructor with all data.
     *
     * @param pathAndName Path and name of a file in the storage.
     * @param data Binary data.
     */
    public Image(final FilePathAndName pathAndName, final byte[] data) {
        super(pathAndName, data);
    }
    
}
