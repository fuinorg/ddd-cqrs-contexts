package org.fuin.dsl.cqrs.common.rules;

import java.io.Serial;
import org.fuin.objects4j.common.UniquelyNumbered;

/**
 * A business rule refused an operation, and the refusal carries the number the model gave it.
 * <p>
 * The same thing as {@link BusinessRuleViolationException} with an identifier attached, for a rule
 * whose exception declares a {@code cid}. It is a subclass rather than a second root so that an
 * operation still declares one checked exception and a handler still needs one catch, whether or not
 * the rules behind it happen to be numbered.
 * <p>
 * It duplicates the few lines of {@code org.fuin.objects4j.common.UniquelyNumberedException} rather
 * than extending it, because that class extends {@link Exception} directly and a Java class has one
 * superclass - so reusing it would be exactly the second root this avoids.
 */
public abstract class UniquelyNumberedBusinessRuleViolationException
        extends BusinessRuleViolationException implements UniquelyNumbered {

    @Serial
    private static final long serialVersionUID = 1000L;

    private final long number;

    /**
     * Constructor with the number and the message the model states.
     *
     * @param number Number that identifies this exception uniquely in the context.
     * @param message Why the operation was refused, as the rule's own model message renders it.
     */
    public UniquelyNumberedBusinessRuleViolationException(final long number, final String message) {
        super(message);
        this.number = number;
    }

    /**
     * Constructor with the number, the message the model states and the failure underneath it.
     *
     * @param number Number that identifies this exception uniquely in the context.
     * @param message Why the operation was refused, as the rule's own model message renders it.
     * @param cause What led to the refusal.
     */
    public UniquelyNumberedBusinessRuleViolationException(final long number, final String message,
            final Throwable cause) {
        super(message, cause);
        this.number = number;
    }

    @Override
    public final long getUniqueNumber() {
        return number;
    }

}
