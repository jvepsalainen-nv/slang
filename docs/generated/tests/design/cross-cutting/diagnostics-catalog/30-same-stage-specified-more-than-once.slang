//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E00030 (same-stage-specified-more-than-once) - the stage '~stage' was specified more than once for entry point '~entryPoint'
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=30
//META: catalog_name=same-stage-specified-more-than-once
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Repeating `-stage` for one entry point is redundant rather than fatal. The
// second identical `-stage compute` makes the driver warn; the CHECK pins the
// duplicate-stage warning code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry main -stage compute -stage compute
[numthreads(1,1,1)]
void main() {}

//CHECK: E00030
