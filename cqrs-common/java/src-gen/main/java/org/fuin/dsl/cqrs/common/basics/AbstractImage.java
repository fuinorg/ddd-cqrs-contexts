package org.fuin.dsl.cqrs.common.basics;

import java.io.Serial;
import java.io.Serializable;
import org.fuin.objects4j.common.Contract;
import org.fuin.objects4j.common.ValueObject;

/**
 * Representation of an image used for uploads.
 */
public abstract class AbstractImage implements ValueObject, Serializable {

    @Serial
    private static final long serialVersionUID = 1000L;
    
    private FilePathAndName pathAndName;
    
    private byte[] data;
    
    /**
     * Default constructor.
     */
    @SuppressWarnings("NullAway.Init")
    protected AbstractImage() {
        super();
    }
    
    /**
     * Constructor with all data.
     *
     * @param pathAndName Path and name of a file in the storage.
     * @param data Binary data.
     */
    public AbstractImage(final FilePathAndName pathAndName, final byte[] data) {
        super();
        Contract.requireArgNotNull("pathAndName", pathAndName);
        Contract.requireArgNotNull("data", data);
        
        this.pathAndName = pathAndName;
        this.data = data;
    }
    
    /**
     * Returns: Path and name of a file in the storage.
     *
     * @return Current value.
     */
    public final FilePathAndName getPathAndName() {
        return pathAndName;
    }
    
    /**
     * Returns: Binary data.
     *
     * @return Current value.
     */
    public final byte[] getData() {
        return data;
    }
    
}
