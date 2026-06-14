package org.fuin.dsl.cqrs.common.constraints;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;

/** Test for {@link MinLengthValidator}. */
class MinLengthValidatorTest extends ValidatorTestBase {

    private static final class Bean {
        @MinLength(3)
        private final String value;

        Bean(final String value) {
            this.value = value;
        }
    }

    @Test
    void testAtOrAboveMinIsValid() {
        assertThat(valid(new Bean("abc"))).isTrue();
        assertThat(valid(new Bean("abcd"))).isTrue();
    }

    @Test
    void testNullIsValid() {
        assertThat(valid(new Bean(null))).isTrue();
    }

    @Test
    void testBelowMinIsInvalid() {
        assertThat(valid(new Bean("ab"))).isFalse();
    }

}
