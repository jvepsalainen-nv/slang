//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15613 (pragma-warning-unknown-specifier) - unknown specifier
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15613
//META: catalog_name=pragma-warning-unknown-specifier
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The specifier before the id list in `#pragma warning` comes from a fixed set
// (push/pop/disable/enable/error). A name outside it is diagnosed, which the
// CHECK pins by code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#pragma warning(bogusspecifier: 30081)
void main() {}

//CHECK: E15613
