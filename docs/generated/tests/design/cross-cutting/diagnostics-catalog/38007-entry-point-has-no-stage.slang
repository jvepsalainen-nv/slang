//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E38007 (entry-point-has-no-stage) - no stage specified for entry point
//META: intent=negative
//META: pipeline_stage=link
//META: catalog_code=38007
//META: catalog_name=entry-point-has-no-stage
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// An entry point's stage comes from `-stage` or from a `[shader(...)]`
// attribute. With neither, the compiler cannot classify the entry point, and
// the CHECK pins the no-stage-specified error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -entry main
[numthreads(1,1,1)]
void main() {}

//CHECK: E38007
