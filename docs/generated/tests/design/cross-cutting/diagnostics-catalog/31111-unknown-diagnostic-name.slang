//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31111 (unknown-diagnostic-name) - unknown diagnostic
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=31111
//META: catalog_name=unknown-diagnostic-name
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `-warnings-disable` resolves each identifier against the diagnostic catalog.
// A name that is in no catalog entry is reported rather than ignored, so the
// CHECK pins the unknown-diagnostic-name error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -entry main -stage compute -warnings-disable not-a-real-diagnostic-name
[numthreads(1,1,1)]
void main() {}

//CHECK: E31111
