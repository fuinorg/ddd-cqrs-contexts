package org.fuin.dsl.cqrs.common.exceptions;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.io.Serial;
import java.util.Objects;
import org.fuin.ddd4j.core.EntityIdPath;
import org.fuin.ddd4j.core.ExceptionData;
import org.fuin.objects4j.common.ImmutableAfterUnmarshal;

/**
 * Data of a EntityNotInStateDeletedException, carried to a client so a refusal can say what it was about.
 *
 * The exception is recreated from it rather than transported with its stack trace.
 */
@ImmutableAfterUnmarshal
@JsonIgnoreProperties(ignoreUnknown = true)
@SuppressWarnings("NullAway.Init")
public final class EntityNotInStateDeletedExceptionData implements ExceptionData<EntityNotInStateDeletedException> {

    @Serial
    private static final long serialVersionUID = 1000L;

    @JsonProperty("entityIdPath")
    private EntityIdPath entityIdPath;

    /**
     * Constructor only for marshalling/unmarshalling.
     */
    protected EntityNotInStateDeletedExceptionData() {
        super();
    }

    /**
     * Constructor with the exception to copy the data from.
     */
    public EntityNotInStateDeletedExceptionData(final EntityNotInStateDeletedException ex) {
        super();
        Objects.requireNonNull(ex, "ex==null");
        this.entityIdPath = ex.getEntityIdPath();
    }

    @Override
    @JsonIgnore
    public String getDataElement() {
        return EntityNotInStateDeletedException.ELEMENT_NAME;
    }

    /**
     * Returns: entityIdPath
     *
     * @return Current value.
     */
    @JsonIgnore
    public EntityIdPath getEntityIdPath() {
        return entityIdPath;
    }

    @Override
    public EntityNotInStateDeletedException toException() {
        return new EntityNotInStateDeletedException(entityIdPath);
    }

    @Override
    public int hashCode() {
        return Objects.hash(entityIdPath);
    }

    @Override
    public boolean equals(final Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        final EntityNotInStateDeletedExceptionData other = (EntityNotInStateDeletedExceptionData) obj;
        return Objects.equals(entityIdPath, other.entityIdPath);
    }

    @Override
    public String toString() {
        return "EntityNotInStateDeletedExceptionData [entityIdPath=" + entityIdPath + "]";
    }

}
