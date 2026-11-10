//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#failure-modes
//META: purpose=The discarded-result check recurses into a short-circuit expression, so the `[NoDiscard]` call whose value is actually thrown away is the one reported.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the short-circuit arm of the recursion, and that the recursion is
// precise rather than blanket: the left operand's result feeds the `&&` and is
// not discarded, while the right operand's result is the statement's own
// discarded value. CHECK pins the single E30059 and its message, and
// exhaustive mode makes "only the right operand was reported" part of the
// assertion.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

[NoDiscard]
bool g()
{
    return true;
}

void main()
{
    g() && g();
//CHECK: E30059
//CHECK: the result of calling 'g' is discarded
}
