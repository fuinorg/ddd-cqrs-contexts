package org.fuin.dsl.cqrs.common.rules;

import java.io.Serial;

/**
 * A business rule refused an operation.
 * <p>
 * Every rule keeps its own exception class, with its own attributes and its own message written to be
 * read by a person; this is only what they have in common. It exists so that an operation can declare
 * one checked exception and still refuse for any of the reasons its rules give, and so a command
 * handler needs one catch rather than one per rule - a forgotten catch compiles, and the trailing
 * {@code catch (Exception)} then turns a business refusal into an HTTP 500.
 * <p>
 * Widening the signature loses nothing a caller had: the generated validator keeps the specific types,
 * and catching a subclass of a declared checked exception is legal, so a caller that does care about
 * one particular refusal can still name it.
 * <p>
 * Nothing on the wire changes - a result derives its {@code code} from the actual class.
 */
public abstract class BusinessRuleViolationException extends Exception {

    @Serial
    private static final long serialVersionUID = 1000L;

    /**
     * Constructor with the message the model states.
     *
     * @param message Why the operation was refused, as the rule's own model message renders it.
     */
    public BusinessRuleViolationException(final String message) {
        super(message);
    }

    /**
     * Constructor with the message the model states and the failure underneath it.
     *
     * @param message Why the operation was refused, as the rule's own model message renders it.
     * @param cause What led to the refusal.
     */
    public BusinessRuleViolationException(final String message, final Throwable cause) {
        super(message, cause);
    }

}
