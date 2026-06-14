package org.fuin.dsl.cqrs.common.constraints;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;

/** Test for {@link ExactLengthValidator}. */
class ExactLengthValidatorTest extends ValidatorTestBase {

    private static final class Bean {
        @ExactLength(3)
        private final String value;

        Bean(final String value) {
            this.value = value;
        }
    }

    @Test
    void testExactLengthIsValid() {
        assertThat(valid(new Bean("abc"))).isTrue();
    }

    @Test
    void testNullIsValid() {
        assertThat(valid(new Bean(null))).isTrue();
    }

    @Test
    void testTooShortIsInvalid() {
        assertThat(valid(new Bean("ab"))).isFalse();
    }

    @Test
    void testMessageResolvesVariables() {
        assertThat(messages(new Bean("ab")))
                .containsExactly("Expected an exact length of 3, but value was: 'ab'");
    }

    @Test
    void testTooLongIsInvalid() {
        assertThat(valid(new Bean("abcd"))).isFalse();
    }

}
