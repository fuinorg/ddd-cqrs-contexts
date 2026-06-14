package org.fuin.dsl.cqrs.common.constraints;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.List;

import org.junit.jupiter.api.Test;

/** Test for {@link ListLengthValidator}. */
class ListLengthValidatorTest extends ValidatorTestBase {

    private static final class Bean {
        @ListLength(min = 1, max = 3)
        private final List<String> value;

        Bean(final List<String> value) {
            this.value = value;
        }
    }

    @Test
    void testWithinRangeIsValid() {
        assertThat(valid(new Bean(List.of("a")))).isTrue();
        assertThat(valid(new Bean(List.of("a", "b", "c")))).isTrue();
    }

    @Test
    void testNullIsValid() {
        assertThat(valid(new Bean(null))).isTrue();
    }

    @Test
    void testTooFewIsInvalid() {
        assertThat(valid(new Bean(List.of()))).isFalse();
    }

    @Test
    void testTooManyIsInvalid() {
        assertThat(valid(new Bean(List.of("a", "b", "c", "d")))).isFalse();
    }

}
