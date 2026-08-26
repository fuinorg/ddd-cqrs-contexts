package org.fuin.dsl.cqrs.conformance.rules;

import java.io.Serial;
import org.fuin.dsl.cqrs.common.rules.BusinessRuleViolationException;

/**
 * Refused. Which rule refused is what the test asserts; the wording plays no part.
 */
public final class ConformanceException extends BusinessRuleViolationException {

    @Serial
    private static final long serialVersionUID = 1000L;

    /**
     * Constructs a new instance of the exception.
     */
    public ConformanceException() {
        super("The rule does not hold");
    }

}
