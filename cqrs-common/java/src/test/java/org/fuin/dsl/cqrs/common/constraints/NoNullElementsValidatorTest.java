package org.fuin.dsl.cqrs.common.constraints;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.Arrays;
import java.util.List;

import org.junit.jupiter.api.Test;

/** Test for {@link NoNullElementsValidator}. */
class NoNullElementsValidatorTest extends ValidatorTestBase {

    private static final class Bean {
        @NoNullElements
        private final List<String> value;

        Bean(final List<String> value) {
            this.value = value;
        }
    }

    @Test
    void testWithoutNullElementsIsValid() {
        assertThat(valid(new Bean(List.of("a", "b")))).isTrue();
    }

    @Test
    void testEmptyIsValid() {
        assertThat(valid(new Bean(List.of()))).isTrue();
    }

    @Test
    void testNullListIsValid() {
        assertThat(valid(new Bean(null))).isTrue();
    }

    @Test
    void testWithNullElementIsInvalid() {
        assertThat(valid(new Bean(Arrays.asList("a", null, "b")))).isFalse();
    }

}
