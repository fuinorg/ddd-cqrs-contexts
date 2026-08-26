package org.fuin.dsl.cqrs.conformance.rules;

import org.fuin.dsl.cqrs.common.rules.BusinessRule;
import org.fuin.objects4j.common.Contract;

/**
 * A bare Boolean attribute is the whole condition.
 */
public final class MustBeEnabled implements BusinessRule {

    private boolean enabled;
    
    /**
     * Constructor with the values this rule decides from.
     *
     * @param enabled Whether this installation offers the module.
     */
    public MustBeEnabled(final boolean enabled) {
        Contract.requireArgNotNull("enabled", enabled);
        
        this.enabled = enabled;
    }

    @Override
    public void verify() throws ConformanceException {
        if (!(enabled)) {
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
