package org.fuin.dsl.cqrs.conformance.rules;

import java.util.Objects;
import org.fuin.dsl.cqrs.common.rules.BusinessRule;
import org.fuin.objects4j.common.Contract;

/**
 * Compared against a value written out in the condition.
 */
public final class MustNotBeReferenced implements BusinessRule {

    private int referenceCount;
    
    /**
     * Constructor with the values this rule decides from.
     *
     * @param referenceCount How many records still reference it.
     */
    public MustNotBeReferenced(final int referenceCount) {
        Contract.requireArgNotNull("referenceCount", referenceCount);
        
        this.referenceCount = referenceCount;
    }

    @Override
    public void verify() throws ConformanceException {
        if (!(Objects.equals(referenceCount, 0))) {
            throw new ConformanceException();
        }
    }

    /**
     * Returns: How many records still reference it.
     *
     * @return Current value.
     */
    public int getReferenceCount() {
        return referenceCount;
    }
    
}
