/*
 * Package mapping of the "cqrs-common" model.
 *
 * Everything lives in "<context>.<module>" - the model publishes plain reusable types and has no
 * command/query sides to separate. This script ships inside the model jar: a project that depends on
 * this model runs *this* function to name an imported type, so it gets the package the types were
 * actually generated into, whatever layout the consumer uses for its own code.
 *
 * An unknown key throws - there is no declarative mapping left to fall back to, and placing a type in a
 * silently wrong package is worse than failing the build.
 */

function model2JavaPackage(element, typeKey) {

    switch (typeKey) {

        case 'java-value-object':
        case 'java-value-object-abstract':
        case 'java-value-object-test':
        case 'java-aggregate-id':
        case 'java-aggregate-id-abstract':
        case 'java-aggregate-id-stream-factory':
        case 'java-entity-id':
        case 'java-entity-id-abstract':
        case 'java-enum':
        case 'java-enum-abstract':
        case 'java-event':
        case 'java-event-test':
        case 'java-exception':
        case 'java-exception-data':
        case 'java-constraint':
        case 'java-constraint-validator':
        case 'java-command':
        case 'java-service':
        case 'java-aggregate':
        case 'java-aggregate-abstract':
        case 'java-entity':
        case 'java-entity-abstract':
        case 'java-business-rule':
        case 'java-business-rules':
        case 'java-package-info':
        case 'res-aggregate-doc':
        case 'res-aggregate-liquibase':
            return join(contextName(element), moduleName(element));

        default:
            throw new Error('Unknown typeKey: ' + typeKey);
    }
}

/** Name of the context the element belongs to. */
function contextName(element) {
    var ctx = enclosing(element, 'Context');
    return ctx === null ? '' : String(ctx.getName());
}

/** Name of the module the element belongs to. */
function moduleName(element) {
    var mod = enclosing(element, 'Module');
    return mod === null ? '' : String(mod.getName());
}

/** Closest container of the element whose meta class has the given name, or null. */
function enclosing(element, className) {
    var current = element;
    while (current !== null) {
        // String(...) matters: a Java string wrapped by the engine is never === a JS string.
        if (String(current.eClass().getName()) === className) {
            return current;
        }
        current = current.eContainer();
    }
    return null;
}

/** Joins the non-empty segments with a dot. */
function join() {
    var parts = [];
    for (var i = 0; i < arguments.length; i++) {
        var part = arguments[i];
        if (part !== null && part !== undefined && part !== '') {
            parts.push(String(part));
        }
    }
    return parts.join('.');
}
