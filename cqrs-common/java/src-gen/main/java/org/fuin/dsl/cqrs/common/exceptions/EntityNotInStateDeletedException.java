package org.fuin.dsl.cqrs.common.exceptions;

import java.io.Serial;
import java.util.Objects;
import org.fuin.ddd4j.core.EntityIdPath;
import org.fuin.dsl.cqrs.common.rules.BusinessRuleViolationException;
import org.fuin.dsl.cqrs.common.wording.Wording;
import org.fuin.objects4j.common.Contract;
import org.fuin.objects4j.common.ExceptionShortIdentifable;
import org.fuin.objects4j.core.KeyValue;
import org.fuin.objects4j.core.KeyValueEL;

/**
 * Expected the entity to be in state 'deleted', but was not.
 */
public final class EntityNotInStateDeletedException extends BusinessRuleViolationException implements ExceptionShortIdentifable {

    @Serial
    private static final long serialVersionUID = 1000L;

    /** Name this exception is transported under. */
    public static final String ELEMENT_NAME = "entity-not-in-state-deleted-exception";

    /** Unique short identifier of this exception. */
    public static final String SHORT_ID = "CQRSCO-ENTITY_NOT_IN_STATE_DELETED";

    private EntityIdPath entityIdPath;
    
    /**
     * Constructs a new instance of the exception.
     *
     * @param entityIdPath An ordered list of entity identifiers. An aggregate root will be the first entry if it's contained in the list. See <a href="https://github.com/fuinorg/ddd-4-java/blob/master/src/main/java/org/fuin/ddd4j/ddd/EntityIdPath.java">org.fuin.ddd4j.ddd.EntityIdPath</a>.
     */
    public EntityNotInStateDeletedException(final EntityIdPath entityIdPath) {
        super(Objects.requireNonNull(KeyValueEL.replace(Wording.message("Exceptions", "EntityNotInStateDeletedException", "Expected the entity to be in state 'deleted', but was not: ${entityIdPath}"),  new KeyValue("entityIdPath", entityIdPath))));
        Contract.requireArgNotNull("entityIdPath", entityIdPath);
        
        this.entityIdPath = entityIdPath;
    }

@Override
public final String getShortId() {
    return SHORT_ID;
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
