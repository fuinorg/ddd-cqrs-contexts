package org.fuin.dsl.cqrs.common.constraints;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;

/** Test for {@link MaxValueValidator}. */
class MaxValueValidatorTest extends ValidatorTestBase {

    private static final class Bean {
        @MaxValue(10)
        private final Long value;

        Bean(final Long value) {
            this.value = value;
        }
    }

    @Test
    void testAtOrBelowMaxIsValid() {
        assertThat(valid(new Bean(10L))).isTrue();
        assertThat(valid(new Bean(9L))).isTrue();
    }

    @Test
    void testNullIsValid() {
        assertThat(valid(new Bean(null))).isTrue();
    }

    @Test
    void testAboveMaxIsInvalid() {
        assertThat(valid(new Bean(11L))).isFalse();
    }

}
