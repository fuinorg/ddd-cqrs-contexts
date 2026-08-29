package org.fuin.dsl.cqrs.common.exceptions;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.io.Serial;
import java.util.Objects;
import org.fuin.ddd4j.core.ExceptionData;
import org.fuin.objects4j.common.ImmutableAfterUnmarshal;

/**
 * Data of a LimitExceededException, carried to a client so a refusal can say what it was about.
 *
 * The exception is recreated from it rather than transported with its stack trace.
 */
@ImmutableAfterUnmarshal
@JsonIgnoreProperties(ignoreUnknown = true)
@SuppressWarnings("NullAway.Init")
public final class LimitExceededExceptionData implements ExceptionData<LimitExceededException> {

    @Serial
    private static final long serialVersionUID = 1000L;

    @JsonProperty("max")
    private int max;

    /**
     * Constructor only for marshalling/unmarshalling.
     */
    protected LimitExceededExceptionData() {
        super();
    }

    /**
     * Constructor with the exception to copy the data from.
     */
    public LimitExceededExceptionData(final LimitExceededException ex) {
        super();
        Objects.requireNonNull(ex, "ex==null");
        this.max = ex.getMax();
    }

    @Override
    @JsonIgnore
    public String getDataElement() {
        return LimitExceededException.ELEMENT_NAME;
    }

    /**
     * Returns: max
     *
     * @return Current value.
     */
    @JsonIgnore
    public int getMax() {
        return max;
    }

    @Override
    public LimitExceededException toException() {
        return new LimitExceededException(max);
    }

    @Override
    public int hashCode() {
        return Objects.hash(max);
    }

    @Override
    public boolean equals(final Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        final LimitExceededExceptionData other = (LimitExceededExceptionData) obj;
        return Objects.equals(max, other.max);
    }

    @Override
    public String toString() {
        return "LimitExceededExceptionData [max=" + max + "]";
    }

}
