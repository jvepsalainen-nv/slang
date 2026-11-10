//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30025 (invalid-array-size) - array size must be non-negative
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30025
//META: catalog_name=invalid-array-size
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// An array's element count must be non-negative. A literal `-1` extent is
// folded at check time and rejected, which the CHECK pins by code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
void main() { int a[-1]; }

//CHECK: E30025
