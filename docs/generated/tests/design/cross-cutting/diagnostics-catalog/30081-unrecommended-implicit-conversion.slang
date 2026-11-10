//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30081 (unrecommended-implicit-conversion) - implicit conversion not recommended
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30081
//META: catalog_name=unrecommended-implicit-conversion
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Some implicit conversions are legal but lossy. Initializing an `int` from a
// `float` narrows, so the checker warns rather than errors; the CHECK pins the
// unrecommended-conversion warning code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
void main() { float f = 1.5; int i = f; }

//CHECK: E30081
