package org.fuin.dsl.cqrs.common.basics;

import java.io.Serial;
import org.fuin.ddd4j.core.EntityIdPath;

/**
 * Identifies the aggregate or entity some data was derived from, together with the version of that aggregate at the time. A projection copies both values from the domain event into the read model, and a client sends them back with a command, so the aggregate repository can tell on load whether the data the change was based on is still current.
 */
public final class VersionedEntityIdPath extends AbstractVersionedEntityIdPath {

    @Serial
    private static final long serialVersionUID = 1000L;
    
    /**
     * Default constructor.
     */
    @SuppressWarnings("NullAway.Init")
    protected VersionedEntityIdPath() {
        super();
    }
    
    /**
     * Constructor with all data.
     *
     * @param entityIdPath Path from the aggregate root down to the entity the data was derived from.
     * @param aggregateVersion Version of the aggregate the data reflects, or nothing if it is unknown.
     */
    public VersionedEntityIdPath(final EntityIdPath entityIdPath, final Integer aggregateVersion) {
        super(entityIdPath, aggregateVersion);
    }
    
}
