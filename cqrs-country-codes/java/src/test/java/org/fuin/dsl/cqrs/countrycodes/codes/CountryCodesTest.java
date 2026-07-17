package org.fuin.dsl.cqrs.countrycodes.codes;

import static org.assertj.core.api.Assertions.assertThat;

import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;
import org.junit.jupiter.api.Test;

/**
 * Tests for the generated ISO 3166 value objects. They verify (via Bean Validation, backed by
 * Hibernate Validator) that the invariants reused from the "common" context
 * ({@code Pattern}, {@code Length}) are applied to the generated value objects — which proves the
 * generated code references {@code org.fuin.dsl.cqrs.common.constraints.*} from the
 * {@code cqrs-common-java} dependency.
 */
class CountryCodesTest {

    private static final ValidatorFactory FACTORY = Validation.buildDefaultValidatorFactory();

    private static final Validator VALIDATOR = FACTORY.getValidator();

    private static boolean valid(final Object bean) {
        return VALIDATOR.validate(bean).isEmpty();
    }

    @Test
    void testAlpha2Code() {
        assertThat(valid(new Alpha2Code("DE"))).isTrue();
        assertThat(valid(new Alpha2Code("US"))).isTrue();
        assertThat(valid(new Alpha2Code("de"))).isFalse();
        assertThat(valid(new Alpha2Code("D"))).isFalse();
        assertThat(valid(new Alpha2Code("DEU"))).isFalse();
    }

    @Test
    void testAlpha3Code() {
        assertThat(valid(new Alpha3Code("DEU"))).isTrue();
        assertThat(valid(new Alpha3Code("USA"))).isTrue();
        assertThat(valid(new Alpha3Code("usa"))).isFalse();
        assertThat(valid(new Alpha3Code("DE"))).isFalse();
    }

    @Test
    void testNumericCode() {
        assertThat(valid(new NumericCode("276"))).isTrue();
        assertThat(valid(new NumericCode("840"))).isTrue();
        assertThat(valid(new NumericCode("004"))).isTrue();
        assertThat(valid(new NumericCode("12"))).isFalse();
        assertThat(valid(new NumericCode("ABC"))).isFalse();
    }

    @Test
    void testSubdivisionCode() {
        assertThat(valid(new SubdivisionCode("ID-RI"))).isTrue();
        assertThat(valid(new SubdivisionCode("NG-RI"))).isTrue();
        assertThat(valid(new SubdivisionCode("US-CA"))).isTrue();
        assertThat(valid(new SubdivisionCode("idri"))).isFalse();
        assertThat(valid(new SubdivisionCode("ID-"))).isFalse();
    }

}
