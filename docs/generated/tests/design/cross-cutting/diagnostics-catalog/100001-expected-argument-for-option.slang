//META: generated=true
//META: doc_ref=source/compiler-core/slang-misc-diagnostic-defs.h
//META: purpose=Fires diagnostic E100001 (expectedArgumentForOption) - expected an argument for command-line option
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=100001
//META: catalog_name=expectedArgumentForOption
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `-profile` requires a following value. Omitting it triggers the
// expected-argument diagnostic.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry main -stage compute -profile

[numthreads(1,1,1)]
void main() {}

//CHECK: 100001
