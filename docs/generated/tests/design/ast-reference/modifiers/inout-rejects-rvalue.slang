//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=An `inout` parameter requires an l-value argument; passing a literal is diagnosed.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the write-back half of `inout` imposes an l-value requirement on
// the argument. A literal has no storage to write back into, so the checker must
// reject the call; CHECK pins the argument-not-an-l-value error code rather than
// the message wording, which is the stable part of the diagnostic.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void inc(inout int x)
{
    x = x + 1;
}

void main()
{
    inc(7);
    //CHECK: error
    //CHECK: E30047
}
