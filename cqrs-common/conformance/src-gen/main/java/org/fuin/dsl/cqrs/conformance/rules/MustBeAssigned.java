package org.fuin.dsl.cqrs.conformance.rules;

import org.fuin.dsl.cqrs.common.rules.BusinessRule;
import org.jspecify.annotations.Nullable;

/**
 * Compared against absence.
 */
public final class MustBeAssigned implements BusinessRule {

    @Nullable
    private String assignedEntry;
    
    /**
     * Constructor with the values this rule decides from.
     *
     * @param assignedEntry The journal entry this receipt backs, if any.
     */
    public MustBeAssigned(@Nullable final String assignedEntry) {
        
        this.assignedEntry = assignedEntry;
    }

    @Override
    public void verify() throws ConformanceException {
        if (!(assignedEntry != null)) {
            throw new ConformanceException();
        }
    }

    /**
     * Returns: The journal entry this receipt backs, if any.
     *
     * @return Current value.
     */
    @Nullable
    public String getAssignedEntry() {
        return assignedEntry;
    }
    
}
