//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#files-and-responsibilities
//META: purpose=Expression checking rejects a literal passed to an `out` parameter because the argument must be an l-value (E30047).
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that lvalue-ness is enforced at argument-passing sites too, not
// just at `=`. An `out` parameter needs storage to write back into, and a
// literal has none; CHECK pins E30047 on the offending argument.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void take(out int o)
{
    o = 1;
}

void main()
{
    take(3);
//CHECK: E30047
}
