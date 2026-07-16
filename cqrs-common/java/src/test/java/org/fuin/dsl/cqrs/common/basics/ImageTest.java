package org.fuin.dsl.cqrs.common.basics;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import org.junit.jupiter.api.Test;

/** Test for {@link Image}. */
class ImageTest extends ValueObjectTestBase {

    private static final FilePathAndName PATH = new FilePathAndName("images/spidey.png");

    private static final byte[] DATA = new byte[] { 1, 2, 3 };

    @Test
    void testConstructor() {
        final Image testee = new Image(PATH, DATA);

        assertThat(testee.getPathAndName()).isEqualTo(PATH);
        assertThat(testee.getData()).isEqualTo(DATA);
    }

    @Test
    void testMandatoryArguments() {
        assertThatThrownBy(() -> new Image(null, DATA)).hasMessageContaining("pathAndName");
        assertThatThrownBy(() -> new Image(PATH, null)).hasMessageContaining("data");
    }

    @Test
    void testNoInvariantsInTheModel() {
        // The model defines no invariants for the attributes, so anything non-null is valid
        assertThat(valid(new Image(PATH, new byte[0]))).isTrue();
    }

}
