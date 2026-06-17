package org.fuin.dsl.cqrs.common.constraints;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.List;

import org.junit.jupiter.api.Test;

/** Test for {@link ListNotEmptyValidator}. */
class ListNotEmptyValidatorTest extends ValidatorTestBase {

    private static final class Bean {
        @ListNotEmpty
        private final List<String> value;

        Bean(final List<String> value) {
            this.value = value;
        }
    }

    @Test
    void testNonEmptyIsValid() {
        assertThat(valid(new Bean(List.of("a")))).isTrue();
    }

    @Test
    void testNullIsValid() {
        assertThat(valid(new Bean(null))).isTrue();
    }

    @Test
    void testEmptyIsInvalid() {
        assertThat(valid(new Bean(List.of()))).isFalse();
    }

}
