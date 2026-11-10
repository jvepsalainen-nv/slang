//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E00040 (same-profile-specified-more-than-once) - the '~profile' was specified more than once for target '~target'
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=40
//META: catalog_name=same-profile-specified-more-than-once
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Repeating the same `-profile` for one target is redundant. The driver warns
// instead of failing, and the CHECK pins the duplicate-profile warning code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -profile sm_6_0 -profile sm_6_0 -entry main -stage compute
[numthreads(1,1,1)]
void main() {}

//CHECK: E00040
