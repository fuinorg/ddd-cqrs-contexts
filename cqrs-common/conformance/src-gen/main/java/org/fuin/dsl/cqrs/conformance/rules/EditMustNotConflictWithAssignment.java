package org.fuin.dsl.cqrs.conformance.rules;

import java.util.Objects;
import org.fuin.dsl.cqrs.common.rules.BusinessRule;
import org.fuin.objects4j.common.Contract;

/**
 * One attribute compared against another of the same type.
 */
public final class EditMustNotConflictWithAssignment implements BusinessRule {

    private Kind categoryKind;
    
    private Kind newCategoryKind;
    
    /**
     * Constructor with the values this rule decides from.
     *
     * @param categoryKind The category type it carries now.
     * @param newCategoryKind The category type the edit would give it.
     */
    public EditMustNotConflictWithAssignment(final Kind categoryKind, final Kind newCategoryKind) {
        Contract.requireArgNotNull("categoryKind", categoryKind);
        Contract.requireArgNotNull("newCategoryKind", newCategoryKind);
        
        this.categoryKind = categoryKind;
        this.newCategoryKind = newCategoryKind;
    }

    @Override
    public void verify() throws ConformanceException {
        if (!(Objects.equals(categoryKind, newCategoryKind))) {
            throw new ConformanceException();
        }
    }

    /**
     * Returns: The category type it carries now.
     *
     * @return Current value.
     */
    public Kind getCategoryKind() {
        return categoryKind;
    }
    
    /**
     * Returns: The category type the edit would give it.
     *
     * @return Current value.
     */
    public Kind getNewCategoryKind() {
        return newCategoryKind;
    }
    
}
