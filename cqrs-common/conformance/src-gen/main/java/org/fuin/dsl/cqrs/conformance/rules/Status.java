package org.fuin.dsl.cqrs.conformance.rules;

import java.util.List;
import org.jspecify.annotations.Nullable;

/** Stands in for every enumeration a vector compares against by name. */
public enum Status {
    
    /** Not reconciled yet. */
    OPEN,
    
        /** Deliberately skipped. */
    IGNORED
    
    ;
    
    /** All instances. */
    public static final List<Status> ALL = List.of(
        OPEN, IGNORED
    );
    
    /** Valid instances. */
    public static final List<Status> VALID = List.of(
        OPEN, IGNORED
    );
    
    /** Deprecated instances. */
    public static final List<Status> DEPRECATED = List.of(
    );
    
}
