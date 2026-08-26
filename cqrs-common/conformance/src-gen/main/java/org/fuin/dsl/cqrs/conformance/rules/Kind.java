package org.fuin.dsl.cqrs.conformance.rules;

import java.util.List;
import org.jspecify.annotations.Nullable;

/** The side of the ledger something falls on. */
public enum Kind {
    
    /** Money in. */
    INCOME,
    
        /** Money out. */
    EXPENSE
    
    ;
    
    /** All instances. */
    public static final List<Kind> ALL = List.of(
        INCOME, EXPENSE
    );
    
    /** Valid instances. */
    public static final List<Kind> VALID = List.of(
        INCOME, EXPENSE
    );
    
    /** Deprecated instances. */
    public static final List<Kind> DEPRECATED = List.of(
    );
    
}
