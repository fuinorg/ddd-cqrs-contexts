package org.fuin.dsl.cqrs.common.basics;

import java.io.Serial;
import java.io.Serializable;
import org.fuin.ddd4j.core.EntityIdPath;
import org.fuin.objects4j.common.Contract;
import org.fuin.objects4j.common.ValueObject;
import org.jspecify.annotations.Nullable;

/**
 * Identifies the aggregate or entity some data was derived from, together with the version of that aggregate at the time. A projection copies both values from the domain event into the read model, and a client sends them back with a command, so the aggregate repository can tell on load whether the data the change was based on is still current.
 */
public abstract class AbstractVersionedEntityIdPath implements ValueObject, Serializable {

    @Serial
    private static final long serialVersionUID = 1000L;
    
    private EntityIdPath entityIdPath;
    
    @Nullable
    private Integer aggregateVersion;
    
    /**
     * Default constructor.
     */
    @SuppressWarnings("NullAway.Init")
    protected AbstractVersionedEntityIdPath() {
        super();
    }
    
    /**
     * Constructor with all data.
     *
     * @param entityIdPath Path from the aggregate root down to the entity the data was derived from.
     * @param aggregateVersion Version of the aggregate the data reflects, or nothing if it is unknown.
     */
    public AbstractVersionedEntityIdPath(final EntityIdPath entityIdPath, @Nullable final Integer aggregateVersion) {
        super();
        Contract.requireArgNotNull("entityIdPath", entityIdPath);
        
        this.entityIdPath = entityIdPath;
        this.aggregateVersion = aggregateVersion;
    }
    
    /**
     * Returns: Path from the aggregate root down to the entity the data was derived from.
     *
     * @return Current value.
     */
    public final EntityIdPath getEntityIdPath() {
        return entityIdPath;
    }
    
    /**
     * Returns: Version of the aggregate the data reflects, or nothing if it is unknown.
     *
     * @return Current value.
     */
    @Nullable
    public final Integer getAggregateVersion() {
        return aggregateVersion;
    }
    
}
