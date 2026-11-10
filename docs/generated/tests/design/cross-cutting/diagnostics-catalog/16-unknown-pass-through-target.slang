//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E00016 (unknown-pass-through-target) - unknown pass-through target '~target'
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=16
//META: catalog_name=unknown-pass-through-target
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `-pass-through` names a downstream compiler to hand the source to. An
// unrecognised name is rejected while parsing the command line, which the CHECK
// observes by code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-pass-through bogusdownstream
[numthreads(1,1,1)]
void main() {}

//CHECK: E00016
