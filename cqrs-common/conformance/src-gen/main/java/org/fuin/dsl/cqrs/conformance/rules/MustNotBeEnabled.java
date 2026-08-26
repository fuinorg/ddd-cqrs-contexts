package org.fuin.dsl.cqrs.conformance.rules;

import org.fuin.dsl.cqrs.common.rules.BusinessRule;
import org.fuin.objects4j.common.Contract;

/**
 * Negation of a bare Boolean.
 */
public final class MustNotBeEnabled implements BusinessRule {

    private boolean enabled;
    
    /**
     * Constructor with the values this rule decides from.
     *
     * @param enabled Whether this installation offers the module.
     */
    public MustNotBeEnabled(final boolean enabled) {
        Contract.requireArgNotNull("enabled", enabled);
        
        this.enabled = enabled;
    }

    @Override
    public void verify() throws ConformanceException {
        if (!(!(enabled))) {
            throw new ConformanceException();
        }
    }

    /**
     * Returns: Whether this installation offers the module.
     *
     * @return Current value.
     */
    public boolean getEnabled() {
        return enabled;
    }
    
}
