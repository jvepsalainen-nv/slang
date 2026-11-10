//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#shader-specific-checks
//META: purpose=Entry-point validation requires a stage, so a function compiled as an entry point with neither a `[shader(...)]` attribute nor `-stage` is rejected with E38007.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the "the function's stage attribute" part of entry-point
// validation. The command line names the entry point but supplies no stage,
// and the function carries no stage attribute, so the checker has nothing to
// validate the signature against. CHECK pins E38007 on the function name.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive): -target hlsl -entry main

[numthreads(1, 1, 1)]
void main()
{
}
//CHECK: E38007
