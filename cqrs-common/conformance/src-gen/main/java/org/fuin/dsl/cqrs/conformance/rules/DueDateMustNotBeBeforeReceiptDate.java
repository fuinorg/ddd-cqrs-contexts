package org.fuin.dsl.cqrs.conformance.rules;

import java.time.LocalDate;
import org.fuin.dsl.cqrs.common.rules.BusinessRule;
import org.fuin.objects4j.common.Contract;

/**
 * Ordering two dates.
 */
public final class DueDateMustNotBeBeforeReceiptDate implements BusinessRule {

    private LocalDate dueDate;
    
    private LocalDate receiptDate;
    
    /**
     * Constructor with the values this rule decides from.
     *
     * @param dueDate When payment is due.
     * @param receiptDate When the document was issued.
     */
    public DueDateMustNotBeBeforeReceiptDate(final LocalDate dueDate, final LocalDate receiptDate) {
        Contract.requireArgNotNull("dueDate", dueDate);
        Contract.requireArgNotNull("receiptDate", receiptDate);
        
        this.dueDate = dueDate;
        this.receiptDate = receiptDate;
    }

    @Override
    public void verify() throws ConformanceException {
        if (!(dueDate.compareTo(receiptDate) >= 0)) {
            throw new ConformanceException();
        }
    }

    /**
     * Returns: When payment is due.
     *
     * @return Current value.
     */
    public LocalDate getDueDate() {
        return dueDate;
    }
    
    /**
     * Returns: When the document was issued.
     *
     * @return Current value.
     */
    public LocalDate getReceiptDate() {
        return receiptDate;
    }
    
}
