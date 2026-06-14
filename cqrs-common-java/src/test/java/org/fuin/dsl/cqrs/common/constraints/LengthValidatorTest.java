package org.fuin.dsl.cqrs.common.constraints;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;

/** Test for {@link LengthValidator}. */
class LengthValidatorTest extends ValidatorTestBase {

    private static final class Bean {
        @Length(min = 2, max = 5)
        private final String value;

        Bean(final String value) {
            this.value = value;
        }
    }

    @Test
    void testWithinRangeIsValid() {
        assertThat(valid(new Bean("ab"))).isTrue();
        assertThat(valid(new Bean("abcde"))).isTrue();
    }

    @Test
    void testNullIsValid() {
        assertThat(valid(new Bean(null))).isTrue();
    }

    @Test
    void testTooShortIsInvalid() {
        assertThat(valid(new Bean("a"))).isFalse();
    }

    @Test
    void testTooLongIsInvalid() {
        assertThat(valid(new Bean("abcdef"))).isFalse();
    }

}
