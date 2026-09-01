package org.fuin.dsl.cqrs.common.wording;

import org.fuin.objects4j.ui.Label;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;

import java.util.Locale;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Covers the language a refusal is written in.
 *
 * <p>
 * The bundle under {@code src/test/resources} stands in for a generated one: same shape, same suffix,
 * two languages.
 */
class WordingTest {

    @AfterEach
    void forgetTheLanguage() {
        Wording.clear();
    }

    @Test
    void testUnsetIsTheLanguageTheModelIsWrittenIn() {
        // Everything that is not a request - a test, a process manager, a log line - gets this.
        assertThat(Wording.locale()).isEqualTo(Locale.ROOT);
        assertThat(Wording.message("TestWording", "Refused", "the model's own"))
                .isEqualTo("as the model states it");
    }

    @Test
    void testTheLanguageInForceIsWhatTheSentenceComesBackIn() {
        Wording.use(Locale.GERMAN);

        assertThat(Wording.message("TestWording", "Refused", "the model's own"))
                .isEqualTo("wie das Modell es sagt");
    }

    @Test
    void testAPlaceholderSurvivesTheLookupBecauseSubstitutionRunsAfterIt() {
        Wording.use(Locale.GERMAN);

        assertThat(Wording.message("TestWording", "Named", "no")).contains("${name}");
    }

    @Test
    void testAKeyNobodyTranslatedAnswersWhatTheModelStates() {
        Wording.use(Locale.GERMAN);

        assertThat(Wording.message("TestWording", "NotTranslated", "the model's own"))
                .isEqualTo("the model's own");
    }

    @Test
    void testABundleThatDoesNotExistIsTheSameNonEvent() {
        assertThat(Wording.message("NoSuchBundleAnywhere", "Refused", "the model's own"))
                .isEqualTo("the model's own");
    }

    @Test
    void testAnEnumIsNamedByItsCaptionRatherThanItsWireValue() {
        // Without this a refusal reads "A EXPENSE category named…", because that is what an enum's
        // toString answers and the placeholder is substituted from the value itself.
        assertThat(Wording.of(Kind.EXPENSE)).isEqualTo("Expense");
    }

    @Test
    void testAndFallsBackToTheWireValueWhenItStatesNoCaption() {
        assertThat(Wording.of(Kind.UNCAPTIONED)).isEqualTo("UNCAPTIONED");
    }

    @Test
    void testNullStaysNullSoAnOptionalValueReadsAsAbsent() {
        assertThat(Wording.of(null)).isNull();
    }

    /** Stands in for a generated enumeration: a caption on the constant, as the generator writes it. */
    private enum Kind {

        @Label(key = "EXPENSE.label", value = "Expense")
        EXPENSE,

        UNCAPTIONED
    }

}
