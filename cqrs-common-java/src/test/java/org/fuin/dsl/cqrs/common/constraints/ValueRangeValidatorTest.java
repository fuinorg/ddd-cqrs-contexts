package org.fuin.dsl.cqrs.common.constraints;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;

/** Test for {@link ValueRangeValidator}. */
class ValueRangeValidatorTest extends ValidatorTestBase {

    private static final class Bean {
        @ValueRange(min = 1, max = 10)
        private final Long value;

        Bean(final Long value) {
            this.value = value;
        }
    }

    @Test
    void testWithinRangeIsValid() {
        assertThat(valid(new Bean(1L))).isTrue();
        assertThat(valid(new Bean(10L))).isTrue();
        assertThat(valid(new Bean(5L))).isTrue();
    }

    @Test
    void testNullIsValid() {
        assertThat(valid(new Bean(null))).isTrue();
    }

    @Test
    void testBelowRangeIsInvalid() {
        assertThat(valid(new Bean(0L))).isFalse();
    }

    @Test
    void testAboveRangeIsInvalid() {
        assertThat(valid(new Bean(11L))).isFalse();
    }

    @Test
    void testMessageResolvesVariables() {
        assertThat(messages(new Bean(11L)))
                .containsExactly("Expected a value between 1 and 10, but actual was: 11");
    }

}
