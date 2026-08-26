package org.fuin.dsl.cqrs.conformance.rules;

import java.util.Objects;
import org.fuin.dsl.cqrs.common.rules.BusinessRule;
import org.fuin.objects4j.common.Contract;

/**
 * The same, negated.
 */
public final class MustNotBeIgnored implements BusinessRule {

    private Status status;
    
    /**
     * Constructor with the values this rule decides from.
     *
     * @param status How far the transaction got.
     */
    public MustNotBeIgnored(final Status status) {
        Contract.requireArgNotNull("status", status);
        
        this.status = status;
    }

    @Override
    public void verify() throws ConformanceException {
        if (!(!Objects.equals(status, Status.IGNORED))) {
            throw new ConformanceException();
        }
    }

    /**
     * Returns: How far the transaction got.
     *
     * @return Current value.
     */
    public Status getStatus() {
        return status;
    }
    
}
