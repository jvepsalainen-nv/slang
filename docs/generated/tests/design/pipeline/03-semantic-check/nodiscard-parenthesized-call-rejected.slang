//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#failure-modes
//META: purpose=The discarded-result check peels parentheses, so a `[NoDiscard]` call wrapped in parentheses as a bare statement is still reported (E30059).
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the parenthesis peeling: the statement is a parenthesized
// expression, not a call, so the check must look through the parentheses to
// find the discarded call. CHECK pins E30059.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

[NoDiscard]
int f()
{
    return 1;
}

void main()
{
    (f());
//CHECK: E30059
}
