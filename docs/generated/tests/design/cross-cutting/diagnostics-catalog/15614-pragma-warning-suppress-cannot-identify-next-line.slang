//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15614 (pragma-warning-suppress-cannot-identify-next-line) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15614
//META: catalog_name=pragma-warning-suppress-cannot-identify-next-line
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E15614.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
//CHECK: E15614
void main() {}
#pragma warning(suppress: 41024)