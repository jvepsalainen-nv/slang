//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E20102 (unexpected-body-after-semicolon) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=20102
//META: catalog_name=unexpected-body-after-semicolon
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E20102.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
void foo(); { }
void main() {}

//CHECK: E20102
