/*
 * Target mapping of the "cqrs-common" model. Everything it declares is a plain reusable type, so it all
 * goes into the one module the generating project declares; the folder rules are the templates' own.
 *
 *   folder: four rules on the factory, first match wins
 *     1. "*TestArtifactFactory"          -> testJava     (a test class)
 *     2. the two non-Java factories      -> genMainRes   (documentation, Liquibase XML)
 *     3. "Final*" and the leaf factories -> mainJava     (developer owned, written once)
 *     4. everything else                 -> genMainJava  (derived, rewritten every run)
 */

var MAIN_JAVA = 'mainJava';
var GEN_MAIN_JAVA = 'genMainJava';
var GEN_MAIN_RES = 'genMainRes';
var TEST_JAVA = 'testJava';

var TEST_SUFFIX = 'TestArtifactFactory';
var FINAL_PREFIX = 'Final';

/** Factories that create a non-Java artifact. */
var MAIN_RESOURCE_ARTIFACTS = [
    'AggregateDocArtifactFactory',
    'ESJpaLiquibaseXmlArtifactFactory'
];

/** Leaf classes owned by the developer that are not named "Final*". */
var MAIN_JAVA_ARTIFACTS = [
    'AggregateIdArtifactFactory',
    'EntityIdArtifactFactory',
    'ValidatorArtifactFactory',
    'ESRepositoryArtifactFactory',
    'ProcessManagerArtifactFactory'
];

function artifact2Target(element, typeKey, artifactFactory) {
    return { module: module(typeKey), folder: folder(artifactFactory) };
}

/**
 * Module an artifact is generated into. This is the SrcGen4J module name declared in the generator
 * configuration of the project doing the generating (cqrs-common/java: "shared"), not the name of the
 * Maven module - everything this model declares goes to that single target.
 */
function module(typeKey) {
    return 'shared';
}

/** Simple or fully qualified factory class name -> one of the four folders. */
function folder(artifactFactory) {
    if (artifactFactory === null || artifactFactory === undefined) {
        throw new Error("Argument 'artifactFactory' cannot be null");
    }
    var name = simpleName(artifactFactory);
    if (name.endsWith(TEST_SUFFIX)) {
        return TEST_JAVA;
    }
    if (MAIN_RESOURCE_ARTIFACTS.indexOf(name) >= 0) {
        return GEN_MAIN_RES;
    }
    if (name.startsWith(FINAL_PREFIX) || MAIN_JAVA_ARTIFACTS.indexOf(name) >= 0) {
        return MAIN_JAVA;
    }
    return GEN_MAIN_JAVA;
}

function simpleName(className) {
    var idx = className.lastIndexOf('.');
    return idx < 0 ? className : className.substring(idx + 1);
}
