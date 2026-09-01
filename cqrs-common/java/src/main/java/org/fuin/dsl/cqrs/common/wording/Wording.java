package org.fuin.dsl.cqrs.common.wording;

import org.fuin.objects4j.common.ThreadSafe;
import org.fuin.objects4j.ui.AnnotationAnalyzer;
import org.fuin.objects4j.ui.FieldTextInfo;
import org.fuin.objects4j.ui.Label;
import org.jspecify.annotations.Nullable;

import java.lang.reflect.Field;
import java.util.Locale;
import java.util.MissingResourceException;
import java.util.ResourceBundle;

/**
 * What the model says, in the language the caller asked for.
 *
 * <h2>Why a refusal needs this and a label does not</h2>
 * <p>
 * A field's caption is resolved where it is displayed, by whoever displays it, and a client that has its
 * own bundle never asks the server. A refusal is different: it is a <em>sentence</em>, composed on the
 * server out of the values it refused, and it arrives at the client already written. Composing it in the
 * language of the machine the server happens to run on is what leaves one English line in an otherwise
 * German screen.
 *
 * <h2>The language is ambient, like the tenant</h2>
 * <p>
 * It arrives on the request and is put here by whatever reads the request, so nothing between that and
 * the refusal has to carry it: not a command, not an aggregate, not an operation's signature. A refusal
 * is thrown from deep inside a domain method that has no business knowing what language anybody reads.
 * <p>
 * Unset means {@link Locale#ROOT}, which resolves to the bundle the model was written in. That is the
 * right answer for everything that is not a request - a test, a process manager, a log line.
 */
@ThreadSafe
public final class Wording {

    /** Suffix the model's own sentence is keyed under, matching what the generator writes. */
    private static final String MESSAGE = ".message";

    private static final ThreadLocal<Locale> CURRENT = new ThreadLocal<>();

    private static final AnnotationAnalyzer ANALYZER = new AnnotationAnalyzer();

    private Wording() {
        throw new UnsupportedOperationException("It is not allowed to create an instance of a utility class");
    }

    /**
     * Sets the language for this thread, for as long as the request lasts.
     *
     * @param locale Language the caller asked for, or {@literal null} to use the model's own.
     */
    public static void use(@Nullable final Locale locale) {
        if (locale == null) {
            CURRENT.remove();
        } else {
            CURRENT.set(locale);
        }
    }

    /** Forgets the language, which whoever set it has to do before the thread is reused. */
    public static void clear() {
        CURRENT.remove();
    }

    /**
     * Returns the language in force on this thread.
     *
     * @return What was set, or {@link Locale#ROOT} - the language the model is written in.
     */
    public static Locale locale() {
        final Locale locale = CURRENT.get();
        return locale == null ? Locale.ROOT : locale;
    }

    /**
     * Returns a refusal's sentence in the language in force, as a template with its placeholders intact.
     * <p>
     * Substitution runs <b>after</b> this, never before: a translation is a template too, and the values
     * it names are the same ones in every language.
     *
     * @param bundle Resource bundle the exception's wording lives in.
     * @param key Key it is stored under, without the suffix.
     * @param modelsOwn What the model states, returned when nothing translates it.
     *
     * @return Template to substitute into.
     */
    public static String message(final String bundle, final String key, final String modelsOwn) {
        try {
            return ResourceBundle.getBundle(bundle, locale()).getString(key + MESSAGE);
        } catch (final MissingResourceException ex) {
            // A bundle that is not on the classpath and a key nothing translated are the same
            // non-event: the model's own sentence is the answer, which is what it was written to be.
            return modelsOwn;
        }
    }

    /**
     * Returns what an enumeration's value is called on screen, in the language in force.
     * <p>
     * A refusal naming one would otherwise quote the wire value - "A EXPENSE category named…" - because
     * that is what an enum's {@code toString} answers. The caption is on the constant already, as the
     * {@code @Label} the generator writes there, and it translates through the same bundle as everything
     * else.
     *
     * @param value Value to name, or {@literal null}.
     *
     * @return Its caption, its wire name when it states none, or {@literal null} for {@literal null}.
     */
    @Nullable
    public static String of(@Nullable final Enum<?> value) {
        if (value == null) {
            return null;
        }
        try {
            final Field constant = value.getDeclaringClass().getField(value.name());
            final FieldTextInfo info = ANALYZER.createFieldInfo(constant, locale(), Label.class);
            final String text = info == null ? null : info.getText();
            return text == null ? value.name() : text;
        } catch (final NoSuchFieldException ex) {
            // A constant of the enum, looked up on the enum: unreachable, and not worth a checked
            // exception in every generated refusal.
            return value.name();
        }
    }

}
