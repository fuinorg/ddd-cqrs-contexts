package org.fuin.dsl.cqrs.conformance.rules;

import org.fuin.dsl.cqrs.common.rules.BusinessRule;
import org.fuin.objects4j.common.Contract;

/**
 * A Boolean the caller looked up.
 */
public final class NameMustBeUniqueForType implements BusinessRule {

    private boolean nameTaken;
    
    /**
     * Constructor with the values this rule decides from.
     *
     * @param nameTaken Whether the name is already in use.
     */
    public NameMustBeUniqueForType(final boolean nameTaken) {
        Contract.requireArgNotNull("nameTaken", nameTaken);
        
        this.nameTaken = nameTaken;
    }

    @Override
    public void verify() throws ConformanceException {
        if (!(!(nameTaken))) {
            throw new ConformanceException();
        }
    }

    /**
     * Returns: Whether the name is already in use.
     *
     * @return Current value.
     */
    public boolean getNameTaken() {
        return nameTaken;
    }
    
}
