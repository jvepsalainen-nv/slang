//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E00080 (duplicate-output-paths-for-entry-point-and-target) - multiple output paths have been specified entry point '~entryPoint:Name' on target '~target'
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=80
//META: catalog_name=duplicate-output-paths-for-entry-point-and-target
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// One entry point on one target has a single kernel output. Supplying two `-o`
// paths after the same `-entry` is ambiguous, and the CHECK pins the
// duplicate-output-path error that rejects it.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry main -stage compute -o a.hlsl -o b.hlsl
[numthreads(1,1,1)]
void main() {}

//CHECK: E00080
