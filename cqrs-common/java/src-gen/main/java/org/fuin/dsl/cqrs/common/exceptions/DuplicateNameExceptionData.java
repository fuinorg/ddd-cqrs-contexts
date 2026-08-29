package org.fuin.dsl.cqrs.common.exceptions;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.io.Serial;
import java.util.Objects;
import org.fuin.ddd4j.core.ExceptionData;
import org.fuin.objects4j.common.ImmutableAfterUnmarshal;

/**
 * Data of a DuplicateNameException, carried to a client so a refusal can say what it was about.
 *
 * The exception is recreated from it rather than transported with its stack trace.
 */
@ImmutableAfterUnmarshal
@JsonIgnoreProperties(ignoreUnknown = true)
@SuppressWarnings("NullAway.Init")
public final class DuplicateNameExceptionData implements ExceptionData<DuplicateNameException> {

    @Serial
    private static final long serialVersionUID = 1000L;

    @JsonProperty("name")
    private String name;

    /**
     * Constructor only for marshalling/unmarshalling.
     */
    protected DuplicateNameExceptionData() {
        super();
    }

    /**
     * Constructor with the exception to copy the data from.
     */
    public DuplicateNameExceptionData(final DuplicateNameException ex) {
        super();
        Objects.requireNonNull(ex, "ex==null");
        this.name = ex.getName();
    }

    @Override
    @JsonIgnore
    public String getDataElement() {
        return DuplicateNameException.ELEMENT_NAME;
    }

    /**
     * Returns: name
     *
     * @return Current value.
     */
    @JsonIgnore
    public String getName() {
        return name;
    }

    @Override
    public DuplicateNameException toException() {
        return new DuplicateNameException(name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name);
    }

    @Override
    public boolean equals(final Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        final DuplicateNameExceptionData other = (DuplicateNameExceptionData) obj;
        return Objects.equals(name, other.name);
    }

    @Override
    public String toString() {
        return "DuplicateNameExceptionData [name=" + name + "]";
    }

}
