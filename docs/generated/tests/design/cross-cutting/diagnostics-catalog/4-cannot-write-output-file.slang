//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E00004 (cannot-write-output-file) - cannot write output file '~path'
//META: intent=negative
//META: pipeline_stage=emit
//META: catalog_code=4
//META: catalog_name=cannot-write-output-file
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The driver reports a distinct code when the requested output path cannot be
// opened for writing. Compiling into a directory that does not exist makes the
// write fail after codegen succeeds, so the CHECK pins the write-side code
// rather than any front-end error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry main -stage compute -o nonexistent-dir-xyz/out.hlsl
[numthreads(1,1,1)]
void main() {}

//CHECK: E00004
