package org.fuin.dsl.cqrs.common.exceptions;

import java.io.Serial;
import java.util.Objects;
import org.fuin.ddd4j.core.EntityIdPath;
import org.fuin.objects4j.common.Contract;
import org.fuin.objects4j.common.UniquelyNumberedException;
import org.fuin.objects4j.core.KeyValue;

/**
 * Expected the entity to be in state 'deleted', but was not.
 */
public final class EntityNotInStateDeletedException extends UniquelyNumberedException {

    @Serial
    private static final long serialVersionUID = 1000L;

    private EntityIdPath entityIdPath;
    
    /**
     * Constructs a new instance of the exception.
     *
     * @param entityIdPath An ordered list of entity identifiers. An aggregate root will be the first entry if it's contained in the list. See <a href="https://github.com/fuinorg/ddd-4-java/blob/master/src/main/java/org/fuin/ddd4j/ddd/EntityIdPath.java">org.fuin.ddd4j.ddd.EntityIdPath</a>.
     */
    public EntityNotInStateDeletedException(final EntityIdPath entityIdPath) {
        super(1001, Objects.requireNonNull(KeyValue.replace("Expected the entity to be in state 'deleted', but was not: ${entityIdPath}",  new KeyValue("entityIdPath", entityIdPath))));
        Contract.requireArgNotNull("entityIdPath", entityIdPath);
        
        this.entityIdPath = entityIdPath;
    }

    /**
     * Returns: An ordered list of entity identifiers. An aggregate root will be the first entry if it's contained in the list. See <a href="https://github.com/fuinorg/ddd-4-java/blob/master/src/main/java/org/fuin/ddd4j/ddd/EntityIdPath.java">org.fuin.ddd4j.ddd.EntityIdPath</a>.
     *
     * @return Current value.
     */
    public final EntityIdPath getEntityIdPath() {
        return entityIdPath;
    }
    
}
