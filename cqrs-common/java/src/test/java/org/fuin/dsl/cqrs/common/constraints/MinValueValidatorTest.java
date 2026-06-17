package org.fuin.dsl.cqrs.common.constraints;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;

/** Test for {@link MinValueValidator}. */
class MinValueValidatorTest extends ValidatorTestBase {

    private static final class Bean {
        @MinValue(5)
        private final Long value;

        Bean(final Long value) {
            this.value = value;
        }
    }

    @Test
    void testAtOrAboveMinIsValid() {
        assertThat(valid(new Bean(5L))).isTrue();
        assertThat(valid(new Bean(6L))).isTrue();
    }

    @Test
    void testNullIsValid() {
        assertThat(valid(new Bean(null))).isTrue();
    }

    @Test
    void testBelowMinIsInvalid() {
        assertThat(valid(new Bean(4L))).isFalse();
    }

}
