package org.fuin.dsl.cqrs.common.rules;

/**
 * One business rule, over values it was handed.
 * <p>
 * <b>The rule decides; the caller fetches.</b> A rule never consults a repository, a service or the
 * aggregate - it is constructed with values and answers one question about them. That is what makes
 * the rules needing outside data ordinary: a rule about a name already being taken is not handed a
 * repository to search, it is handed the {@code Boolean} answer.
 * <p>
 * It also makes a rule a unit-testable object rather than a passage inside an aggregate method.
 */
public interface BusinessRule {

    /**
     * Verifies the rule and does nothing if it holds.
     *
     * @throws BusinessRuleViolationException The rule refused the operation, with the model's own
     *             wording and whichever of its values name what went wrong.
     */
    void verify() throws BusinessRuleViolationException;

}
