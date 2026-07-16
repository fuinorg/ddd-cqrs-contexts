package org.fuin.dsl.cqrs.common.basics;

import jakarta.validation.constraints.Size;
import java.io.Serial;
import java.io.Serializable;
import org.fuin.objects4j.common.Contract;
import org.fuin.objects4j.common.ValueObject;
import org.fuin.objects4j.core.AbstractStringValueObject;
import org.fuin.objects4j.ui.Examples;

/**
 * A phone number is a unique sequence of digits assigned to a telephone line, enabling calls and text messages to reach a specific person or device. It acts as a unique identifier within a telecommunications network, allowing users to connect with others. Phone numbers are always stored in international format with plus sign (+), then country code, city code, and local phone number.
 */
public abstract class AbstractPhoneNumber extends AbstractStringValueObject implements ValueObject, Serializable {

    @Serial
    private static final long serialVersionUID = 1000L;
    
    private PhoneType typ;
    
    @Size(min=5, max=164)
    @Examples(value = { "+49-40-12345678" })
    private String value;
    
    /**
     * Default constructor.
     */
    @SuppressWarnings("NullAway.Init")
    protected AbstractPhoneNumber() {
        super();
    }
    
    /**
     * Constructor with all data.
     *
     * @param typ Type of phone number.
     * @param value Represents 16-bit Unicode strings. See <a href="http://docs.oracle.com/javase/8/docs/api/java/lang/String.html">java.lang.String</a>.
     */
    public AbstractPhoneNumber(final PhoneType typ, @Size(min=5, max=164) final String value) {
        super();
        Contract.requireArgNotNull("typ", typ);
        Contract.requireArgNotNull("value", value);
        
        this.typ = typ;
        this.value = value;
    }
    
    /**
     * Returns: Type of phone number.
     *
     * @return Current value.
     */
    public final PhoneType getTyp() {
        return typ;
    }
    
    /**
     * Returns: Represents 16-bit Unicode strings. See <a href="http://docs.oracle.com/javase/8/docs/api/java/lang/String.html">java.lang.String</a>.
     *
     * @return Current value.
     */
    public final String getValue() {
        return value;
    }
    
}
