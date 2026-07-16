package org.fuin.dsl.cqrs.common.basics;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import org.junit.jupiter.api.Test;

/** Test for {@link Comment}. */
class CommentTest extends ValueObjectTestBase {

    private static final MediaType TEXT = new MediaType("text/plain");

    @Test
    void testConstructor() {
        final Comment testee = new Comment(TEXT, "Hello");

        assertThat(testee.getMimeType()).isEqualTo(TEXT);
        assertThat(testee.getValue()).isEqualTo("Hello");
    }

    @Test
    void testMandatoryArguments() {
        assertThatThrownBy(() -> new Comment(null, "Hello")).hasMessageContaining("mimeType");
        assertThatThrownBy(() -> new Comment(TEXT, null)).hasMessageContaining("value");
    }

    @Test
    void testValueLengthIsTakenFromTheModel() {
        // The model defines "invariants Length(1, 2000)" for the value
        assertThat(valid(new Comment(TEXT, ""))).isFalse();
        assertThat(valid(new Comment(TEXT, "a"))).isTrue();
        assertThat(valid(new Comment(TEXT, "a".repeat(2000)))).isTrue();
        assertThat(valid(new Comment(TEXT, "a".repeat(2001)))).isFalse();
    }

    @Test
    void testViolationMessageIsInterpolated() {
        assertThat(messages(new Comment(TEXT, ""))).isNotEmpty();
    }

}
