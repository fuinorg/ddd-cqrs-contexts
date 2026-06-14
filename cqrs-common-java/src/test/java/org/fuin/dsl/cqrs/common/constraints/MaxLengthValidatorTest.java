package org.fuin.dsl.cqrs.common.constraints;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;

/** Test for {@link MaxLengthValidator}. */
class MaxLengthValidatorTest extends ValidatorTestBase {

    private static final class Bean {
        @MaxLength(5)
        private final String value;

        Bean(final String value) {
            this.value = value;
        }
    }

    @Test
    void testAtOrBelowMaxIsValid() {
        assertThat(valid(new Bean(""))).isTrue();
        assertThat(valid(new Bean("abcde"))).isTrue();
    }

    @Test
    void testNullIsValid() {
        assertThat(valid(new Bean(null))).isTrue();
    }

    @Test
    void testAboveMaxIsInvalid() {
        assertThat(valid(new Bean("abcdef"))).isFalse();
    }

}
