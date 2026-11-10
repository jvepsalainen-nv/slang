//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E50011 (spirv-version-not-supported) - SPIR-V version too old
//META: intent=negative
//META: pipeline_stage=emit
//META: catalog_code=50011
//META: catalog_name=spirv-version-not-supported
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Slang's direct SPIR-V backend only emits 1.3+. Requesting a 1.0
// profile triggers the too-old-version warning.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target spirv -entry main -stage compute -profile spirv_1_0

[numthreads(1,1,1)]
void main() {}

//CHECK: E50011
