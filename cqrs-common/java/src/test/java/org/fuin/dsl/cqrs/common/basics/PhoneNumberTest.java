package org.fuin.dsl.cqrs.common.basics;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import org.fuin.objects4j.common.ConstraintViolationException;
import org.junit.jupiter.api.Test;

/** Test for {@link PhoneNumber}. */
class PhoneNumberTest {

    private static final String NUMBER = "+49-40-12345678";

    @Test
    void testAsBaseTypeContainsTypeAndNumber() {
        assertThat(new PhoneNumber(PhoneType.MOBILE, NUMBER).asBaseType()).isEqualTo("MOBILE " + NUMBER);
        assertThat(new PhoneNumber(PhoneType.LANDLINE, NUMBER).asBaseType()).isEqualTo("LANDLINE " + NUMBER);
    }

    @Test
    void testValueOfParsesWhatAsBaseTypeCreated() {
        for (final PhoneType type : PhoneType.ALL) {
            final PhoneNumber original = new PhoneNumber(type, NUMBER);

            final PhoneNumber copy = PhoneNumber.valueOf(original.asBaseType());

            assertThat(copy).isEqualTo(original);
            assertThat(copy.getTyp()).isEqualTo(type);
            assertThat(copy.getValue()).isEqualTo(NUMBER);
        }
    }

    @Test
    void testNullIsValidAndConvertsToNull() {
        assertThat(PhoneNumber.isValid(null)).isTrue();
        assertThat(PhoneNumber.valueOf(null)).isNull();
    }

    @Test
    void testValidValue() {
        assertThat(PhoneNumber.isValid("MOBILE " + NUMBER)).isTrue();
    }

    @Test
    void testUnknownTypeIsInvalid() {
        assertThat(PhoneNumber.isValid("BOGUS " + NUMBER)).isFalse();
    }

    @Test
    void testMissingTypeIsInvalid() {
        assertThat(PhoneNumber.isValid(NUMBER)).isFalse();
        assertThat(PhoneNumber.isValid(" " + NUMBER)).isFalse();
    }

    @Test
    void testMissingNumberIsInvalid() {
        assertThat(PhoneNumber.isValid("MOBILE")).isFalse();
        assertThat(PhoneNumber.isValid("")).isFalse();
    }

    @Test
    void testNumberLengthIsTakenFromTheModel() {
        // The model defines "invariants Length(5, 164)" for the value
        assertThat(PhoneNumber.isValid("MOBILE " + "9".repeat(4))).isFalse();
        assertThat(PhoneNumber.isValid("MOBILE " + "9".repeat(5))).isTrue();
        assertThat(PhoneNumber.isValid("MOBILE " + "9".repeat(164))).isTrue();
        assertThat(PhoneNumber.isValid("MOBILE " + "9".repeat(165))).isFalse();
    }

    @Test
    void testNumberMayContainSpaces() {
        // Only the first space separates the type from the number
        assertThat(PhoneNumber.isValid("MOBILE +49 40 12345678")).isTrue();
        assertThat(PhoneNumber.valueOf("MOBILE +49 40 12345678").getValue()).isEqualTo("+49 40 12345678");
    }

    @Test
    void testValueOfInvalidValueThrows() {
        assertThatThrownBy(() -> PhoneNumber.valueOf("BOGUS 12345"))
                .isInstanceOf(ConstraintViolationException.class)
                .hasMessageContaining("BOGUS 12345");
        assertThatThrownBy(() -> PhoneNumber.valueOf("MOBILE 1234"))
                .isInstanceOf(ConstraintViolationException.class);
        assertThatThrownBy(() -> PhoneNumber.valueOf("MOBILE"))
                .isInstanceOf(ConstraintViolationException.class);
    }

}
