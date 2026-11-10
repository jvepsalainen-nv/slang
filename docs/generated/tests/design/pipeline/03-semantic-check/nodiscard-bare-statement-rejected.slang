//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#failure-modes
//META: purpose=Discarding the result of a `[NoDiscard]` call written as a bare expression statement is rejected with E30059.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the base case of the discarded-result check: the call is the whole
// statement, so its value has nowhere to go. CHECK pins E30059, whose message
// names the callee and the attribute.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

[NoDiscard]
int f()
{
    return 1;
}

void main()
{
    f();
//CHECK: E30059
}
