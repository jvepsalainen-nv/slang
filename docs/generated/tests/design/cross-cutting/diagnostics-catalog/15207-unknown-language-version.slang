//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15207 (unknown-language-version) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15207
//META: catalog_name=unknown-language-version
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E15207.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#version 99999 hlsl
void main() {}

//CHECK: E15207
