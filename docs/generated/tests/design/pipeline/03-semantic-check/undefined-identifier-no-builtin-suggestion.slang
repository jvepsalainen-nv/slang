//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#failure-modes
//META: purpose=Core-module builtins are excluded from the did-you-mean candidate set, so misspelling a builtin produces no suggestion.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the builtin-exclusion rule. `sqr` is one edit from the core-module
// `sqrt`, so an unfiltered candidate walk would suggest it; the exclusion is
// what keeps the suggestion list from being dominated by the core module.
// CHECK pins the undefined-identifier error and its message, and exhaustive
// mode turns "no suggestion note came with it" into part of the assertion.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    float y = sqr(2.0);
//CHECK: E30015
//CHECK: undefined identifier 'sqr'.
}
