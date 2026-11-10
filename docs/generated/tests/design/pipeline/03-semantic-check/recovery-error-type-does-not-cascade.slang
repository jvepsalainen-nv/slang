//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#failure-modes
//META: purpose=Check-level recovery substitutes an error type for an unresolved name, so a second, unrelated error in the next statement is still reported.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that recovery is "continue with a placeholder type" rather than
// abort. Two independent unresolved names appear in consecutive statements;
// if the first failure poisoned checking, the second would never be reached.
// CHECK pins one E30015 per statement, and exhaustive mode makes "exactly
// these two, nothing swallowed and nothing cascaded" part of the assertion.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    int a = undefinedOne;
//CHECK: E30015
//CHECK: undefined identifier 'undefinedOne'.
    int b = undefinedTwo;
//CHECK: E30015
//CHECK: undefined identifier 'undefinedTwo'.
}
