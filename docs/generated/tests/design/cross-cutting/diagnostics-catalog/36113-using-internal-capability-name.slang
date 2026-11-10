//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E36113 (using-internal-capability-name) - using internal capability name
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=36113
//META: catalog_name=using-internal-capability-name
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Using the internal capability name `_sm_4_0` (which has a
// leading underscore) triggers E36113. Public users are expected
// to use `sm_4_0` instead.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive): -target glsl -entry main -stage compute -profile sm_5_0

[require(glsl, _sm_4_0)]
public void helper() {}

[numthreads(1,1,1)]
void main() { helper(); }

//CHECK: E36113