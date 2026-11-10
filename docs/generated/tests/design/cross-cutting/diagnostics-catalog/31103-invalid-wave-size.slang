//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31103 (invalid-wave-size) - invalid 'WaveSize' value
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=31103
//META: catalog_name=invalid-wave-size
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `[WaveSize]` only accepts hardware wave widths, which are powers of two. 7 is
// outside that set, and the CHECK pins the invalid-wave-size error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -entry main -stage compute
[numthreads(1,1,1)]
[WaveSize(7)]
void main() {}

//CHECK: E31103
