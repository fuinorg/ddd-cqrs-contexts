package org.fuin.dsl.cqrs.common.constraints;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;

/** Test for {@link NotEmptyValidator}. */
class NotEmptyValidatorTest extends ValidatorTestBase {

    private static final class Bean {
        @NotEmpty
        private final String value;

        Bean(final String value) {
            this.value = value;
        }
    }

    @Test
    void testNonEmptyIsValid() {
        assertThat(valid(new Bean("a"))).isTrue();
    }

    @Test
    void testNullIsValid() {
        assertThat(valid(new Bean(null))).isTrue();
    }

    @Test
    void testEmptyIsInvalid() {
        assertThat(valid(new Bean(""))).isFalse();
    }

}
