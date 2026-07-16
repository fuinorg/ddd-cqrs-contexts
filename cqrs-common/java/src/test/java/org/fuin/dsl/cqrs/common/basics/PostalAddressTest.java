package org.fuin.dsl.cqrs.common.basics;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.util.List;
import java.util.stream.IntStream;

import org.junit.jupiter.api.Test;

/** Test for {@link PostalAddress}. */
class PostalAddressTest extends ValueObjectTestBase {

    @Test
    void testConstructor() {
        final List<String> lines = List.of("Peter Parker", "20 Ingram Street", "New York");

        assertThat(new PostalAddress(lines).getLines()).isEqualTo(lines);
    }

    @Test
    void testMandatoryArguments() {
        assertThatThrownBy(() -> new PostalAddress(null)).hasMessageContaining("lines");
    }

    @Test
    void testNumberOfLinesIsTakenFromTheModel() {
        // The model defines "invariants ListLength(1, 10)" for the lines
        assertThat(valid(new PostalAddress(List.of()))).isFalse();
        assertThat(valid(new PostalAddress(lines(1)))).isTrue();
        assertThat(valid(new PostalAddress(lines(10)))).isTrue();
        assertThat(valid(new PostalAddress(lines(11)))).isFalse();
    }

    @Test
    void testViolationMessageIsInterpolated() {
        assertThat(messages(new PostalAddress(lines(11)))).isNotEmpty();
    }

    private static List<String> lines(final int count) {
        return IntStream.range(0, count).mapToObj(i -> "Line " + i).toList();
    }

}
