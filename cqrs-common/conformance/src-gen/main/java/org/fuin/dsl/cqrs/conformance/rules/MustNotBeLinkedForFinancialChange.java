package org.fuin.dsl.cqrs.conformance.rules;

import java.time.LocalDate;
import java.util.Objects;
import org.fuin.dsl.cqrs.common.rules.BusinessRule;
import org.fuin.objects4j.common.Contract;
import org.jspecify.annotations.Nullable;

/**
 * The one rule needing parentheses: a disjunction over a conjunction.
 */
public final class MustNotBeLinkedForFinancialChange implements BusinessRule {

    @Nullable
    private String accountTransactionId;
    
    private LocalDate date;
    
    private LocalDate newDate;
    
    private String sourceCurrency;
    
    private String newSourceCurrency;
    
    /**
     * Constructor with the values this rule decides from.
     *
     * @param accountTransactionId The bank transaction this entry reconciles, if any.
     * @param date The date it carries now.
     * @param newDate The date the edit would give it.
     * @param sourceCurrency The source currency it carries now.
     * @param newSourceCurrency The source currency the edit would give it.
     */
    public MustNotBeLinkedForFinancialChange(@Nullable final String accountTransactionId, final LocalDate date, final LocalDate newDate, final String sourceCurrency, final String newSourceCurrency) {
        Contract.requireArgNotNull("date", date);
        Contract.requireArgNotNull("newDate", newDate);
        Contract.requireArgNotNull("sourceCurrency", sourceCurrency);
        Contract.requireArgNotNull("newSourceCurrency", newSourceCurrency);
        
        this.accountTransactionId = accountTransactionId;
        this.date = date;
        this.newDate = newDate;
        this.sourceCurrency = sourceCurrency;
        this.newSourceCurrency = newSourceCurrency;
    }

    @Override
    public void verify() throws ConformanceException {
        if (!((accountTransactionId == null || (Objects.equals(date, newDate) && Objects.equals(sourceCurrency, newSourceCurrency))))) {
            throw new ConformanceException();
        }
    }

    /**
     * Returns: The bank transaction this entry reconciles, if any.
     *
     * @return Current value.
     */
    @Nullable
    public String getAccountTransactionId() {
        return accountTransactionId;
    }
    
    /**
     * Returns: The date it carries now.
     *
     * @return Current value.
     */
    public LocalDate getDate() {
        return date;
    }
    
    /**
     * Returns: The date the edit would give it.
     *
     * @return Current value.
     */
    public LocalDate getNewDate() {
        return newDate;
    }
    
    /**
     * Returns: The source currency it carries now.
     *
     * @return Current value.
     */
    public String getSourceCurrency() {
        return sourceCurrency;
    }
    
    /**
     * Returns: The source currency the edit would give it.
     *
     * @return Current value.
     */
    public String getNewSourceCurrency() {
        return newSourceCurrency;
    }
    
}
