package org.fuin.dsl.cqrs.conformance;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.fuin.dsl.cqrs.common.rules.BusinessRule;
import org.fuin.dsl.cqrs.common.rules.BusinessRuleViolationException;
import org.junit.jupiter.api.DynamicTest;
import org.junit.jupiter.api.TestFactory;

import java.io.InputStream;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.fail;

/**
 * Answers the shared conformance vectors with the Java a rule generates.
 * <p>
 * <b>Why this exists.</b> One predicate is answered twice - by a generated rule class on the server and
 * by the Dart evaluator on the client - and two implementations of one semantics drift. The drift does
 * not announce itself: it shows up as a button that quietly stops being offered. Until now only the
 * Dart half ran the vectors, so half of what the table was written to protect was unguarded.
 * <p>
 * <b>What is actually compared.</b> Not a description of the generated code: the classes in
 * {@code src-gen} are produced by the same templates every real model uses, from a fixture model whose
 * rules are the vectors one for one. Each vector names a rule, each case gives that rule's attributes
 * their values, and the verdict is whether {@code verify()} threw.
 * <p>
 * The vectors carry <b>wire</b> values, so a value arrives as a bool, a number, a string, or a list. The
 * fixture declares its attributes as plain types for that reason, and the only conversions left are the
 * two the wire cannot express by itself: the name of an enumeration instance, and an ISO-8601 date.
 */
class RuleConformanceTest {

    private static final String RULE_PACKAGE = "org.fuin.dsl.cqrs.conformance.rules.";

    @TestFactory
    List<DynamicTest> conformsToTheSharedVectors() throws Exception {
        final List<DynamicTest> tests = new ArrayList<>();
        for (final JsonNode vector : vectors()) {
            final String rule = vector.get("rule").asText();
            final String name = vector.get("name").asText();
            int index = 0;
            for (final JsonNode testCase : vector.get("cases")) {
                index++;
                final String label = rule + " - " + name + " case " + index;
                final Map<String, Object> values = valuesOf(testCase.get("values"));
                final boolean expected = testCase.get("expected").asBoolean();
                tests.add(DynamicTest.dynamicTest(label, () -> assertHolds(rule, values, expected)));
            }
        }
        // A vector nobody runs protects nothing, so the count is asserted rather than assumed.
        assertThat(tests).hasSizeGreaterThanOrEqualTo(13);
        return tests;
    }

    /**
     * Constructs the generated rule from the vector's values and records whether it refused.
     *
     * @param ruleName Simple name of the generated class, which is the name the vector gives the rule.
     * @param values The rule's attributes, by name, as they travel on the wire.
     * @param expected TRUE when the rule is expected to hold.
     */
    private void assertHolds(final String ruleName, final Map<String, Object> values,
            final boolean expected) throws Exception {

        final BusinessRule rule = construct(ruleName, values);
        boolean held = true;
        try {
            rule.verify();
        } catch (final BusinessRuleViolationException ex) {
            held = false;
        }
        assertThat(held)
                .withFailMessage("%s answered %s for %s, but the vectors say %s - the generated Java and"
                        + " the Dart evaluator no longer agree", ruleName, held, values, expected)
                .isEqualTo(expected);
    }

    /**
     * The generated rule, built from its single constructor.
     * <p>
     * By name rather than by declaration order: the vectors are a table a person maintains, and a rule
     * whose attributes are reordered must not start silently comparing the wrong pair.
     */
    private BusinessRule construct(final String ruleName, final Map<String, Object> values)
            throws Exception {

        final Class<?> type = Class.forName(RULE_PACKAGE + ruleName);
        final Constructor<?> constructor = type.getConstructors()[0];
        // The attribute names come from the fields rather than the parameters: a parameter name only
        // survives compilation with "-parameters", and a field name always does. The generated class
        // declares one field per attribute, in the order the constructor takes them.
        final Field[] fields = type.getDeclaredFields();
        final Class<?>[] types = constructor.getParameterTypes();
        if (types.length != values.size()) {
            fail(ruleName + " takes " + types.length + " value(s), but the vector gives "
                    + values.size() + ": " + values.keySet());
        }
        final Object[] args = new Object[types.length];
        for (int i = 0; i < types.length; i++) {
            final String name = fields[i].getName();
            if (!values.containsKey(name)) {
                fail(ruleName + " takes '" + name + "', which the vector does not give: "
                        + values.keySet());
            }
            args[i] = convert(values.get(name), types[i]);
        }
        return (BusinessRule) constructor.newInstance(args);
    }

    /** A wire value as the constructor wants it. */
    @SuppressWarnings({ "unchecked", "rawtypes" })
    private Object convert(final Object value, final Class<?> target) {
        if (value == null) {
            return null;
        }
        if (target.isEnum()) {
            // An instance travels as its wire name - "IGNORED", not the Java constant.
            return Enum.valueOf((Class<Enum>) target, (String) value);
        }
        if (target == LocalDate.class) {
            return LocalDate.parse((String) value);
        }
        return value;
    }

    private Map<String, Object> valuesOf(final JsonNode node) {
        final Map<String, Object> values = new LinkedHashMap<>();
        node.fields().forEachRemaining(entry -> values.put(entry.getKey(), plain(entry.getValue())));
        return values;
    }

    private Object plain(final JsonNode node) {
        if (node.isNull()) {
            return null;
        }
        if (node.isBoolean()) {
            return node.asBoolean();
        }
        if (node.isInt()) {
            return node.asInt();
        }
        if (node.isArray()) {
            final List<Object> list = new ArrayList<>();
            node.forEach(element -> list.add(plain(element)));
            return list;
        }
        return node.asText();
    }

    private JsonNode vectors() throws Exception {
        try (InputStream in = getClass().getResourceAsStream("/vectors.json")) {
            assertThat(in).withFailMessage("vectors.json is not on the test classpath").isNotNull();
            return new ObjectMapper().readTree(in);
        }
    }

}
