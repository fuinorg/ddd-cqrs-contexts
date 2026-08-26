package org.fuin.dsl.cqrs.conformance.rules;

import java.util.List;
import org.fuin.dsl.cqrs.common.rules.BusinessRule;
import org.fuin.objects4j.common.Contract;

/**
 * The same, negated.
 */
public final class MustHaveLinks implements BusinessRule {

    private List<String> linkedEntries;
    
    /**
     * Constructor with the values this rule decides from.
     *
     * @param linkedEntries The journal entries linked to it.
     */
    public MustHaveLinks(final List<String> linkedEntries) {
        Contract.requireArgNotNull("linkedEntries", linkedEntries);
        
        this.linkedEntries = linkedEntries;
    }

    @Override
    public void verify() throws ConformanceException {
        if (!(!(linkedEntries.isEmpty()))) {
            throw new ConformanceException();
        }
    }

    /**
     * Returns: The journal entries linked to it.
     *
     * @return Current value.
     */
    public List<String> getLinkedEntries() {
        return linkedEntries;
    }
    
}
