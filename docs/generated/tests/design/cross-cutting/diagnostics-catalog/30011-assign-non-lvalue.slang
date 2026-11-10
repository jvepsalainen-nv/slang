//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30011 (assign-non-lvalue) - left of '=' is not an l-value
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30011
//META: catalog_name=assign-non-lvalue
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Assignment requires an l-value on the left. A literal has no storage, so the
// CHECK pins the not-an-l-value error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
void main() { 1 = 2; }

//CHECK: E30011
