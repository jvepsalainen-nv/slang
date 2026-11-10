//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31202 (duplicate-modifier) - duplicate modifier
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=31202
//META: catalog_name=duplicate-modifier
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Repeating a modifier on one declaration is redundant. Writing `static static`
// fires the duplicate-modifier error, which the CHECK pins.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -entry main -stage compute
[numthreads(1,1,1)]
void main() { static static int x = 0; }

//CHECK: E31202
