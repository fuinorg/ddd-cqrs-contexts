package org.fuin.dsl.cqrs.common.rules;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatCode;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import org.fuin.objects4j.common.UniquelyNumbered;
import org.junit.jupiter.api.Test;

/** Test for {@link BusinessRuleViolationException} and its numbered subclass. */
class BusinessRuleViolationExceptionTest {

    /** A rule whose exception the model declares without a "cid". */
    private static final class NameTakenException extends BusinessRuleViolationException {
        private static final long serialVersionUID = 1L;

        NameTakenException(final String name) {
            super("A category named '" + name + "' already exists");
        }
    }

    /** A rule whose exception the model declares with one. */
    private static final class AlreadyDeletedException
            extends UniquelyNumberedBusinessRuleViolationException {
        private static final long serialVersionUID = 1L;

        AlreadyDeletedException() {
            super(1002, "The entity was already deleted");
        }
    }

    @Test
    void testARefusalIsCheckedSoAnOperationHasToDeclareIt() {
        // The point of the base: a caller cannot forget about it, which is what an unchecked exception
        // would allow - and a business refusal that escapes a handler becomes an HTTP 500.
        assertThat(BusinessRuleViolationException.class).isAssignableTo(Exception.class);
        assertThat(RuntimeException.class.isAssignableFrom(BusinessRuleViolationException.class))
                .as("a refusal must not be unchecked")
                .isFalse();
    }

    @Test
    void testOneCatchCoversBothKinds() {
        // A numbered refusal is a subclass rather than a second root, so an operation declares one
        // checked exception whether or not the rules behind it happen to be numbered.
        assertThatThrownBy(() -> {
            throw new AlreadyDeletedException();
        }).isInstanceOf(BusinessRuleViolationException.class);
    }

    @Test
    void testANumberedRefusalCarriesItsNumber() {
        final AlreadyDeletedException ex = new AlreadyDeletedException();

        assertThat(ex.getUniqueNumber()).isEqualTo(1002L);
        assertThat(ex).isInstanceOf(UniquelyNumbered.class);
    }

    @Test
    void testTheMessageIsTheModelsOwnWording() {
        // What reaches the user. The rule's attributes are what let it name the thing it refused.
        assertThat(new NameTakenException("Office supplies"))
                .hasMessage("A category named 'Office supplies' already exists");
    }

    @Test
    void testARuleIsAnObjectThatEitherReturnsOrRefuses() {
        final BusinessRule holds = () -> {
        };
        final BusinessRule refuses = () -> {
            throw new NameTakenException("Office supplies");
        };

        assertThatCode(holds::verify).doesNotThrowAnyException();
        assertThatThrownBy(refuses::verify).isInstanceOf(NameTakenException.class);
    }

}
