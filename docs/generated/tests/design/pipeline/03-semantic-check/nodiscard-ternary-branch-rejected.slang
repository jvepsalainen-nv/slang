//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#failure-modes
//META: purpose=The discarded-result check recurses into a ternary select, so a `[NoDiscard]` call in either branch of a discarded conditional is reported.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the ternary arm of the recursion. The discarded expression is the
// conditional, not the call, so a check that only inspected the statement's
// top-level expression would miss both branches. CHECK pins one E30059 per
// branch.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

[NoDiscard]
int f()
{
    return 1;
}

void main()
{
    true ? f() : f();
//CHECK: E30059
//CHECK: E30059
}
