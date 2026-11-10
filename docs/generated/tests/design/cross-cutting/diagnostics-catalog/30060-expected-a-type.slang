//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30060 (expected-a-type) - expected a type
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30060
//META: catalog_name=expected-a-type
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A declaration's first token must name a type. Using a value-bound identifier
// there makes the checker report that a type was expected, which the CHECK
// pins by code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
void main() { int x = 0; x y; }

//CHECK: E30060
