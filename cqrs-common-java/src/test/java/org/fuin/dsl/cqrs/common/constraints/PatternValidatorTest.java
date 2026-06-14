package org.fuin.dsl.cqrs.common.constraints;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;

/** Test for {@link PatternValidator}. */
class PatternValidatorTest extends ValidatorTestBase {

    private static final class Bean {
        @Pattern("[a-z]+")
        private final String value;

        Bean(final String value) {
            this.value = value;
        }
    }

    @Test
    void testMatchingIsValid() {
        assertThat(valid(new Bean("abc"))).isTrue();
    }

    @Test
    void testNullIsValid() {
        assertThat(valid(new Bean(null))).isTrue();
    }

    @Test
    void testNonMatchingIsInvalid() {
        assertThat(valid(new Bean("ABC"))).isFalse();
        assertThat(valid(new Bean("a1"))).isFalse();
    }

    @Test
    void testMessageResolvesVariables() {
        assertThat(messages(new Bean("ABC")))
                .containsExactly("The value does not match the pattern '[a-z]+': ABC");
    }

}
