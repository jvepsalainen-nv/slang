//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E39019 (global-uniform-not-expected) - implicit global shader parameter
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=39019
//META: catalog_name=global-uniform-not-expected
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A global ordinary variable without `uniform` or `static`
// becomes an implicit shader parameter, triggering E39019.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -stage compute -entry main -profile sm_6_0

float someGlobal;

[numthreads(1,1,1)]
void main() {}

//CHECK: E39019